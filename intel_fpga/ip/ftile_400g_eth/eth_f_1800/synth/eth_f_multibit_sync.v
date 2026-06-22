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


`timescale 1 ps / 1 ps
// baeckler - 01-20-2010
// weak meta hardening intended for low toggle rate / low priority status signals

module eth_f_multibit_sync #(
	parameter WIDTH = 32
)(
	input clk,
	input reset_n,
	input [WIDTH-1:0] din,
	output [WIDTH-1:0] dout
);

generate
genvar i;
for (i=0; i<WIDTH; i=i+1)
begin : sync
           eth_f_altera_std_synchronizer_nocut #(
                .depth(3),
                .rst_value({WIDTH{1'b0}})
            )  synchronizer_nocut_inst  (
                .clk(clk),
                .reset_n(reset_n),
                .din(din[i]),
                .dout(dout[i])
            );
end
endgenerate

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "4AvUa/AX+twoSNmlxf8DfgbJZtLM0FTYaDfqwIVh58kyS9m523ZPwLwxNf/MAu2Ws24gvNuIWubOgwJDJF/J8SquMj7R1nNyipeKzuCa44Ouq3sVSfXA6vNne7RbKwd87qtqmEuaCdIDSUZZO8uw+CWUHgUS5S0PLelh7tY7EIuUsZeE9mUM9zh2JvtzuWMzW1qicCsSFUI1HHB6Owmf0ylz2E7BXtP0spRRZWMpnQ3f1M++blyTG7BQcyWPvW044mmWXhlKTs9/838EbfG4DiauPea9RdeOa6LNEWETXjFCgUatDPbOOPj2SBfrV4xk0r/XY6IGkO0I1y4kKNILy4qYd+Zz82CEi0ozuT3wYZiC4K86snCJp45P8cLz2Ezzesx5iCy7FqSXw6L7YTzyKQHjWAKPEJAvgaLW1LBXNBXHjsLw9xqB9oZWCotN338Z8qXqlwCO8Tacp+Cov2xDJgFE0FvkVMYvQ9/TBR8V2KwaytazyXngELdYw585+QICKO+6t0niv/hLMoiod+OfjaF38gziZArtyTQir057ijD9ypUwdAoKnMp96aU0PQtTuIwOQAsAgzZyaJjlw7gM0ZoR4xyDuGUzqBgWQDX9E/9chBOogXzZVfJ1/4j6K1mSgDXbAnCTlPWVX7zfs5xgo10PdBh+COBTlnTfBPf8BXVYc2aGW3IDtnrlbAvq8XST/Wk4TN8oVU+YPOONudjvyJRpjhInFuX4/bs74DCsC43b4Be9RT3MUOgh07pW1rMYSJCqVgg29wtZhuGCd7wZdqwYdzkJZw87VYD9kmtHPxFYC8NjkuLpVtqsZB+zLvp53E3H8UiZAOtHWNc2hIlpeOYa4cjbXB0Ze3jiNe8IoRmvJGhtBXRzJY75Dcdzrar3TLe/38gNXgvyfDbssH9C5V9qmTrI7Wg4iGMfsT3Y7lxFfrbOr+bHTq3cC/8AEWOak76DdQhnf5Z26bvZeDphmxRvdRfthZP4sk+Sm0l1EKvq/iZXLIKBm4+C5nxlwpJ7"
`endif