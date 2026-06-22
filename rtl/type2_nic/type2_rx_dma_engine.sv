module type2_rx_dma_engine (
    input  logic         clk,
    input  logic         rst_n,
    input  logic         link_up,
    input  logic         nic_enable,
    input  logic         irq_enable,
    input  logic [31:0]  irq_ack,
    input  logic [63:0]  fill_base,
    input  logic [15:0]  fill_count,
    input  logic [15:0]  fill_tail_db,
    output logic [15:0]  fill_head_hw,
    input  logic [63:0]  cpl_base,
    input  logic [15:0]  cpl_count,
    output logic [15:0]  cpl_tail_hw,

    output logic         dma_rd_req,
    output logic [63:0]  dma_rd_addr,
    output logic [15:0]  dma_rd_len,
    input  logic         dma_rd_ack,
    input  logic         dma_rd_data_valid,
    input  logic [511:0] dma_rd_data,
    input  logic         dma_rd_last,

    input  logic         rx_valid,
    input  logic         rx_sop,
    input  logic         rx_eop,
    input  logic [511:0] rx_data,
    input  logic [5:0]   rx_empty,
    input  logic         rx_error,
    output logic         rx_ready,

    output logic         dma_wr_req,
    output logic [63:0]  dma_wr_addr,
    output logic [511:0] dma_wr_data,
    output logic [5:0]   dma_wr_beats,
    input  logic         dma_wr_ack,

    output logic [31:0]  irq_status,
    output logic [31:0]  debug_status
);

  typedef enum logic [2:0] {
    RX_IDLE,
    RX_FILL_REQ,
    RX_FILL_WAIT,
    RX_WAIT_BEAT,
    RX_WRITE_PAYLOAD,
    RX_WRITE_CPL
  } rx_state_t;

  rx_state_t state;
  logic [15:0] next_fill_head;
  logic [15:0] next_cpl_tail;
  logic [63:0] fill_desc_addr;
  logic [63:0] payload_addr;
  logic [15:0] payload_len;
  logic        desc_valid;
  logic        packet_active;
  logic [15:0] packet_len_bytes;
  logic [15:0] payload_bytes_written;
  logic [15:0] cpl_status_bits;
  logic [15:0] beat_len_bytes;
  logic        beat_eop;
  logic [511:0] beat_data;
  logic [63:0] beat_addr;
  logic [15:0] rx_status_next;
  logic [15:0] rx_len_next;

  function automatic [15:0] ring_next(input [15:0] idx, input [15:0] count);
    if ((count != 16'd0) && (idx == (count - 16'd1)))
      ring_next = 16'd0;
    else
      ring_next = idx + 16'd1;
  endfunction

  function automatic [127:0] select_desc(input [511:0] line, input [1:0] slot);
    case (slot)
      2'd0: select_desc = line[127:0];
      2'd1: select_desc = line[255:128];
      2'd2: select_desc = line[383:256];
      default: select_desc = line[511:384];
    endcase
  endfunction

  function automatic [15:0] rx_beat_len(input logic eop, input logic [5:0] empty);
    if (eop)
      rx_beat_len = 16'd64 - {10'd0, empty};
    else
      rx_beat_len = 16'd64;
  endfunction

  function automatic [511:0] cpl_line(
      input logic [15:0] pkt_len,
      input logic [15:0] status
  );
    logic [127:0] cpl;
    begin
      cpl = {
        64'd0,
        16'd0,
        16'd0,
        status,
        pkt_len
      };
      cpl_line = 512'd0;
      cpl_line[127:0] = cpl;
    end
  endfunction

  wire [127:0] selected_desc = select_desc(dma_rd_data, fill_head_hw[1:0]);
  assign rx_ready = nic_enable && link_up && desc_valid && (state == RX_WAIT_BEAT);
  assign rx_len_next = rx_beat_len(rx_eop, rx_empty);
  assign rx_status_next =
      ((rx_sop && !packet_active) ? 16'h0001 : cpl_status_bits) |
      (rx_error ? 16'h0002 : 16'h0000) |
      (((payload_len != 16'd0) &&
        ((payload_bytes_written + rx_len_next) > payload_len)) ? 16'h0004 : 16'h0000);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state                 <= RX_IDLE;
      fill_head_hw          <= '0;
      cpl_tail_hw           <= '0;
      dma_rd_req            <= 1'b0;
      dma_rd_addr           <= '0;
      dma_rd_len            <= '0;
      dma_wr_req            <= 1'b0;
      dma_wr_addr           <= '0;
      dma_wr_data           <= '0;
      dma_wr_beats          <= '0;
      irq_status            <= '0;
      debug_status          <= '0;
      next_fill_head        <= '0;
      next_cpl_tail         <= '0;
      fill_desc_addr        <= '0;
      payload_addr          <= '0;
      payload_len           <= '0;
      desc_valid            <= 1'b0;
      packet_active         <= 1'b0;
      packet_len_bytes      <= '0;
      payload_bytes_written <= '0;
      cpl_status_bits       <= '0;
      beat_len_bytes        <= '0;
      beat_eop              <= 1'b0;
      beat_data             <= '0;
      beat_addr             <= '0;
    end else begin
      dma_rd_req <= 1'b0;
      dma_wr_req <= 1'b0;
      irq_status <= irq_status & ~irq_ack;

      if (!nic_enable || !link_up) begin
        state                 <= RX_IDLE;
        desc_valid            <= 1'b0;
        packet_active         <= 1'b0;
        payload_bytes_written <= '0;
        packet_len_bytes      <= '0;
      end else begin
        unique case (state)
          RX_IDLE: begin
            if (!desc_valid &&
                (fill_count != 16'd0) && (cpl_count != 16'd0) &&
                (fill_head_hw != fill_tail_db)) begin
              fill_desc_addr <= fill_base + ({50'd0, fill_head_hw[15:2]} << 6);
              next_fill_head <= ring_next(fill_head_hw, fill_count);
              next_cpl_tail  <= ring_next(cpl_tail_hw, cpl_count);
              state          <= RX_FILL_REQ;
            end else if (desc_valid) begin
              state <= RX_WAIT_BEAT;
            end
          end

          RX_FILL_REQ: begin
            dma_rd_req  <= 1'b1;
            dma_rd_addr <= fill_desc_addr;
            dma_rd_len  <= 16'd1;
            if (dma_rd_ack)
              state <= RX_FILL_WAIT;
          end

          RX_FILL_WAIT: begin
            if (dma_rd_data_valid) begin
              payload_addr          <= selected_desc[63:0];
              payload_len           <= selected_desc[79:64];
              desc_valid            <= 1'b1;
              packet_active         <= 1'b0;
              packet_len_bytes      <= '0;
              payload_bytes_written <= '0;
              cpl_status_bits       <= 16'h0001;
              state                 <= RX_WAIT_BEAT;
            end
          end

          RX_WAIT_BEAT: begin
            if (rx_valid && (packet_active || rx_sop)) begin
              beat_len_bytes <= rx_len_next;
              beat_eop       <= rx_eop;
              beat_data      <= rx_data;
              beat_addr      <= payload_addr + {48'd0, payload_bytes_written};

              if (rx_sop && !packet_active) begin
                packet_len_bytes      <= rx_len_next;
                payload_bytes_written <= '0;
              end else begin
                packet_len_bytes <= packet_len_bytes + rx_len_next;
              end

              cpl_status_bits <= rx_status_next;
              packet_active <= !rx_eop;
              state         <= RX_WRITE_PAYLOAD;
            end
          end

          RX_WRITE_PAYLOAD: begin
            dma_wr_req   <= 1'b1;
            dma_wr_addr  <= beat_addr;
            dma_wr_data  <= beat_data;
            dma_wr_beats <= 6'd1;

            if (dma_wr_ack) begin
              payload_bytes_written <= payload_bytes_written + beat_len_bytes;
              if (beat_eop)
                state <= RX_WRITE_CPL;
              else
                state <= RX_WAIT_BEAT;
            end
          end

          RX_WRITE_CPL: begin
            dma_wr_req   <= 1'b1;
            dma_wr_addr  <= cpl_base + ({48'd0, cpl_tail_hw} << 6);
            dma_wr_data  <= cpl_line(packet_len_bytes, cpl_status_bits);
            dma_wr_beats <= 6'd1;

            if (dma_wr_ack) begin
              fill_head_hw          <= next_fill_head;
              cpl_tail_hw           <= next_cpl_tail;
              desc_valid            <= 1'b0;
              packet_active         <= 1'b0;
              payload_bytes_written <= '0;
              packet_len_bytes      <= '0;
              if (irq_enable)
                irq_status <= (irq_status & ~irq_ack) | 32'h0000_0001;
              state <= RX_IDLE;
            end
          end

          default: state <= RX_IDLE;
        endcase
      end

      debug_status <= {
        desc_valid,
        packet_active,
        rx_ready,
        state,
        payload_len[7:0],
        fill_head_hw[7:0],
        cpl_tail_hw[7:0],
        cpl_status_bits[1:0]
      };
    end
  end

endmodule
