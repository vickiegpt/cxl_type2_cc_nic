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

module eth_f_dropped_frame_count #(
    parameter LANES         = 4,
    parameter FRAME_MARKERS = "sop"
) (
    input   logic               clk,
    input   logic               reset,
    input   logic               clear_count,
    input   logic               valid,
    input   logic   [0:LANES-1] inframe_unfiltered,
    input   logic   [0:LANES-1] inframe_filtered,
    output  logic   [63:0]      dropped_frames
);

    logic               valid_delay;
    logic               if_last_uf;
    logic               if_last_f;
    logic   [0:LANES]   if_vec_uf;
    logic   [0:LANES]   if_vec_f;
    logic   [0:LANES-1] edges_uf;
    logic   [0:LANES-1] edges_f;
    logic   [2:0]       frames_f;
    logic   [2:0]       frames_uf;
    logic   [2:0]       drops;
    logic   [2:0]       valid_drops;
    logic               clear_count_int;

    eth_f_delay_reg #(
        .CYCLES (3),
        .WIDTH  (1)
    ) valid_delay_inst (
        .clk    (clk),
        .din    (valid),
        .dout   (valid_delay)
    );

    assign if_vec_uf = {if_last_uf, inframe_unfiltered};
    assign if_vec_f  = {if_last_f,  inframe_filtered};

    always_ff @(posedge clk) begin
        clear_count_int <= clear_count || reset;
        if (FRAME_MARKERS == "sop") begin   // Use SOPs
            edges_uf       <= ~if_vec_uf[0+:LANES] & if_vec_uf[1+:LANES];
            edges_f        <= ~if_vec_f [0+:LANES] & if_vec_f [1+:LANES];
        end else begin          // Use EOPs
            edges_uf       <= ~if_vec_uf[1+:LANES] & if_vec_uf[0+:LANES];
            edges_f        <= ~if_vec_f [1+:LANES] & if_vec_f [0+:LANES];
        end
        frames_uf       <= count_ones(edges_uf);
        frames_f        <= count_ones(edges_f);
        drops           <= 3'(frames_uf - frames_f);
        valid_drops     <= valid_delay ? drops : 3'd0;
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            if_last_uf  <= 1'b0;
            if_last_f   <= 1'b0;
        end else begin
            if (valid) begin
                if_last_uf  <= inframe_unfiltered[LANES-1];
                if_last_f   <= inframe_filtered[LANES-1];
            end else begin
                if_last_uf  <= if_last_uf;
                if_last_f   <= if_last_f;
            end
        end
    end

    eth_f_accumulator_64b_4c acc0 (
        .clear  (clear_count_int),
        .clk    (clk),
        .din    ({61'd0, valid_drops}),
        .cin    (1'b0),
        .dout   (dropped_frames),
        .cout   (/* unused */)
    );

    function automatic [2:0] count_ones;
        input   logic   [3:0]   din;
        case (din)
            4'b0000 : count_ones = 3'd0;
            4'b0001 : count_ones = 3'd1;
            4'b0010 : count_ones = 3'd1;
            4'b0011 : count_ones = 3'd2;
            4'b0100 : count_ones = 3'd1;
            4'b0101 : count_ones = 3'd2;
            4'b0110 : count_ones = 3'd2;
            4'b0111 : count_ones = 3'd3;
            4'b1000 : count_ones = 3'd1;
            4'b1001 : count_ones = 3'd2;
            4'b1010 : count_ones = 3'd2;
            4'b1011 : count_ones = 3'd3;
            4'b1100 : count_ones = 3'd2;
            4'b1101 : count_ones = 3'd3;
            4'b1110 : count_ones = 3'd3;
            4'b1111 : count_ones = 3'd4;
        endcase
    endfunction
endmodule

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q46/sqiyFnNvFOcicHF8BO0UET+uLN6t6T5K+UdBIAIo8Zr8vWzUfrZPvxrY5rkjnjY3dHYHcJ9eeMEzYlMfCxklZVGKGd7vqzheQBl1D5saysfAxm9nSqPOZhKbLi/TbI/Ir4zVaWe2fBiUqhKnH4oMLJe4WWAQP/z4gk2DoY+y4uDHVjB0e/s7I+YOhAHi7b+7V3FRy6Id+8sUDXyMhfv2Fc7kuZMUJkmr+z2z3bjNZ7DzSsuGPKUwszx6UxfnSJOjK0AvR6rQxmJqMjgtnGUh8mjDA6h9ehoCR9tyqQD0ObJ5fYutyQEljEDDeFYyCw6fT49LR+ttSROv6Bzxb9awfr375+Po1QlXCgPSLkmx9B5fdwMgl9qPir3pDTrHCCF1P8lzlg6pu0QtQNSPF9jRrILSO0V0v5cUNSGMJ5sDmgsz55EIaESBRYwuWzfsip2oyVNCgBAe9mvFLyPhqwwy8CkwB3dY4oH9qNRoOfdjtB3XCLjczrgAFcKG94dfy2ZSnNC99dLsnkboMvZp3p/e80wBn9TFHIjQlV0fTY4iW/2SDTAeaeY5Nkf06li9bXJo8MsX02yubMUCQ8FeiFdQV0YgwPvQWr99DQ9pKEuTdvBdtX/b0kmsagu5PFSMBueBtAQrJMkRgHcygCvA8G+9XAa/QdoFEmOw7eoK/TFfUr3vp9hB8hj/x39PXVJ6HPb9vCRFo9IloGnukFdBmGvrbwkHiWaIg7fGOcg5Jj5mAU35Cr3yGa0sOVmRQAVFuMhY0NMpL6AL0gEkQFAS8znG"
`endif