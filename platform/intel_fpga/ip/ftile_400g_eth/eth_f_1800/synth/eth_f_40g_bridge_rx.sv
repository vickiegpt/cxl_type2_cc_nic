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

module eth_f_40g_bridge_rx #(
  parameter SIM_EMULATE    = 0,
  parameter WIDTH         = 64
)
(
   input   logic 			 	      	      i_clk,
   input   logic				   	          i_reset,
   input   logic                			  i_rx_valid, 
   input   wire  [0:3] [WIDTH -1:0]           i_rx_data,
   input   logic [0:3] 			              i_rx_inframe,
   input   wire  [0:3] [2:0] 	        	  i_rx_empty,
   input   wire  [0:3] [1:0]      	          i_rx_error,
   input   logic [0:3] 			              i_rx_fcs_error,
   input   wire  [0:3] [2:0] 	        	  i_rx_status,
   
   output  logic [0:1] [WIDTH -1:0]           o_rx_data,
   output  logic [0:1]                        o_rx_inframe,
   output  logic [0:1] [2:0]       		      o_rx_empty,
   output  logic [1:0] [1:0]                  o_rx_error,
   output  logic [1:0]                        o_rx_fcs_error,
   output  logic [1:0] [2:0] 		          o_rx_status,
   output  logic 				              o_rx_valid
 );
 
   localparam  BWIDTH = 1+3+2+1+3+WIDTH;  // if + empty + error + fcs_error + status + data
   logic 			                	 mem_sel;
   logic [1:0] 			       			 empty;						
   logic [0:3] [BWIDTH-1:0]              fifo_wr_data;
   logic [0:3] [BWIDTH-1:0]              fifo_rd_data;
   logic [0:1] [BWIDTH-1:0]              fifo_dout_reg;
  
   assign fifo_wr_data[0] = {i_rx_inframe[0], i_rx_empty[0], i_rx_error[0], i_rx_fcs_error[0], i_rx_status[0], i_rx_data[0]};	
   assign fifo_wr_data[1] = {i_rx_inframe[1], i_rx_empty[1], i_rx_error[1], i_rx_fcs_error[1], i_rx_status[1], i_rx_data[1]};
   assign fifo_wr_data[2] = {i_rx_inframe[2], i_rx_empty[2], i_rx_error[2], i_rx_fcs_error[2], i_rx_status[2], i_rx_data[2]};
   assign fifo_wr_data[3] = {i_rx_inframe[3], i_rx_empty[3], i_rx_error[3], i_rx_fcs_error[3], i_rx_status[3], i_rx_data[3]};  
		

 //empty[0] - 2nd set of 4-lanes data i.e. [0] & [1] are read out. 
 //Indicates true empty of both FIFOs - !empty[0] used as read enable
 eth_f_scfifo_mlab #(
		.SIM_EMULATE (SIM_EMULATE),
		.WIDTH       (2*(WIDTH+1+3+2+1+3))
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
		.WIDTH       (2*(WIDTH+1+3+2+1+3))
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
	
	assign {o_rx_inframe[0], o_rx_empty[0], o_rx_error[0], o_rx_fcs_error[0], o_rx_status[0], o_rx_data[0]} = fifo_dout_reg[0];
	assign {o_rx_inframe[1], o_rx_empty[1], o_rx_error[1], o_rx_fcs_error[1], o_rx_status[1], o_rx_data[1]} = fifo_dout_reg[1];

	
	always @(posedge i_clk) 
	begin
	o_rx_valid    	<= !empty[0];
	end 
 
endmodule 
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q448mIufjSEgyfcFkGvobR0kAVqX1uLMLH0sSdyxEBdRNErxEZ/iQVfRqEA7oZBR2hYFPCJY1z1qHiwcl3AyatNb6rYjQdqJMjxEmxI79OZLrbuzcdmfYGQ6LGR8H1MKn+tZjOaXVrQf2qBsR+8KKmkka0dHEVAdFbZ6NvSDYMxlvOdoFhqyWSBxHItwXzaPre2zlm91/tAE4V6S6SqWjuZfy36g0uB8IS5xeLLvsSxF4jnT7dcCfPZ+2QQ08BfNeHiWD+ZeLbBzTWhvkNe5c6O7bbXTAXbDJViDc4nF2SOjM/qQSk3/QXKGDcv57BlnfG6ayk9AMEiEGaLyWUXJtBmUgRBQ0ycl/7N9UU7OHItiR4QNwVhVW9bLIA1R0KLZKLUTRI+vkJFYDCYd0MullqFkvj2flFeNgUxlIeGkA7jwNEaugROnGdC3aThukaM//Ag/hUV1W8CTpd/2HKzwwwcc/kBNAYBraLwQi51x+WDPzKCN57yOnqkDS0xO9+BiGnLvuYj4M0uhrWuCktZzGB1lMvK0fJwNLpjf01DdL+US8bvXbbPf5S+OJoCoUGDd7yeEixhrPtBc4jewzLrUNQFUr/1TR+6wcjAQI5rt3ZGU0fMIFSVSE0M11XDQFJnml4hYpTTk645bvsQDEhSVPgc0WT+tnlR4NqbcX3MyEm3ahWAT8U1JzWSbJGi/2yEaFFvFeqEn02bd3I0MHOq92oOJ4frNZlN3OUyTnB+e0RR8JxdKbHbmFYL+JjdneSvRGLrpDZuLPpLETxiECZtCXF8B"
`endif