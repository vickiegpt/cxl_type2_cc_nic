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

module eth_f_10g_25g_adapter_tx #(
    parameter EHIP_RATE     = "25G",
    parameter ENABLE_ASYNC_ADAPTERS = 0 ,
    parameter WORD_WIDTH    = 64,
    parameter EMPTY_BITS    = 3,
    parameter READY_LATENCY = 1,
    parameter SIM_EMULATE   = 1,
    parameter NUM_CHANNELS  = 1
) (
    input   [NUM_CHANNELS-1:0]                        i_clk,
    input   [NUM_CHANNELS-1:0]                        i_sl_async_clk_tx,
    input   [NUM_CHANNELS-1:0]                        i_reset,
    
    input wire 				                          tx_transmit_ready,

    // Client interface
    input   [NUM_CHANNELS-1:0]                        i_valid,
    input   [NUM_CHANNELS-1:0][WORD_WIDTH-1:0]        i_data,
    input   [NUM_CHANNELS-1:0]                        i_sop,
    input   [NUM_CHANNELS-1:0]                        i_eop,
    input   [NUM_CHANNELS-1:0][EMPTY_BITS-1:0]        i_empty,
    input   [NUM_CHANNELS-1:0]                        i_error,
    input   [NUM_CHANNELS-1:0]                        i_skip_crc,
    output reg [NUM_CHANNELS-1:0]                     o_ready,

    output  [NUM_CHANNELS-1:0][WORD_WIDTH-1:0]        o_data,
    output  reg  [NUM_CHANNELS-1:0]                   o_valid,
    input   [NUM_CHANNELS-1:0]                        i_ready,
    output  [NUM_CHANNELS-1:0]                        o_inframe,
    output  reg [NUM_CHANNELS-1:0][EMPTY_BITS-1:0]    o_empty,
    output  [NUM_CHANNELS-1:0]                        o_error,
    output  [NUM_CHANNELS-1:0]                        o_skip_crc
);

    wire [NUM_CHANNELS-1:0]                         o_ready_delay;

    wire [NUM_CHANNELS-1:0][WORD_WIDTH-1:0]         av_data;
    wire [NUM_CHANNELS-1:0]                         av_to_ff_valid;
    wire [NUM_CHANNELS-1:0]                         av_inframe;
    wire [NUM_CHANNELS-1:0][EMPTY_BITS-1:0]         av_empty;
    wire [NUM_CHANNELS-1:0]                         av_error;
    wire [NUM_CHANNELS-1:0]                         av_skip_crc;
    wire [NUM_CHANNELS-1:0]                         av_ready;
    wire [NUM_CHANNELS-1:0][1+1+1+EMPTY_BITS+WORD_WIDTH-1:0] ff_din;
    wire [NUM_CHANNELS-1:0][1+1+1+EMPTY_BITS+WORD_WIDTH-1:0] ff_dout;
  
    reg  [NUM_CHANNELS-1:0][1+1+1+EMPTY_BITS+WORD_WIDTH-1:0] ff_dout_reg;
	
	localparam ZERO_WIDTH = 256-{1+1+1+EMPTY_BITS+WORD_WIDTH} ;
	wire [NUM_CHANNELS-1:0][ZERO_WIDTH-1:0] ff_d_ZEROS;

	
	genvar k;
    generate
      for (k=0; k<NUM_CHANNELS; k++) begin: gen_zeroes
	assign ff_d_ZEROS[k] = {ZERO_WIDTH{1'b0}};
      end: gen_zeroes
    endgenerate	
		 
	
	wire [NUM_CHANNELS-1:0][ZERO_WIDTH-1:0]  done_care_bits; 
   
    wire   [NUM_CHANNELS-1:0]                        rdempty;
    wire   [NUM_CHANNELS-1:0]                        wrfull;
     wire   [NUM_CHANNELS-1:0][4:0]                   wrusedw;
    wire   [NUM_CHANNELS-1:0][4:0]                   rdusedw;
      
    reg    [NUM_CHANNELS-1:0]                        rdempty_pulse ;
    reg    [NUM_CHANNELS-1:0]                        rdempty_pulse_r ;
    wire   [NUM_CHANNELS-1:0]                        i_reset_sync390;
    reg    [NUM_CHANNELS-1:0]                        rdfifo_req ;
            
    wire   [NUM_CHANNELS-1:0]                        clk_delay_reg;


    genvar i,j ;
    generate
      for (i=0; i<NUM_CHANNELS; i++) begin: gen_avf
 
        eth_f_delay_reg #(
            .CYCLES (READY_LATENCY),
            .WIDTH  (NUM_CHANNELS)
        ) i_ehip_delay_reg (
            .clk    (clk_delay_reg[i]),
            .din    (o_ready[i]),
            .dout   (o_ready_delay[i])
        );
        eth_f_sl_avalon_to_if #(
          .WORD_WIDTH (WORD_WIDTH),
          .EMPTY_BITS (EMPTY_BITS)
        ) i_ehip_avalon_to_if (
          .i_reset    (i_reset_sync390[i]),
          .i_clk      (clk_delay_reg[i]),

          .i_data     (i_data[i]),
          .i_valid    (i_valid[i]),
          .i_sop      (i_sop[i]),
          .i_eop      (i_eop[i]),
          .i_empty    (i_empty[i]),
          .i_error    (i_error[i]),
          .i_skip_crc (i_skip_crc[i]),
          .i_ready    (o_ready_delay[i]),

          .o_data     (av_data[i]),
          .o_valid    (av_to_ff_valid[i]),
          .o_inframe  (av_inframe[i]),
          .o_empty    (av_empty[i]),
          .o_error    (av_error[i]),
          .o_skip_crc (av_skip_crc[i]),
          .o_ready    (av_ready[i])
        );

        assign ff_din[i]      = {av_inframe[i], av_skip_crc[i], av_error[i], av_empty[i], av_data[i]};
	if (ENABLE_ASYNC_ADAPTERS == 0)  begin 

           assign clk_delay_reg[i] = i_clk[i];
           assign i_reset_sync390[i] = i_reset[i];

           for (j=0; j<NUM_CHANNELS; j++) begin : GEN_SCFIFO
             eth_f_scfifo_mlab #(
                 .SIM_EMULATE (SIM_EMULATE),
                 .WIDTH       (1+1+1+EMPTY_BITS+WORD_WIDTH)
             ) i_ehip_scfifo_mlab (
                 .clk     (i_clk),
                 .sclr    (i_reset),
                 .wdata   (ff_din[i]),
                 .wreq    (av_ready[i]),
                 .full    (/* Unused */),
                 .rdata   (ff_dout[i]),
                 .rreq    (i_ready[i]),
                 .empty   ()
             );
      	    end : GEN_SCFIFO       // for better timing
            always @(posedge i_clk)
              ff_dout_reg[i] <= ff_dout[i];

            assign {o_inframe[i], o_skip_crc[i], o_error[i], o_empty[i], o_data[i]} = ff_dout_reg[i];

            always @(posedge i_clk) 
              o_ready <= i_ready;

            assign o_valid = o_ready;
 
	end 
	else begin :  ASYNC

           assign clk_delay_reg[i] = i_sl_async_clk_tx[i];

           always @(posedge i_clk[i]) 
               o_valid[i] <= i_ready[i];

		   
			eth_f_altera_std_synchronizer_nocut i_reset_synchronizer (
					.clk     (i_sl_async_clk_tx[i]),
					.reset_n (1'b1),
					.din     (i_reset[i]),
					.dout    (i_reset_sync390[i])
				);		   
	
           dcfifo  dcfifo_txfifo (
                       .aclr (i_reset[i]),
                       .data ({ff_din[i],ff_d_ZEROS[i]}),
                       .rdclk (i_clk[i]),
                       // .rdreq (((~rdempty[i]) & i_ready[i])),
                       .rdreq ((rdfifo_req[i] && i_ready[i])),
                       .wrclk (i_sl_async_clk_tx[i]),
                       .wrreq (av_ready[i]),
                       .q ({ff_dout[i], done_care_bits[i]}),
                       .rdempty (rdempty[i]),
                       .wrfull (wrfull[i]),
                       .wrusedw (wrusedw[i]),
                       .eccstatus (),
                       .rdfull (),
                       .rdusedw (rdusedw[i]),
                       .wrempty ());
           defparam
               dcfifo_txfifo.enable_ecc  = "FALSE",
               dcfifo_txfifo.intended_device_family  = "Stratix 10",
               dcfifo_txfifo.lpm_hint  = "MAXIMUM_DEPTH=32,DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT=FALSE",
               dcfifo_txfifo.lpm_numwords  = 32,
               dcfifo_txfifo.lpm_showahead  = "OFF",
               dcfifo_txfifo.lpm_type  = "dcfifo",
               dcfifo_txfifo.lpm_width  = 256,
               dcfifo_txfifo.lpm_widthu  = 5,
               dcfifo_txfifo.overflow_checking  = "ON",
               dcfifo_txfifo.rdsync_delaypipe  = 5,
               dcfifo_txfifo.read_aclr_synch  = "ON",
               dcfifo_txfifo.underflow_checking  = "ON",
               dcfifo_txfifo.use_eab  = "ON",
               dcfifo_txfifo.write_aclr_synch  = "ON",
               dcfifo_txfifo.wrsync_delaypipe  = 5;
       
            always @ (posedge i_clk[i]) begin
                if (i_reset[i])begin
                    rdempty_pulse_r[i] <= 0;
                end else begin
                    rdempty_pulse_r[i] <= (rdempty[i]);
                end
            end
            
            assign rdempty_pulse[i] = rdempty_pulse_r[i] & (~rdempty[i]);
            
            always @ (posedge i_clk[i]) begin
                if (i_reset[i])begin
                    rdfifo_req[i] <= 1'b0;
                end else begin
                    if ((rdempty_pulse[i] == 1'b1) || (rdempty[i] == 1'b1)) begin
                        rdfifo_req[i] <= 1'b0;
                    //end else if ((rdusedw[i] >= 5'h6) && (rdfifo_req[i] == 1'b0) )begin //fix for case:16012130646
                    end else if ((rdusedw[i] >= 5'hA) && (rdfifo_req[i] == 1'b0) )begin //fix for case:16012130646 increased the threshold to meet pause backpressure
                        rdfifo_req[i] <= 1'b1;
                    end
                end
            end
	     
            assign {o_inframe[i], o_skip_crc[i], o_error[i], o_empty[i], o_data[i]} = ff_dout[i];

            always @(posedge i_sl_async_clk_tx )begin
                if (i_reset_sync390[i])begin
                    o_ready[i]  <= 1'b0;
                end
                else begin
                    o_ready[i]  <= (~wrfull[i]) && (wrusedw[i] < 5'h19)   ;
                end
            end
	end : ASYNC

      end: gen_avf
    endgenerate

    

endmodule //eth_f_10g_25g_adapter_tx
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q47rl/xvHvtsujk4Vsum/0Se86WuYSN8f1pzlRCAnJAwrPW9bM74H0df46PSnBbaZSj7PaBiKgNqH6PudYBb+AL5T5Nh6t2gp8uIwaXBc4xa+RAJhhrDY9zbx5dpHHlT5UBuB08SMxeEaA/e3Yb/Eb+BLSJww6DGRxN6ToAfdrK3cF5e2s0huarNI2SJZa9jI3wvTASmw7765ZUfbfFY0IW+duyDm5bCvUf+RJ738Q85WDmvyQgFU4As/nj/dRuRD3mpcSgT3/zQD94FeqWZB0vJQ85wejdLF+bUzNUlOkCGootUD/hKQ5RukAalhWIv+zuTC95Cpzt8VZRtOKWIwrwlDMWYMKT0At5ZnFTTDftQqbdGpRU9gYDblRCD3ih/aGduSd4XwlKOwVDpSLXcNpKd9hl9ff7nglYGWDjZHJsCUPpK07zlxeecbdiOmyAPP7GCLpaQvQU4mjOxsS14KZbjupsB+uwt6HhcBI8B2jfJVLw42HuqRTn9dYfLQGeXAc292UgqPuLcB7DqnMIRw1VIQ5pVX3vNUAwe6gb40kwV+Z4bBgCoFLSPKkIAIbIsDCaGUNLRKbCtWuUGnqu5q6MibOWsrYVVMDR9IrVhIjUV24XhIqsTwjsyudzq81/mWaMtYh0jKBfcC+J0ughfWZyfrx+BZcVY0VY0iiNzHB4S675uaL0slcwzY3HelDU4GggCQYxcLCSCUI/uFuC6STwaFyMDjKZfWRjeIdBh+K2XZ7oS6mYWmDK4PEPFWtceSl2LikOY2RnCUna+FZox5tl8"
`endif