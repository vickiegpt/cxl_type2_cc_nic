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

module eth_f_reverse_3bits #(
	parameter NUM_SYMBOL = 32
)(
	input [NUM_SYMBOL*3-1:0] din,
	output [NUM_SYMBOL*3-1:0] dout
);

genvar i;
generate
	for (i=0; i<NUM_SYMBOL; i=i+1) begin : lp
		assign dout[(NUM_SYMBOL-1-i)*3+2:(NUM_SYMBOL-1-i)*3] = din[(i*3)+2:i*3];		
	end
endgenerate

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "4AvUa/AX+twoSNmlxf8DfgbJZtLM0FTYaDfqwIVh58kyS9m523ZPwLwxNf/MAu2Ws24gvNuIWubOgwJDJF/J8SquMj7R1nNyipeKzuCa44Ouq3sVSfXA6vNne7RbKwd87qtqmEuaCdIDSUZZO8uw+CWUHgUS5S0PLelh7tY7EIuUsZeE9mUM9zh2JvtzuWMzW1qicCsSFUI1HHB6Owmf0ylz2E7BXtP0spRRZWMpnQ1u4pKsp7i0c8zVZOBhLCcn4t70aD0u8DM5JwRrsxU2L0VcvHJSIDTAfHpINj8nywhSvQ8sSpc1UFsMjWQORy15Ge/PuiIuKnUu31GAtZiU82YX5YT03INbOMi198eqQpI+mGZyIPE5u6uAUhU0kgnBvsLWsLVRFbOICn+kJj9/kJpzfzjgCiQelS3+8yyDzh2w47o39cgnp0f972luoo0CIAAv9Oh4g+nKk75RT83GORn0229J0g0Y1akMIHpDxu5o5hqB38dOW4FGXZaCWMI4NhJSFxR2FrLItdGUvUDhbhXILnD6EjPdFdihO2hnELszUywNAQSJYzEUOPUT7FDCSnSs5Opw/dpN5GAit2M6EIu9hjIm5/tjSm6ejSnrSiK+eRJmIwFpmWRp+HdwHDIGTXMfyGjlT4/3y9WyNFexaU3Id/Lvi+0XOXA9IfRRuU1JbJGu3E/Pns4SQubPqOp8siqc5xi1QtafuPRIwBEu4CIIjKOoim8V4H219raZnRAW1dkJbtl9wbpcrKKUFn6Bf3R6NvEBD2Z9mJ5Vzk+kUxo55RPTuzDBkRI6MMXN2BP0Y282nI8l77fl13uIMiVnDCu6RMPcU1MBZfGZ+fcmL1rcASZs/WQ41M6vBmg+5OdsHp7X6bdMnBIw8A6HSnWkp2DZ3D/w/3kIXYHMs6+mPeKsWxny2p2iFHFt1PlEvt4Msg9Wyh5dt0m8BjMWskhfOxMwgBOg9g14VXOD7oIj5f0fvptNoPOkkwDPcGOwUovs0qZLsEarncI4BhiOPQkr"
`endif