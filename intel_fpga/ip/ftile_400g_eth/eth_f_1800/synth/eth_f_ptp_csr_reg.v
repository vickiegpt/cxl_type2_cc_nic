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
//   Date : Fri Dec 18 02:30:52 PST 2020           
//-----------------------------------------------------------------------------------------------//


//-----------------------------------------------------------------------------------------------//
//   Verilog Register Bank
//   Component Name: eth_f_ptp_csr_reg
//   File Ref: /nfs/sc/disks/swuser_work_chooyuyi/qshell_b95/p4/ip/ethernet/eth_f/csr_gen/eth_f_ptp_csrgen_out/_workspace_mrv_gen_py_/xmlProject/_local_copy_Vendor_Library_eth_f_ptp_csr_reg_1.0.xml                                             
//   Magillem Version :   5.2018.3                                                                         
//-----------------------------------------------------------------------------------------------//
// 

module eth_f_ptp_csr_reg (
// register offset : 0x800, field offset : 0, access : RW, ptp_tx_tam_adjust.tam_adjust
input   ptp_tx_tam_adjust_tam_adjust_hwclr,
output  reg ptp_tx_tam_adjust_tam_adjust_modTrig,
output  reg[31:0] ptp_tx_tam_adjust_tam_adjust,
// register offset : 0x804, field offset : 0, access : RW, ptp_rx_tam_adjust.tam_adjust
input   ptp_rx_tam_adjust_tam_adjust_hwclr,
output  reg ptp_rx_tam_adjust_tam_adjust_modTrig,
output  reg[31:0] ptp_rx_tam_adjust_tam_adjust,
// register offset : 0x80c, field offset : 0, access : RW, ptp_ref_lane.tx_ref_lane
input   ptp_ref_lane_tx_ref_lane_hwclr,
output  reg ptp_ref_lane_tx_ref_lane_modTrig,
output  reg[2:0] ptp_ref_lane_tx_ref_lane,
// register offset : 0x80c, field offset : 3, access : RW, ptp_ref_lane.rx_ref_lane
input   ptp_ref_lane_rx_ref_lane_hwclr,
output  reg ptp_ref_lane_rx_ref_lane_modTrig,
output  reg[2:0] ptp_ref_lane_rx_ref_lane,
// register offset : 0x810, field offset : 0, access : RW, ptp_dr_cfg.tx_ehip_preamble_passthrough
input   ptp_dr_cfg_tx_ehip_preamble_passthrough_reset_value,
output  reg ptp_dr_cfg_tx_ehip_preamble_passthrough,
// register offset : 0x814, field offset : 0, access : RW, ptp_tx_user_cfg_status.tx_user_cfg_done
input   ptp_tx_user_cfg_status_tx_user_cfg_done_hwclr,
output  reg ptp_tx_user_cfg_status_tx_user_cfg_done,
// register offset : 0x818, field offset : 0, access : RW, ptp_rx_user_cfg_status.rx_user_cfg_done
input   ptp_rx_user_cfg_status_rx_user_cfg_done_hwclr,
output  reg ptp_rx_user_cfg_status_rx_user_cfg_done,
// register offset : 0x818, field offset : 1, access : RW, ptp_rx_user_cfg_status.rx_fec_cw_pos_cfg_done
input   ptp_rx_user_cfg_status_rx_fec_cw_pos_cfg_done_hwclr,
output  reg ptp_rx_user_cfg_status_rx_fec_cw_pos_cfg_done,
// register offset : 0x81c, field offset : 0, access : ReturnToZero, ptp_uim_tam_snapshot.tx_tam_snapshot
output  reg ptp_uim_tam_snapshot_tx_tam_snapshot,
// register offset : 0x81c, field offset : 1, access : ReturnToZero, ptp_uim_tam_snapshot.rx_tam_snapshot
output  reg ptp_uim_tam_snapshot_rx_tam_snapshot,
// register offset : 0x820, field offset : 0, access : RO, ptp_tx_uim_tam_info0.tam_31_0
input  [31:0] ptp_tx_uim_tam_info0_tam_31_0_i,
// register offset : 0x824, field offset : 0, access : RO, ptp_tx_uim_tam_info1.tam_47_32
input  [15:0] ptp_tx_uim_tam_info1_tam_47_32_i,
// register offset : 0x824, field offset : 16, access : RO, ptp_tx_uim_tam_info1.tam_cnt
input  [14:0] ptp_tx_uim_tam_info1_tam_cnt_i,
// register offset : 0x824, field offset : 31, access : RO, ptp_tx_uim_tam_info1.tam_valid
input   ptp_tx_uim_tam_info1_tam_valid_i,
// register offset : 0x828, field offset : 0, access : RO, ptp_rx_uim_tam_info0.tam_31_0
input  [31:0] ptp_rx_uim_tam_info0_tam_31_0_i,
// register offset : 0x82c, field offset : 0, access : RO, ptp_rx_uim_tam_info1.tam_47_32
input  [15:0] ptp_rx_uim_tam_info1_tam_47_32_i,
// register offset : 0x82c, field offset : 16, access : RO, ptp_rx_uim_tam_info1.tam_cnt
input  [14:0] ptp_rx_uim_tam_info1_tam_cnt_i,
// register offset : 0x82c, field offset : 31, access : RO, ptp_rx_uim_tam_info1.tam_valid
input   ptp_rx_uim_tam_info1_tam_valid_i,
// register offset : 0x830, field offset : 0, access : RO, ptp_status.tx_ptp_offset_data_valid
input   ptp_status_tx_ptp_offset_data_valid_i,
// register offset : 0x830, field offset : 1, access : RO, ptp_status.rx_ptp_offset_data_valid
input   ptp_status_rx_ptp_offset_data_valid_i,
// register offset : 0x830, field offset : 2, access : RO, ptp_status.tx_ptp_ready
input   ptp_status_tx_ptp_ready_i,
// register offset : 0x830, field offset : 3, access : RO, ptp_status.rx_ptp_ready
input   ptp_status_rx_ptp_ready_i,
// register offset : 0x840, field offset : 0, access : RO, ptp_status2.tx_calc_data_offset_valid
input   ptp_status2_tx_calc_data_offset_valid_i,
// register offset : 0x840, field offset : 1, access : RO, ptp_status2.tx_calc_data_time_valid
input   ptp_status2_tx_calc_data_time_valid_i,
// register offset : 0x840, field offset : 2, access : RO, ptp_status2.tx_calc_data_wiredelay_valid
input   ptp_status2_tx_calc_data_wiredelay_valid_i,
// register offset : 0x840, field offset : 3, access : RO, ptp_status2.rx_calc_data_offset_valid
input   ptp_status2_rx_calc_data_offset_valid_i,
// register offset : 0x840, field offset : 4, access : RO, ptp_status2.rx_calc_data_time_valid
input   ptp_status2_rx_calc_data_time_valid_i,
// register offset : 0x840, field offset : 5, access : RO, ptp_status2.rx_calc_data_wiredelay_valid
input   ptp_status2_rx_calc_data_wiredelay_valid_i,
// register offset : 0x840, field offset : 6, access : RO, ptp_status2.rx_vl_offset_data_ready
input   ptp_status2_rx_vl_offset_data_ready_i,
// register offset : 0x8f0, field offset : 0, access : RO, ptp_tx_lane_calc_data_constdelay.data_constdelay
input  [31:0] ptp_tx_lane_calc_data_constdelay_data_constdelay_i,
// register offset : 0x8f4, field offset : 0, access : RO, ptp_rx_lane_calc_data_constdelay.data_constdelay
input  [31:0] ptp_rx_lane_calc_data_constdelay_data_constdelay_i,
// register offset : 0x900, field offset : 0, access : RO, ptp_tx_lane0_calc_data_offset.data_offset
input  [31:0] ptp_tx_lane0_calc_data_offset_data_offset_i,
// register offset : 0x904, field offset : 0, access : RO, ptp_rx_lane0_calc_data_offset.data_offset
input  [31:0] ptp_rx_lane0_calc_data_offset_data_offset_i,
// register offset : 0x908, field offset : 0, access : RO, ptp_tx_lane0_calc_data_time.data_time
input  [27:0] ptp_tx_lane0_calc_data_time_data_time_i,
// register offset : 0x90c, field offset : 0, access : RO, ptp_rx_lane0_calc_data_time.data_time
input  [27:0] ptp_rx_lane0_calc_data_time_data_time_i,
// register offset : 0x910, field offset : 0, access : RO, ptp_tx_lane0_calc_data_wiredelay.data_wiredelay
input  [19:0] ptp_tx_lane0_calc_data_wiredelay_data_wiredelay_i,
// register offset : 0x914, field offset : 0, access : RO, ptp_rx_lane0_calc_data_wiredelay.data_wiredelay
input  [19:0] ptp_rx_lane0_calc_data_wiredelay_data_wiredelay_i,
// register offset : 0x920, field offset : 0, access : RO, ptp_tx_lane1_calc_data_offset.data_offset
input  [31:0] ptp_tx_lane1_calc_data_offset_data_offset_i,
// register offset : 0x924, field offset : 0, access : RO, ptp_rx_lane1_calc_data_offset.data_offset
input  [31:0] ptp_rx_lane1_calc_data_offset_data_offset_i,
// register offset : 0x928, field offset : 0, access : RO, ptp_tx_lane1_calc_data_time.data_time
input  [27:0] ptp_tx_lane1_calc_data_time_data_time_i,
// register offset : 0x92c, field offset : 0, access : RO, ptp_rx_lane1_calc_data_time.data_time
input  [27:0] ptp_rx_lane1_calc_data_time_data_time_i,
// register offset : 0x930, field offset : 0, access : RO, ptp_tx_lane1_calc_data_wiredelay.data_wiredelay
input  [19:0] ptp_tx_lane1_calc_data_wiredelay_data_wiredelay_i,
// register offset : 0x934, field offset : 0, access : RO, ptp_rx_lane1_calc_data_wiredelay.data_wiredelay
input  [19:0] ptp_rx_lane1_calc_data_wiredelay_data_wiredelay_i,
// register offset : 0x940, field offset : 0, access : RO, ptp_tx_lane2_calc_data_offset.data_offset
input  [31:0] ptp_tx_lane2_calc_data_offset_data_offset_i,
// register offset : 0x944, field offset : 0, access : RO, ptp_rx_lane2_calc_data_offset.data_offset
input  [31:0] ptp_rx_lane2_calc_data_offset_data_offset_i,
// register offset : 0x948, field offset : 0, access : RO, ptp_tx_lane2_calc_data_time.data_time
input  [27:0] ptp_tx_lane2_calc_data_time_data_time_i,
// register offset : 0x94c, field offset : 0, access : RO, ptp_rx_lane2_calc_data_time.data_time
input  [27:0] ptp_rx_lane2_calc_data_time_data_time_i,
// register offset : 0x950, field offset : 0, access : RO, ptp_tx_lane2_calc_data_wiredelay.data_wiredelay
input  [19:0] ptp_tx_lane2_calc_data_wiredelay_data_wiredelay_i,
// register offset : 0x954, field offset : 0, access : RO, ptp_rx_lane2_calc_data_wiredelay.data_wiredelay
input  [19:0] ptp_rx_lane2_calc_data_wiredelay_data_wiredelay_i,
// register offset : 0x960, field offset : 0, access : RO, ptp_tx_lane3_calc_data_offset.data_offset
input  [31:0] ptp_tx_lane3_calc_data_offset_data_offset_i,
// register offset : 0x964, field offset : 0, access : RO, ptp_rx_lane3_calc_data_offset.data_offset
input  [31:0] ptp_rx_lane3_calc_data_offset_data_offset_i,
// register offset : 0x968, field offset : 0, access : RO, ptp_tx_lane3_calc_data_time.data_time
input  [27:0] ptp_tx_lane3_calc_data_time_data_time_i,
// register offset : 0x96c, field offset : 0, access : RO, ptp_rx_lane3_calc_data_time.data_time
input  [27:0] ptp_rx_lane3_calc_data_time_data_time_i,
// register offset : 0x970, field offset : 0, access : RO, ptp_tx_lane3_calc_data_wiredelay.data_wiredelay
input  [19:0] ptp_tx_lane3_calc_data_wiredelay_data_wiredelay_i,
// register offset : 0x974, field offset : 0, access : RO, ptp_rx_lane3_calc_data_wiredelay.data_wiredelay
input  [19:0] ptp_rx_lane3_calc_data_wiredelay_data_wiredelay_i,
// register offset : 0x980, field offset : 0, access : RO, ptp_tx_lane4_calc_data_offset.data_offset
input  [31:0] ptp_tx_lane4_calc_data_offset_data_offset_i,
// register offset : 0x984, field offset : 0, access : RO, ptp_rx_lane4_calc_data_offset.data_offset
input  [31:0] ptp_rx_lane4_calc_data_offset_data_offset_i,
// register offset : 0x988, field offset : 0, access : RO, ptp_tx_lane4_calc_data_time.data_time
input  [27:0] ptp_tx_lane4_calc_data_time_data_time_i,
// register offset : 0x98c, field offset : 0, access : RO, ptp_rx_lane4_calc_data_time.data_time
input  [27:0] ptp_rx_lane4_calc_data_time_data_time_i,
// register offset : 0x990, field offset : 0, access : RO, ptp_tx_lane4_calc_data_wiredelay.data_wiredelay
input  [19:0] ptp_tx_lane4_calc_data_wiredelay_data_wiredelay_i,
// register offset : 0x994, field offset : 0, access : RO, ptp_rx_lane4_calc_data_wiredelay.data_wiredelay
input  [19:0] ptp_rx_lane4_calc_data_wiredelay_data_wiredelay_i,
// register offset : 0x9a0, field offset : 0, access : RO, ptp_tx_lane5_calc_data_offset.data_offset
input  [31:0] ptp_tx_lane5_calc_data_offset_data_offset_i,
// register offset : 0x9a4, field offset : 0, access : RO, ptp_rx_lane5_calc_data_offset.data_offset
input  [31:0] ptp_rx_lane5_calc_data_offset_data_offset_i,
// register offset : 0x9a8, field offset : 0, access : RO, ptp_tx_lane5_calc_data_time.data_time
input  [27:0] ptp_tx_lane5_calc_data_time_data_time_i,
// register offset : 0x9ac, field offset : 0, access : RO, ptp_rx_lane5_calc_data_time.data_time
input  [27:0] ptp_rx_lane5_calc_data_time_data_time_i,
// register offset : 0x9b0, field offset : 0, access : RO, ptp_tx_lane5_calc_data_wiredelay.data_wiredelay
input  [19:0] ptp_tx_lane5_calc_data_wiredelay_data_wiredelay_i,
// register offset : 0x9b4, field offset : 0, access : RO, ptp_rx_lane5_calc_data_wiredelay.data_wiredelay
input  [19:0] ptp_rx_lane5_calc_data_wiredelay_data_wiredelay_i,
// register offset : 0x9c0, field offset : 0, access : RO, ptp_tx_lane6_calc_data_offset.data_offset
input  [31:0] ptp_tx_lane6_calc_data_offset_data_offset_i,
// register offset : 0x9c4, field offset : 0, access : RO, ptp_rx_lane6_calc_data_offset.data_offset
input  [31:0] ptp_rx_lane6_calc_data_offset_data_offset_i,
// register offset : 0x9c8, field offset : 0, access : RO, ptp_tx_lane6_calc_data_time.data_time
input  [27:0] ptp_tx_lane6_calc_data_time_data_time_i,
// register offset : 0x9cc, field offset : 0, access : RO, ptp_rx_lane6_calc_data_time.data_time
input  [27:0] ptp_rx_lane6_calc_data_time_data_time_i,
// register offset : 0x9d0, field offset : 0, access : RO, ptp_tx_lane6_calc_data_wiredelay.data_wiredelay
input  [19:0] ptp_tx_lane6_calc_data_wiredelay_data_wiredelay_i,
// register offset : 0x9d4, field offset : 0, access : RO, ptp_rx_lane6_calc_data_wiredelay.data_wiredelay
input  [19:0] ptp_rx_lane6_calc_data_wiredelay_data_wiredelay_i,
// register offset : 0x9e0, field offset : 0, access : RO, ptp_tx_lane7_calc_data_offset.data_offset
input  [31:0] ptp_tx_lane7_calc_data_offset_data_offset_i,
// register offset : 0x9e4, field offset : 0, access : RO, ptp_rx_lane7_calc_data_offset.data_offset
input  [31:0] ptp_rx_lane7_calc_data_offset_data_offset_i,
// register offset : 0x9e8, field offset : 0, access : RO, ptp_tx_lane7_calc_data_time.data_time
input  [27:0] ptp_tx_lane7_calc_data_time_data_time_i,
// register offset : 0x9ec, field offset : 0, access : RO, ptp_rx_lane7_calc_data_time.data_time
input  [27:0] ptp_rx_lane7_calc_data_time_data_time_i,
// register offset : 0x9f0, field offset : 0, access : RO, ptp_tx_lane7_calc_data_wiredelay.data_wiredelay
input  [19:0] ptp_tx_lane7_calc_data_wiredelay_data_wiredelay_i,
// register offset : 0x9f4, field offset : 0, access : RO, ptp_rx_lane7_calc_data_wiredelay.data_wiredelay
input  [19:0] ptp_rx_lane7_calc_data_wiredelay_data_wiredelay_i,
//Bus Interface
input clk,
input reset,
input [31:0] writedata,
input read,
input write,
input [3:0] byteenable,
output reg [31:0] readdata,
output reg readdatavalid,
input [11:0] address

);

wire reset_n = !reset;	
// Protocol management
// combinatorial read data signal declaration
reg [31:0] rdata_comb;

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
wire [11:0] addr = address[11:0];
wire [31:0] din  = writedata [31:0];
// A write byte enable for each register
// register ptp_tx_tam_adjust with  writeType: write
wire	[3:0]  we_ptp_tx_tam_adjust		=	we  & (addr[11:0]  == 12'h800)	?	byteenable[3:0]	:	{4{1'b0}};
// register ptp_rx_tam_adjust with  writeType: write
wire	[3:0]  we_ptp_rx_tam_adjust		=	we  & (addr[11:0]  == 12'h804)	?	byteenable[3:0]	:	{4{1'b0}};
// register ptp_ref_lane with  writeType: write
wire	  we_ptp_ref_lane		=	we  & (addr[11:0]  == 12'h80c)	?	byteenable[0]	:	1'b0;
// register ptp_dr_cfg with  writeType: write
wire	  we_ptp_dr_cfg		=	we  & (addr[11:0]  == 12'h810)	?	byteenable[0]	:	1'b0;
// register ptp_tx_user_cfg_status with  writeType: write
wire	  we_ptp_tx_user_cfg_status		=	we  & (addr[11:0]  == 12'h814)	?	byteenable[0]	:	1'b0;
// register ptp_rx_user_cfg_status with  writeType: write
wire	  we_ptp_rx_user_cfg_status		=	we  & (addr[11:0]  == 12'h818)	?	byteenable[0]	:	1'b0;
// register ptp_uim_tam_snapshot with  writeType: write
wire	  we_ptp_uim_tam_snapshot		=	we  & (addr[11:0]  == 12'h81c)	?	byteenable[0]	:	1'b0;

// A read byte enable for each register


/* Definitions of REGISTER "ptp_tx_tam_adjust" */

// ptp_tx_tam_adjust_tam_adjust
// bitfield description: calculated TAM adjustment value
// 32 bit of TAM adjustment value for specific physical lane
// 
// 
// Write value must not be zero. See User Guide for calculation details.
// Resetting the respective TX or RX datapath, or the entire core will clear the bits to 0
// RX only, rx_pcs_fully_aligned deassertion will clear the bits to 0
// customType:  RW
// hwAccess: RO 
// reset value : 0x00000000 
// inputPort: ptp_tx_tam_adjust_tam_adjust_hwclr 
// modifiedTriggerPort:  "ptp_tx_tam_adjust_tam_adjust_modTrig"  
// hardware clear:  "ptp_tx_tam_adjust_tam_adjust_hwclr"  


// Modified Trigger  Port for :ptp_tx_tam_adjust_tam_adjust
always  @( posedge clk )
   begin if(!reset_n) begin
      ptp_tx_tam_adjust_tam_adjust_modTrig		<=	1'b0;
      end
   else  begin  
      ptp_tx_tam_adjust_tam_adjust_modTrig		<=	( we_ptp_tx_tam_adjust[0]&& (din [7:0]  !=ptp_tx_tam_adjust_tam_adjust[7:0]) )|( we_ptp_tx_tam_adjust[1]&& (din [15:8]  !=ptp_tx_tam_adjust_tam_adjust[15:8]) )|( we_ptp_tx_tam_adjust[2]&& (din [23:16]  !=ptp_tx_tam_adjust_tam_adjust[23:16]) )|( we_ptp_tx_tam_adjust[3]&& (din [31:24]  !=ptp_tx_tam_adjust_tam_adjust[31:24]) );
      end
   end
reg  ptp_tx_tam_adjust_tam_adjust_hwclr_sync;
always @( posedge clk)
   if (!reset_n)  begin
       ptp_tx_tam_adjust_tam_adjust_hwclr_sync <= 1'h0;
   end else begin
       ptp_tx_tam_adjust_tam_adjust_hwclr_sync <=  ptp_tx_tam_adjust_tam_adjust_hwclr;
   end
	

wire hw_we_hwclr_ptp_tx_tam_adjust_tam_adjust = (ptp_tx_tam_adjust_tam_adjust_hwclr ^ ptp_tx_tam_adjust_tam_adjust_hwclr_sync) & ~(ptp_tx_tam_adjust_tam_adjust_hwclr ^ 1'b1);

always @( posedge clk)
   if (!reset_n)  begin
      ptp_tx_tam_adjust_tam_adjust <= 32'h00000000;
   end
   else begin
   if (we_ptp_tx_tam_adjust[0]) begin 
      ptp_tx_tam_adjust_tam_adjust[7:0]   <=  din[7:0];  //
   end
   if (we_ptp_tx_tam_adjust[1]) begin 
      ptp_tx_tam_adjust_tam_adjust[15:8]   <=  din[15:8];  //
   end
   if (we_ptp_tx_tam_adjust[2]) begin 
      ptp_tx_tam_adjust_tam_adjust[23:16]   <=  din[23:16];  //
   end
   if (we_ptp_tx_tam_adjust[3]) begin 
      ptp_tx_tam_adjust_tam_adjust[31:24]   <=  din[31:24];  //
   end
   else if (hw_we_hwclr_ptp_tx_tam_adjust_tam_adjust && !we_ptp_tx_tam_adjust[0] && !we_ptp_tx_tam_adjust[1] && !we_ptp_tx_tam_adjust[2] && !we_ptp_tx_tam_adjust[3]) begin
      ptp_tx_tam_adjust_tam_adjust[31:0]<=  32'b00000000000000000000000000000000; // hw to clear
   end
end
/* Definitions of REGISTER "ptp_rx_tam_adjust" */

// ptp_rx_tam_adjust_tam_adjust
// bitfield description: calculated TAM adjustment value
// 32 bit of TAM adjustment value for specific physical lane
// 
// 
// Write value must not be zero. See User Guide for calculation details.
// Resetting the respective TX or RX datapath, or the entire core will clear the bits to 0
// RX only, rx_pcs_fully_aligned deassertion will clear the bits to 0
// customType:  RW
// hwAccess: RO 
// reset value : 0x00000000 
// inputPort: ptp_rx_tam_adjust_tam_adjust_hwclr 
// modifiedTriggerPort:  "ptp_rx_tam_adjust_tam_adjust_modTrig"  
// hardware clear:  "ptp_rx_tam_adjust_tam_adjust_hwclr"  


// Modified Trigger  Port for :ptp_rx_tam_adjust_tam_adjust
always  @( posedge clk )
   begin if(!reset_n) begin
      ptp_rx_tam_adjust_tam_adjust_modTrig		<=	1'b0;
      end
   else  begin  
      ptp_rx_tam_adjust_tam_adjust_modTrig		<=	( we_ptp_rx_tam_adjust[0]&& (din [7:0]  !=ptp_rx_tam_adjust_tam_adjust[7:0]) )|( we_ptp_rx_tam_adjust[1]&& (din [15:8]  !=ptp_rx_tam_adjust_tam_adjust[15:8]) )|( we_ptp_rx_tam_adjust[2]&& (din [23:16]  !=ptp_rx_tam_adjust_tam_adjust[23:16]) )|( we_ptp_rx_tam_adjust[3]&& (din [31:24]  !=ptp_rx_tam_adjust_tam_adjust[31:24]) );
      end
   end
reg  ptp_rx_tam_adjust_tam_adjust_hwclr_sync;
always @( posedge clk)
   if (!reset_n)  begin
       ptp_rx_tam_adjust_tam_adjust_hwclr_sync <= 1'h0;
   end else begin
       ptp_rx_tam_adjust_tam_adjust_hwclr_sync <=  ptp_rx_tam_adjust_tam_adjust_hwclr;
   end
	

wire hw_we_hwclr_ptp_rx_tam_adjust_tam_adjust = (ptp_rx_tam_adjust_tam_adjust_hwclr ^ ptp_rx_tam_adjust_tam_adjust_hwclr_sync) & ~(ptp_rx_tam_adjust_tam_adjust_hwclr ^ 1'b1);

always @( posedge clk)
   if (!reset_n)  begin
      ptp_rx_tam_adjust_tam_adjust <= 32'h00000000;
   end
   else begin
   if (we_ptp_rx_tam_adjust[0]) begin 
      ptp_rx_tam_adjust_tam_adjust[7:0]   <=  din[7:0];  //
   end
   if (we_ptp_rx_tam_adjust[1]) begin 
      ptp_rx_tam_adjust_tam_adjust[15:8]   <=  din[15:8];  //
   end
   if (we_ptp_rx_tam_adjust[2]) begin 
      ptp_rx_tam_adjust_tam_adjust[23:16]   <=  din[23:16];  //
   end
   if (we_ptp_rx_tam_adjust[3]) begin 
      ptp_rx_tam_adjust_tam_adjust[31:24]   <=  din[31:24];  //
   end
   else if (hw_we_hwclr_ptp_rx_tam_adjust_tam_adjust && !we_ptp_rx_tam_adjust[0] && !we_ptp_rx_tam_adjust[1] && !we_ptp_rx_tam_adjust[2] && !we_ptp_rx_tam_adjust[3]) begin
      ptp_rx_tam_adjust_tam_adjust[31:0]<=  32'b00000000000000000000000000000000; // hw to clear
   end
end
/* Definitions of REGISTER "ptp_ref_lane" */

// ptp_ref_lane_tx_ref_lane
// bitfield description: TX reference lane
// 3 bit number of TX physical lane (any can be reference)
// 
// 
// Resetting TX datapath, or the entire core will clear this bit to 0
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 
// inputPort: ptp_ref_lane_tx_ref_lane_hwclr 
// modifiedTriggerPort:  "ptp_ref_lane_tx_ref_lane_modTrig"  
// hardware clear:  "ptp_ref_lane_tx_ref_lane_hwclr"  


// Modified Trigger  Port for :ptp_ref_lane_tx_ref_lane
always  @( posedge clk )
   begin if(!reset_n) begin
      ptp_ref_lane_tx_ref_lane_modTrig		<=	1'b0;
      end
   else  begin  
      ptp_ref_lane_tx_ref_lane_modTrig		<=	( we_ptp_ref_lane&& (din [2:0]  !=ptp_ref_lane_tx_ref_lane[2:0]) );
      end
   end
reg  ptp_ref_lane_tx_ref_lane_hwclr_sync;
always @( posedge clk)
   if (!reset_n)  begin
       ptp_ref_lane_tx_ref_lane_hwclr_sync <= 1'h0;
   end else begin
       ptp_ref_lane_tx_ref_lane_hwclr_sync <=  ptp_ref_lane_tx_ref_lane_hwclr;
   end
	

wire hw_we_hwclr_ptp_ref_lane_tx_ref_lane = (ptp_ref_lane_tx_ref_lane_hwclr ^ ptp_ref_lane_tx_ref_lane_hwclr_sync) & ~(ptp_ref_lane_tx_ref_lane_hwclr ^ 1'b1);

always @( posedge clk)
   if (!reset_n)  begin
      ptp_ref_lane_tx_ref_lane <= 3'h0;
   end
   else begin
   if (we_ptp_ref_lane) begin 
      ptp_ref_lane_tx_ref_lane[2:0]   <=  din[2:0];  //
   end
   else if (hw_we_hwclr_ptp_ref_lane_tx_ref_lane && !we_ptp_ref_lane) begin
      ptp_ref_lane_tx_ref_lane[2:0]<=  3'b000; // hw to clear
   end
end

// ptp_ref_lane_rx_ref_lane
// bitfield description: RX reference lane
// 3 bit number of RX physical lane which packet last arrives at
// 
// 
// rx_pcs_fully_aligned deassertion will clear the bits to 0
// Resetting RX datapath or the entire core will also clear the bits to 0
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 
// inputPort: ptp_ref_lane_rx_ref_lane_hwclr 
// modifiedTriggerPort:  "ptp_ref_lane_rx_ref_lane_modTrig"  
// hardware clear:  "ptp_ref_lane_rx_ref_lane_hwclr"  


// Modified Trigger  Port for :ptp_ref_lane_rx_ref_lane
always  @( posedge clk )
   begin if(!reset_n) begin
      ptp_ref_lane_rx_ref_lane_modTrig		<=	1'b0;
      end
   else  begin  
      ptp_ref_lane_rx_ref_lane_modTrig		<=	( we_ptp_ref_lane&& (din [5:3]  !=ptp_ref_lane_rx_ref_lane[2:0]) );
      end
   end
reg  ptp_ref_lane_rx_ref_lane_hwclr_sync;
always @( posedge clk)
   if (!reset_n)  begin
       ptp_ref_lane_rx_ref_lane_hwclr_sync <= 1'h0;
   end else begin
       ptp_ref_lane_rx_ref_lane_hwclr_sync <=  ptp_ref_lane_rx_ref_lane_hwclr;
   end
	

wire hw_we_hwclr_ptp_ref_lane_rx_ref_lane = (ptp_ref_lane_rx_ref_lane_hwclr ^ ptp_ref_lane_rx_ref_lane_hwclr_sync) & ~(ptp_ref_lane_rx_ref_lane_hwclr ^ 1'b1);

always @( posedge clk)
   if (!reset_n)  begin
      ptp_ref_lane_rx_ref_lane <= 3'h0;
   end
   else begin
   if (we_ptp_ref_lane) begin 
      ptp_ref_lane_rx_ref_lane[2:0]   <=  din[5:3];  //
   end
   else if (hw_we_hwclr_ptp_ref_lane_rx_ref_lane && !we_ptp_ref_lane) begin
      ptp_ref_lane_rx_ref_lane[2:0]<=  3'b000; // hw to clear
   end
end
/* Definitions of REGISTER "ptp_dr_cfg" */

// ptp_dr_cfg_tx_ehip_preamble_passthrough
// bitfield description: This bit should be identical to EHIP TX Preamble Passthrough setting value
// 1: EHIP Preamble Passthrough enabled 0: EHIP Preamble Passthrough disabled
// customType:  RW
// hwAccess: RO 
// reset Value signal:  "ptp_dr_cfg_tx_ehip_preamble_passthrough_reset_value" 


always @( posedge clk)
   if (!reset_n)  begin
      ptp_dr_cfg_tx_ehip_preamble_passthrough <= ptp_dr_cfg_tx_ehip_preamble_passthrough_reset_value;
   end
   else begin
   if (we_ptp_dr_cfg) begin 
      ptp_dr_cfg_tx_ehip_preamble_passthrough   <=  din[0];  //
   end
end
/* Definitions of REGISTER "ptp_tx_user_cfg_status" */

// ptp_tx_user_cfg_status_tx_user_cfg_done
// bitfield description: indicates user has completed all necessary TX configuration:
// 1: Configured 0: Not configured yet
// 
// has programmed TX TAM adjustment to Soft IP
// has programmed TX extra latency to Hard IP
// has programmed TX VL offset to Hard IP (Multi-lane variant only)
// Register value will be automatically cleared in the following condition:
// tx_lanes_stable deassertion
// Resetting TX datapath or the entire core
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 
// inputPort: ptp_tx_user_cfg_status_tx_user_cfg_done_hwclr 
// hardware clear:  "ptp_tx_user_cfg_status_tx_user_cfg_done_hwclr"  

reg  ptp_tx_user_cfg_status_tx_user_cfg_done_hwclr_sync;
always @( posedge clk)
   if (!reset_n)  begin
       ptp_tx_user_cfg_status_tx_user_cfg_done_hwclr_sync <= 1'h0;
   end else begin
       ptp_tx_user_cfg_status_tx_user_cfg_done_hwclr_sync <=  ptp_tx_user_cfg_status_tx_user_cfg_done_hwclr;
   end
	

wire hw_we_hwclr_ptp_tx_user_cfg_status_tx_user_cfg_done = (ptp_tx_user_cfg_status_tx_user_cfg_done_hwclr ^ ptp_tx_user_cfg_status_tx_user_cfg_done_hwclr_sync) & ~(ptp_tx_user_cfg_status_tx_user_cfg_done_hwclr ^ 1'b1);

always @( posedge clk)
   if (!reset_n)  begin
      ptp_tx_user_cfg_status_tx_user_cfg_done <= 1'h0;
   end
   else begin
   if (we_ptp_tx_user_cfg_status) begin 
      ptp_tx_user_cfg_status_tx_user_cfg_done   <=  din[0];  //
   end
   else if (hw_we_hwclr_ptp_tx_user_cfg_status_tx_user_cfg_done && !we_ptp_tx_user_cfg_status) begin
      ptp_tx_user_cfg_status_tx_user_cfg_done<=  1'b0; // hw to clear
   end
end
/* Definitions of REGISTER "ptp_rx_user_cfg_status" */

// ptp_rx_user_cfg_status_rx_user_cfg_done
// bitfield description: indicates user has completed all necessary RX configuration
// 1: Configured 0: Not configured yet
// 
// has programmed RX TAM adjustment to Soft IP
// has programmed RX extra latency to Hard IP
// has programmed RX VL offset to Hard IP (Multi-lane variant only)
// Register value will be automatically cleared in the following condition:
// rx_pcs_fully_aligned deassertion
// Resetting RX datapath or the entire core
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 
// inputPort: ptp_rx_user_cfg_status_rx_user_cfg_done_hwclr 
// hardware clear:  "ptp_rx_user_cfg_status_rx_user_cfg_done_hwclr"  

reg  ptp_rx_user_cfg_status_rx_user_cfg_done_hwclr_sync;
always @( posedge clk)
   if (!reset_n)  begin
       ptp_rx_user_cfg_status_rx_user_cfg_done_hwclr_sync <= 1'h0;
   end else begin
       ptp_rx_user_cfg_status_rx_user_cfg_done_hwclr_sync <=  ptp_rx_user_cfg_status_rx_user_cfg_done_hwclr;
   end
	

wire hw_we_hwclr_ptp_rx_user_cfg_status_rx_user_cfg_done = (ptp_rx_user_cfg_status_rx_user_cfg_done_hwclr ^ ptp_rx_user_cfg_status_rx_user_cfg_done_hwclr_sync) & ~(ptp_rx_user_cfg_status_rx_user_cfg_done_hwclr ^ 1'b1);

always @( posedge clk)
   if (!reset_n)  begin
      ptp_rx_user_cfg_status_rx_user_cfg_done <= 1'h0;
   end
   else begin
   if (we_ptp_rx_user_cfg_status) begin 
      ptp_rx_user_cfg_status_rx_user_cfg_done   <=  din[0];  //
   end
   else if (hw_we_hwclr_ptp_rx_user_cfg_status_rx_user_cfg_done && !we_ptp_rx_user_cfg_status) begin
      ptp_rx_user_cfg_status_rx_user_cfg_done<=  1'b0; // hw to clear
   end
end

// ptp_rx_user_cfg_status_rx_fec_cw_pos_cfg_done
// bitfield description: indicates user has configured Hard IP's RX FEC codeword position register
// 1: Configured 0: Not configured yet
// 
// Register value will be automatically cleared in the following condition:
// rx_pcs_fully_aligned deassertion
// Resetting RX datapath or the entire core
// customType:  RW
// hwAccess: RO 
// reset value : 0x0 
// inputPort: ptp_rx_user_cfg_status_rx_fec_cw_pos_cfg_done_hwclr 
// hardware clear:  "ptp_rx_user_cfg_status_rx_fec_cw_pos_cfg_done_hwclr"  

reg  ptp_rx_user_cfg_status_rx_fec_cw_pos_cfg_done_hwclr_sync;
always @( posedge clk)
   if (!reset_n)  begin
       ptp_rx_user_cfg_status_rx_fec_cw_pos_cfg_done_hwclr_sync <= 1'h0;
   end else begin
       ptp_rx_user_cfg_status_rx_fec_cw_pos_cfg_done_hwclr_sync <=  ptp_rx_user_cfg_status_rx_fec_cw_pos_cfg_done_hwclr;
   end
	

wire hw_we_hwclr_ptp_rx_user_cfg_status_rx_fec_cw_pos_cfg_done = (ptp_rx_user_cfg_status_rx_fec_cw_pos_cfg_done_hwclr ^ ptp_rx_user_cfg_status_rx_fec_cw_pos_cfg_done_hwclr_sync) & ~(ptp_rx_user_cfg_status_rx_fec_cw_pos_cfg_done_hwclr ^ 1'b1);

always @( posedge clk)
   if (!reset_n)  begin
      ptp_rx_user_cfg_status_rx_fec_cw_pos_cfg_done <= 1'h0;
   end
   else begin
   if (we_ptp_rx_user_cfg_status) begin 
      ptp_rx_user_cfg_status_rx_fec_cw_pos_cfg_done   <=  din[1];  //
   end
   else if (hw_we_hwclr_ptp_rx_user_cfg_status_rx_fec_cw_pos_cfg_done && !we_ptp_rx_user_cfg_status) begin
      ptp_rx_user_cfg_status_rx_fec_cw_pos_cfg_done<=  1'b0; // hw to clear
   end
end
/* Definitions of REGISTER "ptp_uim_tam_snapshot" */

// ptp_uim_tam_snapshot_tx_tam_snapshot
// bitfield description: Set this bit to 1'b1 to request TX TAM snapshot
// Asserting this bit generates a single pulse to hardware
// customType:  ReturnToZero
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      ptp_uim_tam_snapshot_tx_tam_snapshot <= 1'h0;
   end
   else begin
   
   if (we_ptp_uim_tam_snapshot) begin 
      ptp_uim_tam_snapshot_tx_tam_snapshot   <=  din[0];  //
   end else begin
        ptp_uim_tam_snapshot_tx_tam_snapshot   <=   1'b0;
   end
end

// ptp_uim_tam_snapshot_rx_tam_snapshot
// bitfield description: Set this bit to 1'b1 to request RX TAM snapshot
// Asserting this bit generates a single pulse to hardware
// customType:  ReturnToZero
// hwAccess: RO 
// reset value : 0x0 


always @( posedge clk)
   if (!reset_n)  begin
      ptp_uim_tam_snapshot_rx_tam_snapshot <= 1'h0;
   end
   else begin
   
   if (we_ptp_uim_tam_snapshot) begin 
      ptp_uim_tam_snapshot_rx_tam_snapshot   <=  din[1];  //
   end else begin
        ptp_uim_tam_snapshot_rx_tam_snapshot   <=   1'b0;
   end
end
/* Definitions of REGISTER "ptp_tx_uim_tam_info0" */

// ptp_tx_uim_tam_info0_tam_31_0
// bitfield description: TAM lower bits
// bit 31-0 of TAM
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: ptp_tx_uim_tam_info0_tam_31_0_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_uim_tam_info1" */

// ptp_tx_uim_tam_info1_tam_47_32
// bitfield description: TAM upper bits
// bit 47-32 of TAM
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000 
// inputPort: ptp_tx_uim_tam_info1_tam_47_32_i 
// outputPort:  "" 
// NO register generated




// ptp_tx_uim_tam_info1_tam_cnt
// bitfield description: TAM counter
// 15 bits of TAM counter
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000 
// inputPort: ptp_tx_uim_tam_info1_tam_cnt_i 
// outputPort:  "" 
// NO register generated




// ptp_tx_uim_tam_info1_tam_valid
// bitfield description: TAM valid
// 1 bits of TAM valid
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: ptp_tx_uim_tam_info1_tam_valid_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_uim_tam_info0" */

// ptp_rx_uim_tam_info0_tam_31_0
// bitfield description: TAM lower bits
// bit 31-0 of TAM
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: ptp_rx_uim_tam_info0_tam_31_0_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_uim_tam_info1" */

// ptp_rx_uim_tam_info1_tam_47_32
// bitfield description: TAM upper bits
// bit 47-32 of TAM
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000 
// inputPort: ptp_rx_uim_tam_info1_tam_47_32_i 
// outputPort:  "" 
// NO register generated




// ptp_rx_uim_tam_info1_tam_cnt
// bitfield description: TAM counter
// 15 bits of TAM counter
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000 
// inputPort: ptp_rx_uim_tam_info1_tam_cnt_i 
// outputPort:  "" 
// NO register generated




// ptp_rx_uim_tam_info1_tam_valid
// bitfield description: TAM valid
// 1 bits of TAM valid
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: ptp_rx_uim_tam_info1_tam_valid_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_status" */

// ptp_status_tx_ptp_offset_data_valid
// bitfield description: TX calculation data valid/ready to read
// 1: valid
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: ptp_status_tx_ptp_offset_data_valid_i 
// outputPort:  "" 
// NO register generated




// ptp_status_rx_ptp_offset_data_valid
// bitfield description: RX calculation data valid/ready to read
// 1: valid
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: ptp_status_rx_ptp_offset_data_valid_i 
// outputPort:  "" 
// NO register generated




// ptp_status_tx_ptp_ready
// bitfield description: TX PTP is ready
// 1: ready
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: ptp_status_tx_ptp_ready_i 
// outputPort:  "" 
// NO register generated




// ptp_status_rx_ptp_ready
// bitfield description: RX PTP is ready
// 1: ready
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: ptp_status_rx_ptp_ready_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_status2" */

// ptp_status2_tx_calc_data_offset_valid
// bitfield description: TX calculation data 'time offset' is valid/ready to read
// 1: valid
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: ptp_status2_tx_calc_data_offset_valid_i 
// outputPort:  "" 
// NO register generated




// ptp_status2_tx_calc_data_time_valid
// bitfield description: TX calculation data 'time' is valid/ready to read
// 1: valid
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: ptp_status2_tx_calc_data_time_valid_i 
// outputPort:  "" 
// NO register generated




// ptp_status2_tx_calc_data_wiredelay_valid
// bitfield description: TX calculation data 'wire delay' is valid/ready to read
// 1: valid
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: ptp_status2_tx_calc_data_wiredelay_valid_i 
// outputPort:  "" 
// NO register generated




// ptp_status2_rx_calc_data_offset_valid
// bitfield description: RX calculation data 'time offset' is valid/ready to read
// 1: valid
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: ptp_status2_rx_calc_data_offset_valid_i 
// outputPort:  "" 
// NO register generated




// ptp_status2_rx_calc_data_time_valid
// bitfield description: RX calculation data 'time' is valid/ready to read
// 1: valid
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: ptp_status2_rx_calc_data_time_valid_i 
// outputPort:  "" 
// NO register generated




// ptp_status2_rx_calc_data_wiredelay_valid
// bitfield description: RX calculation data 'wire delay' is valid/ready to read
// 1: valid
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: ptp_status2_rx_calc_data_wiredelay_valid_i 
// outputPort:  "" 
// NO register generated




// ptp_status2_rx_vl_offset_data_ready
// bitfield description: (For multilane non-fec variant only)RX VL raw data in EHIP is ready to read
// 1: ready
// customType:  RO
// hwAccess: WO 
// reset value : 0x0 
// inputPort: ptp_status2_rx_vl_offset_data_ready_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane_calc_data_constdelay" */

// ptp_tx_lane_calc_data_constdelay_data_constdelay
// bitfield description: constant delay value used in TAM adjustment calculation
// constant delay for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: ptp_tx_lane_calc_data_constdelay_data_constdelay_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane_calc_data_constdelay" */

// ptp_rx_lane_calc_data_constdelay_data_constdelay
// bitfield description: constant delay value used in TAM adjustment calculation
// constant delay for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: ptp_rx_lane_calc_data_constdelay_data_constdelay_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane0_calc_data_offset" */

// ptp_tx_lane0_calc_data_offset_data_offset
// bitfield description: time offset value used in TAM adjustment calculation
// time offset for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: ptp_tx_lane0_calc_data_offset_data_offset_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane0_calc_data_offset" */

// ptp_rx_lane0_calc_data_offset_data_offset
// bitfield description: time offset value used in TAM adjustment calculation
// time offset for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: ptp_rx_lane0_calc_data_offset_data_offset_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane0_calc_data_time" */

// ptp_tx_lane0_calc_data_time_data_time
// bitfield description: time value used in TAM adjustment calculation
// marker time for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000000 
// inputPort: ptp_tx_lane0_calc_data_time_data_time_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane0_calc_data_time" */

// ptp_rx_lane0_calc_data_time_data_time
// bitfield description: time value used in TAM adjustment calculation
// marker time for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000000 
// inputPort: ptp_rx_lane0_calc_data_time_data_time_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane0_calc_data_wiredelay" */

// ptp_tx_lane0_calc_data_wiredelay_data_wiredelay
// bitfield description: wire delay value used in TAM adjustment calculation
// wire delay for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000 
// inputPort: ptp_tx_lane0_calc_data_wiredelay_data_wiredelay_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane0_calc_data_wiredelay" */

// ptp_rx_lane0_calc_data_wiredelay_data_wiredelay
// bitfield description: wire delay value used in TAM adjustment calculation
// wire delay for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000 
// inputPort: ptp_rx_lane0_calc_data_wiredelay_data_wiredelay_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane1_calc_data_offset" */

// ptp_tx_lane1_calc_data_offset_data_offset
// bitfield description: time offset value used in TAM adjustment calculation
// time offset for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: ptp_tx_lane1_calc_data_offset_data_offset_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane1_calc_data_offset" */

// ptp_rx_lane1_calc_data_offset_data_offset
// bitfield description: time offset value used in TAM adjustment calculation
// time offset for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: ptp_rx_lane1_calc_data_offset_data_offset_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane1_calc_data_time" */

// ptp_tx_lane1_calc_data_time_data_time
// bitfield description: time value used in TAM adjustment calculation
// marker time for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000000 
// inputPort: ptp_tx_lane1_calc_data_time_data_time_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane1_calc_data_time" */

// ptp_rx_lane1_calc_data_time_data_time
// bitfield description: time value used in TAM adjustment calculation
// marker time for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000000 
// inputPort: ptp_rx_lane1_calc_data_time_data_time_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane1_calc_data_wiredelay" */

// ptp_tx_lane1_calc_data_wiredelay_data_wiredelay
// bitfield description: wire delay value used in TAM adjustment calculation
// wire delay for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000 
// inputPort: ptp_tx_lane1_calc_data_wiredelay_data_wiredelay_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane1_calc_data_wiredelay" */

// ptp_rx_lane1_calc_data_wiredelay_data_wiredelay
// bitfield description: wire delay value used in TAM adjustment calculation
// wire delay for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000 
// inputPort: ptp_rx_lane1_calc_data_wiredelay_data_wiredelay_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane2_calc_data_offset" */

// ptp_tx_lane2_calc_data_offset_data_offset
// bitfield description: time offset value used in TAM adjustment calculation
// time offset for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: ptp_tx_lane2_calc_data_offset_data_offset_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane2_calc_data_offset" */

// ptp_rx_lane2_calc_data_offset_data_offset
// bitfield description: time offset value used in TAM adjustment calculation
// time offset for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: ptp_rx_lane2_calc_data_offset_data_offset_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane2_calc_data_time" */

// ptp_tx_lane2_calc_data_time_data_time
// bitfield description: time value used in TAM adjustment calculation
// marker time for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000000 
// inputPort: ptp_tx_lane2_calc_data_time_data_time_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane2_calc_data_time" */

// ptp_rx_lane2_calc_data_time_data_time
// bitfield description: time value used in TAM adjustment calculation
// marker time for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000000 
// inputPort: ptp_rx_lane2_calc_data_time_data_time_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane2_calc_data_wiredelay" */

// ptp_tx_lane2_calc_data_wiredelay_data_wiredelay
// bitfield description: wire delay value used in TAM adjustment calculation
// wire delay for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000 
// inputPort: ptp_tx_lane2_calc_data_wiredelay_data_wiredelay_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane2_calc_data_wiredelay" */

// ptp_rx_lane2_calc_data_wiredelay_data_wiredelay
// bitfield description: wire delay value used in TAM adjustment calculation
// wire delay for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000 
// inputPort: ptp_rx_lane2_calc_data_wiredelay_data_wiredelay_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane3_calc_data_offset" */

// ptp_tx_lane3_calc_data_offset_data_offset
// bitfield description: time offset value used in TAM adjustment calculation
// time offset for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: ptp_tx_lane3_calc_data_offset_data_offset_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane3_calc_data_offset" */

// ptp_rx_lane3_calc_data_offset_data_offset
// bitfield description: time offset value used in TAM adjustment calculation
// time offset for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: ptp_rx_lane3_calc_data_offset_data_offset_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane3_calc_data_time" */

// ptp_tx_lane3_calc_data_time_data_time
// bitfield description: time value used in TAM adjustment calculation
// marker time for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000000 
// inputPort: ptp_tx_lane3_calc_data_time_data_time_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane3_calc_data_time" */

// ptp_rx_lane3_calc_data_time_data_time
// bitfield description: time value used in TAM adjustment calculation
// marker time for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000000 
// inputPort: ptp_rx_lane3_calc_data_time_data_time_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane3_calc_data_wiredelay" */

// ptp_tx_lane3_calc_data_wiredelay_data_wiredelay
// bitfield description: wire delay value used in TAM adjustment calculation
// wire delay for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000 
// inputPort: ptp_tx_lane3_calc_data_wiredelay_data_wiredelay_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane3_calc_data_wiredelay" */

// ptp_rx_lane3_calc_data_wiredelay_data_wiredelay
// bitfield description: wire delay value used in TAM adjustment calculation
// wire delay for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000 
// inputPort: ptp_rx_lane3_calc_data_wiredelay_data_wiredelay_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane4_calc_data_offset" */

// ptp_tx_lane4_calc_data_offset_data_offset
// bitfield description: time offset value used in TAM adjustment calculation
// time offset for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: ptp_tx_lane4_calc_data_offset_data_offset_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane4_calc_data_offset" */

// ptp_rx_lane4_calc_data_offset_data_offset
// bitfield description: time offset value used in TAM adjustment calculation
// time offset for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: ptp_rx_lane4_calc_data_offset_data_offset_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane4_calc_data_time" */

// ptp_tx_lane4_calc_data_time_data_time
// bitfield description: time value used in TAM adjustment calculation
// marker time for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000000 
// inputPort: ptp_tx_lane4_calc_data_time_data_time_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane4_calc_data_time" */

// ptp_rx_lane4_calc_data_time_data_time
// bitfield description: time value used in TAM adjustment calculation
// marker time for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000000 
// inputPort: ptp_rx_lane4_calc_data_time_data_time_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane4_calc_data_wiredelay" */

// ptp_tx_lane4_calc_data_wiredelay_data_wiredelay
// bitfield description: wire delay value used in TAM adjustment calculation
// wire delay for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000 
// inputPort: ptp_tx_lane4_calc_data_wiredelay_data_wiredelay_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane4_calc_data_wiredelay" */

// ptp_rx_lane4_calc_data_wiredelay_data_wiredelay
// bitfield description: wire delay value used in TAM adjustment calculation
// wire delay for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000 
// inputPort: ptp_rx_lane4_calc_data_wiredelay_data_wiredelay_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane5_calc_data_offset" */

// ptp_tx_lane5_calc_data_offset_data_offset
// bitfield description: time offset value used in TAM adjustment calculation
// time offset for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: ptp_tx_lane5_calc_data_offset_data_offset_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane5_calc_data_offset" */

// ptp_rx_lane5_calc_data_offset_data_offset
// bitfield description: time offset value used in TAM adjustment calculation
// time offset for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: ptp_rx_lane5_calc_data_offset_data_offset_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane5_calc_data_time" */

// ptp_tx_lane5_calc_data_time_data_time
// bitfield description: time value used in TAM adjustment calculation
// marker time for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000000 
// inputPort: ptp_tx_lane5_calc_data_time_data_time_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane5_calc_data_time" */

// ptp_rx_lane5_calc_data_time_data_time
// bitfield description: time value used in TAM adjustment calculation
// marker time for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000000 
// inputPort: ptp_rx_lane5_calc_data_time_data_time_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane5_calc_data_wiredelay" */

// ptp_tx_lane5_calc_data_wiredelay_data_wiredelay
// bitfield description: wire delay value used in TAM adjustment calculation
// wire delay for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000 
// inputPort: ptp_tx_lane5_calc_data_wiredelay_data_wiredelay_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane5_calc_data_wiredelay" */

// ptp_rx_lane5_calc_data_wiredelay_data_wiredelay
// bitfield description: wire delay value used in TAM adjustment calculation
// wire delay for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000 
// inputPort: ptp_rx_lane5_calc_data_wiredelay_data_wiredelay_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane6_calc_data_offset" */

// ptp_tx_lane6_calc_data_offset_data_offset
// bitfield description: time offset value used in TAM adjustment calculation
// time offset for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: ptp_tx_lane6_calc_data_offset_data_offset_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane6_calc_data_offset" */

// ptp_rx_lane6_calc_data_offset_data_offset
// bitfield description: time offset value used in TAM adjustment calculation
// time offset for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: ptp_rx_lane6_calc_data_offset_data_offset_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane6_calc_data_time" */

// ptp_tx_lane6_calc_data_time_data_time
// bitfield description: time value used in TAM adjustment calculation
// marker time for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000000 
// inputPort: ptp_tx_lane6_calc_data_time_data_time_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane6_calc_data_time" */

// ptp_rx_lane6_calc_data_time_data_time
// bitfield description: time value used in TAM adjustment calculation
// marker time for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000000 
// inputPort: ptp_rx_lane6_calc_data_time_data_time_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane6_calc_data_wiredelay" */

// ptp_tx_lane6_calc_data_wiredelay_data_wiredelay
// bitfield description: wire delay value used in TAM adjustment calculation
// wire delay for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000 
// inputPort: ptp_tx_lane6_calc_data_wiredelay_data_wiredelay_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane6_calc_data_wiredelay" */

// ptp_rx_lane6_calc_data_wiredelay_data_wiredelay
// bitfield description: wire delay value used in TAM adjustment calculation
// wire delay for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000 
// inputPort: ptp_rx_lane6_calc_data_wiredelay_data_wiredelay_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane7_calc_data_offset" */

// ptp_tx_lane7_calc_data_offset_data_offset
// bitfield description: time offset value used in TAM adjustment calculation
// time offset for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: ptp_tx_lane7_calc_data_offset_data_offset_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane7_calc_data_offset" */

// ptp_rx_lane7_calc_data_offset_data_offset
// bitfield description: time offset value used in TAM adjustment calculation
// time offset for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000000 
// inputPort: ptp_rx_lane7_calc_data_offset_data_offset_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane7_calc_data_time" */

// ptp_tx_lane7_calc_data_time_data_time
// bitfield description: time value used in TAM adjustment calculation
// marker time for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000000 
// inputPort: ptp_tx_lane7_calc_data_time_data_time_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane7_calc_data_time" */

// ptp_rx_lane7_calc_data_time_data_time
// bitfield description: time value used in TAM adjustment calculation
// marker time for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x0000000 
// inputPort: ptp_rx_lane7_calc_data_time_data_time_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_tx_lane7_calc_data_wiredelay" */

// ptp_tx_lane7_calc_data_wiredelay_data_wiredelay
// bitfield description: wire delay value used in TAM adjustment calculation
// wire delay for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000 
// inputPort: ptp_tx_lane7_calc_data_wiredelay_data_wiredelay_i 
// outputPort:  "" 
// NO register generated



/* Definitions of REGISTER "ptp_rx_lane7_calc_data_wiredelay" */

// ptp_rx_lane7_calc_data_wiredelay_data_wiredelay
// bitfield description: wire delay value used in TAM adjustment calculation
// wire delay for specific physical lane
// customType:  RO
// hwAccess: WO 
// reset value : 0x00000 
// inputPort: ptp_rx_lane7_calc_data_wiredelay_data_wiredelay_i 
// outputPort:  "" 
// NO register generated





// read process
always @ (*)
begin
rdata_comb = 32'h00000000;
   if(re) begin
      case (addr)  
	12'h800 : begin
		rdata_comb [31:0]	= ptp_tx_tam_adjust_tam_adjust [31:0] ;		// readType = read   writeType =write
	end
	12'h804 : begin
		rdata_comb [31:0]	= ptp_rx_tam_adjust_tam_adjust [31:0] ;		// readType = read   writeType =write
	end
	12'h80c : begin
		rdata_comb [2:0]	= ptp_ref_lane_tx_ref_lane [2:0] ;		// readType = read   writeType =write
		rdata_comb [5:3]	= ptp_ref_lane_rx_ref_lane [2:0] ;		// readType = read   writeType =write
	end
	12'h810 : begin
		rdata_comb [0]	= ptp_dr_cfg_tx_ehip_preamble_passthrough  ;		// readType = read   writeType =write
	end
	12'h814 : begin
		rdata_comb [0]	= ptp_tx_user_cfg_status_tx_user_cfg_done  ;		// readType = read   writeType =write
	end
	12'h818 : begin
		rdata_comb [0]	= ptp_rx_user_cfg_status_rx_user_cfg_done  ;		// readType = read   writeType =write
		rdata_comb [1]	= ptp_rx_user_cfg_status_rx_fec_cw_pos_cfg_done  ;		// readType = read   writeType =write
	end
	12'h81c : begin
		rdata_comb [0]	= ptp_uim_tam_snapshot_tx_tam_snapshot  ;		// readType = read   writeType =write
		rdata_comb [1]	= ptp_uim_tam_snapshot_rx_tam_snapshot  ;		// readType = read   writeType =write
	end
	12'h820 : begin
		rdata_comb [31:0]	= ptp_tx_uim_tam_info0_tam_31_0_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h824 : begin
		rdata_comb [15:0]	= ptp_tx_uim_tam_info1_tam_47_32_i [15:0] ;		// readType = read   writeType =illegal
		rdata_comb [30:16]	= ptp_tx_uim_tam_info1_tam_cnt_i [14:0] ;		// readType = read   writeType =illegal
		rdata_comb [31]	= ptp_tx_uim_tam_info1_tam_valid_i  ;		// readType = read   writeType =illegal
	end
	12'h828 : begin
		rdata_comb [31:0]	= ptp_rx_uim_tam_info0_tam_31_0_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h82c : begin
		rdata_comb [15:0]	= ptp_rx_uim_tam_info1_tam_47_32_i [15:0] ;		// readType = read   writeType =illegal
		rdata_comb [30:16]	= ptp_rx_uim_tam_info1_tam_cnt_i [14:0] ;		// readType = read   writeType =illegal
		rdata_comb [31]	= ptp_rx_uim_tam_info1_tam_valid_i  ;		// readType = read   writeType =illegal
	end
	12'h830 : begin
		rdata_comb [0]	= ptp_status_tx_ptp_offset_data_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= ptp_status_rx_ptp_offset_data_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [2]	= ptp_status_tx_ptp_ready_i  ;		// readType = read   writeType =illegal
		rdata_comb [3]	= ptp_status_rx_ptp_ready_i  ;		// readType = read   writeType =illegal
	end
	12'h840 : begin
		rdata_comb [0]	= ptp_status2_tx_calc_data_offset_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= ptp_status2_tx_calc_data_time_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [2]	= ptp_status2_tx_calc_data_wiredelay_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [3]	= ptp_status2_rx_calc_data_offset_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [4]	= ptp_status2_rx_calc_data_time_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [5]	= ptp_status2_rx_calc_data_wiredelay_valid_i  ;		// readType = read   writeType =illegal
		rdata_comb [6]	= ptp_status2_rx_vl_offset_data_ready_i  ;		// readType = read   writeType =illegal
	end
	12'h8f0 : begin
		rdata_comb [31:0]	= ptp_tx_lane_calc_data_constdelay_data_constdelay_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h8f4 : begin
		rdata_comb [31:0]	= ptp_rx_lane_calc_data_constdelay_data_constdelay_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h900 : begin
		rdata_comb [31:0]	= ptp_tx_lane0_calc_data_offset_data_offset_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h904 : begin
		rdata_comb [31:0]	= ptp_rx_lane0_calc_data_offset_data_offset_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h908 : begin
		rdata_comb [27:0]	= ptp_tx_lane0_calc_data_time_data_time_i [27:0] ;		// readType = read   writeType =illegal
	end
	12'h90c : begin
		rdata_comb [27:0]	= ptp_rx_lane0_calc_data_time_data_time_i [27:0] ;		// readType = read   writeType =illegal
	end
	12'h910 : begin
		rdata_comb [19:0]	= ptp_tx_lane0_calc_data_wiredelay_data_wiredelay_i [19:0] ;		// readType = read   writeType =illegal
	end
	12'h914 : begin
		rdata_comb [19:0]	= ptp_rx_lane0_calc_data_wiredelay_data_wiredelay_i [19:0] ;		// readType = read   writeType =illegal
	end
	12'h920 : begin
		rdata_comb [31:0]	= ptp_tx_lane1_calc_data_offset_data_offset_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h924 : begin
		rdata_comb [31:0]	= ptp_rx_lane1_calc_data_offset_data_offset_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h928 : begin
		rdata_comb [27:0]	= ptp_tx_lane1_calc_data_time_data_time_i [27:0] ;		// readType = read   writeType =illegal
	end
	12'h92c : begin
		rdata_comb [27:0]	= ptp_rx_lane1_calc_data_time_data_time_i [27:0] ;		// readType = read   writeType =illegal
	end
	12'h930 : begin
		rdata_comb [19:0]	= ptp_tx_lane1_calc_data_wiredelay_data_wiredelay_i [19:0] ;		// readType = read   writeType =illegal
	end
	12'h934 : begin
		rdata_comb [19:0]	= ptp_rx_lane1_calc_data_wiredelay_data_wiredelay_i [19:0] ;		// readType = read   writeType =illegal
	end
	12'h940 : begin
		rdata_comb [31:0]	= ptp_tx_lane2_calc_data_offset_data_offset_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h944 : begin
		rdata_comb [31:0]	= ptp_rx_lane2_calc_data_offset_data_offset_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h948 : begin
		rdata_comb [27:0]	= ptp_tx_lane2_calc_data_time_data_time_i [27:0] ;		// readType = read   writeType =illegal
	end
	12'h94c : begin
		rdata_comb [27:0]	= ptp_rx_lane2_calc_data_time_data_time_i [27:0] ;		// readType = read   writeType =illegal
	end
	12'h950 : begin
		rdata_comb [19:0]	= ptp_tx_lane2_calc_data_wiredelay_data_wiredelay_i [19:0] ;		// readType = read   writeType =illegal
	end
	12'h954 : begin
		rdata_comb [19:0]	= ptp_rx_lane2_calc_data_wiredelay_data_wiredelay_i [19:0] ;		// readType = read   writeType =illegal
	end
	12'h960 : begin
		rdata_comb [31:0]	= ptp_tx_lane3_calc_data_offset_data_offset_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h964 : begin
		rdata_comb [31:0]	= ptp_rx_lane3_calc_data_offset_data_offset_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h968 : begin
		rdata_comb [27:0]	= ptp_tx_lane3_calc_data_time_data_time_i [27:0] ;		// readType = read   writeType =illegal
	end
	12'h96c : begin
		rdata_comb [27:0]	= ptp_rx_lane3_calc_data_time_data_time_i [27:0] ;		// readType = read   writeType =illegal
	end
	12'h970 : begin
		rdata_comb [19:0]	= ptp_tx_lane3_calc_data_wiredelay_data_wiredelay_i [19:0] ;		// readType = read   writeType =illegal
	end
	12'h974 : begin
		rdata_comb [19:0]	= ptp_rx_lane3_calc_data_wiredelay_data_wiredelay_i [19:0] ;		// readType = read   writeType =illegal
	end
	12'h980 : begin
		rdata_comb [31:0]	= ptp_tx_lane4_calc_data_offset_data_offset_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h984 : begin
		rdata_comb [31:0]	= ptp_rx_lane4_calc_data_offset_data_offset_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h988 : begin
		rdata_comb [27:0]	= ptp_tx_lane4_calc_data_time_data_time_i [27:0] ;		// readType = read   writeType =illegal
	end
	12'h98c : begin
		rdata_comb [27:0]	= ptp_rx_lane4_calc_data_time_data_time_i [27:0] ;		// readType = read   writeType =illegal
	end
	12'h990 : begin
		rdata_comb [19:0]	= ptp_tx_lane4_calc_data_wiredelay_data_wiredelay_i [19:0] ;		// readType = read   writeType =illegal
	end
	12'h994 : begin
		rdata_comb [19:0]	= ptp_rx_lane4_calc_data_wiredelay_data_wiredelay_i [19:0] ;		// readType = read   writeType =illegal
	end
	12'h9a0 : begin
		rdata_comb [31:0]	= ptp_tx_lane5_calc_data_offset_data_offset_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h9a4 : begin
		rdata_comb [31:0]	= ptp_rx_lane5_calc_data_offset_data_offset_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h9a8 : begin
		rdata_comb [27:0]	= ptp_tx_lane5_calc_data_time_data_time_i [27:0] ;		// readType = read   writeType =illegal
	end
	12'h9ac : begin
		rdata_comb [27:0]	= ptp_rx_lane5_calc_data_time_data_time_i [27:0] ;		// readType = read   writeType =illegal
	end
	12'h9b0 : begin
		rdata_comb [19:0]	= ptp_tx_lane5_calc_data_wiredelay_data_wiredelay_i [19:0] ;		// readType = read   writeType =illegal
	end
	12'h9b4 : begin
		rdata_comb [19:0]	= ptp_rx_lane5_calc_data_wiredelay_data_wiredelay_i [19:0] ;		// readType = read   writeType =illegal
	end
	12'h9c0 : begin
		rdata_comb [31:0]	= ptp_tx_lane6_calc_data_offset_data_offset_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h9c4 : begin
		rdata_comb [31:0]	= ptp_rx_lane6_calc_data_offset_data_offset_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h9c8 : begin
		rdata_comb [27:0]	= ptp_tx_lane6_calc_data_time_data_time_i [27:0] ;		// readType = read   writeType =illegal
	end
	12'h9cc : begin
		rdata_comb [27:0]	= ptp_rx_lane6_calc_data_time_data_time_i [27:0] ;		// readType = read   writeType =illegal
	end
	12'h9d0 : begin
		rdata_comb [19:0]	= ptp_tx_lane6_calc_data_wiredelay_data_wiredelay_i [19:0] ;		// readType = read   writeType =illegal
	end
	12'h9d4 : begin
		rdata_comb [19:0]	= ptp_rx_lane6_calc_data_wiredelay_data_wiredelay_i [19:0] ;		// readType = read   writeType =illegal
	end
	12'h9e0 : begin
		rdata_comb [31:0]	= ptp_tx_lane7_calc_data_offset_data_offset_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h9e4 : begin
		rdata_comb [31:0]	= ptp_rx_lane7_calc_data_offset_data_offset_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h9e8 : begin
		rdata_comb [27:0]	= ptp_tx_lane7_calc_data_time_data_time_i [27:0] ;		// readType = read   writeType =illegal
	end
	12'h9ec : begin
		rdata_comb [27:0]	= ptp_rx_lane7_calc_data_time_data_time_i [27:0] ;		// readType = read   writeType =illegal
	end
	12'h9f0 : begin
		rdata_comb [19:0]	= ptp_tx_lane7_calc_data_wiredelay_data_wiredelay_i [19:0] ;		// readType = read   writeType =illegal
	end
	12'h9f4 : begin
		rdata_comb [19:0]	= ptp_rx_lane7_calc_data_wiredelay_data_wiredelay_i [19:0] ;		// readType = read   writeType =illegal
	end
	default : begin
		rdata_comb = 32'h00000000;
	end
      endcase
   end
end

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "o2ONPYJ6JWO2K/lQHkyApXo6DVczB8sUyJtLpEiYtF7LL07s93qi8rQ7d2s1AdTOt/BNVdBoSTLCdACDT58BR3umvYuucV6Cbb36lNsOsJegwtedOJsDvTnB14ZLU41EvDEX+uxr7iJUYiTmn7hunq22K1+T/Nc7+FaTNr6AMH3CCuiZmo/CmXjVXLRPwF034Kg1mVvlsNTpZhm0ORjPpNI8tuMP0bMp6HLhHMKVKvdxdTtdhUN6o5rlifYgP+5/UEhG8vT6QYqCazrUEcfq8aASy702ilb2VNVXNOOjwkHdvh/kHuxDhKeINFun3ZaXKGkycYxGk2ndazOWbNGNCBaw87KOPlqge1oo8KzllCfAwjBX/Rxtj+/dcb6tkkjLBQfJyUqw3rcBjGv00ULG8T9m0AgOrZYJFUZofLDY6ByLie5zG8KMPQGJJt4Hx9P8aqfC8pXVrn4PbmABT1M8ZYRIYLTMIYiEoG8qb06BB8+SZAVx7MtR+6aGak/+9cARMD7b6s9h6rCpDIb+sRHSaThXXnabMX+F5NmNOOiUe90A/1YMVzcyXDqlnNRV1hOvB+yL++K3RP+3khTJLDkJ1YtE3EQ3QjKzLH6RXyTkgigGFo6V8zOWjpFD9Yx3oBe4db/FDEU7SnXPUD17FpIt0UMC5FGhTrzO79ZiPWi0vXb/hbVSOpNBLaZGHvdp1JhY683JLsLowcw0gXa2/GHpv/t2EtPuJyfEAlUZL/q6Sgf1Vmt5Dx5guvRtabS3MUQrGJDZ4uhcC5wFzkUgJBF/uIjMQlu2T0h/9hi0WZ7lgQyOZl5Cbec17s+Lyojr+5gqFXVGEb8Hr2zY4mv8Bm3Su/oBygPWry5GBWc1HKA9tZ2zKv+E5xmbiz8qPck88E42nrTQooX3IXYBJUPPn78QeBrnjAk+YOxJwy3COCnmLXQmPaB0CBsb9rCuf47eenKDh4Q5CbjPbYMJOLWpItB4k00Is5CKf6bfYwTVbfQghWOzPXx/JVbFC66w7yqXsVLA"
`endif