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

module eth_f_stats_tx100a #(
	parameter ENABLE_ASYNC_ADAPTERS = 1,
	parameter SIM_EMULATE = 1'b0) 
	(
    input   logic               i_reset_r,
    input   logic               i_reset_w,
    input   logic               i_clk_r,
    input   logic               i_clk_w,
    input   logic               i_valid_in,
    input   logic               i_valid_out,
    input   logic               i_sop,
    input   logic               i_eop,
    input   logic   [0:3]       i_inframe,
    input   logic               i_mem_read,
    input   wire    [0:1][4:0]  i_read_pointers,
    input   wire    [0:7][4:0]  i_write_pointers,
    output  logic   [31:0]      o_starts_in,
    output  logic   [31:0]      o_starts_out,
    output  logic   [31:0]      o_ends_in,
    output  logic   [31:0]      o_ends_out,
    output  logic   [0:7]       o_mem_underflow
);

   genvar i;
    logic           start_in;
    logic           end_in;
    logic   [1:0]   starts_out;
    logic   [1:0]   ends_out;
    logic           if_last;

    logic   [0:3]   sop;
    logic   [0:3]   eop;

    logic   [0:7]   ptrs_equal;
    logic           mem_read_r2;

    logic   [0:7][5:0]  write_pointers_sync1;
    logic   [0:7][4:0]  write_pointers_sync;
	logic               r_clk;

    assign sop = i_inframe & ~{if_last, i_inframe[0:2]};
    assign eop = {if_last, i_inframe[0:2]} & ~i_inframe;
	
	generate
		if (ENABLE_ASYNC_ADAPTERS)
			assign r_clk = i_clk_r;
		else 
			assign r_clk = i_clk_w;
	endgenerate

    generate
        for (i = 0; i < 8; i++) begin : ptr_loop
            eth_f_pointer_synchronizer #(
                .WIDTH      (5+1),
		.SIM_EMULATE(SIM_EMULATE)  
            ) sync_w_ptrs (
                .clk_in     (i_clk_w),
                .ptr_in     ({1'b0,i_write_pointers[i]}),
                .clk_out    (i_clk_r),
                .ptr_out    (write_pointers_sync1[i]) ///added for width matching
            );
			
			assign write_pointers_sync[i] = write_pointers_sync1[i][4:0];

            always_ff @(posedge i_clk_r) begin
                ptrs_equal[i]   <= write_pointers_sync[i] == i_read_pointers[i[2]];
            end
        end
    endgenerate

    always_ff @(posedge i_clk_r) begin
        mem_read_r2     <= i_mem_read;
        if (i_reset_r) begin
            o_mem_underflow <= 8'b00000000;
        end else begin
            o_mem_underflow <= mem_read_r2 ? o_mem_underflow | ptrs_equal : o_mem_underflow;
        end
    end

 

    always_ff @(posedge i_clk_r) begin
        if (i_reset_r) begin
            o_starts_out    <= 32'd0;
            o_ends_out      <= 32'd0;
        end else begin
            o_starts_out    <= 32'(o_starts_out + starts_out);
            o_ends_out      <= 32'(o_ends_out   + ends_out);
        end
    end

    always_ff @(posedge i_clk_w) begin
        if (i_reset_w) begin
            o_starts_in     <= 32'd0;
            o_ends_in       <= 32'd0;
        end else begin
            o_starts_in     <= 32'(o_starts_in  + start_in);
            o_ends_in       <= 32'(o_ends_in    + end_in);
        end
    end

    always_ff @(posedge i_clk_r) begin
        if (i_valid_out) begin
            case (eop)
                4'b0001 : ends_out <= 2'd1;
                4'b0010 : ends_out <= 2'd1;
                4'b0100 : ends_out <= 2'd1;
                4'b1000 : ends_out <= 2'd1;
                4'b0101 : ends_out <= 2'd2;
                4'b1001 : ends_out <= 2'd2;
                4'b1010 : ends_out <= 2'd2;
                default : ends_out <= 2'd0;
            endcase
        end else begin
            ends_out <= 2'd0;
        end
    end

    always_ff @(posedge i_clk_r) begin
        if (i_valid_out) begin
            case (sop)
                4'b0001 : starts_out <= 2'd1;
                4'b0010 : starts_out <= 2'd1;
                4'b0100 : starts_out <= 2'd1;
                4'b1000 : starts_out <= 2'd1;
                4'b0101 : starts_out <= 2'd2;
                4'b1001 : starts_out <= 2'd2;
                4'b1010 : starts_out <= 2'd2;
                default : starts_out <= 2'd0;
            endcase
        end else begin
            starts_out <= 2'd0;
        end
    end

    always_ff @(posedge r_clk) begin
        if (i_reset_r) begin
            if_last <= 1'b0;
        end else begin
            if (i_valid_out) begin
                if_last <= i_inframe[3];
            end else begin
                if_last <= if_last;
            end
        end
    end

    always_ff @(posedge i_clk_w) begin
        start_in  <= i_sop && i_valid_in;
        end_in  <= i_eop && i_valid_in;
    end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q44MNgdreNWKXWj7JUrHSVynHgteORdGOF1YEupKYazCwkT9nXaXfJhuxOtOBO+UazYDEdh97DmWUXU11fFAQee0eiG0HSfhrJT2hq93waCfwMsDUMIic764pVq87vl8xo9yx00tOw+8Gwa2d7O9YFLv0o/mrXdfZ9Nonvg7wBsDyUmHxueuIhW+rZAGS2eMdGX0we83sp1ywrb37myAVJkPJYdKrRm6jeGOYi0MLscNoE/gfkvWS7jYnnUqp/V+rAGrcxVfe+QeOS2Wpu0UZh9I4t5oLWkzbBwG2Ww9PrTgA9nCBHVGmn81uSzm6jAJ7BHkozJWeLgNFpeUMCl52dry2by3J1qyaRdod9x+ncKtKur93hlZcbJaM73/5e9OHp4Use5dXmcPr48xwJU7dbuVIOBjWmZaTqaXjZtOX6O7dNt5qrM05+R/gYtZy5R7438r3lutcmzZpbddWe4StlGNTYEoAHygRCiJbHk1VruelOTrOtTb8zwGnFJxfSOyqdj48WGXb+diCur735AXQag5DZqpY42W2TRFwQIPlLlSWbEfW0evelb2OojgdObpsk8+09zbtrzDGEU5JPchk+ZKT7CnzrdOWj3CB5FYPib9WEqDbi0y66VjJDMNBYhmaa7gvtZRqlWk5EwjJk310+OzwsMCsseDbvMg6FUVqugTc9BYG82ZltAQOZCRbuWX76XysVt+oFvn9NPOQpEujIb54O0PdyhkSrz2tOTUBnYOXP0IuedKZJ+AHvS9s2YEo5LNkAEdqYdZT396Uc9UC3zA"
`endif