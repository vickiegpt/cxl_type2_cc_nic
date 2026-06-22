module type2_nic_queue_regs (
    input  logic         clk,
    input  logic         rst_n,
    input  logic         csr_write,
    input  logic [15:0]  csr_addr,
    input  logic [31:0]  csr_wdata,

    output logic [63:0]  tx_desc_base,
    output logic [15:0]  tx_desc_count,
    output logic [15:0]  tx_tail_db,
    output logic [63:0]  rx_fill_base,
    output logic [15:0]  rx_fill_count,
    output logic [15:0]  rx_fill_tail_db,
    output logic [63:0]  rx_cpl_base,
    output logic [15:0]  rx_cpl_count,
    output logic [47:0]  mac_addr,
    output logic [15:0]  mtu,
    output logic [1:0]   fec_mode,
    output logic         nic_enable,
    output logic         irq_enable,
    output logic         dma_mode_enable,
    input  logic [15:0]  tx_head_hw,
    input  logic [15:0]  rx_fill_head_hw,
    input  logic [15:0]  rx_cpl_tail_hw,
    input  logic [31:0]  irq_status_hw
);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      tx_desc_base    <= '0;
      tx_desc_count   <= '0;
      tx_tail_db      <= '0;
      rx_fill_base    <= '0;
      rx_fill_count   <= '0;
      rx_fill_tail_db <= '0;
      rx_cpl_base     <= '0;
      rx_cpl_count    <= '0;
      mac_addr        <= 48'h0200_0000_0001;
      mtu             <= 16'd9216;
      fec_mode        <= 2'd1;
      nic_enable      <= 1'b0;
      irq_enable      <= 1'b0;
      dma_mode_enable <= 1'b0;
    end else if (csr_write) begin
      unique case (csr_addr)
        16'h0000: tx_desc_base[31:0]  <= csr_wdata;
        16'h0004: tx_desc_base[63:32] <= csr_wdata;
        16'h0008: tx_desc_count       <= csr_wdata[15:0];
        16'h000c: tx_tail_db          <= csr_wdata[15:0];
        16'h0010: rx_fill_base[31:0]  <= csr_wdata;
        16'h0014: rx_fill_base[63:32] <= csr_wdata;
        16'h0018: rx_fill_count       <= csr_wdata[15:0];
        16'h001c: rx_fill_tail_db     <= csr_wdata[15:0];
        16'h0020: rx_cpl_base[31:0]   <= csr_wdata;
        16'h0024: rx_cpl_base[63:32]  <= csr_wdata;
        16'h0028: rx_cpl_count        <= csr_wdata[15:0];
        16'h002c: begin
          nic_enable      <= csr_wdata[0];
          irq_enable      <= csr_wdata[1];
          dma_mode_enable <= csr_wdata[2];
        end
        16'h0030: mac_addr[31:0]      <= csr_wdata;
        16'h0034: mac_addr[47:32]     <= csr_wdata[15:0];
        16'h0038: mtu                 <= csr_wdata[15:0];
        16'h003c: fec_mode            <= csr_wdata[1:0];
        16'h004c: begin
          if (csr_wdata[0])
            tx_tail_db <= tx_head_hw;
          if (csr_wdata[1])
            rx_fill_tail_db <= rx_fill_head_hw;
        end
        default: ;
      endcase
    end
  end

endmodule
