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
module eth_f_50g_tx_pp_data_rotate_3to4_async #(
    parameter WIDTH = 8
) (
    input   logic                       i_clk,
    input   logic   [1:0]               i_rotation,
    input   wire    [0:2][WIDTH-1:0]    i_data,
    output  logic   [0:3][WIDTH-1:0]    o_data
);
    localparam BLANK = {WIDTH{1'b0}};

    always_ff @(posedge i_clk) begin
        case (i_rotation)
            2'd0 : o_data <= {i_data[0], i_data[1], i_data[2], BLANK    };
            2'd1 : o_data <= {BLANK,     i_data[0], i_data[1], i_data[2]};
            2'd2 : o_data <= {i_data[2], BLANK,     i_data[0], i_data[1]};
            2'd3 : o_data <= {i_data[1], i_data[2], BLANK,     i_data[0]};
        endcase
    end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q45U/AhaPnA4oC0PARpndynervYf6mVFPOCrmUk449xSjHFoWSf0HCJtLceDZMa60qAQPtl/o2AGFPbCEzbS852FU79BkRMYdxb6XKMferUrIEIRBP54XHMGAI8Ukl5vd8Ygbf+ZeP3kulPC3GORJNs3d8WNz5Pym1spQWNB7iEoGQadF2erplUB0BntBdlTLP780bV4/f3d4LZuZIXaBQ/JrFCisuzGJ3kw/AeUyO9DZm9r36jMTuYdCbXF6y+MhjPDE0d3Qgy8ptIH13ubcl2ObPALdCI/zoOWW6yBwZlWnOe9HEIS/pkKFk2W1qdikDsWughpT4ECppRmOTheYEc18kmKhrYXKqNFlKzUESFIedjQpbdqIA2/VF/rfx9P5eTZgzn7ivaqt2z7w/QvvMMI4e5i+j+rNLeHpFWYV8+NiabQoiCQ1oss4pj1LTwER0uf37+O1o0FKsmONAMZrzHRUTAqZAXmV+DX2AVLZFY3YtQxIJgp4UkRuFHQ+YB347GNxKw1HUHBCuZ0sKxErRfnKVeewwDMMrBxQhcVJwuw1fnG7EdAVnzno0fgbdvRJUJZrQu1aaprTKL3WG+ViBfXuB+28kvoUt3eDlthuqu2qjM2qhqJ7j1k486ay5w5BA/q1QDXnW+k5ukXMmO5pKVONPauib3uNTNuRtzStMhh2prvegB7yNmNDxHYt0UrgnUuTnsmf6mLSqD5zs+tS7c+OGj3087YKCiganycuBfFbRerExG+0XzZgrg2hnstP/UMqG4x5TRdpgRISZGmqotV"
`endif