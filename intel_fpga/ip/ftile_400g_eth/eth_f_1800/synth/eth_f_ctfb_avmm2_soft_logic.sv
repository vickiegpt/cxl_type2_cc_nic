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
// Name:        ctfb_avmm2_soft_logic.sv
// Author:      Ensheng Huang
// Description: This is a multi-channel wrapper file that connects agx_f avmm building blocks
//              or hip, to ct3_avmm_soft_logic_core.
//-------------------------------------------------------------------------------------------------
 
module eth_f_ctfb_avmm2_soft_logic
#(
  parameter avmm_interfaces                  = 1,                        //Number of AVMM interfaces required - one for each bonded_lane, PLL, and Master CGB
  parameter rcfg_enable                      = 0                        //Enable/disable reconfig interface in the XCVR PMA or PCIe IPs
) (
  // AVMM slave interface signals (user)
  input  wire  [avmm_interfaces-1     :0] avmm_clk,
  input  wire  [avmm_interfaces-1     :0] avmm_reset,
  input  wire  [avmm_interfaces*8-1   :0] avmm_writedata, 
  input  wire  [avmm_interfaces*21-1  :0] avmm_address, // Same address width as shown in avmm2 atom
  input  wire  [avmm_interfaces-1     :0] avmm_write,
  input  wire  [avmm_interfaces-1     :0] avmm_read,
  output reg   [avmm_interfaces*8-1   :0] avmm_readdata, 
  output wire  [avmm_interfaces-1     :0] avmm_waitrequest,
  //AVMM interface busy with calibration
  output wire  [avmm_interfaces-1     :0] avmm_busy,
     
  // Expose clkchnl to wire up with pld_adapt avmmclk for Place and Route in Fitter
  output  wire  [avmm_interfaces-1    :0] avmm_clkchnl,
 
  // ports to/from hip ports of building block
  output wire  [avmm_interfaces-1     :0]  hip_avmm_read_real,
  input  wire  [avmm_interfaces*8-1   :0]  hip_avmm_readdata_real,
  input  wire  [avmm_interfaces-1     :0]  hip_avmm_readdatavalid_real,
  output wire  [avmm_interfaces*21-1  :0]  hip_avmm_reg_addr_real,
  input  wire  [avmm_interfaces*5-1   :0]  hip_avmm_reserved_out_real,
  output wire  [avmm_interfaces-1     :0]  hip_avmm_write_real,
  output wire  [avmm_interfaces*8-1   :0]  hip_avmm_writedata_real,
  input  wire  [avmm_interfaces-1     :0]  hip_avmm_writedone_real,
  input  wire  [avmm_interfaces-1     :0]  pld_avmm2_busy_real,
  output wire  [avmm_interfaces-1     :0]  pld_avmm2_clk_rowclk_real,
  input  wire  [avmm_interfaces-1     :0]  pld_avmm2_cmdfifo_wr_full_real,
  input  wire  [avmm_interfaces-1     :0]  pld_avmm2_cmdfifo_wr_pfull_real,
  output wire  [avmm_interfaces-1     :0]  pld_avmm2_request_real,
  input  wire  [avmm_interfaces-1     :0]  pld_pll_cal_done_real,
  // below are unused ports in hip mode
  output wire  [avmm_interfaces-1     :0]  pld_avmm2_write_real,
  output wire  [avmm_interfaces-1     :0]  pld_avmm2_read_real,
  output wire  [avmm_interfaces*9-1   :0]  pld_avmm2_reg_addr_real,
  input  wire  [avmm_interfaces*8-1   :0]  pld_avmm2_readdata_real,
  output wire  [avmm_interfaces*8-1   :0]  pld_avmm2_writedata_real,
  input  wire  [avmm_interfaces-1     :0]  pld_avmm2_readdatavalid_real,
  output wire  [avmm_interfaces*6-1  :0]  pld_avmm2_reserved_in_real,
  input  wire  [avmm_interfaces-1   :0]  pld_avmm2_reserved_out_real
 
 );
 
//****************************************************
//                   SIGNALS
//****************************************************
wire  [avmm_interfaces-1  :0]   avmm_readdatavalid;
wire  [avmm_interfaces-1  :0]   avmm_request;
wire  [avmm_interfaces*8-1:0]   avmm_readdata_int;
wire  [avmm_interfaces-1  :0]   avmm_cmdfifo_pfull;
wire  [avmm_interfaces*3-1  :0] avmm_reservedout;
wire  [avmm_interfaces-1  :0]   avmm_writedone;
wire  [avmm_interfaces-1  :0]   soft_avmm_read;
wire  [avmm_interfaces-1  :0]   soft_avmm_write;
 
 
assign  hip_avmm_reg_addr_real    =   avmm_address;
assign  hip_avmm_writedata_real   =   avmm_writedata;
assign  pld_avmm2_clk_rowclk_real =   avmm_clk;
assign  avmm_clkchnl              =   avmm_clk;

assign avmm_busy = '0; //no driver, assign 0
 
// Connect the AVMM2 building block to soft logic per interface
generate
genvar ig;
for( ig=0; ig<avmm_interfaces; ig=ig+1 ) begin : avmm_sip_insts
 
   assign  avmm_reservedout             [ig*3  +: 3]   =   3'h0;
   
   // Use the common soft logic module, parameterized for AVMM2
   eth_f_ctfb_avmm_maib_if
   #(
   .avmm_interface_type        ("avmm2"                         ),           
   .rcfg_enable                (rcfg_enable                     )
   ) agx_xcvr_avmm_soft_logic_inst (
   //Inputs
   .avmm_clk                   (avmm_clk            [ig]        ),
   .avmm_reset                 (avmm_reset          [ig]        ),
   .avmm_writedata             (avmm_writedata      [ig*8+:8]   ), 
   .avmm_address               (avmm_address        [ig*21+:21] ),
   .avmm_write                 (avmm_write          [ig]        ),
   .avmm_read                  (avmm_read           [ig]        ),
   .avmm_readdata_int          (hip_avmm_readdata_real   [ig*8+:8]   ),
   .avmm_readdatavalid         (hip_avmm_readdatavalid_real  [ig]     ),
   .avmm_cmdfifo_pfull         (pld_avmm2_cmdfifo_wr_pfull_real  [ig] ),
   .avmm_busy                  (pld_avmm2_busy_real       [ig]        ),
   .avmm_reservedout           (avmm_reservedout    [ig*3+:3]   ),
   .avmm_writedone             (hip_avmm_writedone_real [ig]    ),
   //Outputs
   .avmm_readdata              (avmm_readdata       [ig*8+:8]   ), 
   .avmm_waitrequest           (avmm_waitrequest    [ig]        ),
   .avmm_request               (pld_avmm2_request_real [ig]     ),
   .soft_avmm_write            (hip_avmm_write_real    [ig]     ),
   .soft_avmm_read             (hip_avmm_read_real     [ig]     )  //Specific to AVMM2
 );
 
   assign  pld_avmm2_write_real         [ig]      = 1'b0;
   assign  pld_avmm2_read_real          [ig]      = 1'b0;
   assign  pld_avmm2_reg_addr_real      [ig*9+:9] = 9'h0;
   assign  pld_avmm2_writedata_real     [ig*8+:8]      = 8'b0;
   assign  pld_avmm2_reserved_in_real [ig*6+:6] = 6'h0;
 
 
end //  for each interface
endgenerate
 
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "o2ONPYJ6JWO2K/lQHkyApXo6DVczB8sUyJtLpEiYtF7LL07s93qi8rQ7d2s1AdTOt/BNVdBoSTLCdACDT58BR3umvYuucV6Cbb36lNsOsJegwtedOJsDvTnB14ZLU41EvDEX+uxr7iJUYiTmn7hunq22K1+T/Nc7+FaTNr6AMH3CCuiZmo/CmXjVXLRPwF034Kg1mVvlsNTpZhm0ORjPpNI8tuMP0bMp6HLhHMKVKvf4U+nmVGC8/NOcXdb1gZDuPvssQ4omy8FVpCtrkc8NlZOFYok8OGlosT4Kc+yq1vHNuP9ecTGmFt9qmB5v3LedmZzSgwEb50bhFNxRs5ynZC07nYdgdOs9DvaMEsQDgOavUgAadyyEOc4CO9tgagEPHxhvlAeVqX+wCI58YR9ujjeNGeqUZSwyfLAO3+SAcZEcUwlGsbilqiVtUmkG2+8Fkqqd3dfDzGuVmh3TXqmp+n1WdV08S1A/YtaCbBtTptCf6QrvLC4560ODDK98JP6t6gy4BcTM/ztxnEQbbiW5rjjYGxVzXA3hT66e3/glN2OiQpxMHSBO0eN748mrSkYWzhH3T4d8r1OsdBjFnqVtxJ1xrwFVkcfS1eBWZaR7DBG39ZnbuawhJDVWSsSuwrCeTlwYZX7VebXiBWbTXf5M5fByHPdS+oyHXXsX57MK79sy2OLXf3sT7cuwghqRc/38q9hNDbETNPRfyT3QXGzPlzIa6sqhpvbwzVV/NsbmttEKDWcCZRmrdN4ZJAJXwvAVH4EbkXblH5sVK1DGJSeAVQyUKFTMFwfZbRTwNl5L1jf8n1VOhtPl0vew/hL4DWLwQBNVA15BxuuEMd4ZaPKvfErwIpuP6ZbgCGmWe6iV2n9evK5zCFoLe1FN3khN0P1jMDNYZxk79Q1Mww0+3d/3S3aKrvHpfpheRroQXUdg4fz2D3dhqpaR5O0NkV657AgaIndxC71q3HbslBInGAusderVWoczlBPjoHTgbOoeKbdoUYupJa3qj4FqXf6AW92b"
`endif