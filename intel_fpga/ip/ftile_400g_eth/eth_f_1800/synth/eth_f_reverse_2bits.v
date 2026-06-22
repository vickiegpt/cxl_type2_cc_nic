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


// $Id: $
// $Revision: $
// $Date: $
// $Author: $
//-----------------------------------------------------------------------------

`timescale 1 ps / 1 ps
// baeckler - 10-15-2012

module eth_f_reverse_2bits #(
	parameter NUM_SYMBOL = 32
)(
	input [NUM_SYMBOL*2-1:0] din,
	output [NUM_SYMBOL*2-1:0] dout
);

genvar i;
generate
	for (i=0; i<NUM_SYMBOL; i=i+1) begin : lp
		assign dout[(NUM_SYMBOL-1-i)*2+1:(NUM_SYMBOL-1-i)*2] = din[(i*2)+1:i*2];		
	end
endgenerate

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "4AvUa/AX+twoSNmlxf8DfgbJZtLM0FTYaDfqwIVh58kyS9m523ZPwLwxNf/MAu2Ws24gvNuIWubOgwJDJF/J8SquMj7R1nNyipeKzuCa44Ouq3sVSfXA6vNne7RbKwd87qtqmEuaCdIDSUZZO8uw+CWUHgUS5S0PLelh7tY7EIuUsZeE9mUM9zh2JvtzuWMzW1qicCsSFUI1HHB6Owmf0ylz2E7BXtP0spRRZWMpnQ05cll5K69ZG3kg2+3H/u6bgLki1uSdzRKwp0W3TGnja7KU0Hfq/j66CTnLRQwT+1h50a+RVXqO+0PUl8jgo1qja9qaeGokeyy2+zslu2XxELPjxcNBAwfnXYx3W1131jEZNwYFcfgobLHNPbd7dhK/9JM+dC/N6+M+8pBTpQqIU8ElwIl5m+PlzX09DcLtKVbnqYN0ZMX7FMOv3kyq1nMyRwuJHvMmzuZZXlCFBiHpfFFSCFmbDnVjtLOMtrFxc3adGCmatrV5tU5DzgxAUiI2TWzd6kvX3EoUpmDJGtUr8vKEsHBLoqRRt/IeVFdq8I9Sdu2nHDCmKJMMZDjMWf4w30RxITqRBl3KTlGm5bJmdDX5XJmEeuGgRWqPDwHqjqhzwtsezk0pb5kA2GVb/D9sDpxNlgDAjDPLEj86SYPlvq+IE3yw5GZbm9HqDkjKkyEQbWhvaUvGTmxA/qgOiDgJBs7/aROfZQXissDssO4uPhkhNVaSPS7kMzavNStzkJtLOqjxj/TWOFOzNqy9nBgG59ITuZNrYP5AG2vthB5njwk4uUociuzgjbjaz9XDkhqcNgicrYdy4/TOZmTqO3PJo/RTWaOMHAjg518dSnbaesTuYrQCKudzUynEdFixKHWnTftBx3k5NjTyfjdgnBSdWMvgpv9uHvjeNJqaPAbQLVFNiKyxuEw/xhe14Y4qOmY+4/pX2dwtym8gHf4IBjt8ap71Qi/05MiXdxAaG4bahx0LYNj2i8qFX8UfembrzKU20p/XGO+BDCw0xBPTbW44"
`endif