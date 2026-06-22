module type2_nic_top #(
    parameter logic DMA_BACKEND_PRESENT = 1'b0
) (
    input  logic          clk,
    input  logic          rst_n,
    input  logic          link_up,

    input  logic          csr_write,
    input  logic [3:0]    csr_byteenable,
    input  logic [15:0]   csr_addr,
    input  logic [31:0]   csr_wdata,

    output logic          tx_dma_rd_req,
    output logic [63:0]   tx_dma_rd_addr,
    output logic [15:0]   tx_dma_rd_len,
    input  logic          tx_dma_rd_ack,
    input  logic          tx_dma_rd_data_valid,
    input  logic [511:0]  tx_dma_rd_data,
    input  logic          tx_dma_rd_last,

    output logic          rx_dma_rd_req,
    output logic [63:0]   rx_dma_rd_addr,
    output logic [15:0]   rx_dma_rd_len,
    input  logic          rx_dma_rd_ack,
    input  logic          rx_dma_rd_data_valid,
    input  logic [511:0]  rx_dma_rd_data,
    input  logic          rx_dma_rd_last,

    output logic          rx_dma_wr_req,
    output logic [63:0]   rx_dma_wr_addr,
    output logic [511:0]  rx_dma_wr_data,
    output logic [5:0]    rx_dma_wr_beats,
    input  logic          rx_dma_wr_ack,

    output logic          tx_valid,
    output logic          tx_sop,
    output logic          tx_eop,
    output logic [511:0]  tx_data,
    output logic [5:0]    tx_empty,
    output logic          tx_error,
    input  logic          tx_ready,

    input  logic          rx_valid,
    input  logic          rx_sop,
    input  logic          rx_eop,
    input  logic [511:0]  rx_data,
    input  logic [5:0]    rx_empty,
    input  logic          rx_error,

    output logic          tx_path_enable,
    output logic          tx_frame_valid,
    output logic [1023:0] tx_frame_data,
    output logic [15:0]   tx_frame_inframe,
    output logic [47:0]   tx_frame_eop_empty,
    output logic [15:0]   tx_frame_error_mask,
    output logic [15:0]   tx_frame_skip_crc,
    input  logic          tx_frame_ready,

    input  logic          rx_frame_valid,
    input  logic [1023:0] rx_frame_data,
    input  logic [15:0]   rx_frame_inframe,
    input  logic [47:0]   rx_frame_eop_empty,
    input  logic [31:0]   rx_frame_error_mask,
    input  logic [1:0]    rx_frame_meta,
    output logic          rx_frame_ready,

    output logic [31:0]   irq_status,
    output logic [1023:0] csr_window_flat
);

  localparam int DESC_RING_CAPACITY = 8;
  localparam int SLOT_COUNT         = 16;
  localparam int SLOT_WORDS         = 35;
  localparam int DESC_WORDS         = 4;
  localparam int SLOT_CTRL0_IDX     = 32;
  localparam int SLOT_CTRL1_IDX     = 33;
  localparam int SLOT_CTRL2_IDX     = 34;
  localparam int SLOT_INDEX_W       = $clog2(SLOT_COUNT);
  localparam int SLOT_COUNT_W       = $clog2(SLOT_COUNT + 1);

  localparam logic [15:0] REG_MMIO_WR_ADDR     = 16'h0000;
  localparam logic [15:0] REG_MMIO_WR_DATA     = 16'h0004;
  localparam logic [15:0] REG_TX_RING_HEAD     = 16'h0040;
  localparam logic [15:0] REG_TX_RING_CAP      = 16'h0048;
  localparam logic [15:0] REG_TX_RING_INIT     = 16'h004c;
  localparam logic [15:0] REG_TX_SLOT_COUNT    = 16'h0050;
  localparam logic [15:0] REG_TX_SLOT_STRIDE   = 16'h0054;
  localparam logic [15:0] REG_IRQ_ACK          = 16'h0058;
  localparam logic [15:0] REG_TX_PKT_CNT       = 16'h005c;
  localparam logic [15:0] REG_RX_CPL_HEAD      = 16'h0060;
  localparam logic [15:0] REG_RX_CPL_TAIL      = 16'h0064;
  localparam logic [15:0] REG_RX_CPL_CAP       = 16'h0068;
  localparam logic [15:0] REG_RX_CPL_INIT      = 16'h006c;
  localparam logic [15:0] REG_RX_SLOT_COUNT    = 16'h0070;
  localparam logic [15:0] REG_RX_SLOT_STRIDE   = 16'h0074;
  localparam logic [15:0] REG_RX_PKT_CNT       = 16'h0078;
  localparam logic [15:0] REG_MMIO_RD_ADDR     = 16'h007c;

  localparam logic [15:0] TX_DESC_BASE         = 16'h0080;
  localparam logic [15:0] TX_SLOT_BASE         = 16'h0100;
  localparam logic [15:0] RX_CPL_BASE          = TX_SLOT_BASE + (SLOT_COUNT * SLOT_WORDS * 4);
  localparam logic [15:0] RX_SLOT_BASE         = RX_CPL_BASE + (DESC_RING_CAPACITY * DESC_WORDS * 4);
  localparam logic [31:0] RING_INIT_MAGIC      = 32'hCAFECAFE;

  localparam logic [31:0] IRQ_TX_DESC_DONE     = 32'h0000_0001;
  localparam logic [31:0] IRQ_TX_FIFO_STALL    = 32'h0000_0002;
  localparam logic [31:0] IRQ_TX_BAD_DESC      = 32'h0000_0004;
  localparam logic [31:0] IRQ_RX_CPL_DONE      = 32'h0000_0010;
  localparam logic [31:0] IRQ_RX_RING_FULL     = 32'h0000_0020;
  localparam logic [31:0] IRQ_LINK_DOWN        = 32'h0000_0100;

  localparam int RX_META_EOP_BIT = 0;
  localparam int RX_META_SOP_BIT = 1;

  localparam logic [1:0] TXS_IDLE = 2'd0;
  localparam logic [1:0] TXS_SEND = 2'd1;

  logic [63:0] tx_desc_base;
  logic [15:0] tx_desc_count;
  logic [15:0] tx_tail_db;
  logic [15:0] tx_head_hw;
  logic [63:0] rx_fill_base;
  logic [15:0] rx_fill_count;
  logic [15:0] rx_fill_tail_db;
  logic [15:0] rx_fill_head_hw;
  logic [63:0] rx_cpl_base;
  logic [15:0] rx_cpl_count;
  logic [15:0] rx_cpl_tail_hw;
  logic [47:0] mac_addr;
  logic [15:0] mtu;
  logic [1:0]  fec_mode;
  logic        nic_enable;
  logic        irq_enable;
  logic        dma_mode_requested;
  logic        dma_mode_active;

  logic        tx_dma_rd_req_i;
  logic [63:0] tx_dma_rd_addr_i;
  logic [15:0] tx_dma_rd_len_i;
  logic [15:0] tx_dma_head_hw;
  logic        tx_dma_valid_i;
  logic        tx_dma_sop_i;
  logic        tx_dma_eop_i;
  logic [511:0] tx_dma_data_i;
  logic [5:0]  tx_dma_empty_i;
  logic        tx_dma_error_i;
  logic [31:0] tx_dma_debug_status;

  logic        rx_dma_rd_req_i;
  logic [63:0] rx_dma_rd_addr_i;
  logic [15:0] rx_dma_rd_len_i;
  logic        rx_dma_wr_req_i;
  logic [63:0] rx_dma_wr_addr_i;
  logic [511:0] rx_dma_wr_data_i;
  logic [5:0]  rx_dma_wr_beats_i;
  logic [15:0] rx_dma_fill_head_hw;
  logic [15:0] rx_dma_cpl_tail_hw;
  logic        rx_dma_ready_i;
  logic        rx_dma_valid_i;
  logic        rx_dma_sop_i;
  logic        rx_dma_eop_i;
  logic [511:0] rx_dma_data_i;
  logic [5:0]  rx_dma_empty_i;
  logic        rx_dma_error_i;
  logic [31:0] rx_dma_irq_status;
  logic [31:0] rx_dma_debug_status;
  logic [31:0] irq_ack_mask;

  logic [31:0] tx_ring_head_host;
  logic [31:0] tx_ring_tail_dev;
  logic [31:0] tx_ring_initialized;
  logic [31:0] tx_packets_completed;

  logic [31:0] rx_cpl_head_dev;
  logic [31:0] rx_cpl_tail_host;
  logic [31:0] rx_cpl_initialized;
  logic [31:0] rx_packets_completed;
  logic [31:0] rx_packets_dropped;

  logic [31:0] tx_desc_mem [0:DESC_RING_CAPACITY-1][0:DESC_WORDS-1];
  logic [31:0] tx_slot_mem [0:SLOT_COUNT-1][0:SLOT_WORDS-1];
  logic [31:0] rx_cpl_mem  [0:DESC_RING_CAPACITY-1][0:DESC_WORDS-1];
  logic [31:0] rx_slot_mem [0:SLOT_COUNT-1][0:SLOT_WORDS-1];

  logic [1:0]  tx_state;
  logic [7:0]  tx_slot_base_idx;
  logic [7:0]  tx_slot_count;
  logic [7:0]  tx_slot_offset;
  logic [SLOT_INDEX_W-1:0] tx_slot_rd_idx;
  logic [SLOT_INDEX_W-1:0] rx_slot_alloc_ptr;
  logic [31:0] irq_status_reg;
  logic [15:0] mmio_wr_addr;
  logic [31:0] mmio_wr_data_shadow;
  logic        csr_write_full;
  logic        csr_write_full_d;
  logic        csr_write_fire;

  logic tx_desc_region_wr;
  logic [2:0] tx_desc_wr_idx;
  logic [1:0] tx_desc_wr_word;
  logic tx_slot_region_wr;
  logic [SLOT_INDEX_W-1:0] tx_slot_wr_idx;
  logic [5:0] tx_slot_wr_word;
  logic [31:0] tx_slot_word_offset;
  logic rx_cpl_region_wr;
  logic [2:0] rx_cpl_wr_idx;
  logic [1:0] rx_cpl_wr_word;
  logic [15:0] csr_mem_wr_addr;

  logic [15:0] rx_frame_byte_count;
  logic [15:0] rx_frame_eop_mask;
  logic [15:0] rx_frame_eop_empty_mask;
  logic        rx_frame_eop_inactive;
  logic [15:0] rx_frame_fall_mask;
  logic [15:0] rx_frame_sop_mask;
  logic        rx_frame_has_data;
  logic        rx_frame_has_eop;
  logic [15:0] rx_frame_error_summary;
  logic [SLOT_COUNT_W-1:0] rx_current_slot_count;
  logic [15:0] rx_current_byte_count;
  logic        rx_packet_active;
  logic [SLOT_INDEX_W-1:0] rx_packet_start_slot;
  logic [SLOT_COUNT_W-1:0] rx_packet_slot_count;
  logic [15:0] rx_packet_byte_count;
  logic [15:0] rx_prev_inframe;
  logic [2:0]  rx_eop_empty_selected;
  logic        rx_packet_complete;
  logic        rx_cpl_ring_full;
  logic [SLOT_INDEX_W-1:0] rx_slot_write_idx;
  logic [7:0]  rx_packet_slot_count_encoded;
  logic [7:0]  rx_packet_start_slot_encoded;
  logic [15:0] mmio_rd_addr;
  logic [31:0] mmio_rd_data;

  logic        dma_rx_frame_pending;
  logic        dma_rx_frame_upper_sel;
  logic [1023:0] dma_rx_frame_data_hold;
  logic [15:0] dma_rx_frame_inframe_hold;
  logic [47:0] dma_rx_frame_eop_empty_hold;
  logic [31:0] dma_rx_frame_error_hold;
  logic [1:0]  dma_rx_frame_meta_hold;
  logic [15:0] dma_rx_prev_inframe;
  logic        dma_rx_frame_prev_inframe_msb_hold;
  logic [15:0] dma_rx_frame_eop_empty_mask_hold;
  logic [15:0] dma_rx_frame_fall_mask_hold;
  logic [15:0] dma_rx_frame_eop_mask_hold;
  logic        dma_rx_lower_has_data;
  logic        dma_rx_upper_has_data;
  logic        dma_rx_current_has_data;
  logic        dma_rx_current_eop;
  logic        dma_rx_current_sop;
  logic        dma_rx_current_error;
  logic [5:0]  dma_rx_current_empty;
  logic        dma_rx_feed_fire;

  function automatic [5:0] count_ones16(input logic [15:0] value);
    integer idx;
    begin
      count_ones16 = 6'd0;
      for (idx = 0; idx < 16; idx = idx + 1)
        count_ones16 = count_ones16 + {5'd0, value[idx]};
    end
  endfunction

  function automatic [3:0] count_ones8(input logic [7:0] value);
    integer idx;
    begin
      count_ones8 = 4'd0;
      for (idx = 0; idx < 8; idx = idx + 1)
        count_ones8 = count_ones8 + {3'd0, value[idx]};
    end
  endfunction

  function automatic [2:0] select_eop_empty8(
      input logic [7:0] eop_mask,
      input logic [23:0] eop_empty_vec
  );
    integer idx;
    begin
      select_eop_empty8 = 3'd0;
      for (idx = 0; idx < 8; idx = idx + 1) begin
        if (eop_mask[idx])
          select_eop_empty8 = eop_empty_vec[(idx * 3) +: 3];
      end
    end
  endfunction

  function automatic [7:0] eop_empty_segment_mask8(input logic [23:0] eop_empty_vec);
    integer idx;
    begin
      eop_empty_segment_mask8 = 8'd0;
      for (idx = 0; idx < 8; idx = idx + 1) begin
        if (eop_empty_vec[(idx * 3) +: 3] != 3'd0)
          eop_empty_segment_mask8[idx] = 1'b1;
      end
    end
  endfunction

  function automatic [5:0] frame_half_empty(
      input logic        eop,
      input logic [7:0]  inframe,
      input logic [23:0] eop_empty_vec
  );
    logic [7:0] eop_mask;
    logic [2:0] eop_empty;
    logic [6:0] byte_count;
    logic [6:0] empty_count;
    begin
      if (!eop) begin
        frame_half_empty = 6'd0;
      end else begin
        eop_mask = eop_empty_segment_mask8(eop_empty_vec);
        eop_empty = select_eop_empty8(eop_mask, eop_empty_vec);
        byte_count = ({3'd0, count_ones8(inframe)} << 3) +
                     7'd8 - {4'd0, eop_empty};
        if (byte_count > 7'd64)
          byte_count = 7'd64;
        empty_count = 7'd64 - byte_count;
        frame_half_empty = (byte_count >= 7'd64) ? 6'd0 : empty_count[5:0];
      end
    end
  endfunction

  function automatic [7:0] tx_dma_inframe_mask(input logic eop, input logic [5:0] empty);
    logic [6:0] byte_count;
    logic [6:0] last_byte_idx;
    logic [3:0] eop_segment;
    begin
      if (!eop) begin
        tx_dma_inframe_mask = 8'hff;
      end else begin
        byte_count = 7'd64 - {1'b0, empty};
        last_byte_idx = (byte_count == 7'd0) ? 7'd0 : (byte_count - 7'd1);
        eop_segment = last_byte_idx[6:3];
        tx_dma_inframe_mask = (eop_segment == 4'd0) ?
            8'd0 :
            ((8'h01 << eop_segment) - 8'h01);
      end
    end
  endfunction

  function automatic [23:0] tx_dma_eop_empty_vec(input logic eop, input logic [5:0] empty);
    logic [6:0] byte_count;
    logic [6:0] last_byte_idx;
    logic [3:0] eop_segment;
    logic [2:0] seg_empty;
    begin
      tx_dma_eop_empty_vec = 24'd0;
      if (eop) begin
        byte_count = 7'd64 - {1'b0, empty};
        last_byte_idx = (byte_count == 7'd0) ? 7'd0 : (byte_count - 7'd1);
        eop_segment = last_byte_idx[6:3];
        seg_empty = empty[2:0];
        tx_dma_eop_empty_vec[(eop_segment * 3) +: 3] = seg_empty;
      end
    end
  endfunction

  function automatic [2:0] select_eop_empty(
      input logic [15:0] eop_mask,
      input logic [47:0] eop_empty_vec
  );
    integer idx;
    begin
      select_eop_empty = 3'd0;
      for (idx = 0; idx < 16; idx = idx + 1) begin
        if (eop_mask[idx])
          select_eop_empty = eop_empty_vec[(idx * 3) +: 3];
      end
    end
  endfunction

  function automatic [15:0] eop_empty_segment_mask(input logic [47:0] eop_empty_vec);
    integer idx;
    begin
      eop_empty_segment_mask = 16'd0;
      for (idx = 0; idx < 16; idx = idx + 1) begin
        if (eop_empty_vec[(idx * 3) +: 3] != 3'd0)
          eop_empty_segment_mask[idx] = 1'b1;
      end
    end
  endfunction

  assign rx_frame_has_eop = rx_frame_meta[RX_META_EOP_BIT] || (rx_frame_eop_empty_mask != 16'd0);
  assign rx_frame_sop_mask = rx_frame_inframe & ~{rx_frame_inframe[14:0], rx_prev_inframe[15]};
  assign rx_frame_eop_empty_mask = eop_empty_segment_mask(rx_frame_eop_empty);
  assign rx_frame_fall_mask = (~rx_frame_inframe) & {rx_frame_inframe[14:0], rx_prev_inframe[15]};
  assign rx_frame_eop_mask = (rx_frame_eop_empty_mask != 16'd0) ?
      rx_frame_eop_empty_mask :
      (rx_frame_has_eop ? rx_frame_fall_mask : 16'd0);
  assign rx_eop_empty_selected = select_eop_empty(rx_frame_eop_mask, rx_frame_eop_empty);
  assign rx_frame_eop_inactive = |(rx_frame_eop_empty_mask & ~rx_frame_inframe);
  assign rx_frame_has_data = (|rx_frame_inframe) || (rx_frame_eop_empty_mask != 16'd0);
  assign rx_frame_byte_count = ({10'd0, count_ones16(rx_frame_inframe)} << 3) -
      ((rx_frame_eop_empty_mask != 16'd0) ? {13'd0, rx_eop_empty_selected} : 16'd0) +
      ((rx_frame_eop_inactive && (rx_frame_eop_empty_mask != 16'd0)) ? 16'd8 : 16'd0);
  assign rx_packet_complete = rx_frame_has_eop;
  assign rx_frame_error_summary = rx_frame_error_mask[15:0] | rx_frame_error_mask[31:16];
  assign rx_cpl_ring_full = ((rx_cpl_head_dev - rx_cpl_tail_host) >= DESC_RING_CAPACITY);
  assign rx_current_slot_count = rx_packet_active ? rx_packet_slot_count : '0;
  assign rx_current_byte_count = rx_packet_active ? rx_packet_byte_count : 16'd0;
  assign rx_slot_write_idx = rx_packet_active ?
      (rx_packet_start_slot + rx_current_slot_count[SLOT_INDEX_W-1:0]) :
      rx_slot_alloc_ptr;
  assign rx_packet_slot_count_encoded = rx_current_slot_count + 1'b1;
  assign rx_packet_start_slot_encoded = rx_packet_active ? rx_packet_start_slot : rx_slot_alloc_ptr;
  assign csr_mem_wr_addr = (csr_addr == REG_MMIO_WR_DATA) ? mmio_wr_addr : csr_addr;
  assign csr_write_full = csr_write && (csr_byteenable == 4'hf);
  assign csr_write_fire = csr_write_full && !csr_write_full_d;
  assign tx_slot_rd_idx = tx_slot_base_idx[SLOT_INDEX_W-1:0] +
                          tx_slot_offset[SLOT_INDEX_W-1:0];
  assign irq_ack_mask = (csr_write_fire && (csr_addr == REG_IRQ_ACK)) ? csr_wdata : 32'd0;

  assign dma_rx_frame_eop_empty_mask_hold = eop_empty_segment_mask(dma_rx_frame_eop_empty_hold);
  assign dma_rx_frame_fall_mask_hold =
      (~dma_rx_frame_inframe_hold) &
      {dma_rx_frame_inframe_hold[14:0], dma_rx_frame_prev_inframe_msb_hold};
  assign dma_rx_frame_eop_mask_hold = (dma_rx_frame_eop_empty_mask_hold != 16'd0) ?
      dma_rx_frame_eop_empty_mask_hold :
      (dma_rx_frame_meta_hold[RX_META_EOP_BIT] ? dma_rx_frame_fall_mask_hold : 16'd0);
  assign dma_rx_lower_has_data = (|dma_rx_frame_inframe_hold[7:0]) ||
                                 (|dma_rx_frame_eop_empty_hold[23:0]) ||
                                 (|dma_rx_frame_eop_mask_hold[7:0]);
  assign dma_rx_upper_has_data = (|dma_rx_frame_inframe_hold[15:8]) ||
                                 (|dma_rx_frame_eop_empty_hold[47:24]) ||
                                 (|dma_rx_frame_eop_mask_hold[15:8]);
  assign dma_rx_current_has_data = dma_rx_frame_upper_sel ?
      dma_rx_upper_has_data : dma_rx_lower_has_data;
  assign dma_rx_current_eop = dma_rx_frame_upper_sel ?
      (|dma_rx_frame_eop_mask_hold[15:8]) :
      (|dma_rx_frame_eop_mask_hold[7:0]);
  assign dma_rx_current_sop = dma_rx_frame_meta_hold[RX_META_SOP_BIT] &&
                              (!dma_rx_frame_upper_sel || !dma_rx_lower_has_data);
  assign dma_rx_current_error = dma_rx_frame_upper_sel ?
      (|dma_rx_frame_error_hold[31:16]) : (|dma_rx_frame_error_hold[15:0]);
  assign dma_rx_current_empty = dma_rx_frame_upper_sel ?
      frame_half_empty(dma_rx_current_eop,
                       dma_rx_frame_inframe_hold[15:8],
                       dma_rx_frame_eop_empty_hold[47:24]) :
      frame_half_empty(dma_rx_current_eop,
                       dma_rx_frame_inframe_hold[7:0],
                       dma_rx_frame_eop_empty_hold[23:0]);
  assign dma_mode_active = dma_mode_requested && DMA_BACKEND_PRESENT;

  assign dma_rx_feed_fire = dma_mode_active && dma_rx_frame_pending &&
                            dma_rx_current_has_data && rx_dma_ready_i;

  assign rx_dma_valid_i = dma_rx_feed_fire;
  assign rx_dma_sop_i   = dma_rx_current_sop;
  assign rx_dma_eop_i   = dma_rx_current_eop;
  assign rx_dma_data_i  = dma_rx_frame_upper_sel ?
      dma_rx_frame_data_hold[1023:512] : dma_rx_frame_data_hold[511:0];
  assign rx_dma_empty_i = dma_rx_current_empty;
  assign rx_dma_error_i = dma_rx_current_error;

  type2_nic_queue_regs regs (
      .clk(clk),
      .rst_n(rst_n),
      .csr_write(csr_write_fire),
      .csr_addr(csr_addr),
      .csr_wdata(csr_wdata),
      .tx_desc_base(tx_desc_base),
      .tx_desc_count(tx_desc_count),
      .tx_tail_db(tx_tail_db),
      .rx_fill_base(rx_fill_base),
      .rx_fill_count(rx_fill_count),
      .rx_fill_tail_db(rx_fill_tail_db),
      .rx_cpl_base(rx_cpl_base),
      .rx_cpl_count(rx_cpl_count),
      .mac_addr(mac_addr),
      .mtu(mtu),
      .fec_mode(fec_mode),
      .nic_enable(nic_enable),
      .irq_enable(irq_enable),
      .dma_mode_enable(dma_mode_requested),
      .tx_head_hw(tx_head_hw),
      .rx_fill_head_hw(rx_fill_head_hw),
      .rx_cpl_tail_hw(rx_cpl_tail_hw),
      .irq_status_hw(irq_status_reg)
  );

  type2_tx_dma_engine tx_dma_engine (
      .clk(clk),
      .rst_n(rst_n),
      .link_up(link_up),
      .nic_enable(nic_enable && dma_mode_active),
      .desc_base(tx_desc_base),
      .desc_count(tx_desc_count),
      .tail_db(tx_tail_db),
      .head_hw(tx_dma_head_hw),
      .dma_rd_req(tx_dma_rd_req_i),
      .dma_rd_addr(tx_dma_rd_addr_i),
      .dma_rd_len(tx_dma_rd_len_i),
      .dma_rd_ack(tx_dma_rd_ack),
      .dma_rd_data_valid(tx_dma_rd_data_valid),
      .dma_rd_data(tx_dma_rd_data),
      .dma_rd_last(tx_dma_rd_last),
      .tx_valid(tx_dma_valid_i),
      .tx_sop(tx_dma_sop_i),
      .tx_eop(tx_dma_eop_i),
      .tx_data(tx_dma_data_i),
      .tx_empty(tx_dma_empty_i),
      .tx_error(tx_dma_error_i),
      .tx_ready(tx_frame_ready && dma_mode_active),
      .debug_status(tx_dma_debug_status)
  );

  type2_rx_dma_engine rx_dma_engine (
      .clk(clk),
      .rst_n(rst_n),
      .link_up(link_up),
      .nic_enable(nic_enable && dma_mode_active),
      .irq_enable(irq_enable),
      .irq_ack(irq_ack_mask),
      .fill_base(rx_fill_base),
      .fill_count(rx_fill_count),
      .fill_tail_db(rx_fill_tail_db),
      .fill_head_hw(rx_dma_fill_head_hw),
      .cpl_base(rx_cpl_base),
      .cpl_count(rx_cpl_count),
      .cpl_tail_hw(rx_dma_cpl_tail_hw),
      .dma_rd_req(rx_dma_rd_req_i),
      .dma_rd_addr(rx_dma_rd_addr_i),
      .dma_rd_len(rx_dma_rd_len_i),
      .dma_rd_ack(rx_dma_rd_ack),
      .dma_rd_data_valid(rx_dma_rd_data_valid),
      .dma_rd_data(rx_dma_rd_data),
      .dma_rd_last(rx_dma_rd_last),
      .rx_valid(rx_dma_valid_i),
      .rx_sop(rx_dma_sop_i),
      .rx_eop(rx_dma_eop_i),
      .rx_data(rx_dma_data_i),
      .rx_empty(rx_dma_empty_i),
      .rx_error(rx_dma_error_i),
      .rx_ready(rx_dma_ready_i),
      .dma_wr_req(rx_dma_wr_req_i),
      .dma_wr_addr(rx_dma_wr_addr_i),
      .dma_wr_data(rx_dma_wr_data_i),
      .dma_wr_beats(rx_dma_wr_beats_i),
      .dma_wr_ack(rx_dma_wr_ack),
      .irq_status(rx_dma_irq_status),
      .debug_status(rx_dma_debug_status)
  );

  always_comb begin
    int desc_idx;
    int slot_idx;

    tx_desc_region_wr = 1'b0;
    tx_desc_wr_idx    = '0;
    tx_desc_wr_word   = '0;
    tx_slot_region_wr = 1'b0;
    tx_slot_wr_idx    = '0;
    tx_slot_wr_word   = '0;
    tx_slot_word_offset = '0;
    rx_cpl_region_wr  = 1'b0;
    rx_cpl_wr_idx     = '0;
    rx_cpl_wr_word    = '0;

    if (csr_write_fire) begin
      for (desc_idx = 0; desc_idx < DESC_RING_CAPACITY; desc_idx = desc_idx + 1) begin
        if ((csr_mem_wr_addr >= (TX_DESC_BASE + (desc_idx * 16))) &&
            (csr_mem_wr_addr <  (TX_DESC_BASE + (desc_idx * 16) + 16))) begin
          tx_desc_region_wr = 1'b1;
          tx_desc_wr_idx    = desc_idx[2:0];
          tx_desc_wr_word   = csr_mem_wr_addr[3:2];
        end

        if ((csr_mem_wr_addr >= (RX_CPL_BASE + (desc_idx * 16))) &&
            (csr_mem_wr_addr <  (RX_CPL_BASE + (desc_idx * 16) + 16))) begin
          rx_cpl_region_wr = 1'b1;
          rx_cpl_wr_idx    = desc_idx[2:0];
          rx_cpl_wr_word   = csr_mem_wr_addr[3:2];
        end
      end

      for (slot_idx = 0; slot_idx < SLOT_COUNT; slot_idx = slot_idx + 1) begin
        if ((csr_mem_wr_addr >= (TX_SLOT_BASE + (slot_idx * SLOT_WORDS * 4))) &&
            (csr_mem_wr_addr <  (TX_SLOT_BASE + ((slot_idx + 1) * SLOT_WORDS * 4)))) begin
          tx_slot_region_wr = 1'b1;
          tx_slot_wr_idx    = slot_idx[SLOT_INDEX_W-1:0];
          tx_slot_word_offset = (csr_mem_wr_addr - (TX_SLOT_BASE + (slot_idx * SLOT_WORDS * 4))) >> 2;
          tx_slot_wr_word   = tx_slot_word_offset[5:0];
        end
      end
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      tx_ring_head_host   <= '0;
      tx_ring_tail_dev    <= '0;
      tx_ring_initialized <= '0;
      tx_packets_completed<= '0;
      rx_cpl_head_dev     <= '0;
      rx_cpl_tail_host    <= '0;
      rx_cpl_initialized  <= '0;
      rx_packets_completed<= '0;
      rx_packets_dropped  <= '0;
      mmio_wr_addr        <= '0;
      mmio_wr_data_shadow <= '0;
      mmio_rd_addr        <= '0;
      csr_write_full_d    <= 1'b0;
      rx_packet_active    <= 1'b0;
      rx_packet_start_slot<= '0;
      rx_packet_slot_count<= '0;
      rx_packet_byte_count<= '0;
      rx_prev_inframe     <= '0;
      tx_state            <= TXS_IDLE;
      tx_slot_base_idx    <= '0;
      tx_slot_count       <= '0;
      tx_slot_offset      <= '0;
      rx_slot_alloc_ptr   <= '0;
      irq_status_reg      <= '0;
      tx_frame_valid      <= 1'b0;
      tx_frame_data       <= '0;
      tx_frame_inframe    <= '0;
      tx_frame_eop_empty  <= '0;
      tx_frame_error_mask <= '0;
      tx_frame_skip_crc   <= '0;
      dma_rx_frame_pending <= 1'b0;
      dma_rx_frame_upper_sel <= 1'b0;
      dma_rx_frame_data_hold <= '0;
      dma_rx_frame_inframe_hold <= '0;
      dma_rx_frame_eop_empty_hold <= '0;
      dma_rx_frame_error_hold <= '0;
      dma_rx_frame_meta_hold <= '0;
      dma_rx_prev_inframe <= '0;
      dma_rx_frame_prev_inframe_msb_hold <= 1'b0;

      for (int desc_idx = 0; desc_idx < DESC_RING_CAPACITY; desc_idx = desc_idx + 1) begin
        for (int word_idx = 0; word_idx < DESC_WORDS; word_idx = word_idx + 1) begin
          tx_desc_mem[desc_idx][word_idx] <= '0;
          rx_cpl_mem[desc_idx][word_idx]  <= '0;
        end
      end

      for (int slot_idx = 0; slot_idx < SLOT_COUNT; slot_idx = slot_idx + 1) begin
        for (int word_idx = 0; word_idx < SLOT_WORDS; word_idx = word_idx + 1) begin
          tx_slot_mem[slot_idx][word_idx] <= '0;
          rx_slot_mem[slot_idx][word_idx] <= '0;
        end
      end
    end else begin
      csr_write_full_d <= csr_write_full;
      tx_frame_valid <= 1'b0;

      if (!dma_mode_active) begin
        dma_rx_frame_pending   <= 1'b0;
        dma_rx_frame_upper_sel <= 1'b0;
        dma_rx_prev_inframe    <= '0;
        dma_rx_frame_prev_inframe_msb_hold <= 1'b0;
      end else begin
        if (!dma_rx_frame_pending && rx_frame_valid) begin
          dma_rx_frame_pending        <= 1'b1;
          dma_rx_frame_upper_sel      <= 1'b0;
          dma_rx_frame_data_hold      <= rx_frame_data;
          dma_rx_frame_inframe_hold   <= rx_frame_inframe;
          dma_rx_frame_eop_empty_hold <= rx_frame_eop_empty;
          dma_rx_frame_error_hold     <= rx_frame_error_mask;
          dma_rx_frame_meta_hold      <= rx_frame_meta;
          dma_rx_frame_prev_inframe_msb_hold <= dma_rx_prev_inframe[15];
          dma_rx_prev_inframe         <= rx_frame_inframe;
        end

        if (dma_rx_frame_pending) begin
          if (!dma_rx_current_has_data) begin
            if (!dma_rx_frame_upper_sel && dma_rx_upper_has_data)
              dma_rx_frame_upper_sel <= 1'b1;
            else
              dma_rx_frame_pending <= 1'b0;
          end else if (dma_rx_feed_fire) begin
            if (!dma_rx_frame_upper_sel && dma_rx_upper_has_data)
              dma_rx_frame_upper_sel <= 1'b1;
            else
              dma_rx_frame_pending <= 1'b0;
          end
        end
      end

      if (dma_mode_active) begin
        tx_frame_valid      <= tx_dma_valid_i;
        tx_frame_data       <= {512'd0, tx_dma_data_i};
        tx_frame_inframe    <= {8'd0, tx_dma_inframe_mask(tx_dma_eop_i, tx_dma_empty_i)};
        tx_frame_eop_empty  <= {24'd0, tx_dma_eop_empty_vec(tx_dma_eop_i, tx_dma_empty_i)};
        tx_frame_error_mask <= {8'd0, {8{tx_dma_error_i && tx_dma_eop_i}}};
        tx_frame_skip_crc   <= 16'd0;
        tx_state            <= TXS_IDLE;
      end

      if (csr_write_fire) begin
        unique case (csr_addr)
          REG_MMIO_WR_ADDR: mmio_wr_addr        <= csr_wdata[15:0];
          REG_MMIO_WR_DATA: begin
            mmio_wr_data_shadow <= csr_wdata;
          end
          REG_TX_RING_HEAD: tx_ring_head_host   <= csr_wdata;
          REG_TX_RING_INIT: tx_ring_initialized <= csr_wdata;
          REG_RX_CPL_TAIL:  rx_cpl_tail_host    <= csr_wdata;
          REG_RX_CPL_INIT:  rx_cpl_initialized  <= csr_wdata;
          REG_MMIO_RD_ADDR: mmio_rd_addr        <= csr_wdata[15:0];
          REG_IRQ_ACK:      irq_status_reg      <= irq_status_reg & ~csr_wdata;
          default: ;
        endcase

        if (tx_desc_region_wr)
          tx_desc_mem[tx_desc_wr_idx][tx_desc_wr_word] <= csr_wdata;

        if (tx_slot_region_wr)
          tx_slot_mem[tx_slot_wr_idx][tx_slot_wr_word] <= csr_wdata;

        if (rx_cpl_region_wr)
          rx_cpl_mem[rx_cpl_wr_idx][rx_cpl_wr_word] <= csr_wdata;
      end

      if (!link_up)
        irq_status_reg <= irq_status_reg | IRQ_LINK_DOWN;

      if (!dma_mode_active) begin
        unique case (tx_state)
          TXS_IDLE: begin
            if (nic_enable &&
                link_up &&
                (tx_ring_initialized == RING_INIT_MAGIC) &&
                (tx_ring_head_host != tx_ring_tail_dev)) begin
              tx_slot_base_idx <= tx_desc_mem[tx_ring_tail_dev[2:0]][0][7:0];
              tx_slot_count    <= tx_desc_mem[tx_ring_tail_dev[2:0]][1][7:0];
              tx_slot_offset   <= '0;

              if ((tx_desc_mem[tx_ring_tail_dev[2:0]][1][7:0] == 0) ||
                  ((tx_desc_mem[tx_ring_tail_dev[2:0]][0][7:0] +
                    tx_desc_mem[tx_ring_tail_dev[2:0]][1][7:0]) > SLOT_COUNT)) begin
                irq_status_reg <= irq_status_reg | IRQ_TX_BAD_DESC;
                tx_ring_tail_dev <= tx_ring_tail_dev + 1'b1;
              end else begin
                tx_state <= TXS_SEND;
              end
            end
          end

          TXS_SEND: begin
            if (tx_frame_ready) begin
              tx_frame_valid <= 1'b1;
              tx_frame_data  <= {
                tx_slot_mem[tx_slot_rd_idx][31],
                tx_slot_mem[tx_slot_rd_idx][30],
                tx_slot_mem[tx_slot_rd_idx][29],
                tx_slot_mem[tx_slot_rd_idx][28],
                tx_slot_mem[tx_slot_rd_idx][27],
                tx_slot_mem[tx_slot_rd_idx][26],
                tx_slot_mem[tx_slot_rd_idx][25],
                tx_slot_mem[tx_slot_rd_idx][24],
                tx_slot_mem[tx_slot_rd_idx][23],
                tx_slot_mem[tx_slot_rd_idx][22],
                tx_slot_mem[tx_slot_rd_idx][21],
                tx_slot_mem[tx_slot_rd_idx][20],
                tx_slot_mem[tx_slot_rd_idx][19],
                tx_slot_mem[tx_slot_rd_idx][18],
                tx_slot_mem[tx_slot_rd_idx][17],
                tx_slot_mem[tx_slot_rd_idx][16],
                tx_slot_mem[tx_slot_rd_idx][15],
                tx_slot_mem[tx_slot_rd_idx][14],
                tx_slot_mem[tx_slot_rd_idx][13],
                tx_slot_mem[tx_slot_rd_idx][12],
                tx_slot_mem[tx_slot_rd_idx][11],
                tx_slot_mem[tx_slot_rd_idx][10],
                tx_slot_mem[tx_slot_rd_idx][9],
                tx_slot_mem[tx_slot_rd_idx][8],
                tx_slot_mem[tx_slot_rd_idx][7],
                tx_slot_mem[tx_slot_rd_idx][6],
                tx_slot_mem[tx_slot_rd_idx][5],
                tx_slot_mem[tx_slot_rd_idx][4],
                tx_slot_mem[tx_slot_rd_idx][3],
                tx_slot_mem[tx_slot_rd_idx][2],
                tx_slot_mem[tx_slot_rd_idx][1],
                tx_slot_mem[tx_slot_rd_idx][0]
              };
              tx_frame_inframe    <= tx_slot_mem[tx_slot_rd_idx][SLOT_CTRL0_IDX][15:0];
              tx_frame_error_mask <= tx_slot_mem[tx_slot_rd_idx][SLOT_CTRL0_IDX][31:16];
              tx_frame_eop_empty  <= {
                tx_slot_mem[tx_slot_rd_idx][SLOT_CTRL2_IDX][15:0],
                tx_slot_mem[tx_slot_rd_idx][SLOT_CTRL1_IDX]
              };
              tx_frame_skip_crc   <= tx_slot_mem[tx_slot_rd_idx][SLOT_CTRL2_IDX][31:16];

              if (tx_slot_offset + 1'b1 == tx_slot_count) begin
                tx_ring_tail_dev     <= tx_ring_tail_dev + 1'b1;
                tx_packets_completed <= tx_packets_completed + 1'b1;
                irq_status_reg       <= irq_status_reg | IRQ_TX_DESC_DONE;
                tx_state             <= TXS_IDLE;
              end else begin
                tx_slot_offset <= tx_slot_offset + 1'b1;
              end
            end else begin
              irq_status_reg <= irq_status_reg | IRQ_TX_FIFO_STALL;
            end
          end

          default: tx_state <= TXS_IDLE;
        endcase
      end

      if (!dma_mode_active && nic_enable && link_up &&
          (rx_cpl_initialized == RING_INIT_MAGIC) && rx_frame_valid) begin
        rx_prev_inframe <= rx_frame_inframe;

        if (rx_frame_has_data && (rx_current_slot_count < SLOT_COUNT)) begin
          for (int word_idx = 0; word_idx < 32; word_idx = word_idx + 1)
            rx_slot_mem[rx_slot_write_idx][word_idx] <= rx_frame_data[(word_idx*32) +: 32];

          rx_slot_mem[rx_slot_write_idx][SLOT_CTRL0_IDX] <= {rx_frame_error_summary, rx_frame_inframe};
          rx_slot_mem[rx_slot_write_idx][SLOT_CTRL1_IDX] <= rx_frame_eop_empty[31:0];
          rx_slot_mem[rx_slot_write_idx][SLOT_CTRL2_IDX] <= {16'd0, rx_frame_eop_empty[47:32]};

          if (rx_packet_complete) begin
            if (rx_cpl_ring_full) begin
              rx_packets_dropped <= rx_packets_dropped + 1'b1;
              irq_status_reg     <= irq_status_reg | IRQ_RX_RING_FULL;
              rx_packet_active   <= 1'b0;
              rx_packet_slot_count <= '0;
              rx_packet_byte_count <= '0;
            end else begin
              rx_cpl_mem[rx_cpl_head_dev[2:0]][0] <= {16'd0, rx_packet_slot_count_encoded, rx_packet_start_slot_encoded};
              rx_cpl_mem[rx_cpl_head_dev[2:0]][1] <= {rx_frame_error_summary, (rx_current_byte_count + rx_frame_byte_count)};
              rx_cpl_mem[rx_cpl_head_dev[2:0]][2] <= {rx_frame_eop_empty[15:0], rx_frame_inframe};
              rx_cpl_mem[rx_cpl_head_dev[2:0]][3] <= rx_frame_error_mask;

              rx_cpl_head_dev      <= rx_cpl_head_dev + 1'b1;
              rx_slot_alloc_ptr    <= rx_slot_write_idx + 1'b1;
              rx_packets_completed <= rx_packets_completed + 1'b1;
              irq_status_reg       <= irq_status_reg | IRQ_RX_CPL_DONE;
              rx_packet_active     <= 1'b0;
              rx_packet_slot_count <= '0;
              rx_packet_byte_count <= '0;
            end
          end else begin
            rx_packet_active     <= 1'b1;
            rx_packet_start_slot <= rx_packet_start_slot_encoded;
            rx_packet_slot_count <= rx_packet_slot_count_encoded;
            rx_packet_byte_count <= rx_current_byte_count + rx_frame_byte_count;
          end
        end else if (rx_packet_complete && rx_packet_active) begin
          if (rx_cpl_ring_full) begin
            rx_packets_dropped <= rx_packets_dropped + 1'b1;
            irq_status_reg     <= irq_status_reg | IRQ_RX_RING_FULL;
            rx_packet_active   <= 1'b0;
            rx_packet_slot_count <= '0;
            rx_packet_byte_count <= '0;
          end else begin
            rx_cpl_mem[rx_cpl_head_dev[2:0]][0] <= {16'd0, {3'd0, rx_packet_slot_count}, {4'd0, rx_packet_start_slot}};
            rx_cpl_mem[rx_cpl_head_dev[2:0]][1] <= {rx_frame_error_summary, rx_packet_byte_count};
            rx_cpl_mem[rx_cpl_head_dev[2:0]][2] <= {rx_frame_eop_empty[15:0], rx_frame_inframe};
            rx_cpl_mem[rx_cpl_head_dev[2:0]][3] <= rx_frame_error_mask;

            rx_cpl_head_dev      <= rx_cpl_head_dev + 1'b1;
            rx_slot_alloc_ptr    <= rx_packet_start_slot + rx_packet_slot_count[SLOT_INDEX_W-1:0];
            rx_packets_completed <= rx_packets_completed + 1'b1;
            irq_status_reg       <= irq_status_reg | IRQ_RX_CPL_DONE;
            rx_packet_active     <= 1'b0;
            rx_packet_slot_count <= '0;
            rx_packet_byte_count <= '0;
          end
        end else if (rx_frame_has_data) begin
          rx_packets_dropped <= rx_packets_dropped + 1'b1;
          irq_status_reg     <= irq_status_reg | IRQ_RX_RING_FULL;
          rx_packet_active   <= 1'b0;
          rx_packet_slot_count <= '0;
          rx_packet_byte_count <= '0;
          rx_slot_alloc_ptr  <= rx_slot_write_idx;
        end
      end
    end
  end

  always_comb begin
    tx_dma_rd_req   = dma_mode_active ? tx_dma_rd_req_i : 1'b0;
    tx_dma_rd_addr  = dma_mode_active ? tx_dma_rd_addr_i : 64'd0;
    tx_dma_rd_len   = dma_mode_active ? tx_dma_rd_len_i : 16'd0;
    rx_dma_rd_req   = dma_mode_active ? rx_dma_rd_req_i : 1'b0;
    rx_dma_rd_addr  = dma_mode_active ? rx_dma_rd_addr_i : 64'd0;
    rx_dma_rd_len   = dma_mode_active ? rx_dma_rd_len_i : 16'd0;
    rx_dma_wr_req   = dma_mode_active ? rx_dma_wr_req_i : 1'b0;
    rx_dma_wr_addr  = dma_mode_active ? rx_dma_wr_addr_i : 64'd0;
    rx_dma_wr_data  = dma_mode_active ? rx_dma_wr_data_i : 512'd0;
    rx_dma_wr_beats = dma_mode_active ? rx_dma_wr_beats_i : 6'd0;

    tx_valid = dma_mode_active ? tx_dma_valid_i : 1'b0;
    tx_sop   = dma_mode_active ? tx_dma_sop_i : 1'b0;
    tx_eop   = dma_mode_active ? tx_dma_eop_i : 1'b0;
    tx_data  = dma_mode_active ? tx_dma_data_i : 512'd0;
    tx_empty = dma_mode_active ? tx_dma_empty_i : 6'd0;
    tx_error = dma_mode_active ? tx_dma_error_i : 1'b0;

    tx_path_enable = nic_enable;
    irq_status     = irq_status_reg | (dma_mode_active ? rx_dma_irq_status : 32'd0);
    rx_frame_ready = !dma_mode_active || (!dma_rx_frame_pending && !rx_frame_valid);

    tx_head_hw      = dma_mode_active ? tx_dma_head_hw : tx_ring_head_host[15:0];
    rx_fill_head_hw = dma_mode_active ? rx_dma_fill_head_hw : 16'd0;
    rx_cpl_tail_hw  = dma_mode_active ? rx_dma_cpl_tail_hw : rx_cpl_head_dev[15:0];

    mmio_rd_data = 32'd0;

    for (int desc_idx = 0; desc_idx < DESC_RING_CAPACITY; desc_idx = desc_idx + 1) begin
      if ((mmio_rd_addr >= (TX_DESC_BASE + (desc_idx * 16))) &&
          (mmio_rd_addr <  (TX_DESC_BASE + (desc_idx * 16) + 16)))
        mmio_rd_data = tx_desc_mem[desc_idx][(mmio_rd_addr - (TX_DESC_BASE + (desc_idx * 16))) >> 2];

      if ((mmio_rd_addr >= (RX_CPL_BASE + (desc_idx * 16))) &&
          (mmio_rd_addr <  (RX_CPL_BASE + (desc_idx * 16) + 16)))
        mmio_rd_data = rx_cpl_mem[desc_idx][(mmio_rd_addr - (RX_CPL_BASE + (desc_idx * 16))) >> 2];
    end

    for (int slot_idx = 0; slot_idx < SLOT_COUNT; slot_idx = slot_idx + 1) begin
      if ((mmio_rd_addr >= (TX_SLOT_BASE + (slot_idx * SLOT_WORDS * 4))) &&
          (mmio_rd_addr <  (TX_SLOT_BASE + ((slot_idx + 1) * SLOT_WORDS * 4))))
        mmio_rd_data = tx_slot_mem[slot_idx][(mmio_rd_addr - (TX_SLOT_BASE + (slot_idx * SLOT_WORDS * 4))) >> 2];

      if ((mmio_rd_addr >= (RX_SLOT_BASE + (slot_idx * SLOT_WORDS * 4))) &&
          (mmio_rd_addr <  (RX_SLOT_BASE + ((slot_idx + 1) * SLOT_WORDS * 4))))
        mmio_rd_data = rx_slot_mem[slot_idx][(mmio_rd_addr - (RX_SLOT_BASE + (slot_idx * SLOT_WORDS * 4))) >> 2];
    end

    csr_window_flat = '0;
    csr_window_flat[31:0]      = dma_mode_active ? tx_desc_base[31:0] : {16'd0, mmio_wr_addr};
    csr_window_flat[63:32]     = dma_mode_active ? tx_desc_base[63:32] : mmio_wr_data_shadow;
    csr_window_flat[95:64]     = {16'h0, tx_desc_count};
    csr_window_flat[127:96]    = {16'h0, tx_tail_db};
    csr_window_flat[159:128]   = rx_fill_base[31:0];
    csr_window_flat[191:160]   = rx_fill_base[63:32];
    csr_window_flat[223:192]   = {16'h0, rx_fill_count};
    csr_window_flat[255:224]   = {16'h0, rx_fill_tail_db};
    csr_window_flat[287:256]   = rx_cpl_base[31:0];
    csr_window_flat[319:288]   = rx_cpl_base[63:32];
    csr_window_flat[351:320]   = {16'h0, rx_cpl_count};
    csr_window_flat[383:352]   = {DMA_BACKEND_PRESENT, 28'd0, dma_mode_active, irq_enable, nic_enable};
    csr_window_flat[415:384]   = mac_addr[31:0];
    csr_window_flat[447:416]   = {16'h0, mac_addr[47:32]};
    csr_window_flat[479:448]   = {16'h0, mtu};
    csr_window_flat[511:480]   = {30'h0, fec_mode};
    csr_window_flat[543:512]   = dma_mode_active ? {16'd0, tx_tail_db} : tx_ring_head_host;
    csr_window_flat[575:544]   = dma_mode_active ? {16'd0, tx_dma_head_hw} : tx_ring_tail_dev;
    csr_window_flat[607:576]   = DESC_RING_CAPACITY;
    csr_window_flat[639:608]   = tx_ring_initialized;
    csr_window_flat[671:640]   = SLOT_COUNT;
    csr_window_flat[703:672]   = SLOT_WORDS;
    csr_window_flat[735:704]   = irq_status_reg | (dma_mode_active ? rx_dma_irq_status : 32'd0);
    csr_window_flat[767:736]   = dma_mode_active ? tx_dma_debug_status : tx_packets_completed;
    csr_window_flat[799:768]   = dma_mode_active ? {16'd0, rx_dma_cpl_tail_hw} : rx_cpl_head_dev;
    csr_window_flat[831:800]   = dma_mode_active ? {16'd0, rx_dma_fill_head_hw} : rx_cpl_tail_host;
    csr_window_flat[863:832]   = DESC_RING_CAPACITY;
    csr_window_flat[895:864]   = rx_cpl_initialized;
    csr_window_flat[927:896]   = SLOT_COUNT;
    csr_window_flat[959:928]   = SLOT_WORDS;
    csr_window_flat[991:960]   = dma_mode_active ? rx_dma_debug_status : rx_packets_completed;
    csr_window_flat[1023:992]  = mmio_rd_data;
  end

endmodule
