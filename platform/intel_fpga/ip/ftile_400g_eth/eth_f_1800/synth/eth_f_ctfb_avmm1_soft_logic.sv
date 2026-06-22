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


//-------------------------------------------------------------------------------------------------
// Name:        ctfb_avmm1_soft_logic.sv
// Author:      Ensheng Huang
// Description: This is a simple wrapper file around the ct3_xcvr_avmm_soft_logic_core
//              This wrapper enabled support for multiple interfaces, if needed
//-------------------------------------------------------------------------------------------------

module eth_f_ctfb_avmm1_soft_logic
#(

  //PARAM_LIST_START
  parameter avmm_interfaces = 1,  //Number of AVMM interfaces required - one for each bonded_lane, PLL, and Master CGB
  parameter rcfg_enable     = 0   //Enable/disable reconfig interface in the Native PHY or PLL IP
  //PARAM_LIST_END
)  
(
  //PORT_LIST_START
  // AVMM slave interface signals (user)
  input  wire  [avmm_interfaces-1     :0] avmm_clk, 
  input  wire  [avmm_interfaces-1     :0] avmm_reset,   
  input  wire  [avmm_interfaces*8-1   :0] avmm_writedata, 
  input  wire  [avmm_interfaces*10-1  :0] avmm_address,    // addr[9:8], 2'b11 for MAIB, rest for F-tile, addr[8] is Dword Access
  input  wire  [avmm_interfaces*9-1   :0] avmm_reservedin, //For F-tile high address bits
  input  wire  [avmm_interfaces-1     :0] avmm_write,
  input  wire  [avmm_interfaces-1     :0] avmm_read,
  output reg   [avmm_interfaces*8-1   :0] avmm_readdata, 
  output wire  [avmm_interfaces-1     :0] avmm_waitrequest,
  // Signals from AVMM1 building block
  input  wire  [avmm_interfaces-1     :0] pld_avmm1_busy_real,
  input  wire  [avmm_interfaces-1     :0] pld_avmm1_cmdfifo_wr_full_real,
  input  wire  [avmm_interfaces-1     :0] pld_avmm1_cmdfifo_wr_pfull_real,
  input  wire  [avmm_interfaces*8-1   :0] pld_avmm1_readdata_real,
  input  wire  [avmm_interfaces-1     :0] pld_avmm1_readdatavalid_real,
  input  wire  [avmm_interfaces*3-1   :0] pld_avmm1_reserved_out_real,
  input  wire  [avmm_interfaces-1     :0] pld_chnl_cal_done_real,
  input  wire  [avmm_interfaces-1     :0] pld_hssi_osc_transfer_en_real,
  // Signals to AVMM1 building block
  output wire  [avmm_interfaces-1     :0] pld_avmm1_clk_rowclk_real,
  output wire  [avmm_interfaces-1     :0] pld_avmm1_read_real,
  output wire  [avmm_interfaces*10-1  :0] pld_avmm1_reg_addr_real,
  output wire  [avmm_interfaces-1     :0] pld_avmm1_request_real,
  output wire  [avmm_interfaces*9-1   :0] pld_avmm1_reserved_in_real,
  output wire  [avmm_interfaces-1     :0] pld_avmm1_write_real,
  output wire  [avmm_interfaces*8-1   :0] pld_avmm1_writedata_real
  //PORT_LIST_END
);
 

generate
genvar ig;
for(ig=0;ig<avmm_interfaces;ig=ig+1) begin : avmm_if_soft_logic

assign pld_avmm1_clk_rowclk_real[ig]       =  avmm_clk[ig];
assign pld_avmm1_read_real[ig]             =  avmm_read[ig];
assign pld_avmm1_reg_addr_real[ig*10 +:10] =  avmm_address[ig*10 +:10];
assign pld_avmm1_reserved_in_real[ig*9 +:9]=  avmm_reservedin[ig*9 +:9];
assign pld_avmm1_writedata_real [ig*8 +:8] =  avmm_writedata[ig*8 +:8];

eth_f_ctfb_avmm_maib_if
#(
   //The soft logic core has logic for handling cases related to both avmm1 and avmm2
   //This instantiation only looks as logic related to AVMM1
   .avmm_interface_type        ("avmm1"                         ),           
   .rcfg_enable                (rcfg_enable                     )
) 
ctfb_avmm_maib_if_inst (
   //Inputs
   .avmm_clk                   ( avmm_clk            [ig]        ),
   .avmm_reset                 ( avmm_reset          [ig]        ),
   .avmm_writedata             ( avmm_writedata      [ig*8+:8]   ), 
   .avmm_address               ( {2'b0, avmm_reservedin[ig*9+:9], avmm_address[ig*10+:10]}),
   .avmm_write                 ( avmm_write          [ig]        ),
   .avmm_read                  ( avmm_read           [ig]        ),
   .avmm_readdata_int          ( pld_avmm1_readdata_real         [ig*8+:8]   ),
   .avmm_readdatavalid         ( pld_avmm1_readdatavalid_real    [ig]        ),
   .avmm_cmdfifo_pfull         ( pld_avmm1_cmdfifo_wr_pfull_real [ig]        ),
   .avmm_busy                  ( pld_avmm1_busy_real             [ig]        ),
   .avmm_reservedout           ( pld_avmm1_reserved_out_real     [ig*3+:3]   ),
   .avmm_writedone             ( 1'b0 /*not used for AVMM1, used reservedout[1] instead*/     ),
   //Outputs
   .avmm_readdata              ( avmm_readdata                  [ig*8+:8]   ), 
   .avmm_waitrequest           ( avmm_waitrequest               [ig]        ),
   .avmm_request               ( pld_avmm1_request_real         [ig]        ),
   .soft_avmm_write            ( pld_avmm1_write_real           [ig]        ),
   .soft_avmm_read             ( /*not used for AVMM1*/          )
);

end //end for begin
endgenerate

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "o2ONPYJ6JWO2K/lQHkyApXo6DVczB8sUyJtLpEiYtF7LL07s93qi8rQ7d2s1AdTOt/BNVdBoSTLCdACDT58BR3umvYuucV6Cbb36lNsOsJegwtedOJsDvTnB14ZLU41EvDEX+uxr7iJUYiTmn7hunq22K1+T/Nc7+FaTNr6AMH3CCuiZmo/CmXjVXLRPwF034Kg1mVvlsNTpZhm0ORjPpNI8tuMP0bMp6HLhHMKVKvcY9vj6NLSiJ/L/8wlB1J4y21EplJV70S4z+AefzE+h0tju5pFtXPodhXvsce3Breyn6SQ9Xjdi7InStBFXxlJjMRHwbDvKZ7p2XAC0WXjdWAFWLUGOYeVd8xo7lOxVv1Y3PjdJ8pjyUEYeS/z9Dmkx2P/XmQB1lyEkN9u1mTM00YU6VKvCl+hPK9+e4DIwIOEplKhWrlZDAaqenvwllrRM/tvbYOnFANEWkzQHApRrfnu6RDwpmtl+XJ5fl205ltUnfrMiD/iUl1x7mexxWORuCdjKvuwFL+j6ST1ETgYaPs587OawGFNZbwBjNpuVxp/WznrrRlw0qMDvDGJy+UnrNMz/PMSfJ6cHjB8i9nw9IUSenhIUm7D1YpOMiGDL2s4VGlyQO7V5BUZQEPjZc2HE1+e9Awafg0V4Hsyj6i6puV2ORV4pW1YzzOMSL/WzHBNc6f/mDGNM4ioPOloiiYdScOdM7VWDdoGCHlxtqL+oz4ObqSXECgKCJZvkWxB2bRlFgnxwmq6NAAEcrGmEpy0jYDV4d7l609pzUCJcxo2kKwYKbYtsPeCq0v/Mv1RM7T+9mNO0RSiViolxYMyINuD56U9uiODvm0n6BzBgZwVN+ycih9RCm9Hc6iClArc3G0PXrclP1CaN7hAU6LQUJRK7Mv9A2LH9LIFOxBT/B2hij1xKoNTBlvTGk014GWLfhExcy29LSHVGahi6bT3Ih1Q4sFXZk1dTOny2AjfGMvBB835TMEjABnaEoTF/RKpJNGEVG2PtGcdG5LO0gQboF1XS"
`endif