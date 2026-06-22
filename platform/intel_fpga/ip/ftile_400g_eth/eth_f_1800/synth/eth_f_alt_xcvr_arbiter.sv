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


// Clocked priority encoder with state
//
// On each clock cycle, updates state to show which request is granted.
// Most recent grant holder is always the highest priority.
// If current grant holder is not making a request, while others are, 
// then new grant holder is always the requester with lowest bit number.
// If no requests, current grant holder retains grant state

// $Header$

`timescale 1 ns / 1 ns
//altera message_off 16753
module eth_f_alt_xcvr_arbiter #(
	parameter width = 2
) (
	input  wire clock,
	input  wire [width-1:0] req,	// req[n] requests for this cycle
	output reg  [width-1:0] grant	// grant[n] means requester n is grantee in this cycle
);

	wire idle;	// idle when no requests
	wire [width-1:0] keep;	// keep[n] means requester n is requesting, and already has the grant
							// Note: current grantee is always highest priority for next grant
	wire [width-1:0] take;	// take[n] means requester n is requesting, and there are no higher-priority requests

	assign keep = req & grant;	// current grantee is always highest priority for next grant
	assign idle = ~| req;		// idle when no requests

	initial begin
		grant = 0;
	end

	// grant next state depends on current grant and take priority
	always @(posedge clock) begin
		grant <= 
// synthesis translate_off
                    (grant === {width{1'bx}})? {width{1'b0}} :
// synthesis translate_on
				keep				// if current grantee is requesting, gets to keep grant
				 | ({width{idle}} & grant)	// if no requests, grant state remains unchanged
				 | take;			// take applies only if current grantee is not requesting
	end

	// 'take' bus encodes priority.  Request with lowest bit number wins when current grantee not requesting
	assign take[0] = req[0]
					 & (~| (keep & ({width{1'b1}} << 1)));	// no 'keep' from lower-priority inputs
	genvar i;
	generate
	for (i=1; i < width; i = i + 1) begin : arb
		assign take[i] = req[i]
						 & (~| (keep & ({width{1'b1}} << (i+1))))	// no 'keep' from lower-priority inputs
						 & (~| (req & {i{1'b1}}));	// no 'req' from higher-priority inputs
	end
	endgenerate
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "o2ONPYJ6JWO2K/lQHkyApXo6DVczB8sUyJtLpEiYtF7LL07s93qi8rQ7d2s1AdTOt/BNVdBoSTLCdACDT58BR3umvYuucV6Cbb36lNsOsJegwtedOJsDvTnB14ZLU41EvDEX+uxr7iJUYiTmn7hunq22K1+T/Nc7+FaTNr6AMH3CCuiZmo/CmXjVXLRPwF034Kg1mVvlsNTpZhm0ORjPpNI8tuMP0bMp6HLhHMKVKvevOefRjgcFEVRw0JR0133VD41mVGN7bOrCivF4lnwjcZ8BZWXdTKP4dBm856aXMk7kuXAMMH8idDXCQgZeBjNKHcXFePvhU+h0H44JM/U1b/4eCb+cMOrXzrqBNSBE2ZTJgFItdIDh4g9fqUD5fsWwXqs6O/BKWSxYHfwTn022MrH/DXqAxGhucgvUqCoQeE7lFH1wyDpnENivPbWEC2TjgEjUJ54cR5LGilu3byLldr+z5P8ZGfiJ6VBb9T/p9kwHWCwemxvfFxOXfTu/++fNctTbu4Zl9OM6WmQBzrdOBtwMMeeclDkPBcXk0FOE4yAHDX3NPCLLjOcWeDkTpQU1kM0ycz7wBLQE0SVQD0rPfi2RmHoINKLcaX7Gn4RaN0k4jttzp137XY+9t/ptbvqQB/paw7Ov07PCIvMYghzc9WkEsI5ZDDwLffSL3arXpJQXckSly+v7VJdzFRnOi5ZoJYBYFRIN8APR6DAZ2SzsRiUUIadkIdjjlfClQaE8wDETZx+L/zY1/Omh+nCifFwYB3QWILAETCq7XvBJyoUofjO2bV27PKsYNMYaupzta+4YOfcc2LGKYJW7lmFK/wdlJIqtXDvI89LHsho4pn/9FW5ZdDHknvNk93oq/7rVPmSpQu3A9om1opREpmBi+ApqJhyovRX1UBtLOffuqItXX538spcxQeGjrUi0MlyHTqIBDS76IzYu+ZCW3JY31PRekm1dwmSQX+z9jJfkxeLwXXvIQTNEBYBqoG4OUxUaFPi4arGpGD4+V/6FF71AtNKw"
`endif