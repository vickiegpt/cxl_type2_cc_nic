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


`timescale 1 ps / 1 ps
 
(* tile_ip_hip *)
(* altera_attribute = "-name UNCONNECTED_OUTPUT_PORT_MESSAGE_LEVEL OFF" *)
module ftile_systempll_ref4_systemclk_f_400_v3lqleq_hip #(
 
// SystemPLL:
   parameter  enables_systempll       = 0,
 
   parameter  systempll_ethernet_preset_0 = "IE",
   parameter  systempll_ethernet_preset_1 = "IE",
   parameter  systempll_ethernet_preset_2 = "IE",
 
   parameter  systempll_pcie_preset_0 = "IE",
   parameter  systempll_pcie_preset_1 = "IE",
   parameter  systempll_pcie_preset_2 = "IE",
 
   parameter  systempll_refsrc_0      = 0,
   parameter  systempll_refsrc_1      = 0,
   parameter  systempll_refsrc_2      = 0,
 
   parameter  syspll_availpor_0      = 1,
   parameter  syspll_availpor_1      = 1,
   parameter  syspll_availpor_2      = 1,
 
   parameter  refclk_fgt_always_active_0 = 0,
   parameter  refclk_fgt_always_active_1 = 0,
   parameter  refclk_fgt_always_active_2 = 0,
   parameter  refclk_fgt_always_active_3 = 0,
   parameter  refclk_fgt_always_active_4 = 0,
   parameter  refclk_fgt_always_active_5 = 0,
   parameter  refclk_fgt_always_active_6 = 0,
   parameter  refclk_fgt_always_active_7 = 0,
   parameter  refclk_fgt_always_active_8 = 0,
   parameter  refclk_fgt_always_active_9 = 0,
 
   parameter  systempll_c0_counter_0         = "IE",
   parameter  systempll_c0_output_enable_0   = "IE",
   parameter  systempll_c1_counter_0         = "IE",
   parameter  systempll_c1_output_enable_0   = "IE",
   parameter  systempll_c2_counter_0         = "IE",
   parameter  systempll_c2_output_enable_0   = "IE",
   parameter  systempll_f_out_c0_hz_0        = "IE",
   parameter  systempll_f_out_c1_hz_0        = "IE",
   parameter  systempll_f_out_c2_hz_0        = "IE",
   parameter  systempll_f_pfd_hz_0           = "IE",
   parameter  systempll_f_ref_hz_0           = "IE",
   parameter  systempll_f_vco_hz_0           = "IE",
   parameter  systempll_fractional_enable_0  = "IE",
   parameter  systempll_m_counter_0          = "IE",
   parameter  systempll_n_counter_0          = "IE",
   parameter  systempll_primary_use_0        = "IE",
   parameter  systempll_refclk_mux_select_0  = "IE",
   parameter  systempll_eth_flux_used_0      = "IE",
 
   parameter  systempll_c0_counter_1         = "IE",
   parameter  systempll_c0_output_enable_1   = "IE",
   parameter  systempll_c1_counter_1         = "IE",
   parameter  systempll_c1_output_enable_1   = "IE",
   parameter  systempll_c2_counter_1         = "IE",
   parameter  systempll_c2_output_enable_1   = "IE",
   parameter  systempll_f_out_c0_hz_1        = "IE",
   parameter  systempll_f_out_c1_hz_1        = "IE",
   parameter  systempll_f_out_c2_hz_1        = "IE",
   parameter  systempll_f_pfd_hz_1           = "IE",
   parameter  systempll_f_ref_hz_1           = "IE",
   parameter  systempll_f_vco_hz_1           = "IE",
   parameter  systempll_fractional_enable_1  = "IE",
   parameter  systempll_m_counter_1          = "IE",
   parameter  systempll_n_counter_1          = "IE",
   parameter  systempll_primary_use_1        = "IE",
   parameter  systempll_refclk_mux_select_1  = "IE",
   parameter  systempll_eth_flux_used_1      = "IE",
 
   parameter  systempll_c0_counter_2         = "IE",
   parameter  systempll_c0_output_enable_2   = "IE",
   parameter  systempll_c1_counter_2         = "IE",
   parameter  systempll_c1_output_enable_2   = "IE",
   parameter  systempll_c2_counter_2         = "IE",
   parameter  systempll_c2_output_enable_2   = "IE",
   parameter  systempll_f_out_c0_hz_2        = "IE",
   parameter  systempll_f_out_c1_hz_2        = "IE",
   parameter  systempll_f_out_c2_hz_2        = "IE",
   parameter  systempll_f_pfd_hz_2           = "IE",
   parameter  systempll_f_ref_hz_2           = "IE",
   parameter  systempll_f_vco_hz_2           = "IE",
   parameter  systempll_fractional_enable_2  = "IE",
   parameter  systempll_m_counter_2          = "IE",
   parameter  systempll_n_counter_2          = "IE",
   parameter  systempll_primary_use_2        = "IE",
   parameter  systempll_refclk_mux_select_2  = "IE",
   parameter  systempll_eth_flux_used_2      = "IE",
 
// FGT Reference Clock:
   parameter  enables_refclk_fgt      = 0,
   parameter  enables_coreclk_fgt     = 0,
 
   parameter  refclk_fgt_freq_0       = 0,
   parameter  refclk_fgt_freq_1       = 0,
   parameter  refclk_fgt_freq_2       = 0,
   parameter  refclk_fgt_freq_3       = 0,
   parameter  refclk_fgt_freq_4       = 0,
   parameter  refclk_fgt_freq_5       = 0,
   parameter  refclk_fgt_freq_6       = 0,
   parameter  refclk_fgt_freq_7       = 0,
   parameter  refclk_fgt_freq_8       = 0,
   parameter  refclk_fgt_freq_9       = 0,
 
// FGT Reference Clock:
   parameter  enables_cdrout_fgt      = 0,
 
 
// FHT Reference Clock:
   parameter  enables_refclk_fht      = 0,
   parameter  fhtref_fref_hz_0        = "IE",
   parameter  fhtref_fref_hz_1        = "IE",
 
// Common PLL:
   parameter  enables_commonpll       = 0,
   parameter  commonpll_refsrc_0      = 0,
   parameter  commonpll_refsrc_1      = 0,
   parameter  cmnpll_en_cmos_refclk_out = "IE",
   parameter  cmnpll_xtensa_used_0    = "IE",
   parameter  cmnpll_xtensa_used_1    = "IE",
 
 
   parameter  silicon_revision        = "10nm6awhra",
   parameter  device_revision         = "10nm6awhra"
 
 
 ) (
   output out_systempll_synthlock_0,
   output out_systempll_synthlock_1,
   output out_systempll_synthlock_2,
 
   output out_systempll_disconnect_0,
   output out_systempll_disconnect_1,
   output out_systempll_disconnect_2,
 
   output [3:0] out_systempll_status_0,
   output [3:0] out_systempll_status_1,
   output [3:0] out_systempll_status_2,
 
   output out_coreclk_0,
   output out_coreclk_1,
   output out_coreclk_2,
   output out_coreclk_3,
   output out_coreclk_4,
   output out_coreclk_5,
   output out_coreclk_6,
   output out_coreclk_7,
   output out_coreclk_8,  // Only 8 physical available.  This is logical
   output out_coreclk_9,
 
    input in_refclk_fgt_0,
    input in_refclk_fgt_1,
    input in_refclk_fgt_2,
    input in_refclk_fgt_3,
    input in_refclk_fgt_4,
    input in_refclk_fgt_5,
    input in_refclk_fgt_6,
    input in_refclk_fgt_7,
    input in_refclk_fgt_8,
    input in_refclk_fgt_9,
 
   output out_refclk_fgt_0,
   output out_refclk_fgt_1,
   output out_refclk_fgt_2,
   output out_refclk_fgt_3,
   output out_refclk_fgt_4,
   output out_refclk_fgt_5,
   output out_refclk_fgt_6,
   output out_refclk_fgt_7,
   output out_refclk_fgt_8,
   output out_refclk_fgt_9,
 
    input in_refclk_fht_0,
    input in_refclk_fht_1,
 
   output out_fht_cmmpll_clk_0,
   output out_fht_cmmpll_clk_1,
 
    input in_cdrclk_0,
    input in_cdrclk_1,
 
   output out_cdrclk_0,
   output out_cdrclk_1,
 
   output out_systempll_clk_0,
   output out_systempll_clk_1,
   output out_systempll_clk_2,
 
   output out_ctrl_pll_aibrc_clock_top__pll_0_slice0_clk_real,
   output out_ctrl_pll_aibrc_clock_top__pll_0_slice1_clk_real,
   output out_ctrl_pll_aibrc_clock_top__pll_0_slice2_clk_real,
   output out_ctrl_pll_aibrc_clock_top__pll_0_slice3_clk_real,
 
   output out_ctrl_pll_aibrc_clock_top__pll_1_slice0_clk_real,
   output out_ctrl_pll_aibrc_clock_top__pll_1_slice1_clk_real,
   output out_ctrl_pll_aibrc_clock_top__pll_1_slice2_clk_real,
   output out_ctrl_pll_aibrc_clock_top__pll_1_slice3_clk_real,
 
   output out_ctrl_pll_aibrc_clock_top__pll_2_slice0_clk_real,
   output out_ctrl_pll_aibrc_clock_top__pll_2_slice1_clk_real,
   output out_ctrl_pll_aibrc_clock_top__pll_2_slice2_clk_real,
   output out_ctrl_pll_aibrc_clock_top__pll_2_slice3_clk_real,
 
 
//  for AVMM1 bb ports refclk_2
   output         pld_avmm1_busy_ref_2,
    input         pld_avmm1_clk_rowclk_ref_2,
   output         pld_avmm1_cmdfifo_wr_full_ref_2,
   output         pld_avmm1_cmdfifo_wr_pfull_ref_2,
    input         pld_avmm1_read_ref_2,
   output [7:0]   pld_avmm1_readdata_ref_2,
   output         pld_avmm1_readdatavalid_ref_2,
    input [9:0]   pld_avmm1_reg_addr_ref_2,
    input         pld_avmm1_request_ref_2,
    input [8:0]   pld_avmm1_reserved_in_ref_2,
   output [2:0]   pld_avmm1_reserved_out_ref_2,
    input         pld_avmm1_write_ref_2,
    input [7:0]   pld_avmm1_writedata_ref_2,
   output         pld_chnl_cal_done_ref_2,
   output         pld_hssi_osc_transfer_en_ref_2,
   
 
//  for AVMM1 bb ports refclk_3
   output         pld_avmm1_busy_ref_3,
    input         pld_avmm1_clk_rowclk_ref_3,
   output         pld_avmm1_cmdfifo_wr_full_ref_3,
   output         pld_avmm1_cmdfifo_wr_pfull_ref_3,
    input         pld_avmm1_read_ref_3,
   output [7:0]   pld_avmm1_readdata_ref_3,
   output         pld_avmm1_readdatavalid_ref_3,
    input [9:0]   pld_avmm1_reg_addr_ref_3,
    input         pld_avmm1_request_ref_3,
    input [8:0]   pld_avmm1_reserved_in_ref_3,
   output [2:0]   pld_avmm1_reserved_out_ref_3,
    input         pld_avmm1_write_ref_3,
    input [7:0]   pld_avmm1_writedata_ref_3,
   output         pld_chnl_cal_done_ref_3,
   output         pld_hssi_osc_transfer_en_ref_3,
   
 
//  for AVMM1 bb ports refclk_4
   output         pld_avmm1_busy_ref_4,
    input         pld_avmm1_clk_rowclk_ref_4,
   output         pld_avmm1_cmdfifo_wr_full_ref_4,
   output         pld_avmm1_cmdfifo_wr_pfull_ref_4,
    input         pld_avmm1_read_ref_4,
   output [7:0]   pld_avmm1_readdata_ref_4,
   output         pld_avmm1_readdatavalid_ref_4,
    input [9:0]   pld_avmm1_reg_addr_ref_4,
    input         pld_avmm1_request_ref_4,
    input [8:0]   pld_avmm1_reserved_in_ref_4,
   output [2:0]   pld_avmm1_reserved_out_ref_4,
    input         pld_avmm1_write_ref_4,
    input [7:0]   pld_avmm1_writedata_ref_4,
   output         pld_chnl_cal_done_ref_4,
   output         pld_hssi_osc_transfer_en_ref_4,
   
 
//  for AVMM1 bb ports refclk_5
   output         pld_avmm1_busy_ref_5,
    input         pld_avmm1_clk_rowclk_ref_5,
   output         pld_avmm1_cmdfifo_wr_full_ref_5,
   output         pld_avmm1_cmdfifo_wr_pfull_ref_5,
    input         pld_avmm1_read_ref_5,
   output [7:0]   pld_avmm1_readdata_ref_5,
   output         pld_avmm1_readdatavalid_ref_5,
    input [9:0]   pld_avmm1_reg_addr_ref_5,
    input         pld_avmm1_request_ref_5,
    input [8:0]   pld_avmm1_reserved_in_ref_5,
   output [2:0]   pld_avmm1_reserved_out_ref_5,
    input         pld_avmm1_write_ref_5,
    input [7:0]   pld_avmm1_writedata_ref_5,
   output         pld_chnl_cal_done_ref_5,
   output         pld_hssi_osc_transfer_en_ref_5,
   
   
   //  for AVMM1 bb ports
    output        pld_avmm1_busy,
     input        pld_avmm1_clk_rowclk,
    output        pld_avmm1_cmdfifo_wr_full,
    output        pld_avmm1_cmdfifo_wr_pfull,
     input        pld_avmm1_read,
    output [7:0]  pld_avmm1_readdata,
    output        pld_avmm1_readdatavalid,
     input [9:0]  pld_avmm1_reg_addr,
     input        pld_avmm1_request,
     input [8:0]  pld_avmm1_reserved_in,
    output [2:0]  pld_avmm1_reserved_out,
     input        pld_avmm1_write,
     input [7:0]  pld_avmm1_writedata,
    output        pld_chnl_cal_done,
    output        pld_hssi_osc_transfer_en
);
 
//=================================================================
//                          FGT CDR Clockouts
//=================================================================
localparam REFCLK_FGT_DP_NUM = 2;
 
wire [REFCLK_FGT_DP_NUM-1:0]  w_cdrclk_out;
wire [REFCLK_FGT_DP_NUM-1:0]  w_cdrclk_in;
 
`ifdef __TILE_IP__
assign {out_cdrclk_1, out_cdrclk_0} = w_cdrclk_out;
`endif  //__TILE_IP__
assign                  w_cdrclk_in = {in_cdrclk_1, in_cdrclk_0};
 
for (genvar i=0;i<REFCLK_FGT_DP_NUM;i++) begin : gen_cdrclk_
  if ( enables_cdrout_fgt[i] ) 
  begin : enabled
`ifdef __TILE_IP__
      bb_f_ux_refclk #(
       //.refclk_hz                    ( l_freq ),
       //.refclk_reconfig_span         ( ),
       .syspll_refclk_output_enable  ("ENABLE"),
       //.location      (),
         .silicon_rev   ( silicon_revision )
      )  inst (
         .io_gdr_refclk_in_ds__b_refclk_in_p_srds_pad_lv_real( w_cdrclk_out[i] ),
         .rx_cdr_divclk_link ( w_cdrclk_in[i] ),
         .refclk_link        ( )
     ); 
`else
     // Driven by XMR -- assign w_cdrclk_out[i] = 1'b0;  
`endif  //__TILE_IP__
  end
  else
  begin
       // Avoid Lint error:
     assign w_cdrclk_out[i] = 1'b0; 
  end
end
 
//=================================================================
//                          FGT RefClk
//=================================================================
localparam REFCLK_FGT_NUM = 10;
 
wire [REFCLK_FGT_NUM-1:0]  w_refclk_fgt_clk_in;
wire [REFCLK_FGT_NUM-1:0]  w_refclk_fgt_clk_out;
wire [REFCLK_FGT_NUM-1:0]  w_coreclk_fgt; // Only 8 physical available.  This is logical
 
 
`ifdef __TILE_IP__
assign {out_coreclk_9, out_coreclk_8, out_coreclk_7, out_coreclk_6, 
        out_coreclk_5, out_coreclk_4, out_coreclk_3, out_coreclk_2, 
                                      out_coreclk_1, out_coreclk_0 } = w_coreclk_fgt;
`endif
 
 
assign {out_refclk_fgt_9, out_refclk_fgt_8, out_refclk_fgt_7, out_refclk_fgt_6, 
        out_refclk_fgt_5, out_refclk_fgt_4, out_refclk_fgt_3, out_refclk_fgt_2, 
                                            out_refclk_fgt_1, out_refclk_fgt_0 } = w_refclk_fgt_clk_out;
 
assign w_refclk_fgt_clk_in = {in_refclk_fgt_9, in_refclk_fgt_8, in_refclk_fgt_7, in_refclk_fgt_6, 
                              in_refclk_fgt_5, in_refclk_fgt_4, in_refclk_fgt_3, in_refclk_fgt_2, 
                              in_refclk_fgt_1, in_refclk_fgt_0 };
 
for (genvar i=0;i<REFCLK_FGT_NUM;i++) begin : gen_refclk_fgt_bb_
  if ( enables_refclk_fgt[i] ) 
  begin : enabled
 
     localparam l_freq = (i==0)? refclk_fgt_freq_0 :(i==1)? refclk_fgt_freq_1 :(i==2)? refclk_fgt_freq_2 :(i==3)? refclk_fgt_freq_3 :
                         (i==4)? refclk_fgt_freq_4 :(i==5)? refclk_fgt_freq_5 :(i==6)? refclk_fgt_freq_6 :(i==7)? refclk_fgt_freq_7 :
                         (i==8)? refclk_fgt_freq_8 :(i==9)? refclk_fgt_freq_9 :"IE";
     localparam l_freq_v = (l_freq==0) ? "__BB_DONT_CARE__" : l_freq;
 
     localparam l_refclk_fgt_always_active =
        0 == i ? ( refclk_fgt_always_active_0 ? "TRUE" : "FALSE" )
        :
        1 == i ? ( refclk_fgt_always_active_1 ? "TRUE" : "FALSE" )
        :
        2 == i ? ( refclk_fgt_always_active_2 ? "TRUE" : "FALSE" )
        :
        3 == i ? ( refclk_fgt_always_active_3 ? "TRUE" : "FALSE" )
        :
        4 == i ? ( refclk_fgt_always_active_4 ? "TRUE" : "FALSE" )
        :
        5 == i ? ( refclk_fgt_always_active_5 ? "TRUE" : "FALSE" )
        :
        6 == i ? ( refclk_fgt_always_active_6 ? "TRUE" : "FALSE" )
        :
        7 == i ? ( refclk_fgt_always_active_7 ? "TRUE" : "FALSE" )
        :
        8 == i ? ( refclk_fgt_always_active_8 ? "TRUE" : "FALSE" )
        :
        9 == i ? ( refclk_fgt_always_active_9 ? "TRUE" : "FALSE" )
        :
        "IE"
        ;
 
     localparam l_passthru_clk_type =
        (enables_coreclk_fgt[i] || l_refclk_fgt_always_active == "FALSE") ? "PASSTHRU_PAD2CMOS" : "PASSTHRU_DISABLE";
 
`ifdef __TILE_IP__
     wire w_bb_f_ux_refclk_coreclk;
 
     bb_f_ux_refclk #(
         .refclk_hz                    ( l_freq_v ),
         .passthru_clk_type            ( l_passthru_clk_type ),
         .refclk_available_at_poweron  ( l_refclk_fgt_always_active ),
         .syspll_refclk_output_enable  ( "ENABLE" ),
         .silicon_rev                  ( silicon_revision )
     )  inst (
        // Real-ports:
         .o_xcvrrc_clkrst_ux_ds_0__xcvr_quad_refclk_real     ( w_bb_f_ux_refclk_coreclk ),
         .io_gdr_refclk_in_ds__b_refclk_in_p_srds_pad_lv_real( w_refclk_fgt_clk_in[i] ),
 
        // Link-ports:
         .rx_cdr_divclk_link ( ),
         .refclk_link        ( w_refclk_fgt_clk_out[i] )
     );
 
     assign w_coreclk_fgt[i] = (enables_coreclk_fgt[i] || l_refclk_fgt_always_active == "FALSE") ? w_bb_f_ux_refclk_coreclk : 1'b0;
`else
     assign w_refclk_fgt_clk_out[i] = 1'b0;
`endif  //__TILE_IP__
 
  end
  else
  begin
       // Avoid Lint error:
     assign w_refclk_fgt_clk_out[i] = 1'b0;
     assign w_coreclk_fgt[i] = 1'b0;
  end
end
 
//=================================================================
//                          FHT RefClk
//=================================================================
localparam REFCLK_FHT_NUM = 2;
 
wire [REFCLK_FHT_NUM-1:0]  w_refclk_fht_clk_in;
wire [REFCLK_FHT_NUM-1:0]  w_refclk_fht_clk_out;
 
 
assign w_refclk_fht_clk_in = { in_refclk_fht_1, in_refclk_fht_0 };
 
for (genvar i=0;i<REFCLK_FHT_NUM;i++) begin : gen_fht_bb_
  if ( enables_refclk_fht[i] ) 
  begin : enabled
 
     localparam l_freq = (i==0) ? fhtref_fref_hz_0  : (i==1) ? fhtref_fref_hz_1  : "IE" ;
 
`ifdef __TILE_IP__
      bb_f_bk_refclk #(
         .freq          ( l_freq ),
         .silicon_rev   ( silicon_revision )
      )  refclk_inst (
         .io_gdr_refclk_in_ds__b_refclk_in_p_srds_pad_lv_real ( w_refclk_fht_clk_in[i] ),
         .refclk_link   ( w_refclk_fht_clk_out[i] )
      );
`else
     assign w_refclk_fht_clk_out[i] = 1'b0;
`endif  //__TILE_IP__
 
  end
  else
  begin
       // Avoid Lint error:  
     assign w_refclk_fht_clk_out[i] = 1'b0;
  end
end
 
 
//=================================================================
//                          Common PLL
//=================================================================
localparam COMMONPLL_NUM = 2;
wire [COMMONPLL_NUM-1:0]  w_cmmpll_clk_out;
 
assign { out_fht_cmmpll_clk_1, out_fht_cmmpll_clk_0 } = w_cmmpll_clk_out;
 
for (genvar i=0;i<COMMONPLL_NUM;i++) begin : gen_commonpll_bb_
  if ( enables_commonpll[i] ) 
  begin : enabled
 
        localparam l_commonpll_refsrc  = (i==0) ? commonpll_refsrc_0   : (i==1) ? commonpll_refsrc_1   : "IE";
        localparam l_xtensa_used       = (i==0) ? cmnpll_xtensa_used_0 : (i==1) ? cmnpll_xtensa_used_1 : "IE";
 
`ifdef __TILE_IP__
      bb_f_bk_cmnpll #(
       //.bk_clk_en_cmos_refclk_out
         .xtensa_clk    ( l_xtensa_used    ),
         .silicon_rev   ( silicon_revision )
      )  cmpll_inst (
         .pll_link      ( w_cmmpll_clk_out[i] ),
         .refclk_link   ( w_refclk_fht_clk_out[l_commonpll_refsrc] )
      );
`else
     assign w_cmmpll_clk_out[i] = 1'b0;
`endif  //__TILE_IP__
  end
  else
  begin
       // Avoid Lint error:  
     assign w_cmmpll_clk_out[i] = 1'b0;
  end
 
end
 
//=================================================================
//                          SystemPLL
//=================================================================
localparam SYSTEMPLL_NUM = 3;
 
wire   [SYSTEMPLL_NUM-1:0]  w_systempll_clk_out;
wire   [SYSTEMPLL_NUM-1:0]  w_systempll_synthlock_out;
//wire [SYSTEMPLL_NUM-1:0]  w_systempll_disconnect_out;
wire [4*SYSTEMPLL_NUM-1:0]  w_systempll_status_out;
 
assign  { out_systempll_clk_2, out_systempll_clk_1, out_systempll_clk_0 } = w_systempll_clk_out;
 
for (genvar i=0;i<SYSTEMPLL_NUM;i++) begin : gen_systempll_bb_
  if ( enables_systempll[i] ) 
  begin : enabled
 
        localparam l_c0_counter          = (i==0) ? systempll_c0_counter_0  : (i==1) ? systempll_c0_counter_1  : (i==2) ? systempll_c0_counter_2  : "IE" ;
        localparam l_c1_counter          = (i==0) ? systempll_c1_counter_0  : (i==1) ? systempll_c1_counter_1  : (i==2) ? systempll_c1_counter_2  : "IE" ;
        localparam l_f_out_c0_hz         = (i==0) ? systempll_f_out_c0_hz_0 : (i==1) ? systempll_f_out_c0_hz_1 : (i==2) ? systempll_f_out_c0_hz_2 : "IE" ;
        localparam l_f_out_c1_hz         = (i==0) ? systempll_f_out_c1_hz_0 : (i==1) ? systempll_f_out_c1_hz_1 : (i==2) ? systempll_f_out_c1_hz_2 : "IE" ;
        localparam l_f_pfd_hz            = (i==0) ? systempll_f_pfd_hz_0    : (i==1) ? systempll_f_pfd_hz_1    : (i==2) ? systempll_f_pfd_hz_2    : "IE" ;
        localparam l_f_ref_hz            = (i==0) ? systempll_f_ref_hz_0    : (i==1) ? systempll_f_ref_hz_1    : (i==2) ? systempll_f_ref_hz_2    : "IE" ;
        localparam l_f_vco_hz            = (i==0) ? systempll_f_vco_hz_0    : (i==1) ? systempll_f_vco_hz_1    : (i==2) ? systempll_f_vco_hz_2    : "IE" ;
        localparam l_m_counter           = (i==0) ? systempll_m_counter_0   : (i==1) ? systempll_m_counter_1   : (i==2) ? systempll_m_counter_2   : "IE" ;
        localparam l_n_counter           = (i==0) ? systempll_n_counter_0   : (i==1) ? systempll_n_counter_1   : (i==2) ? systempll_n_counter_2   : "IE" ;
 
        localparam l_systempll_refsrc    = (i==0) ? systempll_refsrc_0      : (i==1) ? systempll_refsrc_1      : (i==2) ? systempll_refsrc_2      : "IE" ;
 
        localparam l_ethernet_preset     = (i==0) ? systempll_ethernet_preset_0 : (i==1) ? systempll_ethernet_preset_1 : (i==2) ? systempll_ethernet_preset_2 : "IE" ;
        localparam l_pcie_preset         = (i==0) ? systempll_pcie_preset_0     : (i==1) ? systempll_pcie_preset_1     : (i==2) ? systempll_pcie_preset_2     : "IE" ;
        localparam l_primary_use         = (i==0) ? systempll_primary_use_0     : (i==1) ? systempll_primary_use_1     : (i==2) ? systempll_primary_use_2     : "IE" ;
 
        localparam l_c2_output_enable    = (i==0) ? systempll_c2_output_enable_0: (i==1) ? systempll_c2_output_enable_1: (i==2) ? systempll_c2_output_enable_2: "IE" ;
        localparam l_f_out_c2_hz         = (i==0) ? systempll_f_out_c2_hz_0     : (i==1) ? systempll_f_out_c2_hz_1     : (i==2) ? systempll_f_out_c2_hz_2     : "IE" ;
        localparam l_c2_counter          = (i==0) ? systempll_c2_counter_0      : (i==1) ? systempll_c2_counter_1      : (i==2) ? systempll_c2_counter_2      : "IE" ;
 
        localparam l_eth_flux_used       = (i==0) ? systempll_eth_flux_used_0   : (i==1) ? systempll_eth_flux_used_1   : (i==2) ? systempll_eth_flux_used_2   : "IE" ;
 
        localparam l_availpor            = (i==0) ? syspll_availpor_0           : (i==1) ? syspll_availpor_1           : (i==2) ? syspll_availpor_2   : "IE" ;
 
`ifdef __TILE_IP__
     assign  { out_systempll_synthlock_2,  out_systempll_synthlock_1,  out_systempll_synthlock_0     } = w_systempll_synthlock_out;
   //assign  { out_systempll_disconnect_2, out_systempll_disconnect_1, out_systempll_disconnect_0    } = w_systempll_disconnect_out;
   //assign  { out_systempll_status_2,     out_systempll_status_1,     out_systempll_status_0        } = w_systempll_status_out;
 
     wire out_ctrl_pll_aibrc_clock_top__pll_slice0_clk_real;
     wire out_ctrl_pll_aibrc_clock_top__pll_slice1_clk_real;
     wire out_ctrl_pll_aibrc_clock_top__pll_slice2_clk_real;
     wire out_ctrl_pll_aibrc_clock_top__pll_slice3_clk_real;
 
     if (i==0) begin
       assign out_ctrl_pll_aibrc_clock_top__pll_0_slice0_clk_real = out_ctrl_pll_aibrc_clock_top__pll_slice0_clk_real;
       assign out_ctrl_pll_aibrc_clock_top__pll_0_slice1_clk_real = out_ctrl_pll_aibrc_clock_top__pll_slice1_clk_real;
       assign out_ctrl_pll_aibrc_clock_top__pll_0_slice2_clk_real = out_ctrl_pll_aibrc_clock_top__pll_slice2_clk_real;
       assign out_ctrl_pll_aibrc_clock_top__pll_0_slice3_clk_real = out_ctrl_pll_aibrc_clock_top__pll_slice3_clk_real;
     end
     if (i==1) begin
       assign out_ctrl_pll_aibrc_clock_top__pll_1_slice0_clk_real = out_ctrl_pll_aibrc_clock_top__pll_slice0_clk_real;
       assign out_ctrl_pll_aibrc_clock_top__pll_1_slice1_clk_real = out_ctrl_pll_aibrc_clock_top__pll_slice1_clk_real;
       assign out_ctrl_pll_aibrc_clock_top__pll_1_slice2_clk_real = out_ctrl_pll_aibrc_clock_top__pll_slice2_clk_real;
       assign out_ctrl_pll_aibrc_clock_top__pll_1_slice3_clk_real = out_ctrl_pll_aibrc_clock_top__pll_slice3_clk_real;
     end
     if (i==2) begin
       assign out_ctrl_pll_aibrc_clock_top__pll_2_slice0_clk_real = out_ctrl_pll_aibrc_clock_top__pll_slice0_clk_real;
       assign out_ctrl_pll_aibrc_clock_top__pll_2_slice1_clk_real = out_ctrl_pll_aibrc_clock_top__pll_slice1_clk_real;
       assign out_ctrl_pll_aibrc_clock_top__pll_2_slice2_clk_real = out_ctrl_pll_aibrc_clock_top__pll_slice2_clk_real;
       assign out_ctrl_pll_aibrc_clock_top__pll_2_slice3_clk_real = out_ctrl_pll_aibrc_clock_top__pll_slice3_clk_real;
     end
 
     bb_f_system_pll #(
      .silicon_rev      ( silicon_revision ),
 
      .refclk_available_at_poweron( (l_availpor)?"TRUE":"FALSE"),
      .primary_use ("__BB_DONT_CARE__"), //now instantiated for JESD protocol
 
   // Configure C0:
      .f_vco_hz         ( l_f_vco_hz ),
      .f_ref_hz         ( l_f_ref_hz ),
      .f_pfd_hz         ( l_f_pfd_hz ),
      .f_out_c0_hz      ( l_f_out_c0_hz ),
      .c0_counter   ( l_c0_counter ),
      .m_counter    ( l_m_counter ),
      .n_counter    ( l_n_counter ),
      .c0_output_enable ( "C0_OUTPUT_ENABLE" ),
 
   // Configure C1:
      .c1_output_enable ( "C1_OUTPUT_ENABLE"),
      .f_out_c1_hz      ( l_f_out_c1_hz ),
      .c1_counter       ( l_c1_counter ),
 
   // Disable C2
    .c2_output_enable   (  l_c2_output_enable ),
    .f_out_c2_hz        ( (l_c2_output_enable=="__BB_DONT_CARE__") ? "__BB_DONT_CARE__" : l_f_out_c2_hz ),
    .c2_counter         ( (l_c2_output_enable=="__BB_DONT_CARE__") ? "__BB_DONT_CARE__" : l_c2_counter  ),
 
   // Preset settings
      .ethernet_preset  ( l_ethernet_preset ),
      .pcie_preset      ( l_pcie_preset ),
 
      .eth_flux_used    ( l_eth_flux_used ),
 
   // Not currently supported
    /*
      .dts_ctrl_f_en_attr()          -- Thermo sensor
      .primary_dfd_power_off_attr()  -- Design for debug
      .topology         ()           -- Set by z-level, not at IP level
      .primary_use  ()           -- Let RBC resolve 
    */   
 
   // Common settings
      .fractional_enable( "FRACTIONAL_DISABLED" ),
      .sup_mode         ( "ADVANCED_USER_MODE" )
     ) inst (
         .disconnect_status_real (/* w_systempll_disconnect_out[i] */           ),
         .slice_status_real      (/* w_systempll_status_out[4*i+:4]*/           ),
         .synthlock_status_real  (   w_systempll_synthlock_out[i]               ),
         .pll_link               (   w_systempll_clk_out[i]                     ),
         .refclk_link            (   w_refclk_fgt_clk_out[ l_systempll_refsrc ] ),
         .o_ctrl_pll_aibrc_clock_top__pll_slice0_clk_real(out_ctrl_pll_aibrc_clock_top__pll_slice0_clk_real),
         .o_ctrl_pll_aibrc_clock_top__pll_slice1_clk_real(out_ctrl_pll_aibrc_clock_top__pll_slice1_clk_real),
         .o_ctrl_pll_aibrc_clock_top__pll_slice2_clk_real(out_ctrl_pll_aibrc_clock_top__pll_slice2_clk_real),
         .o_ctrl_pll_aibrc_clock_top__pll_slice3_clk_real(out_ctrl_pll_aibrc_clock_top__pll_slice3_clk_real)
     );
`else
//     assign w_systempll_status_out[4*i+:4] = 4'b0;
//     assign w_systempll_synthlock_out[i]   = 1'b0;
       assign w_systempll_clk_out[i]         = 1'b0;
 
`endif  // __TILE_IP__
  end
  else
  begin
       // Avoid Lint error:  
     assign w_systempll_status_out[4*i+:4] = 4'b0;
     assign w_systempll_synthlock_out[i]   = 1'b0;
     assign w_systempll_clk_out[i]         = 1'b0;
  end
end
 
`ifdef __TILE_IP__
 bb_m_hdpldadapt_avmm1 #(
                          .location ("MAIB0"), 
                          .silicon_rev  (silicon_revision),
                          .auto_profile_id ("__${ip_inst_d}__") 
                   )
                   x_bb_f_avmm1 (
                   .pld_avmm1_busy_real              ( pld_avmm1_busy ), 
                   .pld_avmm1_clk_rowclk_real        ( pld_avmm1_clk_rowclk ),
                   .pld_avmm1_cmdfifo_wr_full_real   ( pld_avmm1_cmdfifo_wr_full ),
                   .pld_avmm1_cmdfifo_wr_pfull_real  ( pld_avmm1_cmdfifo_wr_pfull ),
                   .pld_avmm1_read_real              ( pld_avmm1_read ),
                   .pld_avmm1_readdata_real          ( pld_avmm1_readdata ),
                   .pld_avmm1_readdatavalid_real     ( pld_avmm1_readdatavalid ),
                   .pld_avmm1_reg_addr_real          ( pld_avmm1_reg_addr ),
                   .pld_avmm1_request_real           ( pld_avmm1_request ),
                   .pld_avmm1_reserved_in_real       ( pld_avmm1_reserved_in ),
                   .pld_avmm1_reserved_out_real      ( pld_avmm1_reserved_out ),
                   .pld_avmm1_write_real             ( pld_avmm1_write),
                   .pld_avmm1_writedata_real         ( pld_avmm1_writedata ),
                   .pld_chnl_cal_done_real           ( pld_chnl_cal_done),
                   .pld_hssi_osc_transfer_en_real    ( pld_hssi_osc_transfer_en ),
                   .avmm1_link                       ( )
              );
`endif  // __TILE_IP__
`ifdef __TILE_IP__
 
        bb_m_hdpldadapt_avmm1 #(
                          .silicon_rev  (silicon_revision),
                          .auto_profile_id ("__${ip_inst_d}__")
                   )
                   x_bb_f_avmm1_ref_2 (
                   .pld_avmm1_busy_real              ( pld_avmm1_busy_ref_2 ), 
                   .pld_avmm1_clk_rowclk_real        ( pld_avmm1_clk_rowclk_ref_2 ),
                   .pld_avmm1_cmdfifo_wr_full_real   ( pld_avmm1_cmdfifo_wr_full_ref_2 ),
                   .pld_avmm1_cmdfifo_wr_pfull_real  ( pld_avmm1_cmdfifo_wr_pfull_ref_2 ),
                   .pld_avmm1_read_real              ( pld_avmm1_read_ref_2 ),
                   .pld_avmm1_readdata_real          ( pld_avmm1_readdata_ref_2 ),
                   .pld_avmm1_readdatavalid_real     ( pld_avmm1_readdatavalid_ref_2 ),
                   .pld_avmm1_reg_addr_real          ( pld_avmm1_reg_addr_ref_2 ),
                   .pld_avmm1_request_real           ( pld_avmm1_request_ref_2 ),
                   .pld_avmm1_reserved_in_real       ( pld_avmm1_reserved_in_ref_2 ),
                   .pld_avmm1_reserved_out_real      ( pld_avmm1_reserved_out_ref_2 ),
                   .pld_avmm1_write_real             ( pld_avmm1_write_ref_2),
                   .pld_avmm1_writedata_real         ( pld_avmm1_writedata_ref_2 ),
                   .pld_chnl_cal_done_real           ( pld_chnl_cal_done_ref_2),
                   .pld_hssi_osc_transfer_en_real    ( pld_hssi_osc_transfer_en_ref_2 ),
                   .avmm1_link                       ( )
              );  
 
        bb_m_hdpldadapt_avmm1 #(
                          .silicon_rev  (silicon_revision),
                          .auto_profile_id ("__${ip_inst_d}__")
                   )
                   x_bb_f_avmm1_ref_3 (
                   .pld_avmm1_busy_real              ( pld_avmm1_busy_ref_3 ), 
                   .pld_avmm1_clk_rowclk_real        ( pld_avmm1_clk_rowclk_ref_3 ),
                   .pld_avmm1_cmdfifo_wr_full_real   ( pld_avmm1_cmdfifo_wr_full_ref_3 ),
                   .pld_avmm1_cmdfifo_wr_pfull_real  ( pld_avmm1_cmdfifo_wr_pfull_ref_3 ),
                   .pld_avmm1_read_real              ( pld_avmm1_read_ref_3 ),
                   .pld_avmm1_readdata_real          ( pld_avmm1_readdata_ref_3 ),
                   .pld_avmm1_readdatavalid_real     ( pld_avmm1_readdatavalid_ref_3 ),
                   .pld_avmm1_reg_addr_real          ( pld_avmm1_reg_addr_ref_3 ),
                   .pld_avmm1_request_real           ( pld_avmm1_request_ref_3 ),
                   .pld_avmm1_reserved_in_real       ( pld_avmm1_reserved_in_ref_3 ),
                   .pld_avmm1_reserved_out_real      ( pld_avmm1_reserved_out_ref_3 ),
                   .pld_avmm1_write_real             ( pld_avmm1_write_ref_3),
                   .pld_avmm1_writedata_real         ( pld_avmm1_writedata_ref_3 ),
                   .pld_chnl_cal_done_real           ( pld_chnl_cal_done_ref_3),
                   .pld_hssi_osc_transfer_en_real    ( pld_hssi_osc_transfer_en_ref_3 ),
                   .avmm1_link                       ( )
              );  
 
        bb_m_hdpldadapt_avmm1 #(
                          .silicon_rev  (silicon_revision),
                          .auto_profile_id ("__${ip_inst_d}__")
                   )
                   x_bb_f_avmm1_ref_4 (
                   .pld_avmm1_busy_real              ( pld_avmm1_busy_ref_4 ), 
                   .pld_avmm1_clk_rowclk_real        ( pld_avmm1_clk_rowclk_ref_4 ),
                   .pld_avmm1_cmdfifo_wr_full_real   ( pld_avmm1_cmdfifo_wr_full_ref_4 ),
                   .pld_avmm1_cmdfifo_wr_pfull_real  ( pld_avmm1_cmdfifo_wr_pfull_ref_4 ),
                   .pld_avmm1_read_real              ( pld_avmm1_read_ref_4 ),
                   .pld_avmm1_readdata_real          ( pld_avmm1_readdata_ref_4 ),
                   .pld_avmm1_readdatavalid_real     ( pld_avmm1_readdatavalid_ref_4 ),
                   .pld_avmm1_reg_addr_real          ( pld_avmm1_reg_addr_ref_4 ),
                   .pld_avmm1_request_real           ( pld_avmm1_request_ref_4 ),
                   .pld_avmm1_reserved_in_real       ( pld_avmm1_reserved_in_ref_4 ),
                   .pld_avmm1_reserved_out_real      ( pld_avmm1_reserved_out_ref_4 ),
                   .pld_avmm1_write_real             ( pld_avmm1_write_ref_4),
                   .pld_avmm1_writedata_real         ( pld_avmm1_writedata_ref_4 ),
                   .pld_chnl_cal_done_real           ( pld_chnl_cal_done_ref_4),
                   .pld_hssi_osc_transfer_en_real    ( pld_hssi_osc_transfer_en_ref_4 ),
                   .avmm1_link                       ( )
              );  
 
        bb_m_hdpldadapt_avmm1 #(
                          .silicon_rev  (silicon_revision),
                          .auto_profile_id ("__${ip_inst_d}__")
                   )
                   x_bb_f_avmm1_ref_5 (
                   .pld_avmm1_busy_real              ( pld_avmm1_busy_ref_5 ), 
                   .pld_avmm1_clk_rowclk_real        ( pld_avmm1_clk_rowclk_ref_5 ),
                   .pld_avmm1_cmdfifo_wr_full_real   ( pld_avmm1_cmdfifo_wr_full_ref_5 ),
                   .pld_avmm1_cmdfifo_wr_pfull_real  ( pld_avmm1_cmdfifo_wr_pfull_ref_5 ),
                   .pld_avmm1_read_real              ( pld_avmm1_read_ref_5 ),
                   .pld_avmm1_readdata_real          ( pld_avmm1_readdata_ref_5 ),
                   .pld_avmm1_readdatavalid_real     ( pld_avmm1_readdatavalid_ref_5 ),
                   .pld_avmm1_reg_addr_real          ( pld_avmm1_reg_addr_ref_5 ),
                   .pld_avmm1_request_real           ( pld_avmm1_request_ref_5 ),
                   .pld_avmm1_reserved_in_real       ( pld_avmm1_reserved_in_ref_5 ),
                   .pld_avmm1_reserved_out_real      ( pld_avmm1_reserved_out_ref_5 ),
                   .pld_avmm1_write_real             ( pld_avmm1_write_ref_5),
                   .pld_avmm1_writedata_real         ( pld_avmm1_writedata_ref_5 ),
                   .pld_chnl_cal_done_real           ( pld_chnl_cal_done_ref_5),
                   .pld_hssi_osc_transfer_en_real    ( pld_hssi_osc_transfer_en_ref_5 ),
                   .avmm1_link                       ( )
              );  
 
`endif  // __TILE_IP__
 
endmodule
 
(* tile_ip *)
module ftile_systempll_ref4_systemclk_f_400_v3lqleq #(
 
// SystemPLL:
   parameter  enables_systempll       = 0,
 
   parameter  systempll_ethernet_preset_0 = "IE",
   parameter  systempll_ethernet_preset_1 = "IE",
   parameter  systempll_ethernet_preset_2 = "IE",
 
   parameter  systempll_pcie_preset_0 = "IE",
   parameter  systempll_pcie_preset_1 = "IE",
   parameter  systempll_pcie_preset_2 = "IE",
 
   parameter  systempll_refsrc_0      = 0,
   parameter  systempll_refsrc_1      = 0,
   parameter  systempll_refsrc_2      = 0,
 
   parameter  syspll_availpor_0       = 1,
   parameter  syspll_availpor_1       = 1,
   parameter  syspll_availpor_2       = 1,
 
   parameter  systempll_c0_counter_0         = "IE",
   parameter  systempll_c0_output_enable_0   = "IE",
   parameter  systempll_c1_counter_0         = "IE",
   parameter  systempll_c1_output_enable_0   = "IE",
   parameter  systempll_c2_counter_0         = "IE",
   parameter  systempll_c2_output_enable_0   = "IE",
   parameter  systempll_f_out_c0_hz_0        = "IE",
   parameter  systempll_f_out_c1_hz_0        = "IE",
   parameter  systempll_f_out_c2_hz_0        = "IE",
   parameter  systempll_f_pfd_hz_0           = "IE",
   parameter  systempll_f_ref_hz_0           = "IE",
   parameter  systempll_f_vco_hz_0           = "IE",
   parameter  systempll_fractional_enable_0  = "IE",
   parameter  systempll_m_counter_0          = "IE",
   parameter  systempll_n_counter_0          = "IE",
   parameter  systempll_primary_use_0        = "IE",
   parameter  systempll_refclk_mux_select_0  = "IE",
   parameter  systempll_eth_flux_used_0      = "IE",
 
   parameter  systempll_c0_counter_1         = "IE",
   parameter  systempll_c0_output_enable_1   = "IE",
   parameter  systempll_c1_counter_1         = "IE",
   parameter  systempll_c1_output_enable_1   = "IE",
   parameter  systempll_c2_counter_1         = "IE",
   parameter  systempll_c2_output_enable_1   = "IE",
   parameter  systempll_f_out_c0_hz_1        = "IE",
   parameter  systempll_f_out_c1_hz_1        = "IE",
   parameter  systempll_f_out_c2_hz_1        = "IE",
   parameter  systempll_f_pfd_hz_1           = "IE",
   parameter  systempll_f_ref_hz_1           = "IE",
   parameter  systempll_f_vco_hz_1           = "IE",
   parameter  systempll_fractional_enable_1  = "IE",
   parameter  systempll_m_counter_1          = "IE",
   parameter  systempll_n_counter_1          = "IE",
   parameter  systempll_primary_use_1        = "IE",
   parameter  systempll_refclk_mux_select_1  = "IE",
   parameter  systempll_eth_flux_used_1      = "IE",
 
   parameter  systempll_c0_counter_2         = "IE",
   parameter  systempll_c0_output_enable_2   = "IE",
   parameter  systempll_c1_counter_2         = "IE",
   parameter  systempll_c1_output_enable_2   = "IE",
   parameter  systempll_c2_counter_2         = "IE",
   parameter  systempll_c2_output_enable_2   = "IE",
   parameter  systempll_f_out_c0_hz_2        = "IE",
   parameter  systempll_f_out_c1_hz_2        = "IE",
   parameter  systempll_f_out_c2_hz_2        = "IE",
   parameter  systempll_f_pfd_hz_2           = "IE",
   parameter  systempll_f_ref_hz_2           = "IE",
   parameter  systempll_f_vco_hz_2           = "IE",
   parameter  systempll_fractional_enable_2  = "IE",
   parameter  systempll_m_counter_2          = "IE",
   parameter  systempll_n_counter_2          = "IE",
   parameter  systempll_primary_use_2        = "IE",
   parameter  systempll_refclk_mux_select_2  = "IE",
   parameter  systempll_eth_flux_used_2      = "IE",
 
// FGT Reference Clock:
   parameter  enables_refclk_fgt             = 0,
   parameter  enables_coreclk_fgt            = 0,
   
   parameter  refclk_fgt_always_active_0 = 0,
   parameter  refclk_fgt_always_active_1 = 0,
   parameter  refclk_fgt_always_active_2 = 0,
   parameter  refclk_fgt_always_active_3 = 0,
   parameter  refclk_fgt_always_active_4 = 0,
   parameter  refclk_fgt_always_active_5 = 0,
   parameter  refclk_fgt_always_active_6 = 0,
   parameter  refclk_fgt_always_active_7 = 0,
   parameter  refclk_fgt_always_active_8 = 0,
   parameter  refclk_fgt_always_active_9 = 0,
 
   parameter  refclk_fgt_freq_0              = 0,
   parameter  refclk_fgt_freq_1              = 0,
   parameter  refclk_fgt_freq_2              = 0,
   parameter  refclk_fgt_freq_3              = 0,
   parameter  refclk_fgt_freq_4              = 0,
   parameter  refclk_fgt_freq_5              = 0,
   parameter  refclk_fgt_freq_6              = 0,
   parameter  refclk_fgt_freq_7              = 0,
   parameter  refclk_fgt_freq_8              = 0,
   parameter  refclk_fgt_freq_9              = 0,
 
// FGT Reference Clock:
   parameter  enables_cdrout_fgt      = 0,
 
 
// FHT Reference Clock:
   parameter  enables_refclk_fht      = 0,
   parameter  fhtref_fref_hz_0        = "IE",
   parameter  fhtref_fref_hz_1        = "IE",
 
// Common PLL:
   parameter  enables_commonpll       = 0,
   parameter  commonpll_refsrc_0      = 0,
   parameter  commonpll_refsrc_1      = 0,
   parameter  cmnpll_en_cmos_refclk_out = "IE",
   parameter  cmnpll_xtensa_used_0    = "IE",
   parameter  cmnpll_xtensa_used_1    = "IE",
 
 
   parameter  silicon_revision        = "10nm6awhra",
   parameter  device_revision         = "10nm6awhra",
   
      
//AVMM parameters
    parameter  avmm_data_width  = 32, 
    parameter  avmm_addr_width  = 18,
    parameter  read_pipeline_enable = 1,
    parameter  avmm_jtag_enable     = 0,
    parameter  refclkready_enable   = 0
 
 ) (
                              output    out_systempll_synthlock_0,
                              output    out_systempll_synthlock_1,
                              output    out_systempll_synthlock_2,
 
                              output    out_systempll_disconnect_0,
                              output    out_systempll_disconnect_1,
                              output    out_systempll_disconnect_2,
 
                              output [3:0] out_systempll_status_0,
                              output [3:0] out_systempll_status_1,
                              output [3:0] out_systempll_status_2,
                              output tri0 all_qhip_in_rst,
                              output tri0 src_rst_done,
                              input  tri1 rst_src_n,
                              input  tri0 ftile_reconfig_active,
 
                              output    out_coreclk_0,
                              output    out_coreclk_1,
                              output    out_coreclk_2,
                              output    out_coreclk_3,
                              output    out_coreclk_4,
                              output    out_coreclk_5,
                              output    out_coreclk_6,
                              output    out_coreclk_7,
                              output    out_coreclk_8,  // Only 8 physical available.  This is logical
                              output    out_coreclk_9,
                              
                              output    refclk_fgt_enabled_0,
                              output    refclk_fgt_enabled_1,
                              output    refclk_fgt_enabled_2,
                              output    refclk_fgt_enabled_3,
                              output    refclk_fgt_enabled_4,
                              output    refclk_fgt_enabled_5,
                              output    refclk_fgt_enabled_6,
                              output    refclk_fgt_enabled_7,
                              output    refclk_fgt_enabled_8,
                              output    refclk_fgt_enabled_9,
                              
                               input    en_refclk_fgt_0,
                               input    en_refclk_fgt_1,
                               input    en_refclk_fgt_2,
                               input    en_refclk_fgt_3,
                               input    en_refclk_fgt_4,
                               input    en_refclk_fgt_5,
                               input    en_refclk_fgt_6,
                               input    en_refclk_fgt_7,
                               input    en_refclk_fgt_8,
                               input    en_refclk_fgt_9,
                               
                               input tri0 disable_refclk_monitor_0,
                               input tri0 disable_refclk_monitor_1,
                               input tri0 disable_refclk_monitor_2,
                               input tri0 disable_refclk_monitor_3,
                               input tri0 disable_refclk_monitor_4,
                               input tri0 disable_refclk_monitor_5,
                               input tri0 disable_refclk_monitor_6,
                               input tri0 disable_refclk_monitor_7,
                               input tri0 disable_refclk_monitor_8,
                               input tri0 disable_refclk_monitor_9,
                               
                               input tri0 enable_syspll_watchdog_timer,                            
                               input tri0 enable_refclk_watchdog_timer_0,
                               input tri0 enable_refclk_watchdog_timer_1,
                               input tri0 enable_refclk_watchdog_timer_2,
                               input tri0 enable_refclk_watchdog_timer_3,
                               input tri0 enable_refclk_watchdog_timer_4,
                               input tri0 enable_refclk_watchdog_timer_5,
                               input tri0 enable_refclk_watchdog_timer_6,
                               input tri0 enable_refclk_watchdog_timer_7,
                               input tri0 enable_refclk_watchdog_timer_8,
                               input tri0 enable_refclk_watchdog_timer_9,
                               
                               output tri0 syspll_watchdog_timeout,
                               output tri0 refclk_watchdog_timeout_0,
                               output tri0 refclk_watchdog_timeout_1,
                               output tri0 refclk_watchdog_timeout_2,
                               output tri0 refclk_watchdog_timeout_3,
                               output tri0 refclk_watchdog_timeout_4,
                               output tri0 refclk_watchdog_timeout_5,
                               output tri0 refclk_watchdog_timeout_6,
                               output tri0 refclk_watchdog_timeout_7,
                               output tri0 refclk_watchdog_timeout_8,
                               output tri0 refclk_watchdog_timeout_9,

    (* tile_ip_find_net *)     input    in_refclk_fgt_0,
    (* tile_ip_find_net *)     input    in_refclk_fgt_1,
    (* tile_ip_find_net *)     input    in_refclk_fgt_2,
    (* tile_ip_find_net *)     input    in_refclk_fgt_3,
    (* tile_ip_find_net *)     input    in_refclk_fgt_4,
    (* tile_ip_find_net *)     input    in_refclk_fgt_5,
    (* tile_ip_find_net *)     input    in_refclk_fgt_6,
    (* tile_ip_find_net *)     input    in_refclk_fgt_7,
    (* tile_ip_find_net *)     input    in_refclk_fgt_8,
    (* tile_ip_find_net *)     input    in_refclk_fgt_9,
 
    (* tile_ip_find_net *)    output    out_refclk_fgt_0,
    (* tile_ip_find_net *)    output    out_refclk_fgt_1,
    (* tile_ip_find_net *)    output    out_refclk_fgt_2,
    (* tile_ip_find_net *)    output    out_refclk_fgt_3,
    (* tile_ip_find_net *)    output    out_refclk_fgt_4,
    (* tile_ip_find_net *)    output    out_refclk_fgt_5,
    (* tile_ip_find_net *)    output    out_refclk_fgt_6,
    (* tile_ip_find_net *)    output    out_refclk_fgt_7,
    (* tile_ip_find_net *)    output    out_refclk_fgt_8,
    (* tile_ip_find_net *)    output    out_refclk_fgt_9,
 
    (* tile_ip_find_net *)     input    in_refclk_fht_0,
    (* tile_ip_find_net *)     input    in_refclk_fht_1,
 
    (* tile_ip_find_net *)    output    out_fht_cmmpll_clk_0,
    (* tile_ip_find_net *)    output    out_fht_cmmpll_clk_1,
 
    (* tile_ip_find_net *)     input    in_cdrclk_0,
    (* tile_ip_find_net *)     input    in_cdrclk_1,
 
    (* tile_ip_find_net *)    output    out_cdrclk_0,
    (* tile_ip_find_net *)    output    out_cdrclk_1,
 
    (* tile_ip_find_net *)    output    out_systempll_clk_0,
    (* tile_ip_find_net *)    output    out_systempll_clk_1,
    (* tile_ip_find_net *)    output    out_systempll_clk_2,
 
    //AVMM ports
                               input    tri0 avmm_clk,
                               input    tri0 avmm_reset,
                               input[2:0] refclock_ready,
                              output    refclock_status
 );
    // Some derived clocks to core
    wire w_ctrl_pll_aibrc_clock_top__pll_slice0_clk_real;
    wire w_ctrl_pll_aibrc_clock_top__pll_slice1_clk_real;
    wire w_ctrl_pll_aibrc_clock_top__pll_slice2_clk_real;
    wire w_ctrl_pll_aibrc_clock_top__pll_slice3_clk_real;
    
  //  for AVMM1 bb ports
  wire        pld_avmm1_busy;
  wire        pld_avmm1_clk_rowclk;
  wire        pld_avmm1_cmdfifo_wr_full;
  wire        pld_avmm1_cmdfifo_wr_pfull;
  wire        pld_avmm1_read;
  wire  [7:0] pld_avmm1_readdata;
  wire        pld_avmm1_readdatavalid;
  wire  [9:0] pld_avmm1_reg_addr;
  wire        pld_avmm1_request;
  wire  [8:0] pld_avmm1_reserved_in;
  wire  [2:0] pld_avmm1_reserved_out;
  wire        pld_avmm1_write;
  wire  [7:0] pld_avmm1_writedata;
  wire        pld_chnl_cal_done;
  wire        pld_hssi_osc_transfer_en;
  
 
//  for AVMM1 bb ports ref_2  
  wire        pld_avmm1_busy_ref_2;
  wire        pld_avmm1_clk_rowclk_ref_2;
  wire        pld_avmm1_cmdfifo_wr_full_ref_2;
  wire        pld_avmm1_cmdfifo_wr_pfull_ref_2;
  wire        pld_avmm1_read_ref_2;
  wire  [7:0] pld_avmm1_readdata_ref_2;
  wire        pld_avmm1_readdatavalid_ref_2;
  wire  [9:0] pld_avmm1_reg_addr_ref_2;
  wire        pld_avmm1_request_ref_2;
  wire  [8:0] pld_avmm1_reserved_in_ref_2;
  wire  [2:0] pld_avmm1_reserved_out_ref_2;
  wire        pld_avmm1_write_ref_2;
  wire  [7:0] pld_avmm1_writedata_ref_2;
  wire        pld_chnl_cal_done_ref_2;
  wire        pld_hssi_osc_transfer_en_ref_2;
 
//  for AVMM1 bb ports ref_3  
  wire        pld_avmm1_busy_ref_3;
  wire        pld_avmm1_clk_rowclk_ref_3;
  wire        pld_avmm1_cmdfifo_wr_full_ref_3;
  wire        pld_avmm1_cmdfifo_wr_pfull_ref_3;
  wire        pld_avmm1_read_ref_3;
  wire  [7:0] pld_avmm1_readdata_ref_3;
  wire        pld_avmm1_readdatavalid_ref_3;
  wire  [9:0] pld_avmm1_reg_addr_ref_3;
  wire        pld_avmm1_request_ref_3;
  wire  [8:0] pld_avmm1_reserved_in_ref_3;
  wire  [2:0] pld_avmm1_reserved_out_ref_3;
  wire        pld_avmm1_write_ref_3;
  wire  [7:0] pld_avmm1_writedata_ref_3;
  wire        pld_chnl_cal_done_ref_3;
  wire        pld_hssi_osc_transfer_en_ref_3;
 
//  for AVMM1 bb ports ref_4  
  wire        pld_avmm1_busy_ref_4;
  wire        pld_avmm1_clk_rowclk_ref_4;
  wire        pld_avmm1_cmdfifo_wr_full_ref_4;
  wire        pld_avmm1_cmdfifo_wr_pfull_ref_4;
  wire        pld_avmm1_read_ref_4;
  wire  [7:0] pld_avmm1_readdata_ref_4;
  wire        pld_avmm1_readdatavalid_ref_4;
  wire  [9:0] pld_avmm1_reg_addr_ref_4;
  wire        pld_avmm1_request_ref_4;
  wire  [8:0] pld_avmm1_reserved_in_ref_4;
  wire  [2:0] pld_avmm1_reserved_out_ref_4;
  wire        pld_avmm1_write_ref_4;
  wire  [7:0] pld_avmm1_writedata_ref_4;
  wire        pld_chnl_cal_done_ref_4;
  wire        pld_hssi_osc_transfer_en_ref_4;
 
//  for AVMM1 bb ports ref_5  
  wire        pld_avmm1_busy_ref_5;
  wire        pld_avmm1_clk_rowclk_ref_5;
  wire        pld_avmm1_cmdfifo_wr_full_ref_5;
  wire        pld_avmm1_cmdfifo_wr_pfull_ref_5;
  wire        pld_avmm1_read_ref_5;
  wire  [7:0] pld_avmm1_readdata_ref_5;
  wire        pld_avmm1_readdatavalid_ref_5;
  wire  [9:0] pld_avmm1_reg_addr_ref_5;
  wire        pld_avmm1_request_ref_5;
  wire  [8:0] pld_avmm1_reserved_in_ref_5;
  wire  [2:0] pld_avmm1_reserved_out_ref_5;
  wire        pld_avmm1_write_ref_5;
  wire  [7:0] pld_avmm1_writedata_ref_5;
  wire        pld_chnl_cal_done_ref_5;
  wire        pld_hssi_osc_transfer_en_ref_5;
 
 
ftile_systempll_ref4_systemclk_f_400_v3lqleq_hip
    #(
        .enables_systempll(enables_systempll),
        .systempll_ethernet_preset_0(systempll_ethernet_preset_0),
        .systempll_ethernet_preset_1(systempll_ethernet_preset_1),
        .systempll_ethernet_preset_2(systempll_ethernet_preset_2),
        .systempll_pcie_preset_0(systempll_pcie_preset_0),
        .systempll_pcie_preset_1(systempll_pcie_preset_1),
        .systempll_pcie_preset_2(systempll_pcie_preset_2),
        .systempll_refsrc_0(systempll_refsrc_0),
        .systempll_refsrc_1(systempll_refsrc_1),
        .systempll_refsrc_2(systempll_refsrc_2),
        .syspll_availpor_0(syspll_availpor_0),
        .syspll_availpor_1(syspll_availpor_1),
        .syspll_availpor_2(syspll_availpor_2),
        .refclk_fgt_always_active_0(refclk_fgt_always_active_0),
        .refclk_fgt_always_active_1(refclk_fgt_always_active_1),
        .refclk_fgt_always_active_2(refclk_fgt_always_active_2),
        .refclk_fgt_always_active_3(refclk_fgt_always_active_3),
        .refclk_fgt_always_active_4(refclk_fgt_always_active_4),
        .refclk_fgt_always_active_5(refclk_fgt_always_active_5),
        .refclk_fgt_always_active_6(refclk_fgt_always_active_6),
        .refclk_fgt_always_active_7(refclk_fgt_always_active_7),
        .refclk_fgt_always_active_8(refclk_fgt_always_active_8),
        .refclk_fgt_always_active_9(refclk_fgt_always_active_9),
        .systempll_c0_counter_0(systempll_c0_counter_0),
        .systempll_c0_output_enable_0(systempll_c0_output_enable_0),
        .systempll_c1_counter_0(systempll_c1_counter_0),
        .systempll_c1_output_enable_0(systempll_c1_output_enable_0),
        .systempll_c2_counter_0(systempll_c2_counter_0),
        .systempll_c2_output_enable_0(systempll_c2_output_enable_0),
        .systempll_f_out_c0_hz_0(systempll_f_out_c0_hz_0),
        .systempll_f_out_c1_hz_0(systempll_f_out_c1_hz_0),
        .systempll_f_out_c2_hz_0(systempll_f_out_c2_hz_0),
        .systempll_f_pfd_hz_0(systempll_f_pfd_hz_0),
        .systempll_f_ref_hz_0(systempll_f_ref_hz_0),
        .systempll_f_vco_hz_0(systempll_f_vco_hz_0),
        .systempll_fractional_enable_0(systempll_fractional_enable_0),
        .systempll_m_counter_0(systempll_m_counter_0),
        .systempll_n_counter_0(systempll_n_counter_0),
        .systempll_primary_use_0(systempll_primary_use_0),
        .systempll_refclk_mux_select_0(systempll_refclk_mux_select_0),
        .systempll_eth_flux_used_0(systempll_eth_flux_used_0),
        .systempll_c0_counter_1(systempll_c0_counter_1),
        .systempll_c0_output_enable_1(systempll_c0_output_enable_1),
        .systempll_c1_counter_1(systempll_c1_counter_1),
        .systempll_c1_output_enable_1(systempll_c1_output_enable_1),
        .systempll_c2_counter_1(systempll_c2_counter_1),
        .systempll_c2_output_enable_1(systempll_c2_output_enable_1),
        .systempll_f_out_c0_hz_1(systempll_f_out_c0_hz_1),
        .systempll_f_out_c1_hz_1(systempll_f_out_c1_hz_1),
        .systempll_f_out_c2_hz_1(systempll_f_out_c2_hz_1),
        .systempll_f_pfd_hz_1(systempll_f_pfd_hz_1),
        .systempll_f_ref_hz_1(systempll_f_ref_hz_1),
        .systempll_f_vco_hz_1(systempll_f_vco_hz_1),
        .systempll_fractional_enable_1(systempll_fractional_enable_1),
        .systempll_m_counter_1(systempll_m_counter_1),
        .systempll_n_counter_1(systempll_n_counter_1),
        .systempll_primary_use_1(systempll_primary_use_1),
        .systempll_refclk_mux_select_1(systempll_refclk_mux_select_1),
        .systempll_eth_flux_used_1(systempll_eth_flux_used_1),
        .systempll_c0_counter_2(systempll_c0_counter_2),
        .systempll_c0_output_enable_2(systempll_c0_output_enable_2),
        .systempll_c1_counter_2(systempll_c1_counter_2),
        .systempll_c1_output_enable_2(systempll_c1_output_enable_2),
        .systempll_c2_counter_2(systempll_c2_counter_2),
        .systempll_c2_output_enable_2(systempll_c2_output_enable_2),
        .systempll_f_out_c0_hz_2(systempll_f_out_c0_hz_2),
        .systempll_f_out_c1_hz_2(systempll_f_out_c1_hz_2),
        .systempll_f_out_c2_hz_2(systempll_f_out_c2_hz_2),
        .systempll_f_pfd_hz_2(systempll_f_pfd_hz_2),
        .systempll_f_ref_hz_2(systempll_f_ref_hz_2),
        .systempll_f_vco_hz_2(systempll_f_vco_hz_2),
        .systempll_fractional_enable_2(systempll_fractional_enable_2),
        .systempll_m_counter_2(systempll_m_counter_2),
        .systempll_n_counter_2(systempll_n_counter_2),
        .systempll_primary_use_2(systempll_primary_use_2),
        .systempll_refclk_mux_select_2(systempll_refclk_mux_select_2),
        .systempll_eth_flux_used_2(systempll_eth_flux_used_2),
        .enables_refclk_fgt(enables_refclk_fgt),
        .enables_coreclk_fgt(enables_coreclk_fgt),
        .refclk_fgt_freq_0(refclk_fgt_freq_0),
        .refclk_fgt_freq_1(refclk_fgt_freq_1),
        .refclk_fgt_freq_2(refclk_fgt_freq_2),
        .refclk_fgt_freq_3(refclk_fgt_freq_3),
        .refclk_fgt_freq_4(refclk_fgt_freq_4),
        .refclk_fgt_freq_5(refclk_fgt_freq_5),
        .refclk_fgt_freq_6(refclk_fgt_freq_6),
        .refclk_fgt_freq_7(refclk_fgt_freq_7),
        .refclk_fgt_freq_8(refclk_fgt_freq_8),
        .refclk_fgt_freq_9(refclk_fgt_freq_9),
        .enables_cdrout_fgt(enables_cdrout_fgt),
        .enables_refclk_fht(enables_refclk_fht),
        .fhtref_fref_hz_0(fhtref_fref_hz_0),
        .fhtref_fref_hz_1(fhtref_fref_hz_1),
        .enables_commonpll(enables_commonpll),
        .commonpll_refsrc_0(commonpll_refsrc_0),
        .commonpll_refsrc_1(commonpll_refsrc_1),
        .cmnpll_en_cmos_refclk_out(cmnpll_en_cmos_refclk_out),
        .cmnpll_xtensa_used_0(cmnpll_xtensa_used_0),
        .cmnpll_xtensa_used_1(cmnpll_xtensa_used_1),
        .silicon_revision(silicon_revision),
        .device_revision(device_revision)
    ) x_hip (
        .*,
        .out_ctrl_pll_aibrc_clock_top__pll_0_slice0_clk_real(w_ctrl_pll_aibrc_clock_top__pll_0_slice0_clk_real),
        .out_ctrl_pll_aibrc_clock_top__pll_0_slice1_clk_real(w_ctrl_pll_aibrc_clock_top__pll_0_slice1_clk_real),
        .out_ctrl_pll_aibrc_clock_top__pll_0_slice2_clk_real(w_ctrl_pll_aibrc_clock_top__pll_0_slice2_clk_real),
        .out_ctrl_pll_aibrc_clock_top__pll_0_slice3_clk_real(w_ctrl_pll_aibrc_clock_top__pll_0_slice3_clk_real),
 
        .out_ctrl_pll_aibrc_clock_top__pll_1_slice0_clk_real(w_ctrl_pll_aibrc_clock_top__pll_1_slice0_clk_real),
        .out_ctrl_pll_aibrc_clock_top__pll_1_slice1_clk_real(w_ctrl_pll_aibrc_clock_top__pll_1_slice1_clk_real),
        .out_ctrl_pll_aibrc_clock_top__pll_1_slice2_clk_real(w_ctrl_pll_aibrc_clock_top__pll_1_slice2_clk_real),
        .out_ctrl_pll_aibrc_clock_top__pll_1_slice3_clk_real(w_ctrl_pll_aibrc_clock_top__pll_1_slice3_clk_real),
 
        .out_ctrl_pll_aibrc_clock_top__pll_2_slice0_clk_real(w_ctrl_pll_aibrc_clock_top__pll_2_slice0_clk_real),
        .out_ctrl_pll_aibrc_clock_top__pll_2_slice1_clk_real(w_ctrl_pll_aibrc_clock_top__pll_2_slice1_clk_real),
        .out_ctrl_pll_aibrc_clock_top__pll_2_slice2_clk_real(w_ctrl_pll_aibrc_clock_top__pll_2_slice2_clk_real),
        .out_ctrl_pll_aibrc_clock_top__pll_2_slice3_clk_real(w_ctrl_pll_aibrc_clock_top__pll_2_slice3_clk_real),
 
 
    // AVMM1 ports ref_2
        .pld_avmm1_busy_ref_2( pld_avmm1_busy_ref_2 ),
        .pld_avmm1_clk_rowclk_ref_2( pld_avmm1_clk_rowclk_ref_2 ),
        .pld_avmm1_cmdfifo_wr_full_ref_2( pld_avmm1_cmdfifo_wr_full_ref_2 ),
        .pld_avmm1_cmdfifo_wr_pfull_ref_2( pld_avmm1_cmdfifo_wr_pfull_ref_2 ),
        .pld_avmm1_read_ref_2 ( pld_avmm1_read_ref_2 ),
        .pld_avmm1_readdata_ref_2 ( pld_avmm1_readdata_ref_2 ),
        .pld_avmm1_readdatavalid_ref_2 ( pld_avmm1_readdatavalid_ref_2 ),
        .pld_avmm1_reg_addr_ref_2( pld_avmm1_reg_addr_ref_2 ),
        .pld_avmm1_request_ref_2( pld_avmm1_request_ref_2 ),
        .pld_avmm1_reserved_in_ref_2 ( pld_avmm1_reserved_in_ref_2 ),
        .pld_avmm1_reserved_out_ref_2 ( pld_avmm1_reserved_out_ref_2 ),
        .pld_avmm1_write_ref_2 ( pld_avmm1_write_ref_2 ),
        .pld_avmm1_writedata_ref_2( pld_avmm1_writedata_ref_2 ),
        .pld_chnl_cal_done_ref_2( pld_chnl_cal_done_ref_2 ),
        .pld_hssi_osc_transfer_en_ref_2( pld_hssi_osc_transfer_en_ref_2 ),
    // AVMM1 ports ref_3
        .pld_avmm1_busy_ref_3( pld_avmm1_busy_ref_3 ),
        .pld_avmm1_clk_rowclk_ref_3( pld_avmm1_clk_rowclk_ref_3 ),
        .pld_avmm1_cmdfifo_wr_full_ref_3( pld_avmm1_cmdfifo_wr_full_ref_3 ),
        .pld_avmm1_cmdfifo_wr_pfull_ref_3( pld_avmm1_cmdfifo_wr_pfull_ref_3 ),
        .pld_avmm1_read_ref_3 ( pld_avmm1_read_ref_3 ),
        .pld_avmm1_readdata_ref_3 ( pld_avmm1_readdata_ref_3 ),
        .pld_avmm1_readdatavalid_ref_3 ( pld_avmm1_readdatavalid_ref_3 ),
        .pld_avmm1_reg_addr_ref_3( pld_avmm1_reg_addr_ref_3 ),
        .pld_avmm1_request_ref_3( pld_avmm1_request_ref_3 ),
        .pld_avmm1_reserved_in_ref_3 ( pld_avmm1_reserved_in_ref_3 ),
        .pld_avmm1_reserved_out_ref_3 ( pld_avmm1_reserved_out_ref_3 ),
        .pld_avmm1_write_ref_3 ( pld_avmm1_write_ref_3 ),
        .pld_avmm1_writedata_ref_3( pld_avmm1_writedata_ref_3 ),
        .pld_chnl_cal_done_ref_3( pld_chnl_cal_done_ref_3 ),
        .pld_hssi_osc_transfer_en_ref_3( pld_hssi_osc_transfer_en_ref_3 ),
    // AVMM1 ports ref_4
        .pld_avmm1_busy_ref_4( pld_avmm1_busy_ref_4 ),
        .pld_avmm1_clk_rowclk_ref_4( pld_avmm1_clk_rowclk_ref_4 ),
        .pld_avmm1_cmdfifo_wr_full_ref_4( pld_avmm1_cmdfifo_wr_full_ref_4 ),
        .pld_avmm1_cmdfifo_wr_pfull_ref_4( pld_avmm1_cmdfifo_wr_pfull_ref_4 ),
        .pld_avmm1_read_ref_4 ( pld_avmm1_read_ref_4 ),
        .pld_avmm1_readdata_ref_4 ( pld_avmm1_readdata_ref_4 ),
        .pld_avmm1_readdatavalid_ref_4 ( pld_avmm1_readdatavalid_ref_4 ),
        .pld_avmm1_reg_addr_ref_4( pld_avmm1_reg_addr_ref_4 ),
        .pld_avmm1_request_ref_4( pld_avmm1_request_ref_4 ),
        .pld_avmm1_reserved_in_ref_4 ( pld_avmm1_reserved_in_ref_4 ),
        .pld_avmm1_reserved_out_ref_4 ( pld_avmm1_reserved_out_ref_4 ),
        .pld_avmm1_write_ref_4 ( pld_avmm1_write_ref_4 ),
        .pld_avmm1_writedata_ref_4( pld_avmm1_writedata_ref_4 ),
        .pld_chnl_cal_done_ref_4( pld_chnl_cal_done_ref_4 ),
        .pld_hssi_osc_transfer_en_ref_4( pld_hssi_osc_transfer_en_ref_4 ),
    // AVMM1 ports ref_5
        .pld_avmm1_busy_ref_5( pld_avmm1_busy_ref_5 ),
        .pld_avmm1_clk_rowclk_ref_5( pld_avmm1_clk_rowclk_ref_5 ),
        .pld_avmm1_cmdfifo_wr_full_ref_5( pld_avmm1_cmdfifo_wr_full_ref_5 ),
        .pld_avmm1_cmdfifo_wr_pfull_ref_5( pld_avmm1_cmdfifo_wr_pfull_ref_5 ),
        .pld_avmm1_read_ref_5 ( pld_avmm1_read_ref_5 ),
        .pld_avmm1_readdata_ref_5 ( pld_avmm1_readdata_ref_5 ),
        .pld_avmm1_readdatavalid_ref_5 ( pld_avmm1_readdatavalid_ref_5 ),
        .pld_avmm1_reg_addr_ref_5( pld_avmm1_reg_addr_ref_5 ),
        .pld_avmm1_request_ref_5( pld_avmm1_request_ref_5 ),
        .pld_avmm1_reserved_in_ref_5 ( pld_avmm1_reserved_in_ref_5 ),
        .pld_avmm1_reserved_out_ref_5 ( pld_avmm1_reserved_out_ref_5 ),
        .pld_avmm1_write_ref_5 ( pld_avmm1_write_ref_5 ),
        .pld_avmm1_writedata_ref_5( pld_avmm1_writedata_ref_5 ),
        .pld_chnl_cal_done_ref_5( pld_chnl_cal_done_ref_5 ),
        .pld_hssi_osc_transfer_en_ref_5( pld_hssi_osc_transfer_en_ref_5 ),
 
        // AVMM1 ports
        .pld_avmm1_busy( pld_avmm1_busy ),
        .pld_avmm1_clk_rowclk( pld_avmm1_clk_rowclk ),
        .pld_avmm1_cmdfifo_wr_full( pld_avmm1_cmdfifo_wr_full ),
        .pld_avmm1_cmdfifo_wr_pfull( pld_avmm1_cmdfifo_wr_pfull ),
        .pld_avmm1_read ( pld_avmm1_read ),
        .pld_avmm1_readdata ( pld_avmm1_readdata ),
        .pld_avmm1_readdatavalid ( pld_avmm1_readdatavalid ),
        .pld_avmm1_reg_addr( pld_avmm1_reg_addr ),
        .pld_avmm1_request( pld_avmm1_request ),
        .pld_avmm1_reserved_in ( pld_avmm1_reserved_in ),
        .pld_avmm1_reserved_out ( pld_avmm1_reserved_out ),
        .pld_avmm1_write ( pld_avmm1_write ),
        .pld_avmm1_writedata( pld_avmm1_writedata ),
        .pld_chnl_cal_done( pld_chnl_cal_done ),
        .pld_hssi_osc_transfer_en( pld_hssi_osc_transfer_en )
 
       
 
    );
 
    ftile_systempll_ref4_systemclk_f_400_v3lqleq_sip #(
        .enables_systempll(enables_systempll),
        .enables_refclk_fgt(enables_refclk_fgt),
        .enables_coreclk_fgt(enables_coreclk_fgt),
        .refclk_fgt_always_active_0(refclk_fgt_always_active_0),
        .refclk_fgt_always_active_1(refclk_fgt_always_active_1),
        .refclk_fgt_always_active_2(refclk_fgt_always_active_2),
        .refclk_fgt_always_active_3(refclk_fgt_always_active_3),
        .refclk_fgt_always_active_4(refclk_fgt_always_active_4),
        .refclk_fgt_always_active_5(refclk_fgt_always_active_5),
        .refclk_fgt_always_active_6(refclk_fgt_always_active_6),
        .refclk_fgt_always_active_7(refclk_fgt_always_active_7),
        .refclk_fgt_always_active_8(refclk_fgt_always_active_8),
        .refclk_fgt_always_active_9(refclk_fgt_always_active_9),
        .avmm_data_width(avmm_data_width),
        .avmm_addr_width (avmm_addr_width ),
        .read_pipeline_enable(read_pipeline_enable),
        .avmm_jtag_enable(avmm_jtag_enable),
        .refclkready_enable(refclkready_enable)
    )
    x_sip
    (
        .in_ctrl_pll_aibrc_clock_top__pll_0_slice0_clk_real(w_ctrl_pll_aibrc_clock_top__pll_0_slice0_clk_real),
        .in_ctrl_pll_aibrc_clock_top__pll_0_slice1_clk_real(w_ctrl_pll_aibrc_clock_top__pll_0_slice1_clk_real),
        .in_ctrl_pll_aibrc_clock_top__pll_0_slice2_clk_real(w_ctrl_pll_aibrc_clock_top__pll_0_slice2_clk_real),
        .in_ctrl_pll_aibrc_clock_top__pll_0_slice3_clk_real(w_ctrl_pll_aibrc_clock_top__pll_0_slice3_clk_real),
 
        .in_ctrl_pll_aibrc_clock_top__pll_1_slice0_clk_real(w_ctrl_pll_aibrc_clock_top__pll_1_slice0_clk_real),
        .in_ctrl_pll_aibrc_clock_top__pll_1_slice1_clk_real(w_ctrl_pll_aibrc_clock_top__pll_1_slice1_clk_real),
        .in_ctrl_pll_aibrc_clock_top__pll_1_slice2_clk_real(w_ctrl_pll_aibrc_clock_top__pll_1_slice2_clk_real),
        .in_ctrl_pll_aibrc_clock_top__pll_1_slice3_clk_real(w_ctrl_pll_aibrc_clock_top__pll_1_slice3_clk_real),
 
        .in_ctrl_pll_aibrc_clock_top__pll_2_slice0_clk_real(w_ctrl_pll_aibrc_clock_top__pll_2_slice0_clk_real),
        .in_ctrl_pll_aibrc_clock_top__pll_2_slice1_clk_real(w_ctrl_pll_aibrc_clock_top__pll_2_slice1_clk_real),
        .in_ctrl_pll_aibrc_clock_top__pll_2_slice2_clk_real(w_ctrl_pll_aibrc_clock_top__pll_2_slice2_clk_real),
        .in_ctrl_pll_aibrc_clock_top__pll_2_slice3_clk_real(w_ctrl_pll_aibrc_clock_top__pll_2_slice3_clk_real),
 
        .in_coreclk_0(out_coreclk_0),
        .in_coreclk_1(out_coreclk_1),
        .in_coreclk_2(out_coreclk_2),
        .in_coreclk_3(out_coreclk_3),
        .in_coreclk_4(out_coreclk_4),
        .in_coreclk_5(out_coreclk_5),
        .in_coreclk_6(out_coreclk_6),
        .in_coreclk_7(out_coreclk_7),
        .in_coreclk_8(out_coreclk_8),
        .in_coreclk_9(out_coreclk_9),
        //.avmm_clk(avmm_clk),
        .avmm_reset_in(avmm_reset),
        .refclock_ready(refclock_ready),
        .refclock_status(refclock_status),
        .enable_syspll_watchdog_timer(enable_syspll_watchdog_timer),
        .syspll_watchdog_timeout(syspll_watchdog_timeout),
 
        .en_refclk_fgt_2(en_refclk_fgt_2),
        .refclk_fgt_enabled_2(refclk_fgt_enabled_2),
        .disable_refclk_monitor_2(disable_refclk_monitor_2),
        .enable_refclk_watchdog_timer_2(enable_refclk_watchdog_timer_2),
        .refclk_watchdog_timeout_2(refclk_watchdog_timeout_2),
        // AVMM1 ports ref_2
        .pld_avmm1_busy_ref_2( pld_avmm1_busy_ref_2 ),
        .pld_avmm1_clk_rowclk_ref_2( pld_avmm1_clk_rowclk_ref_2 ),
        .pld_avmm1_cmdfifo_wr_full_ref_2( pld_avmm1_cmdfifo_wr_full_ref_2 ),
        .pld_avmm1_cmdfifo_wr_pfull_ref_2( pld_avmm1_cmdfifo_wr_pfull_ref_2 ),
        .pld_avmm1_read_ref_2 ( pld_avmm1_read_ref_2 ),
        .pld_avmm1_readdata_ref_2 ( pld_avmm1_readdata_ref_2 ),
        .pld_avmm1_readdatavalid_ref_2 ( pld_avmm1_readdatavalid_ref_2 ),
        .pld_avmm1_reg_addr_ref_2( pld_avmm1_reg_addr_ref_2 ),
        .pld_avmm1_request_ref_2( pld_avmm1_request_ref_2 ),
        .pld_avmm1_reserved_in_ref_2 ( pld_avmm1_reserved_in_ref_2 ),
        .pld_avmm1_reserved_out_ref_2 ( pld_avmm1_reserved_out_ref_2 ),
        .pld_avmm1_write_ref_2 ( pld_avmm1_write_ref_2 ),
        .pld_avmm1_writedata_ref_2( pld_avmm1_writedata_ref_2 ),
        .pld_chnl_cal_done_ref_2( pld_chnl_cal_done_ref_2 ),
        .pld_hssi_osc_transfer_en_ref_2( pld_hssi_osc_transfer_en_ref_2 ),
 
        .en_refclk_fgt_3(en_refclk_fgt_3),
        .refclk_fgt_enabled_3(refclk_fgt_enabled_3),
        .disable_refclk_monitor_3(disable_refclk_monitor_3),
        .enable_refclk_watchdog_timer_3(enable_refclk_watchdog_timer_3),
        .refclk_watchdog_timeout_3(refclk_watchdog_timeout_3),
        // AVMM1 ports ref_3
        .pld_avmm1_busy_ref_3( pld_avmm1_busy_ref_3 ),
        .pld_avmm1_clk_rowclk_ref_3( pld_avmm1_clk_rowclk_ref_3 ),
        .pld_avmm1_cmdfifo_wr_full_ref_3( pld_avmm1_cmdfifo_wr_full_ref_3 ),
        .pld_avmm1_cmdfifo_wr_pfull_ref_3( pld_avmm1_cmdfifo_wr_pfull_ref_3 ),
        .pld_avmm1_read_ref_3 ( pld_avmm1_read_ref_3 ),
        .pld_avmm1_readdata_ref_3 ( pld_avmm1_readdata_ref_3 ),
        .pld_avmm1_readdatavalid_ref_3 ( pld_avmm1_readdatavalid_ref_3 ),
        .pld_avmm1_reg_addr_ref_3( pld_avmm1_reg_addr_ref_3 ),
        .pld_avmm1_request_ref_3( pld_avmm1_request_ref_3 ),
        .pld_avmm1_reserved_in_ref_3 ( pld_avmm1_reserved_in_ref_3 ),
        .pld_avmm1_reserved_out_ref_3 ( pld_avmm1_reserved_out_ref_3 ),
        .pld_avmm1_write_ref_3 ( pld_avmm1_write_ref_3 ),
        .pld_avmm1_writedata_ref_3( pld_avmm1_writedata_ref_3 ),
        .pld_chnl_cal_done_ref_3( pld_chnl_cal_done_ref_3 ),
        .pld_hssi_osc_transfer_en_ref_3( pld_hssi_osc_transfer_en_ref_3 ),
 
        .en_refclk_fgt_4(en_refclk_fgt_4),
        .refclk_fgt_enabled_4(refclk_fgt_enabled_4),
        .disable_refclk_monitor_4(disable_refclk_monitor_4),
        .enable_refclk_watchdog_timer_4(enable_refclk_watchdog_timer_4),
        .refclk_watchdog_timeout_4(refclk_watchdog_timeout_4),
        // AVMM1 ports ref_4
        .pld_avmm1_busy_ref_4( pld_avmm1_busy_ref_4 ),
        .pld_avmm1_clk_rowclk_ref_4( pld_avmm1_clk_rowclk_ref_4 ),
        .pld_avmm1_cmdfifo_wr_full_ref_4( pld_avmm1_cmdfifo_wr_full_ref_4 ),
        .pld_avmm1_cmdfifo_wr_pfull_ref_4( pld_avmm1_cmdfifo_wr_pfull_ref_4 ),
        .pld_avmm1_read_ref_4 ( pld_avmm1_read_ref_4 ),
        .pld_avmm1_readdata_ref_4 ( pld_avmm1_readdata_ref_4 ),
        .pld_avmm1_readdatavalid_ref_4 ( pld_avmm1_readdatavalid_ref_4 ),
        .pld_avmm1_reg_addr_ref_4( pld_avmm1_reg_addr_ref_4 ),
        .pld_avmm1_request_ref_4( pld_avmm1_request_ref_4 ),
        .pld_avmm1_reserved_in_ref_4 ( pld_avmm1_reserved_in_ref_4 ),
        .pld_avmm1_reserved_out_ref_4 ( pld_avmm1_reserved_out_ref_4 ),
        .pld_avmm1_write_ref_4 ( pld_avmm1_write_ref_4 ),
        .pld_avmm1_writedata_ref_4( pld_avmm1_writedata_ref_4 ),
        .pld_chnl_cal_done_ref_4( pld_chnl_cal_done_ref_4 ),
        .pld_hssi_osc_transfer_en_ref_4( pld_hssi_osc_transfer_en_ref_4 ),
 
        .en_refclk_fgt_5(en_refclk_fgt_5),
        .refclk_fgt_enabled_5(refclk_fgt_enabled_5),
        .disable_refclk_monitor_5(disable_refclk_monitor_5),
        .enable_refclk_watchdog_timer_5(enable_refclk_watchdog_timer_5),
        .refclk_watchdog_timeout_5(refclk_watchdog_timeout_5),
        // AVMM1 ports ref_5
        .pld_avmm1_busy_ref_5( pld_avmm1_busy_ref_5 ),
        .pld_avmm1_clk_rowclk_ref_5( pld_avmm1_clk_rowclk_ref_5 ),
        .pld_avmm1_cmdfifo_wr_full_ref_5( pld_avmm1_cmdfifo_wr_full_ref_5 ),
        .pld_avmm1_cmdfifo_wr_pfull_ref_5( pld_avmm1_cmdfifo_wr_pfull_ref_5 ),
        .pld_avmm1_read_ref_5 ( pld_avmm1_read_ref_5 ),
        .pld_avmm1_readdata_ref_5 ( pld_avmm1_readdata_ref_5 ),
        .pld_avmm1_readdatavalid_ref_5 ( pld_avmm1_readdatavalid_ref_5 ),
        .pld_avmm1_reg_addr_ref_5( pld_avmm1_reg_addr_ref_5 ),
        .pld_avmm1_request_ref_5( pld_avmm1_request_ref_5 ),
        .pld_avmm1_reserved_in_ref_5 ( pld_avmm1_reserved_in_ref_5 ),
        .pld_avmm1_reserved_out_ref_5 ( pld_avmm1_reserved_out_ref_5 ),
        .pld_avmm1_write_ref_5 ( pld_avmm1_write_ref_5 ),
        .pld_avmm1_writedata_ref_5( pld_avmm1_writedata_ref_5 ),
        .pld_chnl_cal_done_ref_5( pld_chnl_cal_done_ref_5 ),
        .pld_hssi_osc_transfer_en_ref_5( pld_hssi_osc_transfer_en_ref_5 ),
 
        // AVMM1 ports
        .pld_avmm1_busy( pld_avmm1_busy ),
        .pld_avmm1_clk_rowclk( pld_avmm1_clk_rowclk ),
        .pld_avmm1_cmdfifo_wr_full( pld_avmm1_cmdfifo_wr_full ),
        .pld_avmm1_cmdfifo_wr_pfull( pld_avmm1_cmdfifo_wr_pfull ),
        .pld_avmm1_read ( pld_avmm1_read ),
        .pld_avmm1_readdata ( pld_avmm1_readdata ),
        .pld_avmm1_readdatavalid ( pld_avmm1_readdatavalid ),
        .pld_avmm1_reg_addr( pld_avmm1_reg_addr ),
        .pld_avmm1_request( pld_avmm1_request ),
        .pld_avmm1_reserved_in ( pld_avmm1_reserved_in ),
        .pld_avmm1_reserved_out ( pld_avmm1_reserved_out ),
        .pld_avmm1_write ( pld_avmm1_write ),
        .pld_avmm1_writedata( pld_avmm1_writedata ),
        .pld_chnl_cal_done( pld_chnl_cal_done ),
        .pld_hssi_osc_transfer_en( pld_hssi_osc_transfer_en )
       
    );
 
endmodule
 
(* tile_ip_sip *)
module ftile_systempll_ref4_systemclk_f_400_v3lqleq_sip
#(
    parameter  in_coreclk_2_pmap       = -1,
    parameter  in_coreclk_3_pmap       = -1,
    parameter  in_coreclk_4_pmap       = -1,
    parameter  in_coreclk_5_pmap       = -1,
 
    parameter  enables_systempll          = 0,
    parameter  enables_refclk_fgt         = 0,
    parameter  enables_coreclk_fgt        = 0,
    parameter  refclk_fgt_always_active_0 = 0,
    parameter  refclk_fgt_always_active_1 = 0,
    parameter  refclk_fgt_always_active_2 = 0,
    parameter  refclk_fgt_always_active_3 = 0,
    parameter  refclk_fgt_always_active_4 = 0,
    parameter  refclk_fgt_always_active_5 = 0,
    parameter  refclk_fgt_always_active_6 = 0,
    parameter  refclk_fgt_always_active_7 = 0,
    parameter  refclk_fgt_always_active_8 = 0,
    parameter  refclk_fgt_always_active_9 = 0,
    parameter  avmm_data_width            = 32, 
    parameter  avmm_addr_width            = 18,
`ifndef ALTERA_RESERVED_QIS
    parameter  timeout_cnt                = 14'h3000,  
    parameter  timeout_cnt_width          = 14,
    parameter  timeout_cnt1               = 9'h100,
    parameter  timeout_cnt1_width         = 9,
`else
    parameter  timeout_cnt                = 19'h40000,  
    parameter  timeout_cnt_width          = 19,
    parameter  timeout_cnt1               = 11'h400,
    parameter  timeout_cnt1_width         = 11,
`endif // ifndef ALTERA_RESERVED_QIS
    parameter  read_pipeline_enable       = 0,
    parameter  avmm_jtag_enable           = 0,
    parameter  refclkready_enable         = 0
)
(
    input in_ctrl_pll_aibrc_clock_top__pll_0_slice0_clk_real,
    input in_ctrl_pll_aibrc_clock_top__pll_0_slice1_clk_real,
    input in_ctrl_pll_aibrc_clock_top__pll_0_slice2_clk_real,
    input in_ctrl_pll_aibrc_clock_top__pll_0_slice3_clk_real,
    input in_ctrl_pll_aibrc_clock_top__pll_1_slice0_clk_real,
    input in_ctrl_pll_aibrc_clock_top__pll_1_slice1_clk_real,
    input in_ctrl_pll_aibrc_clock_top__pll_1_slice2_clk_real,
    input in_ctrl_pll_aibrc_clock_top__pll_1_slice3_clk_real,
    input in_ctrl_pll_aibrc_clock_top__pll_2_slice0_clk_real,
    input in_ctrl_pll_aibrc_clock_top__pll_2_slice1_clk_real,
    input in_ctrl_pll_aibrc_clock_top__pll_2_slice2_clk_real,
    input in_ctrl_pll_aibrc_clock_top__pll_2_slice3_clk_real,
 
    input in_coreclk_0,
    input in_coreclk_1,
    input in_coreclk_2,
    input in_coreclk_3,
    input in_coreclk_4,
    input in_coreclk_5,
    input in_coreclk_6,
    input in_coreclk_7,
    input in_coreclk_8,
    input in_coreclk_9,
    
    // AVMM ports from/to top
    //input avmm_clk,
    input avmm_reset_in,
    input[2:0] refclock_ready,
 
    output  logic refclock_status,
    input   en_refclk_fgt_0,
    input   en_refclk_fgt_1,
    input   en_refclk_fgt_2,
    input   en_refclk_fgt_3,
    input   en_refclk_fgt_4,
    input   en_refclk_fgt_5,
    input   en_refclk_fgt_6,
    input   en_refclk_fgt_7,
    input   en_refclk_fgt_8,
    input   en_refclk_fgt_9,
    
    output logic refclk_fgt_enabled_0,
    output logic refclk_fgt_enabled_1,
    output logic refclk_fgt_enabled_2,
    output logic refclk_fgt_enabled_3,
    output logic refclk_fgt_enabled_4,
    output logic refclk_fgt_enabled_5,
    output logic refclk_fgt_enabled_6,
    output logic refclk_fgt_enabled_7,
    output logic refclk_fgt_enabled_8,
    output logic refclk_fgt_enabled_9,
    
    input tri0 disable_refclk_monitor_0,
    input tri0 disable_refclk_monitor_1,
    input tri0 disable_refclk_monitor_2,
    input tri0 disable_refclk_monitor_3,
    input tri0 disable_refclk_monitor_4,
    input tri0 disable_refclk_monitor_5,
    input tri0 disable_refclk_monitor_6,
    input tri0 disable_refclk_monitor_7,
    input tri0 disable_refclk_monitor_8,
    input tri0 disable_refclk_monitor_9,
    
    input tri0 enable_syspll_watchdog_timer,                            
    input tri0 enable_refclk_watchdog_timer_0,
    input tri0 enable_refclk_watchdog_timer_1,
    input tri0 enable_refclk_watchdog_timer_2,
    input tri0 enable_refclk_watchdog_timer_3,
    input tri0 enable_refclk_watchdog_timer_4,
    input tri0 enable_refclk_watchdog_timer_5,
    input tri0 enable_refclk_watchdog_timer_6,
    input tri0 enable_refclk_watchdog_timer_7,
    input tri0 enable_refclk_watchdog_timer_8,
    input tri0 enable_refclk_watchdog_timer_9,
    
    
    output tri0 syspll_watchdog_timeout,
    output tri0 refclk_watchdog_timeout_0,
    output tri0 refclk_watchdog_timeout_1,
    output tri0 refclk_watchdog_timeout_2,
    output tri0 refclk_watchdog_timeout_3,
    output tri0 refclk_watchdog_timeout_4,
    output tri0 refclk_watchdog_timeout_5,
    output tri0 refclk_watchdog_timeout_6,
    output tri0 refclk_watchdog_timeout_7,
    output tri0 refclk_watchdog_timeout_8,
    output tri0 refclk_watchdog_timeout_9,
    

 
    input [3:0] in_coreclk_2_map,
 
//  for AVMM1 bb ports  refclk__2
    input           pld_avmm1_busy_ref_2,
    output          pld_avmm1_clk_rowclk_ref_2,
    (* alt_clk_source_user="pld_avmm1_clk_rowclk_ref_2", alt_clk_source_block="hdpldadapt_avmm1", alt_clk_source_port="pld_avmm1_clk_rowclk" *)
    input           i_common_avmm1_clk_2,
    input           pld_avmm1_cmdfifo_wr_full_ref_2,
    input           pld_avmm1_cmdfifo_wr_pfull_ref_2,
    output          pld_avmm1_read_ref_2,
    input  [7:0]    pld_avmm1_readdata_ref_2,
    input           pld_avmm1_readdatavalid_ref_2,
    output [9:0]    pld_avmm1_reg_addr_ref_2,
    output          pld_avmm1_request_ref_2,
    output [8:0]    pld_avmm1_reserved_in_ref_2,
    input  [2:0]    pld_avmm1_reserved_out_ref_2,
    output          pld_avmm1_write_ref_2,
    output [7:0]    pld_avmm1_writedata_ref_2,
    input           pld_chnl_cal_done_ref_2,
    input           pld_hssi_osc_transfer_en_ref_2,
 
    input [3:0] in_coreclk_3_map,
 
//  for AVMM1 bb ports  refclk__3
    input           pld_avmm1_busy_ref_3,
    output          pld_avmm1_clk_rowclk_ref_3,
    (* alt_clk_source_user="pld_avmm1_clk_rowclk_ref_3", alt_clk_source_block="hdpldadapt_avmm1", alt_clk_source_port="pld_avmm1_clk_rowclk" *)
    input           i_common_avmm1_clk_3,
    input           pld_avmm1_cmdfifo_wr_full_ref_3,
    input           pld_avmm1_cmdfifo_wr_pfull_ref_3,
    output          pld_avmm1_read_ref_3,
    input  [7:0]    pld_avmm1_readdata_ref_3,
    input           pld_avmm1_readdatavalid_ref_3,
    output [9:0]    pld_avmm1_reg_addr_ref_3,
    output          pld_avmm1_request_ref_3,
    output [8:0]    pld_avmm1_reserved_in_ref_3,
    input  [2:0]    pld_avmm1_reserved_out_ref_3,
    output          pld_avmm1_write_ref_3,
    output [7:0]    pld_avmm1_writedata_ref_3,
    input           pld_chnl_cal_done_ref_3,
    input           pld_hssi_osc_transfer_en_ref_3,
 
    input [3:0] in_coreclk_4_map,
 
//  for AVMM1 bb ports  refclk__4
    input           pld_avmm1_busy_ref_4,
    output          pld_avmm1_clk_rowclk_ref_4,
    (* alt_clk_source_user="pld_avmm1_clk_rowclk_ref_4", alt_clk_source_block="hdpldadapt_avmm1", alt_clk_source_port="pld_avmm1_clk_rowclk" *)
    input           i_common_avmm1_clk_4,
    input           pld_avmm1_cmdfifo_wr_full_ref_4,
    input           pld_avmm1_cmdfifo_wr_pfull_ref_4,
    output          pld_avmm1_read_ref_4,
    input  [7:0]    pld_avmm1_readdata_ref_4,
    input           pld_avmm1_readdatavalid_ref_4,
    output [9:0]    pld_avmm1_reg_addr_ref_4,
    output          pld_avmm1_request_ref_4,
    output [8:0]    pld_avmm1_reserved_in_ref_4,
    input  [2:0]    pld_avmm1_reserved_out_ref_4,
    output          pld_avmm1_write_ref_4,
    output [7:0]    pld_avmm1_writedata_ref_4,
    input           pld_chnl_cal_done_ref_4,
    input           pld_hssi_osc_transfer_en_ref_4,
 
    input [3:0] in_coreclk_5_map,
 
//  for AVMM1 bb ports  refclk__5
    input           pld_avmm1_busy_ref_5,
    output          pld_avmm1_clk_rowclk_ref_5,
    (* alt_clk_source_user="pld_avmm1_clk_rowclk_ref_5", alt_clk_source_block="hdpldadapt_avmm1", alt_clk_source_port="pld_avmm1_clk_rowclk" *)
    input           i_common_avmm1_clk_5,
    input           pld_avmm1_cmdfifo_wr_full_ref_5,
    input           pld_avmm1_cmdfifo_wr_pfull_ref_5,
    output          pld_avmm1_read_ref_5,
    input  [7:0]    pld_avmm1_readdata_ref_5,
    input           pld_avmm1_readdatavalid_ref_5,
    output [9:0]    pld_avmm1_reg_addr_ref_5,
    output          pld_avmm1_request_ref_5,
    output [8:0]    pld_avmm1_reserved_in_ref_5,
    input  [2:0]    pld_avmm1_reserved_out_ref_5,
    output          pld_avmm1_write_ref_5,
    output [7:0]    pld_avmm1_writedata_ref_5,
    input           pld_chnl_cal_done_ref_5,
    input           pld_hssi_osc_transfer_en_ref_5,
 
  //  for AVMM1 bb ports
  input             pld_avmm1_busy,
  output            pld_avmm1_clk_rowclk,
  (* alt_clk_source_user="pld_avmm1_clk_rowclk", alt_clk_source_block="hdpldadapt_avmm1", alt_clk_source_port="pld_avmm1_clk_rowclk" *)
  input             i_common_avmm1_clk,
  input             pld_avmm1_cmdfifo_wr_full,
  input             pld_avmm1_cmdfifo_wr_pfull,
  output            pld_avmm1_read,
  input  [7:0]      pld_avmm1_readdata,
  input             pld_avmm1_readdatavalid,
  output [9:0]      pld_avmm1_reg_addr,
  output            pld_avmm1_request,
  output [8:0]      pld_avmm1_reserved_in,
  input  [2:0]      pld_avmm1_reserved_out,
  output            pld_avmm1_write,
  output [7:0]      pld_avmm1_writedata,
  input             pld_chnl_cal_done,
  input             pld_hssi_osc_transfer_en
);
 
//Avmm1 mail box soft logic
  logic avmm_write;
  logic avmm_read;
  logic avmm_reset;
  logic avmm_reset_ip;
  logic avmm_reset_ip_sync;
  logic avmm_reset_ext;
  logic avmm_reset_in_sync;
  logic enable_syspll_watchdog_timer_sync;
  logic [9:0] count_reset=0 ;
  logic  [17:0] avmm_address;
  logic  [3:0]  avmm_byteenable;
  logic  [31:0] avmm_writedata;
  logic [31:0] avmm_readdata;
  logic        avmm_waitrequest;
  logic        avmm_readdatavalid;
 
 
  localparam S8_ADDR_WIDTH = 21;
  localparam BE_WIDTH      = avmm_data_width/8;
  logic [S8_ADDR_WIDTH-1:0]  avmm_m8_addr         ;  
  logic [7:0]                avmm_m8_wdata        ;  
  logic                      avmm_m8_write        ;  
  logic                      avmm_m8_read         ;  
  logic [7:0]                avmm_m8_readdata     ;  
  logic                      avmm_m8_waitrequest  ;  
  logic                      wait_timer_on=0;
  logic                      wait_timer1_on=0;
  logic                      wait_timer_on_in=0;
  logic                      wait_timer1_on_in=0;
  logic                      wait_timer_timeout; 
  logic                      wait_timer1_timeout;
  logic [timeout_cnt_width-1:0] timeout_timer_cnt=0;
  logic [timeout_cnt1_width-1:0] timeout_timer1_cnt=0;
  logic                      m32_read;
  logic                      m32_write;
  logic[avmm_data_width-1:0] m32_writedata  ;
  logic[avmm_data_width-1:0] m32_readdata ;
  logic                      m32_waitrequest;
  logic                      m32_readdatavalid;
  logic[avmm_addr_width-1:0] m32_address;
  logic [BE_WIDTH-1:0]       m32_byteenable;
 (* preserve *)
  logic                      cnoc_clk;
 
`ifndef ALTERA_RESERVED_QIS
  logic avmm_clk;

  localparam learning_count=1200;
  localparam detetction_count=120;
  always begin
    #2ns cnoc_clk = ~cnoc_clk;
  end
  initial begin
    cnoc_clk = 1'b0;
  end
  initial begin
        avmm_reset_ip = 1'b1;
    #20 avmm_reset_ip = 1'b0;
  end
  assign avmm_clk = cnoc_clk;
`else
  (* preserve, noprune *)
  reg avmm_clk = 1'b0;

  localparam learning_count=120000;
  localparam detetction_count=12000;
  altera_config_clock_source_endpoint clock_endpoint (
    .clk(cnoc_clk)
    );

   always @(posedge cnoc_clk) begin
         avmm_clk <= ~avmm_clk;
   end

   localparam USER_RESET_DELAY = 20;
    
  altera_agilex_config_reset_release_endpoint config_reset_release_endpoint(
    .conf_reset(avmm_reset_ip)
        );
`endif // ifndef ALTERA_RESERVED_QIS  
///mailbox implementation
    
   syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (1)
   ) avmm_reset2_sync_inst(
        .clk                       (i_common_avmm1_clk),
        .reset                     (avmm_reset_ip),
        .d                         (1'b0),
        .q                         (avmm_reset_ip_sync)
   );

    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) avmm_reset_in_sync_inst0(
        .clk                       (i_common_avmm1_clk),
        .reset                     (1'b0),
        .d                         (avmm_reset_in),
        .q                         (avmm_reset_in_sync)
   );
  
///


    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) enable_syspll_watchdog_sync_inst0(
        .clk                       (i_common_avmm1_clk),
        .reset                     (1'b0),
        .d                         (enable_syspll_watchdog_timer),
        .q                         (enable_syspll_watchdog_timer_sync)
   );

/// we need to modify to 5 bit counter
 always@ (posedge i_common_avmm1_clk )
    begin
      if (avmm_reset_ip_sync)
        count_reset<=10'd0; 
      else if (count_reset==10'd512)
        count_reset<=count_reset;
      else
        count_reset<=count_reset+1'b1;
    end
 assign avmm_reset_ext= (count_reset>=10'd512) ? 0 : 1;
 
 always@ (posedge i_common_avmm1_clk )
    begin
      avmm_reset<=avmm_reset_ext | avmm_reset_in_sync;
    end
  
  always @(posedge i_common_avmm1_clk ) 
  begin
    wait_timer_on_in <= wait_timer_on;
    wait_timer1_on_in <= wait_timer1_on;
   end
  
  always @(posedge i_common_avmm1_clk ) 
   begin
    if(wait_timer_on_in & enable_syspll_watchdog_timer_sync)     
      timeout_timer_cnt <= timeout_timer_cnt + 1'b1;        
    else
      timeout_timer_cnt <= {timeout_cnt_width{1'b0}};       
   end
  
  always @(posedge i_common_avmm1_clk ) 
 begin
    if(wait_timer1_on_in & enable_syspll_watchdog_timer_sync)    
    timeout_timer1_cnt <= timeout_timer1_cnt + 1'b1;        
    else
    timeout_timer1_cnt <= {timeout_cnt1_width{1'b0}};       
 end
 
  always @(posedge i_common_avmm1_clk ) 
   begin
    wait_timer_timeout  <= (timeout_timer_cnt >= timeout_cnt); 
    wait_timer1_timeout <= (timeout_timer1_cnt >= timeout_cnt1); 
   end

  //refclock ready signal OR operation
   syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) syspll_watchdog_timeout_sync_inst0(
        .clk                       (i_common_avmm1_clk),
        .reset                     (1'b0),
        .d                         (wait_timer_timeout),
        .q                         (syspll_watchdog_timeout)
   );

   // ref clock ready signal OR operation
   logic refclock_ready_or;
   logic [2:0] refclock_ready_or_reg;
   logic refclock_status_out;   
   
   localparam ST_IDLE              =4'h0;
   localparam ST_WRITE             =4'h1;
   localparam ST_WRITE_PAUSE       =4'h2;
   localparam ST_READ_check        =4'h3;
   localparam ST_READ              =4'h4;
   localparam ST_READ_PAUSE        =4'h5;
   localparam ST_WRITE_CLEAR       =4'h6;
   localparam ST_WRITE_CLEAR_PAUSE =4'h7;
   localparam ST_CLEAR             =4'h8;
   reg [3:0] cur_st=4'h0 /* synthesis preserve dont_replicate */;
   reg [3:0] next_st=4'h0 /* synthesis preserve dont_replicate */;

   
   //refclock ready signal OR operation
   syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) refclock_ready_sync_inst0(
        .clk                       (i_common_avmm1_clk),
        .reset                     (1'b0),
        .d                         (refclock_ready[0]),
        .q                         (refclock_ready_or_reg[0])
   );
   syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) refclock_ready_sync_inst1(
        .clk                       (i_common_avmm1_clk),
        .reset                     (1'b0),
        .d                         (refclock_ready[1]),
        .q                         (refclock_ready_or_reg[1])
   );
   syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) refclock_ready_sync_inst2(
        .clk                       (i_common_avmm1_clk),
        .reset                     (1'b0),
        .d                         (refclock_ready[2]),
        .q                         (refclock_ready_or_reg[2])
   );

  always @(posedge i_common_avmm1_clk) begin
    refclock_ready_or <= |refclock_ready_or_reg; 
  end

  always @(posedge i_common_avmm1_clk) begin
         refclock_status    <= refclock_status_out ;
  end

  always @(posedge i_common_avmm1_clk ) begin   
   if(avmm_reset) begin
      cur_st     <= ST_IDLE;
   end else begin
      cur_st     <= next_st;
    end
 end
 
//always_comb begin
`ifndef ALTERA_RESERVED_QIS
always@(*)
`else
always_comb 
`endif // ifndef ALTERA_RESERVED_QIS 
begin
    avmm_write = 1'b0;
    avmm_read  =1'b0;
    avmm_address =18'h0;
    avmm_byteenable =4'b0;
    avmm_writedata =32'h0;
    refclock_status_out = 1'b0;
    next_st      = ST_IDLE;
    wait_timer_on = 1'b0;
    wait_timer1_on = 1'b0;
    case (cur_st) 
        ST_IDLE: 
        begin
            avmm_write = 1'b0;
            avmm_read  =1'b0;
            refclock_status_out = 1'b0;
            avmm_address =18'h0;
            avmm_byteenable =4'b0;
            avmm_writedata =32'h0;
            if (refclock_ready_or) 
            begin 
                next_st = ST_WRITE;
            end 
            else
            begin 
                next_st = ST_IDLE;
            end   
        end
        ST_WRITE: 
        begin
            wait_timer_on = 1'b1;
            wait_timer1_on = 1'b0;
            if (wait_timer_timeout==1) begin
                next_st = ST_WRITE_PAUSE;
                wait_timer_on = 1'b0;
            end else if ( avmm_waitrequest ) 
            begin
                avmm_write = 1'b1;
                avmm_read  =1'b0;
                avmm_address =18'h0001;
                avmm_byteenable =4'b1111;
                avmm_writedata =32'h90000000;
                next_st = ST_WRITE;
                wait_timer_on = 1'b1;
                wait_timer1_on = 1'b0;
            end else if (!avmm_waitrequest) 
            begin 
                avmm_write = 1'b0;
                avmm_byteenable =4'b0000;
                avmm_address =18'h0001;
                next_st = ST_READ_check;  
                wait_timer_on = 1'b0;
                wait_timer1_on = 1'b0;
            end else 
            begin 
                next_st = ST_IDLE;
                wait_timer_on = 1'b0;
                wait_timer1_on = 1'b0;
            end
        end
        ST_WRITE_PAUSE:
        begin
            if(wait_timer1_timeout) 
            begin
                next_st = ST_IDLE;            
                wait_timer_on = 1'b0;
                wait_timer1_on = 1'b0;      
            end 
            else  
            begin       
                next_st = ST_WRITE_PAUSE;
            end
            avmm_write = 1'b0;
            avmm_read  =1'b0;
            avmm_byteenable =4'b0000;
            avmm_address =18'h0001;
            wait_timer_on = 1'b0;
            wait_timer1_on = 1'b1;                  
        end
        ST_READ_check: 
        begin  
            wait_timer_on = 1'b0;
            wait_timer1_on = 1'b1;                  
            avmm_write = 1'b0;
            avmm_read  =1'b0;
            if (wait_timer1_timeout) begin
                next_st = ST_IDLE;
                wait_timer1_on = 1'b0;                  
            end else if ( avmm_waitrequest ) 
            begin
                next_st = ST_READ;
            end 
            else 
            begin 
                next_st = ST_READ_check;
            end
        end
        ST_READ: 
        begin
            avmm_write = 1'b0;
            avmm_read  =1'b1;
            avmm_address =18'h0002;
            avmm_byteenable =4'b1111;
            wait_timer_on = 1'b1;
            wait_timer1_on = 1'b0;    
            if (wait_timer_timeout==1'b1) begin
                next_st = ST_READ_PAUSE;
                wait_timer_on = 1'b0;
            end else if (!avmm_waitrequest && (avmm_readdata[31:28]==4'h8 || avmm_readdata[31:28]==4'hA)) 
            begin
                next_st = ST_WRITE_CLEAR;
            end 
            else 
            begin 
                if (wait_timer_timeout==1'b1) 
                begin 
                    next_st = ST_READ_PAUSE;
                    wait_timer_on = 1'b0;
                    wait_timer1_on = 1'b0;
                end 
                else 
                begin 
                    next_st = ST_READ;
                end 
            end
        end
        ST_READ_PAUSE: 
        begin
            if (wait_timer1_timeout) 
            begin
                next_st=ST_IDLE;
                refclock_status_out = 1'b0;                  
                wait_timer_on = 1'b0;
                wait_timer1_on = 1'b0;  
            end 
            else 
            begin 
                next_st=ST_READ_PAUSE;
                refclock_status_out = 1'b0;               
            end         
            avmm_write = 1'b0;
            avmm_read  =1'b0;
            avmm_byteenable =4'b0000;
            avmm_address =18'h0002;
            wait_timer_on = 1'b0;
            wait_timer1_on = 1'b1;              
        end 
        ST_WRITE_CLEAR: 
        begin
            wait_timer_on = 1'b1;
            wait_timer1_on = 1'b0;  
            if (wait_timer_timeout) begin
                next_st = ST_WRITE_CLEAR_PAUSE;
                wait_timer_on = 1'b0;
            end else if (avmm_waitrequest) 
            begin
                refclock_status_out = 1'b0;
                avmm_write = 1'b1;
                avmm_read  =1'b0;
                avmm_address =18'h0001;
                avmm_byteenable =4'b1111;
                avmm_writedata =32'h00000000;
                wait_timer_on = 1'b1;
                wait_timer1_on = 1'b0;  
                if (wait_timer_timeout)
                    next_st = ST_WRITE_CLEAR_PAUSE;
                else
                    next_st = ST_WRITE_CLEAR;
            end 
            else 
            begin 
                next_st = ST_CLEAR;
                refclock_status_out = 1'b0; 
                wait_timer_on = 1'b0;
                wait_timer1_on = 1'b0;            
            end
        end
        ST_WRITE_CLEAR_PAUSE: 
        begin
            if (wait_timer1_timeout) 
            begin
                next_st=ST_IDLE;
                refclock_status_out = 1'b0;                  
                wait_timer_on = 1'b0;
                wait_timer1_on = 1'b0;  
            end 
            else 
            begin 
                next_st=ST_WRITE_CLEAR_PAUSE;
                refclock_status_out = 1'b0;               
            end 
            avmm_write = 1'b0;
            avmm_read  =1'b0;
            avmm_byteenable =4'b0000;
            avmm_address =18'h0001;
            wait_timer_on = 1'b0;
            wait_timer1_on = 1'b1;              
        end 
        ST_CLEAR: 
        begin
            if (!refclock_ready_or) 
            begin
                next_st = ST_IDLE;
                refclock_status_out = 1'b0;
                wait_timer_on = 1'b0;
                wait_timer1_on = 1'b0;
            end 
            else 
            begin 
                next_st = ST_CLEAR;
                refclock_status_out = 1'b1;
                wait_timer_on = 1'b0;
                wait_timer1_on = 1'b0;
            end
            avmm_write = 1'b0;
            avmm_read  =1'b0;
            avmm_address =18'h0;
            avmm_byteenable =4'b0;
            avmm_writedata =32'h0;
            wait_timer_on = 1'b0;
            wait_timer1_on = 1'b0;
            // refclock_status_out = 1'b0;
        end 
        default:
        begin 
            next_st = ST_IDLE;
        end 
    endcase
end
 
localparam integer MAX_CHARS_ALT_XCVR_NATIVE_S10 = 86;
  ////////////////////////////////////////////////////////////////////
  // Convert an integer to a string
  function [MAX_CHARS_ALT_XCVR_NATIVE_S10*8-1:0] int2str_alt_xcvr_native_s10(
    input integer in_int
  );
    integer i;
    integer this_char;
    i = 0;
    int2str_alt_xcvr_native_s10 = "";
    do
    begin
      this_char = (in_int % 10) + 48;
      int2str_alt_xcvr_native_s10[i*8+:8] = this_char[7:0];
      i=i+1;
      in_int = in_int / 10; 
    end
    while(in_int > 0);
  endfunction
 
 //assign avmm_readdata = m32_readdata;
 
 //Removed JTAG enable RTL code
         assign avmm_waitrequest   = m32_waitrequest  ;
         assign avmm_readdatavalid = m32_readdatavalid ;
         assign avmm_readdata      = m32_readdata;
         assign m32_read           = avmm_read    ;
         assign m32_write          = avmm_write   ;
         assign m32_address        = avmm_address ;
         assign m32_byteenable     = avmm_byteenable;
         assign m32_writedata      = avmm_writedata ;
 
    ft_avmm_32to8_bridge 
           #(   .ADDR_WIDTH ( avmm_addr_width ),
                .READ_PIPELINE_ENABLE ( read_pipeline_enable )
            )
      avmm_32to8_inst (
       // AVMM slave Port
       .i_clk                   (  i_common_avmm1_clk ), 
       .i_rst                   (  avmm_reset ),
       
       .i_avmm_s32_addr         ( m32_address ),  
       .i_avmm_s32_wdata        ( m32_writedata ), 
       .i_avmm_s32_write        ( m32_write ), 
       .i_avmm_s32_read         ( m32_read ), 
       .i_avmm_s32_byte_enable  ( m32_byteenable ),
       .o_avmm_s32_readdata     ( m32_readdata ), 
       .o_avmm_s32_waitrequest  ( m32_waitrequest ),
       .o_avmm_s32_readdatavalid( m32_readdatavalid ),
 
       // Master Port
       .o_avmm_m8_addr          ( avmm_m8_addr ),
       .o_avmm_m8_wdata         ( avmm_m8_wdata ), 
       .o_avmm_m8_write         ( avmm_m8_write ), 
       .o_avmm_m8_read          ( avmm_m8_read ), 
       .i_avmm_m8_readdata      ( avmm_m8_readdata ), 
       .i_avmm_m8_waitrequest   ( avmm_m8_waitrequest )   
   );
       
      // instantiate avmm2 core logic
   ctfb_avmm1_soft_logic
                #(  .avmm_interfaces(1),                 //Number of AVMM interfaces required - one for each bonded_lane, PLL, and Master CGB
                    .rcfg_enable (1)                    //Enable/disable reconfig interface 
                 ) avmm1_ena_inst   (
                // AVMM slave interface signals (user)
                 .avmm_clk (i_common_avmm1_clk) ,
                 .avmm_reset (avmm_reset),
                 .avmm_writedata (avmm_m8_wdata), 
                .avmm_address (avmm_m8_addr[9:0]), 
                .avmm_write (avmm_m8_write),
                .avmm_read (avmm_m8_read),
                .avmm_readdata (avmm_m8_readdata), 
                .avmm_waitrequest (avmm_m8_waitrequest),
                   
                // Signals from AVMM1 building block
                 .pld_avmm1_busy_real             ( pld_avmm1_busy),
                 .pld_avmm1_cmdfifo_wr_full_real  ( pld_avmm1_cmdfifo_wr_full ),
                 .pld_avmm1_cmdfifo_wr_pfull_real ( pld_avmm1_cmdfifo_wr_pfull ),
                 .pld_avmm1_readdata_real         ( pld_avmm1_readdata ),
                 .pld_avmm1_readdatavalid_real    ( pld_avmm1_readdatavalid),
                 .pld_avmm1_reserved_out_real     ( pld_avmm1_reserved_out ),
                 .pld_chnl_cal_done_real          ( pld_chnl_cal_done ),        
                 .pld_hssi_osc_transfer_en_real   ( pld_hssi_osc_transfer_en ),
                // Signals to AVMM1 building block
                 .pld_avmm1_clk_rowclk_real      (), //( pld_avmm1_clk_rowclk ),
                 .pld_avmm1_read_real             ( pld_avmm1_read),
                 .pld_avmm1_reg_addr_real         ( pld_avmm1_reg_addr),
                 .pld_avmm1_request_real          ( pld_avmm1_request ),
                 .pld_avmm1_reserved_in_real      ( pld_avmm1_reserved_in ),
                 .pld_avmm1_write_real            ( pld_avmm1_write ),
                 .pld_avmm1_writedata_real        ( pld_avmm1_writedata)
 
                );
assign pld_avmm1_clk_rowclk=avmm_clk;
 
//CLKRX Implementation 
  
 
     
//Avmm1 mail box soft logic

  
  logic avmm_write_2;    
  logic avmm_read_2;
  logic avmm_reset_2;
  logic avmm_reset_ip_sync_2;
  logic avmm_reset_ext_2;
  logic avmm_reset_in_sync_2;
  logic [9:0] count_reset_2;
  logic  [17:0] avmm_address_2;
  logic  [3:0]  avmm_byteenable_2;
  logic  [31:0] avmm_writedata_2;
  logic [31:0] avmm_readdata_2;
  logic        avmm_waitrequest_2;
  logic        avmm_readdatavalid_2;
 
  logic [S8_ADDR_WIDTH-1:0]  avmm_m8_addr_2         ;  
  logic [7:0]                avmm_m8_wdata_2        ;  
  logic                      avmm_m8_write_2        ;  
  logic                      avmm_m8_read_2         ;  
  logic [7:0]                avmm_m8_readdata_2     ;  
  logic                      avmm_m8_waitrequest_2  ;  
  logic                           m32_read_2;
  logic                           m32_write_2;
  logic[avmm_data_width-1:0]  m32_writedata_2  ;
  logic[avmm_data_width-1:0]  m32_readdata_2 ;
  logic                           m32_waitrequest_2;
  logic                           m32_readdatavalid_2;
  logic[avmm_addr_width-1:0]  m32_address_2;
  logic [BE_WIDTH-1:0]         m32_byteenable_2;
  logic  [1:0]                en_refclk_fgt_change_2;
  logic  [1:0]                en_refclk_fgt_change_detect_2;
 
  localparam count_width_2 = 17;
  localparam d_count_width_2                      = 15;
  logic enable_learning_phase_2; 
  logic enable_learning_phase_2_ff1_cnoc; 
  logic enable_learning_phase_2_ff2_cnoc;
    
  logic enable_learning_phase_2_ff1_core; 
  logic enable_learning_phase_2_ff2_core; 
  
  
  logic [count_width_2-1:0]  cnoc_2_count=0          ;
  logic [3:0] devide_count_10_2=0;
  logic refclk_count_en_2;
  logic start_refclk_monitor_2=0;
  logic cnoc_2_count_limit2;
  logic [d_count_width_2-1:0]   refclk_2_count=0         ;
  logic [d_count_width_2-1:0]   refclk_2_count_store ;
  logic [d_count_width_2-1:0]   refclk_2_count1 ;
  logic [d_count_width_2-1:0]   refclk_2_count2 ;
  logic store_cnoc_clk_2_limit;
  logic store_cnoc_clk_2_limit1;
  logic store_cnoc_clk_2_limit2;
  //detection & removal phase 
  logic start_refclk_monitor_2_enable ;
  logic start_refclk_monitor_2_enable1 ;
  logic start_refclk_monitor_2_enable2 ;
  logic d_start_refclk_monitor_2_enable2 ;
  logic enable_refclk_watchdog_timer_sync_2;
   
  logic [d_count_width_2-1:0]  d_refclk_2_count=0     ;
  logic [d_count_width_2-2:0]  d_cnoc_2_count  =0       ;
  logic d_cnoc_clk_2_limit;
  logic d_cnoc_clk_2_limit1;
  logic d_cnoc_clk_2_limit2;
  
  logic d_store_cnoc_clk_2_limit;
  logic d_store_cnoc_clk_2_limit1;
  logic d_store_cnoc_clk_2_limit2;
  logic [d_count_width_2-1:0] max_count_2;
  logic [d_count_width_2-1:0] min_count_2;
  logic  refclk_fgt_enabled_2_st;
  logic  refclk_fgt_enabled_2_sample;
  logic  refclk_fgt_enabled_2_st2;
  logic  refclk_fgt_enabled_2_enable ;
  logic disable_refclk_monitor_2_reg;
  logic disable_refclk_monitor_2_reg1;
  logic disable_refclk_monitor_2_chickenbit;
  logic [d_count_width_2-1:0]   d_refclk_2_count_store     ;
  logic                          d_refclk_2_count_store_en  ;
  logic                          d_refclk_2_count_store_en1 ;
  logic                          d_refclk_2_count_store_en2 ;
  logic  [1:0]                   one_state_2_store=0;
  logic                          one_state_2_store_en=0;
  logic                          d_store_cnoc_clk_2_limit3;
  logic                          d_store_cnoc_clk_2_limit3_neg_edge;
  logic                          disable_refclk_monitor_2_coreclk;
  logic                          disable_refclk_monitor_2_coreclk1;
  logic                          refclk_count2_data=1'b0;
  logic                          refclk_count2_data_reg1;
  logic                          reg_refclk_fgt_always_active_2;
  logic                          wait_timer_on_2=0;
  logic                          wait_timer1_on_2=0;
  logic                          wait_timer_on_in_2=0;
  logic                          wait_timer1_on_in_2=0;
  logic                          wait_timer_timeout_2; 
  logic                          wait_timer1_timeout_2; 
  logic [timeout_cnt_width-1:0]  timeout_timer_cnt_2=0;
  logic [timeout_cnt1_width-1:0] timeout_timer1_cnt_2=0;
  logic [1:0]                    in_coreclk_2_div=0;
  logic                          in_coreclk_2_div_sync;
  logic                          in_coreclk_2_div_sync_d1;
  logic                          in_coreclk_2_div_sync_edge;
  logic [8:0]                    count_2_cnoc_512=0;
  logic [8:0]                    count_2_coreclk=0;
  logic                          no_coreclk_2;
  logic                          no_coreclk_2_sync;


  
    
     syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (1)
   ) avmm_reset_ip_sync_2_sync_inst(
        .clk                       (i_common_avmm1_clk_2),
        .reset                     (avmm_reset_ip),
        .d                         (1'b0),
        .q                         (avmm_reset_ip_sync_2)
   );
  
    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) avmm_reset_in_sync_2_inst0(
        .clk                       (i_common_avmm1_clk_2),
        .reset                     (1'b0),
        .d                         (avmm_reset_in),
        .q                         (avmm_reset_in_sync_2)
   );
 
 
      syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) enable_refclk_watchdog_timer_2_inst0(
        .clk                       (i_common_avmm1_clk_2),
        .reset                     (1'b0),
        .d                         (enable_refclk_watchdog_timer_2),
        .q                         (enable_refclk_watchdog_timer_sync_2)
   );
  

  
  always@ (posedge i_common_avmm1_clk_2 )
    begin
      if (avmm_reset_ip_sync_2)
        count_reset_2<=10'd0; 
      else if (count_reset_2==10'd512)
        count_reset_2<=count_reset_2;
      else
        count_reset_2<=count_reset_2+1'b1;
    end
 assign avmm_reset_ext_2= (count_reset_2>=10'd512) ? 0 : 1;
 
   always@ (posedge i_common_avmm1_clk_2 )
   begin
     avmm_reset_2<=avmm_reset_ext_2 | avmm_reset_in_sync_2;
   end

  always @(posedge i_common_avmm1_clk_2 ) 
  begin
    wait_timer_on_in_2 <= wait_timer_on_2;
    wait_timer1_on_in_2 <= wait_timer1_on_2;
  end
  
 always @(posedge i_common_avmm1_clk_2 ) 
 begin
    if(wait_timer_on_in_2 & enable_refclk_watchdog_timer_sync_2)     
    timeout_timer_cnt_2 <= timeout_timer_cnt_2 + 1'b1;        
    else
    timeout_timer_cnt_2 <= {timeout_cnt_width{1'b0}};        
 end
  
 always @(posedge i_common_avmm1_clk_2 ) 
 begin
    if(wait_timer1_on_in_2 & enable_refclk_watchdog_timer_sync_2)    
    timeout_timer1_cnt_2 <= timeout_timer1_cnt_2 + 1'b1;      
    else
    timeout_timer1_cnt_2 <= {timeout_cnt1_width{1'b0}};      
 end
  
 always @(posedge i_common_avmm1_clk_2 ) 
 begin
    wait_timer_timeout_2 <= (timeout_timer_cnt_2 >= timeout_cnt); 
    wait_timer1_timeout_2 <= (timeout_timer1_cnt_2 >= timeout_cnt1); 
 end

     syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) refclk_watchdog_timeout_2_sync_inst(
        .clk                       (i_common_avmm1_clk_2),
        .reset                     (1'b0),
        .d                         (wait_timer_timeout_2),
        .q                         (refclk_watchdog_timeout_2)
   );

  /// start learning once refclk persent.
  
 always@(posedge in_coreclk_2 ) 
    begin
      if  (refclk_count2_data==1'b1)
        refclk_count2_data<=refclk_count2_data;
      else 
        refclk_count2_data<=refclk_count2_data+1'b1;
    end

     syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) refclk_count2_data_sync_inst(
        .clk                       (i_common_avmm1_clk_2),
        .reset                     (1'b0),
        .d                         (refclk_count2_data),
        .q                         (refclk_count2_data_reg1)
   );

    
//clkrx main: avmm state machine runs with avmm clock 
// state transition with avmm clock
  
 localparam ST_IDLE_R_2=4'd0;
 localparam ST_WRITE_ON_2=4'd1;
 localparam ST_WRITE_PAUSE_ON_2=4'd2;
 localparam ST_READ_check_ON_2=4'd3 ;
 localparam ST_READ_ON_2=4'd4;
 localparam ST_READ_PAUSE_ON_2=4'd5;
 localparam ST_WRITE_CLEAR_ON_2=4'd6;
 localparam ST_WRITE_OFF_2=4'd7;
 localparam ST_WRITE_PAUSE_OFF_2=4'd8;
 localparam ST_READ_check_OFF_2=4'd9;
 localparam ST_READ_OFF_2=4'd10;
 localparam ST_READ_PAUSE_OFF_2=4'd11;
 localparam ST_WRITE_CLEAR_OFF_2=4'd12;
 localparam ST_CLEAR_OFF_2=4'd13;
 reg [3:0] cur_st_2=4'd0 /* synthesis preserve dont_replicate */;
 reg [3:0] next_st_2=4'd0 /* synthesis preserve dont_replicate */; 
 
 
 
 
  always @(posedge i_common_avmm1_clk_2 ) begin
   if(avmm_reset_2) begin
      cur_st_2     <= ST_IDLE_R_2;
   end else begin
       cur_st_2     <= next_st_2;
    end
 end
 
// input synchronization in avmm clock domain 
logic reg_en_refclk_fgt_2;
logic reg1_en_refclk_fgt_2;


    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) en_refclk_fgt_2_sync_inst(
        .clk                       (i_common_avmm1_clk_2),
        .reset                     (1'b0),
        .d                         (en_refclk_fgt_2),
        .q                         (reg1_en_refclk_fgt_2)
   ); 
     

//avmm state machine combo logic
//always_comb  
`ifndef ALTERA_RESERVED_QIS
always@(*)
`else
always_comb 
`endif // ifndef ALTERA_RESERVED_QIS 

begin

    avmm_write_2 = 1'b0;
    avmm_read_2  =1'b0;
    avmm_address_2 =18'h0;
    avmm_byteenable_2 =4'b0;
    avmm_writedata_2 =32'h0;
    refclk_fgt_enabled_2_enable=1'b0;
    enable_learning_phase_2=1'b0;
    wait_timer_on_2 = 1'b0;
    wait_timer1_on_2 = 1'b0;
    next_st_2 = ST_IDLE_R_2;
    case (cur_st_2) 
        ST_IDLE_R_2 : 
        begin //idle state to initialize avmm read and write 
            avmm_write_2 = 1'b0;
            avmm_read_2  =1'b0;
            avmm_address_2 =18'h0;
            avmm_byteenable_2 =4'b0;
            enable_learning_phase_2=1'b0;
            avmm_writedata_2 =32'h0; 
            wait_timer_on_2 = 1'b0;
            wait_timer1_on_2 = 1'b0;
            if ((refclk_fgt_always_active_2==1) && (refclk_count2_data_reg1==1'b1))
                next_st_2 =   ST_WRITE_CLEAR_ON_2;
            else if (reg1_en_refclk_fgt_2==1'b1)
                next_st_2 =   ST_WRITE_ON_2;
            else
                next_st_2 =   ST_IDLE_R_2;                         
        end
        ST_WRITE_ON_2: 
        begin // mailbox write for stable clk 
            wait_timer_on_2 = 1'b1;
            wait_timer1_on_2 = 1'b0;
            if (wait_timer_timeout_2 == 1'b1) begin
                next_st_2 =ST_WRITE_PAUSE_ON_2;
                wait_timer_on_2 = 1'b0;
            end else if (avmm_waitrequest_2 ) 
            begin //  mailbox write for stable clk, loop in ST_WRITE_ON_2 until avmm_waitrequest went low
                avmm_write_2 = 1'b1;
                avmm_read_2  =1'b0;
                avmm_address_2 =18'h0001;
                avmm_byteenable_2 =4'b1111;
                avmm_writedata_2 ={1'h1,3'h2,in_coreclk_2_map,24'h000000};
                enable_learning_phase_2=1'b0;
                wait_timer_on_2 = 1'b1;
                wait_timer1_on_2 = 1'b0;
                next_st_2 =ST_WRITE_ON_2;
            end else if (!avmm_waitrequest_2 ) 
            begin //Move to ST_READ_check_ON_2 once get avmm_waitrequest low
                avmm_write_2 = 1'b0;
                avmm_byteenable_2 =4'b0000;
                avmm_address_2 =18'h0001;
                enable_learning_phase_2=1'b0;
                next_st_2 = ST_READ_check_ON_2;
                wait_timer_on_2  = 1'b0;
                wait_timer1_on_2 = 1'b0;
            end else 
            begin
                next_st_2 = ST_IDLE_R_2;     
                wait_timer_on_2  = 1'b0;
                wait_timer1_on_2 = 1'b0;
            end
        end
        ST_WRITE_PAUSE_ON_2: 
        begin
            avmm_write_2 = 1'b0;
            avmm_byteenable_2 =4'b0000;
            avmm_address_2 =18'h0001;
            enable_learning_phase_2=1'b0;
            wait_timer_on_2 = 1'b0;
            wait_timer1_on_2 = 1'b1;
            if(wait_timer1_timeout_2 == 1'b1) begin
                next_st_2 = ST_IDLE_R_2;     
                wait_timer1_on_2 = 1'b0;
            end
            else begin
                next_st_2 = ST_WRITE_PAUSE_ON_2;
            end            
        end
        ST_READ_check_ON_2: 
        begin
            enable_learning_phase_2=1'b0;
            wait_timer_on_2 = 1'b0;
            wait_timer1_on_2 = 1'b1;
            if(wait_timer1_timeout_2 == 1'b1) begin
                wait_timer1_on_2 = 1'b0;
                next_st_2 = ST_IDLE_R_2;
            end else if (avmm_waitrequest_2) 
            begin //Move to to ST_READ_ON_2 once avmm_waitrequest go high
                next_st_2 = ST_READ_ON_2;
            end else begin 
                next_st_2 = ST_READ_check_ON_2;
            end
        end
        ST_READ_ON_2: 
        begin
            enable_learning_phase_2=1'b0;
            avmm_write_2 = 1'b0;
            avmm_read_2  =1'b1;
            avmm_address_2 =18'h0002;
            avmm_byteenable_2 =4'b1111;
            //avmm_time_out_enable_2=1'b1;
            wait_timer_on_2 = 1'b1;
            wait_timer1_on_2 = 1'b0;
            if(wait_timer_timeout_2 == 1'b1)
            begin
                next_st_2=ST_READ_PAUSE_ON_2;
                wait_timer_on_2 = 1'b0;
                wait_timer1_on_2 = 1'b0;
            end else if (!avmm_waitrequest_2 && avmm_readdata_2[30:28]==3'h2 && avmm_readdata_2[31]==1'h1) 
            begin  // check FW read once get valid data move to state ST_WRITE_CLEAR_ON & generate flag for enable learning phase & assert refclk_fgt_enabled to high for user
                next_st_2 = ST_WRITE_CLEAR_ON_2;
                enable_learning_phase_2=1'b1;
                refclk_fgt_enabled_2_enable=1'b1;
                wait_timer_on_2 = 1'b0;
                wait_timer1_on_2 = 1'b0;
            end else begin
                refclk_fgt_enabled_2_enable=1'b0;
                next_st_2=ST_READ_ON_2;
            end            
        end
        ST_READ_PAUSE_ON_2: 
        begin             
            avmm_write_2 = 1'b0;
            avmm_read_2  =1'b0;
            avmm_byteenable_2 =4'b0000;
            avmm_address_2 =18'h0002;
            enable_learning_phase_2=1'b0;
            wait_timer_on_2 = 1'b0;
            wait_timer1_on_2 = 1'b1;
            refclk_fgt_enabled_2_enable=1'b0;
            if(wait_timer1_timeout_2 == 1'b1) begin
                next_st_2 = ST_IDLE_R_2;     
                wait_timer1_on_2 = 1'b0;
            end
            else begin
                next_st_2=ST_READ_PAUSE_ON_2;
            end
        end
        ST_WRITE_CLEAR_ON_2:             ///Need to clear the register as per new FW implementation  discussion needed with sidhartha 
        begin
            avmm_write_2 = 1'b0;
            avmm_read_2  =1'b0;
            avmm_address_2 =18'h0;
            avmm_byteenable_2 =4'b0;
            avmm_writedata_2 =32'h0;
            wait_timer_on_2 = 1'b0;
            wait_timer1_on_2 = 1'b0;
            enable_learning_phase_2=1'b1; 
            refclk_fgt_enabled_2_enable=1'b1;
            if (((~refclk_fgt_enabled_2_st2 &&  d_refclk_2_count_store_en && (!disable_refclk_monitor_2_reg1))) || ((reg1_en_refclk_fgt_2==1'b0) &&(refclk_fgt_always_active_2==0)) || (no_coreclk_2_sync && (!disable_refclk_monitor_2_reg1)))             
            begin // wait for monitoring logic to confirm if clock not in range or user indication for refclk not active
                next_st_2 = ST_WRITE_OFF_2;
            end else if ((~refclk_fgt_enabled_2_st2)  && (refclk_fgt_always_active_2==1) && (d_refclk_2_count_store_en) && (!disable_refclk_monitor_2_reg1) || (no_coreclk_2_sync && (!disable_refclk_monitor_2_reg1)))
                next_st_2 = ST_WRITE_OFF_2;
            else
                next_st_2 = ST_WRITE_CLEAR_ON_2;
        end 
        ST_WRITE_OFF_2: 
        begin // if monitoring logic to confirm clock not in range mailbox send command to off CML buffer  
            wait_timer_on_2 = 1'b1;
            wait_timer1_on_2 = 1'b0;
            enable_learning_phase_2=1'b0; 
            if (wait_timer_timeout_2)             
            begin
                next_st_2 = ST_WRITE_PAUSE_OFF_2;
                wait_timer_on_2 = 1'b0;
                wait_timer1_on_2 = 1'b0;
            end else if (avmm_waitrequest_2 ) begin //&& (~refclk_fgt_enabled_2_st2 || reg1_en_refclk_fgt_2==1'b0)) begin
                avmm_write_2 = 1'b1;
                avmm_read_2  =1'b0;
                avmm_address_2 =18'h0001;
                avmm_byteenable_2 =4'b1111;
                avmm_writedata_2 ={1'h1,3'h3,in_coreclk_2_map,24'h000000};
                wait_timer_on_2 = 1'b1;
                wait_timer1_on_2 = 1'b0;
                next_st_2 = ST_WRITE_OFF_2;
            end else begin //if(!avmm_waitrequest_2 && (~refclk_fgt_enabled_2_st2 || reg1_en_refclk_fgt_2==1'b0)) begin 
                avmm_write_2 = 1'b0;
                avmm_byteenable_2 =4'b0000;
                avmm_address_2 =18'h0001;
                next_st_2 = ST_READ_check_OFF_2;
                wait_timer_on_2 = 1'b0;
                wait_timer1_on_2 = 1'b0;
            end       
        end
        ST_WRITE_PAUSE_OFF_2: 
        begin
            avmm_write_2 = 1'b0;
            avmm_byteenable_2 =4'b0000;
            avmm_address_2 =18'h0001;
            wait_timer_on_2 = 1'b0;
            wait_timer1_on_2 = 1'b1;
            if (wait_timer1_timeout_2) 
            begin
                next_st_2 = ST_WRITE_CLEAR_ON_2;            
            end
            else begin
                next_st_2 = ST_WRITE_PAUSE_OFF_2;
            end                              
        end
        
        ST_READ_check_OFF_2: 
        begin           
            wait_timer_on_2 = 1'b0;
            wait_timer1_on_2 = 1'b1;
            if (wait_timer1_timeout_2) 
            begin
                wait_timer_on_2 = 1'b0;
                wait_timer1_on_2 = 1'b0;
                next_st_2 = ST_WRITE_CLEAR_ON_2;            
            end else if ( avmm_waitrequest_2 ) 
            begin
                next_st_2 = ST_READ_OFF_2;
            end else begin 
                next_st_2 = ST_READ_check_OFF_2;
            end
        end
        ST_READ_OFF_2: 
        begin      // Read FW response until get coorect response from FW      
            avmm_write_2 = 1'b0;
            avmm_read_2  =1'b1;
            avmm_address_2 =18'h0002;
            avmm_byteenable_2 =4'b1111;
            wait_timer_on_2 = 1'b1;
            wait_timer1_on_2 = 1'b0;
            if (wait_timer_timeout_2==1'b1)
            begin
                next_st_2 =  ST_READ_PAUSE_OFF_2;
                wait_timer_on_2 = 1'b0;
                wait_timer1_on_2 = 1'b0;
            end else if (!avmm_waitrequest_2 && avmm_readdata_2[30:28]==3'h3 && avmm_readdata_2[31]==1'h1) 
            begin
                next_st_2 =  ST_WRITE_CLEAR_OFF_2;
                refclk_fgt_enabled_2_enable=1'b0; 
            end else 
            begin
                next_st_2 =  ST_READ_OFF_2;
                refclk_fgt_enabled_2_enable=1'b0;        
            end
        end
        ST_READ_PAUSE_OFF_2: 
        begin
            avmm_write_2 = 1'b0;
            avmm_read_2  =1'b0;
            avmm_address_2 =18'h0002;
            avmm_byteenable_2 =4'b1111;
            wait_timer_on_2 = 1'b0;
            wait_timer1_on_2 = 1'b1;
            if (wait_timer1_timeout_2) 
            begin
                next_st_2 = ST_WRITE_CLEAR_ON_2;
            end
            else begin
                next_st_2=ST_READ_PAUSE_OFF_2;
                wait_timer_on_2 = 1'b0;
                wait_timer1_on_2 = 1'b1;
            end
        end
        ST_WRITE_CLEAR_OFF_2: 
        begin // Clear mailbox & move to idle state for user input
            
            if (reg1_en_refclk_fgt_2==1'b1) 
            begin
                avmm_write_2 = 1'b0;
                avmm_read_2  =1'b0;
                avmm_address_2 =18'h0;
                avmm_byteenable_2 =4'b0;
                avmm_writedata_2 =32'h0;
                next_st_2 = ST_WRITE_CLEAR_OFF_2;
            end else 
            begin 
                avmm_write_2 = 1'b0;
                avmm_read_2  =1'b0;
                avmm_address_2 =18'h0;
                avmm_byteenable_2 =4'b0;
                avmm_writedata_2 =32'h0;
                next_st_2 = ST_IDLE_R_2;
            end 
        end
        default:
        begin 
            next_st_2 = ST_IDLE_R_2;
        end         
  endcase
end
 
  assign avmm_waitrequest_2   = m32_waitrequest_2  ;
  assign avmm_readdatavalid_2 = m32_readdatavalid_2 ;
  assign avmm_readdata_2      = m32_readdata_2;
  assign m32_read_2           = avmm_read_2    ;
  assign m32_write_2          = avmm_write_2   ;
  assign m32_address_2        = avmm_address_2 ;
  assign m32_byteenable_2     = avmm_byteenable_2;
  assign m32_writedata_2      = avmm_writedata_2 ;
  
 
 
    
 
    ft_avmm_32to8_bridge 
           #(   .ADDR_WIDTH ( avmm_addr_width ),
                .READ_PIPELINE_ENABLE ( read_pipeline_enable )
            )
      avmm_32to8_inst_2 (
       // AVMM slave Port
       .i_clk                   (  i_common_avmm1_clk_2 ), 
       .i_rst                   (  avmm_reset_2 ),
       
       .i_avmm_s32_addr         ( m32_address_2 ),  
       .i_avmm_s32_wdata        ( m32_writedata_2 ), 
       .i_avmm_s32_write        ( m32_write_2 ), 
       .i_avmm_s32_read         ( m32_read_2 ), 
       .i_avmm_s32_byte_enable  ( m32_byteenable_2 ),
       .o_avmm_s32_readdata     ( m32_readdata_2 ), 
       .o_avmm_s32_waitrequest  ( m32_waitrequest_2 ),
       .o_avmm_s32_readdatavalid( m32_readdatavalid_2 ),
 
       // Master Port
       .o_avmm_m8_addr          ( avmm_m8_addr_2 ),
       .o_avmm_m8_wdata         ( avmm_m8_wdata_2 ), 
       .o_avmm_m8_write         ( avmm_m8_write_2 ), 
       .o_avmm_m8_read          ( avmm_m8_read_2 ), 
       .i_avmm_m8_readdata      ( avmm_m8_readdata_2 ), 
       .i_avmm_m8_waitrequest   ( avmm_m8_waitrequest_2 )   
   );
       
      // instantiate avmm2 core logic
   ctfb_avmm1_soft_logic
                #(  .avmm_interfaces(1),                 //Number of AVMM interfaces required - one for each bonded_lane, PLL, and Master CGB
                    .rcfg_enable (1)                    //Enable/disable reconfig interface 
                 ) avmm1_ena_ins_2t   (
                // AVMM slave interface signals (user)
                 .avmm_clk (i_common_avmm1_clk_2) ,
                 .avmm_reset (avmm_reset_2),
                 .avmm_writedata (avmm_m8_wdata_2), 
                .avmm_address (avmm_m8_addr_2[9:0]), 
                .avmm_write (avmm_m8_write_2),
                .avmm_read (avmm_m8_read_2),
                .avmm_readdata (avmm_m8_readdata_2), 
                .avmm_waitrequest (avmm_m8_waitrequest_2),
                   
                // Signals from AVMM1 building block
                 .pld_avmm1_busy_real             ( pld_avmm1_busy_ref_2),
                 .pld_avmm1_cmdfifo_wr_full_real  ( pld_avmm1_cmdfifo_wr_full_ref_2 ),
                 .pld_avmm1_cmdfifo_wr_pfull_real ( pld_avmm1_cmdfifo_wr_pfull_ref_2 ),
                 .pld_avmm1_readdata_real         ( pld_avmm1_readdata_ref_2 ),
                 .pld_avmm1_readdatavalid_real    ( pld_avmm1_readdatavalid_ref_2),
                 .pld_avmm1_reserved_out_real     ( pld_avmm1_reserved_out_ref_2 ),
                 .pld_chnl_cal_done_real          ( pld_chnl_cal_done_ref_2 ),        
                 .pld_hssi_osc_transfer_en_real   ( pld_hssi_osc_transfer_en_ref_2 ),
                // Signals to AVMM1 building block
                 .pld_avmm1_clk_rowclk_real     (),  //( pld_avmm1_clk_rowclk_ref_2 ),
                 .pld_avmm1_read_real             ( pld_avmm1_read_ref_2),
                 .pld_avmm1_reg_addr_real         ( pld_avmm1_reg_addr_ref_2),
                 .pld_avmm1_request_real          ( pld_avmm1_request_ref_2 ),
                 .pld_avmm1_reserved_in_real      ( pld_avmm1_reserved_in_ref_2 ),
                 .pld_avmm1_write_real            ( pld_avmm1_write_ref_2 ),
                 .pld_avmm1_writedata_real        ( pld_avmm1_writedata_ref_2)
 
                );
 //learning_phase
//learning phase implementation
// chicken bit synchronize
 
assign pld_avmm1_clk_rowclk_ref_2= avmm_clk;

    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) refclk_monitor_2_sync_inst(
        .clk                       (i_common_avmm1_clk_2),
        .reset                     (1'b0),
        .d                         (disable_refclk_monitor_2),
        .q                         (disable_refclk_monitor_2_reg1)
   ); 

 

    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) refclk_monitor_2_core_sync_inst(
        .clk                       (in_coreclk_2),
        .reset                     (1'b0),
        .d                         (disable_refclk_monitor_2),
        .q                         (disable_refclk_monitor_2_coreclk1)
   ); 

 

always @(posedge i_common_avmm1_clk_2)
begin 
   disable_refclk_monitor_2_chickenbit <= (enable_learning_phase_2 && (!disable_refclk_monitor_2_reg1)) ;
end

 
///synchronizer avmm clock to CNOC clock transfer 
  
    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) monitor_2_chickenbit_sync_inst(
        .clk                       (cnoc_clk),
        .reset                     (1'b0),
        .d                         (disable_refclk_monitor_2_chickenbit),
        .q                         (enable_learning_phase_2_ff2_cnoc)
   );  
   
///flag synchronizer avmm clock to in_coreclk_2  clock transfer 

    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) monitor_2_chickenbit_core_sync_inst(
        .clk                       (in_coreclk_2),
        .reset                     (1'b0),
        .d                         (disable_refclk_monitor_2_chickenbit),
        .q                         (enable_learning_phase_2_ff2_core)
   ); 
///count for 480 us in CNOC clock domain 
always@ (posedge cnoc_clk)
begin
if (enable_learning_phase_2_ff2_cnoc) begin 
  if (cnoc_2_count>=learning_count-1) begin 
      cnoc_2_count<=cnoc_2_count;
  end else begin
      cnoc_2_count<=cnoc_2_count+1'b1;
  end
end else begin 
  cnoc_2_count<=0;
end end
 
always@ (posedge cnoc_clk)
begin
if (enable_learning_phase_2_ff2_cnoc) begin 
  if (cnoc_2_count>=learning_count-3) begin 
      start_refclk_monitor_2<=1'b1;
  end else begin
      start_refclk_monitor_2<=1'b0;
  end
end else begin 
  start_refclk_monitor_2<=1'b0;
end end
 
 
/////FF synchronizer

     syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) cnoc_2_count_limit_sync_inst(
        .clk                       (in_coreclk_2),
        .reset                     (1'b0),
        .d                         (start_refclk_monitor_2),
        .q                         (cnoc_2_count_limit2)
   );
 
// divide by 10 counetr 
always@ (posedge in_coreclk_2)
begin
if (enable_learning_phase_2_ff2_core) begin
  if (~cnoc_2_count_limit2) begin
   if (devide_count_10_2==9) begin 
     devide_count_10_2<= 0;     
     end else begin 
       devide_count_10_2<= devide_count_10_2+1'b1;   
    end
end else
 devide_count_10_2<= 0;  
end
end
///muxing for divide by 10
assign refclk_count_en_2= (devide_count_10_2==9) ? 1'b1:1'b0;
 
 //count for 480 us in in_coreclk_2 clock domain devide by 10 counter    
always@ (posedge in_coreclk_2)
begin
if (enable_learning_phase_2_ff2_core) begin 
  if  (cnoc_2_count_limit2) begin 
     refclk_2_count<= refclk_2_count; 
  end  else if (refclk_count_en_2) begin 
     refclk_2_count<= refclk_2_count+1'b1;
  end else 
     refclk_2_count<= refclk_2_count; 
end else
     refclk_2_count<= 0; 
end
 

always@ (posedge in_coreclk_2)
begin
refclk_2_count1<=refclk_2_count;
refclk_2_count2<=refclk_2_count1;
end

always@ (posedge in_coreclk_2)
begin
  store_cnoc_clk_2_limit <= cnoc_2_count_limit2;  
  store_cnoc_clk_2_limit1 <= store_cnoc_clk_2_limit;  
  store_cnoc_clk_2_limit2 <= store_cnoc_clk_2_limit1;  
end

//stored data
always@ (posedge in_coreclk_2)
begin
if (~enable_learning_phase_2_ff2_core) begin 
refclk_2_count_store<='d0;
end else if (store_cnoc_clk_2_limit2) begin 
refclk_2_count_store<=refclk_2_count2;
end else 
refclk_2_count_store<=refclk_2_count_store;
end
 
///monitor logic 
generate
     if(in_coreclk_2_pmap!='d8 || in_coreclk_2_pmap!='d9) begin
//based monitor flag generation 
 
//2 clock cycle delay
always@ (posedge cnoc_clk)
  begin
    start_refclk_monitor_2_enable<=start_refclk_monitor_2;
    start_refclk_monitor_2_enable1<=start_refclk_monitor_2_enable;
    start_refclk_monitor_2_enable2<=start_refclk_monitor_2_enable1;
  end 
 
///count for 48 us in CNOC clock domain 
always@ (posedge cnoc_clk)
begin
if (start_refclk_monitor_2_enable2) begin
  if (d_cnoc_2_count>=detetction_count-1) begin 
      d_cnoc_2_count<=0;   
  end else begin
      d_cnoc_2_count<=d_cnoc_2_count+1'b1;    
  end
  end else begin 
       d_cnoc_2_count<=0;
end end
 
 
//4 cycles(2 cycles are minimum required) of samplable pulse in 25MHz monitoring clock
always@ (posedge cnoc_clk)
begin 
if (start_refclk_monitor_2_enable2) begin
    if (d_cnoc_2_count==detetction_count-'d41)    
       d_store_cnoc_clk_2_limit<= 1'b1;
    else if(d_cnoc_2_count>=detetction_count-'d3)    
       d_store_cnoc_clk_2_limit<= 1'b0;
end else begin
    d_store_cnoc_clk_2_limit<= 1'b0;
end
end
  
// edge detection
 
      syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) d_store_cnoc_clk_2_limit_sync_inst(
        .clk                       (in_coreclk_2),
        .reset                     (1'b0),
        .d                         (d_store_cnoc_clk_2_limit),
        .q                         (d_store_cnoc_clk_2_limit2)
   );
 
      syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) d_store_core_clk_2_limit_sync_inst(
        .clk                       (in_coreclk_2),
        .reset                     (1'b0),
        .d                         (start_refclk_monitor_2_enable),
        .q                         (d_start_refclk_monitor_2_enable2)
   );

always@ (posedge in_coreclk_2)
  begin
    d_store_cnoc_clk_2_limit3<=d_store_cnoc_clk_2_limit2;
  end 
 
 assign d_store_cnoc_clk_2_limit3_neg_edge = ((~d_store_cnoc_clk_2_limit2) && d_store_cnoc_clk_2_limit3) ? 1'b1 : 1'b0; 
 
   ///counter reset based on negedge of d_store_cnoc_clk_2_limit flag. 
always@ (posedge in_coreclk_2)
begin
if (d_start_refclk_monitor_2_enable2) begin
  if  (d_store_cnoc_clk_2_limit3_neg_edge) begin 
     d_refclk_2_count<= 0; 
  end else begin
     d_refclk_2_count<= d_refclk_2_count+1'b1;     
  end
end else begin
  d_refclk_2_count<= 0; 
end
end
 
///store counter based on posedge
always@ (posedge in_coreclk_2)
begin
if (d_start_refclk_monitor_2_enable2) begin
  if (d_store_cnoc_clk_2_limit3_neg_edge)
    d_refclk_2_count_store<=d_refclk_2_count;
end else  
    d_refclk_2_count_store<=0;
end
 
 
always@(posedge i_common_avmm1_clk_2) 
begin  
  refclk_fgt_enabled_2 <= refclk_fgt_enabled_2_enable;
end
//We assume (.78125% error margin)
 
`ifndef ALTERA_RESERVED_QIS
assign max_count_2=refclk_2_count_store+10;
assign min_count_2=refclk_2_count_store-10;
`else
assign max_count_2=refclk_2_count_store+(refclk_2_count_store>>7);
assign min_count_2=refclk_2_count_store-(refclk_2_count_store>>7);
`endif // ifndef ALTERA_RESERVED_QIS  
 
 
    // assign refclk_fgt_enabled_2_st =  ((d_refclk_2_count_store>=min_count_2 && d_refclk_2_count_store<=max_count_2) ? 1'b1 : 1'b0); 
always@ (posedge in_coreclk_2)
begin
 refclk_fgt_enabled_2_sample<=(d_refclk_2_count_store>=min_count_2 && d_refclk_2_count_store<=max_count_2);
 refclk_fgt_enabled_2_st<=refclk_fgt_enabled_2_sample;
end  



always@ (posedge in_coreclk_2)
begin
 if (!d_start_refclk_monitor_2_enable2) 
   in_coreclk_2_div<=0;
 else
   in_coreclk_2_div<=in_coreclk_2_div+1'b1;  
end 

 syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) in_coreclk_2_div_sync_inst(
        .clk                       (cnoc_clk),
        .reset                     (1'b0),
        .d                         (in_coreclk_2_div[1]),
        .q                         (in_coreclk_2_div_sync)
   );

always@ (posedge cnoc_clk)
begin
   in_coreclk_2_div_sync_d1<=in_coreclk_2_div_sync;
end

assign  in_coreclk_2_div_sync_edge = (in_coreclk_2_div_sync & (!in_coreclk_2_div_sync_d1));
 
always@(posedge cnoc_clk)
begin
 if (!start_refclk_monitor_2)
  count_2_cnoc_512<=0;
 else
  count_2_cnoc_512<=count_2_cnoc_512+1'b1;
end

always@(posedge cnoc_clk)
begin
   if (!start_refclk_monitor_2)
     count_2_coreclk<=0;
   else if  (count_2_cnoc_512==511)
     count_2_coreclk<=0;
   else if (in_coreclk_2_div_sync_edge)
     count_2_coreclk<= count_2_coreclk+1'b1;      
end

always@(posedge cnoc_clk)
begin
  if (!start_refclk_monitor_2)
    no_coreclk_2<=0;
  else if (count_2_cnoc_512==511 & count_2_coreclk==0)
    no_coreclk_2<=1;    
end


 syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) no_coreclk_2_div_sync_inst(
        .clk                       (i_common_avmm1_clk_2),
        .reset                     (1'b0),
        .d                         (no_coreclk_2),
        .q                         (no_coreclk_2_sync)
   );

// wait for 48 us to start monitoring
always@ (posedge in_coreclk_2)
begin
if (enable_learning_phase_2_ff2_core) begin 
   if (one_state_2_store==2)
     one_state_2_store<=one_state_2_store;
   else if (one_state_2_store <3 && d_store_cnoc_clk_2_limit3_neg_edge) 
     one_state_2_store<=one_state_2_store+1'b1;
   else if (disable_refclk_monitor_2_coreclk1)
     one_state_2_store<=0; 
end else begin
   one_state_2_store<=0;
end
end        
 
always@ (posedge in_coreclk_2)
begin
   one_state_2_store_en <= (one_state_2_store>= 2);
end
 
       syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) one_state_2_store_sync_inst(
        .clk                       (i_common_avmm1_clk_2),
        .reset                     (1'b0),
        .d                         (one_state_2_store_en),
        .q                         (d_refclk_2_count_store_en)
   );
 

       syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) refclk_fgt_enabled_2_st_sync_inst(
        .clk                       (i_common_avmm1_clk_2),
        .reset                     (1'b0),
        .d                         (refclk_fgt_enabled_2_st),
        .q                         (refclk_fgt_enabled_2_st2)
   );


   
  end else begin 
      assign refclk_fgt_enabled_2_st =  1'b1;
   end
endgenerate

 
  
 
     
//Avmm1 mail box soft logic

  
  logic avmm_write_3;    
  logic avmm_read_3;
  logic avmm_reset_3;
  logic avmm_reset_ip_sync_3;
  logic avmm_reset_ext_3;
  logic avmm_reset_in_sync_3;
  logic [9:0] count_reset_3;
  logic  [17:0] avmm_address_3;
  logic  [3:0]  avmm_byteenable_3;
  logic  [31:0] avmm_writedata_3;
  logic [31:0] avmm_readdata_3;
  logic        avmm_waitrequest_3;
  logic        avmm_readdatavalid_3;
 
  logic [S8_ADDR_WIDTH-1:0]  avmm_m8_addr_3         ;  
  logic [7:0]                avmm_m8_wdata_3        ;  
  logic                      avmm_m8_write_3        ;  
  logic                      avmm_m8_read_3         ;  
  logic [7:0]                avmm_m8_readdata_3     ;  
  logic                      avmm_m8_waitrequest_3  ;  
  logic                           m32_read_3;
  logic                           m32_write_3;
  logic[avmm_data_width-1:0]  m32_writedata_3  ;
  logic[avmm_data_width-1:0]  m32_readdata_3 ;
  logic                           m32_waitrequest_3;
  logic                           m32_readdatavalid_3;
  logic[avmm_addr_width-1:0]  m32_address_3;
  logic [BE_WIDTH-1:0]         m32_byteenable_3;
  logic  [1:0]                en_refclk_fgt_change_3;
  logic  [1:0]                en_refclk_fgt_change_detect_3;
 
  localparam count_width_3 = 17;
  localparam d_count_width_3                      = 15;
  logic enable_learning_phase_3; 
  logic enable_learning_phase_3_ff1_cnoc; 
  logic enable_learning_phase_3_ff2_cnoc;
    
  logic enable_learning_phase_3_ff1_core; 
  logic enable_learning_phase_3_ff2_core; 
  
  
  logic [count_width_3-1:0]  cnoc_3_count=0          ;
  logic [3:0] devide_count_10_3=0;
  logic refclk_count_en_3;
  logic start_refclk_monitor_3=0;
  logic cnoc_3_count_limit2;
  logic [d_count_width_3-1:0]   refclk_3_count=0         ;
  logic [d_count_width_3-1:0]   refclk_3_count_store ;
  logic [d_count_width_3-1:0]   refclk_3_count1 ;
  logic [d_count_width_3-1:0]   refclk_3_count2 ;
  logic store_cnoc_clk_3_limit;
  logic store_cnoc_clk_3_limit1;
  logic store_cnoc_clk_3_limit2;
  //detection & removal phase 
  logic start_refclk_monitor_3_enable ;
  logic start_refclk_monitor_3_enable1 ;
  logic start_refclk_monitor_3_enable2 ;
  logic d_start_refclk_monitor_3_enable2 ;
  logic enable_refclk_watchdog_timer_sync_3;
   
  logic [d_count_width_3-1:0]  d_refclk_3_count=0     ;
  logic [d_count_width_3-2:0]  d_cnoc_3_count  =0       ;
  logic d_cnoc_clk_3_limit;
  logic d_cnoc_clk_3_limit1;
  logic d_cnoc_clk_3_limit2;
  
  logic d_store_cnoc_clk_3_limit;
  logic d_store_cnoc_clk_3_limit1;
  logic d_store_cnoc_clk_3_limit2;
  logic [d_count_width_3-1:0] max_count_3;
  logic [d_count_width_3-1:0] min_count_3;
  logic  refclk_fgt_enabled_3_st;
  logic  refclk_fgt_enabled_3_sample;
  logic  refclk_fgt_enabled_3_st2;
  logic  refclk_fgt_enabled_3_enable ;
  logic disable_refclk_monitor_3_reg;
  logic disable_refclk_monitor_3_reg1;
  logic disable_refclk_monitor_3_chickenbit;
  logic [d_count_width_3-1:0]   d_refclk_3_count_store     ;
  logic                          d_refclk_3_count_store_en  ;
  logic                          d_refclk_3_count_store_en1 ;
  logic                          d_refclk_3_count_store_en2 ;
  logic  [1:0]                   one_state_3_store=0;
  logic                          one_state_3_store_en=0;
  logic                          d_store_cnoc_clk_3_limit3;
  logic                          d_store_cnoc_clk_3_limit3_neg_edge;
  logic                          disable_refclk_monitor_3_coreclk;
  logic                          disable_refclk_monitor_3_coreclk1;
  logic                          refclk_count3_data=1'b0;
  logic                          refclk_count3_data_reg1;
  logic                          reg_refclk_fgt_always_active_3;
  logic                          wait_timer_on_3=0;
  logic                          wait_timer1_on_3=0;
  logic                          wait_timer_on_in_3=0;
  logic                          wait_timer1_on_in_3=0;
  logic                          wait_timer_timeout_3; 
  logic                          wait_timer1_timeout_3; 
  logic [timeout_cnt_width-1:0]  timeout_timer_cnt_3=0;
  logic [timeout_cnt1_width-1:0] timeout_timer1_cnt_3=0;
  logic [1:0]                    in_coreclk_3_div=0;
  logic                          in_coreclk_3_div_sync;
  logic                          in_coreclk_3_div_sync_d1;
  logic                          in_coreclk_3_div_sync_edge;
  logic [8:0]                    count_3_cnoc_512=0;
  logic [8:0]                    count_3_coreclk=0;
  logic                          no_coreclk_3;
  logic                          no_coreclk_3_sync;


  
    
     syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (1)
   ) avmm_reset_ip_sync_3_sync_inst(
        .clk                       (i_common_avmm1_clk_3),
        .reset                     (avmm_reset_ip),
        .d                         (1'b0),
        .q                         (avmm_reset_ip_sync_3)
   );
  
    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) avmm_reset_in_sync_3_inst0(
        .clk                       (i_common_avmm1_clk_3),
        .reset                     (1'b0),
        .d                         (avmm_reset_in),
        .q                         (avmm_reset_in_sync_3)
   );
 
 
      syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) enable_refclk_watchdog_timer_3_inst0(
        .clk                       (i_common_avmm1_clk_3),
        .reset                     (1'b0),
        .d                         (enable_refclk_watchdog_timer_3),
        .q                         (enable_refclk_watchdog_timer_sync_3)
   );
  

  
  always@ (posedge i_common_avmm1_clk_3 )
    begin
      if (avmm_reset_ip_sync_3)
        count_reset_3<=10'd0; 
      else if (count_reset_3==10'd512)
        count_reset_3<=count_reset_3;
      else
        count_reset_3<=count_reset_3+1'b1;
    end
 assign avmm_reset_ext_3= (count_reset_3>=10'd512) ? 0 : 1;
 
   always@ (posedge i_common_avmm1_clk_3 )
   begin
     avmm_reset_3<=avmm_reset_ext_3 | avmm_reset_in_sync_3;
   end

  always @(posedge i_common_avmm1_clk_3 ) 
  begin
    wait_timer_on_in_3 <= wait_timer_on_3;
    wait_timer1_on_in_3 <= wait_timer1_on_3;
  end
  
 always @(posedge i_common_avmm1_clk_3 ) 
 begin
    if(wait_timer_on_in_3 & enable_refclk_watchdog_timer_sync_3)     
    timeout_timer_cnt_3 <= timeout_timer_cnt_3 + 1'b1;        
    else
    timeout_timer_cnt_3 <= {timeout_cnt_width{1'b0}};        
 end
  
 always @(posedge i_common_avmm1_clk_3 ) 
 begin
    if(wait_timer1_on_in_3 & enable_refclk_watchdog_timer_sync_3)    
    timeout_timer1_cnt_3 <= timeout_timer1_cnt_3 + 1'b1;      
    else
    timeout_timer1_cnt_3 <= {timeout_cnt1_width{1'b0}};      
 end
  
 always @(posedge i_common_avmm1_clk_3 ) 
 begin
    wait_timer_timeout_3 <= (timeout_timer_cnt_3 >= timeout_cnt); 
    wait_timer1_timeout_3 <= (timeout_timer1_cnt_3 >= timeout_cnt1); 
 end

     syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) refclk_watchdog_timeout_3_sync_inst(
        .clk                       (i_common_avmm1_clk_3),
        .reset                     (1'b0),
        .d                         (wait_timer_timeout_3),
        .q                         (refclk_watchdog_timeout_3)
   );

  /// start learning once refclk persent.
  
 always@(posedge in_coreclk_3 ) 
    begin
      if  (refclk_count3_data==1'b1)
        refclk_count3_data<=refclk_count3_data;
      else 
        refclk_count3_data<=refclk_count3_data+1'b1;
    end

     syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) refclk_count3_data_sync_inst(
        .clk                       (i_common_avmm1_clk_3),
        .reset                     (1'b0),
        .d                         (refclk_count3_data),
        .q                         (refclk_count3_data_reg1)
   );

    
//clkrx main: avmm state machine runs with avmm clock 
// state transition with avmm clock
  
 localparam ST_IDLE_R_3=4'd0;
 localparam ST_WRITE_ON_3=4'd1;
 localparam ST_WRITE_PAUSE_ON_3=4'd2;
 localparam ST_READ_check_ON_3=4'd3 ;
 localparam ST_READ_ON_3=4'd4;
 localparam ST_READ_PAUSE_ON_3=4'd5;
 localparam ST_WRITE_CLEAR_ON_3=4'd6;
 localparam ST_WRITE_OFF_3=4'd7;
 localparam ST_WRITE_PAUSE_OFF_3=4'd8;
 localparam ST_READ_check_OFF_3=4'd9;
 localparam ST_READ_OFF_3=4'd10;
 localparam ST_READ_PAUSE_OFF_3=4'd11;
 localparam ST_WRITE_CLEAR_OFF_3=4'd12;
 localparam ST_CLEAR_OFF_3=4'd13;
 reg [3:0] cur_st_3=4'd0 /* synthesis preserve dont_replicate */;
 reg [3:0] next_st_3=4'd0 /* synthesis preserve dont_replicate */; 
 
 
 
 
  always @(posedge i_common_avmm1_clk_3 ) begin
   if(avmm_reset_3) begin
      cur_st_3     <= ST_IDLE_R_3;
   end else begin
       cur_st_3     <= next_st_3;
    end
 end
 
// input synchronization in avmm clock domain 
logic reg_en_refclk_fgt_3;
logic reg1_en_refclk_fgt_3;


    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) en_refclk_fgt_3_sync_inst(
        .clk                       (i_common_avmm1_clk_3),
        .reset                     (1'b0),
        .d                         (en_refclk_fgt_3),
        .q                         (reg1_en_refclk_fgt_3)
   ); 
     

//avmm state machine combo logic
//always_comb  
`ifndef ALTERA_RESERVED_QIS
always@(*)
`else
always_comb 
`endif // ifndef ALTERA_RESERVED_QIS 

begin

    avmm_write_3 = 1'b0;
    avmm_read_3  =1'b0;
    avmm_address_3 =18'h0;
    avmm_byteenable_3 =4'b0;
    avmm_writedata_3 =32'h0;
    refclk_fgt_enabled_3_enable=1'b0;
    enable_learning_phase_3=1'b0;
    wait_timer_on_3 = 1'b0;
    wait_timer1_on_3 = 1'b0;
    next_st_3 = ST_IDLE_R_3;
    case (cur_st_3) 
        ST_IDLE_R_3 : 
        begin //idle state to initialize avmm read and write 
            avmm_write_3 = 1'b0;
            avmm_read_3  =1'b0;
            avmm_address_3 =18'h0;
            avmm_byteenable_3 =4'b0;
            enable_learning_phase_3=1'b0;
            avmm_writedata_3 =32'h0; 
            wait_timer_on_3 = 1'b0;
            wait_timer1_on_3 = 1'b0;
            if ((refclk_fgt_always_active_3==1) && (refclk_count3_data_reg1==1'b1))
                next_st_3 =   ST_WRITE_CLEAR_ON_3;
            else if (reg1_en_refclk_fgt_3==1'b1)
                next_st_3 =   ST_WRITE_ON_3;
            else
                next_st_3 =   ST_IDLE_R_3;                         
        end
        ST_WRITE_ON_3: 
        begin // mailbox write for stable clk 
            wait_timer_on_3 = 1'b1;
            wait_timer1_on_3 = 1'b0;
            if (wait_timer_timeout_3 == 1'b1) begin
                next_st_3 =ST_WRITE_PAUSE_ON_3;
                wait_timer_on_3 = 1'b0;
            end else if (avmm_waitrequest_3 ) 
            begin //  mailbox write for stable clk, loop in ST_WRITE_ON_3 until avmm_waitrequest went low
                avmm_write_3 = 1'b1;
                avmm_read_3  =1'b0;
                avmm_address_3 =18'h0001;
                avmm_byteenable_3 =4'b1111;
                avmm_writedata_3 ={1'h1,3'h2,in_coreclk_3_map,24'h000000};
                enable_learning_phase_3=1'b0;
                wait_timer_on_3 = 1'b1;
                wait_timer1_on_3 = 1'b0;
                next_st_3 =ST_WRITE_ON_3;
            end else if (!avmm_waitrequest_3 ) 
            begin //Move to ST_READ_check_ON_3 once get avmm_waitrequest low
                avmm_write_3 = 1'b0;
                avmm_byteenable_3 =4'b0000;
                avmm_address_3 =18'h0001;
                enable_learning_phase_3=1'b0;
                next_st_3 = ST_READ_check_ON_3;
                wait_timer_on_3  = 1'b0;
                wait_timer1_on_3 = 1'b0;
            end else 
            begin
                next_st_3 = ST_IDLE_R_3;     
                wait_timer_on_3  = 1'b0;
                wait_timer1_on_3 = 1'b0;
            end
        end
        ST_WRITE_PAUSE_ON_3: 
        begin
            avmm_write_3 = 1'b0;
            avmm_byteenable_3 =4'b0000;
            avmm_address_3 =18'h0001;
            enable_learning_phase_3=1'b0;
            wait_timer_on_3 = 1'b0;
            wait_timer1_on_3 = 1'b1;
            if(wait_timer1_timeout_3 == 1'b1) begin
                next_st_3 = ST_IDLE_R_3;     
                wait_timer1_on_3 = 1'b0;
            end
            else begin
                next_st_3 = ST_WRITE_PAUSE_ON_3;
            end            
        end
        ST_READ_check_ON_3: 
        begin
            enable_learning_phase_3=1'b0;
            wait_timer_on_3 = 1'b0;
            wait_timer1_on_3 = 1'b1;
            if(wait_timer1_timeout_3 == 1'b1) begin
                wait_timer1_on_3 = 1'b0;
                next_st_3 = ST_IDLE_R_3;
            end else if (avmm_waitrequest_3) 
            begin //Move to to ST_READ_ON_3 once avmm_waitrequest go high
                next_st_3 = ST_READ_ON_3;
            end else begin 
                next_st_3 = ST_READ_check_ON_3;
            end
        end
        ST_READ_ON_3: 
        begin
            enable_learning_phase_3=1'b0;
            avmm_write_3 = 1'b0;
            avmm_read_3  =1'b1;
            avmm_address_3 =18'h0002;
            avmm_byteenable_3 =4'b1111;
            //avmm_time_out_enable_3=1'b1;
            wait_timer_on_3 = 1'b1;
            wait_timer1_on_3 = 1'b0;
            if(wait_timer_timeout_3 == 1'b1)
            begin
                next_st_3=ST_READ_PAUSE_ON_3;
                wait_timer_on_3 = 1'b0;
                wait_timer1_on_3 = 1'b0;
            end else if (!avmm_waitrequest_3 && avmm_readdata_3[30:28]==3'h2 && avmm_readdata_3[31]==1'h1) 
            begin  // check FW read once get valid data move to state ST_WRITE_CLEAR_ON & generate flag for enable learning phase & assert refclk_fgt_enabled to high for user
                next_st_3 = ST_WRITE_CLEAR_ON_3;
                enable_learning_phase_3=1'b1;
                refclk_fgt_enabled_3_enable=1'b1;
                wait_timer_on_3 = 1'b0;
                wait_timer1_on_3 = 1'b0;
            end else begin
                refclk_fgt_enabled_3_enable=1'b0;
                next_st_3=ST_READ_ON_3;
            end            
        end
        ST_READ_PAUSE_ON_3: 
        begin             
            avmm_write_3 = 1'b0;
            avmm_read_3  =1'b0;
            avmm_byteenable_3 =4'b0000;
            avmm_address_3 =18'h0002;
            enable_learning_phase_3=1'b0;
            wait_timer_on_3 = 1'b0;
            wait_timer1_on_3 = 1'b1;
            refclk_fgt_enabled_3_enable=1'b0;
            if(wait_timer1_timeout_3 == 1'b1) begin
                next_st_3 = ST_IDLE_R_3;     
                wait_timer1_on_3 = 1'b0;
            end
            else begin
                next_st_3=ST_READ_PAUSE_ON_3;
            end
        end
        ST_WRITE_CLEAR_ON_3:             ///Need to clear the register as per new FW implementation  discussion needed with sidhartha 
        begin
            avmm_write_3 = 1'b0;
            avmm_read_3  =1'b0;
            avmm_address_3 =18'h0;
            avmm_byteenable_3 =4'b0;
            avmm_writedata_3 =32'h0;
            wait_timer_on_3 = 1'b0;
            wait_timer1_on_3 = 1'b0;
            enable_learning_phase_3=1'b1; 
            refclk_fgt_enabled_3_enable=1'b1;
            if (((~refclk_fgt_enabled_3_st2 &&  d_refclk_3_count_store_en && (!disable_refclk_monitor_3_reg1))) || ((reg1_en_refclk_fgt_3==1'b0) &&(refclk_fgt_always_active_3==0)) || (no_coreclk_3_sync && (!disable_refclk_monitor_3_reg1)))             
            begin // wait for monitoring logic to confirm if clock not in range or user indication for refclk not active
                next_st_3 = ST_WRITE_OFF_3;
            end else if ((~refclk_fgt_enabled_3_st2)  && (refclk_fgt_always_active_3==1) && (d_refclk_3_count_store_en) && (!disable_refclk_monitor_3_reg1) || (no_coreclk_3_sync && (!disable_refclk_monitor_3_reg1)))
                next_st_3 = ST_WRITE_OFF_3;
            else
                next_st_3 = ST_WRITE_CLEAR_ON_3;
        end 
        ST_WRITE_OFF_3: 
        begin // if monitoring logic to confirm clock not in range mailbox send command to off CML buffer  
            wait_timer_on_3 = 1'b1;
            wait_timer1_on_3 = 1'b0;
            enable_learning_phase_3=1'b0; 
            if (wait_timer_timeout_3)             
            begin
                next_st_3 = ST_WRITE_PAUSE_OFF_3;
                wait_timer_on_3 = 1'b0;
                wait_timer1_on_3 = 1'b0;
            end else if (avmm_waitrequest_3 ) begin //&& (~refclk_fgt_enabled_3_st2 || reg1_en_refclk_fgt_3==1'b0)) begin
                avmm_write_3 = 1'b1;
                avmm_read_3  =1'b0;
                avmm_address_3 =18'h0001;
                avmm_byteenable_3 =4'b1111;
                avmm_writedata_3 ={1'h1,3'h3,in_coreclk_3_map,24'h000000};
                wait_timer_on_3 = 1'b1;
                wait_timer1_on_3 = 1'b0;
                next_st_3 = ST_WRITE_OFF_3;
            end else begin //if(!avmm_waitrequest_3 && (~refclk_fgt_enabled_3_st2 || reg1_en_refclk_fgt_3==1'b0)) begin 
                avmm_write_3 = 1'b0;
                avmm_byteenable_3 =4'b0000;
                avmm_address_3 =18'h0001;
                next_st_3 = ST_READ_check_OFF_3;
                wait_timer_on_3 = 1'b0;
                wait_timer1_on_3 = 1'b0;
            end       
        end
        ST_WRITE_PAUSE_OFF_3: 
        begin
            avmm_write_3 = 1'b0;
            avmm_byteenable_3 =4'b0000;
            avmm_address_3 =18'h0001;
            wait_timer_on_3 = 1'b0;
            wait_timer1_on_3 = 1'b1;
            if (wait_timer1_timeout_3) 
            begin
                next_st_3 = ST_WRITE_CLEAR_ON_3;            
            end
            else begin
                next_st_3 = ST_WRITE_PAUSE_OFF_3;
            end                              
        end
        
        ST_READ_check_OFF_3: 
        begin           
            wait_timer_on_3 = 1'b0;
            wait_timer1_on_3 = 1'b1;
            if (wait_timer1_timeout_3) 
            begin
                wait_timer_on_3 = 1'b0;
                wait_timer1_on_3 = 1'b0;
                next_st_3 = ST_WRITE_CLEAR_ON_3;            
            end else if ( avmm_waitrequest_3 ) 
            begin
                next_st_3 = ST_READ_OFF_3;
            end else begin 
                next_st_3 = ST_READ_check_OFF_3;
            end
        end
        ST_READ_OFF_3: 
        begin      // Read FW response until get coorect response from FW      
            avmm_write_3 = 1'b0;
            avmm_read_3  =1'b1;
            avmm_address_3 =18'h0002;
            avmm_byteenable_3 =4'b1111;
            wait_timer_on_3 = 1'b1;
            wait_timer1_on_3 = 1'b0;
            if (wait_timer_timeout_3==1'b1)
            begin
                next_st_3 =  ST_READ_PAUSE_OFF_3;
                wait_timer_on_3 = 1'b0;
                wait_timer1_on_3 = 1'b0;
            end else if (!avmm_waitrequest_3 && avmm_readdata_3[30:28]==3'h3 && avmm_readdata_3[31]==1'h1) 
            begin
                next_st_3 =  ST_WRITE_CLEAR_OFF_3;
                refclk_fgt_enabled_3_enable=1'b0; 
            end else 
            begin
                next_st_3 =  ST_READ_OFF_3;
                refclk_fgt_enabled_3_enable=1'b0;        
            end
        end
        ST_READ_PAUSE_OFF_3: 
        begin
            avmm_write_3 = 1'b0;
            avmm_read_3  =1'b0;
            avmm_address_3 =18'h0002;
            avmm_byteenable_3 =4'b1111;
            wait_timer_on_3 = 1'b0;
            wait_timer1_on_3 = 1'b1;
            if (wait_timer1_timeout_3) 
            begin
                next_st_3 = ST_WRITE_CLEAR_ON_3;
            end
            else begin
                next_st_3=ST_READ_PAUSE_OFF_3;
                wait_timer_on_3 = 1'b0;
                wait_timer1_on_3 = 1'b1;
            end
        end
        ST_WRITE_CLEAR_OFF_3: 
        begin // Clear mailbox & move to idle state for user input
            
            if (reg1_en_refclk_fgt_3==1'b1) 
            begin
                avmm_write_3 = 1'b0;
                avmm_read_3  =1'b0;
                avmm_address_3 =18'h0;
                avmm_byteenable_3 =4'b0;
                avmm_writedata_3 =32'h0;
                next_st_3 = ST_WRITE_CLEAR_OFF_3;
            end else 
            begin 
                avmm_write_3 = 1'b0;
                avmm_read_3  =1'b0;
                avmm_address_3 =18'h0;
                avmm_byteenable_3 =4'b0;
                avmm_writedata_3 =32'h0;
                next_st_3 = ST_IDLE_R_3;
            end 
        end
        default:
        begin 
            next_st_3 = ST_IDLE_R_3;
        end         
  endcase
end
 
  assign avmm_waitrequest_3   = m32_waitrequest_3  ;
  assign avmm_readdatavalid_3 = m32_readdatavalid_3 ;
  assign avmm_readdata_3      = m32_readdata_3;
  assign m32_read_3           = avmm_read_3    ;
  assign m32_write_3          = avmm_write_3   ;
  assign m32_address_3        = avmm_address_3 ;
  assign m32_byteenable_3     = avmm_byteenable_3;
  assign m32_writedata_3      = avmm_writedata_3 ;
  
 
 
    
 
    ft_avmm_32to8_bridge 
           #(   .ADDR_WIDTH ( avmm_addr_width ),
                .READ_PIPELINE_ENABLE ( read_pipeline_enable )
            )
      avmm_32to8_inst_3 (
       // AVMM slave Port
       .i_clk                   (  i_common_avmm1_clk_3 ), 
       .i_rst                   (  avmm_reset_3 ),
       
       .i_avmm_s32_addr         ( m32_address_3 ),  
       .i_avmm_s32_wdata        ( m32_writedata_3 ), 
       .i_avmm_s32_write        ( m32_write_3 ), 
       .i_avmm_s32_read         ( m32_read_3 ), 
       .i_avmm_s32_byte_enable  ( m32_byteenable_3 ),
       .o_avmm_s32_readdata     ( m32_readdata_3 ), 
       .o_avmm_s32_waitrequest  ( m32_waitrequest_3 ),
       .o_avmm_s32_readdatavalid( m32_readdatavalid_3 ),
 
       // Master Port
       .o_avmm_m8_addr          ( avmm_m8_addr_3 ),
       .o_avmm_m8_wdata         ( avmm_m8_wdata_3 ), 
       .o_avmm_m8_write         ( avmm_m8_write_3 ), 
       .o_avmm_m8_read          ( avmm_m8_read_3 ), 
       .i_avmm_m8_readdata      ( avmm_m8_readdata_3 ), 
       .i_avmm_m8_waitrequest   ( avmm_m8_waitrequest_3 )   
   );
       
      // instantiate avmm2 core logic
   ctfb_avmm1_soft_logic
                #(  .avmm_interfaces(1),                 //Number of AVMM interfaces required - one for each bonded_lane, PLL, and Master CGB
                    .rcfg_enable (1)                    //Enable/disable reconfig interface 
                 ) avmm1_ena_ins_3t   (
                // AVMM slave interface signals (user)
                 .avmm_clk (i_common_avmm1_clk_3) ,
                 .avmm_reset (avmm_reset_3),
                 .avmm_writedata (avmm_m8_wdata_3), 
                .avmm_address (avmm_m8_addr_3[9:0]), 
                .avmm_write (avmm_m8_write_3),
                .avmm_read (avmm_m8_read_3),
                .avmm_readdata (avmm_m8_readdata_3), 
                .avmm_waitrequest (avmm_m8_waitrequest_3),
                   
                // Signals from AVMM1 building block
                 .pld_avmm1_busy_real             ( pld_avmm1_busy_ref_3),
                 .pld_avmm1_cmdfifo_wr_full_real  ( pld_avmm1_cmdfifo_wr_full_ref_3 ),
                 .pld_avmm1_cmdfifo_wr_pfull_real ( pld_avmm1_cmdfifo_wr_pfull_ref_3 ),
                 .pld_avmm1_readdata_real         ( pld_avmm1_readdata_ref_3 ),
                 .pld_avmm1_readdatavalid_real    ( pld_avmm1_readdatavalid_ref_3),
                 .pld_avmm1_reserved_out_real     ( pld_avmm1_reserved_out_ref_3 ),
                 .pld_chnl_cal_done_real          ( pld_chnl_cal_done_ref_3 ),        
                 .pld_hssi_osc_transfer_en_real   ( pld_hssi_osc_transfer_en_ref_3 ),
                // Signals to AVMM1 building block
                 .pld_avmm1_clk_rowclk_real     (),  //( pld_avmm1_clk_rowclk_ref_3 ),
                 .pld_avmm1_read_real             ( pld_avmm1_read_ref_3),
                 .pld_avmm1_reg_addr_real         ( pld_avmm1_reg_addr_ref_3),
                 .pld_avmm1_request_real          ( pld_avmm1_request_ref_3 ),
                 .pld_avmm1_reserved_in_real      ( pld_avmm1_reserved_in_ref_3 ),
                 .pld_avmm1_write_real            ( pld_avmm1_write_ref_3 ),
                 .pld_avmm1_writedata_real        ( pld_avmm1_writedata_ref_3)
 
                );
 //learning_phase
//learning phase implementation
// chicken bit synchronize
 
assign pld_avmm1_clk_rowclk_ref_3= avmm_clk;

    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) refclk_monitor_3_sync_inst(
        .clk                       (i_common_avmm1_clk_3),
        .reset                     (1'b0),
        .d                         (disable_refclk_monitor_3),
        .q                         (disable_refclk_monitor_3_reg1)
   ); 

 

    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) refclk_monitor_3_core_sync_inst(
        .clk                       (in_coreclk_3),
        .reset                     (1'b0),
        .d                         (disable_refclk_monitor_3),
        .q                         (disable_refclk_monitor_3_coreclk1)
   ); 

 

always @(posedge i_common_avmm1_clk_3)
begin 
   disable_refclk_monitor_3_chickenbit <= (enable_learning_phase_3 && (!disable_refclk_monitor_3_reg1)) ;
end

 
///synchronizer avmm clock to CNOC clock transfer 
  
    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) monitor_3_chickenbit_sync_inst(
        .clk                       (cnoc_clk),
        .reset                     (1'b0),
        .d                         (disable_refclk_monitor_3_chickenbit),
        .q                         (enable_learning_phase_3_ff2_cnoc)
   );  
   
///flag synchronizer avmm clock to in_coreclk_3  clock transfer 

    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) monitor_3_chickenbit_core_sync_inst(
        .clk                       (in_coreclk_3),
        .reset                     (1'b0),
        .d                         (disable_refclk_monitor_3_chickenbit),
        .q                         (enable_learning_phase_3_ff2_core)
   ); 
///count for 480 us in CNOC clock domain 
always@ (posedge cnoc_clk)
begin
if (enable_learning_phase_3_ff2_cnoc) begin 
  if (cnoc_3_count>=learning_count-1) begin 
      cnoc_3_count<=cnoc_3_count;
  end else begin
      cnoc_3_count<=cnoc_3_count+1'b1;
  end
end else begin 
  cnoc_3_count<=0;
end end
 
always@ (posedge cnoc_clk)
begin
if (enable_learning_phase_3_ff2_cnoc) begin 
  if (cnoc_3_count>=learning_count-3) begin 
      start_refclk_monitor_3<=1'b1;
  end else begin
      start_refclk_monitor_3<=1'b0;
  end
end else begin 
  start_refclk_monitor_3<=1'b0;
end end
 
 
/////FF synchronizer

     syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) cnoc_3_count_limit_sync_inst(
        .clk                       (in_coreclk_3),
        .reset                     (1'b0),
        .d                         (start_refclk_monitor_3),
        .q                         (cnoc_3_count_limit2)
   );
 
// divide by 10 counetr 
always@ (posedge in_coreclk_3)
begin
if (enable_learning_phase_3_ff2_core) begin
  if (~cnoc_3_count_limit2) begin
   if (devide_count_10_3==9) begin 
     devide_count_10_3<= 0;     
     end else begin 
       devide_count_10_3<= devide_count_10_3+1'b1;   
    end
end else
 devide_count_10_3<= 0;  
end
end
///muxing for divide by 10
assign refclk_count_en_3= (devide_count_10_3==9) ? 1'b1:1'b0;
 
 //count for 480 us in in_coreclk_3 clock domain devide by 10 counter    
always@ (posedge in_coreclk_3)
begin
if (enable_learning_phase_3_ff2_core) begin 
  if  (cnoc_3_count_limit2) begin 
     refclk_3_count<= refclk_3_count; 
  end  else if (refclk_count_en_3) begin 
     refclk_3_count<= refclk_3_count+1'b1;
  end else 
     refclk_3_count<= refclk_3_count; 
end else
     refclk_3_count<= 0; 
end
 

always@ (posedge in_coreclk_3)
begin
refclk_3_count1<=refclk_3_count;
refclk_3_count2<=refclk_3_count1;
end

always@ (posedge in_coreclk_3)
begin
  store_cnoc_clk_3_limit <= cnoc_3_count_limit2;  
  store_cnoc_clk_3_limit1 <= store_cnoc_clk_3_limit;  
  store_cnoc_clk_3_limit2 <= store_cnoc_clk_3_limit1;  
end

//stored data
always@ (posedge in_coreclk_3)
begin
if (~enable_learning_phase_3_ff2_core) begin 
refclk_3_count_store<='d0;
end else if (store_cnoc_clk_3_limit2) begin 
refclk_3_count_store<=refclk_3_count2;
end else 
refclk_3_count_store<=refclk_3_count_store;
end
 
///monitor logic 
generate
     if(in_coreclk_3_pmap!='d8 || in_coreclk_3_pmap!='d9) begin
//based monitor flag generation 
 
//2 clock cycle delay
always@ (posedge cnoc_clk)
  begin
    start_refclk_monitor_3_enable<=start_refclk_monitor_3;
    start_refclk_monitor_3_enable1<=start_refclk_monitor_3_enable;
    start_refclk_monitor_3_enable2<=start_refclk_monitor_3_enable1;
  end 
 
///count for 48 us in CNOC clock domain 
always@ (posedge cnoc_clk)
begin
if (start_refclk_monitor_3_enable2) begin
  if (d_cnoc_3_count>=detetction_count-1) begin 
      d_cnoc_3_count<=0;   
  end else begin
      d_cnoc_3_count<=d_cnoc_3_count+1'b1;    
  end
  end else begin 
       d_cnoc_3_count<=0;
end end
 
 
//4 cycles(2 cycles are minimum required) of samplable pulse in 25MHz monitoring clock
always@ (posedge cnoc_clk)
begin 
if (start_refclk_monitor_3_enable2) begin
    if (d_cnoc_3_count==detetction_count-'d41)    
       d_store_cnoc_clk_3_limit<= 1'b1;
    else if(d_cnoc_3_count>=detetction_count-'d3)    
       d_store_cnoc_clk_3_limit<= 1'b0;
end else begin
    d_store_cnoc_clk_3_limit<= 1'b0;
end
end
  
// edge detection
 
      syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) d_store_cnoc_clk_3_limit_sync_inst(
        .clk                       (in_coreclk_3),
        .reset                     (1'b0),
        .d                         (d_store_cnoc_clk_3_limit),
        .q                         (d_store_cnoc_clk_3_limit2)
   );
 
      syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) d_store_core_clk_3_limit_sync_inst(
        .clk                       (in_coreclk_3),
        .reset                     (1'b0),
        .d                         (start_refclk_monitor_3_enable),
        .q                         (d_start_refclk_monitor_3_enable2)
   );

always@ (posedge in_coreclk_3)
  begin
    d_store_cnoc_clk_3_limit3<=d_store_cnoc_clk_3_limit2;
  end 
 
 assign d_store_cnoc_clk_3_limit3_neg_edge = ((~d_store_cnoc_clk_3_limit2) && d_store_cnoc_clk_3_limit3) ? 1'b1 : 1'b0; 
 
   ///counter reset based on negedge of d_store_cnoc_clk_3_limit flag. 
always@ (posedge in_coreclk_3)
begin
if (d_start_refclk_monitor_3_enable2) begin
  if  (d_store_cnoc_clk_3_limit3_neg_edge) begin 
     d_refclk_3_count<= 0; 
  end else begin
     d_refclk_3_count<= d_refclk_3_count+1'b1;     
  end
end else begin
  d_refclk_3_count<= 0; 
end
end
 
///store counter based on posedge
always@ (posedge in_coreclk_3)
begin
if (d_start_refclk_monitor_3_enable2) begin
  if (d_store_cnoc_clk_3_limit3_neg_edge)
    d_refclk_3_count_store<=d_refclk_3_count;
end else  
    d_refclk_3_count_store<=0;
end
 
 
always@(posedge i_common_avmm1_clk_3) 
begin  
  refclk_fgt_enabled_3 <= refclk_fgt_enabled_3_enable;
end
//We assume (.78125% error margin)
 
`ifndef ALTERA_RESERVED_QIS
assign max_count_3=refclk_3_count_store+10;
assign min_count_3=refclk_3_count_store-10;
`else
assign max_count_3=refclk_3_count_store+(refclk_3_count_store>>7);
assign min_count_3=refclk_3_count_store-(refclk_3_count_store>>7);
`endif // ifndef ALTERA_RESERVED_QIS  
 
 
    // assign refclk_fgt_enabled_3_st =  ((d_refclk_3_count_store>=min_count_3 && d_refclk_3_count_store<=max_count_3) ? 1'b1 : 1'b0); 
always@ (posedge in_coreclk_3)
begin
 refclk_fgt_enabled_3_sample<=(d_refclk_3_count_store>=min_count_3 && d_refclk_3_count_store<=max_count_3);
 refclk_fgt_enabled_3_st<=refclk_fgt_enabled_3_sample;
end  



always@ (posedge in_coreclk_3)
begin
 if (!d_start_refclk_monitor_3_enable2) 
   in_coreclk_3_div<=0;
 else
   in_coreclk_3_div<=in_coreclk_3_div+1'b1;  
end 

 syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) in_coreclk_3_div_sync_inst(
        .clk                       (cnoc_clk),
        .reset                     (1'b0),
        .d                         (in_coreclk_3_div[1]),
        .q                         (in_coreclk_3_div_sync)
   );

always@ (posedge cnoc_clk)
begin
   in_coreclk_3_div_sync_d1<=in_coreclk_3_div_sync;
end

assign  in_coreclk_3_div_sync_edge = (in_coreclk_3_div_sync & (!in_coreclk_3_div_sync_d1));
 
always@(posedge cnoc_clk)
begin
 if (!start_refclk_monitor_3)
  count_3_cnoc_512<=0;
 else
  count_3_cnoc_512<=count_3_cnoc_512+1'b1;
end

always@(posedge cnoc_clk)
begin
   if (!start_refclk_monitor_3)
     count_3_coreclk<=0;
   else if  (count_3_cnoc_512==511)
     count_3_coreclk<=0;
   else if (in_coreclk_3_div_sync_edge)
     count_3_coreclk<= count_3_coreclk+1'b1;      
end

always@(posedge cnoc_clk)
begin
  if (!start_refclk_monitor_3)
    no_coreclk_3<=0;
  else if (count_3_cnoc_512==511 & count_3_coreclk==0)
    no_coreclk_3<=1;    
end


 syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) no_coreclk_3_div_sync_inst(
        .clk                       (i_common_avmm1_clk_3),
        .reset                     (1'b0),
        .d                         (no_coreclk_3),
        .q                         (no_coreclk_3_sync)
   );

// wait for 48 us to start monitoring
always@ (posedge in_coreclk_3)
begin
if (enable_learning_phase_3_ff2_core) begin 
   if (one_state_3_store==2)
     one_state_3_store<=one_state_3_store;
   else if (one_state_3_store <3 && d_store_cnoc_clk_3_limit3_neg_edge) 
     one_state_3_store<=one_state_3_store+1'b1;
   else if (disable_refclk_monitor_3_coreclk1)
     one_state_3_store<=0; 
end else begin
   one_state_3_store<=0;
end
end        
 
always@ (posedge in_coreclk_3)
begin
   one_state_3_store_en <= (one_state_3_store>= 2);
end
 
       syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) one_state_3_store_sync_inst(
        .clk                       (i_common_avmm1_clk_3),
        .reset                     (1'b0),
        .d                         (one_state_3_store_en),
        .q                         (d_refclk_3_count_store_en)
   );
 

       syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) refclk_fgt_enabled_3_st_sync_inst(
        .clk                       (i_common_avmm1_clk_3),
        .reset                     (1'b0),
        .d                         (refclk_fgt_enabled_3_st),
        .q                         (refclk_fgt_enabled_3_st2)
   );


   
  end else begin 
      assign refclk_fgt_enabled_3_st =  1'b1;
   end
endgenerate

 
  
 
     
//Avmm1 mail box soft logic

  
  logic avmm_write_4;    
  logic avmm_read_4;
  logic avmm_reset_4;
  logic avmm_reset_ip_sync_4;
  logic avmm_reset_ext_4;
  logic avmm_reset_in_sync_4;
  logic [9:0] count_reset_4;
  logic  [17:0] avmm_address_4;
  logic  [3:0]  avmm_byteenable_4;
  logic  [31:0] avmm_writedata_4;
  logic [31:0] avmm_readdata_4;
  logic        avmm_waitrequest_4;
  logic        avmm_readdatavalid_4;
 
  logic [S8_ADDR_WIDTH-1:0]  avmm_m8_addr_4         ;  
  logic [7:0]                avmm_m8_wdata_4        ;  
  logic                      avmm_m8_write_4        ;  
  logic                      avmm_m8_read_4         ;  
  logic [7:0]                avmm_m8_readdata_4     ;  
  logic                      avmm_m8_waitrequest_4  ;  
  logic                           m32_read_4;
  logic                           m32_write_4;
  logic[avmm_data_width-1:0]  m32_writedata_4  ;
  logic[avmm_data_width-1:0]  m32_readdata_4 ;
  logic                           m32_waitrequest_4;
  logic                           m32_readdatavalid_4;
  logic[avmm_addr_width-1:0]  m32_address_4;
  logic [BE_WIDTH-1:0]         m32_byteenable_4;
  logic  [1:0]                en_refclk_fgt_change_4;
  logic  [1:0]                en_refclk_fgt_change_detect_4;
 
  localparam count_width_4 = 17;
  localparam d_count_width_4                      = 15;
  logic enable_learning_phase_4; 
  logic enable_learning_phase_4_ff1_cnoc; 
  logic enable_learning_phase_4_ff2_cnoc;
    
  logic enable_learning_phase_4_ff1_core; 
  logic enable_learning_phase_4_ff2_core; 
  
  
  logic [count_width_4-1:0]  cnoc_4_count=0          ;
  logic [3:0] devide_count_10_4=0;
  logic refclk_count_en_4;
  logic start_refclk_monitor_4=0;
  logic cnoc_4_count_limit2;
  logic [d_count_width_4-1:0]   refclk_4_count=0         ;
  logic [d_count_width_4-1:0]   refclk_4_count_store ;
  logic [d_count_width_4-1:0]   refclk_4_count1 ;
  logic [d_count_width_4-1:0]   refclk_4_count2 ;
  logic store_cnoc_clk_4_limit;
  logic store_cnoc_clk_4_limit1;
  logic store_cnoc_clk_4_limit2;
  //detection & removal phase 
  logic start_refclk_monitor_4_enable ;
  logic start_refclk_monitor_4_enable1 ;
  logic start_refclk_monitor_4_enable2 ;
  logic d_start_refclk_monitor_4_enable2 ;
  logic enable_refclk_watchdog_timer_sync_4;
   
  logic [d_count_width_4-1:0]  d_refclk_4_count=0     ;
  logic [d_count_width_4-2:0]  d_cnoc_4_count  =0       ;
  logic d_cnoc_clk_4_limit;
  logic d_cnoc_clk_4_limit1;
  logic d_cnoc_clk_4_limit2;
  
  logic d_store_cnoc_clk_4_limit;
  logic d_store_cnoc_clk_4_limit1;
  logic d_store_cnoc_clk_4_limit2;
  logic [d_count_width_4-1:0] max_count_4;
  logic [d_count_width_4-1:0] min_count_4;
  logic  refclk_fgt_enabled_4_st;
  logic  refclk_fgt_enabled_4_sample;
  logic  refclk_fgt_enabled_4_st2;
  logic  refclk_fgt_enabled_4_enable ;
  logic disable_refclk_monitor_4_reg;
  logic disable_refclk_monitor_4_reg1;
  logic disable_refclk_monitor_4_chickenbit;
  logic [d_count_width_4-1:0]   d_refclk_4_count_store     ;
  logic                          d_refclk_4_count_store_en  ;
  logic                          d_refclk_4_count_store_en1 ;
  logic                          d_refclk_4_count_store_en2 ;
  logic  [1:0]                   one_state_4_store=0;
  logic                          one_state_4_store_en=0;
  logic                          d_store_cnoc_clk_4_limit3;
  logic                          d_store_cnoc_clk_4_limit3_neg_edge;
  logic                          disable_refclk_monitor_4_coreclk;
  logic                          disable_refclk_monitor_4_coreclk1;
  logic                          refclk_count4_data=1'b0;
  logic                          refclk_count4_data_reg1;
  logic                          reg_refclk_fgt_always_active_4;
  logic                          wait_timer_on_4=0;
  logic                          wait_timer1_on_4=0;
  logic                          wait_timer_on_in_4=0;
  logic                          wait_timer1_on_in_4=0;
  logic                          wait_timer_timeout_4; 
  logic                          wait_timer1_timeout_4; 
  logic [timeout_cnt_width-1:0]  timeout_timer_cnt_4=0;
  logic [timeout_cnt1_width-1:0] timeout_timer1_cnt_4=0;
  logic [1:0]                    in_coreclk_4_div=0;
  logic                          in_coreclk_4_div_sync;
  logic                          in_coreclk_4_div_sync_d1;
  logic                          in_coreclk_4_div_sync_edge;
  logic [8:0]                    count_4_cnoc_512=0;
  logic [8:0]                    count_4_coreclk=0;
  logic                          no_coreclk_4;
  logic                          no_coreclk_4_sync;


  
    
     syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (1)
   ) avmm_reset_ip_sync_4_sync_inst(
        .clk                       (i_common_avmm1_clk_4),
        .reset                     (avmm_reset_ip),
        .d                         (1'b0),
        .q                         (avmm_reset_ip_sync_4)
   );
  
    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) avmm_reset_in_sync_4_inst0(
        .clk                       (i_common_avmm1_clk_4),
        .reset                     (1'b0),
        .d                         (avmm_reset_in),
        .q                         (avmm_reset_in_sync_4)
   );
 
 
      syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) enable_refclk_watchdog_timer_4_inst0(
        .clk                       (i_common_avmm1_clk_4),
        .reset                     (1'b0),
        .d                         (enable_refclk_watchdog_timer_4),
        .q                         (enable_refclk_watchdog_timer_sync_4)
   );
  

  
  always@ (posedge i_common_avmm1_clk_4 )
    begin
      if (avmm_reset_ip_sync_4)
        count_reset_4<=10'd0; 
      else if (count_reset_4==10'd512)
        count_reset_4<=count_reset_4;
      else
        count_reset_4<=count_reset_4+1'b1;
    end
 assign avmm_reset_ext_4= (count_reset_4>=10'd512) ? 0 : 1;
 
   always@ (posedge i_common_avmm1_clk_4 )
   begin
     avmm_reset_4<=avmm_reset_ext_4 | avmm_reset_in_sync_4;
   end

  always @(posedge i_common_avmm1_clk_4 ) 
  begin
    wait_timer_on_in_4 <= wait_timer_on_4;
    wait_timer1_on_in_4 <= wait_timer1_on_4;
  end
  
 always @(posedge i_common_avmm1_clk_4 ) 
 begin
    if(wait_timer_on_in_4 & enable_refclk_watchdog_timer_sync_4)     
    timeout_timer_cnt_4 <= timeout_timer_cnt_4 + 1'b1;        
    else
    timeout_timer_cnt_4 <= {timeout_cnt_width{1'b0}};        
 end
  
 always @(posedge i_common_avmm1_clk_4 ) 
 begin
    if(wait_timer1_on_in_4 & enable_refclk_watchdog_timer_sync_4)    
    timeout_timer1_cnt_4 <= timeout_timer1_cnt_4 + 1'b1;      
    else
    timeout_timer1_cnt_4 <= {timeout_cnt1_width{1'b0}};      
 end
  
 always @(posedge i_common_avmm1_clk_4 ) 
 begin
    wait_timer_timeout_4 <= (timeout_timer_cnt_4 >= timeout_cnt); 
    wait_timer1_timeout_4 <= (timeout_timer1_cnt_4 >= timeout_cnt1); 
 end

     syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) refclk_watchdog_timeout_4_sync_inst(
        .clk                       (i_common_avmm1_clk_4),
        .reset                     (1'b0),
        .d                         (wait_timer_timeout_4),
        .q                         (refclk_watchdog_timeout_4)
   );

  /// start learning once refclk persent.
  
 always@(posedge in_coreclk_4 ) 
    begin
      if  (refclk_count4_data==1'b1)
        refclk_count4_data<=refclk_count4_data;
      else 
        refclk_count4_data<=refclk_count4_data+1'b1;
    end

     syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) refclk_count4_data_sync_inst(
        .clk                       (i_common_avmm1_clk_4),
        .reset                     (1'b0),
        .d                         (refclk_count4_data),
        .q                         (refclk_count4_data_reg1)
   );

    
//clkrx main: avmm state machine runs with avmm clock 
// state transition with avmm clock
  
 localparam ST_IDLE_R_4=4'd0;
 localparam ST_WRITE_ON_4=4'd1;
 localparam ST_WRITE_PAUSE_ON_4=4'd2;
 localparam ST_READ_check_ON_4=4'd3 ;
 localparam ST_READ_ON_4=4'd4;
 localparam ST_READ_PAUSE_ON_4=4'd5;
 localparam ST_WRITE_CLEAR_ON_4=4'd6;
 localparam ST_WRITE_OFF_4=4'd7;
 localparam ST_WRITE_PAUSE_OFF_4=4'd8;
 localparam ST_READ_check_OFF_4=4'd9;
 localparam ST_READ_OFF_4=4'd10;
 localparam ST_READ_PAUSE_OFF_4=4'd11;
 localparam ST_WRITE_CLEAR_OFF_4=4'd12;
 localparam ST_CLEAR_OFF_4=4'd13;
 reg [3:0] cur_st_4=4'd0 /* synthesis preserve dont_replicate */;
 reg [3:0] next_st_4=4'd0 /* synthesis preserve dont_replicate */; 
 
 
 
 
  always @(posedge i_common_avmm1_clk_4 ) begin
   if(avmm_reset_4) begin
      cur_st_4     <= ST_IDLE_R_4;
   end else begin
       cur_st_4     <= next_st_4;
    end
 end
 
// input synchronization in avmm clock domain 
logic reg_en_refclk_fgt_4;
logic reg1_en_refclk_fgt_4;


    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) en_refclk_fgt_4_sync_inst(
        .clk                       (i_common_avmm1_clk_4),
        .reset                     (1'b0),
        .d                         (en_refclk_fgt_4),
        .q                         (reg1_en_refclk_fgt_4)
   ); 
     

//avmm state machine combo logic
//always_comb  
`ifndef ALTERA_RESERVED_QIS
always@(*)
`else
always_comb 
`endif // ifndef ALTERA_RESERVED_QIS 

begin

    avmm_write_4 = 1'b0;
    avmm_read_4  =1'b0;
    avmm_address_4 =18'h0;
    avmm_byteenable_4 =4'b0;
    avmm_writedata_4 =32'h0;
    refclk_fgt_enabled_4_enable=1'b0;
    enable_learning_phase_4=1'b0;
    wait_timer_on_4 = 1'b0;
    wait_timer1_on_4 = 1'b0;
    next_st_4 = ST_IDLE_R_4;
    case (cur_st_4) 
        ST_IDLE_R_4 : 
        begin //idle state to initialize avmm read and write 
            avmm_write_4 = 1'b0;
            avmm_read_4  =1'b0;
            avmm_address_4 =18'h0;
            avmm_byteenable_4 =4'b0;
            enable_learning_phase_4=1'b0;
            avmm_writedata_4 =32'h0; 
            wait_timer_on_4 = 1'b0;
            wait_timer1_on_4 = 1'b0;
            if ((refclk_fgt_always_active_4==1) && (refclk_count4_data_reg1==1'b1))
                next_st_4 =   ST_WRITE_CLEAR_ON_4;
            else if (reg1_en_refclk_fgt_4==1'b1)
                next_st_4 =   ST_WRITE_ON_4;
            else
                next_st_4 =   ST_IDLE_R_4;                         
        end
        ST_WRITE_ON_4: 
        begin // mailbox write for stable clk 
            wait_timer_on_4 = 1'b1;
            wait_timer1_on_4 = 1'b0;
            if (wait_timer_timeout_4 == 1'b1) begin
                next_st_4 =ST_WRITE_PAUSE_ON_4;
                wait_timer_on_4 = 1'b0;
            end else if (avmm_waitrequest_4 ) 
            begin //  mailbox write for stable clk, loop in ST_WRITE_ON_4 until avmm_waitrequest went low
                avmm_write_4 = 1'b1;
                avmm_read_4  =1'b0;
                avmm_address_4 =18'h0001;
                avmm_byteenable_4 =4'b1111;
                avmm_writedata_4 ={1'h1,3'h2,in_coreclk_4_map,24'h000000};
                enable_learning_phase_4=1'b0;
                wait_timer_on_4 = 1'b1;
                wait_timer1_on_4 = 1'b0;
                next_st_4 =ST_WRITE_ON_4;
            end else if (!avmm_waitrequest_4 ) 
            begin //Move to ST_READ_check_ON_4 once get avmm_waitrequest low
                avmm_write_4 = 1'b0;
                avmm_byteenable_4 =4'b0000;
                avmm_address_4 =18'h0001;
                enable_learning_phase_4=1'b0;
                next_st_4 = ST_READ_check_ON_4;
                wait_timer_on_4  = 1'b0;
                wait_timer1_on_4 = 1'b0;
            end else 
            begin
                next_st_4 = ST_IDLE_R_4;     
                wait_timer_on_4  = 1'b0;
                wait_timer1_on_4 = 1'b0;
            end
        end
        ST_WRITE_PAUSE_ON_4: 
        begin
            avmm_write_4 = 1'b0;
            avmm_byteenable_4 =4'b0000;
            avmm_address_4 =18'h0001;
            enable_learning_phase_4=1'b0;
            wait_timer_on_4 = 1'b0;
            wait_timer1_on_4 = 1'b1;
            if(wait_timer1_timeout_4 == 1'b1) begin
                next_st_4 = ST_IDLE_R_4;     
                wait_timer1_on_4 = 1'b0;
            end
            else begin
                next_st_4 = ST_WRITE_PAUSE_ON_4;
            end            
        end
        ST_READ_check_ON_4: 
        begin
            enable_learning_phase_4=1'b0;
            wait_timer_on_4 = 1'b0;
            wait_timer1_on_4 = 1'b1;
            if(wait_timer1_timeout_4 == 1'b1) begin
                wait_timer1_on_4 = 1'b0;
                next_st_4 = ST_IDLE_R_4;
            end else if (avmm_waitrequest_4) 
            begin //Move to to ST_READ_ON_4 once avmm_waitrequest go high
                next_st_4 = ST_READ_ON_4;
            end else begin 
                next_st_4 = ST_READ_check_ON_4;
            end
        end
        ST_READ_ON_4: 
        begin
            enable_learning_phase_4=1'b0;
            avmm_write_4 = 1'b0;
            avmm_read_4  =1'b1;
            avmm_address_4 =18'h0002;
            avmm_byteenable_4 =4'b1111;
            //avmm_time_out_enable_4=1'b1;
            wait_timer_on_4 = 1'b1;
            wait_timer1_on_4 = 1'b0;
            if(wait_timer_timeout_4 == 1'b1)
            begin
                next_st_4=ST_READ_PAUSE_ON_4;
                wait_timer_on_4 = 1'b0;
                wait_timer1_on_4 = 1'b0;
            end else if (!avmm_waitrequest_4 && avmm_readdata_4[30:28]==3'h2 && avmm_readdata_4[31]==1'h1) 
            begin  // check FW read once get valid data move to state ST_WRITE_CLEAR_ON & generate flag for enable learning phase & assert refclk_fgt_enabled to high for user
                next_st_4 = ST_WRITE_CLEAR_ON_4;
                enable_learning_phase_4=1'b1;
                refclk_fgt_enabled_4_enable=1'b1;
                wait_timer_on_4 = 1'b0;
                wait_timer1_on_4 = 1'b0;
            end else begin
                refclk_fgt_enabled_4_enable=1'b0;
                next_st_4=ST_READ_ON_4;
            end            
        end
        ST_READ_PAUSE_ON_4: 
        begin             
            avmm_write_4 = 1'b0;
            avmm_read_4  =1'b0;
            avmm_byteenable_4 =4'b0000;
            avmm_address_4 =18'h0002;
            enable_learning_phase_4=1'b0;
            wait_timer_on_4 = 1'b0;
            wait_timer1_on_4 = 1'b1;
            refclk_fgt_enabled_4_enable=1'b0;
            if(wait_timer1_timeout_4 == 1'b1) begin
                next_st_4 = ST_IDLE_R_4;     
                wait_timer1_on_4 = 1'b0;
            end
            else begin
                next_st_4=ST_READ_PAUSE_ON_4;
            end
        end
        ST_WRITE_CLEAR_ON_4:             ///Need to clear the register as per new FW implementation  discussion needed with sidhartha 
        begin
            avmm_write_4 = 1'b0;
            avmm_read_4  =1'b0;
            avmm_address_4 =18'h0;
            avmm_byteenable_4 =4'b0;
            avmm_writedata_4 =32'h0;
            wait_timer_on_4 = 1'b0;
            wait_timer1_on_4 = 1'b0;
            enable_learning_phase_4=1'b1; 
            refclk_fgt_enabled_4_enable=1'b1;
            if (((~refclk_fgt_enabled_4_st2 &&  d_refclk_4_count_store_en && (!disable_refclk_monitor_4_reg1))) || ((reg1_en_refclk_fgt_4==1'b0) &&(refclk_fgt_always_active_4==0)) || (no_coreclk_4_sync && (!disable_refclk_monitor_4_reg1)))             
            begin // wait for monitoring logic to confirm if clock not in range or user indication for refclk not active
                next_st_4 = ST_WRITE_OFF_4;
            end else if ((~refclk_fgt_enabled_4_st2)  && (refclk_fgt_always_active_4==1) && (d_refclk_4_count_store_en) && (!disable_refclk_monitor_4_reg1) || (no_coreclk_4_sync && (!disable_refclk_monitor_4_reg1)))
                next_st_4 = ST_WRITE_OFF_4;
            else
                next_st_4 = ST_WRITE_CLEAR_ON_4;
        end 
        ST_WRITE_OFF_4: 
        begin // if monitoring logic to confirm clock not in range mailbox send command to off CML buffer  
            wait_timer_on_4 = 1'b1;
            wait_timer1_on_4 = 1'b0;
            enable_learning_phase_4=1'b0; 
            if (wait_timer_timeout_4)             
            begin
                next_st_4 = ST_WRITE_PAUSE_OFF_4;
                wait_timer_on_4 = 1'b0;
                wait_timer1_on_4 = 1'b0;
            end else if (avmm_waitrequest_4 ) begin //&& (~refclk_fgt_enabled_4_st2 || reg1_en_refclk_fgt_4==1'b0)) begin
                avmm_write_4 = 1'b1;
                avmm_read_4  =1'b0;
                avmm_address_4 =18'h0001;
                avmm_byteenable_4 =4'b1111;
                avmm_writedata_4 ={1'h1,3'h3,in_coreclk_4_map,24'h000000};
                wait_timer_on_4 = 1'b1;
                wait_timer1_on_4 = 1'b0;
                next_st_4 = ST_WRITE_OFF_4;
            end else begin //if(!avmm_waitrequest_4 && (~refclk_fgt_enabled_4_st2 || reg1_en_refclk_fgt_4==1'b0)) begin 
                avmm_write_4 = 1'b0;
                avmm_byteenable_4 =4'b0000;
                avmm_address_4 =18'h0001;
                next_st_4 = ST_READ_check_OFF_4;
                wait_timer_on_4 = 1'b0;
                wait_timer1_on_4 = 1'b0;
            end       
        end
        ST_WRITE_PAUSE_OFF_4: 
        begin
            avmm_write_4 = 1'b0;
            avmm_byteenable_4 =4'b0000;
            avmm_address_4 =18'h0001;
            wait_timer_on_4 = 1'b0;
            wait_timer1_on_4 = 1'b1;
            if (wait_timer1_timeout_4) 
            begin
                next_st_4 = ST_WRITE_CLEAR_ON_4;            
            end
            else begin
                next_st_4 = ST_WRITE_PAUSE_OFF_4;
            end                              
        end
        
        ST_READ_check_OFF_4: 
        begin           
            wait_timer_on_4 = 1'b0;
            wait_timer1_on_4 = 1'b1;
            if (wait_timer1_timeout_4) 
            begin
                wait_timer_on_4 = 1'b0;
                wait_timer1_on_4 = 1'b0;
                next_st_4 = ST_WRITE_CLEAR_ON_4;            
            end else if ( avmm_waitrequest_4 ) 
            begin
                next_st_4 = ST_READ_OFF_4;
            end else begin 
                next_st_4 = ST_READ_check_OFF_4;
            end
        end
        ST_READ_OFF_4: 
        begin      // Read FW response until get coorect response from FW      
            avmm_write_4 = 1'b0;
            avmm_read_4  =1'b1;
            avmm_address_4 =18'h0002;
            avmm_byteenable_4 =4'b1111;
            wait_timer_on_4 = 1'b1;
            wait_timer1_on_4 = 1'b0;
            if (wait_timer_timeout_4==1'b1)
            begin
                next_st_4 =  ST_READ_PAUSE_OFF_4;
                wait_timer_on_4 = 1'b0;
                wait_timer1_on_4 = 1'b0;
            end else if (!avmm_waitrequest_4 && avmm_readdata_4[30:28]==3'h3 && avmm_readdata_4[31]==1'h1) 
            begin
                next_st_4 =  ST_WRITE_CLEAR_OFF_4;
                refclk_fgt_enabled_4_enable=1'b0; 
            end else 
            begin
                next_st_4 =  ST_READ_OFF_4;
                refclk_fgt_enabled_4_enable=1'b0;        
            end
        end
        ST_READ_PAUSE_OFF_4: 
        begin
            avmm_write_4 = 1'b0;
            avmm_read_4  =1'b0;
            avmm_address_4 =18'h0002;
            avmm_byteenable_4 =4'b1111;
            wait_timer_on_4 = 1'b0;
            wait_timer1_on_4 = 1'b1;
            if (wait_timer1_timeout_4) 
            begin
                next_st_4 = ST_WRITE_CLEAR_ON_4;
            end
            else begin
                next_st_4=ST_READ_PAUSE_OFF_4;
                wait_timer_on_4 = 1'b0;
                wait_timer1_on_4 = 1'b1;
            end
        end
        ST_WRITE_CLEAR_OFF_4: 
        begin // Clear mailbox & move to idle state for user input
            
            if (reg1_en_refclk_fgt_4==1'b1) 
            begin
                avmm_write_4 = 1'b0;
                avmm_read_4  =1'b0;
                avmm_address_4 =18'h0;
                avmm_byteenable_4 =4'b0;
                avmm_writedata_4 =32'h0;
                next_st_4 = ST_WRITE_CLEAR_OFF_4;
            end else 
            begin 
                avmm_write_4 = 1'b0;
                avmm_read_4  =1'b0;
                avmm_address_4 =18'h0;
                avmm_byteenable_4 =4'b0;
                avmm_writedata_4 =32'h0;
                next_st_4 = ST_IDLE_R_4;
            end 
        end
        default:
        begin 
            next_st_4 = ST_IDLE_R_4;
        end         
  endcase
end
 
  assign avmm_waitrequest_4   = m32_waitrequest_4  ;
  assign avmm_readdatavalid_4 = m32_readdatavalid_4 ;
  assign avmm_readdata_4      = m32_readdata_4;
  assign m32_read_4           = avmm_read_4    ;
  assign m32_write_4          = avmm_write_4   ;
  assign m32_address_4        = avmm_address_4 ;
  assign m32_byteenable_4     = avmm_byteenable_4;
  assign m32_writedata_4      = avmm_writedata_4 ;
  
 
 
    
 
    ft_avmm_32to8_bridge 
           #(   .ADDR_WIDTH ( avmm_addr_width ),
                .READ_PIPELINE_ENABLE ( read_pipeline_enable )
            )
      avmm_32to8_inst_4 (
       // AVMM slave Port
       .i_clk                   (  i_common_avmm1_clk_4 ), 
       .i_rst                   (  avmm_reset_4 ),
       
       .i_avmm_s32_addr         ( m32_address_4 ),  
       .i_avmm_s32_wdata        ( m32_writedata_4 ), 
       .i_avmm_s32_write        ( m32_write_4 ), 
       .i_avmm_s32_read         ( m32_read_4 ), 
       .i_avmm_s32_byte_enable  ( m32_byteenable_4 ),
       .o_avmm_s32_readdata     ( m32_readdata_4 ), 
       .o_avmm_s32_waitrequest  ( m32_waitrequest_4 ),
       .o_avmm_s32_readdatavalid( m32_readdatavalid_4 ),
 
       // Master Port
       .o_avmm_m8_addr          ( avmm_m8_addr_4 ),
       .o_avmm_m8_wdata         ( avmm_m8_wdata_4 ), 
       .o_avmm_m8_write         ( avmm_m8_write_4 ), 
       .o_avmm_m8_read          ( avmm_m8_read_4 ), 
       .i_avmm_m8_readdata      ( avmm_m8_readdata_4 ), 
       .i_avmm_m8_waitrequest   ( avmm_m8_waitrequest_4 )   
   );
       
      // instantiate avmm2 core logic
   ctfb_avmm1_soft_logic
                #(  .avmm_interfaces(1),                 //Number of AVMM interfaces required - one for each bonded_lane, PLL, and Master CGB
                    .rcfg_enable (1)                    //Enable/disable reconfig interface 
                 ) avmm1_ena_ins_4t   (
                // AVMM slave interface signals (user)
                 .avmm_clk (i_common_avmm1_clk_4) ,
                 .avmm_reset (avmm_reset_4),
                 .avmm_writedata (avmm_m8_wdata_4), 
                .avmm_address (avmm_m8_addr_4[9:0]), 
                .avmm_write (avmm_m8_write_4),
                .avmm_read (avmm_m8_read_4),
                .avmm_readdata (avmm_m8_readdata_4), 
                .avmm_waitrequest (avmm_m8_waitrequest_4),
                   
                // Signals from AVMM1 building block
                 .pld_avmm1_busy_real             ( pld_avmm1_busy_ref_4),
                 .pld_avmm1_cmdfifo_wr_full_real  ( pld_avmm1_cmdfifo_wr_full_ref_4 ),
                 .pld_avmm1_cmdfifo_wr_pfull_real ( pld_avmm1_cmdfifo_wr_pfull_ref_4 ),
                 .pld_avmm1_readdata_real         ( pld_avmm1_readdata_ref_4 ),
                 .pld_avmm1_readdatavalid_real    ( pld_avmm1_readdatavalid_ref_4),
                 .pld_avmm1_reserved_out_real     ( pld_avmm1_reserved_out_ref_4 ),
                 .pld_chnl_cal_done_real          ( pld_chnl_cal_done_ref_4 ),        
                 .pld_hssi_osc_transfer_en_real   ( pld_hssi_osc_transfer_en_ref_4 ),
                // Signals to AVMM1 building block
                 .pld_avmm1_clk_rowclk_real     (),  //( pld_avmm1_clk_rowclk_ref_4 ),
                 .pld_avmm1_read_real             ( pld_avmm1_read_ref_4),
                 .pld_avmm1_reg_addr_real         ( pld_avmm1_reg_addr_ref_4),
                 .pld_avmm1_request_real          ( pld_avmm1_request_ref_4 ),
                 .pld_avmm1_reserved_in_real      ( pld_avmm1_reserved_in_ref_4 ),
                 .pld_avmm1_write_real            ( pld_avmm1_write_ref_4 ),
                 .pld_avmm1_writedata_real        ( pld_avmm1_writedata_ref_4)
 
                );
 //learning_phase
//learning phase implementation
// chicken bit synchronize
 
assign pld_avmm1_clk_rowclk_ref_4= avmm_clk;

    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) refclk_monitor_4_sync_inst(
        .clk                       (i_common_avmm1_clk_4),
        .reset                     (1'b0),
        .d                         (disable_refclk_monitor_4),
        .q                         (disable_refclk_monitor_4_reg1)
   ); 

 

    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) refclk_monitor_4_core_sync_inst(
        .clk                       (in_coreclk_4),
        .reset                     (1'b0),
        .d                         (disable_refclk_monitor_4),
        .q                         (disable_refclk_monitor_4_coreclk1)
   ); 

 

always @(posedge i_common_avmm1_clk_4)
begin 
   disable_refclk_monitor_4_chickenbit <= (enable_learning_phase_4 && (!disable_refclk_monitor_4_reg1)) ;
end

 
///synchronizer avmm clock to CNOC clock transfer 
  
    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) monitor_4_chickenbit_sync_inst(
        .clk                       (cnoc_clk),
        .reset                     (1'b0),
        .d                         (disable_refclk_monitor_4_chickenbit),
        .q                         (enable_learning_phase_4_ff2_cnoc)
   );  
   
///flag synchronizer avmm clock to in_coreclk_4  clock transfer 

    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) monitor_4_chickenbit_core_sync_inst(
        .clk                       (in_coreclk_4),
        .reset                     (1'b0),
        .d                         (disable_refclk_monitor_4_chickenbit),
        .q                         (enable_learning_phase_4_ff2_core)
   ); 
///count for 480 us in CNOC clock domain 
always@ (posedge cnoc_clk)
begin
if (enable_learning_phase_4_ff2_cnoc) begin 
  if (cnoc_4_count>=learning_count-1) begin 
      cnoc_4_count<=cnoc_4_count;
  end else begin
      cnoc_4_count<=cnoc_4_count+1'b1;
  end
end else begin 
  cnoc_4_count<=0;
end end
 
always@ (posedge cnoc_clk)
begin
if (enable_learning_phase_4_ff2_cnoc) begin 
  if (cnoc_4_count>=learning_count-3) begin 
      start_refclk_monitor_4<=1'b1;
  end else begin
      start_refclk_monitor_4<=1'b0;
  end
end else begin 
  start_refclk_monitor_4<=1'b0;
end end
 
 
/////FF synchronizer

     syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) cnoc_4_count_limit_sync_inst(
        .clk                       (in_coreclk_4),
        .reset                     (1'b0),
        .d                         (start_refclk_monitor_4),
        .q                         (cnoc_4_count_limit2)
   );
 
// divide by 10 counetr 
always@ (posedge in_coreclk_4)
begin
if (enable_learning_phase_4_ff2_core) begin
  if (~cnoc_4_count_limit2) begin
   if (devide_count_10_4==9) begin 
     devide_count_10_4<= 0;     
     end else begin 
       devide_count_10_4<= devide_count_10_4+1'b1;   
    end
end else
 devide_count_10_4<= 0;  
end
end
///muxing for divide by 10
assign refclk_count_en_4= (devide_count_10_4==9) ? 1'b1:1'b0;
 
 //count for 480 us in in_coreclk_4 clock domain devide by 10 counter    
always@ (posedge in_coreclk_4)
begin
if (enable_learning_phase_4_ff2_core) begin 
  if  (cnoc_4_count_limit2) begin 
     refclk_4_count<= refclk_4_count; 
  end  else if (refclk_count_en_4) begin 
     refclk_4_count<= refclk_4_count+1'b1;
  end else 
     refclk_4_count<= refclk_4_count; 
end else
     refclk_4_count<= 0; 
end
 

always@ (posedge in_coreclk_4)
begin
refclk_4_count1<=refclk_4_count;
refclk_4_count2<=refclk_4_count1;
end

always@ (posedge in_coreclk_4)
begin
  store_cnoc_clk_4_limit <= cnoc_4_count_limit2;  
  store_cnoc_clk_4_limit1 <= store_cnoc_clk_4_limit;  
  store_cnoc_clk_4_limit2 <= store_cnoc_clk_4_limit1;  
end

//stored data
always@ (posedge in_coreclk_4)
begin
if (~enable_learning_phase_4_ff2_core) begin 
refclk_4_count_store<='d0;
end else if (store_cnoc_clk_4_limit2) begin 
refclk_4_count_store<=refclk_4_count2;
end else 
refclk_4_count_store<=refclk_4_count_store;
end
 
///monitor logic 
generate
     if(in_coreclk_4_pmap!='d8 || in_coreclk_4_pmap!='d9) begin
//based monitor flag generation 
 
//2 clock cycle delay
always@ (posedge cnoc_clk)
  begin
    start_refclk_monitor_4_enable<=start_refclk_monitor_4;
    start_refclk_monitor_4_enable1<=start_refclk_monitor_4_enable;
    start_refclk_monitor_4_enable2<=start_refclk_monitor_4_enable1;
  end 
 
///count for 48 us in CNOC clock domain 
always@ (posedge cnoc_clk)
begin
if (start_refclk_monitor_4_enable2) begin
  if (d_cnoc_4_count>=detetction_count-1) begin 
      d_cnoc_4_count<=0;   
  end else begin
      d_cnoc_4_count<=d_cnoc_4_count+1'b1;    
  end
  end else begin 
       d_cnoc_4_count<=0;
end end
 
 
//4 cycles(2 cycles are minimum required) of samplable pulse in 25MHz monitoring clock
always@ (posedge cnoc_clk)
begin 
if (start_refclk_monitor_4_enable2) begin
    if (d_cnoc_4_count==detetction_count-'d41)    
       d_store_cnoc_clk_4_limit<= 1'b1;
    else if(d_cnoc_4_count>=detetction_count-'d3)    
       d_store_cnoc_clk_4_limit<= 1'b0;
end else begin
    d_store_cnoc_clk_4_limit<= 1'b0;
end
end
  
// edge detection
 
      syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) d_store_cnoc_clk_4_limit_sync_inst(
        .clk                       (in_coreclk_4),
        .reset                     (1'b0),
        .d                         (d_store_cnoc_clk_4_limit),
        .q                         (d_store_cnoc_clk_4_limit2)
   );
 
      syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) d_store_core_clk_4_limit_sync_inst(
        .clk                       (in_coreclk_4),
        .reset                     (1'b0),
        .d                         (start_refclk_monitor_4_enable),
        .q                         (d_start_refclk_monitor_4_enable2)
   );

always@ (posedge in_coreclk_4)
  begin
    d_store_cnoc_clk_4_limit3<=d_store_cnoc_clk_4_limit2;
  end 
 
 assign d_store_cnoc_clk_4_limit3_neg_edge = ((~d_store_cnoc_clk_4_limit2) && d_store_cnoc_clk_4_limit3) ? 1'b1 : 1'b0; 
 
   ///counter reset based on negedge of d_store_cnoc_clk_4_limit flag. 
always@ (posedge in_coreclk_4)
begin
if (d_start_refclk_monitor_4_enable2) begin
  if  (d_store_cnoc_clk_4_limit3_neg_edge) begin 
     d_refclk_4_count<= 0; 
  end else begin
     d_refclk_4_count<= d_refclk_4_count+1'b1;     
  end
end else begin
  d_refclk_4_count<= 0; 
end
end
 
///store counter based on posedge
always@ (posedge in_coreclk_4)
begin
if (d_start_refclk_monitor_4_enable2) begin
  if (d_store_cnoc_clk_4_limit3_neg_edge)
    d_refclk_4_count_store<=d_refclk_4_count;
end else  
    d_refclk_4_count_store<=0;
end
 
 
always@(posedge i_common_avmm1_clk_4) 
begin  
  refclk_fgt_enabled_4 <= refclk_fgt_enabled_4_enable;
end
//We assume (.78125% error margin)
 
`ifndef ALTERA_RESERVED_QIS
assign max_count_4=refclk_4_count_store+10;
assign min_count_4=refclk_4_count_store-10;
`else
assign max_count_4=refclk_4_count_store+(refclk_4_count_store>>7);
assign min_count_4=refclk_4_count_store-(refclk_4_count_store>>7);
`endif // ifndef ALTERA_RESERVED_QIS  
 
 
    // assign refclk_fgt_enabled_4_st =  ((d_refclk_4_count_store>=min_count_4 && d_refclk_4_count_store<=max_count_4) ? 1'b1 : 1'b0); 
always@ (posedge in_coreclk_4)
begin
 refclk_fgt_enabled_4_sample<=(d_refclk_4_count_store>=min_count_4 && d_refclk_4_count_store<=max_count_4);
 refclk_fgt_enabled_4_st<=refclk_fgt_enabled_4_sample;
end  



always@ (posedge in_coreclk_4)
begin
 if (!d_start_refclk_monitor_4_enable2) 
   in_coreclk_4_div<=0;
 else
   in_coreclk_4_div<=in_coreclk_4_div+1'b1;  
end 

 syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) in_coreclk_4_div_sync_inst(
        .clk                       (cnoc_clk),
        .reset                     (1'b0),
        .d                         (in_coreclk_4_div[1]),
        .q                         (in_coreclk_4_div_sync)
   );

always@ (posedge cnoc_clk)
begin
   in_coreclk_4_div_sync_d1<=in_coreclk_4_div_sync;
end

assign  in_coreclk_4_div_sync_edge = (in_coreclk_4_div_sync & (!in_coreclk_4_div_sync_d1));
 
always@(posedge cnoc_clk)
begin
 if (!start_refclk_monitor_4)
  count_4_cnoc_512<=0;
 else
  count_4_cnoc_512<=count_4_cnoc_512+1'b1;
end

always@(posedge cnoc_clk)
begin
   if (!start_refclk_monitor_4)
     count_4_coreclk<=0;
   else if  (count_4_cnoc_512==511)
     count_4_coreclk<=0;
   else if (in_coreclk_4_div_sync_edge)
     count_4_coreclk<= count_4_coreclk+1'b1;      
end

always@(posedge cnoc_clk)
begin
  if (!start_refclk_monitor_4)
    no_coreclk_4<=0;
  else if (count_4_cnoc_512==511 & count_4_coreclk==0)
    no_coreclk_4<=1;    
end


 syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) no_coreclk_4_div_sync_inst(
        .clk                       (i_common_avmm1_clk_4),
        .reset                     (1'b0),
        .d                         (no_coreclk_4),
        .q                         (no_coreclk_4_sync)
   );

// wait for 48 us to start monitoring
always@ (posedge in_coreclk_4)
begin
if (enable_learning_phase_4_ff2_core) begin 
   if (one_state_4_store==2)
     one_state_4_store<=one_state_4_store;
   else if (one_state_4_store <3 && d_store_cnoc_clk_4_limit3_neg_edge) 
     one_state_4_store<=one_state_4_store+1'b1;
   else if (disable_refclk_monitor_4_coreclk1)
     one_state_4_store<=0; 
end else begin
   one_state_4_store<=0;
end
end        
 
always@ (posedge in_coreclk_4)
begin
   one_state_4_store_en <= (one_state_4_store>= 2);
end
 
       syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) one_state_4_store_sync_inst(
        .clk                       (i_common_avmm1_clk_4),
        .reset                     (1'b0),
        .d                         (one_state_4_store_en),
        .q                         (d_refclk_4_count_store_en)
   );
 

       syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) refclk_fgt_enabled_4_st_sync_inst(
        .clk                       (i_common_avmm1_clk_4),
        .reset                     (1'b0),
        .d                         (refclk_fgt_enabled_4_st),
        .q                         (refclk_fgt_enabled_4_st2)
   );


   
  end else begin 
      assign refclk_fgt_enabled_4_st =  1'b1;
   end
endgenerate

 
  
 
     
//Avmm1 mail box soft logic

  
  logic avmm_write_5;    
  logic avmm_read_5;
  logic avmm_reset_5;
  logic avmm_reset_ip_sync_5;
  logic avmm_reset_ext_5;
  logic avmm_reset_in_sync_5;
  logic [9:0] count_reset_5;
  logic  [17:0] avmm_address_5;
  logic  [3:0]  avmm_byteenable_5;
  logic  [31:0] avmm_writedata_5;
  logic [31:0] avmm_readdata_5;
  logic        avmm_waitrequest_5;
  logic        avmm_readdatavalid_5;
 
  logic [S8_ADDR_WIDTH-1:0]  avmm_m8_addr_5         ;  
  logic [7:0]                avmm_m8_wdata_5        ;  
  logic                      avmm_m8_write_5        ;  
  logic                      avmm_m8_read_5         ;  
  logic [7:0]                avmm_m8_readdata_5     ;  
  logic                      avmm_m8_waitrequest_5  ;  
  logic                           m32_read_5;
  logic                           m32_write_5;
  logic[avmm_data_width-1:0]  m32_writedata_5  ;
  logic[avmm_data_width-1:0]  m32_readdata_5 ;
  logic                           m32_waitrequest_5;
  logic                           m32_readdatavalid_5;
  logic[avmm_addr_width-1:0]  m32_address_5;
  logic [BE_WIDTH-1:0]         m32_byteenable_5;
  logic  [1:0]                en_refclk_fgt_change_5;
  logic  [1:0]                en_refclk_fgt_change_detect_5;
 
  localparam count_width_5 = 17;
  localparam d_count_width_5                      = 15;
  logic enable_learning_phase_5; 
  logic enable_learning_phase_5_ff1_cnoc; 
  logic enable_learning_phase_5_ff2_cnoc;
    
  logic enable_learning_phase_5_ff1_core; 
  logic enable_learning_phase_5_ff2_core; 
  
  
  logic [count_width_5-1:0]  cnoc_5_count=0          ;
  logic [3:0] devide_count_10_5=0;
  logic refclk_count_en_5;
  logic start_refclk_monitor_5=0;
  logic cnoc_5_count_limit2;
  logic [d_count_width_5-1:0]   refclk_5_count=0         ;
  logic [d_count_width_5-1:0]   refclk_5_count_store ;
  logic [d_count_width_5-1:0]   refclk_5_count1 ;
  logic [d_count_width_5-1:0]   refclk_5_count2 ;
  logic store_cnoc_clk_5_limit;
  logic store_cnoc_clk_5_limit1;
  logic store_cnoc_clk_5_limit2;
  //detection & removal phase 
  logic start_refclk_monitor_5_enable ;
  logic start_refclk_monitor_5_enable1 ;
  logic start_refclk_monitor_5_enable2 ;
  logic d_start_refclk_monitor_5_enable2 ;
  logic enable_refclk_watchdog_timer_sync_5;
   
  logic [d_count_width_5-1:0]  d_refclk_5_count=0     ;
  logic [d_count_width_5-2:0]  d_cnoc_5_count  =0       ;
  logic d_cnoc_clk_5_limit;
  logic d_cnoc_clk_5_limit1;
  logic d_cnoc_clk_5_limit2;
  
  logic d_store_cnoc_clk_5_limit;
  logic d_store_cnoc_clk_5_limit1;
  logic d_store_cnoc_clk_5_limit2;
  logic [d_count_width_5-1:0] max_count_5;
  logic [d_count_width_5-1:0] min_count_5;
  logic  refclk_fgt_enabled_5_st;
  logic  refclk_fgt_enabled_5_sample;
  logic  refclk_fgt_enabled_5_st2;
  logic  refclk_fgt_enabled_5_enable ;
  logic disable_refclk_monitor_5_reg;
  logic disable_refclk_monitor_5_reg1;
  logic disable_refclk_monitor_5_chickenbit;
  logic [d_count_width_5-1:0]   d_refclk_5_count_store     ;
  logic                          d_refclk_5_count_store_en  ;
  logic                          d_refclk_5_count_store_en1 ;
  logic                          d_refclk_5_count_store_en2 ;
  logic  [1:0]                   one_state_5_store=0;
  logic                          one_state_5_store_en=0;
  logic                          d_store_cnoc_clk_5_limit3;
  logic                          d_store_cnoc_clk_5_limit3_neg_edge;
  logic                          disable_refclk_monitor_5_coreclk;
  logic                          disable_refclk_monitor_5_coreclk1;
  logic                          refclk_count5_data=1'b0;
  logic                          refclk_count5_data_reg1;
  logic                          reg_refclk_fgt_always_active_5;
  logic                          wait_timer_on_5=0;
  logic                          wait_timer1_on_5=0;
  logic                          wait_timer_on_in_5=0;
  logic                          wait_timer1_on_in_5=0;
  logic                          wait_timer_timeout_5; 
  logic                          wait_timer1_timeout_5; 
  logic [timeout_cnt_width-1:0]  timeout_timer_cnt_5=0;
  logic [timeout_cnt1_width-1:0] timeout_timer1_cnt_5=0;
  logic [1:0]                    in_coreclk_5_div=0;
  logic                          in_coreclk_5_div_sync;
  logic                          in_coreclk_5_div_sync_d1;
  logic                          in_coreclk_5_div_sync_edge;
  logic [8:0]                    count_5_cnoc_512=0;
  logic [8:0]                    count_5_coreclk=0;
  logic                          no_coreclk_5;
  logic                          no_coreclk_5_sync;


  
    
     syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (1)
   ) avmm_reset_ip_sync_5_sync_inst(
        .clk                       (i_common_avmm1_clk_5),
        .reset                     (avmm_reset_ip),
        .d                         (1'b0),
        .q                         (avmm_reset_ip_sync_5)
   );
  
    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) avmm_reset_in_sync_5_inst0(
        .clk                       (i_common_avmm1_clk_5),
        .reset                     (1'b0),
        .d                         (avmm_reset_in),
        .q                         (avmm_reset_in_sync_5)
   );
 
 
      syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) enable_refclk_watchdog_timer_5_inst0(
        .clk                       (i_common_avmm1_clk_5),
        .reset                     (1'b0),
        .d                         (enable_refclk_watchdog_timer_5),
        .q                         (enable_refclk_watchdog_timer_sync_5)
   );
  

  
  always@ (posedge i_common_avmm1_clk_5 )
    begin
      if (avmm_reset_ip_sync_5)
        count_reset_5<=10'd0; 
      else if (count_reset_5==10'd512)
        count_reset_5<=count_reset_5;
      else
        count_reset_5<=count_reset_5+1'b1;
    end
 assign avmm_reset_ext_5= (count_reset_5>=10'd512) ? 0 : 1;
 
   always@ (posedge i_common_avmm1_clk_5 )
   begin
     avmm_reset_5<=avmm_reset_ext_5 | avmm_reset_in_sync_5;
   end

  always @(posedge i_common_avmm1_clk_5 ) 
  begin
    wait_timer_on_in_5 <= wait_timer_on_5;
    wait_timer1_on_in_5 <= wait_timer1_on_5;
  end
  
 always @(posedge i_common_avmm1_clk_5 ) 
 begin
    if(wait_timer_on_in_5 & enable_refclk_watchdog_timer_sync_5)     
    timeout_timer_cnt_5 <= timeout_timer_cnt_5 + 1'b1;        
    else
    timeout_timer_cnt_5 <= {timeout_cnt_width{1'b0}};        
 end
  
 always @(posedge i_common_avmm1_clk_5 ) 
 begin
    if(wait_timer1_on_in_5 & enable_refclk_watchdog_timer_sync_5)    
    timeout_timer1_cnt_5 <= timeout_timer1_cnt_5 + 1'b1;      
    else
    timeout_timer1_cnt_5 <= {timeout_cnt1_width{1'b0}};      
 end
  
 always @(posedge i_common_avmm1_clk_5 ) 
 begin
    wait_timer_timeout_5 <= (timeout_timer_cnt_5 >= timeout_cnt); 
    wait_timer1_timeout_5 <= (timeout_timer1_cnt_5 >= timeout_cnt1); 
 end

     syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) refclk_watchdog_timeout_5_sync_inst(
        .clk                       (i_common_avmm1_clk_5),
        .reset                     (1'b0),
        .d                         (wait_timer_timeout_5),
        .q                         (refclk_watchdog_timeout_5)
   );

  /// start learning once refclk persent.
  
 always@(posedge in_coreclk_5 ) 
    begin
      if  (refclk_count5_data==1'b1)
        refclk_count5_data<=refclk_count5_data;
      else 
        refclk_count5_data<=refclk_count5_data+1'b1;
    end

     syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) refclk_count5_data_sync_inst(
        .clk                       (i_common_avmm1_clk_5),
        .reset                     (1'b0),
        .d                         (refclk_count5_data),
        .q                         (refclk_count5_data_reg1)
   );

    
//clkrx main: avmm state machine runs with avmm clock 
// state transition with avmm clock
  
 localparam ST_IDLE_R_5=4'd0;
 localparam ST_WRITE_ON_5=4'd1;
 localparam ST_WRITE_PAUSE_ON_5=4'd2;
 localparam ST_READ_check_ON_5=4'd3 ;
 localparam ST_READ_ON_5=4'd4;
 localparam ST_READ_PAUSE_ON_5=4'd5;
 localparam ST_WRITE_CLEAR_ON_5=4'd6;
 localparam ST_WRITE_OFF_5=4'd7;
 localparam ST_WRITE_PAUSE_OFF_5=4'd8;
 localparam ST_READ_check_OFF_5=4'd9;
 localparam ST_READ_OFF_5=4'd10;
 localparam ST_READ_PAUSE_OFF_5=4'd11;
 localparam ST_WRITE_CLEAR_OFF_5=4'd12;
 localparam ST_CLEAR_OFF_5=4'd13;
 reg [3:0] cur_st_5=4'd0 /* synthesis preserve dont_replicate */;
 reg [3:0] next_st_5=4'd0 /* synthesis preserve dont_replicate */; 
 
 
 
 
  always @(posedge i_common_avmm1_clk_5 ) begin
   if(avmm_reset_5) begin
      cur_st_5     <= ST_IDLE_R_5;
   end else begin
       cur_st_5     <= next_st_5;
    end
 end
 
// input synchronization in avmm clock domain 
logic reg_en_refclk_fgt_5;
logic reg1_en_refclk_fgt_5;


    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) en_refclk_fgt_5_sync_inst(
        .clk                       (i_common_avmm1_clk_5),
        .reset                     (1'b0),
        .d                         (en_refclk_fgt_5),
        .q                         (reg1_en_refclk_fgt_5)
   ); 
     

//avmm state machine combo logic
//always_comb  
`ifndef ALTERA_RESERVED_QIS
always@(*)
`else
always_comb 
`endif // ifndef ALTERA_RESERVED_QIS 

begin

    avmm_write_5 = 1'b0;
    avmm_read_5  =1'b0;
    avmm_address_5 =18'h0;
    avmm_byteenable_5 =4'b0;
    avmm_writedata_5 =32'h0;
    refclk_fgt_enabled_5_enable=1'b0;
    enable_learning_phase_5=1'b0;
    wait_timer_on_5 = 1'b0;
    wait_timer1_on_5 = 1'b0;
    next_st_5 = ST_IDLE_R_5;
    case (cur_st_5) 
        ST_IDLE_R_5 : 
        begin //idle state to initialize avmm read and write 
            avmm_write_5 = 1'b0;
            avmm_read_5  =1'b0;
            avmm_address_5 =18'h0;
            avmm_byteenable_5 =4'b0;
            enable_learning_phase_5=1'b0;
            avmm_writedata_5 =32'h0; 
            wait_timer_on_5 = 1'b0;
            wait_timer1_on_5 = 1'b0;
            if ((refclk_fgt_always_active_5==1) && (refclk_count5_data_reg1==1'b1))
                next_st_5 =   ST_WRITE_CLEAR_ON_5;
            else if (reg1_en_refclk_fgt_5==1'b1)
                next_st_5 =   ST_WRITE_ON_5;
            else
                next_st_5 =   ST_IDLE_R_5;                         
        end
        ST_WRITE_ON_5: 
        begin // mailbox write for stable clk 
            wait_timer_on_5 = 1'b1;
            wait_timer1_on_5 = 1'b0;
            if (wait_timer_timeout_5 == 1'b1) begin
                next_st_5 =ST_WRITE_PAUSE_ON_5;
                wait_timer_on_5 = 1'b0;
            end else if (avmm_waitrequest_5 ) 
            begin //  mailbox write for stable clk, loop in ST_WRITE_ON_5 until avmm_waitrequest went low
                avmm_write_5 = 1'b1;
                avmm_read_5  =1'b0;
                avmm_address_5 =18'h0001;
                avmm_byteenable_5 =4'b1111;
                avmm_writedata_5 ={1'h1,3'h2,in_coreclk_5_map,24'h000000};
                enable_learning_phase_5=1'b0;
                wait_timer_on_5 = 1'b1;
                wait_timer1_on_5 = 1'b0;
                next_st_5 =ST_WRITE_ON_5;
            end else if (!avmm_waitrequest_5 ) 
            begin //Move to ST_READ_check_ON_5 once get avmm_waitrequest low
                avmm_write_5 = 1'b0;
                avmm_byteenable_5 =4'b0000;
                avmm_address_5 =18'h0001;
                enable_learning_phase_5=1'b0;
                next_st_5 = ST_READ_check_ON_5;
                wait_timer_on_5  = 1'b0;
                wait_timer1_on_5 = 1'b0;
            end else 
            begin
                next_st_5 = ST_IDLE_R_5;     
                wait_timer_on_5  = 1'b0;
                wait_timer1_on_5 = 1'b0;
            end
        end
        ST_WRITE_PAUSE_ON_5: 
        begin
            avmm_write_5 = 1'b0;
            avmm_byteenable_5 =4'b0000;
            avmm_address_5 =18'h0001;
            enable_learning_phase_5=1'b0;
            wait_timer_on_5 = 1'b0;
            wait_timer1_on_5 = 1'b1;
            if(wait_timer1_timeout_5 == 1'b1) begin
                next_st_5 = ST_IDLE_R_5;     
                wait_timer1_on_5 = 1'b0;
            end
            else begin
                next_st_5 = ST_WRITE_PAUSE_ON_5;
            end            
        end
        ST_READ_check_ON_5: 
        begin
            enable_learning_phase_5=1'b0;
            wait_timer_on_5 = 1'b0;
            wait_timer1_on_5 = 1'b1;
            if(wait_timer1_timeout_5 == 1'b1) begin
                wait_timer1_on_5 = 1'b0;
                next_st_5 = ST_IDLE_R_5;
            end else if (avmm_waitrequest_5) 
            begin //Move to to ST_READ_ON_5 once avmm_waitrequest go high
                next_st_5 = ST_READ_ON_5;
            end else begin 
                next_st_5 = ST_READ_check_ON_5;
            end
        end
        ST_READ_ON_5: 
        begin
            enable_learning_phase_5=1'b0;
            avmm_write_5 = 1'b0;
            avmm_read_5  =1'b1;
            avmm_address_5 =18'h0002;
            avmm_byteenable_5 =4'b1111;
            //avmm_time_out_enable_5=1'b1;
            wait_timer_on_5 = 1'b1;
            wait_timer1_on_5 = 1'b0;
            if(wait_timer_timeout_5 == 1'b1)
            begin
                next_st_5=ST_READ_PAUSE_ON_5;
                wait_timer_on_5 = 1'b0;
                wait_timer1_on_5 = 1'b0;
            end else if (!avmm_waitrequest_5 && avmm_readdata_5[30:28]==3'h2 && avmm_readdata_5[31]==1'h1) 
            begin  // check FW read once get valid data move to state ST_WRITE_CLEAR_ON & generate flag for enable learning phase & assert refclk_fgt_enabled to high for user
                next_st_5 = ST_WRITE_CLEAR_ON_5;
                enable_learning_phase_5=1'b1;
                refclk_fgt_enabled_5_enable=1'b1;
                wait_timer_on_5 = 1'b0;
                wait_timer1_on_5 = 1'b0;
            end else begin
                refclk_fgt_enabled_5_enable=1'b0;
                next_st_5=ST_READ_ON_5;
            end            
        end
        ST_READ_PAUSE_ON_5: 
        begin             
            avmm_write_5 = 1'b0;
            avmm_read_5  =1'b0;
            avmm_byteenable_5 =4'b0000;
            avmm_address_5 =18'h0002;
            enable_learning_phase_5=1'b0;
            wait_timer_on_5 = 1'b0;
            wait_timer1_on_5 = 1'b1;
            refclk_fgt_enabled_5_enable=1'b0;
            if(wait_timer1_timeout_5 == 1'b1) begin
                next_st_5 = ST_IDLE_R_5;     
                wait_timer1_on_5 = 1'b0;
            end
            else begin
                next_st_5=ST_READ_PAUSE_ON_5;
            end
        end
        ST_WRITE_CLEAR_ON_5:             ///Need to clear the register as per new FW implementation  discussion needed with sidhartha 
        begin
            avmm_write_5 = 1'b0;
            avmm_read_5  =1'b0;
            avmm_address_5 =18'h0;
            avmm_byteenable_5 =4'b0;
            avmm_writedata_5 =32'h0;
            wait_timer_on_5 = 1'b0;
            wait_timer1_on_5 = 1'b0;
            enable_learning_phase_5=1'b1; 
            refclk_fgt_enabled_5_enable=1'b1;
            if (((~refclk_fgt_enabled_5_st2 &&  d_refclk_5_count_store_en && (!disable_refclk_monitor_5_reg1))) || ((reg1_en_refclk_fgt_5==1'b0) &&(refclk_fgt_always_active_5==0)) || (no_coreclk_5_sync && (!disable_refclk_monitor_5_reg1)))             
            begin // wait for monitoring logic to confirm if clock not in range or user indication for refclk not active
                next_st_5 = ST_WRITE_OFF_5;
            end else if ((~refclk_fgt_enabled_5_st2)  && (refclk_fgt_always_active_5==1) && (d_refclk_5_count_store_en) && (!disable_refclk_monitor_5_reg1) || (no_coreclk_5_sync && (!disable_refclk_monitor_5_reg1)))
                next_st_5 = ST_WRITE_OFF_5;
            else
                next_st_5 = ST_WRITE_CLEAR_ON_5;
        end 
        ST_WRITE_OFF_5: 
        begin // if monitoring logic to confirm clock not in range mailbox send command to off CML buffer  
            wait_timer_on_5 = 1'b1;
            wait_timer1_on_5 = 1'b0;
            enable_learning_phase_5=1'b0; 
            if (wait_timer_timeout_5)             
            begin
                next_st_5 = ST_WRITE_PAUSE_OFF_5;
                wait_timer_on_5 = 1'b0;
                wait_timer1_on_5 = 1'b0;
            end else if (avmm_waitrequest_5 ) begin //&& (~refclk_fgt_enabled_5_st2 || reg1_en_refclk_fgt_5==1'b0)) begin
                avmm_write_5 = 1'b1;
                avmm_read_5  =1'b0;
                avmm_address_5 =18'h0001;
                avmm_byteenable_5 =4'b1111;
                avmm_writedata_5 ={1'h1,3'h3,in_coreclk_5_map,24'h000000};
                wait_timer_on_5 = 1'b1;
                wait_timer1_on_5 = 1'b0;
                next_st_5 = ST_WRITE_OFF_5;
            end else begin //if(!avmm_waitrequest_5 && (~refclk_fgt_enabled_5_st2 || reg1_en_refclk_fgt_5==1'b0)) begin 
                avmm_write_5 = 1'b0;
                avmm_byteenable_5 =4'b0000;
                avmm_address_5 =18'h0001;
                next_st_5 = ST_READ_check_OFF_5;
                wait_timer_on_5 = 1'b0;
                wait_timer1_on_5 = 1'b0;
            end       
        end
        ST_WRITE_PAUSE_OFF_5: 
        begin
            avmm_write_5 = 1'b0;
            avmm_byteenable_5 =4'b0000;
            avmm_address_5 =18'h0001;
            wait_timer_on_5 = 1'b0;
            wait_timer1_on_5 = 1'b1;
            if (wait_timer1_timeout_5) 
            begin
                next_st_5 = ST_WRITE_CLEAR_ON_5;            
            end
            else begin
                next_st_5 = ST_WRITE_PAUSE_OFF_5;
            end                              
        end
        
        ST_READ_check_OFF_5: 
        begin           
            wait_timer_on_5 = 1'b0;
            wait_timer1_on_5 = 1'b1;
            if (wait_timer1_timeout_5) 
            begin
                wait_timer_on_5 = 1'b0;
                wait_timer1_on_5 = 1'b0;
                next_st_5 = ST_WRITE_CLEAR_ON_5;            
            end else if ( avmm_waitrequest_5 ) 
            begin
                next_st_5 = ST_READ_OFF_5;
            end else begin 
                next_st_5 = ST_READ_check_OFF_5;
            end
        end
        ST_READ_OFF_5: 
        begin      // Read FW response until get coorect response from FW      
            avmm_write_5 = 1'b0;
            avmm_read_5  =1'b1;
            avmm_address_5 =18'h0002;
            avmm_byteenable_5 =4'b1111;
            wait_timer_on_5 = 1'b1;
            wait_timer1_on_5 = 1'b0;
            if (wait_timer_timeout_5==1'b1)
            begin
                next_st_5 =  ST_READ_PAUSE_OFF_5;
                wait_timer_on_5 = 1'b0;
                wait_timer1_on_5 = 1'b0;
            end else if (!avmm_waitrequest_5 && avmm_readdata_5[30:28]==3'h3 && avmm_readdata_5[31]==1'h1) 
            begin
                next_st_5 =  ST_WRITE_CLEAR_OFF_5;
                refclk_fgt_enabled_5_enable=1'b0; 
            end else 
            begin
                next_st_5 =  ST_READ_OFF_5;
                refclk_fgt_enabled_5_enable=1'b0;        
            end
        end
        ST_READ_PAUSE_OFF_5: 
        begin
            avmm_write_5 = 1'b0;
            avmm_read_5  =1'b0;
            avmm_address_5 =18'h0002;
            avmm_byteenable_5 =4'b1111;
            wait_timer_on_5 = 1'b0;
            wait_timer1_on_5 = 1'b1;
            if (wait_timer1_timeout_5) 
            begin
                next_st_5 = ST_WRITE_CLEAR_ON_5;
            end
            else begin
                next_st_5=ST_READ_PAUSE_OFF_5;
                wait_timer_on_5 = 1'b0;
                wait_timer1_on_5 = 1'b1;
            end
        end
        ST_WRITE_CLEAR_OFF_5: 
        begin // Clear mailbox & move to idle state for user input
            
            if (reg1_en_refclk_fgt_5==1'b1) 
            begin
                avmm_write_5 = 1'b0;
                avmm_read_5  =1'b0;
                avmm_address_5 =18'h0;
                avmm_byteenable_5 =4'b0;
                avmm_writedata_5 =32'h0;
                next_st_5 = ST_WRITE_CLEAR_OFF_5;
            end else 
            begin 
                avmm_write_5 = 1'b0;
                avmm_read_5  =1'b0;
                avmm_address_5 =18'h0;
                avmm_byteenable_5 =4'b0;
                avmm_writedata_5 =32'h0;
                next_st_5 = ST_IDLE_R_5;
            end 
        end
        default:
        begin 
            next_st_5 = ST_IDLE_R_5;
        end         
  endcase
end
 
  assign avmm_waitrequest_5   = m32_waitrequest_5  ;
  assign avmm_readdatavalid_5 = m32_readdatavalid_5 ;
  assign avmm_readdata_5      = m32_readdata_5;
  assign m32_read_5           = avmm_read_5    ;
  assign m32_write_5          = avmm_write_5   ;
  assign m32_address_5        = avmm_address_5 ;
  assign m32_byteenable_5     = avmm_byteenable_5;
  assign m32_writedata_5      = avmm_writedata_5 ;
  
 
 
    
 
    ft_avmm_32to8_bridge 
           #(   .ADDR_WIDTH ( avmm_addr_width ),
                .READ_PIPELINE_ENABLE ( read_pipeline_enable )
            )
      avmm_32to8_inst_5 (
       // AVMM slave Port
       .i_clk                   (  i_common_avmm1_clk_5 ), 
       .i_rst                   (  avmm_reset_5 ),
       
       .i_avmm_s32_addr         ( m32_address_5 ),  
       .i_avmm_s32_wdata        ( m32_writedata_5 ), 
       .i_avmm_s32_write        ( m32_write_5 ), 
       .i_avmm_s32_read         ( m32_read_5 ), 
       .i_avmm_s32_byte_enable  ( m32_byteenable_5 ),
       .o_avmm_s32_readdata     ( m32_readdata_5 ), 
       .o_avmm_s32_waitrequest  ( m32_waitrequest_5 ),
       .o_avmm_s32_readdatavalid( m32_readdatavalid_5 ),
 
       // Master Port
       .o_avmm_m8_addr          ( avmm_m8_addr_5 ),
       .o_avmm_m8_wdata         ( avmm_m8_wdata_5 ), 
       .o_avmm_m8_write         ( avmm_m8_write_5 ), 
       .o_avmm_m8_read          ( avmm_m8_read_5 ), 
       .i_avmm_m8_readdata      ( avmm_m8_readdata_5 ), 
       .i_avmm_m8_waitrequest   ( avmm_m8_waitrequest_5 )   
   );
       
      // instantiate avmm2 core logic
   ctfb_avmm1_soft_logic
                #(  .avmm_interfaces(1),                 //Number of AVMM interfaces required - one for each bonded_lane, PLL, and Master CGB
                    .rcfg_enable (1)                    //Enable/disable reconfig interface 
                 ) avmm1_ena_ins_5t   (
                // AVMM slave interface signals (user)
                 .avmm_clk (i_common_avmm1_clk_5) ,
                 .avmm_reset (avmm_reset_5),
                 .avmm_writedata (avmm_m8_wdata_5), 
                .avmm_address (avmm_m8_addr_5[9:0]), 
                .avmm_write (avmm_m8_write_5),
                .avmm_read (avmm_m8_read_5),
                .avmm_readdata (avmm_m8_readdata_5), 
                .avmm_waitrequest (avmm_m8_waitrequest_5),
                   
                // Signals from AVMM1 building block
                 .pld_avmm1_busy_real             ( pld_avmm1_busy_ref_5),
                 .pld_avmm1_cmdfifo_wr_full_real  ( pld_avmm1_cmdfifo_wr_full_ref_5 ),
                 .pld_avmm1_cmdfifo_wr_pfull_real ( pld_avmm1_cmdfifo_wr_pfull_ref_5 ),
                 .pld_avmm1_readdata_real         ( pld_avmm1_readdata_ref_5 ),
                 .pld_avmm1_readdatavalid_real    ( pld_avmm1_readdatavalid_ref_5),
                 .pld_avmm1_reserved_out_real     ( pld_avmm1_reserved_out_ref_5 ),
                 .pld_chnl_cal_done_real          ( pld_chnl_cal_done_ref_5 ),        
                 .pld_hssi_osc_transfer_en_real   ( pld_hssi_osc_transfer_en_ref_5 ),
                // Signals to AVMM1 building block
                 .pld_avmm1_clk_rowclk_real     (),  //( pld_avmm1_clk_rowclk_ref_5 ),
                 .pld_avmm1_read_real             ( pld_avmm1_read_ref_5),
                 .pld_avmm1_reg_addr_real         ( pld_avmm1_reg_addr_ref_5),
                 .pld_avmm1_request_real          ( pld_avmm1_request_ref_5 ),
                 .pld_avmm1_reserved_in_real      ( pld_avmm1_reserved_in_ref_5 ),
                 .pld_avmm1_write_real            ( pld_avmm1_write_ref_5 ),
                 .pld_avmm1_writedata_real        ( pld_avmm1_writedata_ref_5)
 
                );
 //learning_phase
//learning phase implementation
// chicken bit synchronize
 
assign pld_avmm1_clk_rowclk_ref_5= avmm_clk;

    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) refclk_monitor_5_sync_inst(
        .clk                       (i_common_avmm1_clk_5),
        .reset                     (1'b0),
        .d                         (disable_refclk_monitor_5),
        .q                         (disable_refclk_monitor_5_reg1)
   ); 

 

    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) refclk_monitor_5_core_sync_inst(
        .clk                       (in_coreclk_5),
        .reset                     (1'b0),
        .d                         (disable_refclk_monitor_5),
        .q                         (disable_refclk_monitor_5_coreclk1)
   ); 

 

always @(posedge i_common_avmm1_clk_5)
begin 
   disable_refclk_monitor_5_chickenbit <= (enable_learning_phase_5 && (!disable_refclk_monitor_5_reg1)) ;
end

 
///synchronizer avmm clock to CNOC clock transfer 
  
    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) monitor_5_chickenbit_sync_inst(
        .clk                       (cnoc_clk),
        .reset                     (1'b0),
        .d                         (disable_refclk_monitor_5_chickenbit),
        .q                         (enable_learning_phase_5_ff2_cnoc)
   );  
   
///flag synchronizer avmm clock to in_coreclk_5  clock transfer 

    syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) monitor_5_chickenbit_core_sync_inst(
        .clk                       (in_coreclk_5),
        .reset                     (1'b0),
        .d                         (disable_refclk_monitor_5_chickenbit),
        .q                         (enable_learning_phase_5_ff2_core)
   ); 
///count for 480 us in CNOC clock domain 
always@ (posedge cnoc_clk)
begin
if (enable_learning_phase_5_ff2_cnoc) begin 
  if (cnoc_5_count>=learning_count-1) begin 
      cnoc_5_count<=cnoc_5_count;
  end else begin
      cnoc_5_count<=cnoc_5_count+1'b1;
  end
end else begin 
  cnoc_5_count<=0;
end end
 
always@ (posedge cnoc_clk)
begin
if (enable_learning_phase_5_ff2_cnoc) begin 
  if (cnoc_5_count>=learning_count-3) begin 
      start_refclk_monitor_5<=1'b1;
  end else begin
      start_refclk_monitor_5<=1'b0;
  end
end else begin 
  start_refclk_monitor_5<=1'b0;
end end
 
 
/////FF synchronizer

     syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) cnoc_5_count_limit_sync_inst(
        .clk                       (in_coreclk_5),
        .reset                     (1'b0),
        .d                         (start_refclk_monitor_5),
        .q                         (cnoc_5_count_limit2)
   );
 
// divide by 10 counetr 
always@ (posedge in_coreclk_5)
begin
if (enable_learning_phase_5_ff2_core) begin
  if (~cnoc_5_count_limit2) begin
   if (devide_count_10_5==9) begin 
     devide_count_10_5<= 0;     
     end else begin 
       devide_count_10_5<= devide_count_10_5+1'b1;   
    end
end else
 devide_count_10_5<= 0;  
end
end
///muxing for divide by 10
assign refclk_count_en_5= (devide_count_10_5==9) ? 1'b1:1'b0;
 
 //count for 480 us in in_coreclk_5 clock domain devide by 10 counter    
always@ (posedge in_coreclk_5)
begin
if (enable_learning_phase_5_ff2_core) begin 
  if  (cnoc_5_count_limit2) begin 
     refclk_5_count<= refclk_5_count; 
  end  else if (refclk_count_en_5) begin 
     refclk_5_count<= refclk_5_count+1'b1;
  end else 
     refclk_5_count<= refclk_5_count; 
end else
     refclk_5_count<= 0; 
end
 

always@ (posedge in_coreclk_5)
begin
refclk_5_count1<=refclk_5_count;
refclk_5_count2<=refclk_5_count1;
end

always@ (posedge in_coreclk_5)
begin
  store_cnoc_clk_5_limit <= cnoc_5_count_limit2;  
  store_cnoc_clk_5_limit1 <= store_cnoc_clk_5_limit;  
  store_cnoc_clk_5_limit2 <= store_cnoc_clk_5_limit1;  
end

//stored data
always@ (posedge in_coreclk_5)
begin
if (~enable_learning_phase_5_ff2_core) begin 
refclk_5_count_store<='d0;
end else if (store_cnoc_clk_5_limit2) begin 
refclk_5_count_store<=refclk_5_count2;
end else 
refclk_5_count_store<=refclk_5_count_store;
end
 
///monitor logic 
generate
     if(in_coreclk_5_pmap!='d8 || in_coreclk_5_pmap!='d9) begin
//based monitor flag generation 
 
//2 clock cycle delay
always@ (posedge cnoc_clk)
  begin
    start_refclk_monitor_5_enable<=start_refclk_monitor_5;
    start_refclk_monitor_5_enable1<=start_refclk_monitor_5_enable;
    start_refclk_monitor_5_enable2<=start_refclk_monitor_5_enable1;
  end 
 
///count for 48 us in CNOC clock domain 
always@ (posedge cnoc_clk)
begin
if (start_refclk_monitor_5_enable2) begin
  if (d_cnoc_5_count>=detetction_count-1) begin 
      d_cnoc_5_count<=0;   
  end else begin
      d_cnoc_5_count<=d_cnoc_5_count+1'b1;    
  end
  end else begin 
       d_cnoc_5_count<=0;
end end
 
 
//4 cycles(2 cycles are minimum required) of samplable pulse in 25MHz monitoring clock
always@ (posedge cnoc_clk)
begin 
if (start_refclk_monitor_5_enable2) begin
    if (d_cnoc_5_count==detetction_count-'d41)    
       d_store_cnoc_clk_5_limit<= 1'b1;
    else if(d_cnoc_5_count>=detetction_count-'d3)    
       d_store_cnoc_clk_5_limit<= 1'b0;
end else begin
    d_store_cnoc_clk_5_limit<= 1'b0;
end
end
  
// edge detection
 
      syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) d_store_cnoc_clk_5_limit_sync_inst(
        .clk                       (in_coreclk_5),
        .reset                     (1'b0),
        .d                         (d_store_cnoc_clk_5_limit),
        .q                         (d_store_cnoc_clk_5_limit2)
   );
 
      syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) d_store_core_clk_5_limit_sync_inst(
        .clk                       (in_coreclk_5),
        .reset                     (1'b0),
        .d                         (start_refclk_monitor_5_enable),
        .q                         (d_start_refclk_monitor_5_enable2)
   );

always@ (posedge in_coreclk_5)
  begin
    d_store_cnoc_clk_5_limit3<=d_store_cnoc_clk_5_limit2;
  end 
 
 assign d_store_cnoc_clk_5_limit3_neg_edge = ((~d_store_cnoc_clk_5_limit2) && d_store_cnoc_clk_5_limit3) ? 1'b1 : 1'b0; 
 
   ///counter reset based on negedge of d_store_cnoc_clk_5_limit flag. 
always@ (posedge in_coreclk_5)
begin
if (d_start_refclk_monitor_5_enable2) begin
  if  (d_store_cnoc_clk_5_limit3_neg_edge) begin 
     d_refclk_5_count<= 0; 
  end else begin
     d_refclk_5_count<= d_refclk_5_count+1'b1;     
  end
end else begin
  d_refclk_5_count<= 0; 
end
end
 
///store counter based on posedge
always@ (posedge in_coreclk_5)
begin
if (d_start_refclk_monitor_5_enable2) begin
  if (d_store_cnoc_clk_5_limit3_neg_edge)
    d_refclk_5_count_store<=d_refclk_5_count;
end else  
    d_refclk_5_count_store<=0;
end
 
 
always@(posedge i_common_avmm1_clk_5) 
begin  
  refclk_fgt_enabled_5 <= refclk_fgt_enabled_5_enable;
end
//We assume (.78125% error margin)
 
`ifndef ALTERA_RESERVED_QIS
assign max_count_5=refclk_5_count_store+10;
assign min_count_5=refclk_5_count_store-10;
`else
assign max_count_5=refclk_5_count_store+(refclk_5_count_store>>7);
assign min_count_5=refclk_5_count_store-(refclk_5_count_store>>7);
`endif // ifndef ALTERA_RESERVED_QIS  
 
 
    // assign refclk_fgt_enabled_5_st =  ((d_refclk_5_count_store>=min_count_5 && d_refclk_5_count_store<=max_count_5) ? 1'b1 : 1'b0); 
always@ (posedge in_coreclk_5)
begin
 refclk_fgt_enabled_5_sample<=(d_refclk_5_count_store>=min_count_5 && d_refclk_5_count_store<=max_count_5);
 refclk_fgt_enabled_5_st<=refclk_fgt_enabled_5_sample;
end  



always@ (posedge in_coreclk_5)
begin
 if (!d_start_refclk_monitor_5_enable2) 
   in_coreclk_5_div<=0;
 else
   in_coreclk_5_div<=in_coreclk_5_div+1'b1;  
end 

 syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) in_coreclk_5_div_sync_inst(
        .clk                       (cnoc_clk),
        .reset                     (1'b0),
        .d                         (in_coreclk_5_div[1]),
        .q                         (in_coreclk_5_div_sync)
   );

always@ (posedge cnoc_clk)
begin
   in_coreclk_5_div_sync_d1<=in_coreclk_5_div_sync;
end

assign  in_coreclk_5_div_sync_edge = (in_coreclk_5_div_sync & (!in_coreclk_5_div_sync_d1));
 
always@(posedge cnoc_clk)
begin
 if (!start_refclk_monitor_5)
  count_5_cnoc_512<=0;
 else
  count_5_cnoc_512<=count_5_cnoc_512+1'b1;
end

always@(posedge cnoc_clk)
begin
   if (!start_refclk_monitor_5)
     count_5_coreclk<=0;
   else if  (count_5_cnoc_512==511)
     count_5_coreclk<=0;
   else if (in_coreclk_5_div_sync_edge)
     count_5_coreclk<= count_5_coreclk+1'b1;      
end

always@(posedge cnoc_clk)
begin
  if (!start_refclk_monitor_5)
    no_coreclk_5<=0;
  else if (count_5_cnoc_512==511 & count_5_coreclk==0)
    no_coreclk_5<=1;    
end


 syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) no_coreclk_5_div_sync_inst(
        .clk                       (i_common_avmm1_clk_5),
        .reset                     (1'b0),
        .d                         (no_coreclk_5),
        .q                         (no_coreclk_5_sync)
   );

// wait for 48 us to start monitoring
always@ (posedge in_coreclk_5)
begin
if (enable_learning_phase_5_ff2_core) begin 
   if (one_state_5_store==2)
     one_state_5_store<=one_state_5_store;
   else if (one_state_5_store <3 && d_store_cnoc_clk_5_limit3_neg_edge) 
     one_state_5_store<=one_state_5_store+1'b1;
   else if (disable_refclk_monitor_5_coreclk1)
     one_state_5_store<=0; 
end else begin
   one_state_5_store<=0;
end
end        
 
always@ (posedge in_coreclk_5)
begin
   one_state_5_store_en <= (one_state_5_store>= 2);
end
 
       syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) one_state_5_store_sync_inst(
        .clk                       (i_common_avmm1_clk_5),
        .reset                     (1'b0),
        .d                         (one_state_5_store_en),
        .q                         (d_refclk_5_count_store_en)
   );
 

       syspll_f_alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH (3),  // Number of flip-flops for retiming
      .INIT_VALUE        (0)
   ) refclk_fgt_enabled_5_st_sync_inst(
        .clk                       (i_common_avmm1_clk_5),
        .reset                     (1'b0),
        .d                         (refclk_fgt_enabled_5_st),
        .q                         (refclk_fgt_enabled_5_st2)
   );


   
  end else begin 
      assign refclk_fgt_enabled_5_st =  1'b1;
   end
endgenerate

 
 
localparam REFCLK_FGT_NUM = 10;
 
    wire [REFCLK_FGT_NUM-1:0] w_coreclk;
    assign w_coreclk = {
        in_coreclk_9,
        in_coreclk_8,
        in_coreclk_7,
        in_coreclk_6, 
        in_coreclk_5,
        in_coreclk_4,
        in_coreclk_3,
        in_coreclk_2, 
        in_coreclk_1,
        in_coreclk_0
        };
 
   for (genvar i=0;i<REFCLK_FGT_NUM;i++) begin : refclk_fgt_passthru
        localparam l_refclk_fgt_always_active =
           0 == i ? ( refclk_fgt_always_active_0 ? "TRUE" : "FALSE" )
           :
           1 == i ? ( refclk_fgt_always_active_1 ? "TRUE" : "FALSE" )
           :
           2 == i ? ( refclk_fgt_always_active_2 ? "TRUE" : "FALSE" )
           :
           3 == i ? ( refclk_fgt_always_active_3 ? "TRUE" : "FALSE" )
           :
           4 == i ? ( refclk_fgt_always_active_4 ? "TRUE" : "FALSE" )
           :
           5 == i ? ( refclk_fgt_always_active_5 ? "TRUE" : "FALSE" )
           :
           6 == i ? ( refclk_fgt_always_active_6 ? "TRUE" : "FALSE" )
           :
           7 == i ? ( refclk_fgt_always_active_7 ? "TRUE" : "FALSE" )
           :
           8 == i ? ( refclk_fgt_always_active_8 ? "TRUE" : "FALSE" )
           :
           9 == i ? ( refclk_fgt_always_active_9 ? "TRUE" : "FALSE" )
           :
           "IE"
           ;
 
        if ( enables_refclk_fgt[i] && (enables_coreclk_fgt[i] || l_refclk_fgt_always_active == "FALSE") ) begin : coreclk_enabled
            (* preserve, noprune *) reg coreclk_sdc;
            always_ff @(posedge w_coreclk[i]) begin
                coreclk_sdc <= ~coreclk_sdc;
            end
        end
    end
 
    for ( genvar i=0;i<3;i++ ) begin : gen_systempll
        if ( enables_systempll[i] ) begin : enabled
            wire in_ctrl_pll_aibrc_clock_top__pll_slice1_clk_real;
            assign in_ctrl_pll_aibrc_clock_top__pll_slice1_clk_real =
                (i==0) ? in_ctrl_pll_aibrc_clock_top__pll_0_slice1_clk_real :
                (i==1) ? in_ctrl_pll_aibrc_clock_top__pll_1_slice1_clk_real :
                (i==2) ? in_ctrl_pll_aibrc_clock_top__pll_2_slice1_clk_real :
                'bz
                ;
            (* preserve, noprune *) reg ctrl_pll_aibrc_clock_top__pll_slice1_clk_sdc;
            always_ff @(posedge in_ctrl_pll_aibrc_clock_top__pll_slice1_clk_real) begin
                ctrl_pll_aibrc_clock_top__pll_slice1_clk_sdc <= ~ctrl_pll_aibrc_clock_top__pll_slice1_clk_sdc;
            end
        end
    end
 
endmodule
 
 
 
 
 
 
 
 
 
 
 
 















