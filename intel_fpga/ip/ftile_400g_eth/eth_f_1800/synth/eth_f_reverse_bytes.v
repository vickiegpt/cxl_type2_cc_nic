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

module eth_f_reverse_bytes #(
	parameter NUM_BYTES = 32
)(
	input [NUM_BYTES*8-1:0] din,
	output [NUM_BYTES*8-1:0] dout
);

genvar i;
generate
	for (i=0; i<NUM_BYTES; i=i+1) begin : lp
		assign dout[(NUM_BYTES-1-i)*8+7:(NUM_BYTES-1-i)*8] = din[(i*8)+7:i*8];		
	end
endgenerate

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "4AvUa/AX+twoSNmlxf8DfgbJZtLM0FTYaDfqwIVh58kyS9m523ZPwLwxNf/MAu2Ws24gvNuIWubOgwJDJF/J8SquMj7R1nNyipeKzuCa44Ouq3sVSfXA6vNne7RbKwd87qtqmEuaCdIDSUZZO8uw+CWUHgUS5S0PLelh7tY7EIuUsZeE9mUM9zh2JvtzuWMzW1qicCsSFUI1HHB6Owmf0ylz2E7BXtP0spRRZWMpnQ0amXmOXUBUHTt6FiFxB1bMyu7FPlxCXYntjIeNzhs3JpmULk5n0+x9ttRQcPtUCVq73dtbgKC1iYre/2UBI9DQ+PMuEJkBOn5UGpIANoJhCUv673b9ErzAdS0iMalGqKXlsrBrKGyKuU5TqyiE+rCQvDK2wFxsBZkh4cViJLDKm1wVYLnQrK6fIazgl25yGieQ31bcXx5Y+UbExcQHv/j8LWb53Bbp4DHwCc+s8LZ57s7tvUtstY75C33g2Oe3DKKkma9i7DA7z80dsqtQwXPSu5QCzX5CemIHeeVqE5/S6yeNdBtCVU2yPNZZCv/16EN/Z5r9I4UmxWPYtA8hOJwK1OUeWDlHjlBx7Po1dB84I4XjEMzR0USjdayaWkw/vhh5uN0FILpWnm04E3I2msyx3nijgTsLv2MzjdXTB8UeOQUWVID+T3tkEPorb3Zp1MVGEj08MFxrD0nXf01tYb/i9BkxdeB9Vb9p4Fb1cCP0c8785rf8tZ71/kyzmtbWCIF1WXPAKo0bHZLDeQ6VBkm1jGHykkuCniGySK5TMy1j895/9Z5XtE4+FiPjFtookJXFvZeovaE6LWkXW8GxAldqsjUxPaSiFo0Wh/L790v+OmLGQWX9buxvKPUdbZdGeHz5nB6asMxxUDvbwkClAqVrvy9I5fjXaBWmyTFP5F3voJM55uP3abxV8/Mbrj3+1Faxx6k2AFwtuNhm61YTWphXis9lS+CrFura820552DGq2+cD79BSbZH+J5hE27XnaddBIZJydyabCplcVcBWMsw"
`endif