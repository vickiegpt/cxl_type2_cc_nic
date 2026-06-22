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


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on 

module eth_f_adapter_tx #(
	parameter READY_LATENCY         = 0,
	parameter EHIP_RATE             = "100G",
	parameter ENABLE_ASYNC_ADAPTERS = 1 ,
	//parameter PREAMBLE_PASSTHROUGH  = 0,
	parameter PREAM                 = 64'hFB55_5555_5555_55D5,
	parameter I_NBLOCKS            = (EHIP_RATE == "100G") ? 8 : (EHIP_RATE == "50G" || EHIP_RATE == "40G") ? 2 : 1,
	parameter O_NBLOCKS            = (EHIP_RATE == "100G") ? 4 : (EHIP_RATE == "50G" || EHIP_RATE == "40G") ? 2 : 1,
	parameter EMPTY_BITS           = (EHIP_RATE == "100G") ? 6 : (EHIP_RATE == "50G" || EHIP_RATE == "40G") ? 4 : 3,  
	parameter PTP_WIDTH            = 1,
	parameter SIM_EMULATE          = 0
)(
    input                           i_clk_r,
    input                           i_clk_w,
    input                           i_reset,

	//Client Interface
    input                           i_preamble_passthrough_reg,
    input                  [63:0]   i_preamble,  
    input                           i_valid,
    input   [0:I_NBLOCKS-1][63:0]   i_data,
    input                           i_sop,
    input                           i_eop,
    input   [EMPTY_BITS-1:0]        i_empty,
    input                           i_error,
    input                           i_skip_crc,
    output reg                      o_ready,

    output  [0:O_NBLOCKS-1][63:0]    o_data,
    output  wire                     o_valid,
    input                            i_ready,
    output  reg [0:O_NBLOCKS-1]      o_inframe,
    output  reg [0:O_NBLOCKS-1][2:0] o_empty,
    output  reg [0:O_NBLOCKS-1]      o_error,
    output  reg [0:O_NBLOCKS-1]      o_skip_crc,
    output  reg [PTP_WIDTH-1:0]      o_ptp,
    //
    output  logic   [31:0]           o_starts_in,
    output  logic   [31:0]           o_starts_out,
    output  logic   [31:0]           o_ends_in,
    output  logic   [31:0]           o_ends_out,
    output  logic   [0:7]            o_mem_underflow
);
logic [64-1:0]                 preamble_int;

always_comb begin
  if (i_preamble_passthrough_reg == 1'b1)
    preamble_int = i_preamble;
  else
    preamble_int = PREAM;  
end

generate 
if ( EHIP_RATE == "100G" || EHIP_RATE == "50G" || EHIP_RATE == "40G") begin
     eth_f_100g_50g_adapter_tx #(
	  .EHIP_RATE  (EHIP_RATE),
	  .READY_LATENCY         (READY_LATENCY)
	  ,.ENABLE_ASYNC_ADAPTERS (ENABLE_ASYNC_ADAPTERS),
	  .SIM_EMULATE(SIM_EMULATE)
     ) i_eth_f_100g_adapter_tx (

        .i_arst            (i_reset)
//                    
        ,.i_clk_w          (i_clk_w)
	,.i_preamble       (preamble_int) 
        ,.i_data           (i_data)
        ,.i_empty          (i_empty)
        ,.i_error          (i_error)
        ,.i_sop	           (i_sop)
        ,.i_eop            (i_eop)
        ,.i_valid          (i_valid)
        ,.i_skip_crc       (i_skip_crc)
        ,.o_ready          (o_ready)
//                    
        ,.i_clk_r          (i_clk_r)
        ,.o_data           (o_data)
        ,.o_inframe        (o_inframe)
        ,.o_error          (o_error)       
        ,.o_empty          (o_empty)
        ,.o_valid          (o_valid)
        ,.o_skip_crc       (o_skip_crc)    
        ,.i_ready          (i_ready)
//
        ,.o_starts_in      (o_starts_in)
        ,.o_starts_out     (o_starts_out)   	
        ,.o_ends_in        (o_ends_in)
        ,.o_ends_out       (o_ends_out)
        ,.o_mem_underflow  (o_mem_underflow)
);
end 
else if ((EHIP_RATE == "25G") || (EHIP_RATE == "10G") )begin
	 eth_f_10g_25g_adapter_tx  #(
            .EHIP_RATE             (EHIP_RATE),
	    .READY_LATENCY         (READY_LATENCY),
            .ENABLE_ASYNC_ADAPTERS (ENABLE_ASYNC_ADAPTERS),
	    .SIM_EMULATE	   (SIM_EMULATE)
	 )i_eth_10g_25g_adapter_tx (

            .i_clk            (i_clk_r)
            ,.i_sl_async_clk_tx(i_clk_w)
            ,.i_reset          (i_reset)
//
            ,.i_valid          (i_valid)
            ,.i_data           (i_data)
            ,.i_sop            (i_sop)
            ,.i_eop            (i_eop)
            ,.i_empty          (i_empty)
            ,.i_error          (i_error)
            ,.i_skip_crc       (i_skip_crc)
            ,.o_ready          (o_ready)
                        
            ,.o_data           (o_data)
            ,.o_valid          (o_valid)
            ,.i_ready          (i_ready)
            ,.o_inframe        (o_inframe)
            ,.o_empty          (o_empty)
            ,.o_error          (o_error)
            ,.o_skip_crc       (o_skip_crc)
         );
		
         assign o_starts_in       = 'd0;
         assign o_starts_out      = 'd0;
         assign o_ends_in         = 'd0;
         assign o_ends_out        = 'd0;
         assign o_mem_underflow   = 'd0;
		
end 
endgenerate 

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q47jrf+RVm+oumQUK9oGVXIq2hNAZOnhdmuqij2EAqZhcHyD67lX5apjUadorMq4eKys3SwHQBHoADQKLcgrRFQf54nQZ95Z1kaktdRWyxcAmOjCZOCo/+bLWKhNx8eCAahdh9aDU2pIGow+REF32nqSrFEoBAMNov98iqldcKWlmSKXrSsFZMvCqPvH6f17w1cQaI25GXe7+TYporCJ4QIHuMHH/jflYefn5CvyLNfDYTQq09Q6DoNduTtotHNdGjPMC0MskWkYQF6gnWfpigx9iVJ51AcHN7QEDwB/lTAwU3HV/Y3YjA+4FM2YpPAJtbZNg8ljj4gNL72YTGFp2noGFG2fwzNwroZ78/QycAY4XUOHnQWVPRnZa3aXr6NhdR+7fsXJcY9HhCjNfidgE5QKJRBVNhgtdGq2zInmEcGEpLR7Kw3ABs8s4TZE5oMBimwsqwFrFmgRdH+EJfuVALKese+frY36KYtZEHAAP8/0tRW4qbp5eWJPh+qqyJwJ8/J3BamMQQA3ESb7rRjwQWK/6D+CijKG8r2vxrDm8vMjHBGkZ+hKmC8FbSlJBDycHomOYbe7+TQDrTEMBRwH8Fgvqa4FYe+0JGBdnsLIoiHnHDRSgo1N5DTn7ue6G0CWG7hzAKBb6S8g126d9BC6sWDSanvz2lDM9LmemyH0HPqbKrG/QtWgwHsEUbtkzwH1Mx2KxZUeCZ2OFRvnBa+8ohba0PD4Oq1JoGR294Q4sIZwdMIDiz8ZIJQG9ObdNoskHYNI4+308ZF6L/5cFqUFeocr"
`endif