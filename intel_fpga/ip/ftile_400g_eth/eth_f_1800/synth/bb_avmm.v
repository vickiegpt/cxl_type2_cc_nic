// (C) 2001-2025 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


(* is_building_block *)
// BCM_FILE=$ACDS_SRC_ROOT/quartus/ipd_data/gdr/model_s1/building_blocks/ip_config_hdpldadapt_/vmm1.bcm.xml
//module bb_m_hdpldadapt_avmm1 #(
module bb_avmm1 #(
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter aib_fabric_pld_pma_hclk_hz                         = "__BB_DONT_CARE__" /* AUTOUP_Non- Moded clock shared clock - BCM default=31'd0 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter aib_fabric_pma_aib_tx_clk_hz                       = "__BB_DONT_CARE__" /* AUTOUP_Moded clock TX clock - BCM default=31'd0 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter aib_fabric_rx_transfer_clk_hz                      = "__BB_DONT_CARE__" /* AUTOUP_Moded clock RX clock - BCM default=31'd0 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter csr_clk_hz                                         = "__BB_DONT_CARE__" /* AUTOUP_Non- Moded clock shared clock - BCM default=31'd0 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_avmm_adapter_base_addr                  = "__BB_DONT_CARE__" /* AUTOUP_Adapter base address for AVMM1 - BCM default=10'd0 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_avmm_avmm1_avmm_clk_scg_en              = "__BB_DONT_CARE__" /* AUTOUP_AVMM1 Clock Static Clock Gating Enable - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_avmm_avmm1_cmdfifo_empty                = "__BB_DONT_CARE__" /* AUTOUP_AVMM1 Command FIFO empty threshold - BCM default=6'b000000 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_avmm_avmm1_cmdfifo_full                 = "__BB_DONT_CARE__" /* AUTOUP_AVMM1 Command FIFO full threshold - BCM default=6'b000000 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_avmm_avmm1_cmdfifo_pfull                = "__BB_DONT_CARE__" /* AUTOUP_AVMM1 Command FIFO partially full threshold - BCM default=6'b000000 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_avmm_avmm1_cmdfifo_stop_read            = "__BB_DONT_CARE__" /* AUTOUP_AVMM1 Command FIFO read is allowed or not when emtpy - BCM default="HDPLDADAPT_AVMM_AVMM1_CMDFIFO_RD_EMPTY" - Legal settings are {HDPLDADAPT_AVMM_AVMM1_CMDFIFO_RD_EMPTY,HDPLDADAPT_AVMM_AVMM1_CMDFIFO_N_RD_EMPTY,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_avmm_avmm1_cmdfifo_stop_write           = "__BB_DONT_CARE__" /* AUTOUP_AVMM1 Command FIFO write is allowed or not when full - BCM default="HDPLDADAPT_AVMM_AVMM1_CMDFIFO_WR_FULL" - Legal settings are {HDPLDADAPT_AVMM_AVMM1_CMDFIFO_WR_FULL,HDPLDADAPT_AVMM_AVMM1_CMDFIFO_N_WR_FULL,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_avmm_avmm1_gate_dis                     = "__BB_DONT_CARE__" /* AUTOUP_Gate PLD AVMM1 write/read/request - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_avmm_avmm1_nfhssi_calibratio_feature_en = "__BB_DONT_CARE__" /* AUTOUP_Enables PMA channel calibration feature - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_avmm_avmm1_osc_clk_scg_en               = "__BB_DONT_CARE__" /* AUTOUP_AVMM1 Oscillator Clock Static Clock Gating Enable - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_avmm_avmm1_pcs_dft_broadcast_en         = "__BB_DONT_CARE__" /* AUTOUP_Enables DFT feature of "broadcast write" to DPRIO bits via AVMM1 - BCM default="HDPLDADAPT_AVMM_DISABLE_ONLY_DFT" - Legal settings are {HDPLDADAPT_AVMM_DISABLE_ONLY_DFT} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_avmm_avmm1_pcs_force_mdio_dis_csr_ctrl  = "__BB_DONT_CARE__" /* AUTOUP_Enables DFT feature to override the AVMM1 interface_sel input from the core to high - BCM default="HDPLDADAPT_AVMM_DISABLE_ONLY_DIS" - Legal settings are {HDPLDADAPT_AVMM_DISABLE_ONLY_DIS} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_avmm_avmm1_rdfifo_empty                 = "__BB_DONT_CARE__" /* AUTOUP_AVMM1 Read FIFO empty threshold - BCM default=6'b000000 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_avmm_avmm1_rdfifo_full                  = "__BB_DONT_CARE__" /* AUTOUP_AVMM1 Read FIFO full threshold - BCM default=6'b000000 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_avmm_avmm1_rdfifo_stop_read             = "__BB_DONT_CARE__" /* AUTOUP_AVMM1 Read FIFO read is allowed or not when emtpy - BCM default="HDPLDADAPT_AVMM_AVMM1_RDFIFO_RD_EMPTY" - Legal settings are {HDPLDADAPT_AVMM_AVMM1_RDFIFO_RD_EMPTY,HDPLDADAPT_AVMM_AVMM1_RDFIFO_N_RD_EMPTY,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_avmm_avmm1_rdfifo_stop_write            = "__BB_DONT_CARE__" /* AUTOUP_AVMM1 Read FIFO write is allowed or not when full - BCM default="HDPLDADAPT_AVMM_AVMM1_RDFIFO_WR_FULL" - Legal settings are {HDPLDADAPT_AVMM_AVMM1_RDFIFO_WR_FULL,HDPLDADAPT_AVMM_AVMM1_RDFIFO_N_WR_FULL,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_avmm_avmm1_read_blocking_enable         = "__BB_DONT_CARE__" /* AUTOUP_Block subsequent avmm_read before return of previous readdatavalid - BCM default="ENABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_avmm_avmm1_uc_blocking_enable           = "__BB_DONT_CARE__" /* AUTOUP_Block subsequent avmm_read/write after write uC - BCM default="ENABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_avmm_avmm_hrdrst_osc_clk_scg_en         = "__BB_DONT_CARE__" /* AUTOUP_Oscillator Reset SM Oscillator Clock Static Clock Gating Enable - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_avmm_avmm_testbus_sel                   = "__BB_DONT_CARE__" /* AUTOUP_AVMM testbus selection - BCM default="HDPLDADAPT_AVMM_AVMM1_TRANSFER_TESTBUS" - Legal settings are {HDPLDADAPT_AVMM_AVMM1_TRANSFER_TESTBUS,HDPLDADAPT_AVMM_AVMM2_TRANSFER_TESTBUS,HDPLDADAPT_AVMM_AVMM1_CMN_INTF_TESTBUS,HDPLDADAPT_AVMM_UNUSED_TESTBUS,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_avmm_hip_mode                           = "__BB_DONT_CARE__" /* AUTOUP_HIP mode - BCM default="HDPLDADAPT_AVMM_DISABLE_HIP" - Legal settings are {HDPLDADAPT_AVMM_DISABLE_HIP,HDPLDADAPT_AVMM_USER_CHNL,HDPLDADAPT_AVMM_DEBUG_CHNL,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_avmm_nfhssi_base_addr                   = "__BB_DONT_CARE__" /* AUTOUP_pcs channel base address for AVMM1 - BCM default=10'd0 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_avmm_powermode_dc                       = "__BB_DONT_CARE__" /* AUTOUP_Powermode_dc - BCM default="HDPLDADAPT_AVMM_POWERDOWN" - Legal settings are {HDPLDADAPT_AVMM_POWERDOWN,HDPLDADAPT_AVMM_POWERUP,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_sr_hip_mode                             = "__BB_DONT_CARE__" /* AUTOUP_HIP mode - BCM default="HDPLDADAPT_SR_DISABLE_HIP" - Legal settings are {HDPLDADAPT_SR_DISABLE_HIP,HDPLDADAPT_SR_USER_CHNL,HDPLDADAPT_SR_DEBUG_CHNL,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_sr_sr_osc_clock_setting                 = "__BB_DONT_CARE__" /* AUTOUP_SR osc clock selection - BCM default="HDPLDADAPT_SR_OSC_CLK_DIV_BY1" - Legal settings are {HDPLDADAPT_SR_OSC_CLK_DIV_BY1,HDPLDADAPT_SR_OSC_CLK_DIV_BY2,HDPLDADAPT_SR_OSC_CLK_DIV_BY4,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter hdpldadapt_sr_sr_parity_en                         = "__BB_DONT_CARE__" /* AUTOUP_SR parity Enable - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter location                                           = "__BB_DONT_CARE__" /* ip_config_hdpldadapt_avmm1 location - BCM default="MAIB0" - Legal settings are {MAIB0,MAIB1,MAIB2,MAIB3,MAIB4,MAIB5,MAIB6,MAIB7,MAIB8,MAIB9,MAIB10,MAIB11,MAIB12,MAIB13,MAIB14,MAIB15,MAIB16,MAIB17,MAIB18,MAIB19,MAIB20,MAIB21,MAIB22,MAIB23,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter pld_avmm1_clk_rowclk_hz                            = "__BB_DONT_CARE__" /* AUTOUP_Non- Moded clock shared clock - BCM default=31'd0 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter pld_sclk1_rowclk_hz                                = "__BB_DONT_CARE__" /* AUTOUP_Non- Moded clock shared clock - BCM default=31'd0 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter pld_sclk2_rowclk_hz                                = "__BB_DONT_CARE__" /* AUTOUP_Non- Moded clock shared clock - BCM default=31'd0 */,
    /* rev=fm6 */ parameter silicon_rev                                        = "__BB_DONT_CARE__" /* BB silicon revision - BCM default="fm6" - Legal settings are {fm6} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm1 */ parameter speed_grade                                        = "__BB_DONT_CARE__" /* AUTOUP_device speed grade for frequency rules - BCM default="DASH_1" - Legal settings are {DASH_1,DASH_2,DASH_3,DASH_4,__BB_DONT_CARE__} */
)
(
    (* real_port *) output pld_avmm1_busy_real,
    (* real_port *) input  pld_avmm1_clk_rowclk_real,
    (* real_port *) output pld_avmm1_cmdfifo_wr_full_real,
    (* real_port *) output pld_avmm1_cmdfifo_wr_pfull_real,
    (* real_port *) input  pld_avmm1_read_real,
    (* real_port *) output reg [7:0] pld_avmm1_readdata_real,
    (* real_port *) output pld_avmm1_readdatavalid_real,
    (* real_port *) input  [9:0] pld_avmm1_reg_addr_real,
    (* real_port *) input  pld_avmm1_request_real,
    (* real_port *) input  [8:0] pld_avmm1_reserved_in_real,
    (* real_port *) output [2:0] pld_avmm1_reserved_out_real,
    (* real_port *) input  pld_avmm1_write_real,
    (* real_port *) input  [7:0] pld_avmm1_writedata_real,
    (* real_port *) output pld_chnl_cal_done_real,
    (* real_port *) output pld_hssi_osc_transfer_en_real,
    (* link_port *) output avmm1_link
);



   localparam       AVMM_WAIT_PEROID  = 4'h4;
   localparam       ST_IDLE      = 3'h0;
   localparam       ST_READ      = 3'h1;
   localparam       ST_READ_DONE = 3'h2;
   localparam       ST_WRITE     = 3'h3;
   localparam       ST_WRITE_DONE = 3'h4;

   // unused ports
    assign   pld_avmm1_cmdfifo_wr_full_real  = 1'b0;
    assign   pld_avmm1_cmdfifo_wr_pfull_real = 1'b0;
    assign   pld_pll_cal_done_real           = 1'b1;
    assign   pld_avmm1_busy_real             = 1'b0;

   // singals used in FSM
   reg  [2:0]           avmm_s8_st;
   wire                 write_done,  read_valid;
   reg  [3:0]           wait_cnt;

   assign   pld_avmm1_reserved_out_real = {1'b0, write_done, 1'b0};
   assign   pld_avmm1_readdatavalid_real = read_valid;
   assign   read_valid = (avmm_s8_st == ST_READ_DONE)? 1'b1 : 1'b0;
   assign   write_done = (avmm_s8_st == ST_WRITE_DONE)? 1'b1 : 1'b0;

 
initial begin
        avmm_s8_st       <= ST_IDLE;
        wait_cnt <= 4'h0;
	pld_avmm1_readdata_real <= 8'h0;
end

always @(posedge pld_avmm1_clk_rowclk_real  ) begin
	case (avmm_s8_st) 
	     ST_IDLE:    begin
		     avmm_s8_st= (pld_avmm1_read_real)?  ST_READ : ((pld_avmm1_write_real)? ST_WRITE : avmm_s8_st);
		     if (pld_avmm1_read_real || pld_avmm1_write_real) wait_cnt <= 4'h0;
		end
	     ST_READ:    begin
		     if (wait_cnt < AVMM_WAIT_PEROID) wait_cnt <= wait_cnt + 1;
		     //else  begin avmm_s8_st <= ST_READ_DONE;  pld_avmm1_readdata_real <= $random() % 256; end
		     else  begin avmm_s8_st <= ST_READ_DONE;  pld_avmm1_readdata_real <= 8'h8f; end
		end
	     ST_READ_DONE:    begin avmm_s8_st <= ST_IDLE; end
	     ST_WRITE:      begin
		     if (wait_cnt < AVMM_WAIT_PEROID) wait_cnt <= wait_cnt + 1;
		     else  avmm_s8_st <= ST_WRITE_DONE;
		end
	     ST_WRITE_DONE:   avmm_s8_st <= ST_IDLE;
	     default:    avmm_s8_st <= ST_IDLE;
        endcase
end     // always

endmodule // module bb_m_hdpldadapt_avmm1

(* is_building_block *)
// BCM_FILE=$ACDS_SRC_ROOT/quartus/ipd_data/gdr/model_s1/building_blocks/ip_config_hdpldadapt_avmm2.bcm.xml
//module bb_m_hdpldadapt_avmm2 #(
module bb_avmm2 #(
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter aib_fabric_pld_pma_hclk_hz                 = "__BB_DONT_CARE__" /* AUTOUP_Non- Moded clock shared clock - BCM default=31'd0 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter aib_fabric_pma_aib_tx_clk_hz               = "__BB_DONT_CARE__" /* AUTOUP_Moded clock TX clock - BCM default=31'd0 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter aib_fabric_rx_transfer_clk_hz              = "__BB_DONT_CARE__" /* AUTOUP_Moded clock RX clock - BCM default=31'd0 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter csr_clk_hz                                 = "__BB_DONT_CARE__" /* AUTOUP_Non- Moded clock shared clock - BCM default=31'd0 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter hdpldadapt_avmm_adapter_base_addr          = "__BB_DONT_CARE__" /* AUTOUP_Adapter base address for AVMM1 - BCM default=10'd0 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter hdpldadapt_avmm_avmm2_avmm_clk_scg_en      = "__BB_DONT_CARE__" /* AUTOUP_AVMM2 Clock Static Clock Gating Enable - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter hdpldadapt_avmm_avmm2_cmdfifo_empty        = "__BB_DONT_CARE__" /* AUTOUP_AVMM2 Command FIFO empty threshold - BCM default=6'b000000 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter hdpldadapt_avmm_avmm2_cmdfifo_full         = "__BB_DONT_CARE__" /* AUTOUP_AVMM2 Command FIFO full threshold - BCM default=6'b000000 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter hdpldadapt_avmm_avmm2_cmdfifo_pfull        = "__BB_DONT_CARE__" /* AUTOUP_AVMM2 Command FIFO partially full threshold - BCM default=6'b000000 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter hdpldadapt_avmm_avmm2_cmdfifo_stop_read    = "__BB_DONT_CARE__" /* AUTOUP_AVMM2 Command FIFO read is allowed or not when emtpy - BCM default="HDPLDADAPT_AVMM_AVMM2_CMDFIFO_RD_EMPTY" - Legal settings are {HDPLDADAPT_AVMM_AVMM2_CMDFIFO_RD_EMPTY,HDPLDADAPT_AVMM_AVMM2_CMDFIFO_N_RD_EMPTY,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter hdpldadapt_avmm_avmm2_cmdfifo_stop_write   = "__BB_DONT_CARE__" /* AUTOUP_AVMM2 Command FIFO write is allowed or not when full - BCM default="HDPLDADAPT_AVMM_AVMM2_CMDFIFO_WR_FULL" - Legal settings are {HDPLDADAPT_AVMM_AVMM2_CMDFIFO_WR_FULL,HDPLDADAPT_AVMM_AVMM2_CMDFIFO_N_WR_FULL,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter hdpldadapt_avmm_avmm2_gate_dis             = "__BB_DONT_CARE__" /* AUTOUP_Gate PLD AVMM2 write/read/request or HIP write/read - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter hdpldadapt_avmm_avmm2_hip_sel              = "__BB_DONT_CARE__" /* AUTOUP_Determine AVMM2 bus belongs to PLL or HIP - BCM default="HDPLDADAPT_AVMM_AVMM2_FOR_PLL" - Legal settings are {HDPLDADAPT_AVMM_AVMM2_FOR_PLL,HDPLDADAPT_AVMM_AVMM2_FOR_HIP,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter hdpldadapt_avmm_avmm2_osc_clk_scg_en       = "__BB_DONT_CARE__" /* AUTOUP_AVMM2 Oscillator Clock Static Clock Gating Enable - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter hdpldadapt_avmm_avmm2_rdfifo_empty         = "__BB_DONT_CARE__" /* AUTOUP_AVMM2 Read FIFO empty threshold - BCM default=6'b000000 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter hdpldadapt_avmm_avmm2_rdfifo_full          = "__BB_DONT_CARE__" /* AUTOUP_AVMM2 Read FIFO full threshold - BCM default=6'b000000 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter hdpldadapt_avmm_avmm2_rdfifo_stop_read     = "__BB_DONT_CARE__" /* AUTOUP_AVMM2 Read FIFO read is allowed or not when emtpy - BCM default="HDPLDADAPT_AVMM_AVMM2_RDFIFO_RD_EMPTY" - Legal settings are {HDPLDADAPT_AVMM_AVMM2_RDFIFO_RD_EMPTY,HDPLDADAPT_AVMM_AVMM2_RDFIFO_N_RD_EMPTY,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter hdpldadapt_avmm_avmm2_rdfifo_stop_write    = "__BB_DONT_CARE__" /* AUTOUP_AVMM2 Read FIFO write is allowed or not when full - BCM default="HDPLDADAPT_AVMM_AVMM2_RDFIFO_WR_FULL" - Legal settings are {HDPLDADAPT_AVMM_AVMM2_RDFIFO_WR_FULL,HDPLDADAPT_AVMM_AVMM2_RDFIFO_N_WR_FULL,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter hdpldadapt_avmm_avmm_hrdrst_osc_clk_scg_en = "__BB_DONT_CARE__" /* AUTOUP_Oscillator Reset SM Oscillator Clock Static Clock Gating Enable - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter hdpldadapt_avmm_avmm_testbus_sel           = "__BB_DONT_CARE__" /* AUTOUP_AVMM testbus selection - BCM default="HDPLDADAPT_AVMM_AVMM1_TRANSFER_TESTBUS" - Legal settings are {HDPLDADAPT_AVMM_AVMM1_TRANSFER_TESTBUS,HDPLDADAPT_AVMM_AVMM2_TRANSFER_TESTBUS,HDPLDADAPT_AVMM_AVMM1_CMN_INTF_TESTBUS,HDPLDADAPT_AVMM_UNUSED_TESTBUS,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter hdpldadapt_avmm_hip_mode                   = "__BB_DONT_CARE__" /* AUTOUP_HIP mode - BCM default="HDPLDADAPT_AVMM_DISABLE_HIP" - Legal settings are {HDPLDADAPT_AVMM_DISABLE_HIP,HDPLDADAPT_AVMM_USER_CHNL,HDPLDADAPT_AVMM_DEBUG_CHNL,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter hdpldadapt_avmm_nfhssi_base_addr           = "__BB_DONT_CARE__" /* AUTOUP_pcs channel base address for AVMM1 - BCM default=10'd0 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter hdpldadapt_avmm_powermode_dc               = "__BB_DONT_CARE__" /* AUTOUP_Powermode_dc - BCM default="HDPLDADAPT_AVMM_POWERDOWN" - Legal settings are {HDPLDADAPT_AVMM_POWERDOWN,HDPLDADAPT_AVMM_POWERUP,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter hdpldadapt_sr_hip_mode                     = "__BB_DONT_CARE__" /* AUTOUP_HIP mode - BCM default="HDPLDADAPT_SR_DISABLE_HIP" - Legal settings are {HDPLDADAPT_SR_DISABLE_HIP,HDPLDADAPT_SR_USER_CHNL,HDPLDADAPT_SR_DEBUG_CHNL,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter hdpldadapt_sr_sr_osc_clock_setting         = "__BB_DONT_CARE__" /* AUTOUP_SR osc clock selection - BCM default="HDPLDADAPT_SR_OSC_CLK_DIV_BY1" - Legal settings are {HDPLDADAPT_SR_OSC_CLK_DIV_BY1,HDPLDADAPT_SR_OSC_CLK_DIV_BY2,HDPLDADAPT_SR_OSC_CLK_DIV_BY4,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter hdpldadapt_sr_sr_parity_en                 = "__BB_DONT_CARE__" /* AUTOUP_SR parity Enable - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter location                                   = "__BB_DONT_CARE__" /* ip_config_hdpldadapt_avmm2 location - BCM default="MAIB0" - Legal settings are {MAIB0,MAIB1,MAIB2,MAIB3,MAIB4,MAIB5,MAIB6,MAIB7,MAIB8,MAIB9,MAIB10,MAIB11,MAIB12,MAIB13,MAIB14,MAIB15,MAIB16,MAIB17,MAIB18,MAIB19,MAIB20,MAIB21,MAIB22,MAIB23,__BB_DONT_CARE__} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter pld_avmm2_clk_rowclk_hz                    = "__BB_DONT_CARE__" /* AUTOUP_Non- Moded clock shared clock - BCM default=31'd0 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter pld_sclk1_rowclk_hz                        = "__BB_DONT_CARE__" /* AUTOUP_Non- Moded clock shared clock - BCM default=31'd0 */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter pld_sclk2_rowclk_hz                        = "__BB_DONT_CARE__" /* AUTOUP_Non- Moded clock shared clock - BCM default=31'd0 */,
    /* rev=fm6 */ parameter silicon_rev                                = "__BB_DONT_CARE__" /* BB silicon revision - BCM default="fm6" - Legal settings are {fm6} */,
    /* rev=fm6;bcm_type=ip_config_hdpldadapt_avmm2 */ parameter speed_grade                                = "__BB_DONT_CARE__" /* AUTOUP_device speed grade for frequency rules - BCM default="DASH_1" - Legal settings are {DASH_1,DASH_2,DASH_3,DASH_4,__BB_DONT_CARE__} */
)
(
    (* real_port *) input  hip_avmm_read_real,
    (* real_port *) output reg [7:0] hip_avmm_readdata_real,
    (* real_port *) output hip_avmm_readdatavalid_real,
    (* real_port *) input  [20:0] hip_avmm_reg_addr_real,
    (* real_port *) output [4:0] hip_avmm_reserved_out_real,
    (* real_port *) input  hip_avmm_write_real,
    (* real_port *) input  [7:0] hip_avmm_writedata_real,
    (* real_port *) output hip_avmm_writedone_real,
    (* real_port *) output pld_avmm2_busy_real,
    (* real_port *) input  pld_avmm2_clk_rowclk_real,
    (* real_port *) output pld_avmm2_cmdfifo_wr_full_real,
    (* real_port *) output pld_avmm2_cmdfifo_wr_pfull_real,
    (* real_port *) input  pld_avmm2_read_real,
    (* real_port *) output [7:0] pld_avmm2_readdata_real,
    (* real_port *) output pld_avmm2_readdatavalid_real,
    (* real_port *) input  [8:0] pld_avmm2_reg_addr_real,
    (* real_port *) input  pld_avmm2_request_real,
    (* real_port *) input  [9:0] pld_avmm2_reserved_in_real,
    (* real_port *) output [2:0] pld_avmm2_reserved_out_real,
    (* real_port *) input  pld_avmm2_write_real,
    (* real_port *) input  [7:0] pld_avmm2_writedata_real,
    (* real_port *) output pld_pll_cal_done_real,
    (* link_port *) output avmm2_link
);

   localparam       AVMM_WAIT_PEROID  = 4'h4;
   localparam       ST_IDLE      = 3'h0;
   localparam       ST_READ      = 3'h1;
   localparam       ST_READ_DONE = 3'h2;
   localparam       ST_WRITE     = 3'h3;
   localparam       ST_WRITE_DONE = 3'h4;

   // unused ports
    assign   pld_avmm2_cmdfifo_wr_full_real  = 1'b0;
    assign   pld_avmm2_cmdfifo_wr_pfull_real = 1'b0;
    assign   pld_avmm2_readdata_real         = 8'h0;
    assign   pld_pll_cal_done_real           = 1'b1;
    assign   pld_avmm2_busy_real             = 1'b0;
    assign   hip_avmm_reserved_out_real      = 4'h0;

   // singals used in FSM
   reg  [2:0]           avmm_s8_st;
   wire                 write_done,  read_valid;
   reg  [3:0]           wait_cnt;

   assign   hip_avmm_writedone_real = write_done;
   assign   hip_avmm_readdatavalid_real = read_valid;
   assign   read_valid = (avmm_s8_st == ST_READ_DONE)? 1'b1 : 1'b0;
   assign   write_done = (avmm_s8_st == ST_WRITE_DONE)? 1'b1 : 1'b0;

 
initial begin
        avmm_s8_st       <= ST_IDLE;
        wait_cnt <= 4'h0;
	hip_avmm_readdata_real <= 8'h0;
end

always @(posedge pld_avmm2_clk_rowclk_real  ) begin
	case (avmm_s8_st) 
	     ST_IDLE:    begin
		     avmm_s8_st= (hip_avmm_read_real)?  ST_READ : ((hip_avmm_write_real)? ST_WRITE : avmm_s8_st);
		     if (hip_avmm_read_real || hip_avmm_write_real) wait_cnt <= 4'h0;
		end
	     ST_READ:    begin
		     if (wait_cnt < AVMM_WAIT_PEROID) wait_cnt <= wait_cnt + 1;
		     else  begin avmm_s8_st <= ST_READ_DONE;  hip_avmm_readdata_real <= $random() % 256; end
		end
	     ST_READ_DONE:    begin avmm_s8_st <= ST_IDLE; end
	     ST_WRITE:      begin
		     if (wait_cnt < AVMM_WAIT_PEROID) wait_cnt <= wait_cnt + 1;
		     else  avmm_s8_st <= ST_WRITE_DONE;
		end
	     ST_WRITE_DONE:   avmm_s8_st <= ST_IDLE;
	     default:    avmm_s8_st <= ST_IDLE;
        endcase
end     // always



endmodule // module bb_m_hdpldadapt_avmm2

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "o2ONPYJ6JWO2K/lQHkyApXo6DVczB8sUyJtLpEiYtF7LL07s93qi8rQ7d2s1AdTOt/BNVdBoSTLCdACDT58BR3umvYuucV6Cbb36lNsOsJegwtedOJsDvTnB14ZLU41EvDEX+uxr7iJUYiTmn7hunq22K1+T/Nc7+FaTNr6AMH3CCuiZmo/CmXjVXLRPwF034Kg1mVvlsNTpZhm0ORjPpNI8tuMP0bMp6HLhHMKVKve65ThOc96zesttvtyzAyFzUnuT1XE2ECnoEnPTIn7smarceXP8u08MJlTM/96fvTSYxQDeIJpDglyBChDWGuJHZdGfaOWxviMAETCPYfWfCFQ9yznVFDypSegGYeOV6ghcJ5MmDNBVp+P3X71606KuLQD9BUelTndgMqpEMVmBX8XozaLdhvepidmoEQRvJzVy/JGaJ0POtFP+Wf1iVTkbPcpm55EUzIitJt9FcQETyXG2JJPABjYWnmqcCtfbuKjXe1+RM4GuJUdRUgZboT8okwxO3lR5qMKB0RL9/4WfYw9PEEgHBgvnb91ge/BUR4OzzqeavwK/wdxQhA3KMYAylv4QVTgbtJfeWUC3UNXLaU97MIMgfML21JKAilql03DvN2n6zbQoClyw2ruNdqdX2H6IjZIkEYl/+1kbVBqr51ia8NNh/k0Ky2I8EiIiGIhX5z7u/8AVxpE/rWTtMRfNIQ1Lrxn9YpzAV27zvLOdnkK2X4KK2R3In91EEWE+80HFpgzwmeusWeYJSWqjcJQHPB7QFm4B6TgvML/cuau+SMlERuFrkzy3VRjGx40R4T/9Q0+F2LX3cp55CNAeyHG/pgVLYHvjv5NZhuI6g0xvXKa7HkYmB7UqxfHB3kx9CgAevX2RNxszgdfYcrExsdAZJWFbanebOzdIFiZaZB2Sgx/Czc5SJeOVx4K75b9cA0Owb2PvfgVwM0nkInGmsRwcKvFJlKGtb2axSuF9v/bG25yIOZ0+jb6DmNXs1g/r/cJGBvY7aZS3Mgcn7wwzLm3Y"
`endif