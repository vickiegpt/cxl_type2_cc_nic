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
module eth_f_ready_gen_100g_s #(
    parameter READY_LATENCY         = 0,
	parameter EHIP_RATE             = "100G",
	parameter OUTBLOCKS 		    = 4, 
	parameter MEMBLOCKS 			=  8 ,
    parameter MEMDEPTH  			= 'd32 ,
	parameter COMP                 = (EHIP_RATE == "100G") ? 8'd8 : 8'd2,
    parameter O_READY_USED         = (EHIP_RATE == "100G") ? 8'd11 : 6'd5
) (
    input   logic                    i_reset,
    input   logic                    i_clk,
    input   logic   [OUTBLOCKS-1:0]  i_num_write,
    input   logic                    i_read,
    output  logic                    o_ready
);

    logic   [$clog2(MEMDEPTH)+$clog2(MEMBLOCKS)-1:0]  num_write;
    logic   [$clog2(MEMDEPTH)+$clog2(MEMBLOCKS)-1:0]  num_read;
    logic   [$clog2(MEMDEPTH)+$clog2(MEMBLOCKS)-1:0]   num_add;
    logic   [$clog2(MEMDEPTH)+$clog2(MEMBLOCKS)-1:0]   num_remove;

    logic   [$clog2(MEMDEPTH)+$clog2(MEMBLOCKS)-1:0]  used;
    logic           ready_delay;

generate 
	if (EHIP_RATE == "100G") begin
		assign num_read     = {5'd0, i_read, 2'd0};
	end
	else begin
	    assign num_read     = {4'd0, i_read, 1'b0};
	end	
endgenerate

    assign num_write    = {4'd0, i_num_write};
    
    assign num_add      = ready_delay ? 8'd0 : COMP;
    assign num_remove   = o_ready ? 8'd0 : COMP;
	
generate 
if (EHIP_RATE == "100G") begin
    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            used <= 8'd0;
        end else begin
            used <= 8'(used + num_write + num_add - num_read - num_remove);
        end
    end
end
else begin
always_ff @(posedge i_clk) begin
        if (i_reset) begin
            used <= 6'd0;
        end else begin
            used <= 6'(used + num_write + num_add - num_read - num_remove);
        end
    end
end
endgenerate
	
    assign o_ready = (used < O_READY_USED);

    eth_f_delay_reg #(
        .CYCLES (READY_LATENCY),
        .WIDTH  (1)
    ) dv (
        .clk    (i_clk),
        .din    (o_ready),
        .dout   (ready_delay)
    );

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q477NKssCHMGjcSDdbo3bGRRstVS3Nk3ecC5rEzYTFyUpIHB90emiFmghCvF3y9WNmi1rTrKRb6fNTIun0WJmZEfNx/GbtkHpUMTbnihTorcUDxQAp6bXKnvBm954cDxhI+5dnnLuoL+d1T+RbajKhiiDjWWZHYeqMRNSppOeDidiweK+vXhwemFPnUJT3csJ317PUI62iJFNMjYHCF0Dgf2X0LpUEjrA1RAzyQZNXcz/QyWFy+cjSuHs0OISlUdaYvehhsjVtO+mWE0FVHDuDGAFVJOiP2I3o2o8YTpfgWpfJ0QY037ZN6brQEt/xFRI7c4UBwZJTa7TddNZ6LzPtday7klWxOhgW9JfHdkaNzYlFp6bETJYT9VlTUO0+bBtZ+FQ3B/b6n3XnqihMl4f2kntccbiSb3nvkdeh21BtMmmMwfV+eVgC8e7UIM4ah8f3ub4ZTBV4tX3yetC5h4RurGLhYVLsna4u0x7PiFEWasI3mr3FDflRhjfTZVDCmvNFDWFTv2wlappshlaYaRYiSpeZALG4SeVz98nvXtDx2QwHRF35xlp34hGkZhCA5RqiiSRdkGfUR1E9lFnbG5plk30t39umvOre91UBYSjHkYO4UPeIJnxAineTzMfQSGTqmfA6A5JPwi9YVLk6ic1WGuRrJOyHrd+xd/kd3KzwmlZAyTxvVtTW/tnrGq+BXujS0yDLbWqBh71GG0uBbxJPIJYLFbardCm+IddaCc0jm7cu43V1Sz/PNyy5Awu7D/oMh0I5q6O6uhpZLIXoKGkETJ"
`endif