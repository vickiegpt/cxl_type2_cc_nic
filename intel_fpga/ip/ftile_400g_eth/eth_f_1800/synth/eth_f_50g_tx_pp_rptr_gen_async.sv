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
module eth_f_50g_tx_pp_rptr_gen_async (
    input   logic               i_clk,
    input   logic               i_reset,
    input   logic               i_read,
    output  logic               o_rotate,
    output  logic   [0:1][3:0]  o_read_pointers
);

    genvar i;

    logic   [0:1][4:0]  read_phase;

    generate
        for (i = 0; i < 2; i++) begin : mem2_loop
            always_ff @(posedge i_clk) begin
                if (i_reset) begin
                    read_phase[i]  <= 5'd1 - i[4:0];
                end else begin
                    read_phase[i]  <= i_read ? read_phase[i] + 5'd1 : read_phase[i];
                end
            end

            assign o_read_pointers[i] = read_phase[i][4:1];
        end
    endgenerate

    assign o_rotate = read_phase[1][0];
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q45DUp7h0iBN31obb7enDPTrovdRiJB8l3qK0UpLL+IBWA1uEXX+ely/7n/CnHDcpovR7nOmEHNK82F05AvF4ANP7nq6Tq8pCsoyFIkxN96n4qk4PiZzqpjEjHvP+Has6fV5WwWPjwzgyWPkbYDndihhgUvpm5nGRfB/L/TVzmtrCEoLQQfNeyoFHnHxzB/+09KRrWTG4/x8XtQ67bIUIe/snTzMxZzdXRCF+xO9qNPRmUm86vWHrp8+bVS4kdbfYPtGDcfWiAPP5S1I39aSMNGxrAPm7MTh1LvHHEyG/NvqNxCFUq13wzNp7EZrtIKbLcm3+faQzzYyROtK3VJ5E9Ogkj5InD/yV3yNUdqNxl9LMeC0q1bUxiCoUaSSUkGPQNqAygBC6+fRqFzoJfbvMa+XzB7JxrooEd2iXZPn/H+lxUIMGxa1C1mdYHGRAlgFqf8675Uy2vaocbfGqsuuP0c2hWduwabaZzSeC9JBZFmTTaz/niBwLJqNNWb073/t8eMIwFFtPKqGZ7Pxm93adHZGpDtvIJzlbkzS2gkUjaGFTxhuoR3P7LhRXiPAEgF/foa5w2h8sI5JILE02ZsWMKs6Ct+cfjfgomNog6eNI7RUeNb4LKVKx7f6Q696SMB+8PuXZ1q0NuZlo2+D0O9lriI8EIAQL7XxC8bjvpW2DOSGwblf4nJSRe9LB/HYVDYOWwiRuJ2/AKkDcNMe4sBlB0HZgwVw75TfWRS+UO4wWyTzzEroUUkDbS8IYyzuExxE2kF/ddV23YQGFbiYYWLGHKrW"
`endif