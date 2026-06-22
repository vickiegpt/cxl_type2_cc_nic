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

module eth_f_sl_avalon_to_if #(
    parameter WORD_WIDTH  = 64,
    parameter EMPTY_BITS  = 3
) (
    input                     i_reset,
    input                     i_clk,

    input   [WORD_WIDTH-1:0]  i_data,
    input                     i_valid,
    input                     i_sop,
    input                     i_eop,
    input   [EMPTY_BITS-1:0]  i_empty,
    input                     i_error,
    input                     i_skip_crc,
    input                     i_ready,

    output  [WORD_WIDTH-1:0]  o_data,
    output                    o_valid,
    output                    o_inframe,
    output  [EMPTY_BITS-1:0]  o_empty,
    output                    o_error,
    //output                    o_numvalid,
    output                    o_skip_crc,
    output                    o_ready
);


    reg [EMPTY_BITS-1:0]   empty_reg;
    reg [WORD_WIDTH-1:0]   data_reg;
    reg                    valid_reg;
    reg                    error_reg;
    reg                    skip_crc_reg;
    reg                    o_skip_crc_reg;
    reg                    ready_reg;

    reg                    o_inframe_reg;
    //reg [clogb2(WORD_WIDTH/8)-1:0]  o_numvalid_reg;

    wire inframe = (i_valid & i_sop) ? 1'b1 : ((i_valid & i_eop) ? 1'b0 : o_inframe_reg);

    always @(posedge i_clk) begin
        if (i_reset) begin
          o_inframe_reg <= 0;
        end
        else begin
          o_inframe_reg <= inframe;
        end
    end

    always @(posedge i_clk) begin
        empty_reg       <= i_empty;
        data_reg        <= i_data;
        valid_reg       <= i_valid;
        error_reg       <= i_error;
        skip_crc_reg    <= i_skip_crc;
        o_skip_crc_reg  <= i_skip_crc;
        ready_reg       <= i_ready;
    end

    assign o_inframe    = o_inframe_reg;
    assign o_data       = data_reg;
    assign o_valid      = valid_reg;
    assign o_empty      = empty_reg;
    assign o_error      = error_reg;
    assign o_skip_crc   = o_skip_crc_reg;
    assign o_ready      = ready_reg;

   function integer clogb2;
      input integer input_num;
      begin
         for (clogb2=0; input_num>0; clogb2=clogb2+1)
           input_num = input_num >> 1;
         if(clogb2 == 0)
           clogb2 = 1;
      end
   endfunction

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q44S3r59//vTt22dCfSu7575FGaPHHLlYj2KWij/6cBcQQSJvSpdfem4mbTMsv+IWkPnPo1bsiuzP+l4TCMdWgpWFca290aF6WZB8gCHEWHC5RQ/k8jssmag7Bok9exBzulgZbbJEkiVm+7adyyB2Oplroxah9m+6MsDdOnEEH/N9olhZVIFaNuCMfDIFqEAOi6pmTE7omaAdhjENi6NU4fbecIGP6BaU2LjQDMeHaScgWMyRVm/6/Lflum/OIhSoiTrvetgAXU4Ecukbgj+bkL3GaJdXJiEFL863Or+65bxI52RzStjEoGVN/fl6eSJlqG6dyH257b+A89DSuJRlG80oxnwopRnNMIDoRQJXWQoFNSJ6crz+Jq9VfDpNhssFmVx/+IRzA0nIl6wQUtdKBAJec4TCUd5J7zQXCrUMkR9FemNsXEpoOTI9S4sX/Ztf5Iu4AMwadIBgmtnDVBamduLQlNrMCh6ViG8nxjra/Yl4q4gCgaaZbV5S7qvt6J0fu+A1krnYAX9TQvTm9+eYep/XYiZhEyXk3vMEq/7Zf4vOcSOsd/eI5oytHiQn2leafGo6WA7hJ60Wcaxa4j53bxj0c1VclSk+02vpZ67mAmzhBsefXZ4n5GoNxKHji690fZ10uCILKnNgyO5aJBKC6B36+yJ7xN07yhzf9ulI+s59hC/IHu5Hs8Elf5h2m7Hj5HJnW4RGHeCzyONhf8bdvvHtHTy6CbcMVXYlOmns1QpFDPKDea/CQ5qWg7SkAU6/Q1MPridP/tA1p4wEijqIdIr"
`endif