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
// baeckler - 06-06-2012

module eth_f_reverse_bits #(
	parameter WIDTH = 20
)(
	input [WIDTH-1:0] din,
	output [WIDTH-1:0] dout
);

genvar i;
generate
	for (i=0; i<WIDTH; i=i+1) begin : lp
		assign dout[WIDTH-1-i] = din[i];		
	end
endgenerate

endmodule
// BENCHMARK INFO :  5SGXEA7N2F45C2
// BENCHMARK INFO :  Max depth :  0.0 LUTs
// BENCHMARK INFO :  Total registers : 0
// BENCHMARK INFO :  Total pins : 40
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :                         ; 1               ;       ;
// BENCHMARK INFO :  ALMs : 1 / 234,720 ( < 1 % )
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "4AvUa/AX+twoSNmlxf8DfgbJZtLM0FTYaDfqwIVh58kyS9m523ZPwLwxNf/MAu2Ws24gvNuIWubOgwJDJF/J8SquMj7R1nNyipeKzuCa44Ouq3sVSfXA6vNne7RbKwd87qtqmEuaCdIDSUZZO8uw+CWUHgUS5S0PLelh7tY7EIuUsZeE9mUM9zh2JvtzuWMzW1qicCsSFUI1HHB6Owmf0ylz2E7BXtP0spRRZWMpnQ16HyIKrrUGEh/g7miuSrQY3bIoa6WoPhBpMzjcuN5l7JxL5NQLybjDjNvcteiRGovkIMvdD3UZUazZlLXC+2OnED4uEAFCEfoij+mQ3/8mw2pBBx85CZGSwx1+lMo7xmKKyAy7Z6kp/afvw+mTtffqXixtka4dO0wQCEDj3mJh9ArSYigU6tUDXEOWbaQ7Dzx/1hr28KCc8y4KInBb39iSiyU6gnyU+svFZ7p07vsM1JQTAP4TMBtz33be85Qy5wukMqlFmC8Jq9rJq4K06iyr739fk7ejOlX6Pe1yi9ZQYjhhc9xXAf8B4jtslsaIYpw2LLGbRKDCbrlOPxKlXnT5vucGgzMlUr8x0coHU0kHeJkbqPRK8lcxU4GARIe+ukDpZZIb3kiS6roy7RyHrqqRPemFXBBfx0AMe5hmEngwZLz1ePaGyBf596x2foQEdlwDM67v+KMQmoHNNfZ4bfMd2EYKaPi6aTEM6VsrNWW5RcxnvBiXD35spXaZgXfhUGgauspCIoQRZRDLJ9ekJsRrjlr+JbZGnA4q6LlLst+onG9OSRytGhM71dgulScjOAor6Dd32qSBoLVDep6SOZxMgL3wIrq8ZNkBwxmR0gNjyfoaIBb7LR1OJZWhuZTuSx9z6HFtQCiiquNa5smya0qGx6ugt1bCp0+Dv9ULsQRf0jDI+9GJisj0qZZishp5P3mLlpAyQjbbBtJtsEIx3UvXWWhXIDdXO/MSE6KTzHOCst0NDqqdGGDGNHDFcgUu1w1pQF5Nq5CO3kiyggi3d1H6"
`endif