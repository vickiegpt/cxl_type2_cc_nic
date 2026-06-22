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

module eth_f_stats_txpp50s (
    input   logic               i_reset,
    input   logic               i_clk,
    input   logic               i_valid_in,
    input   logic               i_valid_out,
    input   logic               i_sop,
    input   logic               i_eop,
    input   logic   [0:1]       i_inframe,
    output  logic   [31:0]      o_starts_in,
    output  logic   [31:0]      o_starts_out,
    output  logic   [31:0]      o_ends_in,
    output  logic   [31:0]      o_ends_out
);

    genvar i;

    logic           start_in;
    logic           end_in;
    logic           starts_out;
    logic           ends_out;
    logic           if_last;

    logic   [0:1]   sop;
    logic   [0:1]   eop;

    assign sop = i_inframe & ~{if_last, i_inframe[0]};
    assign eop = {if_last, i_inframe[0]} & ~i_inframe;

    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            o_starts_out    <= 32'd0;
            o_ends_out      <= 32'd0;
            o_starts_in     <= 32'd0;
            o_ends_in       <= 32'd0;
        end else begin
            o_starts_out    <= 32'(o_starts_out + starts_out);
            o_ends_out      <= 32'(o_ends_out   + ends_out);
            o_starts_in     <= 32'(o_starts_in  + start_in);
            o_ends_in       <= 32'(o_ends_in    + end_in);
        end
    end

    always_ff @(posedge i_clk) begin
        if (i_valid_out) begin
            case (eop)
                2'b01   : ends_out <= 1'd1;
                2'b10   : ends_out <= 1'd1;
                default : ends_out <= 1'd0;
            endcase
        end else begin
            ends_out <= 1'd0;
        end
    end

    always_ff @(posedge i_clk) begin
        if (i_valid_out) begin
            case (sop)
                2'b01   : starts_out <= 1'd1;
                2'b10   : starts_out <= 1'd1;
                default : starts_out <= 1'd0;
            endcase
        end else begin
            starts_out <= 1'd0;
        end
    end

    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            if_last <= 1'b0;
        end else begin
            if (i_valid_out) begin
                if_last <= i_inframe[1];
            end else begin
                if_last <= if_last;
            end
        end
    end

    always_ff @(posedge i_clk) begin
        start_in  <= i_sop && i_valid_in;
        end_in  <= i_eop && i_valid_in;
    end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "IHWHrFSUaPtjZF1LBDe+5u/fCSc0//dMeoOgG/ez60Rt84WK1OI/WsMDAOmCm2IklwNYebRgS3zVDw7MPxWxM11LRVdkLZ+X/y8WtfqnS7Duroraj/37v+2WHhkPuM7Zr5jlblPypJOlE04iTTEfu+W3Q6H2vZl2TlAJ75jp9EioCxq3Erh26V4am36iNzJ8q9nPT5rffTeZv2243MrLgLaBmit/Byil0W+B47PrapWjXXjW+0Zu/nRRhjw21mndM5tS0/Vf8WDAsOCLZH3gkqwGXQVekTAdjmo+53SX2kDed2TpuGQxDqx4mBZb0TFwLxJrsfYww4SMnmWiArODaNXSC+SEICF2SOHbPpRmqW0LYV/4T4S3zxjr17LHmHdO/Ngjsk9mLgo2c6dfmJFG6LQJaxkjxRPBAqrv8zVC1Q7e7A+tfTdqzDqlouNiRViORgn0+2xuLzgYtC7YjcXax6kOLQgZreATm6UzTfm/+hmQaxPMP54MzFAwwHIvcdSHobrjZceFC4Wfb7LE/uP7foL6H9ENHs9P+LPBThl4KXp+ci0qigL9Yx4FYNsQahKKzzeEx9hV1FMUfV6pcgWCdzuNtFKsFJXehTrROuTURrX08ihe7BZ3Y/DxM5HSe+Yd3vClWHkizpmpQvN9OR2AwPNPYgHhpeG+xdmSjv/85mk7VviSqjpCPCObzZEw1OHNh1heqI6XLK6x3feApchHKSaHo1gnoEQhkq6xAoUy4y3eVxxcmPyw9QfhuZywv8QfgiGTUyezJAvRIRcs/brfpufKIWKI5M+cHLBPzFPrwsPQp0s7z7MI8VCLMJBFtANi/BHkKiGU7mbAgS51rw863ajZ/AHYjN+5Fmwo9YwRPH+hMkrUjI6F4C4TNbYg4gDiqJ383PPBCaE+NCVd56ymLTX9vX2k0FnC0k6+2Fyr1Aq9luZyBcFzdidXKf29H4pToVud4jaMjqdz+BYbKwg1nGWWCFXTxbQkQNOtp+TfqlDrOj+CvWOCcmLnaPNXYBZK"
`endif