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


//-----------------------------------------------------------------------------------------------//
//   Generated with Magillem S.A. MRV generator.                                  
//   MRV generator version : 0.2
//   Protocol :  AVALON
//   Wait State : WS1_OUTPUT                                         
//   Date : Mon Aug 21 22:49:39 PDT 2023           
//-----------------------------------------------------------------------------------------------//


//-----------------------------------------------------------------------------------------------//
//   Verilog Register Bank
//   Component Name: eth_f_base_sip_csr
//   File Ref: /nfs/site/disks/swuser_work_shubhas/WW31_23/C0.5drop/p4/ip/ethernet/eth_f/csr_gen/eth_f_base_sip_csr/_workspace_mrv_gen_py_/xmlProject/_local_copy_Vendor_Library_eth_f_base_sip_csr_1.0.xml                                             
//   Magillem Version :   5.11.2.1                                                                         
//-----------------------------------------------------------------------------------------------//
// 
module eth_f_base_sip_csr (
// register offset : 0x100, field offset : 0, access : RO, gui_option.device_name
// register offset : 0x100, field offset : 2, access : RO, gui_option.tile_name
// register offset : 0x100, field offset : 5, access : RO, gui_option.eth_rate
input  [2:0] gui_option_eth_rate_i,
// register offset : 0x100, field offset : 8, access : RO, gui_option.anlt_enable
input   gui_option_anlt_enable_i,
// register offset : 0x100, field offset : 9, access : RO, gui_option.modulation_type
input   gui_option_modulation_type_i,
// register offset : 0x100, field offset : 10, access : RO, gui_option.rsfec_type
input  [2:0] gui_option_rsfec_type_i,
// register offset : 0x100, field offset : 13, access : RO, gui_option.ptp_enable
input   gui_option_ptp_enable_i,
// register offset : 0x100, field offset : 14, access : RO, gui_option.flow_control_mode
input  [2:0] gui_option_flow_control_mode_i,
// register offset : 0x100, field offset : 17, access : RO, gui_option.client_intf
input  [2:0] gui_option_client_intf_i,
// register offset : 0x100, field offset : 20, access : RO, gui_option.xcvr_type
input   gui_option_xcvr_type_i,
// register offset : 0x100, field offset : 21, access : RO, gui_option.num_lanes
input  [3:0] gui_option_num_lanes_i,
// register offset : 0x104, field offset : 0, access : RW, qhip_scratch.scratch
// register offset : 0x108, field offset : 0, access : RW, eth_reset.eio_sys_rst
output  reg eth_reset_eio_sys_rst,
// register offset : 0x108, field offset : 1, access : RW, eth_reset.soft_tx_rst
output  reg eth_reset_soft_tx_rst,
// register offset : 0x108, field offset : 2, access : RW, eth_reset.soft_rx_rst
output  reg eth_reset_soft_rx_rst,
// register offset : 0x108, field offset : 16, access : RW, eth_reset.tx_clear_alarm
output  reg[7:0] eth_reset_tx_clear_alarm,
// register offset : 0x108, field offset : 24, access : RW, eth_reset.rx_clear_alarm
output  reg[7:0] eth_reset_rx_clear_alarm,
// register offset : 0x10c, field offset : 0, access : RO, eth_reset_status.rst_ack_n
input   eth_reset_status_rst_ack_n_i,
// register offset : 0x10c, field offset : 1, access : RO, eth_reset_status.tx_rst_ack_n
input   eth_reset_status_tx_rst_ack_n_i,
// register offset : 0x10c, field offset : 2, access : RO, eth_reset_status.rx_rst_ack_n
input   eth_reset_status_rx_rst_ack_n_i,
// register offset : 0x10c, field offset : 8, access : RO, eth_reset_status.tx_lane_current_state
input  [2:0] eth_reset_status_tx_lane_current_state_i,
// register offset : 0x10c, field offset : 12, access : RO, eth_reset_status.rx_lane_current_state
input  [2:0] eth_reset_status_rx_lane_current_state_i,
// register offset : 0x10c, field offset : 16, access : RO, eth_reset_status.tx_alarm
input  [7:0] eth_reset_status_tx_alarm_i,
// register offset : 0x10c, field offset : 24, access : RO, eth_reset_status.rx_alarm
input  [7:0] eth_reset_status_rx_alarm_i,
// register offset : 0x110, field offset : 0, access : RO, phy_tx_pll_locked.tx_pll_locked
input  [7:0] phy_tx_pll_locked_tx_pll_locked_i,
// register offset : 0x114, field offset : 0, access : RO, phy_eiofreq_locked.eio_freq_lock
input  [7:0] phy_eiofreq_locked_eio_freq_lock_i,
// register offset : 0x118, field offset : 0, access : RO, pcs_status.dskew_status
input   pcs_status_dskew_status_i,
// register offset : 0x118, field offset : 1, access : RO, pcs_status.dskew_chng
input   pcs_status_dskew_chng_i,
// register offset : 0x118, field offset : 2, access : RO, pcs_status.tx_lanes_stable
input   pcs_status_tx_lanes_stable_i,
// register offset : 0x118, field offset : 3, access : RO, pcs_status.rx_pcs_ready
input   pcs_status_rx_pcs_ready_i,
// register offset : 0x118, field offset : 4, access : RO, pcs_status.kr_mode
input   pcs_status_kr_mode_i,
// register offset : 0x118, field offset : 5, access : RO, pcs_status.kr_fec_mode
input   pcs_status_kr_fec_mode_i,
// register offset : 0x11c, field offset : 0, access : RW, pcs_control.clr_dskew_chng
output  reg pcs_control_clr_dskew_chng,
// register offset : 0x120, field offset : 0, access : RO, link_fault_status.lfault
input   link_fault_status_lfault_i,
// register offset : 0x120, field offset : 1, access : RO, link_fault_status.rfault
input   link_fault_status_rfault_i,
// register offset : 0x124, field offset : 0, access : RO, aib_transfer_ready_status.ehip_rx_transfer_ready
input  [15:0] aib_transfer_ready_status_ehip_rx_transfer_ready_i,
// register offset : 0x124, field offset : 16, access : RO, aib_transfer_ready_status.ehip_tx_transfer_ready
input  [15:0] aib_transfer_ready_status_ehip_tx_transfer_ready_i,
// register offset : 0x128, field offset : 0, access : RO, clk_tx_khz.clk_tx_khz
input  [31:0] clk_tx_khz_clk_tx_khz_i,
// register offset : 0x12c, field offset : 0, access : RO, clk_rx_khz.clk_rx_khz
input  [31:0] clk_rx_khz_clk_rx_khz_i,
// register offset : 0x130, field offset : 0, access : RO, clk_pll_khz.clk_pll_khz
input  [31:0] clk_pll_khz_clk_pll_khz_i,
// register offset : 0x134, field offset : 0, access : RO, clk_tx_div_khz.clk_tx_div_khz
input  [31:0] clk_tx_div_khz_clk_tx_div_khz_i,
// register offset : 0x138, field offset : 0, access : RO, clk_rec_div64_khz.clk_rec_div64_khz
input  [31:0] clk_rec_div64_khz_clk_rec_div64_khz_i,
// register offset : 0x13c, field offset : 0, access : RO, clk_rec_div_khz.clk_rec_div_khz
input  [31:0] clk_rec_div_khz_clk_rec_div_khz_i,
// register offset : 0x140, field offset : 0, access : RO, rxmac_adapt_dropped_31_0.rxmac_adapt_dropped_31_0
input  [31:0] rxmac_adapt_dropped_31_0_rxmac_adapt_dropped_31_0_i,
// register offset : 0x144, field offset : 0, access : RO, rxmac_adapt_dropped_63_32.rxmac_adapt_dropped_63_32
input  [31:0] rxmac_adapt_dropped_63_32_rxmac_adapt_dropped_63_32_i,
// register offset : 0x148, field offset : 0, access : RW, rxmac_adapt_dropped_control.rxmac_adapt_dropped_clear
output  reg rxmac_adapt_dropped_control_rxmac_adapt_dropped_clear,
// register offset : 0x148, field offset : 1, access : RW, rxmac_adapt_dropped_control.rxmac_adapt_dropped_snapshot
output  reg rxmac_adapt_dropped_control_rxmac_adapt_dropped_snapshot,
// register offset : 0x300, field offset : 0, access : RO, tx_sync_counter_1L.tx_sync_counter_1L
input  [31:0] tx_sync_counter_1L_tx_sync_counter_1L_i,
// register offset : 0x304, field offset : 0, access : RO, tx_async_counter_1L.tx_async_counter_1L
input  [31:0] tx_async_counter_1L_tx_async_counter_1L_i,
// register offset : 0x308, field offset : 0, access : RO, rx_sync_counter_1L.rx_sync_counter_1L
input  [31:0] rx_sync_counter_1L_rx_sync_counter_1L_i,
// register offset : 0x30c, field offset : 0, access : RO, rx_async_counter_1L.rx_async_counter_1L
input  [31:0] rx_async_counter_1L_rx_async_counter_1L_i,
// register offset : 0x310, field offset : 0, access : RO, dl_cfg_1L.rx_measure_valid
input   dl_cfg_1L_rx_measure_valid_i,
// register offset : 0x310, field offset : 1, access : RO, dl_cfg_1L.tx_measure_valid
input   dl_cfg_1L_tx_measure_valid_i,
// register offset : 0x310, field offset : 30, access : RW, dl_cfg_1L.rx_dl_restart
output  reg dl_cfg_1L_rx_dl_restart,
// register offset : 0x310, field offset : 31, access : RW, dl_cfg_1L.tx_dl_restart
output  reg dl_cfg_1L_tx_dl_restart,
// register offset : 0x314, field offset : 0, access : RO, tx_dl_delay_1L.tx_dl_delay_1L
input  [31:0] tx_dl_delay_1L_tx_dl_delay_1L_i,
// register offset : 0x318, field offset : 0, access : RO, rx_dl_delay_1L.rx_dl_delay_1L
input  [31:0] rx_dl_delay_1L_rx_dl_delay_1L_i,
// register offset : 0x31c, field offset : 0, access : RO, dl_status_1L.rx_async_valid
input   dl_status_1L_rx_async_valid_i,
// register offset : 0x31c, field offset : 1, access : RO, dl_status_1L.rx_sync_valid
input   dl_status_1L_rx_sync_valid_i,
// register offset : 0x31c, field offset : 2, access : RO, dl_status_1L.tx_async_valid
input   dl_status_1L_tx_async_valid_i,
// register offset : 0x31c, field offset : 3, access : RO, dl_status_1L.tx_sync_valid
input   dl_status_1L_tx_sync_valid_i,
// register offset : 0x320, field offset : 0, access : RO, tx_sync_counter_2L.tx_sync_counter_2L
input  [31:0] tx_sync_counter_2L_tx_sync_counter_2L_i,
// register offset : 0x324, field offset : 0, access : RO, tx_async_counter_2L.tx_async_counter_2L
input  [31:0] tx_async_counter_2L_tx_async_counter_2L_i,
// register offset : 0x328, field offset : 0, access : RO, rx_sync_counter_2L.rx_sync_counter_2L
input  [31:0] rx_sync_counter_2L_rx_sync_counter_2L_i,
// register offset : 0x32c, field offset : 0, access : RO, rx_async_counter_2L.rx_async_counter_2L
input  [31:0] rx_async_counter_2L_rx_async_counter_2L_i,
// register offset : 0x330, field offset : 0, access : RO, dl_cfg_2L.rx_measure_valid
input   dl_cfg_2L_rx_measure_valid_i,
// register offset : 0x330, field offset : 1, access : RO, dl_cfg_2L.tx_measure_valid
input   dl_cfg_2L_tx_measure_valid_i,
// register offset : 0x330, field offset : 30, access : RW, dl_cfg_2L.rx_dl_restart
output  reg dl_cfg_2L_rx_dl_restart,
// register offset : 0x330, field offset : 31, access : RW, dl_cfg_2L.tx_dl_restart
output  reg dl_cfg_2L_tx_dl_restart,
// register offset : 0x334, field offset : 0, access : RO, tx_dl_delay_2L.tx_dl_delay_2L
input  [31:0] tx_dl_delay_2L_tx_dl_delay_2L_i,
// register offset : 0x338, field offset : 0, access : RO, rx_dl_delay_2L.rx_dl_delay_2L
input  [31:0] rx_dl_delay_2L_rx_dl_delay_2L_i,
// register offset : 0x33c, field offset : 0, access : RO, dl_status_2L.rx_async_valid
input   dl_status_2L_rx_async_valid_i,
// register offset : 0x33c, field offset : 1, access : RO, dl_status_2L.rx_sync_valid
input   dl_status_2L_rx_sync_valid_i,
// register offset : 0x33c, field offset : 2, access : RO, dl_status_2L.tx_async_valid
input   dl_status_2L_tx_async_valid_i,
// register offset : 0x33c, field offset : 3, access : RO, dl_status_2L.tx_sync_valid
input   dl_status_2L_tx_sync_valid_i,
// register offset : 0x340, field offset : 0, access : RO, tx_sync_counter_3L.tx_sync_counter_3L
input  [31:0] tx_sync_counter_3L_tx_sync_counter_3L_i,
// register offset : 0x344, field offset : 0, access : RO, tx_async_counter_3L.tx_async_counter_3L
input  [31:0] tx_async_counter_3L_tx_async_counter_3L_i,
// register offset : 0x348, field offset : 0, access : RO, rx_sync_counter_3L.rx_sync_counter_3L
input  [31:0] rx_sync_counter_3L_rx_sync_counter_3L_i,
// register offset : 0x34c, field offset : 0, access : RO, rx_async_counter_3L.rx_async_counter_3L
input  [31:0] rx_async_counter_3L_rx_async_counter_3L_i,
// register offset : 0x350, field offset : 0, access : RO, dl_cfg_3L.rx_measure_valid
input   dl_cfg_3L_rx_measure_valid_i,
// register offset : 0x350, field offset : 1, access : RO, dl_cfg_3L.tx_measure_valid
input   dl_cfg_3L_tx_measure_valid_i,
// register offset : 0x350, field offset : 30, access : RW, dl_cfg_3L.rx_dl_restart
output  reg dl_cfg_3L_rx_dl_restart,
// register offset : 0x350, field offset : 31, access : RW, dl_cfg_3L.tx_dl_restart
output  reg dl_cfg_3L_tx_dl_restart,
// register offset : 0x354, field offset : 0, access : RO, tx_dl_delay_3L.tx_dl_delay_3L
input  [31:0] tx_dl_delay_3L_tx_dl_delay_3L_i,
// register offset : 0x358, field offset : 0, access : RO, rx_dl_delay_3L.rx_dl_delay_3L
input  [31:0] rx_dl_delay_3L_rx_dl_delay_3L_i,
// register offset : 0x35c, field offset : 0, access : RO, dl_status_3L.rx_async_valid
input   dl_status_3L_rx_async_valid_i,
// register offset : 0x35c, field offset : 1, access : RO, dl_status_3L.rx_sync_valid
input   dl_status_3L_rx_sync_valid_i,
// register offset : 0x35c, field offset : 2, access : RO, dl_status_3L.tx_async_valid
input   dl_status_3L_tx_async_valid_i,
// register offset : 0x35c, field offset : 3, access : RO, dl_status_3L.tx_sync_valid
input   dl_status_3L_tx_sync_valid_i,
// register offset : 0x360, field offset : 0, access : RO, tx_sync_counter_4L.tx_sync_counter_4L
input  [31:0] tx_sync_counter_4L_tx_sync_counter_4L_i,
// register offset : 0x364, field offset : 0, access : RO, tx_async_counter_4L.tx_async_counter_4L
input  [31:0] tx_async_counter_4L_tx_async_counter_4L_i,
// register offset : 0x368, field offset : 0, access : RO, rx_sync_counter_4L.rx_sync_counter_4L
input  [31:0] rx_sync_counter_4L_rx_sync_counter_4L_i,
// register offset : 0x36c, field offset : 0, access : RO, rx_async_counter_4L.rx_async_counter_4L
input  [31:0] rx_async_counter_4L_rx_async_counter_4L_i,
// register offset : 0x370, field offset : 0, access : RO, dl_cfg_4L.rx_measure_valid
input   dl_cfg_4L_rx_measure_valid_i,
// register offset : 0x370, field offset : 1, access : RO, dl_cfg_4L.tx_measure_valid
input   dl_cfg_4L_tx_measure_valid_i,
// register offset : 0x370, field offset : 30, access : RW, dl_cfg_4L.rx_dl_restart
output  reg dl_cfg_4L_rx_dl_restart,
// register offset : 0x370, field offset : 31, access : RW, dl_cfg_4L.tx_dl_restart
output  reg dl_cfg_4L_tx_dl_restart,
// register offset : 0x374, field offset : 0, access : RO, tx_dl_delay_4L.tx_dl_delay_4L
input  [31:0] tx_dl_delay_4L_tx_dl_delay_4L_i,
// register offset : 0x378, field offset : 0, access : RO, rx_dl_delay_4L.rx_dl_delay_4L
input  [31:0] rx_dl_delay_4L_rx_dl_delay_4L_i,
// register offset : 0x37c, field offset : 0, access : RO, dl_status_4L.rx_async_valid
input   dl_status_4L_rx_async_valid_i,
// register offset : 0x37c, field offset : 1, access : RO, dl_status_4L.rx_sync_valid
input   dl_status_4L_rx_sync_valid_i,
// register offset : 0x37c, field offset : 2, access : RO, dl_status_4L.tx_async_valid
input   dl_status_4L_tx_async_valid_i,
// register offset : 0x37c, field offset : 3, access : RO, dl_status_4L.tx_sync_valid
input   dl_status_4L_tx_sync_valid_i,
// register offset : 0x380, field offset : 0, access : RO, tx_sync_counter_5L.tx_sync_counter_5L
input  [31:0] tx_sync_counter_5L_tx_sync_counter_5L_i,
// register offset : 0x384, field offset : 0, access : RO, tx_async_counter_5L.tx_async_counter_5L
input  [31:0] tx_async_counter_5L_tx_async_counter_5L_i,
// register offset : 0x388, field offset : 0, access : RO, rx_sync_counter_5L.rx_sync_counter_5L
input  [31:0] rx_sync_counter_5L_rx_sync_counter_5L_i,
// register offset : 0x38c, field offset : 0, access : RO, rx_async_counter_5L.rx_async_counter_5L
input  [31:0] rx_async_counter_5L_rx_async_counter_5L_i,
// register offset : 0x390, field offset : 0, access : RO, dl_cfg_5L.rx_measure_valid
input   dl_cfg_5L_rx_measure_valid_i,
// register offset : 0x390, field offset : 1, access : RO, dl_cfg_5L.tx_measure_valid
input   dl_cfg_5L_tx_measure_valid_i,
// register offset : 0x390, field offset : 30, access : RW, dl_cfg_5L.rx_dl_restart
output  reg dl_cfg_5L_rx_dl_restart,
// register offset : 0x390, field offset : 31, access : RW, dl_cfg_5L.tx_dl_restart
output  reg dl_cfg_5L_tx_dl_restart,
// register offset : 0x394, field offset : 0, access : RO, tx_dl_delay_5L.tx_dl_delay_5L
input  [31:0] tx_dl_delay_5L_tx_dl_delay_5L_i,
// register offset : 0x398, field offset : 0, access : RO, rx_dl_delay_5L.rx_dl_delay_5L
input  [31:0] rx_dl_delay_5L_rx_dl_delay_5L_i,
// register offset : 0x39c, field offset : 0, access : RO, dl_status_5L.rx_async_valid
input   dl_status_5L_rx_async_valid_i,
// register offset : 0x39c, field offset : 1, access : RO, dl_status_5L.rx_sync_valid
input   dl_status_5L_rx_sync_valid_i,
// register offset : 0x39c, field offset : 2, access : RO, dl_status_5L.tx_async_valid
input   dl_status_5L_tx_async_valid_i,
// register offset : 0x39c, field offset : 3, access : RO, dl_status_5L.tx_sync_valid
input   dl_status_5L_tx_sync_valid_i,
// register offset : 0x3a0, field offset : 0, access : RO, tx_sync_counter_6L.tx_sync_counter_6L
input  [31:0] tx_sync_counter_6L_tx_sync_counter_6L_i,
// register offset : 0x3a4, field offset : 0, access : RO, tx_async_counter_6L.tx_async_counter_6L
input  [31:0] tx_async_counter_6L_tx_async_counter_6L_i,
// register offset : 0x3a8, field offset : 0, access : RO, rx_sync_counter_6L.rx_sync_counter_6L
input  [31:0] rx_sync_counter_6L_rx_sync_counter_6L_i,
// register offset : 0x3ac, field offset : 0, access : RO, rx_async_counter_6L.rx_async_counter_6L
input  [31:0] rx_async_counter_6L_rx_async_counter_6L_i,
// register offset : 0x3b0, field offset : 0, access : RO, dl_cfg_6L.rx_measure_valid
input   dl_cfg_6L_rx_measure_valid_i,
// register offset : 0x3b0, field offset : 1, access : RO, dl_cfg_6L.tx_measure_valid
input   dl_cfg_6L_tx_measure_valid_i,
// register offset : 0x3b0, field offset : 30, access : RW, dl_cfg_6L.rx_dl_restart
output  reg dl_cfg_6L_rx_dl_restart,
// register offset : 0x3b0, field offset : 31, access : RW, dl_cfg_6L.tx_dl_restart
output  reg dl_cfg_6L_tx_dl_restart,
// register offset : 0x3b4, field offset : 0, access : RO, tx_dl_delay_6L.tx_dl_delay_6L
input  [31:0] tx_dl_delay_6L_tx_dl_delay_6L_i,
// register offset : 0x3b8, field offset : 0, access : RO, rx_dl_delay_6L.rx_dl_delay_6L
input  [31:0] rx_dl_delay_6L_rx_dl_delay_6L_i,
// register offset : 0x3bc, field offset : 0, access : RO, dl_status_6L.rx_async_valid
input   dl_status_6L_rx_async_valid_i,
// register offset : 0x3bc, field offset : 1, access : RO, dl_status_6L.rx_sync_valid
input   dl_status_6L_rx_sync_valid_i,
// register offset : 0x3bc, field offset : 2, access : RO, dl_status_6L.tx_async_valid
input   dl_status_6L_tx_async_valid_i,
// register offset : 0x3bc, field offset : 3, access : RO, dl_status_6L.tx_sync_valid
input   dl_status_6L_tx_sync_valid_i,
// register offset : 0x3c0, field offset : 0, access : RO, tx_sync_counter_7L.tx_sync_counter_7L
input  [31:0] tx_sync_counter_7L_tx_sync_counter_7L_i,
// register offset : 0x3c4, field offset : 0, access : RO, tx_async_counter_7L.tx_async_counter_7L
input  [31:0] tx_async_counter_7L_tx_async_counter_7L_i,
// register offset : 0x3c8, field offset : 0, access : RO, rx_sync_counter_7L.rx_sync_counter_7L
input  [31:0] rx_sync_counter_7L_rx_sync_counter_7L_i,
// register offset : 0x3cc, field offset : 0, access : RO, rx_async_counter_7L.rx_async_counter_7L
input  [31:0] rx_async_counter_7L_rx_async_counter_7L_i,
// register offset : 0x3d0, field offset : 0, access : RO, dl_cfg_7L.rx_measure_valid
input   dl_cfg_7L_rx_measure_valid_i,
// register offset : 0x3d0, field offset : 1, access : RO, dl_cfg_7L.tx_measure_valid
input   dl_cfg_7L_tx_measure_valid_i,
// register offset : 0x3d0, field offset : 30, access : RW, dl_cfg_7L.rx_dl_restart
output  reg dl_cfg_7L_rx_dl_restart,
// register offset : 0x3d0, field offset : 31, access : RW, dl_cfg_7L.tx_dl_restart
output  reg dl_cfg_7L_tx_dl_restart,
// register offset : 0x3d4, field offset : 0, access : RO, tx_dl_delay_7L.tx_dl_delay_7L
input  [31:0] tx_dl_delay_7L_tx_dl_delay_7L_i,
// register offset : 0x3d8, field offset : 0, access : RO, rx_dl_delay_7L.rx_dl_delay_7L
input  [31:0] rx_dl_delay_7L_rx_dl_delay_7L_i,
// register offset : 0x3dc, field offset : 0, access : RO, dl_status_7L.rx_async_valid
input   dl_status_7L_rx_async_valid_i,
// register offset : 0x3dc, field offset : 1, access : RO, dl_status_7L.rx_sync_valid
input   dl_status_7L_rx_sync_valid_i,
// register offset : 0x3dc, field offset : 2, access : RO, dl_status_7L.tx_async_valid
input   dl_status_7L_tx_async_valid_i,
// register offset : 0x3dc, field offset : 3, access : RO, dl_status_7L.tx_sync_valid
input   dl_status_7L_tx_sync_valid_i,
// register offset : 0x3e0, field offset : 0, access : RO, tx_sync_counter_8L.tx_sync_counter_8L
input  [31:0] tx_sync_counter_8L_tx_sync_counter_8L_i,
// register offset : 0x3e4, field offset : 0, access : RO, tx_async_counter_8L.tx_async_counter_8L
input  [31:0] tx_async_counter_8L_tx_async_counter_8L_i,
// register offset : 0x3e8, field offset : 0, access : RO, rx_sync_counter_8L.rx_sync_counter_8L
input  [31:0] rx_sync_counter_8L_rx_sync_counter_8L_i,
// register offset : 0x3ec, field offset : 0, access : RO, rx_async_counter_8L.rx_async_counter_8L
input  [31:0] rx_async_counter_8L_rx_async_counter_8L_i,
// register offset : 0x3f0, field offset : 0, access : RO, dl_cfg_8L.rx_measure_valid
input   dl_cfg_8L_rx_measure_valid_i,
// register offset : 0x3f0, field offset : 1, access : RO, dl_cfg_8L.tx_measure_valid
input   dl_cfg_8L_tx_measure_valid_i,
// register offset : 0x3f0, field offset : 30, access : RW, dl_cfg_8L.rx_dl_restart
output  reg dl_cfg_8L_rx_dl_restart,
// register offset : 0x3f0, field offset : 31, access : RW, dl_cfg_8L.tx_dl_restart
output  reg dl_cfg_8L_tx_dl_restart,
// register offset : 0x3f4, field offset : 0, access : RO, tx_dl_delay_8L.tx_dl_delay_8L
input  [31:0] tx_dl_delay_8L_tx_dl_delay_8L_i,
// register offset : 0x3f8, field offset : 0, access : RO, rx_dl_delay_8L.rx_dl_delay_8L
input  [31:0] rx_dl_delay_8L_rx_dl_delay_8L_i,
// register offset : 0x3fc, field offset : 0, access : RO, dl_status_8L.rx_async_valid
input   dl_status_8L_rx_async_valid_i,
// register offset : 0x3fc, field offset : 1, access : RO, dl_status_8L.rx_sync_valid
input   dl_status_8L_rx_sync_valid_i,
// register offset : 0x3fc, field offset : 2, access : RO, dl_status_8L.tx_async_valid
input   dl_status_8L_tx_async_valid_i,
// register offset : 0x3fc, field offset : 3, access : RO, dl_status_8L.tx_sync_valid
input   dl_status_8L_tx_sync_valid_i,
// register offset : 0x400, field offset : 0, access : RW, cwbin_control_register.cwbin_control_register
output  reg cwbin_control_register_cwbin_control_register,
// register offset : 0x404, field offset : 0, access : RO, cwbin0_A.cwbin0_A
input  [31:0] cwbin0_A_cwbin0_A_i,
// register offset : 0x408, field offset : 0, access : RO, cwbin1_A.cwbin1_A
input  [31:0] cwbin1_A_cwbin1_A_i,
// register offset : 0x40c, field offset : 0, access : RO, cwbin2_A.cwbin2_A
input  [31:0] cwbin2_A_cwbin2_A_i,
// register offset : 0x410, field offset : 0, access : RO, cwbin3_A.cwbin3_A
input  [31:0] cwbin3_A_cwbin3_A_i,
// register offset : 0x414, field offset : 0, access : RO, cwbin0_B.cwbin0_B
input  [31:0] cwbin0_B_cwbin0_B_i,
// register offset : 0x418, field offset : 0, access : RO, cwbin1_B.cwbin1_B
input  [31:0] cwbin1_B_cwbin1_B_i,
// register offset : 0x41c, field offset : 0, access : RO, cwbin2_B.cwbin2_B
input  [31:0] cwbin2_B_cwbin2_B_i,
// register offset : 0x420, field offset : 0, access : RO, cwbin3_B.cwbin3_B
input  [31:0] cwbin3_B_cwbin3_B_i,
// register offset : 0x424, field offset : 0, access : RW, cwbin_timer.cwbin_timer
output  reg[31:0] cwbin_timer_cwbin_timer,
//Pkt stats
output reg tx_pkt_sts_clr,
output reg rx_pkt_sts_clr,
output reg rx_lf_rf_pcs_clr,
input [31:0] tx_pkr_sop_cnt_lo,
input [15:0] tx_pkr_sop_cnt_hi,
input [31:0] tx_pkr_eop_cnt_lo,
input [15:0] tx_pkr_eop_cnt_hi,
input [31:0] tx_pkr_byte_cnt_lo,
input [31:0] tx_pkr_byte_cnt_hi,
input [31:0] tx_mac_sop_cnt_lo,
input [15:0] tx_mac_sop_cnt_hi,
input [31:0] tx_mac_eop_cnt_lo,
input [15:0] tx_mac_eop_cnt_hi,
input [31:0] tx_mac_byte_cnt_lo,
input [31:0] tx_mac_byte_cnt_hi,
input [31:0] rx_mac_sop_cnt_lo,
input [15:0] rx_mac_sop_cnt_hi,
input [31:0] rx_mac_eop_cnt_lo,
input [15:0] rx_mac_eop_cnt_hi,
input [31:0] rx_mac_byte_cnt_lo,
input [31:0] rx_mac_byte_cnt_hi,
input [05:0] tx_pkr_max_fifo_level,
input [05:0] tx_pkr_min_fifo_level,
input [03:0] tx_pkr_fifo_empty_cnt,
input [23:0] local_remote_pcs_cntr,
// regsiter offset : 0x500 - 0x53c packer and pause debug counters access:RO
input [31:0] packer_da_mismatch_cnt_in_lo   ,
input [31:0] packer_da_mismatch_cnt_in_hi   ,
input [31:0] packer_da_mismatch_cnt_out_lo  ,
input [31:0] packer_da_mismatch_cnt_out_hi  ,
input [31:0] packer_da_match_cnt_in_lo      ,
input [31:0] packer_da_match_cnt_in_hi      ,
input [31:0] packer_da_match_cnt_out_lo     ,
input [31:0] packer_da_match_cnt_out_hi     ,
input [31:0] tx_pause_da_mismatch_cnt_in_lo ,
input [31:0] tx_pause_da_mismatch_cnt_in_hi ,
input [31:0] tx_pause_da_mismatch_cnt_out_lo,
input [31:0] tx_pause_da_mismatch_cnt_out_hi,
input [31:0] tx_pause_da_match_cnt_in_lo    ,
input [31:0] tx_pause_da_match_cnt_in_hi    ,
input [31:0] tx_pause_da_match_cnt_out_lo   ,
input [31:0] tx_pause_da_match_cnt_out_hi   ,
// register offset : 0x600, field offset : 0, access : RW, cwbin_timer.cwbin_timer
output  reg[31:0] config_ehip_rst_count,
//Bus Interface
input clk,
input reset,
input [31:0] writedata,
input read,
input write,
input [3:0] byteenable,
output reg [31:0] readdata,
output reg readdatavalid,
input [10:0] address

);


wire reset_n = !reset;	
// Protocol management
// combinatorial read data signal declaration
reg [31:0] rdata_comb;
reg [31:0] config_ehip_rst_count_pwd;

// synchronous process for the read
always @(posedge clk)  
   if (!reset_n) readdata[31:0] <= 32'h0; else readdata[31:0] <= rdata_comb[31:0];

// read data is always returned on the next cycle
always @( posedge clk)
   if (!reset_n) readdatavalid <= 1'b0; else readdatavalid <= read;
//
//  Protocol specific assignment to inside signals
//
wire  we = write;
wire  re = read;
wire [10:0] addr = address[10:0];
wire [31:0] din  = writedata [31:0];
// A write byte enable for each register
// register qhip_scratch with  writeType: write
wire	[3:0]  we_qhip_scratch		=	we  & (addr[10:0]  == 11'h104)	?	byteenable[3:0]	:	{4{1'b0}};
// register eth_reset with  writeType: write
wire	[3:0]  we_eth_reset		=	we  & (addr[10:0]  == 11'h108)	?	byteenable[3:0]	:	{4{1'b0}};
// register pcs_control with  writeType: write
wire	  we_pcs_control		=	we  & (addr[10:0]  == 11'h11c)	?	byteenable[0]	:	1'b0;
// register rxmac_adapt_dropped_control with  writeType: write
wire	  we_rxmac_adapt_dropped_control		=	we  & (addr[10:0]  == 11'h148)	?	byteenable[0]	:	1'b0;
// register dl_cfg_1L with  writeType: write
wire	  we_dl_cfg_1L		=	we  & (addr[10:0]  == 11'h310)	?	byteenable[3]	:	1'b0;
// register dl_cfg_2L with  writeType: write
wire	  we_dl_cfg_2L		=	we  & (addr[10:0]  == 11'h330)	?	byteenable[3]	:	1'b0;
// register dl_cfg_3L with  writeType: write
wire	  we_dl_cfg_3L		=	we  & (addr[10:0]  == 11'h350)	?	byteenable[3]	:	1'b0;
// register dl_cfg_4L with  writeType: write
wire	  we_dl_cfg_4L		=	we  & (addr[10:0]  == 11'h370)	?	byteenable[3]	:	1'b0;
// register dl_cfg_5L with  writeType: write
wire	  we_dl_cfg_5L		=	we  & (addr[10:0]  == 11'h390)	?	byteenable[3]	:	1'b0;
// register dl_cfg_6L with  writeType: write
wire	  we_dl_cfg_6L		=	we  & (addr[10:0]  == 11'h3b0)	?	byteenable[3]	:	1'b0;
// register dl_cfg_7L with  writeType: write
wire	  we_dl_cfg_7L		=	we  & (addr[10:0]  == 11'h3d0)	?	byteenable[3]	:	1'b0;
// register dl_cfg_8L with  writeType: write
wire	  we_dl_cfg_8L		=	we  & (addr[10:0]  == 11'h3f0)	?	byteenable[3]	:	1'b0;
// register cwbin_control_register with  writeType: write
wire	  we_cwbin_control_register		=	we  & (addr[10:0]  == 11'h400)	?	byteenable[0]	:	1'b0;
// register cwbin_timer with  writeType: write
wire	[3:0]  we_cwbin_timer		=	we  & (addr[10:0]  == 11'h424)	?	byteenable[3:0]	:	{4{1'b0}};
wire	       we_pkt_sts_clr		=	we  & (addr[10:0]  == 11'h430)	?	byteenable[0]	:	{1{1'b0}};
wire	[3:0]  we_config_ehip_rst_count		=	we  & (addr[10:0]  == 11'h600) & (config_ehip_rst_count_pwd == 32'hFACEC0DE)	?	byteenable[3:0]	:	{4{1'b0}};
wire	[3:0]  we_config_ehip_rst_count_pwd	=	we  & (addr[10:0]  == 11'h604)	?  byteenable[3:0]	:	{4{1'b0}};

// A read byte enable for each register

/* Definitions of REGISTER "gui_option" */

// gui_option_device_name
// bitfield description: Device name
// 0:Stratix 10, 1:Falcon Mesa.
// customType:  RO
// hwAccess: RO 
// reset value : 0x1 
// NO register generated



// gui_option_tile_name
// bitfield description: Tile name
// 0:H-tile,1:L-tile,2:E-tile,3:F-tile, 4-7:reserved
// customType:  RO
// hwAccess: RO 
// reset value : 0x3 
// NO register generated



// gui_option_eth_rate
// bitfield description: Ethernet Rate
// 0:10G, 1:25G, 2:40G, 3:50G, 4:100G, 5:200G, 6:400G
// customType:  RO
// hwAccess: WO 
// reset value : 0x1 
// inputPort: gui_option_eth_rate_i 
// outputPort:  "" 
// NO register generated




// gui_option_anlt_enable
// bitfield description: AN/LT Enabled?
// 0:AN/LT is disabled, 1:AN/LT is enabled
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: gui_option_anlt_enable_i 
// outputPort:  "" 
// NO register generated




// gui_option_modulation_type
// bitfield description: Modulation type
// 0:NRZ, 1:PAM-4
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: gui_option_modulation_type_i 
// outputPort:  "" 
// NO register generated




// gui_option_rsfec_type
// bitfield description: RSFEC type
// 0:None 1:Fire Code (Clause 74), 2:RS(528,514), 3:RS(544,514), 4:Low Latency
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: gui_option_rsfec_type_i 
// outputPort:  "" 
// NO register generated




// gui_option_ptp_enable
// bitfield description: 1588 PTP Enabled?
// 0:1588 PTP is disabled, 1:1588 PTP is enabled
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: gui_option_ptp_enable_i 
// outputPort:  "" 
// NO register generated




// gui_option_flow_control_mode
// bitfield description: Flow control mode
// 0:Disabled, 1:SFC, 2:SFC with no XOFF, 3:PFC, 4:PFC with no XOFF, 5:Both SFC and PFC, 6:Both SFC and PFC wit no XOFF, 7:RX SFC Disabled
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: gui_option_flow_control_mode_i 
// outputPort:  "" 
// NO register generated




// gui_option_client_intf
// bitfield description: Client Interface
// 0: MAC Segemented Interface, 1: MAC Avalon Streaming Interface, 2: PCS Interface, 3: OTN interface, 4: FlexE Interface
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: gui_option_client_intf_i 
// outputPort:  "" 
// NO register generated




// gui_option_xcvr_type
// bitfield description: XCVR Type
// 0: UX, 1: BK
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: gui_option_xcvr_type_i 
// outputPort:  "" 
// NO register generated




// gui_option_num_lanes
// bitfield description: Numbner of Lanes
// 1: 1 lane, 2: 2 lanes, 4: 4 lanes, 8: 8 lanes
// customType:  RO
// hwAccess: WO 
// reset value : 0x1 
// inputPort: gui_option_num_lanes_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "qhip_scratch" */

// qhip_scratch_scratch
// customType:  RW
// hwAccess: NA 
// reset value : 0x00000000 

reg [31:0] qhip_scratch_scratch; // 

always @( posedge clk)
   if (!reset_n)  begin
      qhip_scratch_scratch <= 32'h00000000;
   end
   else begin
   if (we_qhip_scratch[0]) begin 
      qhip_scratch_scratch[7:0]   <=  din[7:0];  //
   end
   if (we_qhip_scratch[1]) begin 
      qhip_scratch_scratch[15:8]   <=  din[15:8];  //
   end
   if (we_qhip_scratch[2]) begin 
      qhip_scratch_scratch[23:16]   <=  din[23:16];  //
   end
   if (we_qhip_scratch[3]) begin 
      qhip_scratch_scratch[31:24]   <=  din[31:24];  //
   end
end
/* Definitions of REGISTER "eth_reset" */

// eth_reset_eio_sys_rst
// bitfield description: Soft Global Reset
// 1: Global Reset (reset datapath and all CSR registers)
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      eth_reset_eio_sys_rst <= 1'h0;
   end
   else begin
   if (we_eth_reset[0]) begin 
      eth_reset_eio_sys_rst   <=  din[0];  //
   end
end

// eth_reset_soft_tx_rst
// bitfield description: Soft TX Reset
// 1:Reset the TX datapath
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      eth_reset_soft_tx_rst <= 1'h0;
   end
   else begin
   if (we_eth_reset[0]) begin 
      eth_reset_soft_tx_rst   <=  din[1];  //
   end
end

// eth_reset_soft_rx_rst
// bitfield description: Soft RX Reset
// 1:Reset the RX datapath
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      eth_reset_soft_rx_rst <= 1'h0;
   end
   else begin
   if (we_eth_reset[0]) begin 
      eth_reset_soft_rx_rst   <=  din[2];  //
   end
end

// eth_reset_tx_clear_alarm
// bitfield description: Clear TX Reset Alarm
// 1:Clear TX Reset Alarm indication for transceiver lane
// customType:  RW
// hwAccess: RO 
// reset value : 0x00 


always @( posedge clk)
   if (!reset_n)  begin
      eth_reset_tx_clear_alarm <= 8'h00;
   end
   else begin
   if (we_eth_reset[2]) begin 
      eth_reset_tx_clear_alarm[7:0]   <=  din[23:16];  //
   end
end

// eth_reset_rx_clear_alarm
// bitfield description: Clear RX Reset Alarm
// 1:Clear RX Reset Alarm indication for transceiver lane
// customType:  RW
// hwAccess: RO 
// reset value : 0x00 


always @( posedge clk)
   if (!reset_n)  begin
      eth_reset_rx_clear_alarm <= 8'h00;
   end
   else begin
   if (we_eth_reset[3]) begin 
      eth_reset_rx_clear_alarm[7:0]   <=  din[31:24];  //
   end
end
/* Definitions of REGISTER "eth_reset_status" */

// eth_reset_status_rst_ack_n
// bitfield description: Global Reset acknowledge. Active low (either the hard reset or the Global Soft Reset)
// 1:acknowledge the reset completed.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: eth_reset_status_rst_ack_n_i 
// outputPort:  "" 
// NO register generated




// eth_reset_status_tx_rst_ack_n
// bitfield description: TX Reset acknowledge. Active low (either the hard tx reset or the soft_tx_rst )
// 1:acknowledge the reset completed.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: eth_reset_status_tx_rst_ack_n_i 
// outputPort:  "" 
// NO register generated




// eth_reset_status_rx_rst_ack_n
// bitfield description: RX Reset acknowledge. Active high (either the hard rx reset or the soft_rx_rst )
// 1:acknowledge the reset completed.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: eth_reset_status_rx_rst_ack_n_i 
// outputPort:  "" 
// NO register generated




// eth_reset_status_tx_lane_current_state
// bitfield description: TX Lane Current State
// Current reset state for TX xcvrs & datapath:
// [0]: Fully in reset state
// [1]: Fully out of reset state (operational)
// Reset control initialized (system clock stable)
// If not fully in reset or out of reset, TX reset is currently transitioning
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: eth_reset_status_tx_lane_current_state_i 
// outputPort:  "" 
// NO register generated




// eth_reset_status_rx_lane_current_state
// bitfield description: RX Lane Current State
// Current reset state for RX xcvrs & datapath:
// [0]: Fully in reset state
// [1]: Fully out of reset state (operational)
// Reset control initialized (system clock stable)
// If not fully in reset or out of reset, RX reset is currently transitioning
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: eth_reset_status_rx_lane_current_state_i 
// outputPort:  "" 
// NO register generated




// eth_reset_status_tx_alarm
// bitfield description: TX Reset Alarm
// 1:TX Reset Alarm indication for transceiver lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00 
// inputPort: eth_reset_status_tx_alarm_i 
// outputPort:  "" 
// NO register generated




// eth_reset_status_rx_alarm
// bitfield description: RX Reset Alarm
// 1:RX Reset Alarm indication for transceiver lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00 
// inputPort: eth_reset_status_rx_alarm_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "phy_tx_pll_locked" */

// phy_tx_pll_locked_tx_pll_locked
// bitfield description: TX PLL Locked
// 1=TX PLL used by this lane physical lane is locked
// customType:  RO
// hwAccess: WO 
// reset value : 0x00 
// inputPort: phy_tx_pll_locked_tx_pll_locked_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "phy_eiofreq_locked" */

// phy_eiofreq_locked_eio_freq_lock
// bitfield description: CDR PLL locked
// 1:Corresponding physical lane's CDR has locked to reference
// customType:  RO
// hwAccess: WO 
// reset value : 0x00 
// inputPort: phy_eiofreq_locked_eio_freq_lock_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "pcs_status" */

// pcs_status_dskew_status
// bitfield description: Deskewed status
// 1:RX AIB is deskewed
// 0:RX AIB is not currently deskewed. Note that there is some latency between this status bit and the actual state
// 
// 
// Not valid for single lane channels (10G/25G) without PTP
// Note that this bit is not sticky - we recommend using a soft logic replacement for this bit that can be made sticky based on the deskew_done port
// customType:  RO
// hwAccess: WO 
// reset value : 1'bx 
// inputPort: pcs_status_dskew_status_i 
// outputPort:  "" 
// NO register generated




// pcs_status_dskew_chng
// bitfield description: Change in deskewed status
// 1:RX AIB went from deskewed to not deskewed, or from not deskewed to deskewed
// 
// 
// Not valid for single lane channels (10G/25G) without PTP
// This bit is sticky - use pcs_control.clr_dskew_chng to set this bit back to 0
// Resetting the RX datapath, or the entire core will also clear the bit
// customType:  RO
// hwAccess: WO 
// reset value : 1'bx 
// inputPort: pcs_status_dskew_chng_i 
// outputPort:  "" 
// NO register generated




// pcs_status_tx_lanes_stable
// bitfield description: TX Lanes Stable
// 1:TX Datapath is ready
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: pcs_status_tx_lanes_stable_i 
// outputPort:  "" 
// NO register generated




// pcs_status_rx_pcs_ready
// bitfield description: RX PCS Ready
// 1:RX Datapath is ready
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: pcs_status_rx_pcs_ready_i 
// outputPort:  "" 
// NO register generated




// pcs_status_kr_mode
// bitfield description: KR Mode
// 1:Port is currently executing in AN/LT mode
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: pcs_status_kr_mode_i 
// outputPort:  "" 
// NO register generated




// pcs_status_kr_fec_mode
// bitfield description: KR FEC mode
// 1:AN has negotiated FEC enable mode
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: pcs_status_kr_fec_mode_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "pcs_control" */

// pcs_control_clr_dskew_chng
// bitfield description: Clear AIB Deskew Change Sticky Bit
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      pcs_control_clr_dskew_chng <= 1'h0;
   end
   else begin
   if (we_pcs_control) begin 
      pcs_control_clr_dskew_chng   <=  din[0];  //
   end
end
/* Definitions of REGISTER "link_fault_status" */

// link_fault_status_lfault
// bitfield description: Local Fault detected
// 1:EHIP detected a local fault
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: link_fault_status_lfault_i 
// outputPort:  "" 
// NO register generated




// link_fault_status_rfault
// bitfield description: Remote Fault detected
// 1:EHIP detected a remote fault
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: link_fault_status_rfault_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "aib_transfer_ready_status" */

// aib_transfer_ready_status_ehip_rx_transfer_ready
// bitfield description: EHIP RX channels Transfer ready status.
// 1:transfer_ready. For example, the 100G case, the bit3 to bit0 are valid. The 25G case, the bit0 is valid only. For 400G case, bit[15:0] are all valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000 
// inputPort: aib_transfer_ready_status_ehip_rx_transfer_ready_i 
// outputPort:  "" 
// NO register generated




// aib_transfer_ready_status_ehip_tx_transfer_ready
// bitfield description: EHIP TX channels Transfer ready status.
// 1:transfer_ready. For example, the 100G case, the bit3 to bit0 are valid. The 25G case, the bit0 is valid only. For 400G case, bit[15:0] are all valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000 
// inputPort: aib_transfer_ready_status_ehip_tx_transfer_ready_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "clk_tx_khz" */

// clk_tx_khz_clk_tx_khz
// bitfield description: i_clk_tx clock frequency in KHz
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: clk_tx_khz_clk_tx_khz_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "clk_rx_khz" */

// clk_rx_khz_clk_rx_khz
// bitfield description: i_clk_rx clock frequency in KHz
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: clk_rx_khz_clk_rx_khz_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "clk_pll_khz" */

// clk_pll_khz_clk_pll_khz
// bitfield description: o_clk_pll clock frequency in KHz
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: clk_pll_khz_clk_pll_khz_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "clk_tx_div_khz" */

// clk_tx_div_khz_clk_tx_div_khz
// bitfield description: o_clk_tx_div clock frequency in KHz
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: clk_tx_div_khz_clk_tx_div_khz_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "clk_rec_div64_khz" */

// clk_rec_div64_khz_clk_rec_div64_khz
// bitfield description: o_clk_rec_div64 clock frequency in KHz
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: clk_rec_div64_khz_clk_rec_div64_khz_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "clk_rec_div_khz" */

// clk_rec_div_khz_clk_rec_div_khz
// bitfield description: o_clk_rec_div clock frequency in KHz
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: clk_rec_div_khz_clk_rec_div_khz_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rxmac_adapt_dropped_31_0" */

// rxmac_adapt_dropped_31_0_rxmac_adapt_dropped_31_0
// bitfield description: RXMAC adapter dropped frame counter lower bits
// bit 31-0 of RXMAC adapter dropped frame counter
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rxmac_adapt_dropped_31_0_rxmac_adapt_dropped_31_0_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rxmac_adapt_dropped_63_32" */

// rxmac_adapt_dropped_63_32_rxmac_adapt_dropped_63_32
// bitfield description: RXMAC adapter dropped frame counter upper bits
// bit 63-32 of RXMAC adapter dropped frame counter
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rxmac_adapt_dropped_63_32_rxmac_adapt_dropped_63_32_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rxmac_adapt_dropped_control" */

// rxmac_adapt_dropped_control_rxmac_adapt_dropped_clear
// bitfield description: Clear RXMAC adapter dropped counter
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      rxmac_adapt_dropped_control_rxmac_adapt_dropped_clear <= 1'h0;
   end
   else begin
   if (we_rxmac_adapt_dropped_control) begin 
      rxmac_adapt_dropped_control_rxmac_adapt_dropped_clear   <=  din[0];  //
   end
end

// rxmac_adapt_dropped_control_rxmac_adapt_dropped_snapshot
// bitfield description: Snapshot RXMAC adapter dropped counter
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      rxmac_adapt_dropped_control_rxmac_adapt_dropped_snapshot <= 1'h0;
   end
   else begin
   if (we_rxmac_adapt_dropped_control) begin 
      rxmac_adapt_dropped_control_rxmac_adapt_dropped_snapshot   <=  din[1];  //
   end
end
/* Definitions of REGISTER "tx_sync_counter_1L" */

// tx_sync_counter_1L_tx_sync_counter_1L
// bitfield description: tx_sync_counter_1L 
// TX synchronous counter value. Must be qualified with tx_sync_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_sync_counter_1L_tx_sync_counter_1L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "tx_async_counter_1L" */

// tx_async_counter_1L_tx_async_counter_1L
// bitfield description: tx_async_counter_1L 
// TX asynchronous counter value. Must be qualified with tx_async_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_async_counter_1L_tx_async_counter_1L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_sync_counter_1L" */

// rx_sync_counter_1L_rx_sync_counter_1L
// bitfield description: rx_sync_counter_1L 
// RX synchronous counter value. Must be qualified with rx_sync_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_sync_counter_1L_rx_sync_counter_1L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_async_counter_1L" */

// rx_async_counter_1L_rx_async_counter_1L
// bitfield description: rx_async_counter_1L 
// RX asynchronous counter value. Must be qualified with rx_async_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_async_counter_1L_rx_async_counter_1L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "dl_cfg_1L" */

// dl_cfg_1L_rx_measure_valid
// bitfield description: Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_cfg_1L_rx_measure_valid_i 
// outputPort:  "" 
// NO register generated




// dl_cfg_1L_tx_measure_valid
// bitfield description: Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. 
// Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_cfg_1L_tx_measure_valid_i 
// outputPort:  "" 
// NO register generated




// dl_cfg_1L_rx_dl_restart
// bitfield description: Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dl_cfg_1L_rx_dl_restart <= 1'h0;
   end
   else begin
   if (we_dl_cfg_1L) begin 
      dl_cfg_1L_rx_dl_restart   <=  din[30];  //
   end
end

// dl_cfg_1L_tx_dl_restart
// bitfield description: Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dl_cfg_1L_tx_dl_restart <= 1'h0;
   end
   else begin
   if (we_dl_cfg_1L) begin 
      dl_cfg_1L_tx_dl_restart   <=  din[31];  //
   end
end
/* Definitions of REGISTER "tx_dl_delay_1L" */

// tx_dl_delay_1L_tx_dl_delay_1L
// bitfield description: Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid. 
// Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_dl_delay_1L_tx_dl_delay_1L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_dl_delay_1L" */

// rx_dl_delay_1L_rx_dl_delay_1L
// bitfield description: Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid. 
// Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_dl_delay_1L_rx_dl_delay_1L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "dl_status_1L" */

// dl_status_1L_rx_async_valid
// bitfield description: Indicates whether RX asynchronous counter values are valid: - 0: Invalid - 1: Valid
// Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_1L_rx_async_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_1L_rx_sync_valid
// bitfield description: Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. 
// Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_1L_rx_sync_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_1L_tx_async_valid
// bitfield description: Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_1L_tx_async_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_1L_tx_sync_valid
// bitfield description: Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_1L_tx_sync_valid_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "tx_sync_counter_2L" */

// tx_sync_counter_2L_tx_sync_counter_2L
// bitfield description: tx_sync_counter_1L 
// TX synchronous counter value. Must be qualified with tx_sync_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_sync_counter_2L_tx_sync_counter_2L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "tx_async_counter_2L" */

// tx_async_counter_2L_tx_async_counter_2L
// bitfield description: tx_async_counter_1L 
// TX asynchronous counter value. Must be qualified with tx_async_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_async_counter_2L_tx_async_counter_2L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_sync_counter_2L" */

// rx_sync_counter_2L_rx_sync_counter_2L
// bitfield description: rx_sync_counter_1L 
// RX synchronous counter value. Must be qualified with rx_sync_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_sync_counter_2L_rx_sync_counter_2L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_async_counter_2L" */

// rx_async_counter_2L_rx_async_counter_2L
// bitfield description: rx_async_counter_1L 
// RX asynchronous counter value. Must be qualified with rx_async_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_async_counter_2L_rx_async_counter_2L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "dl_cfg_2L" */

// dl_cfg_2L_rx_measure_valid
// bitfield description: Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_cfg_2L_rx_measure_valid_i 
// outputPort:  "" 
// NO register generated




// dl_cfg_2L_tx_measure_valid
// bitfield description: Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. 
// Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_cfg_2L_tx_measure_valid_i 
// outputPort:  "" 
// NO register generated




// dl_cfg_2L_rx_dl_restart
// bitfield description: Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dl_cfg_2L_rx_dl_restart <= 1'h0;
   end
   else begin
   if (we_dl_cfg_2L) begin 
      dl_cfg_2L_rx_dl_restart   <=  din[30];  //
   end
end

// dl_cfg_2L_tx_dl_restart
// bitfield description: Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dl_cfg_2L_tx_dl_restart <= 1'h0;
   end
   else begin
   if (we_dl_cfg_2L) begin 
      dl_cfg_2L_tx_dl_restart   <=  din[31];  //
   end
end
/* Definitions of REGISTER "tx_dl_delay_2L" */

// tx_dl_delay_2L_tx_dl_delay_2L
// bitfield description: Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid. 
// Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_dl_delay_2L_tx_dl_delay_2L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_dl_delay_2L" */

// rx_dl_delay_2L_rx_dl_delay_2L
// bitfield description: Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid. 
// Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_dl_delay_2L_rx_dl_delay_2L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "dl_status_2L" */

// dl_status_2L_rx_async_valid
// bitfield description: Indicates whether RX asynchronous counter values are valid: - 0: Invalid - 1: Valid
// Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_2L_rx_async_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_2L_rx_sync_valid
// bitfield description: Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. 
// Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_2L_rx_sync_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_2L_tx_async_valid
// bitfield description: Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_2L_tx_async_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_2L_tx_sync_valid
// bitfield description: Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_2L_tx_sync_valid_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "tx_sync_counter_3L" */

// tx_sync_counter_3L_tx_sync_counter_3L
// bitfield description: tx_sync_counter_1L 
// TX synchronous counter value. Must be qualified with tx_sync_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_sync_counter_3L_tx_sync_counter_3L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "tx_async_counter_3L" */

// tx_async_counter_3L_tx_async_counter_3L
// bitfield description: tx_async_counter_1L 
// TX asynchronous counter value. Must be qualified with tx_async_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_async_counter_3L_tx_async_counter_3L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_sync_counter_3L" */

// rx_sync_counter_3L_rx_sync_counter_3L
// bitfield description: rx_sync_counter_1L 
// RX synchronous counter value. Must be qualified with rx_sync_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_sync_counter_3L_rx_sync_counter_3L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_async_counter_3L" */

// rx_async_counter_3L_rx_async_counter_3L
// bitfield description: rx_async_counter_1L 
// RX asynchronous counter value. Must be qualified with rx_async_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_async_counter_3L_rx_async_counter_3L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "dl_cfg_3L" */

// dl_cfg_3L_rx_measure_valid
// bitfield description: Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_cfg_3L_rx_measure_valid_i 
// outputPort:  "" 
// NO register generated




// dl_cfg_3L_tx_measure_valid
// bitfield description: Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. 
// Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_cfg_3L_tx_measure_valid_i 
// outputPort:  "" 
// NO register generated




// dl_cfg_3L_rx_dl_restart
// bitfield description: Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dl_cfg_3L_rx_dl_restart <= 1'h0;
   end
   else begin
   if (we_dl_cfg_3L) begin 
      dl_cfg_3L_rx_dl_restart   <=  din[30];  //
   end
end

// dl_cfg_3L_tx_dl_restart
// bitfield description: Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dl_cfg_3L_tx_dl_restart <= 1'h0;
   end
   else begin
   if (we_dl_cfg_3L) begin 
      dl_cfg_3L_tx_dl_restart   <=  din[31];  //
   end
end
/* Definitions of REGISTER "tx_dl_delay_3L" */

// tx_dl_delay_3L_tx_dl_delay_3L
// bitfield description: Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid. 
// Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_dl_delay_3L_tx_dl_delay_3L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_dl_delay_3L" */

// rx_dl_delay_3L_rx_dl_delay_3L
// bitfield description: Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid. 
// Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_dl_delay_3L_rx_dl_delay_3L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "dl_status_3L" */

// dl_status_3L_rx_async_valid
// bitfield description: Indicates whether RX asynchronous counter values are valid: - 0: Invalid - 1: Valid
// Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_3L_rx_async_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_3L_rx_sync_valid
// bitfield description: Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. 
// Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_3L_rx_sync_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_3L_tx_async_valid
// bitfield description: Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_3L_tx_async_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_3L_tx_sync_valid
// bitfield description: Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_3L_tx_sync_valid_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "tx_sync_counter_4L" */

// tx_sync_counter_4L_tx_sync_counter_4L
// bitfield description: tx_sync_counter_1L 
// TX synchronous counter value. Must be qualified with tx_sync_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_sync_counter_4L_tx_sync_counter_4L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "tx_async_counter_4L" */

// tx_async_counter_4L_tx_async_counter_4L
// bitfield description: tx_async_counter_1L 
// TX asynchronous counter value. Must be qualified with tx_async_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_async_counter_4L_tx_async_counter_4L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_sync_counter_4L" */

// rx_sync_counter_4L_rx_sync_counter_4L
// bitfield description: rx_sync_counter_1L 
// RX synchronous counter value. Must be qualified with rx_sync_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_sync_counter_4L_rx_sync_counter_4L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_async_counter_4L" */

// rx_async_counter_4L_rx_async_counter_4L
// bitfield description: rx_async_counter_1L 
// RX asynchronous counter value. Must be qualified with rx_async_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_async_counter_4L_rx_async_counter_4L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "dl_cfg_4L" */

// dl_cfg_4L_rx_measure_valid
// bitfield description: Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_cfg_4L_rx_measure_valid_i 
// outputPort:  "" 
// NO register generated




// dl_cfg_4L_tx_measure_valid
// bitfield description: Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. 
// Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_cfg_4L_tx_measure_valid_i 
// outputPort:  "" 
// NO register generated




// dl_cfg_4L_rx_dl_restart
// bitfield description: Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dl_cfg_4L_rx_dl_restart <= 1'h0;
   end
   else begin
   if (we_dl_cfg_4L) begin 
      dl_cfg_4L_rx_dl_restart   <=  din[30];  //
   end
end

// dl_cfg_4L_tx_dl_restart
// bitfield description: Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dl_cfg_4L_tx_dl_restart <= 1'h0;
   end
   else begin
   if (we_dl_cfg_4L) begin 
      dl_cfg_4L_tx_dl_restart   <=  din[31];  //
   end
end
/* Definitions of REGISTER "tx_dl_delay_4L" */

// tx_dl_delay_4L_tx_dl_delay_4L
// bitfield description: Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid. 
// Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_dl_delay_4L_tx_dl_delay_4L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_dl_delay_4L" */

// rx_dl_delay_4L_rx_dl_delay_4L
// bitfield description: Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid. 
// Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_dl_delay_4L_rx_dl_delay_4L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "dl_status_4L" */

// dl_status_4L_rx_async_valid
// bitfield description: Indicates whether RX asynchronous counter values are valid: - 0: Invalid - 1: Valid
// Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_4L_rx_async_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_4L_rx_sync_valid
// bitfield description: Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. 
// Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_4L_rx_sync_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_4L_tx_async_valid
// bitfield description: Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_4L_tx_async_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_4L_tx_sync_valid
// bitfield description: Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_4L_tx_sync_valid_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "tx_sync_counter_5L" */

// tx_sync_counter_5L_tx_sync_counter_5L
// bitfield description: tx_sync_counter_1L 
// TX synchronous counter value. Must be qualified with tx_sync_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_sync_counter_5L_tx_sync_counter_5L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "tx_async_counter_5L" */

// tx_async_counter_5L_tx_async_counter_5L
// bitfield description: tx_async_counter_1L 
// TX asynchronous counter value. Must be qualified with tx_async_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_async_counter_5L_tx_async_counter_5L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_sync_counter_5L" */

// rx_sync_counter_5L_rx_sync_counter_5L
// bitfield description: rx_sync_counter_1L 
// RX synchronous counter value. Must be qualified with rx_sync_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_sync_counter_5L_rx_sync_counter_5L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_async_counter_5L" */

// rx_async_counter_5L_rx_async_counter_5L
// bitfield description: rx_async_counter_1L 
// RX asynchronous counter value. Must be qualified with rx_async_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_async_counter_5L_rx_async_counter_5L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "dl_cfg_5L" */

// dl_cfg_5L_rx_measure_valid
// bitfield description: Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_cfg_5L_rx_measure_valid_i 
// outputPort:  "" 
// NO register generated




// dl_cfg_5L_tx_measure_valid
// bitfield description: Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. 
// Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_cfg_5L_tx_measure_valid_i 
// outputPort:  "" 
// NO register generated




// dl_cfg_5L_rx_dl_restart
// bitfield description: Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dl_cfg_5L_rx_dl_restart <= 1'h0;
   end
   else begin
   if (we_dl_cfg_5L) begin 
      dl_cfg_5L_rx_dl_restart   <=  din[30];  //
   end
end

// dl_cfg_5L_tx_dl_restart
// bitfield description: Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dl_cfg_5L_tx_dl_restart <= 1'h0;
   end
   else begin
   if (we_dl_cfg_5L) begin 
      dl_cfg_5L_tx_dl_restart   <=  din[31];  //
   end
end
/* Definitions of REGISTER "tx_dl_delay_5L" */

// tx_dl_delay_5L_tx_dl_delay_5L
// bitfield description: Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid. 
// Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_dl_delay_5L_tx_dl_delay_5L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_dl_delay_5L" */

// rx_dl_delay_5L_rx_dl_delay_5L
// bitfield description: Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid. 
// Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_dl_delay_5L_rx_dl_delay_5L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "dl_status_5L" */

// dl_status_5L_rx_async_valid
// bitfield description: Indicates whether RX asynchronous counter values are valid: - 0: Invalid - 1: Valid
// Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_5L_rx_async_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_5L_rx_sync_valid
// bitfield description: Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. 
// Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_5L_rx_sync_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_5L_tx_async_valid
// bitfield description: Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_5L_tx_async_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_5L_tx_sync_valid
// bitfield description: Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_5L_tx_sync_valid_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "tx_sync_counter_6L" */

// tx_sync_counter_6L_tx_sync_counter_6L
// bitfield description: tx_sync_counter_1L 
// TX synchronous counter value. Must be qualified with tx_sync_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_sync_counter_6L_tx_sync_counter_6L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "tx_async_counter_6L" */

// tx_async_counter_6L_tx_async_counter_6L
// bitfield description: tx_async_counter_1L 
// TX asynchronous counter value. Must be qualified with tx_async_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_async_counter_6L_tx_async_counter_6L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_sync_counter_6L" */

// rx_sync_counter_6L_rx_sync_counter_6L
// bitfield description: rx_sync_counter_6L 
// RX synchronous counter value. Must be qualified with rx_sync_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_sync_counter_6L_rx_sync_counter_6L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_async_counter_6L" */

// rx_async_counter_6L_rx_async_counter_6L
// bitfield description: rx_async_counter_6L 
// RX asynchronous counter value. Must be qualified with rx_async_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_async_counter_6L_rx_async_counter_6L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "dl_cfg_6L" */

// dl_cfg_6L_rx_measure_valid
// bitfield description: Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_cfg_6L_rx_measure_valid_i 
// outputPort:  "" 
// NO register generated




// dl_cfg_6L_tx_measure_valid
// bitfield description: Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. 
// Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_cfg_6L_tx_measure_valid_i 
// outputPort:  "" 
// NO register generated




// dl_cfg_6L_rx_dl_restart
// bitfield description: Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dl_cfg_6L_rx_dl_restart <= 1'h0;
   end
   else begin
   if (we_dl_cfg_6L) begin 
      dl_cfg_6L_rx_dl_restart   <=  din[30];  //
   end
end

// dl_cfg_6L_tx_dl_restart
// bitfield description: Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dl_cfg_6L_tx_dl_restart <= 1'h0;
   end
   else begin
   if (we_dl_cfg_6L) begin 
      dl_cfg_6L_tx_dl_restart   <=  din[31];  //
   end
end
/* Definitions of REGISTER "tx_dl_delay_6L" */

// tx_dl_delay_6L_tx_dl_delay_6L
// bitfield description: Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid. 
// Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_dl_delay_6L_tx_dl_delay_6L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_dl_delay_6L" */

// rx_dl_delay_6L_rx_dl_delay_6L
// bitfield description: Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid. 
// Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_dl_delay_6L_rx_dl_delay_6L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "dl_status_6L" */

// dl_status_6L_rx_async_valid
// bitfield description: Indicates whether RX asynchronous counter values are valid: - 0: Invalid - 1: Valid
// Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_6L_rx_async_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_6L_rx_sync_valid
// bitfield description: Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. 
// Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_6L_rx_sync_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_6L_tx_async_valid
// bitfield description: Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_6L_tx_async_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_6L_tx_sync_valid
// bitfield description: Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_6L_tx_sync_valid_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "tx_sync_counter_7L" */

// tx_sync_counter_7L_tx_sync_counter_7L
// bitfield description: tx_sync_counter_1L 
// TX synchronous counter value. Must be qualified with tx_sync_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_sync_counter_7L_tx_sync_counter_7L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "tx_async_counter_7L" */

// tx_async_counter_7L_tx_async_counter_7L
// bitfield description: tx_async_counter_1L 
// TX asynchronous counter value. Must be qualified with tx_async_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_async_counter_7L_tx_async_counter_7L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_sync_counter_7L" */

// rx_sync_counter_7L_rx_sync_counter_7L
// bitfield description: rx_sync_counter_1L 
// RX synchronous counter value. Must be qualified with rx_sync_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_sync_counter_7L_rx_sync_counter_7L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_async_counter_7L" */

// rx_async_counter_7L_rx_async_counter_7L
// bitfield description: rx_async_counter_1L 
// RX asynchronous counter value. Must be qualified with rx_async_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_async_counter_7L_rx_async_counter_7L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "dl_cfg_7L" */

// dl_cfg_7L_rx_measure_valid
// bitfield description: Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_cfg_7L_rx_measure_valid_i 
// outputPort:  "" 
// NO register generated




// dl_cfg_7L_tx_measure_valid
// bitfield description: Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. 
// Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_cfg_7L_tx_measure_valid_i 
// outputPort:  "" 
// NO register generated




// dl_cfg_7L_rx_dl_restart
// bitfield description: Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dl_cfg_7L_rx_dl_restart <= 1'h0;
   end
   else begin
   if (we_dl_cfg_7L) begin 
      dl_cfg_7L_rx_dl_restart   <=  din[30];  //
   end
end

// dl_cfg_7L_tx_dl_restart
// bitfield description: Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dl_cfg_7L_tx_dl_restart <= 1'h0;
   end
   else begin
   if (we_dl_cfg_7L) begin 
      dl_cfg_7L_tx_dl_restart   <=  din[31];  //
   end
end
/* Definitions of REGISTER "tx_dl_delay_7L" */

// tx_dl_delay_7L_tx_dl_delay_7L
// bitfield description: Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid. 
// Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_dl_delay_7L_tx_dl_delay_7L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_dl_delay_7L" */

// rx_dl_delay_7L_rx_dl_delay_7L
// bitfield description: Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid. 
// Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_dl_delay_7L_rx_dl_delay_7L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "dl_status_7L" */

// dl_status_7L_rx_async_valid
// bitfield description: Indicates whether RX asynchronous counter values are valid: - 0: Invalid - 1: Valid
// Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_7L_rx_async_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_7L_rx_sync_valid
// bitfield description: Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. 
// Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_7L_rx_sync_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_7L_tx_async_valid
// bitfield description: Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_7L_tx_async_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_7L_tx_sync_valid
// bitfield description: Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_7L_tx_sync_valid_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "tx_sync_counter_8L" */

// tx_sync_counter_8L_tx_sync_counter_8L
// bitfield description: tx_sync_counter_1L 
// TX synchronous counter value. Must be qualified with tx_sync_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_sync_counter_8L_tx_sync_counter_8L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "tx_async_counter_8L" */

// tx_async_counter_8L_tx_async_counter_8L
// bitfield description: tx_async_counter_1L 
// TX asynchronous counter value. Must be qualified with tx_async_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_async_counter_8L_tx_async_counter_8L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_sync_counter_8L" */

// rx_sync_counter_8L_rx_sync_counter_8L
// bitfield description: rx_sync_counter_1L 
// RX synchronous counter value. Must be qualified with rx_sync_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_sync_counter_8L_rx_sync_counter_8L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_async_counter_8L" */

// rx_async_counter_8L_rx_async_counter_8L
// bitfield description: rx_async_counter_1L 
// RX asynchronous counter value. Must be qualified with rx_async_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_async_counter_8L_rx_async_counter_8L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "dl_cfg_8L" */

// dl_cfg_8L_rx_measure_valid
// bitfield description: Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_cfg_8L_rx_measure_valid_i 
// outputPort:  "" 
// NO register generated




// dl_cfg_8L_tx_measure_valid
// bitfield description: Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. 
// Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_cfg_8L_tx_measure_valid_i 
// outputPort:  "" 
// NO register generated




// dl_cfg_8L_rx_dl_restart
// bitfield description: Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dl_cfg_8L_rx_dl_restart <= 1'h0;
   end
   else begin
   if (we_dl_cfg_8L) begin 
      dl_cfg_8L_rx_dl_restart   <=  din[30];  //
   end
end

// dl_cfg_8L_tx_dl_restart
// bitfield description: Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      dl_cfg_8L_tx_dl_restart <= 1'h0;
   end
   else begin
   if (we_dl_cfg_8L) begin 
      dl_cfg_8L_tx_dl_restart   <=  din[31];  //
   end
end
/* Definitions of REGISTER "tx_dl_delay_8L" */

// tx_dl_delay_8L_tx_dl_delay_8L
// bitfield description: Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid. 
// Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: tx_dl_delay_8L_tx_dl_delay_8L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "rx_dl_delay_8L" */

// rx_dl_delay_8L_rx_dl_delay_8L
// bitfield description: Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid. 
// Indicates DL measurement values in fixed-point format for TX datapath latency (in sampling_clk cycle). Must be qualified with tx_measure_valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: rx_dl_delay_8L_rx_dl_delay_8L_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "dl_status_8L" */

// dl_status_8L_rx_async_valid
// bitfield description: Indicates whether RX asynchronous counter values are valid: - 0: Invalid - 1: Valid
// Indicates whether the RX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. Note: If block_lock is deasserted, this register is deasserted.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_8L_rx_async_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_8L_rx_sync_valid
// bitfield description: Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid. 
// Indicates whether the TX deterministic latency (DL) measurement values are valid - 0: Invalid ; 1: Valid.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_8L_rx_sync_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_8L_tx_async_valid
// bitfield description: Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow RX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_8L_tx_async_valid_i 
// outputPort:  "" 
// NO register generated




// dl_status_8L_tx_sync_valid
// bitfield description: Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// Issues a reset to allow TX deterministic latency (DL) measurements to be retaken. - 0: Reset disabled - 1: Reset enabled.
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: dl_status_8L_tx_sync_valid_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "cwbin_control_register" */

// cwbin_control_register_cwbin_control_register
// bitfield description: Soft cwbin control register 
// 1 : resets the cwbin module
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      cwbin_control_register_cwbin_control_register <= 1'h0;
   end
   else begin
   if (we_cwbin_control_register) begin 
      cwbin_control_register_cwbin_control_register   <=  din[0];  //
   end
end
/* Definitions of REGISTER "cwbin0_A" */

// cwbin0_A_cwbin0_A
// bitfield description: cwbin0_A 
// Hard IP rsfec_corr_cwbin_cnt_0_3 - cwbin 0 Errors are accumulated to 32 bit counter Block A
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: cwbin0_A_cwbin0_A_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "cwbin1_A" */

// cwbin1_A_cwbin1_A
// bitfield description: cwbin1_A 
// Hard IP rsfec_corr_cwbin_cnt_0_3 - cwbin 1 Errors are accumulated to 32 bit counter Block A
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: cwbin1_A_cwbin1_A_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "cwbin2_A" */

// cwbin2_A_cwbin2_A
// bitfield description: cwbin2_A 
// Hard IP rsfec_corr_cwbin_cnt_0_3 - cwbin 2 Errors are accumulated to 32 bit counter Block A
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: cwbin2_A_cwbin2_A_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "cwbin3_A" */

// cwbin3_A_cwbin3_A
// bitfield description: cwbin3_A 
// Hard IP rsfec_corr_cwbin_cnt_0_3 - cwbin 3 Errors are accumulated to 32 bit counter Block A
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: cwbin3_A_cwbin3_A_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "cwbin0_B" */

// cwbin0_B_cwbin0_B
// bitfield description: cwbin0_B 
// Hard IP rsfec_corr_cwbin_cnt_0_3 - cwbin 0 Errors are accumulated to 32 bit counter Block B
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: cwbin0_B_cwbin0_B_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "cwbin1_B" */

// cwbin1_B_cwbin1_B
// bitfield description: cwbin1_B 
// Hard IP rsfec_corr_cwbin_cnt_0_3 - cwbin 1 Errors are accumulated to 32 bit counter Block B
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: cwbin1_B_cwbin1_B_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "cwbin2_B" */

// cwbin2_B_cwbin2_B
// bitfield description: cwbin2_B 
// Hard IP rsfec_corr_cwbin_cnt_0_3 - cwbin 2 Errors are accumulated to 32 bit counter Block B
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: cwbin2_B_cwbin2_B_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "cwbin3_B" */

// cwbin3_B_cwbin3_B
// bitfield description: cwbin3_B 
// Hard IP rsfec_corr_cwbin_cnt_0_3 - cwbin 3 Errors are accumulated to 32 bit counter Block B
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: cwbin3_B_cwbin3_B_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "cwbin_timer" */

// cwbin_timer_cwbin_timer
// bitfield description: cwbin_timer 
// soft cwbin timer timeout value,in each loop the hard cwbin registers will be read and accumulated in soft 32bit registers
// customType:  RW
// hwAccess: RO 
// reset value : 0x00000000 


always @(  posedge clk)
   if (!reset_n)  begin
      cwbin_timer_cwbin_timer <= 32'h00000000;
   end
   else begin
   if (we_cwbin_timer[0]) begin 
      cwbin_timer_cwbin_timer[7:0]   <=  din[7:0];  //
   end
   if (we_cwbin_timer[1]) begin 
      cwbin_timer_cwbin_timer[15:8]   <=  din[15:8];  //
   end
   if (we_cwbin_timer[2]) begin 
      cwbin_timer_cwbin_timer[23:16]   <=  din[23:16];  //
   end
   if (we_cwbin_timer[3]) begin 
      cwbin_timer_cwbin_timer[31:24]   <=  din[31:24];  //
   end
end

always @(  posedge clk)
   if (!reset_n)  begin
     {rx_lf_rf_pcs_clr, rx_pkt_sts_clr, tx_pkt_sts_clr}  <= 3'h0;
   end
   else begin
   if (we_pkt_sts_clr) begin 
     {rx_lf_rf_pcs_clr, rx_pkt_sts_clr, tx_pkt_sts_clr}  <= din[2:0]; 
   end
end


always @(  posedge clk) 
begin
   if (!reset_n)  begin
   if (gui_option_eth_rate_i==3'h1 || gui_option_eth_rate_i==3'h0)  begin //25G-1 OR 10G-0
   `ifdef ALTERA_RESERVED_QIS
    config_ehip_rst_count <= 32'h0000C350; //250MHz - 200us, 100MHz - 500us
   `else
    config_ehip_rst_count <= 32'h0000000A;
   `endif
   end else begin
     `ifdef ALTERA_RESERVED_QIS
    config_ehip_rst_count <= 32'h000000FA; //250MHz - 1us, 100MHz - 2.5us
   `else
    config_ehip_rst_count <= 32'h0000000A;
   `endif
   end
   end else begin
   if (we_config_ehip_rst_count[0]) begin 
      config_ehip_rst_count[7:0]   <=  din[7:0];  //
   end
   if (we_config_ehip_rst_count[1]) begin 
      config_ehip_rst_count[15:8]   <=  din[15:8];  //
   end
   if (we_config_ehip_rst_count[2]) begin 
      config_ehip_rst_count[23:16]   <=  din[23:16];  //
   end
   if (we_config_ehip_rst_count[3]) begin 
      config_ehip_rst_count[31:24]   <=  din[31:24];  //
   end
end
end

always @(  posedge clk)
   if (!reset_n)  begin
    config_ehip_rst_count_pwd <= 32'h00000000;
   end
   else begin
   if (we_config_ehip_rst_count_pwd[0]) begin 
      config_ehip_rst_count_pwd[7:0]   <=  din[7:0];  //
   end
   if (we_config_ehip_rst_count_pwd[1]) begin 
      config_ehip_rst_count_pwd[15:8]   <=  din[15:8];  //
   end
   if (we_config_ehip_rst_count_pwd[2]) begin 
      config_ehip_rst_count_pwd[23:16]   <=  din[23:16];  //
   end
   if (we_config_ehip_rst_count_pwd[3]) begin 
      config_ehip_rst_count_pwd[31:24]   <=  din[31:24];  //
   end
end


// read process
always @ (*)
begin
rdata_comb = 32'h00000000;
   if(re) begin
      case (addr)  
	11'h100 : begin
		rdata_comb [1:0]	= 2'h1 ;  // gui_option_device_name 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [4:2]	= 3'h3 ;  // gui_option_tile_name 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [7:5]	= gui_option_eth_rate_i [2:0] ;		// readType = read   writeType =illegal
		rdata_comb [8]	= gui_option_anlt_enable_i  ;		// readType = read   writeType =illegal
		rdata_comb [9]	= gui_option_modulation_type_i  ;		// readType = read   writeType =illegal
		rdata_comb [12:10]	= gui_option_rsfec_type_i [2:0] ;		// readType = read   writeType =illegal
		rdata_comb [13]	= gui_option_ptp_enable_i  ;		// readType = read   writeType =illegal
		rdata_comb [16:14]	= gui_option_flow_control_mode_i [2:0] ;		// readType = read   writeType =illegal
		rdata_comb [19:17]	= gui_option_client_intf_i [2:0] ;		// readType = read   writeType =illegal
		rdata_comb [20]	= gui_option_xcvr_type_i  ;		// readType = read   writeType =illegal
		rdata_comb [24:21]	= gui_option_num_lanes_i [3:0] ;		// readType = read   writeType =illegal
	end
	11'h104 : begin
		rdata_comb [31:0]	= qhip_scratch_scratch [31:0] ;		// readType = read   writeType =write
	end
	11'h108 : begin
		rdata_comb [0]	= eth_reset_eio_sys_rst  ;		// readType = read   writeType =write
		rdata_comb [1]	= eth_reset_soft_tx_rst  ;		// readType = read   writeType =write
		rdata_comb [2]	= eth_reset_soft_rx_rst  ;		// readType = read   writeType =write
		rdata_comb [23:16]	= eth_reset_tx_clear_alarm [7:0] ;		// readType = read   writeType =write
		rdata_comb [31:24]	= eth_reset_rx_clear_alarm [7:0] ;		// readType = read   writeType =write
	end
	11'h10c : begin
		rdata_comb [0]	= eth_reset_status_rst_ack_n_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= eth_reset_status_tx_rst_ack_n_i  ;		// readType = read   writeType =illegal
		rdata_comb [2]	= eth_reset_status_rx_rst_ack_n_i  ;		// readType = read   writeType =illegal
		rdata_comb [10:8]	= eth_reset_status_tx_lane_current_state_i [2:0] ;		// readType = read   writeType =illegal
		rdata_comb [14:12]	= eth_reset_status_rx_lane_current_state_i [2:0] ;		// readType = read   writeType =illegal
		rdata_comb [23:16]	= eth_reset_status_tx_alarm_i [7:0] ;		// readType = read   writeType =illegal
		rdata_comb [31:24]	= eth_reset_status_rx_alarm_i [7:0] ;		// readType = read   writeType =illegal
	end
	11'h110 : begin
		rdata_comb [7:0]	= phy_tx_pll_locked_tx_pll_locked_i [7:0] ;		// readType = read   writeType =illegal
	end
	11'h114 : begin
		rdata_comb [7:0]	= phy_eiofreq_locked_eio_freq_lock_i [7:0] ;		// readType = read   writeType =illegal
	end
	11'h118 : begin
		rdata_comb [0]	= pcs_status_dskew_status_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= pcs_status_dskew_chng_i  ;		// readType = read   writeType =illegal
		rdata_comb [2]	= pcs_status_tx_lanes_stable_i  ;		// readType = read   writeType =illegal
		rdata_comb [3]	= pcs_status_rx_pcs_ready_i  ;		// readType = read   writeType =illegal
		rdata_comb [4]	= pcs_status_kr_mode_i  ;		// readType = read   writeType =illegal
		rdata_comb [5]	= pcs_status_kr_fec_mode_i  ;		// readType = read   writeType =illegal
	end
	11'h11c : begin
		rdata_comb [0]	= pcs_control_clr_dskew_chng  ;		// readType = read   writeType =write
	end
	11'h120 : begin
		rdata_comb [0]	= link_fault_status_lfault_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= link_fault_status_rfault_i  ;		// readType = read   writeType =illegal
	end
	11'h124 : begin
		rdata_comb [15:0]	= aib_transfer_ready_status_ehip_rx_transfer_ready_i [15:0] ;		// readType = read   writeType =illegal
		rdata_comb [31:16]	= aib_transfer_ready_status_ehip_tx_transfer_ready_i [15:0] ;		// readType = read   writeType =illegal
	end
	11'h128 : begin
		rdata_comb [31:0]	= clk_tx_khz_clk_tx_khz_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h12c : begin
		rdata_comb [31:0]	= clk_rx_khz_clk_rx_khz_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h130 : begin
		rdata_comb [31:0]	= clk_pll_khz_clk_pll_khz_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h134 : begin
		rdata_comb [31:0]	= clk_tx_div_khz_clk_tx_div_khz_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h138 : begin
		rdata_comb [31:0]	= clk_rec_div64_khz_clk_rec_div64_khz_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h13c : begin
		rdata_comb [31:0]	= clk_rec_div_khz_clk_rec_div_khz_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h140 : begin
		rdata_comb [31:0]	= rxmac_adapt_dropped_31_0_rxmac_adapt_dropped_31_0_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h144 : begin
		rdata_comb [31:0]	= rxmac_adapt_dropped_63_32_rxmac_adapt_dropped_63_32_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h148 : begin
		rdata_comb [0]	= rxmac_adapt_dropped_control_rxmac_adapt_dropped_clear  ;		// readType = read   writeType =write
		rdata_comb [1]	= rxmac_adapt_dropped_control_rxmac_adapt_dropped_snapshot  ;		// readType = read   writeType =write
	end
	11'h300 : begin
		rdata_comb [31:0]	= tx_sync_counter_1L_tx_sync_counter_1L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h304 : begin
		rdata_comb [31:0]	= tx_async_counter_1L_tx_async_counter_1L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h308 : begin
		rdata_comb [31:0]	= rx_sync_counter_1L_rx_sync_counter_1L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h30c : begin
		rdata_comb [31:0]	= rx_async_counter_1L_rx_async_counter_1L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h310 : begin
		rdata_comb [0]	= dl_cfg_1L_rx_measure_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= dl_cfg_1L_tx_measure_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [30]	= dl_cfg_1L_rx_dl_restart  ;		// readType = read   writeType =write
		rdata_comb [31]	= dl_cfg_1L_tx_dl_restart  ;		// readType = read   writeType =write
	end
	11'h314 : begin
		rdata_comb [31:0]	= tx_dl_delay_1L_tx_dl_delay_1L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h318 : begin
		rdata_comb [31:0]	= rx_dl_delay_1L_rx_dl_delay_1L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h31c : begin
		rdata_comb [0]	= dl_status_1L_rx_async_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= dl_status_1L_rx_sync_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [2]	= dl_status_1L_tx_async_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [3]	= dl_status_1L_tx_sync_valid_i  ;		// readType = read   writeType =illegal
	end
	11'h320 : begin
		rdata_comb [31:0]	= tx_sync_counter_2L_tx_sync_counter_2L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h324 : begin
		rdata_comb [31:0]	= tx_async_counter_2L_tx_async_counter_2L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h328 : begin
		rdata_comb [31:0]	= rx_sync_counter_2L_rx_sync_counter_2L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h32c : begin
		rdata_comb [31:0]	= rx_async_counter_2L_rx_async_counter_2L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h330 : begin
		rdata_comb [0]	= dl_cfg_2L_rx_measure_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= dl_cfg_2L_tx_measure_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [30]	= dl_cfg_2L_rx_dl_restart  ;		// readType = read   writeType =write
		rdata_comb [31]	= dl_cfg_2L_tx_dl_restart  ;		// readType = read   writeType =write
	end
	11'h334 : begin
		rdata_comb [31:0]	= tx_dl_delay_2L_tx_dl_delay_2L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h338 : begin
		rdata_comb [31:0]	= rx_dl_delay_2L_rx_dl_delay_2L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h33c : begin
		rdata_comb [0]	= dl_status_2L_rx_async_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= dl_status_2L_rx_sync_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [2]	= dl_status_2L_tx_async_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [3]	= dl_status_2L_tx_sync_valid_i  ;		// readType = read   writeType =illegal
	end
	11'h340 : begin
		rdata_comb [31:0]	= tx_sync_counter_3L_tx_sync_counter_3L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h344 : begin
		rdata_comb [31:0]	= tx_async_counter_3L_tx_async_counter_3L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h348 : begin
		rdata_comb [31:0]	= rx_sync_counter_3L_rx_sync_counter_3L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h34c : begin
		rdata_comb [31:0]	= rx_async_counter_3L_rx_async_counter_3L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h350 : begin
		rdata_comb [0]	= dl_cfg_3L_rx_measure_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= dl_cfg_3L_tx_measure_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [30]	= dl_cfg_3L_rx_dl_restart  ;		// readType = read   writeType =write
		rdata_comb [31]	= dl_cfg_3L_tx_dl_restart  ;		// readType = read   writeType =write
	end
	11'h354 : begin
		rdata_comb [31:0]	= tx_dl_delay_3L_tx_dl_delay_3L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h358 : begin
		rdata_comb [31:0]	= rx_dl_delay_3L_rx_dl_delay_3L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h35c : begin
		rdata_comb [0]	= dl_status_3L_rx_async_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= dl_status_3L_rx_sync_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [2]	= dl_status_3L_tx_async_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [3]	= dl_status_3L_tx_sync_valid_i  ;		// readType = read   writeType =illegal
	end
	11'h360 : begin
		rdata_comb [31:0]	= tx_sync_counter_4L_tx_sync_counter_4L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h364 : begin
		rdata_comb [31:0]	= tx_async_counter_4L_tx_async_counter_4L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h368 : begin
		rdata_comb [31:0]	= rx_sync_counter_4L_rx_sync_counter_4L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h36c : begin
		rdata_comb [31:0]	= rx_async_counter_4L_rx_async_counter_4L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h370 : begin
		rdata_comb [0]	= dl_cfg_4L_rx_measure_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= dl_cfg_4L_tx_measure_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [30]	= dl_cfg_4L_rx_dl_restart  ;		// readType = read   writeType =write
		rdata_comb [31]	= dl_cfg_4L_tx_dl_restart  ;		// readType = read   writeType =write
	end
	11'h374 : begin
		rdata_comb [31:0]	= tx_dl_delay_4L_tx_dl_delay_4L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h378 : begin
		rdata_comb [31:0]	= rx_dl_delay_4L_rx_dl_delay_4L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h37c : begin
		rdata_comb [0]	= dl_status_4L_rx_async_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= dl_status_4L_rx_sync_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [2]	= dl_status_4L_tx_async_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [3]	= dl_status_4L_tx_sync_valid_i  ;		// readType = read   writeType =illegal
	end
	11'h380 : begin
		rdata_comb [31:0]	= tx_sync_counter_5L_tx_sync_counter_5L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h384 : begin
		rdata_comb [31:0]	= tx_async_counter_5L_tx_async_counter_5L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h388 : begin
		rdata_comb [31:0]	= rx_sync_counter_5L_rx_sync_counter_5L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h38c : begin
		rdata_comb [31:0]	= rx_async_counter_5L_rx_async_counter_5L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h390 : begin
		rdata_comb [0]	= dl_cfg_5L_rx_measure_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= dl_cfg_5L_tx_measure_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [30]	= dl_cfg_5L_rx_dl_restart  ;		// readType = read   writeType =write
		rdata_comb [31]	= dl_cfg_5L_tx_dl_restart  ;		// readType = read   writeType =write
	end
	11'h394 : begin
		rdata_comb [31:0]	= tx_dl_delay_5L_tx_dl_delay_5L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h398 : begin
		rdata_comb [31:0]	= rx_dl_delay_5L_rx_dl_delay_5L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h39c : begin
		rdata_comb [0]	= dl_status_5L_rx_async_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= dl_status_5L_rx_sync_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [2]	= dl_status_5L_tx_async_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [3]	= dl_status_5L_tx_sync_valid_i  ;		// readType = read   writeType =illegal
	end
	11'h3a0 : begin
		rdata_comb [31:0]	= tx_sync_counter_6L_tx_sync_counter_6L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h3a4 : begin
		rdata_comb [31:0]	= tx_async_counter_6L_tx_async_counter_6L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h3a8 : begin
		rdata_comb [31:0]	= rx_sync_counter_6L_rx_sync_counter_6L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h3ac : begin
		rdata_comb [31:0]	= rx_async_counter_6L_rx_async_counter_6L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h3b0 : begin
		rdata_comb [0]	= dl_cfg_6L_rx_measure_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= dl_cfg_6L_tx_measure_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [30]	= dl_cfg_6L_rx_dl_restart  ;		// readType = read   writeType =write
		rdata_comb [31]	= dl_cfg_6L_tx_dl_restart  ;		// readType = read   writeType =write
	end
	11'h3b4 : begin
		rdata_comb [31:0]	= tx_dl_delay_6L_tx_dl_delay_6L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h3b8 : begin
		rdata_comb [31:0]	= rx_dl_delay_6L_rx_dl_delay_6L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h3bc : begin
		rdata_comb [0]	= dl_status_6L_rx_async_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= dl_status_6L_rx_sync_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [2]	= dl_status_6L_tx_async_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [3]	= dl_status_6L_tx_sync_valid_i  ;		// readType = read   writeType =illegal
	end
	11'h3c0 : begin
		rdata_comb [31:0]	= tx_sync_counter_7L_tx_sync_counter_7L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h3c4 : begin
		rdata_comb [31:0]	= tx_async_counter_7L_tx_async_counter_7L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h3c8 : begin
		rdata_comb [31:0]	= rx_sync_counter_7L_rx_sync_counter_7L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h3cc : begin
		rdata_comb [31:0]	= rx_async_counter_7L_rx_async_counter_7L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h3d0 : begin
		rdata_comb [0]	= dl_cfg_7L_rx_measure_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= dl_cfg_7L_tx_measure_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [30]	= dl_cfg_7L_rx_dl_restart  ;		// readType = read   writeType =write
		rdata_comb [31]	= dl_cfg_7L_tx_dl_restart  ;		// readType = read   writeType =write
	end
	11'h3d4 : begin
		rdata_comb [31:0]	= tx_dl_delay_7L_tx_dl_delay_7L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h3d8 : begin
		rdata_comb [31:0]	= rx_dl_delay_7L_rx_dl_delay_7L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h3dc : begin
		rdata_comb [0]	= dl_status_7L_rx_async_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= dl_status_7L_rx_sync_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [2]	= dl_status_7L_tx_async_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [3]	= dl_status_7L_tx_sync_valid_i  ;		// readType = read   writeType =illegal
	end
	11'h3e0 : begin
		rdata_comb [31:0]	= tx_sync_counter_8L_tx_sync_counter_8L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h3e4 : begin
		rdata_comb [31:0]	= tx_async_counter_8L_tx_async_counter_8L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h3e8 : begin
		rdata_comb [31:0]	= rx_sync_counter_8L_rx_sync_counter_8L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h3ec : begin
		rdata_comb [31:0]	= rx_async_counter_8L_rx_async_counter_8L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h3f0 : begin
		rdata_comb [0]	= dl_cfg_8L_rx_measure_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= dl_cfg_8L_tx_measure_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [30]	= dl_cfg_8L_rx_dl_restart  ;		// readType = read   writeType =write
		rdata_comb [31]	= dl_cfg_8L_tx_dl_restart  ;		// readType = read   writeType =write
	end
	11'h3f4 : begin
		rdata_comb [31:0]	= tx_dl_delay_8L_tx_dl_delay_8L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h3f8 : begin
		rdata_comb [31:0]	= rx_dl_delay_8L_rx_dl_delay_8L_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h3fc : begin
		rdata_comb [0]	= dl_status_8L_rx_async_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= dl_status_8L_rx_sync_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [2]	= dl_status_8L_tx_async_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [3]	= dl_status_8L_tx_sync_valid_i  ;		// readType = read   writeType =illegal
	end
	11'h400 : begin
		rdata_comb [0]	= cwbin_control_register_cwbin_control_register  ;		// readType = read   writeType =write
	end
	11'h404 : begin
		rdata_comb [31:0]	= cwbin0_A_cwbin0_A_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h408 : begin
		rdata_comb [31:0]	= cwbin1_A_cwbin1_A_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h40c : begin
		rdata_comb [31:0]	= cwbin2_A_cwbin2_A_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h410 : begin
		rdata_comb [31:0]	= cwbin3_A_cwbin3_A_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h414 : begin
		rdata_comb [31:0]	= cwbin0_B_cwbin0_B_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h418 : begin
		rdata_comb [31:0]	= cwbin1_B_cwbin1_B_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h41c : begin
		rdata_comb [31:0]	= cwbin2_B_cwbin2_B_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h420 : begin
		rdata_comb [31:0]	= cwbin3_B_cwbin3_B_i [31:0] ;		// readType = read   writeType =illegal
	end
	11'h424 : begin
		rdata_comb [31:0]	= cwbin_timer_cwbin_timer [31:0] ;		// readType = read   writeType =write
	end
	11'h430 : rdata_comb [31:0]      = {29'd0, rx_lf_rf_pcs_clr, rx_pkt_sts_clr, tx_pkt_sts_clr};
	11'h440 : rdata_comb [31:0]      = tx_pkr_sop_cnt_lo[31:0];
	11'h444 : rdata_comb [31:0]      = {16'd0, tx_pkr_sop_cnt_hi[15:0]};
	11'h448 : rdata_comb [31:0]      = tx_pkr_eop_cnt_lo[31:0];
	11'h44C : rdata_comb [31:0]      = {16'd0, tx_pkr_eop_cnt_hi[15:0]};
	11'h450 : rdata_comb [31:0]      = tx_pkr_byte_cnt_lo[31:0];
	11'h454 : rdata_comb [31:0]      = tx_pkr_byte_cnt_hi[31:0];
	11'h460 : rdata_comb [31:0]      = tx_mac_sop_cnt_lo[31:0];
	11'h464 : rdata_comb [31:0]      = {16'd0, tx_mac_sop_cnt_hi[15:0]};
	11'h468 : rdata_comb [31:0]      = tx_mac_eop_cnt_lo[31:0];
	11'h46C : rdata_comb [31:0]      = {16'd0, tx_mac_eop_cnt_hi[15:0]};
	11'h470 : rdata_comb [31:0]      = tx_mac_byte_cnt_lo[31:0];
	11'h474 : rdata_comb [31:0]      = tx_mac_byte_cnt_hi[31:0];
	11'h480 : rdata_comb [31:0]      = rx_mac_sop_cnt_lo[31:0];
	11'h484 : rdata_comb [31:0]      = {16'd0, rx_mac_sop_cnt_hi[15:0]};
	11'h488 : rdata_comb [31:0]      = rx_mac_eop_cnt_lo[31:0];
	11'h48C : rdata_comb [31:0]      = {16'd0, rx_mac_eop_cnt_hi[15:0]};
	11'h490 : rdata_comb [31:0]      = rx_mac_byte_cnt_lo[31:0];
	11'h494 : rdata_comb [31:0]      = rx_mac_byte_cnt_hi[31:0];
        11'h498 : rdata_comb [31:0]      = {26'd0, tx_pkr_max_fifo_level[5:0]}; 
	11'h49C : rdata_comb [31:0]      = {26'd0, tx_pkr_min_fifo_level[5:0]}; 
	11'h4A0 : rdata_comb [31:0]      = {28'd0, tx_pkr_fifo_empty_cnt[3:0]};
        11'h4A4 : rdata_comb [31:0]      = {8'd0, local_remote_pcs_cntr[23:0]};
        11'h500 : begin
		rdata_comb [31:0]	= packer_da_mismatch_cnt_in_lo [31:0] ;		// readType = read   writeType =illegal
	end
        11'h504 : begin
		rdata_comb [31:0]	= packer_da_mismatch_cnt_in_hi [31:0] ;		// readType = read   writeType =illegal
	end
        11'h508 : begin
		rdata_comb [31:0]	= packer_da_mismatch_cnt_out_lo [31:0] ;		// readType = read   writeType =illegal
	end
        11'h50c : begin
		rdata_comb [31:0]	= packer_da_mismatch_cnt_out_hi [31:0] ;		// readType = read   writeType =illegal
	end
	11'h510 : begin
		rdata_comb [31:0]	= packer_da_match_cnt_in_lo [31:0] ;		// readType = read   writeType =illegal
	end
        11'h514 : begin
		rdata_comb [31:0]	= packer_da_match_cnt_in_hi [31:0] ;		// readType = read   writeType =illegal
	end
        11'h518 : begin
		rdata_comb [31:0]	= packer_da_match_cnt_out_lo [31:0] ;		// readType = read   writeType =illegal
	end
        11'h51c : begin
		rdata_comb [31:0]	= packer_da_match_cnt_out_hi [31:0] ;		// readType = read   writeType =illegal
	end
	11'h520 : begin
		rdata_comb [31:0]	= tx_pause_da_mismatch_cnt_in_lo [31:0] ;		// readType = read   writeType =illegal
	end
        11'h524 : begin
		rdata_comb [31:0]	= tx_pause_da_mismatch_cnt_in_hi [31:0] ;		// readType = read   writeType =illegal
	end
        11'h528 : begin
		rdata_comb [31:0]	= tx_pause_da_mismatch_cnt_out_lo [31:0] ;		// readType = read   writeType =illegal
	end
        11'h52c : begin
		rdata_comb [31:0]	= tx_pause_da_mismatch_cnt_out_hi [31:0] ;		// readType = read   writeType =illegal
	end
	11'h530 : begin
		rdata_comb [31:0]	= tx_pause_da_match_cnt_in_lo [31:0] ;		// readType = read   writeType =illegal
	end
        11'h534 : begin
		rdata_comb [31:0]	= tx_pause_da_match_cnt_in_hi [31:0] ;		// readType = read   writeType =illegal
	end
        11'h538 : begin
		rdata_comb [31:0]	= tx_pause_da_match_cnt_out_lo [31:0] ;		// readType = read   writeType =illegal
	end
        11'h53c : begin
		rdata_comb [31:0]	= tx_pause_da_match_cnt_out_hi [31:0] ;		// readType = read   writeType =illegal
	end

        11'h600 : begin
		rdata_comb [31:0]	= config_ehip_rst_count [31:0] ;		// readType = read   writeType =write
	end
	11'h604 : begin
	        rdata_comb [31:0]	= config_ehip_rst_count_pwd [31:0] ;		// readType = read   writeType =write
	end
	default : begin
		rdata_comb = 32'h00000000;
	end
      endcase
   end
end

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "o2ONPYJ6JWO2K/lQHkyApXo6DVczB8sUyJtLpEiYtF7LL07s93qi8rQ7d2s1AdTOt/BNVdBoSTLCdACDT58BR3umvYuucV6Cbb36lNsOsJegwtedOJsDvTnB14ZLU41EvDEX+uxr7iJUYiTmn7hunq22K1+T/Nc7+FaTNr6AMH3CCuiZmo/CmXjVXLRPwF034Kg1mVvlsNTpZhm0ORjPpNI8tuMP0bMp6HLhHMKVKvcOktLdU4+pcYrHkX9TvQMq8Nzw6yuflteLY5wIJeJv60QHkeb2BZIYPJC9NmdbyzFncTrXtHffLYsSacojxRNEVa0Zazely9KhIEbNXl7udGq24+vAAFX3eoywdbRwG27QCDEBIH/YXfhVOQ24pSkOmVHs4TzMqCBCNYh2pc3/95yDFRvlEVWOE63R4LGcEopb686J+rsdRWiOif47dy4Rl/KEu5LeLSnhSNKX1+UQqGoEG4qVeMsPXQKPsS85nS+aJwtFinLVqKgaroswyCDyGTI5l1gZvi2yyUSH4NoQ1jf2xY+RIxIQ696ruphZeui9whmtlq1EVqnGwOrKdfLq8WCtuTmu2XcXMLOnKP96Gsb1MVsevgzCP7wrlsbTwRO4f2lDZ7Juf+n0D+ZYW8934X2wlBo2ccu9SfBxhvPr7tBD/z1xIaFTOadVMDEPFa2MHnNWrH+hqexiWe/gqNb6a0eNxRBH+8Bjmf09gwf2melKb+Snfu2S3llW0lyCv296tVDwwnUP8E/M6g/IwBJS7FR3Gzuan8rvAQRy7Zo/T9+2faeiDnT/iOaIAT/xxXYk7PUkf1yRK6UZFQ7QwuyurS0+gEdpVffWf59guFJSkNyTGNB3WZKjazkhGV1lunRVRENv8s6zWj4CBGC8KWIaO/zQ+AMA9TwYqREHkBSW1bzOD7X3A+1kYZ4sf2QLFTiD9m/z2yfxCWoK1J/v1U/r46jNC1UDtDKHOon2f1AQihP/LomNXG1SWyMPOxWAhRq9vORLf/9xEpfck2Oh9r9Y"
`endif