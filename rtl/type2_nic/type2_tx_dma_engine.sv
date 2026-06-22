module type2_tx_dma_engine (
    input  logic         clk,
    input  logic         rst_n,
    input  logic         link_up,
    input  logic         nic_enable,
    input  logic [63:0]  desc_base,
    input  logic [15:0]  desc_count,
    input  logic [15:0]  tail_db,
    output logic [15:0]  head_hw,

    output logic         dma_rd_req,
    output logic [63:0]  dma_rd_addr,
    output logic [15:0]  dma_rd_len,
    input  logic         dma_rd_ack,
    input  logic         dma_rd_data_valid,
    input  logic [511:0] dma_rd_data,
    input  logic         dma_rd_last,

    output logic         tx_valid,
    output logic         tx_sop,
    output logic         tx_eop,
    output logic [511:0] tx_data,
    output logic [5:0]   tx_empty,
    output logic         tx_error,
    input  logic         tx_ready,

    output logic [31:0]  debug_status
);

  localparam int TX_DESC_BYTES = 16;

  typedef enum logic [2:0] {
    TX_IDLE,
    TX_DESC_REQ,
    TX_DESC_WAIT,
    TX_PAYLOAD_REQ,
    TX_PAYLOAD_WAIT,
    TX_STREAM
  } tx_state_t;

  tx_state_t state;
  logic [15:0] next_head;
  logic [63:0] desc_line_addr;
  logic [63:0] payload_addr;
  logic [15:0] payload_len;
  logic [15:0] payload_beats_total;
  logic [15:0] payload_beats_sent;
  logic        payload_last_pending;
  logic [511:0] payload_hold;
  logic        payload_hold_valid;
  logic [5:0]  last_empty;
  logic        last_error;

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

  function automatic [5:0] calc_last_empty(input [5:0] byte_mod);
    if (byte_mod == 6'd0)
      calc_last_empty = 6'd0;
    else
      calc_last_empty = 6'd63 - (byte_mod - 6'd1);
  endfunction

  wire [127:0] selected_desc = select_desc(dma_rd_data, head_hw[1:0]);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state              <= TX_IDLE;
      head_hw            <= '0;
      next_head          <= '0;
      dma_rd_req         <= 1'b0;
      dma_rd_addr        <= '0;
      dma_rd_len         <= '0;
      tx_valid           <= 1'b0;
      tx_sop             <= 1'b0;
      tx_eop             <= 1'b0;
      tx_data            <= '0;
      tx_empty           <= '0;
      tx_error           <= 1'b0;
      payload_addr       <= '0;
      payload_len        <= '0;
      payload_beats_total<= '0;
      payload_beats_sent <= '0;
      payload_last_pending <= 1'b0;
      payload_hold       <= '0;
      payload_hold_valid <= 1'b0;
      last_empty         <= '0;
      last_error         <= 1'b0;
      debug_status       <= '0;
    end else begin
      dma_rd_req <= 1'b0;
      tx_valid   <= 1'b0;
      tx_sop     <= 1'b0;
      tx_eop     <= 1'b0;
      tx_error   <= 1'b0;

      unique case (state)
        TX_IDLE: begin
          payload_hold_valid <= 1'b0;
          payload_beats_sent <= '0;
          payload_last_pending <= 1'b0;
          if (nic_enable && link_up && (desc_count != 16'd0) && (head_hw != tail_db)) begin
            desc_line_addr <= desc_base + ({50'd0, head_hw[15:2]} << 6);
            next_head      <= ring_next(head_hw, desc_count);
            state          <= TX_DESC_REQ;
          end
        end

        TX_DESC_REQ: begin
          dma_rd_req  <= 1'b1;
          dma_rd_addr <= desc_line_addr;
          dma_rd_len  <= 16'd1;
          if (dma_rd_ack)
            state <= TX_DESC_WAIT;
        end

        TX_DESC_WAIT: begin
          if (dma_rd_data_valid) begin
            payload_addr        <= selected_desc[63:0];
            payload_len         <= selected_desc[79:64];
            payload_beats_total <= (selected_desc[79:64] + 16'd63) >> 6;
            last_empty          <= calc_last_empty(selected_desc[69:64]);
            last_error          <= !link_up;
            state               <= TX_PAYLOAD_REQ;
          end
        end

        TX_PAYLOAD_REQ: begin
          dma_rd_req  <= 1'b1;
          dma_rd_addr <= payload_addr;
          dma_rd_len  <= payload_beats_total;
          if (dma_rd_ack)
            state <= TX_PAYLOAD_WAIT;
        end

        TX_PAYLOAD_WAIT: begin
          if (dma_rd_data_valid) begin
            payload_hold       <= dma_rd_data;
            payload_hold_valid <= 1'b1;
            payload_last_pending <= dma_rd_last || (payload_beats_total == 16'd1);
            state              <= TX_STREAM;
          end
        end

        TX_STREAM: begin
          if (payload_hold_valid && tx_ready) begin
            tx_valid           <= 1'b1;
            tx_sop             <= (payload_beats_sent == 16'd0);
            tx_eop             <= payload_last_pending;
            tx_data            <= payload_hold;
            tx_empty           <= payload_last_pending ? last_empty : 6'd0;
            tx_error           <= payload_last_pending && last_error;
            payload_hold_valid <= 1'b0;
            payload_beats_sent <= payload_beats_sent + 16'd1;

            if (payload_last_pending) begin
              head_hw <= next_head;
              state   <= TX_IDLE;
            end else begin
              state <= TX_PAYLOAD_WAIT;
            end
          end
        end
      endcase

      debug_status <= {
        5'd0,
        payload_hold_valid,
        payload_last_pending,
        state,
        payload_len[7:0],
        payload_beats_sent[7:0],
        head_hw[7:0]
      };
    end
  end

endmodule
