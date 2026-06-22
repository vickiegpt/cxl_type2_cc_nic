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
module eth_f_ready_gen_100g_a #(
    parameter READY_LATENCY         = 0,
	parameter EHIP_RATE             = "100G",
	parameter OUTBLOCKS             = 4,
	parameter MEMBLOCKS             = 8,
    parameter MEMDEPTH              = 'd32,
	parameter COMP1                = (EHIP_RATE == "100G") ? 8'd8 : 8'd2,
	parameter VIRTUAL_USED_PRAM    = (EHIP_RATE == "100G") ? 8'd39 : 6'd17	
) (
    input   logic                     i_reset,
    input   logic                     i_clk,
    input   logic   [OUTBLOCKS-1:0]   i_num_write,
    input   logic   [5:0]             i_read_ptr,
    output  logic                     o_ready
);

    logic   [$clog2(MEMDEPTH)+$clog2(MEMBLOCKS)-1:0]   virtual_writes;
    logic   [$clog2(MEMDEPTH)+$clog2(MEMBLOCKS)-1:0]   virtual_used;
    logic           partial_full;
    logic           ready_delay;

    logic   [$clog2(MEMDEPTH)+$clog2(MEMBLOCKS)-1:0]   num_add;
    logic   [$clog2(MEMDEPTH)+$clog2(MEMBLOCKS)-1:0]   num_remove;

generate 
	if (EHIP_RATE == "100G") begin
		assign virtual_used = 8'(virtual_writes - {i_read_ptr,2'd0});
	end
	else begin
	    assign virtual_used = 6'(virtual_writes - {i_read_ptr[4:0], 1'b0});
	end	
endgenerate
 


    assign partial_full = (virtual_used >= VIRTUAL_USED_PRAM);
    assign o_ready      = !partial_full;

	 assign num_add      = ready_delay ? 8'd0 : COMP1;
    assign num_remove   = o_ready ? 8'd0 : COMP1;

generate	
if (EHIP_RATE == "100G") begin
  always_ff @(posedge i_clk) begin	  
			if (i_reset) begin
				virtual_writes  <= 8'd0;
			end 
			else begin
				virtual_writes  <= 8'(virtual_writes + i_num_write + num_add - num_remove);
			end
	end
end
else begin
    always_ff @(posedge i_clk) begin
			if (i_reset) begin
				virtual_writes <= 6'd0;
			end 
			else begin
				virtual_writes <= 6'(virtual_writes + i_num_write + num_add - num_remove);
			end
	end
end	     
endgenerate

    eth_f_delay_reg #(
        .CYCLES (READY_LATENCY),
        .WIDTH  (1)
    ) delay_rdy_fb (
        .clk    (i_clk),
        .din    (o_ready),
        .dout   (ready_delay)
    );
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q44/KLjO/WXs37Nz8ACWiDJW4pQvyqLyR3SzSvR4fei/s34Jk+0LPLqY9k36K6VR2k9D1mUQmlV4C3Hre2vybJmiH9hsmnQqr1Tp4jJ6k+ZvolvUHLfcNxxMgoSJdjj6iEOhpVlcCsz+7C+pWeXxzkeJbUCDS2Z2KHE9D3csPhq2u2q08iUTyCL4QBI8ITKQ9aLv6LZE8IAnO1vrerHtGgxpv++dTL3lPMkrs+ETJ9Pq2KTcXmrLvpBhmeFtEh17E3r2L+patx4UXGtJVuK1b0pSATzCLVxeG0aLZD+lSIbNq9qnk+eBvBjyZPizq0Vs9qOeNhl7rMdqfoUwGFzBVRBU0vrkZ2uEYLME76dy4Xg3/Aid0GyHaBGNpmAC7opxxgbHSnjFrcstwqVVPSmdFUB2uhKB5ZxVdMAHySmtaPNrg+B2ouxjTwQ+PVMaNHnn27Snz2UIm0XhfEvJ6xsFLinsyi5A5c387FGm+ydI3wW1mGqKuXUvcM8ju8YhuZzqdSndeLM3n+W2/U/0L/8zARfPNTUFiffL3wogVWTlKHP1/pRVAnMwxI+o4Ok8+Rxq819ruFPR/1gOvKOxTH2C5fdd9LerLXek5gqbTaszhewqkoIexFxyZeBpi2TxNZKm+6lKs7uJYrjrY8anIaw1glrTiMWOZ8as/qWSEhYSxjklLR06pQuXxxwUMPUC9Gv4+AsQvXhSB/1iq25xMT94NVcK/twLAtIIeUv9bsvXcBCS43pWuq40mWL01Jjitnug4UgOUW3mtUGvFvTxpSKfDUEO"
`endif