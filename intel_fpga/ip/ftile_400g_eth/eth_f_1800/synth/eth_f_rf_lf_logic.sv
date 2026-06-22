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
 
module eth_f_rf_lf_logic
#(
    parameter ADDR_WIDTH = 14
)
(
    // Clock and Reset
    input   wire                                i_reconfig_clk, 
    input   wire                                i_reconfig_reset,
	input   wire    [2:0]                       i_ehip_rate, //  10G-0,25G-1, 40G-2,50G-3,100G-4,200G-5,400G-6;
	input   wire                                i_local_fault, //  
	output reg                                  o_rf_in_progress,
 
	 
	
	// XCVR Reconfig Interface - from FTILE ADME MODULE
    input   wire                     			i_reconfig_write,
    input   wire    [3:0]            			i_reconfig_byteenable,
    input   wire                     			i_reconfig_read,
    input   wire    [ADDR_WIDTH-1:0]         i_reconfig_addr,
    input   wire    [31:0]           			i_reconfig_writedata,
    output  wire    [31:0]            			o_reconfig_readdata,
    output  wire                   				o_reconfig_readdata_valid,
    output  wire                   				o_reconfig_waitrequest,
 
    // XCVR Combined Reconfig Interface AVMM SLAVE from Transceiver 0 trhough 7
    output  wire                  		o_rcfg_write,
    output  wire    [3:0]         		o_rcfg_byteenable,
    output  wire        					o_rcfg_read,
    output  wire    [ADDR_WIDTH-1:0]   o_rcfg_addr,
    output  wire    [31:0]           	o_rcfg_writedata,
    input   wire    [31:0]           	i_rcfg_readdata,
    input   wire                  		i_rcfg_readdata_valid,
    input   wire                  		i_rcfg_waitrequest	
 
);
 

///internal avmm1 bus for reading the rsfec registers
logic                  	avmm_wr,n_avmm_wr;
logic [3:0]            	avmm_byteen;
logic                  	avmm_rd,n_avmm_rd;
logic [ADDR_WIDTH-1:0]  avmm_addr,n_avmm_addr;
logic [31:0]           	avmm_wrdata,n_avmm_wrdata;
logic                	avmm_waitrequest;
logic                	avmm_rdata_valid;
logic [31:0]            avmm_readdata;
logic 			i_local_fault_sync;
logic                   local_fault_sig1;
logic 			local_fault_sig2;
logic                   rf_in_progress;
 
logic rst_int;
logic [3:0] link_fault_reg;
logic [15:0]  link_fault_addr;
logic set_rf;
 
enum logic [3:0] {idle, read1_200,wait1_200, avmm_chk1_rd200,chk_lf_bit, write_200_1, avmm_chk_wr200_1, wait_lf_0, read2_200,wait2_200, avmm_chk2_rd200,write_200_0,avmm_chk_wr200_0} cur_st, nxt_st;
  
assign rst_int = i_reconfig_reset ;
 
 
assign link_fault_addr = (i_ehip_rate == 1 || i_ehip_rate == 0)  ? 'h1200 : (i_ehip_rate == 3) ? 'h2200 : ((i_ehip_rate == 4) || (i_ehip_rate == 2)) ? 'h3200 :(i_ehip_rate == 5) ? 'h4200 :(i_ehip_rate == 6) ? 'h5200 : 'h1200;
						
assign avmm_byteen = 4'b1111;


    eth_f_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) local_fault_sync (
        .clk                (i_reconfig_clk),
        .reset              (1'b0),
        .d                  (i_local_fault),
        .q                  (i_local_fault_sync)
    ); 

/////////////////rising edge detector 
always_ff @(posedge i_reconfig_clk) begin//state register
	if (rst_int ) begin
		local_fault_sig1 <= 0;
		local_fault_sig2 <= 0;
	end
	else begin
		local_fault_sig1 <= i_local_fault_sync;
		local_fault_sig2 <= i_local_fault_sync & ~local_fault_sig1;
	end

end

 
//////////////////////Control Logic
 
always_ff @(posedge i_reconfig_clk) begin//state register
if (rst_int ) cur_st <= idle;
else cur_st <= nxt_st;
end
 

always_comb begin// next state decoder
nxt_st = idle;
case (cur_st)
idle 				:	 if (avmm_waitrequest== 1 & local_fault_sig2 == 1) begin nxt_st = read1_200;
					    end else begin nxt_st = idle; end
						 
read1_200 		: 	 if (avmm_waitrequest== 1) begin nxt_st = wait1_200;
					    end else begin nxt_st = read1_200; end
						 
wait1_200 		: 	 if (avmm_waitrequest== 0) begin nxt_st = avmm_chk1_rd200;
					    end else begin nxt_st = wait1_200; end
						 
avmm_chk1_rd200 	: 	 if (avmm_waitrequest== 1 ) begin nxt_st = chk_lf_bit;
					    end else begin nxt_st = avmm_chk1_rd200;	end

chk_lf_bit       	: 	 if (set_rf==1) begin nxt_st = write_200_1;
					    end else begin nxt_st = idle;	end
						 
write_200_1 		:   if (avmm_waitrequest== 0) begin nxt_st = avmm_chk_wr200_1;
					    end else begin nxt_st = write_200_1; end
						 
avmm_chk_wr200_1         :   if (avmm_waitrequest== 1 ) begin nxt_st = wait_lf_0;
                             end else begin nxt_st = avmm_chk_wr200_1; end
						 
wait_lf_0 		:   if (i_local_fault_sync== 0) begin nxt_st = read2_200;
                               end else begin nxt_st = wait_lf_0; end 
						 
read2_200               :   if (avmm_waitrequest == 1) begin nxt_st = wait2_200;
					    end else begin nxt_st = read2_200; end		
				
wait2_200 		: 	 if (avmm_waitrequest== 0) begin nxt_st = avmm_chk2_rd200;
					    end else begin nxt_st = wait2_200; end
						 
avmm_chk2_rd200 	: 	 if (avmm_waitrequest== 1) begin nxt_st = write_200_0;
					    end else begin nxt_st = avmm_chk2_rd200;	end
						 
write_200_0 		:   if (avmm_waitrequest== 0) begin nxt_st = avmm_chk_wr200_0;
					    end else begin nxt_st = write_200_0; end
						 
avmm_chk_wr200_0 :   if (avmm_waitrequest== 1 ) begin nxt_st = idle;
                    end else begin nxt_st = avmm_chk_wr200_0; end			
						 		
endcase
end
 

always_comb begin// output decoder
		 n_avmm_addr = '0;
                 n_avmm_rd = '0;
		 n_avmm_wr = '0;
		 n_avmm_wrdata = '0;
         rf_in_progress = 1'b0;
case (cur_st)
idle 		    :   begin rf_in_progress = 1'b0; end
 
read1_200       :   begin
			n_avmm_addr = link_fault_addr[15:2];
                        n_avmm_rd = 1'b1;
                        rf_in_progress = 1'b0;
			        end
						 
wait1_200 		: 	     begin  
                         n_avmm_addr = link_fault_addr[15:2];
                         n_avmm_rd = 1'b1;
                         rf_in_progress = 1'b0;
					end 
						 
avmm_chk1_rd200 	:  begin rf_in_progress = 1'b0; end

chk_lf_bit       	:  begin rf_in_progress = 1'b0; end
						 
write_200_1 		:    begin
					         n_avmm_addr = link_fault_addr[15:2];
                        n_avmm_wr = 1'b1;
					    n_avmm_wrdata = {1'b1,link_fault_reg[2:0]};
                        //if (i_ehip_rate != 3'h1 || i_ehip_rate != 3'h0) begin
                        if (i_ehip_rate == 3'h2 || i_ehip_rate == 3'h4) begin //assert only for 40G and 100g
					    rf_in_progress = 1'b1;
                        end else begin
                        rf_in_progress = 1'b0;
                        end 

					    end
						 
avmm_chk_wr200_1 :     begin	
                        n_avmm_wr = 1'b0;
                          if (i_ehip_rate == 3'h2 || i_ehip_rate == 3'h4) begin //assert only for 40G and 100g
					      rf_in_progress = 1'b1;
                          end else begin
                          rf_in_progress = 1'b0;
                          end 
					   end
						 
wait_lf_0 		    :  begin rf_in_progress = 1'b0; end
						 
read2_200 :            begin
								n_avmm_addr = link_fault_addr[15:2];
                        n_avmm_rd = 1'b1;
                        rf_in_progress = 1'b0;
					   end		 
						 
wait2_200 		: 	     begin  
                         n_avmm_addr = link_fault_addr[15:2];
                         n_avmm_rd = 1'b1;
                         rf_in_progress = 1'b0;
						 end
						 
avmm_chk2_rd200 	: begin rf_in_progress = 1'b0; end
						 
write_200_0 		:  begin
					      n_avmm_addr = link_fault_addr[15:2];
                          n_avmm_wr = 1'b1;
						  n_avmm_wrdata = {1'b0,link_fault_reg[2:0]};
                          if (i_ehip_rate == 3'h2 || i_ehip_rate == 3'h4) begin //assert for other than 40G and 100g
					      rf_in_progress = 1'b0;
                          end else begin
                          rf_in_progress = 1'b1;
                          end 
                          end
						 
avmm_chk_wr200_0 		:     begin	
                        	      n_avmm_wr = 1'b0;
                          if (i_ehip_rate == 3'h2 || i_ehip_rate == 3'h4) begin //assert for other than 40G and 100g
					      rf_in_progress = 1'b0;
                          end else begin
                          rf_in_progress = 1'b1;
                          end 

				      end
endcase
end

always @ (posedge i_reconfig_clk) begin
if (rst_int  ) begin
   o_rf_in_progress <= 1'b0;
end else begin
   o_rf_in_progress <= rf_in_progress;
	end
end

 
/////FSM output registers
always_ff @(posedge i_reconfig_clk) begin
if (rst_int ) begin
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
if (rst_int  ) begin
   link_fault_reg[3:0] <= 'h0;
end else if (o_rcfg_addr == link_fault_addr[15:2] & avmm_rdata_valid== 1) begin
	link_fault_reg[3:0] <= avmm_readdata[3:0];
	end
end


assign set_rf = ~link_fault_reg[2] & ~link_fault_reg[1] & link_fault_reg[0];
 
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
`pragma questa_oem_00 "o2ONPYJ6JWO2K/lQHkyApXo6DVczB8sUyJtLpEiYtF7LL07s93qi8rQ7d2s1AdTOt/BNVdBoSTLCdACDT58BR3umvYuucV6Cbb36lNsOsJegwtedOJsDvTnB14ZLU41EvDEX+uxr7iJUYiTmn7hunq22K1+T/Nc7+FaTNr6AMH3CCuiZmo/CmXjVXLRPwF034Kg1mVvlsNTpZhm0ORjPpNI8tuMP0bMp6HLhHMKVKvdFQE7vAgmIxHEH/jQRlkk070Tk6+h5+GfKVJKkHQdeDXkzCj6Z2HA9d+YXqwFu/z3JYTGk6VQsEohG+xHrsKw+UzSCs26HUuUXWFDXnBTMOpKAJfcHvWcccDxbdYg6gTihqb4wc/E5Ty+85PvQjFFqeIFHVsGlJ/PH2tpQC0T610oSJJ1aMlaJCe/JcrsW2ood90ypS9K06552HR1ET4EVNotSG1J17195LLi0q6P8fS03P6sdxzP0i04iNJs8MmVkgYwIp+JV5AU5QChWwo4xkEwTM+ACZLUgTs8Q++2x4xp91w4BCVrwl7wTe/ZHQnZbKfIlUQe6oAzOKcBD0KdLEP3jD8h4+RHRa//U+8wqgheH5xzNm+UEt90LdA/x/MO9fBSMB1W72VtEvoPWtgWYu4wsAgQ5CDBbwEGw2QJSAzVGZx/FB8epocTTFRc6lZR8esSMdAtZGjrFbObie0YYYcD8gcFBGld7DT83u0Mi2V7it2CYGIjzeaL9i4XuHy+rDmXKN7FawAm86rPKBpFJ09XoYPyw7uMfs1n1rL3dF5y17Gz6okGxtRjLUeaezD7SkDB6enyCWZ+noDX3H4LnblHa5duHv6ZmDdhsuCWhniW18VBdqSZXvaaCnnLSH0ccxaSSbyvm66CSYBANUKma9B+dEGs5w099wTK/6Jh1XFaw+dM98E6r6stsGOskE/vuMPhNEE3D4p2Y128yX/OzBh0mKKRCIgH9qJD/N7M8Y/RA5JvVyn/sjDOWTeov+X0eOhZyy+WLIZw1a6hGJ3E2"
`endif