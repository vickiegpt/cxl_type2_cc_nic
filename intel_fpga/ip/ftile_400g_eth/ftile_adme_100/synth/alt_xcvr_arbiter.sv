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

// Same as  ../../../altera_xcvr_generic/ctrl/alt_xcvr_arbiter.sv without timescale

//altera message_off 16753
module alt_xcvr_arbiter #(
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
`pragma questa_oem_00 "WfFVdyql8MX8mXVyk/o4uVHSVnI9UjJRGwwb336nmAdX9+mpbJ6mSUQss63YcuDLPsviS3zV3x4H9/ufzDWJhiMsMk5su3c3a5t6emal0wmMuzlCaBg8nX2HnASXWZFYdD2lZ2f9WQiT7YBk8pWHWPxL53F3O5UwUiGEgA9T6isaFpMPrEoSO+HPNTvZNfnymv7c7T92tiM6OA3+qWyhLObaJSiFnbSgEzJeHEkIUwqeUTEf7PJGt05dC/QQxsJzBdeNeoD+8spfqGEwL1aK4gxsmF+O5QFCkLBuIExmPepeXiAX+UKAX4Cts24x+1lVKBr1NIxmve3BBdGFy+sJtWI3Qjyb9M9zrA7g2X+wZLAkYADgcH/MrqPSjCvt5+7DtCfAkSgH+c2n3fMOZrjTikfjHy9V7tw8PX+GfqubbiJmupvKTRuxQ81uwIvnGCuSOVUyh+DKp7NcDRH0h8JDyM28QzT2YbbdgEbthoiMEKNSU9WbzsXB0BcnSp+NVlBJ1GmqpNB9yd2yA1jcJJkcqspYrpMXzJiUsqVHZ9Yd6DT+1qeTvTJuLMPbRJx33mc/VyWHEUPeW6AqWkwPYLaxJuC/go9hYl5vQTp/8KcXnP9kOAegxgSS/RpasJlvM2ei/l/jKcxxKtUgGTh1E6vRA8rZeiUNIowehAECYnI231Gt+lmB5DE2f860LsLqiymUMss0ehYJsgCg9fdKetusR4Kj2wjGDWCfpDfL3uVdFS5dvMe3qVWLTJwaIJUxRDYniBQgE7Dux1VE9JBHGBhZ1Npu08EqtWrd14K8NyGOdT0uxlielvgxkjhp6P3Gqhm1h9ylmbdcs6PzARlLjNcLr/1sZW9sH1ol6Nnd7uGUr4DVpxMeCxtwOdzs4U03es4buONI8cWyfr2ZphscCA1JPUkBRroYunQgAqV5SGDnkSu3CnKXQkqgFs5o4FPZNlsnJm/NU8pNhavweTVAz4FK/8fFq7Sm+FMI8IUoKnIy3wkg5NYxc5eU9IkeASxw4ZIN"
`endif