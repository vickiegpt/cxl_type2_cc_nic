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
module eth_f_rptr_gen_tx100a (
    input   logic               i_reset,
    input   logic               i_clk,
    input   logic               i_read,
    output  logic   [0:1][4:0]  o_read_pointers,
    output  logic               o_rotation
);
    logic   [0:1][5:0]  phase;

    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            phase[0]    <= 6'd1;
            phase[1]    <= 6'd0;
        end else begin
            if (i_read) begin
                phase[0]    <= phase[0] + 6'd1;
                phase[1]    <= phase[1] + 6'd1;
            end else begin
                phase[0]    <= phase[0];
                phase[1]    <= phase[1];
            end
        end
    end

    assign o_read_pointers[0] = phase[0][5:1];
    assign o_read_pointers[1] = phase[1][5:1];
    assign o_rotation         = phase[1][0];
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q453k2m34pQi1pZirnZ53DwNdBIvfhmPlRp4sP1j0tBCWRFKKpxtpJLa9zHMmFob1OAYqW1T+pnbiMjf1an0kVuHOcsB55YZSl2SaR2ZKd214MLBp8de3Bo98j3SKI1Gayz+F65IGBJq5DTZ3NhWrBJQH/Xa1omgkfmAB2e7ePF+8vZ4fZZeXqfae5a+Vv4Ub0oL1oYTspzhr7cV09iM/+FY3vZshouQUXMFDr+7uEduiSmG5m+PcFbwJxGSGJN8o+aGRnqQOVYwUO2evZDveybv6oGw520loQVtXSzD1BmhDUo+3flR+7eaZMftfoJf6+ZNa36DVavAprM1bTvk8stetCA2qfg8rxduXK9nraQMEpcVMIiFz9JMPpLcNSB/Z8yvl5BxTc4vXgfJlph21la5gwRe/+JiNNgOG33nM6P9RYyrZOeygGPfUWUUsxV3qlWjVUgDxtrNhQSLRpqooDgXvwN0xJJsup3IJgnVnrewpFfmBy58kTyRMkrzH1Xr1f/Qt3xf+USaW2q5WabB7+lvfw/LgkWtfZXpncCnz2fXEhpmG9856exPcnpScPcMx77R76TrqgG4xbA8EuStRosA3bJiSEslhrmYHnmJxwN5rXJXkEBhFfXHxUBSuVStYMjNBSxNrtfnf4MyGTbUW/7MnghEEBENQQfHCm8Nw/g5y+uXuJCRoWPJkZFoaIbRpLJvLZza51t7WQyqjQEGZ5YVBQnBLV35y3ymppOd5FjagdfUHU0ShhckQjqecbjmd0hFajo2q0cP0/Kros+Z1ZhW"
`endif