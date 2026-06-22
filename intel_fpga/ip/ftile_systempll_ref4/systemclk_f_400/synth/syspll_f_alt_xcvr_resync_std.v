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


// Module: alt_xcvr_resync_std
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

module syspll_f_alt_xcvr_resync_std #(
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
		syspll_f_altera_std_synchronizer_nocut #(
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
`pragma questa_oem_00 "WfFVdyql8MX8mXVyk/o4uVHSVnI9UjJRGwwb336nmAdX9+mpbJ6mSUQss63YcuDLPsviS3zV3x4H9/ufzDWJhiMsMk5su3c3a5t6emal0wmMuzlCaBg8nX2HnASXWZFYdD2lZ2f9WQiT7YBk8pWHWPxL53F3O5UwUiGEgA9T6isaFpMPrEoSO+HPNTvZNfnymv7c7T92tiM6OA3+qWyhLObaJSiFnbSgEzJeHEkIUwrBr9lTRQoJ24DKF4a6xoW/TLmnnnl3HSSBDwbDF34j470IhECC/Q9pxvh0NkfVdVC/68l8KVF35VK1CmdGQ9oxjSTUw53+6kez/cOWaKvhwBdMsz6F2S2rWiWqUveieWsHBgh7pP8+8wJOiZSjoNhktUs7wjfEuwymJ0f2BqSjK+vr6dQsCsrvGs4UChueNZpWM79dYHzQPh1QSSKNCb9X7BqC3bFiV+7tD3e2I0mdMJsYQbGBR1OQqf45ZSctwTZvlQHDh25nUgrph3wRNEpo9fobC3XqYlckwEcUtd9+8vG2Z/QqbRHtl4DdZMk4ui9fxvVc58Up9sOfLZ3w9jh7miTmGNrXva/85v/O/8BbkMFu1RLekZmJwj+w7Z2MJYgWJQ8WzEvv4VE1mnSI8Dy0GL/QqoP1lS242dO+mD+1DEj4pFBgV0tDPJ1TMwSU7x4ma3FUohlsMDuicBpRRLBTiePeJqgLMvYC0YKqxRZkoSd13KCQvRqia14D2Y4fLAeQegjksC6zJ2wGsd+DGwWTUGLr3IPrZ0UAVyeQWciFdNvbqGcae2kmMafy21lwYnA9Yqc2CZzA4KyEd9ukeYQ6BGcqAYSxcmOwJOMLwqpOzzAOMuJ+8rREOuqRkItBAM/oEnx9gDMS12fnKGgbxaYZ3q7ElW72aPjbXWp/C+UGqL31Su5SHGckQiAv0ZlKfTwNhdFr25zOCg1Z03SBOO8qAQO3wCGRPuuxlu03ApyVe7QaybM1sSG12+pGQHqB7w9yQ7GYXJpC0+J7TTGzHXBX"
`endif