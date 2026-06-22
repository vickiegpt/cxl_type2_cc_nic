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
module  eth_f_adapter_rx #(
	parameter EHIP_RATE             = "100G",
    parameter MASK_VALID            =   1,
    parameter ENABLE_ASYNC_ADAPTERS = 1,
	parameter PREAMBLE_PASSTHROUGH  = 0,
	parameter O_DATA               = (EHIP_RATE=="100G")? 512 :(EHIP_RATE=="50G" || EHIP_RATE=="40G")? 128 : 64,
	parameter IN_LANE              = (EHIP_RATE=="100G")? 4 :(EHIP_RATE=="50G" || EHIP_RATE=="40G")? 2 : 1,
	parameter IN_LANE_ERR          = (EHIP_RATE=="100G")? 4 :  1,
	parameter EMPTY_BITS           = (EHIP_RATE=="50G" || EHIP_RATE=="40G") ? 4 :(EHIP_RATE=="100G") ?  6 : 3
)(

    input   logic               i_arst,
    input   logic               i_clear_counters,
    input   logic               i_clk_r,
    output  logic  [63:0]       o_dropped_frames,
    output  logic  [O_DATA-1:0] o_data,
    output  logic               o_valid,
    output  logic               o_sop,
    output  logic               o_eop,
    output  logic  [EMPTY_BITS-1:0]        o_empty,
    output  logic  [39:0]       o_status,
    output  logic               o_status_valid,
    output  logic  [5:0]        o_error,
    output  logic  [63:0] 	o_preamble,

    input   logic               i_clk_w,
    input   logic  [0:IN_LANE-1]        i_inframe,
    input   wire   [0:IN_LANE-1][63:0]  i_data,
    input   logic                       i_valid,
    input   wire   [0:IN_LANE-1][2:0]   i_empty,
    input   wire   [0:IN_LANE_ERR-1][1:0]   i_error,
    input   logic  [0:IN_LANE_ERR-1]        i_fcs_error,
    input   wire   [0:IN_LANE_ERR-1][2:0]   i_status,
    input   logic  [15:0]       i_min_frame_octets,
    
    // wire to ptp_adapter_rx
    output  logic  [0:IN_LANE-1]    o_dbg_filtered_if,
    output  logic                   o_dbg_filtered_if_valid

);

generate
if ((EHIP_RATE == "100G") || (EHIP_RATE == "50G") || (EHIP_RATE == "40G")) begin
         eth_f_100g_50g_adapter_rx #(
            .MASK_VALID           (MASK_VALID),
            .EHIP_RATE            (EHIP_RATE),
            .ENABLE_ASYNC_ADAPTERS(ENABLE_ASYNC_ADAPTERS),
            .PREAMBLE_PASSTHROUGH (PREAMBLE_PASSTHROUGH)
	 )i_eth_f_100g_50g_adapter_rx(
           .i_arst           (i_arst)
           ,.i_clear_counters(i_clear_counters)
           ,.i_clk_r         (i_clk_r)
           ,.o_dropped_frames(o_dropped_frames)
           ,.o_data          (o_data)
           ,.o_valid         (o_valid)
           ,.o_sop           (o_sop)
           ,.o_eop           (o_eop)
           ,.o_empty         (o_empty)
           ,.o_status        (o_status)
           ,.o_status_valid  (o_status_valid)
           ,.o_error         (o_error)
           ,.o_preamble      (o_preamble)
           ,.o_dbg_filtered_if       (o_dbg_filtered_if)
           ,.o_dbg_filtered_if_valid (o_dbg_filtered_if_valid)
                 
           ,.i_clk_w         (i_clk_w)
           ,.i_inframe       (i_inframe)
           ,.i_data          (i_data)
           ,.i_valid         (i_valid)
           ,.i_empty         (i_empty)
           ,.i_error         (i_error)
           ,.i_fcs_error     (i_fcs_error)
           ,.i_status        (i_status)
           ,.i_min_frame_octets (i_min_frame_octets)

 );
end
else if ((EHIP_RATE == "25G") || (EHIP_RATE == "10G"))  begin
	 eth_f_10g_25g_adapter_rx #(
		 .ENABLE_ASYNC_ADAPTERS(ENABLE_ASYNC_ADAPTERS)
	 
	 ) i_eth_f_sl_rx_adapter (
             .i_clk              (i_clk_w)
             ,.i_sl_async_clk_rx (i_clk_r)
             ,.i_reset           (i_arst)

             // Client interface
             ,.o_data            (o_data)
             ,.o_valid           (o_valid)
             ,.o_sop             (o_sop)
             ,.o_eop             (o_eop)
             ,.o_empty           (o_empty)
             ,.o_error           (o_error)
             ,.o_status          (o_status)

             ,.i_valid           (i_valid)
             ,.i_data            (i_data)
             ,.i_inframe         (i_inframe)
             ,.i_empty           (i_empty)
             ,.i_error           (i_error)
             ,.i_fcs_error       (i_fcs_error)
             ,.i_status          (i_status)
     ); 
     assign o_dropped_frames = 64'h0;
     assign o_status_valid   = o_valid & o_eop;
     assign o_preamble       = 64'h0;
     assign o_dbg_filtered_if       = 'd0;
     assign o_dbg_filtered_if_valid = 'd0;
end 
endgenerate

endmodule 
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q45VKnrXdpaxGItE0lSTvO9YRP1EGasEncr3vHugMw8eo/S7aWs06ET4grngkPjIELRPJDW7kMZ1dRH/20cgDte3B2HMAl0SOF/2sfpvYq2VKjVpvcU+dIuWmQf6oCSIml5hWY3Fy5hXFRaxwHoEG7XXelepjG3IAoWsScAJkH2zeJpoVNwM3O9GQ6nBCtBiXxB3bWaX49EAfK7zYPKoFper/FuzErRSpjyssZwa0+OvcfiSEhRysUqknUA7MTnyuMn+u2h45Yy+NvT0tOZtTwnj5bx0j5asfvYLJnllsspVdVuO/9zM6dXKtkCwQ/8aNtKZdM+hli/lvn4B3K8qpJgeNx4LSHUsia8FfB+Im2WpTJYYWwkP54/qo7V3XfAsBd/r6n/KxNJrCVoqz+O57AU5WgacIlkliOhFjnAqxq6bO5dzNB1txwy9DQJ5tBukDlPu+Xwoxdv8NZBhaFXvnkIFZ9gAaEzCpakVNj84IdKA08tT3Ur5aLjT5mwGOyjGOQr7VLjF1G0eoCSxFBvrl4Wovm6KtAKVwpD+FCD7+3BIIer++kARcbRoytvI9V3OCsn1b1snNzVvG3Q4tTS5Qlkq7AKGLifVtGbPQv4WT8ZlsxyzgSJZIEuaTTaUgdbKUizCcx3tbmtDDztubtnRriDsAWikZURGFNj1KoRLDky1bjdRyyWZlPDWS4GL1wzE4WlKB8XIjM2HQeHKs/7cUhK9p/IxFtzyfrMrd4eOxY1Sz0VEqFzIMnysdAlCnyrLCcNFwhWivfLyfJNYsCye07Pc"
`endif