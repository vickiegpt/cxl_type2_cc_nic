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
module eth_f_data_rotate_8to8_tx100a #(
    parameter WIDTH = 8
) (
    input   logic                       i_clk,
    input   logic        [2:0]          i_rotate,
    input   wire    [0:7][WIDTH-1:0]    i_data,
    output  logic   [0:7][WIDTH-1:0]    o_data
);

    logic   [0:7][WIDTH-1:0]    o_data_reg;

    always_ff @(posedge i_clk) begin
        case (i_rotate)
            3'd0 : o_data_reg   <= i_data;
            3'd1 : o_data_reg   <= {i_data[7], i_data[0:6]};
            3'd2 : o_data_reg   <= {i_data[6:7], i_data[0:5]};
            3'd3 : o_data_reg   <= {i_data[5:7], i_data[0:4]};
            3'd4 : o_data_reg   <= {i_data[4:7], i_data[0:3]};
            3'd5 : o_data_reg   <= {i_data[3:7], i_data[0:2]};
            3'd6 : o_data_reg   <= {i_data[2:7], i_data[0:1]};
            3'd7 : o_data_reg   <= {i_data[1:7], i_data[0]};
        endcase
        o_data <= o_data_reg;
    end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q44Bksx7qJilYb3h2OduDb8ZEMYoqablPCmwXyFeghiLy8B00ervX9nhnybloIe94NtLYkDut2AwVzXxyFsMjS10XIpYgCvG3XPkU6vExISuVCJ6rQvIEJV36VxG3GGNzfZI7zuvwnejsxYy02VjryVJKbvOQHniYBS1lkRV4w1kqlpXi8t/F0iuy0cDCz4eEFkZOU8EE0UFtouG6kRLLqIN3B8X2LUQEWxr/MIOmrJafJVujEQO4c8M8Hg80CoqYOAKoARpVGbhf0nCizqd9VLkX4jd6rub7ao6VsO8xk4BO3enOznVhiyGaaff07ZJG/vHzbAhuxTlNNC2d0b9r4Gik4x7hy0btBu+BPW0OJ5InUl9K1UMdvU7pO1a7Lp0vbB7miA8smcyRAPvQp8eyxoD+wOM79c0Qst9bnzGTggQS4SlSDGYxgR2h646gL4umJpWRvbOLa6jhYnh9HKVygiS4HyHf02RkVtVT2ggAAs+EYoTQ/WGgNSQg4DQsbsi8kwSTRXZ/8V/sQTgZZuzV1rRfYa5vf/WFCJx6Vczbk7KNgDCBeBjSaxIxuMGWK6OZ9raasLlcIsYB086aZUEqNVkaWgUj4Dm1zha9ega37SbXCWrh1JnsZLuV9EQI2zMotnSz+GF5bruVhpzAauzd5+NCodKx0hQTHf7YAXO6lzHXFGOzPBQSRzU86N+k8uIU1N0RVnnyI+6RXQqdZ4pg3dhsBeD9EkXrPNQOhBJoZuO4dZH3rw+iRPIuwC4EEWurM+ZM5b6QjU8vSoZuSBJ8aZ2"
`endif