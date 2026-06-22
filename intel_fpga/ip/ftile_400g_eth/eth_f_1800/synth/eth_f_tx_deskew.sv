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


//Simple TX Deskew moule
// This module generates a pulse every 32 cycles

module eth_f_tx_deskew
  #(parameter LANES = 1)
   (
    input wire 	     i_resetn,
    input wire 	     i_clk,
    output reg [LANES-1:0] o_dsk
    );
   
   
   reg [4:0] 		dsk_cnt;
   
   always @(posedge i_clk)
     begin
	if (~i_resetn)
	  begin
	     o_dsk <= ({LANES{1'b0}});
	     dsk_cnt <= 5'd0;
	  end
	else
	  begin
	     if (dsk_cnt == 5'd31)
	       begin
		  o_dsk <= ({LANES{1'b1}});
		  dsk_cnt <= 5'd0;
	       end
	     else
	       begin
		  o_dsk <= ({LANES{1'b0}});
		  dsk_cnt <= dsk_cnt+1'b1;
	       end
	  end // else: !if(~i_csr_rst_n)
     end // always @ (negedge i_resetn or posedge i_clk)

endmodule // eth_f_tx_deskew

   
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "o2ONPYJ6JWO2K/lQHkyApXo6DVczB8sUyJtLpEiYtF7LL07s93qi8rQ7d2s1AdTOt/BNVdBoSTLCdACDT58BR3umvYuucV6Cbb36lNsOsJegwtedOJsDvTnB14ZLU41EvDEX+uxr7iJUYiTmn7hunq22K1+T/Nc7+FaTNr6AMH3CCuiZmo/CmXjVXLRPwF034Kg1mVvlsNTpZhm0ORjPpNI8tuMP0bMp6HLhHMKVKvcrewc1S6b/L9ooIUw9PiUhZCqgXtwoeNGpYygRxTObQPpQmu/66AspQvf4AzjckyDZ5X5F6KTlIpBjnMYjOs70fnVy2Cys3lo/aiS6tQp4je85PtDV43MYyn6Alr1x60RGDwqbaq6TlDaj3ezyAwURJ45tGejfHkCIFNXoJXDAHxbclu3rgtcAttdygjlFXjiwXUi3nkXLa+qd8+0FbWYS+Mm2graZ5ph3+naMc879EA8M/ImovDU7MRwtgz7NORpIgdr7YqPsLTwYsXq08xYgQHuJBqBLgFzWw6rN3LG8syivqPi/V2fzH010AzWdsV4+BWcfhP+Kuy7s9GndjJvBIh8ttnR4ZHnnhI+CIKAsPydRu2yMjwsh4F16ScxatLyORCSNHxbU6UzZAtN39NvpF8vqcgYWpz3cVGa1lTKgHVwhuNPcc/8QThJHYyXwOi64NumExtdUycrkGUzQxOLF7Kk4c7v+hEddHbaw3aYfDzVXluJTgeMOgFcM8ATELlTghycGECES5Lqz7YvL/vMi9klSITRh4YcQOwHs7BmF7JvJZTy1kKMcCd6WCVhCS9HS3GHUIyPJbkj7n4Xe9P42/ttvwJMGxooJum6xoHbYZ97ymg1dbAp94Tz9mj68utDRZoXF2tCUBPOBuUaOLMxdMtZdC6f0Lj0qFZLC1CaUijlNkwO26v9qpg6caHMfndZtLXjpIxEEQYUOqJe6OK2rNw/22mX5h+HrzqqLWDxC7j9rcIRBQ8Xgiash26kCmWUkmbRGNLVPDQjczdHymCv+"
`endif