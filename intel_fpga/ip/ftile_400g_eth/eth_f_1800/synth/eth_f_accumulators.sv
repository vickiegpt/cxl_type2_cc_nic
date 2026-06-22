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

module eth_f_accumulator_16b_1c (
    input   logic           clear,
    input   logic           clk,
    input   logic   [15:0]  din,
    input   logic           cin,
    output  logic   [15:0]  dout,
    output  logic           cout
);

    always_ff @(posedge clk) begin
        if (clear) begin
            {cout, dout} <= 17'(din + cin);
        end else begin
            {cout, dout} <= 17'(dout + din + cin);
        end
    end
endmodule

module eth_f_accumulator_32b_2c (
    input   logic           clear,
    input   logic           clk,
    input   logic   [31:0]  din,
    input   logic           cin,
    output  logic   [31:0]  dout,
    output  logic           cout
);

    logic           clear_reg;
    logic   [15:0]  din_reg;
    logic           cin_int;
    logic   [31:0]  dout_int;
    logic   [15:0]  dout_reg;

    always_ff @(posedge clk) begin
        clear_reg   <= clear;
        din_reg     <= din[31:16];
        dout_reg    <= dout_int[15:0];
    end

    eth_f_accumulator_16b_1c acc0 (
        .clear  (clear),
        .clk    (clk),
        .din    (din[15:0]),
        .cin    (cin),
        .dout   (dout_int[15:0]),
        .cout   (cin_int)
    );

    eth_f_accumulator_16b_1c acc1 (
        .clear  (clear_reg),
        .clk    (clk),
        .din    (din_reg),
        .cin    (cin_int),
        .dout   (dout_int[31:16]),
        .cout   (cout)
    );

    assign dout = {dout_int[31:16], dout_reg};
endmodule

module eth_f_accumulator_64b_4c (
    input   logic           clear,
    input   logic           clk,
    input   logic   [63:0]  din,
    input   logic           cin,
    output  logic   [63:0]  dout,
    output  logic           cout
);

    logic   [0:1]           clear_reg;
    logic   [0:1]   [31:0]  din_reg;
    logic                   cin_int;

    logic   [63:0]          dout_int;
    logic   [0:1]   [31:0]  dout_reg;

    always_ff @(posedge clk) begin
        clear_reg[0]    <= clear;
        din_reg[0]      <= din[63:32];

        clear_reg[1]    <= clear_reg[0];
        din_reg[1]      <= din_reg[0];
    end

    eth_f_accumulator_32b_2c acc0 (
        .clear  (clear),
        .clk    (clk),
        .din    (din[31:0]),
        .cin    (cin),
        .dout   (dout_int[31:0]),
        .cout   (cin_int)
    );

    eth_f_accumulator_32b_2c acc1 (
        .clear  (clear_reg[1]),
        .clk    (clk),
        .din    (din_reg[1]),
        .cin    (cin_int),
        .dout   (dout_int[63:32]),
        .cout   (cout)
    );

    always_ff @(posedge clk) begin
        dout_reg[0]     <= dout_int[31:0];
        dout_reg[1]     <= dout_reg[0];
    end

    assign dout = {dout_int[63:32], dout_reg[1]};
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "4AvUa/AX+twoSNmlxf8DfgbJZtLM0FTYaDfqwIVh58kyS9m523ZPwLwxNf/MAu2Ws24gvNuIWubOgwJDJF/J8SquMj7R1nNyipeKzuCa44Ouq3sVSfXA6vNne7RbKwd87qtqmEuaCdIDSUZZO8uw+CWUHgUS5S0PLelh7tY7EIuUsZeE9mUM9zh2JvtzuWMzW1qicCsSFUI1HHB6Owmf0ylz2E7BXtP0spRRZWMpnQ3T8isevARAE96LLDfd7oFpdH5EBpjHbvEs8fh9sIyJIb36knTM0Fxo5imjlFvCctWVyqD82mySJ5EWkkIQBw0woDJkomVoOyDb5PjW7r6jp9WxLTQztR8WPrAM4InHwfQPc1838cWJ7srb2uZdR2fOQoH/qC96hvX89CZHkKD+hKAeM3MWObd3uhg+SeLlAm4GigiVuJknAtDkPNjgyENr5LlDlxZvbLpDFmpuZFdX1+cHW24DAByXjuBxuK+Llrjvet9IIvHrhB2q4Dwez4sjm6pwz1Vs50vDH1MCB7NPpWpqpQLnWIrGhIEtDUnbzcMvhn1dC/Xe/SPdThD3QjWJk2QGSg0csHkmtCWxQZc4zzJkbOTfjq0RXQaH/UQi9xnD9w8W9KLcGdFR7fgPuT7CbecjdtjUBmoOTORuJ43UsiUy81JKeLOvnxw3ajk29pSiCsd20QXVJX2mXASpSxEZ3Vx4KgpmSJGoSuI5Irip2ktsL99LvnhwBwPAOtEmXp/uZym6EaoHcw1g2rCP4Suql73e7NSAYPOWRadP+jPqxY2tNqRPW03tWy+u9ZbCIxL1TA//Eqd6SosSydOFnSg/DvtsHRrNkPdAmGjt4d2gdiQ33BBR8E3SAJQu7qxtX2T1b7hW92qgYWzBm0xqiWblCrxNBLBy9+wWjAeUAavA3+fHlYUkkFPOsmilP1igoocT2jNqov8YdeAKbuyzLYuHsz5118cL7LiXU/4cyzzINuWFr12iLF7EPAzy/hcVznGXemLfXvyVD3lQuiEZLqQL"
`endif