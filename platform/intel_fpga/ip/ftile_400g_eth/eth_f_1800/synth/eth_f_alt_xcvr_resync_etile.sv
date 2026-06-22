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


// (C) 2001-2019 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// Module: alt_xcvr_resync_etile
//
// Description:
//  A general purpose resynchronization module that uses the recommended altera_std_synchronizer 
//  and altera_std_synchronizer_nocut synchronizer
//  
//  Parameters:
//    SYNC_CHAIN_LENGTH
//      - Specifies the length of the synchronizer chain for metastability
//        retiming.
//    WIDTH
//      - Specifies the number of bits you want to synchronize. Controls the width of the
//        d and q ports.
//    SLOW_CLOCK - USE WITH CAUTION. 
//      - Leaving this setting at its default will create a standard resynch circuit that
//        merely passes the input data through a chain of flip-flops. This setting assumes
//        that the input data has a pulse width longer than one clock cycle sufficient to
//        satisfy setup and hold requirements on at least one clock edge.
//      - By setting this to 1 (USE CAUTION) you are creating an asynchronous
//        circuit that will capture the input data regardless of the pulse width and 
//        its relationship to the clock. However it is more difficult to apply static
//        timing constraints as it ties the data input to the clock input of the flop.
//        This implementation assumes the data rate is slow enough
//    INIT_VALUE
//      - Specifies the initial values of the synchronization registers.
//	  NO_CUT
//		- Specifies whether to apply embedded false path timing constraint. 
//		  0: Apply the constraint 1: Not applying the constraint
//

`timescale 1ps/1ps 

module eth_f_alt_xcvr_resync_etile #(
    parameter SYNC_CHAIN_LENGTH = 2,  // Number of flip-flops for retiming. Must be >1
    parameter WIDTH             = 1,  // Number of bits to resync
    parameter SLOW_CLOCK        = 0,  // See description above
    parameter INIT_VALUE        = 0,
    parameter NO_CUT		= 1	  // See description above
  ) (
  input   wire              clk,
  input   wire              reset,
  input   wire  [WIDTH-1:0] d,
  output  wire  [WIDTH-1:0] q
  );

localparam  INT_LEN       = (SYNC_CHAIN_LENGTH > 1) ? SYNC_CHAIN_LENGTH : 2;
localparam  L_INIT_VALUE  = (INIT_VALUE == 1) ? 1'b1 : 1'b0;

genvar ig;

// Generate a synchronizer chain for each bit
generate for(ig=0;ig<WIDTH;ig=ig+1) begin : resync_chains
	wire                d_in;   // Input to sychronization chain.
	wire				sync_d_in;
	wire		        sync_q_out;
	
	// Adding inverter to the input of first sync register and output of the last sync register to implement power-up high for INIT_VALUE=1
	assign sync_d_in = (INIT_VALUE == 1) ? ~d_in : d_in;
	assign q[ig] = (INIT_VALUE == 1)  ? ~sync_q_out : sync_q_out;
	
	if (NO_CUT == 0) begin		
		altera_std_synchronizer #(
			.depth(INT_LEN)				
		) synchronizer (
			.clk		(clk),
			.reset_n	(~reset),
			.din		(sync_d_in),
			.dout		(sync_q_out)
		);
		
		//synthesis translate_off			
		initial begin
			synchronizer.dreg = {(INT_LEN-1){1'b0}};
			synchronizer.din_s1 = 1'b0;
		end
		//synthesis translate_on
				
	end else begin
		altera_std_synchronizer_nocut_etile #(
			.depth(INT_LEN)				
		) synchronizer_nocut (
			.clk		(clk),
			.reset_n	(~reset),
			.din		(sync_d_in),
			.dout		(sync_q_out)
		);
				
		//synthesis translate_off
		initial begin
			synchronizer_nocut.dreg = {(INT_LEN-1){1'b0}};
			synchronizer_nocut.din_s1 = 1'b0;
		end
		//synthesis translate_on	
	end
	
    // Generate asynchronous capture circuit if specified.
    if(SLOW_CLOCK == 0) begin
      assign  d_in = d[ig];
    end else begin
      wire  d_clk;
      reg   d_r = L_INIT_VALUE;
      wire  clr_n;

      assign  d_clk = d[ig];
      assign  d_in  = d_r;
      assign  clr_n = ~q[ig] | d_clk; // Clear when output is logic 1 and input is logic 0

      // Asynchronously latch the input signal.
      always @(posedge d_clk or negedge clr_n)
        if(!clr_n)      d_r <= 1'b0;
        else if(d_clk)  d_r <= 1'b1;
    end // SLOW_CLOCK
  end // for loop
endgenerate

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "o2ONPYJ6JWO2K/lQHkyApXo6DVczB8sUyJtLpEiYtF7LL07s93qi8rQ7d2s1AdTOt/BNVdBoSTLCdACDT58BR3umvYuucV6Cbb36lNsOsJegwtedOJsDvTnB14ZLU41EvDEX+uxr7iJUYiTmn7hunq22K1+T/Nc7+FaTNr6AMH3CCuiZmo/CmXjVXLRPwF034Kg1mVvlsNTpZhm0ORjPpNI8tuMP0bMp6HLhHMKVKveemT1T2fOmBV4AyLDWTupk23+z1DJmDEuHhYzgN8k488smupHNpZPvTfTIgUhV4IWznBtkj9XSLg+tB3ASvJDJM+rb9lUIEnvjPfPgt5OBDLZokuYpv/LnEBE9srisH+dp2Rnge0vkVvdhFftAE+7df5nDD3kMWsrRGcXUoBIj2yI5BUVReb/GBnslMGAvusAC8uylqpQVDUegPz1RTUDYdEIxZMZnW4CXYsKTi8jzATQ444/nwItrbwsDKEPJU5IwlADiLpYHuS67nhvNDBzVUN5aWWMKu2H5E0p2wYzW6/ZmG2465c/9k6vqsSQD+jUt9J7AtEgdz/odt/v6L3Zc82CLv1hjIQeHux6HstyZrzhEzHp1t3MXRu4PVH1KZxQmwizRv/VrchGvHzn4GVhAfS9XeIXvP8JUN4y/FkcwLuIiuKwzvJtMhuA/GWsb3TRWWukPnY0VDx/zDRMjbEWz+s3LCOw7LFRa12hKjOeWelK6IN+K8za+slIBt1XSJfkWpNq56AKfsx7uNrlh+wXbgbOq4u8aTo+rB4dXvSpAhkWadiEGIJIqLSzOnq5cwvkZ/AOrRbvrwFVnps1WUryx9TDIHHuMg/Mdomx4oh0zmQ4mqZM3XVf4SLHQJUSI9NpdvwpMuTYyC1o4FCMG3ZhV7OeqU7JMhTQjQSLqOZg0UfrT2Uf7+LKWfZaLHCErOuFRIEuGYS7bI7C+dYyEBl/Tu4uPWQSSEWLKfuKG03MWaZa5IR63kYFk/XteLljr2mAq5TYD7bEi0kXCVYXDjXRu"
`endif