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



`timescale 1ps/1ps
 
module eth_f_soft_cwbin_counter
#(
    parameter TIMEOUT_COUNT = 1399, //6.5us timer, 650 for 100MHZ reconfig clock, 1625 for 250MHz clock
    parameter ADDR_WIDTH = 14
)
(
    // Clock and Reset
    input   wire                                i_reconfig_clk, 
    input    wire                                i_reset,
    input   wire                                i_reconfig_reset,
	input   wire                                i_stats_snapshot,
	input   wire    [2:0]                       i_ehip_rate, //  10G-0,25G-1, 40G-2,50G-3,100G-4,200G-5,400G-6;
	input   wire                                i_fec_enable, //  for MRIP purpose

	 
	
	// XCVR Reconfig Interface - from FTILE ADME MODULE
    input   wire                     			i_reconfig_write,
    input   wire    [3:0]            			i_reconfig_byteenable,
    input   wire                     			i_reconfig_read,
    input   wire    [ADDR_WIDTH-1:0]            i_reconfig_addr,
    input   wire    [31:0]           			i_reconfig_writedata,
    output  wire    [31:0]            			o_reconfig_readdata,
    output  wire                   				o_reconfig_readdata_valid,
    output  wire                   				o_reconfig_waitrequest,
	 
	 output  wire                   				o_stats_snapshot,
 
    // XCVR Combined Reconfig Interface AVMM SLAVE from Transceiver 0 trhough 7
    output  wire                  		o_rcfg_write,
    output  wire    [3:0]         		o_rcfg_byteenable,
    output  wire        					o_rcfg_read,
    output  wire    [ADDR_WIDTH-1:0]   o_rcfg_addr,
    output  wire    [31:0]           	o_rcfg_writedata,
    input   wire    [31:0]           	i_rcfg_readdata,
    input   wire                  		i_rcfg_readdata_valid,
    input   wire                  		i_rcfg_waitrequest,
	 
	 ////TO/FROM SOFT CSR 
	 input wire                        cwbin_rst, //0x400 soft csr register
         input wire 	[31:0]		cwbin_timer_timeout,
	 output  wire    [31:0]             cwbin0A_out,//0x404 soft csr register
    output  wire    [31:0]             cwbin1A_out,//0x408 soft csr register
	 output  wire    [31:0]             cwbin2A_out,//0x40c soft csr register
	 output  wire    [31:0]             cwbin3A_out,//0x410 soft csr register
	 output  wire    [31:0]             cwbin0B_out,//0x414 soft csr register
    output  wire    [31:0]             cwbin1B_out,//0x418 soft csr register
	 output  wire    [31:0]             cwbin2B_out,//0x41c soft csr register
	 output  wire    [31:0]             cwbin3B_out //0x420 soft csr register
 
);


logic [31:0] cwbin0_A_counter='0;
logic [31:0] cwbin1_A_counter='0;;
logic [31:0] cwbin2_A_counter='0;;
logic [31:0] cwbin3_A_counter='0;;
logic [31:0] cwbin0_B_counter='0;;
logic [31:0] cwbin1_B_counter='0;;
logic [31:0] cwbin2_B_counter='0;;
logic [31:0] cwbin3_B_counter='0;;
////soft CSR Shadow registers for 32bit cwbins
logic [31:0] cwbin0_A_counter_shadow='0;;
logic [31:0] cwbin1_A_counter_shadow='0;;
logic [31:0] cwbin2_A_counter_shadow='0;;
logic [31:0] cwbin3_A_counter_shadow='0;;
logic [31:0] cwbin0_B_counter_shadow='0;;
logic [31:0] cwbin1_B_counter_shadow='0;;
logic [31:0] cwbin2_B_counter_shadow='0;;
logic [31:0] cwbin3_B_counter_shadow='0;;

///internal avmm1 bus for reading the rsfec registers
logic                  	avmm_wr,n_avmm_wr;
logic [3:0]            	avmm_byteen;
logic                  	avmm_rd,n_avmm_rd;
logic [ADDR_WIDTH-1:0]  avmm_addr,n_avmm_addr;
logic [31:0]           	avmm_wrdata,n_avmm_wrdata;
logic                	avmm_waitrequest;
logic                	avmm_rdata_valid;
logic [31:0]            avmm_readdata;


logic cwbin_snapshot_enA;
logic cwbin_snapshot_enB;
logic cwbin_shadowclear_enA;
logic cwbin_shadowclear_enB;
logic stats_snapshot;

logic [15:0] timer_14us;
logic rst_int;
logic timer_timeout;
logic [31:0] timer_reg;
logic en_cwbinB;
logic [15:0]  cwbinA_addr,cwbinB_addr, timeraddr, snapaddrA_S1E0,snapaddrB_S1E0,snapstatusaddr;

enum logic [3:0] {idle, set_snapshot,rd_csrsnap, avmm_chk_rd, rd_cwbinA, avmm_chk_cwbinA, rd_cwbinB, avmm_chk_cwbinB,waitrest} cur_st=idle, nxt_st;

logic rolloverA0, rolloverA1, rolloverA2, rolloverA3;
logic rolloverB0, rolloverB1, rolloverB2, rolloverB3;

assign rst_int = cwbin_rst |  i_reconfig_reset;

assign en_cwbinB = (i_ehip_rate == 4 | i_ehip_rate == 5 | i_ehip_rate == 6)  ? 1 : 0;

assign cwbinA_addr = (i_ehip_rate == 1)  ? 'h61D0 : (i_ehip_rate == 3) ? 'h63D0 :(i_ehip_rate == 4) ? 'h67D0 :(i_ehip_rate == 5) ? 'h6FD0 :(i_ehip_rate == 6) ? 'h7FD0 : 'h61D0;
							
assign cwbinB_addr = (i_ehip_rate == 4) ? 'h6BD0 :(i_ehip_rate == 5) ? 'h77D0:(i_ehip_rate == 6) ? 'h8FD0 : 'h6BD0;
							
assign timeraddr =    'h424 ;
							
assign snapaddrA_S1E0 =    (i_ehip_rate == 1)  ? 'h61E0 : 
							(i_ehip_rate == 3) ? 'h63E0 :
						   (i_ehip_rate == 4) ? 'h67E0 :	
							(i_ehip_rate == 5) ? 'h6FE0 :
							(i_ehip_rate == 6) ? 'h7FE0 : 'h61E0;

							
assign snapaddrB_S1E0 =   (i_ehip_rate == 4) ? 'h6BE0 :	
							(i_ehip_rate == 5) ? 'h77E0 :
							(i_ehip_rate == 6) ? 'h8FE0 : 'h6BE0;
							
							
assign snapstatusaddr =    (i_ehip_rate == 1)  ? 'h61C4 : 
							(i_ehip_rate == 3) ? 'h63C4 :
						   (i_ehip_rate == 4) ? 'h67C4 :	
							(i_ehip_rate == 5) ? 'h6FC4 :
							(i_ehip_rate == 6) ? 'h7FC4: 'h61C4;							

assign avmm_byteen = 4'b1111;

////snapshot port mapped to tx_dp_mapping logic which is OR of internal snapshot signal and input port
assign o_stats_snapshot = stats_snapshot | i_stats_snapshot;

///////////////OUTPUTS
	 assign cwbin0A_out = cwbin0_A_counter_shadow;
    assign cwbin1A_out = cwbin1_A_counter_shadow;
	 assign cwbin2A_out = cwbin2_A_counter_shadow;
	 assign cwbin3A_out = cwbin3_A_counter_shadow;
	 assign cwbin0B_out = cwbin0_B_counter_shadow;
    assign cwbin1B_out = cwbin1_B_counter_shadow;
	 assign cwbin2B_out = cwbin2_B_counter_shadow;
	 assign cwbin3B_out = cwbin3_B_counter_shadow;

//////////////////////CWBIN TIMER

always @ (posedge i_reconfig_clk) begin
	if (rst_int | timer_timeout | ~i_fec_enable) begin
	timer_14us   <= 16'b0;
	end else begin
	timer_14us <= timer_14us + 16'b1;
	end
end

always @ (posedge i_reconfig_clk) begin
	if (rst_int | ~i_fec_enable) begin
	timer_reg   <= {16'b0,TIMEOUT_COUNT};
	end else if (i_reconfig_addr == timeraddr[15:2] & i_reconfig_write== 1 ) begin
	timer_reg <= cwbin_timer_timeout;
	end
end


always @ (posedge i_reconfig_clk) begin
	if (rst_int | ~i_fec_enable) begin
	timer_timeout   <= 1'b0;
	end else if(timer_14us == timer_reg[15:0]) begin
	timer_timeout <= 1'b1;
	end
	else begin
	timer_timeout   <= 1'b0;
	end
end

//////////////////////CWBIN Shadow registers IMPLEMENTATION
always_ff @(posedge i_reconfig_clk) begin
    if (rst_int | ~i_fec_enable |~en_cwbinB | cwbin_shadowclear_enB) begin
	 cwbin0_B_counter_shadow <= 0;
	 cwbin1_B_counter_shadow <= 0;
	 cwbin2_B_counter_shadow <= 0;
	 cwbin3_B_counter_shadow <= 0;
    end else if (cwbin_snapshot_enB) begin 
		  cwbin0_B_counter_shadow  <= cwbin0_B_counter_shadow;
		  cwbin1_B_counter_shadow  <= cwbin1_B_counter_shadow;
		  cwbin2_B_counter_shadow  <= cwbin2_B_counter_shadow;
		  cwbin3_B_counter_shadow  <= cwbin3_B_counter_shadow;
    end else begin
		  cwbin0_B_counter_shadow  <= cwbin0_B_counter;
		  cwbin1_B_counter_shadow  <= cwbin1_B_counter;
		  cwbin2_B_counter_shadow  <= cwbin2_B_counter;
		  cwbin3_B_counter_shadow  <= cwbin3_B_counter;
    end    
  end
  
  /////////////////////CWBIN Shadow registers IMPLEMENTATION
always_ff @(posedge i_reconfig_clk) begin
    if (rst_int | ~i_fec_enable | cwbin_shadowclear_enA ) begin
	 cwbin0_A_counter_shadow <= 0;
	 cwbin1_A_counter_shadow <= 0;
	 cwbin2_A_counter_shadow <= 0;
	 cwbin3_A_counter_shadow <= 0;
    end else if (cwbin_snapshot_enA) begin 
        cwbin0_A_counter_shadow  <= cwbin0_A_counter_shadow;
		  cwbin1_A_counter_shadow  <= cwbin1_A_counter_shadow;
		  cwbin2_A_counter_shadow  <= cwbin2_A_counter_shadow;
		  cwbin3_A_counter_shadow  <= cwbin3_A_counter_shadow;
    end else begin
        cwbin0_A_counter_shadow  <= cwbin0_A_counter;
		  cwbin1_A_counter_shadow  <= cwbin1_A_counter;
		  cwbin2_A_counter_shadow  <= cwbin2_A_counter;
		  cwbin3_A_counter_shadow  <= cwbin3_A_counter;
    end    
  end
  
/////////SNAPSET 
logic snapshot_csrA;
logic snapshot_csrB;
logic snapshot;

always @ (posedge i_reconfig_clk) begin
   if (rst_int | ~i_fec_enable) begin
	snapshot_csrA   <= 1'b0;
	end else if (( i_reconfig_addr == snapaddrA_S1E0[15:2]) & i_reconfig_write== 1 & i_reconfig_writedata[0] == 1) begin  ////0x6100
	snapshot_csrA   <= 1'b1;
	end else if (( i_reconfig_addr == snapaddrA_S1E0[15:2]) & i_reconfig_write== 1 & i_reconfig_writedata[0] == 0) begin  ////0x6100
	snapshot_csrA   <= 1'b0;
	end 
end

always @ (posedge i_reconfig_clk) begin
   if (rst_int | ~i_fec_enable |~en_cwbinB) begin
	snapshot_csrB   <= 1'b0;
	end else if (( i_reconfig_addr == snapaddrB_S1E0[15:2]) & i_reconfig_write== 1 & i_reconfig_writedata[0] == 1) begin  ////0x6100
	snapshot_csrB   <= 1'b1;
	end else if (( i_reconfig_addr == snapaddrB_S1E0[15:2]) & i_reconfig_write== 1 & i_reconfig_writedata[0] == 0) begin  ////0x6100
	snapshot_csrB   <= 1'b0;
	end 
end
//assign snapshot_csr  = (n_avmm_addr == 'h1000  & avmm_rdata_valid== 1 & avmm_readdata([1] == 1) ? 1'b1 : 0;
assign snapshot = snapshot_csrA | i_stats_snapshot | stats_snapshot;
assign cwbin_snapshot_enA = snapshot_csrA | i_stats_snapshot ;
assign cwbin_snapshot_enB = snapshot_csrB | i_stats_snapshot ;



always @ (posedge i_reconfig_clk) begin
   if (rst_int | ~i_fec_enable) begin
	cwbin_shadowclear_enA   <= 1'b0;
	end else if (( i_reconfig_addr == snapaddrA_S1E0[15:2]) & i_reconfig_write== 1 & i_reconfig_writedata[4] == 1) begin  ////0x6100
	cwbin_shadowclear_enA   <= 1'b1;
	end else if (( i_reconfig_addr == snapaddrA_S1E0[15:2]) & i_reconfig_write== 1 & i_reconfig_writedata[4] == 0) begin  ////0x6100
	cwbin_shadowclear_enA   <= 1'b0;
	end 
end

always @ (posedge i_reconfig_clk) begin
   if (rst_int | ~i_fec_enable |~en_cwbinB) begin
	cwbin_shadowclear_enB   <= 1'b0;
	end else if (( i_reconfig_addr == snapaddrB_S1E0[15:2]) & i_reconfig_write== 1 & i_reconfig_writedata[4] == 1) begin  ////0x6100
	cwbin_shadowclear_enB  <= 1'b1;
	end else if (( i_reconfig_addr == snapaddrB_S1E0[15:2]) & i_reconfig_write== 1 & i_reconfig_writedata[4] == 0) begin  ////0x6100
	cwbin_shadowclear_enB   <= 1'b0;
	end 
end



//////////////////////Control Logic

always_ff @(posedge i_reconfig_clk) begin//state register
if (i_reconfig_reset | ~i_fec_enable | i_reset) cur_st <= idle;
else cur_st <= nxt_st;
end

always_comb begin// next state decoder
nxt_st = idle;
case (cur_st)
idle 				:	 if (avmm_waitrequest && ~cwbin_rst) begin nxt_st = set_snapshot;
					    end else begin nxt_st = idle; end
						 
set_snapshot 		: 	 if (avmm_waitrequest== 1) begin nxt_st = rd_csrsnap;
					    end else begin nxt_st = set_snapshot; end
						 
rd_csrsnap 		: 	 if (avmm_waitrequest== 0) begin nxt_st = avmm_chk_rd;
					    end else begin nxt_st = rd_csrsnap; end
						 
avmm_chk_rd 	: 	 if (avmm_waitrequest== 1 & snapshot == 1) begin nxt_st = rd_cwbinA;
					    end else begin nxt_st = avmm_chk_rd;	end
						 
rd_cwbinA 		:   if (avmm_waitrequest== 0) begin nxt_st = avmm_chk_cwbinA;
					    end else begin nxt_st = rd_cwbinA; end
						 
avmm_chk_cwbinA :   if (avmm_waitrequest== 1 & en_cwbinB == 1) begin nxt_st = rd_cwbinB;
                    end else if (avmm_waitrequest== 1 & en_cwbinB == 0) 
						  begin nxt_st = waitrest; end
					     else begin nxt_st = avmm_chk_cwbinA; end
						 
rd_cwbinB 		:   if (avmm_waitrequest== 0) begin nxt_st = avmm_chk_cwbinB;
                   end else begin nxt_st = rd_cwbinB; end 
						 
avmm_chk_cwbinB :   if (avmm_waitrequest == 1) begin nxt_st = waitrest;
					    end else begin nxt_st = avmm_chk_cwbinB; end				 
						 
waitrest       : 		if (timer_timeout ==1) begin
                     	nxt_st = idle; 	
					      end else begin
				           	nxt_st = waitrest; 
						   end		
endcase
end

always_comb begin// output decoder
						 n_avmm_addr = '0;
                         n_avmm_rd = '0;
						 n_avmm_wr = '0;
						 n_avmm_wrdata = '0;
						 stats_snapshot = '0;
case (cur_st)
idle 				:	;

set_snapshot   :   stats_snapshot = 1'b1;
						 
rd_csrsnap 		: 	     begin  
						 n_avmm_addr = snapstatusaddr[15:2];
                         n_avmm_rd = 1'b1;
								 stats_snapshot = 1'b1;
						 end 
						 
avmm_chk_rd 	: 	    begin
                        n_avmm_rd = 1'b0;
								stats_snapshot = 1'b1;
						end
						 
rd_cwbinA 		:        begin
					    n_avmm_addr = cwbinA_addr[15:2];
                        n_avmm_rd = 1'b1;
								stats_snapshot = 1'b1;
						 end
						 
avmm_chk_cwbinA :       begin	
                        n_avmm_rd = 1'b0;
								stats_snapshot = 1'b1;
						 end
						 
rd_cwbinB 		:        begin
						 n_avmm_addr = cwbinB_addr[15:2];
                         n_avmm_rd = 1'b1;
								 stats_snapshot = 1'b1;
						 end
						 
avmm_chk_cwbinB :       begin
                        n_avmm_rd = 1'b0;
								stats_snapshot = 1'b0;
						 end		 
						 
waitrest       : 	    begin
						 stats_snapshot = 1'b0;
					    end	 
endcase
end

/////FSM output registers
always_ff @(posedge i_reconfig_clk) begin
if (rst_int | ~i_fec_enable) begin
	avmm_addr <= 'h0;
   avmm_rd <= 'b0 ;
	avmm_wr <= 'b0; 
	avmm_wrdata <= 'h0;
	end else begin
	avmm_addr <= n_avmm_addr;
	avmm_wrdata <= n_avmm_wrdata;
	if (avmm_waitrequest == 0) begin
	 avmm_rd <= 'b0 ;
	avmm_wr <= 'b0; 
	end else begin
	avmm_rd <= n_avmm_rd ;
	avmm_wr <= n_avmm_wr; 
	end
	end
end


always @ (posedge i_reconfig_clk) begin
if (rst_int | ~i_fec_enable | cwbin_shadowclear_enA) begin
   cwbin0_A_counter[7:0] <= 'h0;
	cwbin1_A_counter[7:0] <= 'h0;
	cwbin2_A_counter[7:0] <= 'h0;
	cwbin3_A_counter[7:0] <= 'h0;
end else if (o_rcfg_addr == cwbinA_addr[15:2] & avmm_rdata_valid== 1) begin
	cwbin0_A_counter[7:0] <= avmm_readdata[7:0];
	cwbin1_A_counter[7:0] <= avmm_readdata[15:8];
	cwbin2_A_counter[7:0] <= avmm_readdata[23:16];
	cwbin3_A_counter[7:0] <= avmm_readdata[31:24];
	end
end
///////MSB CWBIN A rollover condition checks

always @ (posedge i_reconfig_clk) begin
if (rst_int | ~i_fec_enable) begin
	rolloverA0 <= 'b0;
	rolloverA1 <= 'b0;
	rolloverA2 <= 'b0;
	rolloverA3 <= 'b0;
end else if (o_rcfg_addr == cwbinA_addr[15:2] & avmm_rdata_valid== 1) begin
	rolloverA0 <= (cwbin0_A_counter[7:0] > avmm_readdata[7:0])? 1: 0;
	rolloverA1 <= (cwbin1_A_counter[7:0] > avmm_readdata[15:8])? 1: 0;
	rolloverA2 <= (cwbin2_A_counter[7:0] > avmm_readdata[23:16])? 1: 0;
	rolloverA3 <= (cwbin3_A_counter[7:0] > avmm_readdata[31:24])? 1: 0;
	end else begin
	rolloverA0 <= 'b0;
	rolloverA1 <= 'b0;
	rolloverA2 <= 'b0;
	rolloverA3 <= 'b0;
	end
end
///////MSB CWBIN A accumulators

always @ (posedge i_reconfig_clk) begin
if (rst_int | ~i_fec_enable |cwbin_shadowclear_enA) begin
	cwbin0_A_counter[31:8] <= 'b0;
end else if (rolloverA0 == 1) begin
	cwbin0_A_counter[31:8] <= cwbin0_A_counter[31:8] +1'b1;
	end 
end

always @ (posedge i_reconfig_clk) begin
if (rst_int | ~i_fec_enable |cwbin_shadowclear_enA) begin
	cwbin1_A_counter[31:8] <= 'b0;
end else if (rolloverA1 == 1) begin
	cwbin1_A_counter[31:8] <= cwbin1_A_counter[31:8] +1'b1;
	end 
end

always @ (posedge i_reconfig_clk) begin
if (rst_int | ~i_fec_enable |cwbin_shadowclear_enA) begin
	cwbin2_A_counter[31:8] <= 'b0;
end else if (rolloverA2 == 1) begin
	cwbin2_A_counter[31:8] <= cwbin2_A_counter[31:8] +1'b1;
	end 
end

always @ (posedge i_reconfig_clk) begin
if (rst_int | ~i_fec_enable |cwbin_shadowclear_enA) begin
	cwbin3_A_counter[31:8] <= 'b0;
end else if (rolloverA3 == 1) begin
	cwbin3_A_counter[31:8] <= cwbin3_A_counter[31:8] +1'b1;
	end 
end

///////////////////CWBIN B

always @ (posedge i_reconfig_clk) begin
if (rst_int | ~en_cwbinB | ~i_fec_enable |cwbin_shadowclear_enB) begin
   cwbin0_B_counter[7:0] <= 'h0;
	cwbin1_B_counter[7:0] <= 'h0;
	cwbin2_B_counter[7:0] <= 'h0;
	cwbin3_B_counter[7:0] <= 'h0;
end else if (o_rcfg_addr == cwbinB_addr[15:2] & avmm_rdata_valid== 1) begin
	cwbin0_B_counter[7:0] <= avmm_readdata[7:0];
	cwbin1_B_counter[7:0] <= avmm_readdata[15:8];
	cwbin2_B_counter[7:0] <= avmm_readdata[23:16];
	cwbin3_B_counter[7:0] <= avmm_readdata[31:24];
	end
end

///////MSB CWBIN B rollover condition checks
always @ (posedge i_reconfig_clk) begin
if (rst_int | ~en_cwbinB | ~i_fec_enable) begin
	rolloverB0 <= 'b0;
	rolloverB1 <= 'b0;
	rolloverB2 <= 'b0;
	rolloverB3 <= 'b0;
end else if (o_rcfg_addr == cwbinB_addr[15:2] & avmm_rdata_valid== 1) begin
	rolloverB0 <= (cwbin0_B_counter[7:0] > avmm_readdata[7:0])? 1: 0;
	rolloverB1 <= (cwbin1_B_counter[7:0] > avmm_readdata[15:8])? 1: 0;
	rolloverB2 <= (cwbin2_B_counter[7:0] > avmm_readdata[23:16])? 1: 0;
	rolloverB3 <= (cwbin3_B_counter[7:0] > avmm_readdata[31:24])? 1: 0;
	end else begin
	rolloverB0 <= 'b0;
	rolloverB1 <= 'b0;
	rolloverB2 <= 'b0;
	rolloverB3 <= 'b0;
	end
end

///////MSB CWBIN B accumulators
always @ (posedge i_reconfig_clk) begin
if (rst_int | ~en_cwbinB | ~i_fec_enable|cwbin_shadowclear_enB) begin
	cwbin0_B_counter[31:8] <= 'b0;
end else if (rolloverB0 == 1) begin
	cwbin0_B_counter[31:8] <= cwbin0_B_counter[31:8]+ 1'b1;
	end 
end

always @ (posedge i_reconfig_clk) begin
if (rst_int | ~en_cwbinB | ~i_fec_enable|cwbin_shadowclear_enB) begin
	cwbin1_B_counter[31:8] <= 'b0;
end else if (rolloverB1 == 1) begin
	cwbin1_B_counter[31:8] <= cwbin1_B_counter[31:8]+ 1'b1;
	end 
end

always @ (posedge i_reconfig_clk) begin
if (rst_int | ~en_cwbinB | ~i_fec_enable|cwbin_shadowclear_enB) begin
	cwbin2_B_counter[31:8] <= 'b0;
end else if (rolloverB2 == 1) begin
	cwbin2_B_counter[31:8] <= cwbin2_B_counter[31:8] +1'b1;
	end 
end

always @ (posedge i_reconfig_clk) begin
if (rst_int | ~en_cwbinB | ~i_fec_enable|cwbin_shadowclear_enB) begin
	cwbin3_B_counter[31:8] <= 'b0;
end else if (rolloverB3 == 1) begin
	cwbin3_B_counter[31:8] <= cwbin3_B_counter[31:8] +1'b1;
	end 
end

////////ARBITER logic between CWBIN avmm and user AVMM1
         eth_f_rcfg_arb #(
            .TOTAL_MASTERS  (2), // Reuse arbiter from alt_xcvr_avmm_arb.sv 
            .CHANNELS       (1),
            .ADDRESS_WIDTH  (14),
            .DATA_WIDTH     (32)
        ) arb_avmm1_cwbin (

            // Basic AVMM inputs
            .ini_clk            (i_reconfig_clk),
            .ini_reset          (i_reconfig_reset),

            // USER and JTAG EHIP Reconfig
            .ini_read           ({i_reconfig_read, avmm_rd}),
            .ini_write          ({i_reconfig_write, avmm_wr}),
            .ini_address        ({i_reconfig_addr, avmm_addr}),
            .ini_byteenable     ({i_reconfig_byteenable,avmm_byteen}),
            .ini_writedata      ({i_reconfig_writedata, avmm_wrdata}),
            .ini_read_write     ({(i_reconfig_read || i_reconfig_write), (avmm_rd || avmm_wr)}),
            .ini_waitrequest    ({o_reconfig_waitrequest, avmm_waitrequest}),
            .ini_readdatavalid  ({o_reconfig_readdata_valid, avmm_rdata_valid}),

            // Combined EHIP Reconfig
            .avmm_read          (o_rcfg_read),
            .avmm_write         (o_rcfg_write),
            .avmm_address       (o_rcfg_addr),
            .avmm_byteenable    (o_rcfg_byteenable),
            .avmm_writedata     (o_rcfg_writedata),
            .avmm_readdatavalid (i_rcfg_readdata_valid),
            .avmm_waitrequest   (i_rcfg_waitrequest)
        );


    assign  o_reconfig_readdata         =   i_rcfg_readdata;
    assign  avmm_readdata                 =   i_rcfg_readdata;
   	 
 
endmodule

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q47T500MI7BHosLTj9yqjzPIvmJ8RJ1fJNBJ2jif7CfbaoFUHrGt1fDRBZDguU2QmPEPauRPeF8/5/+tgZcMCGHDmvCQqTasvrEWFQOk84iWgQtp+0968sf9aKeg86gGkjCWdzDIo7xKBC3a7W8IZu6hpi5UuKUy7wBy6R5Jn7mFaDX0KZFFTIs+WLdpJUj2vm9Q94Z61kHhPGEN8RkfEgF9WKksbrKQVJV0xG7uVZfMlHtJ5dwl75u73diTlz2uB8KBfz0NBWGMgIj3+aYF1/9soRbdnwKau7qQGwsamzRuLyO4AgDo5tkP6QiWHz/pkS3X3Hii4DQkkk8r4g/ZRruke+Oj9YaXr4RS3vdgIz/JMwom/a7lENMdg0YbVQIgcCYEc6XvDPhbuq+gtA96eXcbhTJhtd0bX+aThsIeYKaRJ5Bd7TibLYXfF3QdjafG2TmwXwmwkhYKNsEdB5bfzmxDDh4qJJ30WkNRZDyCmWICwCGgzNjsMnY5Mt32JZrqGZjGnHia+IBcJUQKZX/EydnoX6P6dPr2SDjT8Iot0snhRu/iktFumw6EWH8mmqTTKQ7SpwPOJ2jbRcrxUSTSNnmFxG3UsiEnbyY77pZc+vrBSHwaVdegbGdw5l5EJtnRfglnDgSGuyJeBXaz7wmrtGya0yKDDTReKLV8wCa3TWVfMejNGUEbWZvYwNDuRHToF8+XDeDepny9Lm5HZ/3lQZhWlrHGaDtNHizSDKVE6JOXOxkmvilxR04JVxbV6j21D8AcIk06FiOVZGADxFz2tURa"
`endif