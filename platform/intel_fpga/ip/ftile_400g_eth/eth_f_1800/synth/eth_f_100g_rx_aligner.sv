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

module eth_f_100g_rx_aligner (
    input   logic           i_clk,
    input   logic           i_reset,
    input   logic           i_valid,
    input   logic   [0:3]   i_inframe,
    input   logic   [5:0]   i_ptr,  // start
    output  logic           o_valid,
    output  logic   [7:0]   o_ptr   // start
);

    logic           if_last;
    logic   [2:0]   phase;  // position of next block to be written
    logic           stored;
    logic   [7:0]   temp;

    logic   [0:3]   sop;
    logic   [7:0]   ptr_extend;

    assign sop = i_inframe & ~{if_last, i_inframe[0:2]};
    assign ptr_extend = {i_ptr, 2'b00};

    // f(1+6+3) = f(10)
    always_ff @(posedge i_clk) begin
        if (stored) begin
            temp <= 8'(ptr_extend - phase);
        end else begin
            temp <= 8'(ptr_extend + 8'd8 - phase);
        end
    end

    // f(1+1+1+5+3) = f(11)
    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            stored  <= 1'b0;
        end else begin
            if (i_valid) begin
                if (stored) begin
                    case (sop) inside
                        4'b0000 : stored <= (phase >= 3'd4);
                        default : stored <= 1'b1;
                    endcase
                end else begin
                    case (sop) inside
                        4'b0001 : stored <= (phase >= 3'd6);
                        4'b001? : stored <= (phase >= 3'd7);
                        default : stored <= 1'b0;
                    endcase
                end
            end else begin
                stored <= 1'b0;
            end
        end
    end

    // f(1+1+5+3) = f(10)
    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            phase   <= 3'd0;
        end else begin
            if (i_valid) begin
                case (sop) inside
                    4'b0000 : phase <= phase + 3'd4;
                    4'b0001 : phase <= 3'd1;
                    4'b001? : phase <= 3'd2;
                    4'b01?? : phase <= 3'd3;
                    4'b1??? : phase <= 3'd4;
                endcase
            end else begin
                phase <= phase;
            end
        end
    end

    // f(1+1+1+1) = f(4)
    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            if_last <= 1'b0;
        end else begin
            if_last <= i_valid ? i_inframe[3] : if_last;
        end
    end

    // f(1+1+6+3) = f(11)
    always_ff @(posedge i_clk) begin
        if (stored) begin
            o_ptr <= temp;
        end else begin
            o_ptr <= 8'(ptr_extend - phase);
        end
    end

    // f(1+1+1+5+3) = f(11)
    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            o_valid <= 1'b0;
        end else begin
            if (stored) begin
                o_valid <= 1'b1;
            end else begin
                if (i_valid) begin
                    case (sop) inside
                        4'b0000 : o_valid <= (phase >= 3'd4);
                        4'b1??? : o_valid <= (phase >= 3'd1);
                        default : o_valid <= 1'b1;
                    endcase
                end else begin
                    o_valid <= 1'b0;
                end
            end
        end
    end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "4AvUa/AX+twoSNmlxf8DfgbJZtLM0FTYaDfqwIVh58kyS9m523ZPwLwxNf/MAu2Ws24gvNuIWubOgwJDJF/J8SquMj7R1nNyipeKzuCa44Ouq3sVSfXA6vNne7RbKwd87qtqmEuaCdIDSUZZO8uw+CWUHgUS5S0PLelh7tY7EIuUsZeE9mUM9zh2JvtzuWMzW1qicCsSFUI1HHB6Owmf0ylz2E7BXtP0spRRZWMpnQ3VNTry5ARvlYsIHzH1rq2FvVGesUDCkqxvH+iGNhyZwrGA7PxX7vPoqT/68NgOpsNEJKRosmxjioLbU+TuH7WQcAYaVXTknVl+X6SvRz4C7/ZFlX4HTyny1oo8dmVMqV2+OJT9ekuAsnvvdVhW2hCcCYBoodDAio4eYuAXIMU7t30gXReJ7BdyPGu+8WGCkEb6CIJ9FfZQsq3XHYbqFzgYgdLhXh9OJnLsXWu79X0wFp8HQ58XGvc3xRqjLumQl4dKs6hACYWAYvpZIO7cg2rVWqL/HL70obLky++GZPF0CnzijceX68bCVSiVM2h5MB2ZAogVR/Jf18BjoHZNupaBo6QpCi2GpTMJkpesT+dmQ7sQFk4X1ynGmZhsPo6GplOYpx/PNu0Qp+0yKEmM/ghaKjEM1fs9/cb5e9V9DQxjLAGvHdqnZQLVkEwu/lv4KB+Uq0r+xIg+PTjJkYhDAy4emzil44HUbAWfvlVMGjLRS3kCklXUrEdl70DarO8MyVNOfYHmmmbWfPvq1DBK7ykFK3QviXaUmwcFl2rEqS5VuRo1bfTECkO1jTrxYVk+I9Xp5hhmolFHXNdbAmrxyyA14Gz1r+HiFQhTM1PHXCtRsixjVmr2Y9bHYiuMtL0wTltRYgO4atj1oGLuqJdXmynqzbHnFtTJePdNvKfuySYTdaw1O7DussdwMYvI5NwGw4P3JwuaauQlt74jj2w2ZQMdFl74wuoo8EJMwAkVbUsW2eEUAPxaAkofKojk2s0UplJ7z2XUlG8ILEl39QJdYG9E"
`endif