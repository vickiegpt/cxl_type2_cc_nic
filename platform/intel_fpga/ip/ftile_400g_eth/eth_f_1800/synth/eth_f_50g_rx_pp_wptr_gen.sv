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
module eth_f_50g_rx_pp_wptr_gen (                    //need to merge
    input   logic               i_clk,
    input   logic               i_reset,
    input   logic               i_valid,
    output  logic   [0:1][4:0]  o_write_pointers,
    output  logic        [6:0]  o_block_pointer
);

    logic   [0:1][5:0]  write_pointer_phase;

    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            write_pointer_phase <= {6'd1, 6'd0};
            o_block_pointer     <= 7'd0;
        end else begin
            if (i_valid) begin
                write_pointer_phase[0]  <= write_pointer_phase[0] + 6'd1;
                write_pointer_phase[1]  <= write_pointer_phase[1] + 6'd1;
                o_block_pointer         <= o_block_pointer + 7'd2;
            end else begin
                write_pointer_phase[0]  <= write_pointer_phase[0];
                write_pointer_phase[1]  <= write_pointer_phase[1];
                o_block_pointer         <= o_block_pointer;
            end
        end
    end

    assign o_write_pointers[0]  = write_pointer_phase[0][5:1];
    assign o_write_pointers[1]  = write_pointer_phase[1][5:1];
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q46DVhTZoHFngdIXjN6Ct68Szqa1tLOw53tjZuprq49xtd3j7voHVykbSg9JKJA1pbX+pNffdnh5hvN7vSq3cBiQI5UpQ9cINmKgbuPa5Aum3sW0gwDAFxNJXvLYOTFTrKDw1NznHGAHtXCjvKHaDrAg2PiWpdAbzctSiP7uTyOBZzixR0nTnzDbY3Mf1sBTBzvKLPX0b+4yniP2Nn1xMC+1bKa6EBosDNg1oA6IEKMrm/KOFEwlAnCD4nK7MsMyn4aWzGPHQ6f7w/j0T6UJmLS0D8Ox6blgUuvcFYMFUZm22ZKqntFqNLLWntwE0a+d9VVsPECQzLaeDMMBmCOXgPBbjNFIs5urYHJzOgMBiOVNnsuX2Mrd04gZDcQ8FAbJzZmD2y5zN9JITshDqWP8qbd7TiYk8gaISussVey/nsD+yjpjpMe9uSPqoZ56xOHoVpB7yX9oMy3KnwcM30Jav8RfZWJttVkSCrALrIy4ZYNIK/jwbIPWaBHGweWJcEjmrWn3Y18kLdC+J1qziUppmHLBb32MZW8VY0KyplT0bIjL03euF5CPQNO05EaGYZZVegJ7ggxJAUbwAqV2UXaoQpPforEDaGiQcidgnFD8WI/vqDD58qvPIocFP6zDJdpOX/q3kBS8hszw382bIMtmbjwrMgHynYRguU4eCNHN3FqBotrsseb1OTFLp+ShF4+8CNa5qe7Dt27jgq+IRmzFYE/Wed177aIWUfux+7ZeU2sztQbB7Xl/ZQ1a54CtPJfJBa9zsmEXYj+pogwuVhnUaxsA"
`endif