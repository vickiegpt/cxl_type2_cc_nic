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


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module eth_f_40g_bridge_otn_rx #(
  parameter SIM_EMULATE    = 0,
  parameter WIDTH         = 66
)
(
   input   logic 			 	      	      i_clk,
   input   logic				   	          i_reset,
   input   logic                			i_rx_valid, 
   input   wire  [0:3] [WIDTH -1:0]   i_rx_data,
   input   logic        		          i_rx_am_valid,
   
   output  logic [0:1] [WIDTH -1:0]   o_rx_data,
   output  logic                      o_rx_am_valid,
   output  logic 				              o_rx_valid
 );
   
   logic [0:1]                          o_rx_am_valid_temp;
   localparam  BWIDTH = 1+WIDTH;  // am_valid + data
   logic 			                	 mem_sel;
   logic [1:0] 			       			 empty;						
   logic [0:3] [BWIDTH-1:0]              fifo_wr_data;
   logic [0:3] [BWIDTH-1:0]              fifo_rd_data;
   logic [0:1] [BWIDTH-1:0]              fifo_dout_reg;
  
   assign fifo_wr_data[0] = { i_rx_am_valid,  i_rx_data[0]};	
   assign fifo_wr_data[1] = { i_rx_am_valid,  i_rx_data[1]};
   assign fifo_wr_data[2] = { i_rx_am_valid,  i_rx_data[2]};
   assign fifo_wr_data[3] = { i_rx_am_valid,  i_rx_data[3]};  
		

 //empty[0] - 2nd set of 4-lanes data i.e. [0] & [1] are read out. 
 //Indicates true empty of both FIFOs - !empty[0] used as read enable
 eth_f_scfifo_mlab #(
		.SIM_EMULATE (SIM_EMULATE),
		.WIDTH       (2*(BWIDTH))
	) i_bridge_rx_scfifo_mlab_1 (
		.clk     (i_clk),
		.sclr    (i_reset),
		.wdata   ({fifo_wr_data[0],fifo_wr_data[1]}),
		.wreq    (i_rx_valid),
		.full    (),//unused
		.rdata   ({fifo_rd_data[0],fifo_rd_data[1]}),
		.rreq    (~empty[0] && mem_sel==1), 
		.empty   (empty[0])
	);
				
   eth_f_scfifo_mlab #(
		.SIM_EMULATE (SIM_EMULATE),
		.WIDTH       (2*(BWIDTH))
	) i_bridge_rx_scfifo_mlab_2 (
		.clk     (i_clk),
		.sclr    (i_reset),
		.wdata   ({fifo_wr_data[2],fifo_wr_data[3]}),
		.wreq    (i_rx_valid),
		.full    (),//unused
		.rdata   ({fifo_rd_data[2],fifo_rd_data[3]}),
		.rreq    (~empty[0] && mem_sel==0), //data from this FIFO should be sent out first
		.empty   (empty[1])
	);
	  		
//read toggle logic		
	always @(posedge i_clk)
	begin
	  if (i_reset) begin
	     mem_sel <= 'd0;
	  end else begin 
	     if(!empty[0]) begin
            mem_sel   <= !mem_sel;
		end
      end
	end
	
    always @(posedge i_clk) begin
		if (mem_sel == 0) begin
		   {fifo_dout_reg[0],fifo_dout_reg[1]} <= {fifo_rd_data[2],fifo_rd_data[3]}; //first
		end else begin 
		   {fifo_dout_reg[0],fifo_dout_reg[1]} <= {fifo_rd_data[0],fifo_rd_data[1]}; //second
		end
	end
	
	assign { o_rx_am_valid_temp[0], o_rx_data[0]} = fifo_dout_reg[0];
	assign { o_rx_am_valid_temp[1], o_rx_data[1]} = fifo_dout_reg[1];

	assign  o_rx_am_valid = o_rx_am_valid_temp[0];
	
	always @(posedge i_clk) 
	begin
	o_rx_valid    	<= !empty[0];
	end 
 
endmodule 




`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q45Bw6KO3WpLp6z9dQzppVsX9PWUEg2y+KLZW1PMK9bAukGR0L7Fee0fp9b9a84fmvMlyTE5uP/DTU71oapLjygPDVWejQEfnXqQIn3Q5OVF4yE0vvRQ116CxbJVFIq4/lBdo2+OJc76DH1tGupeZhs02097CzOWt0dDa/TlsmgrrHpQdLRFqlYtlzGQvTkJ/RaFZCUUQmqazBOYO+QI9CcgjfRIlant/2FE9alcV1ap61F3AykHfAuDA7tmVlzbpwCemVExHUiR/OcNr0br6zvbRCUk//6GMel6srQubF1K9PY7bPKFZD1Zwnx9EGoR8B/srJxXUIYb+TMRknip10L76RZyWE0YYgAp8lpjtmEzSiY7zha+ECAWp6PxlyT35qdbQ8xQycaY7cZyqeFiZpuE2kHy+B1QxhI0+ApLzJ0Ga7rQMUoS1e5FUbYy6np467q5kVYiCHKyn1GYa49wb8B3moYV6SAVoJwv9eBS33u3OIzjSWPEzvpoN+/VW2qslcPa5TfZP4vCkm//TV5REpuMjj33ARJWbdB90TkDJqHH3HvB785d7ZPwJBecdVt6ZdCCrydjiqLvj91w8hJGpCH00aGhlos0gJynz2dPKnoFsUlRdI3mTMtYY+lE6frAQdZsigBoIWE2XjihsFSUPnFCWRGbOWfrPZYROFO7H27+URJOkn05av2Z+uzLN+odq2xnjPR23Xn8i5QAIi7OsU/6IhE5dYCKjSGZrmdAPsmn4+Paqy2tW1ttt25vUBSGfMChaCxHmESZTNLFIRFJks9J"
`endif