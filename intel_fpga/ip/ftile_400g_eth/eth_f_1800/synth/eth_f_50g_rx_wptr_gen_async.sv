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
module eth_f_50g_rx_wptr_gen_async (
    input   logic           i_reset,
    input   logic           i_clk,
    input   logic           i_valid,
    output  logic   [4:0]   write_pointer
);

    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            write_pointer   <= 5'd0;
        end else begin
            if (i_valid) begin
                write_pointer   <= write_pointer + 5'd1;
            end else begin
                write_pointer   <= write_pointer;
            end
        end
    end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q47enWK2YUvm5H8o8JlZfdk1Rpa4fNuRkqn4TmEgwlKRMRu5zFoq8+Bgt/ChMVHIF5xWvj0xVkWG98scSzalIL/vx4DTv9dMZXoCb1+Yo+I3/GPhh/26p80Kxv7jeUeBDq34RzoxsPvFzCrVJmsG1TTDT4HILTa06jUNk7/CHeV/73kBRTO864cEa74zx3rA9ZL00kgG6xBX2fLb7RyNQdl9CAY3R77QiN1Iw9z6yFsVESnSK60ZyMtZ6YH8aYFSeIMYOYR9UiWbedQgQD7AL3hbzIUIkOgqRXin/oOJeuR+MYu1Fm+hArCxWvMHJ0U09bIJkDYrgIDagjfrNONTNh28xJZZJrRxkMlc4rLvINoAareR+xZxRRNPfNG995sgb9t9/FZVIkCY6rdAO2f3NbbkueDi89E9ggLz3LWp7723U9Ci/xVEV8zPmY7uwpFdJN3ORcjCp6FRzxXu2FcB2ZPdkT+I7cwlXcu7wOL6oGGHf8yQU/UfoSASaybli96ctAJEpR3BOJzyG6qsTQtgwqmPICa0Eo5Qy/2hmEc89L4pVIGTPFamcRrd4wHUxxghfSMRbzTjOPZN8N2GgdDl2vlkefrb+ho4pFwJP4/cApRQGbs7irPAGimtbfDd9b/c/HcrfoPLOmnWg8vduhavlNw68Yf1YAYN0Ey34YtRYH9toI0zMlNETEtQl9cXcHJBhU0t+D7Mb/cklF5j3rFCeXAnmxiLM+EiTBN/KMdSW3lrUCeEJ+pdUsTY10yA/Nrp733nHngCtOIc1cNfhMsRM/ub"
`endif