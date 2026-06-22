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

module eth_f_40g_bridge_tx #(
 parameter SIM_EMULATE    = 0,
 parameter WIDTH         = 64
)
(
    input   logic 			 	      			  i_clk,
    input   logic				   	  			  i_reset,
    output  logic                                 o_tx_ready,
    input   logic                     			  i_tx_valid,
	input   logic   [0:1][WIDTH -1:0] 			  i_tx_data,
	input   logic   [0:1]             			  i_tx_inframe,
	input   logic   [0:1][2:0]         			  i_tx_empty,
	input   logic   [0:1]             			  i_tx_error,
	input   logic   [0:1]             			  i_tx_skip_crc,
	
    output  logic   [0:3][WIDTH -1:0]             o_tx_data,
	output  logic   [0:3]                         o_tx_inframe,
	output  logic   [0:3][2:0]                    o_tx_empty,
	output  logic   [0:3]                         o_tx_error,
	output  logic   [0:3]                         o_tx_skip_crc,
    output  logic 							      o_tx_valid,
	input   logic                    			  i_ready
	
 );
 
    localparam  BWIDTH = 1+3+1+1+WIDTH; // if, crc, error, empty, data
    logic 								  empty_w;
    logic 								  full_w;
    logic  			   				      mem_sel;
    logic [1:0]			   		          empty;
    logic [1:0]			   		          full;
    logic [0:1] [BWIDTH-1:0]              fifo_wr_data;
    logic [0:3] [BWIDTH-1:0]              fifo_rd_data;
    logic [0:3] [BWIDTH-1:0]              fifo_dout_reg;
    logic [7:0]                           cnt;
    reg   [30:0]  used;
    localparam  PWIDTH 		= 5; //FIFO Address width 
    //localparam  FIFO_LO_THRSH_VAL = 5'h14; //dec 15
    localparam  FIFO_LO_THRSH_VAL = 5'hE; //dec 15
    logic                        rd_flag; 
    logic                        read; 
    logic                        write; 
    logic                        rd_flag_d1; 
	logic   [0:3]                o_tx_inframe_d1;

 //write toggle logic
	always @(posedge i_clk)
	begin
	  if (i_reset) begin
	     mem_sel <= 'd0;
	  end else begin 
	     if(i_tx_valid) begin
				mem_sel   <= !mem_sel;
		end
      end
	end

   assign fifo_wr_data[0] = {i_tx_inframe[0],i_tx_skip_crc[0],i_tx_error[0],i_tx_empty[0],i_tx_data[0]};
   assign fifo_wr_data[1] = {i_tx_inframe[1],i_tx_skip_crc[1],i_tx_error[1],i_tx_empty[1],i_tx_data[1]};

  eth_f_scfifo_mlab #(
		.SIM_EMULATE (SIM_EMULATE),
		.WIDTH       (2*BWIDTH)
	) i_ehip_scfifo_mlab_1 (
		.clk     (i_clk),
		.sclr    (i_reset),
		.wdata   ({fifo_wr_data[0],fifo_wr_data[1]}),
		.wreq    (i_tx_valid && mem_sel==0),
		.full    (full[0]),
		.rdata   ({fifo_rd_data[2],fifo_rd_data[3]}), //read out first set of blocks at mem_sel=0
		.rreq    (read), 
		.empty   (empty[0])
	);
				
   eth_f_scfifo_mlab #(
		.SIM_EMULATE (SIM_EMULATE),
		.WIDTH       (2*BWIDTH)
	) i_ehip_scfifo_mlab_2 (
		.clk     (i_clk),
		.sclr    (i_reset),
		.wdata   ({fifo_wr_data[0],fifo_wr_data[1]}),
		.wreq    (i_tx_valid && mem_sel==1),
		.full    (full[1]),
		.rdata   ({fifo_rd_data[0],fifo_rd_data[1]}),
		.rreq    (read), 
		.empty   (empty[1])
	);	
	
	always @(posedge i_clk)
	begin
		fifo_dout_reg[0] <=  fifo_rd_data[0];
		fifo_dout_reg[1] <=  fifo_rd_data[1];
		fifo_dout_reg[2] <=  fifo_rd_data[2];
		fifo_dout_reg[3] <=  fifo_rd_data[3];
        rd_flag_d1       <=  rd_flag;
	end
	
	assign {o_tx_inframe_d1[0],o_tx_skip_crc[0],o_tx_error[0],o_tx_empty[0],o_tx_data[0]} = fifo_dout_reg[0];
	assign {o_tx_inframe_d1[1],o_tx_skip_crc[1],o_tx_error[1],o_tx_empty[1],o_tx_data[1]} = fifo_dout_reg[1];
	assign {o_tx_inframe_d1[2],o_tx_skip_crc[2],o_tx_error[2],o_tx_empty[2],o_tx_data[2]} = fifo_dout_reg[2];
	assign {o_tx_inframe_d1[3],o_tx_skip_crc[3],o_tx_error[3],o_tx_empty[3],o_tx_data[3]} = fifo_dout_reg[3];

    assign o_tx_inframe[0] = rd_flag_d1 ? o_tx_inframe_d1[0] : 'd0;
    assign o_tx_inframe[1] = rd_flag_d1 ? o_tx_inframe_d1[1] : 'd0;
    assign o_tx_inframe[2] = rd_flag_d1 ? o_tx_inframe_d1[2] : 'd0;
    assign o_tx_inframe[3] = rd_flag_d1 ? o_tx_inframe_d1[3] : 'd0;
	
	eth_f_delay_reg #(
		.CYCLES (1),
		.WIDTH  (1)
	) valid_out_delay (
		.clk    (i_clk),
		.din    (i_ready),
		.dout   (o_tx_valid)
	);
 

   //Ready generation logic
   //Input ready from Tile carries cadence for 156M (4 lanes)
   //Output ready to Adapter needs to carry cadence for 312M (2 lanes)
   //This logic creates 2x high cycles for every 1x input high cycle
/*   always @(posedge i_clk)
   begin
    if(i_reset)
        cnt <= 0;
    else if(o_tx_ready & i_ready)
        cnt <= cnt + 8'h01;
    else if(o_tx_ready)
        cnt <= cnt - 8'h01;
    else if(i_ready)
        cnt <= cnt + 8'h02;
   end
   assign o_tx_ready = (cnt > 0);
*/



always_ff @(posedge i_clk) begin
  if (i_reset==1'b1 ) begin
    rd_flag    <= 1'b0;
  end else if(used[0] == 1'b0) begin //empty
    rd_flag    <= 1'b0;
  end else if(used[10]) begin
    rd_flag <= 1'b1;
  end
end

 
    always_ff @(posedge i_clk) begin
        if (i_reset==1'b1 )
            o_tx_ready <= 1'b0;
        else if(i_ready) //waiting for the 1st MAC ready
            o_tx_ready <= 1'b1;
        else if(used[14])
            o_tx_ready <= 1'b0;
    end



// logic to monitor 'used' variable  
   assign empty_w  = empty[0];
   assign full_w   = full[0];
   assign write   = (i_tx_valid && mem_sel==0) && !full_w;
   assign read    = (~empty_w && ~empty[1] && i_ready) && rd_flag;
     always @(posedge i_clk) begin
        if (i_reset) begin
            used <= 31'd0;
        end else begin
            if (write) begin
                if (read) begin
                    used <= used;
                end else begin
                    used <= {used[29:0], 1'b1};
                end
            end else begin
                if (read) begin
                    used <= {1'b0, used[30:1]};
                end else begin
                    used <= used;
                end
            end
        end
    end
endmodule   
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q44Ck3mUX6eYTFykF3aomHA5y/Filc+e5D1JOrIQZzHno+QAA0OHRAJ51gva8ZkP1178y/ozgMsz1XyvsZ044yCF4cKfx3VmqxZf0QV78dDvFTdjy5LxancNfieF82fBLZkufmzrlQ3aELIrj68hD9b6s8kzNIkeVQ2iUbvz3lVKZSdiDp4sOX54yv/cdBstql5BSCXoLiHUvO1Mjoj0AoSmwYtILhzS2j59rL5Bm7nAVIybTEMOp7pnTD6S+m2V2J6/Cn8QRhChOZvl52wpt6ohO55YNG4qYH5zsfhkEq60UO5oG+J6uUbp3cgtLW97qfDArOqfJbXvwhuJcuaQtGK9oleT9RDvOz0JR9X87Hn5DkPjshmKMaA3Zzf1u+ZubWVoUu8f15g7ezOiQ0xmb5WMVyodb3+uqd26H/0Wags4n96UYTuGGdIG+nQvhkudZhPQq6UXnwG5ydLWyUDWrpKbq6gWN2PRBdQMv8Lj2ColvB/sr1+pzPMBnaHULI2OrfHRYWz6OWQ+M/f5lsUiQKPrHO358CyeLONuC3r6P93eBVunimLMMfVlZwTya10HdkmamoG3X1zupkkYayCRKDQZTaA9ODLV8eNB5lyy/EW7UC6aQ355sR1p8rMrHSGzCqBb116kixIp6XHKuBSvuRRGWZORjrYNZRI86s5O5zro+dzItIqB+prEhxxuTkLM7aP6+toYOcRpwUSLIhtz5e+aFsnyhk1NB4u8EXqRxufGqH4N1OSxJ48s0C12AuPcU2npXrj5QhidxO23CV8K+R2v"
`endif