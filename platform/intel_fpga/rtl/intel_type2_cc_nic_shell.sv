module intel_type2_cc_nic_shell #(
    parameter logic DMA_BACKEND_PRESENT = 1'b0
) (
    input  logic          user_clk,
    input  logic          user_rst_n,
    input  logic          eth_link_up,

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

  type2_nic_top #(
      .DMA_BACKEND_PRESENT(DMA_BACKEND_PRESENT)
  ) u_type2_nic (
      .clk(user_clk),
      .rst_n(user_rst_n),
      .link_up(eth_link_up),

      .csr_write(csr_write),
      .csr_byteenable(csr_byteenable),
      .csr_addr(csr_addr),
      .csr_wdata(csr_wdata),

      .tx_dma_rd_req(tx_dma_rd_req),
      .tx_dma_rd_addr(tx_dma_rd_addr),
      .tx_dma_rd_len(tx_dma_rd_len),
      .tx_dma_rd_ack(tx_dma_rd_ack),
      .tx_dma_rd_data_valid(tx_dma_rd_data_valid),
      .tx_dma_rd_data(tx_dma_rd_data),
      .tx_dma_rd_last(tx_dma_rd_last),

      .rx_dma_rd_req(rx_dma_rd_req),
      .rx_dma_rd_addr(rx_dma_rd_addr),
      .rx_dma_rd_len(rx_dma_rd_len),
      .rx_dma_rd_ack(rx_dma_rd_ack),
      .rx_dma_rd_data_valid(rx_dma_rd_data_valid),
      .rx_dma_rd_data(rx_dma_rd_data),
      .rx_dma_rd_last(rx_dma_rd_last),

      .rx_dma_wr_req(rx_dma_wr_req),
      .rx_dma_wr_addr(rx_dma_wr_addr),
      .rx_dma_wr_data(rx_dma_wr_data),
      .rx_dma_wr_beats(rx_dma_wr_beats),
      .rx_dma_wr_ack(rx_dma_wr_ack),

      .tx_valid(tx_valid),
      .tx_sop(tx_sop),
      .tx_eop(tx_eop),
      .tx_data(tx_data),
      .tx_empty(tx_empty),
      .tx_error(tx_error),
      .tx_ready(tx_ready),

      .rx_valid(rx_valid),
      .rx_sop(rx_sop),
      .rx_eop(rx_eop),
      .rx_data(rx_data),
      .rx_empty(rx_empty),
      .rx_error(rx_error),

      .tx_path_enable(tx_path_enable),
      .tx_frame_valid(tx_frame_valid),
      .tx_frame_data(tx_frame_data),
      .tx_frame_inframe(tx_frame_inframe),
      .tx_frame_eop_empty(tx_frame_eop_empty),
      .tx_frame_error_mask(tx_frame_error_mask),
      .tx_frame_skip_crc(tx_frame_skip_crc),
      .tx_frame_ready(tx_frame_ready),

      .rx_frame_valid(rx_frame_valid),
      .rx_frame_data(rx_frame_data),
      .rx_frame_inframe(rx_frame_inframe),
      .rx_frame_eop_empty(rx_frame_eop_empty),
      .rx_frame_error_mask(rx_frame_error_mask),
      .rx_frame_meta(rx_frame_meta),
      .rx_frame_ready(rx_frame_ready),

      .irq_status(irq_status),
      .csr_window_flat(csr_window_flat)
  );

endmodule
