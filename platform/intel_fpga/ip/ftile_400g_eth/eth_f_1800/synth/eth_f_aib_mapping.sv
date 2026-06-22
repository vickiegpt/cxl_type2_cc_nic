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


//=============================================================================
//Description
// MAIB mapping   
//=============================================================================
//Declaration

//synthesis translate_off
`timescale 1ns / 1ps
//synthesis translate_on

module eth_f_aib_mapping
import eth_f_package::*;
#(
    parameter   LANES             =   4,
    parameter   EHIP_BLOCK        =   0
)
(
  
    //hdpldadapt  Interface
    input   logic   [31:0]              i_link_out_from_aib,
    output  logic   [LANES-1:0][39:0]   o_link_in_to_aib,

    // Input signals    
    input   logic                       i_pld_ready,
    // input   logic                       i_signal_ok,       
    input   logic                       i_clear_internal,       
    input   logic                       i_tx_pause,       
    input   logic   [7:0]               i_tx_pfc,       

    // Output signals
    output  logic 			o_pcs_rx_sf,
    output  logic   [LANES-1:0]		o_fec_not_locked,
    output  logic 			o_fec_not_align,
    output  logic                       o_rx_rst_n,       
    output  logic                       o_hip_ready,       
    output  logic                       o_tx_rst_n,       
    output  logic                       o_rx_block_lock,       
    output  logic                       o_rx_dsk_done,
    output  logic                       o_rx_am_lock,
    output  logic                       o_rx_pcs_fully_aligned,
    output  logic                       o_hi_ber,
    output  logic                       o_rx_pcs_internal_err,
    output  logic                       o_local_fault,
    output  logic                       o_remote_fault,
    output  logic                       o_rx_pause,
    output  logic [7:0]                 o_rx_pfc,
    output  logic                       o_clk_pll,       
    output  logic                       o_clk_tx_div,          
    output  logic                       o_clk_rec_div64,      
    output  logic                       o_clk_rec_div      
    //    output  logic                       o_txfifo_pfull

);


//=========================================================================
// Generate status signals 
//=========================================================================

assign o_pcs_rx_sf			= i_link_out_from_aib[AIB_PCS_RX_SF];
assign o_fec_not_align			= i_link_out_from_aib[AIB_FEC_NOT_ALIGN];

genvar j;

generate 
for (j=0; j<LANES; j=j+1) begin:FEC_NOT_LOCKED_ALL_CHANNELS
	assign o_fec_not_locked[j] = i_link_out_from_aib[AIB_FEC_NOT_LOCKED];
end
endgenerate


assign o_rx_rst_n                        =   i_link_out_from_aib[AIB_RX_RESET_ACK];      
assign o_hip_ready                       =   i_link_out_from_aib[AIB_HIP_READY];        
assign o_tx_rst_n                        =   i_link_out_from_aib[AIB_TX_RESET_ACK];           
assign o_rx_block_lock                   =   i_link_out_from_aib[AIB_RX_BLOCK_LOCK];      
assign o_rx_dsk_done                     =   i_link_out_from_aib[AIB_RX_DESKEW_DONE];      
assign o_rx_am_lock                      =   i_link_out_from_aib[AIB_RX_AM_LOCK];        
assign o_rx_pcs_fully_aligned            =   i_link_out_from_aib[AIB_RX_PCS_FULLY_ALIGNED];        
assign o_hi_ber                          =   i_link_out_from_aib[AIB_HI_BER];      
assign o_rx_pcs_internal_err             =   i_link_out_from_aib[AIB_RX_PCS_INTERNAL_ERROR];       
assign o_local_fault                     =   i_link_out_from_aib[AIB_LOCAL_FAULT];            
assign o_remote_fault                    =   i_link_out_from_aib[AIB_REMOTE_FAULT];       
assign o_rx_pause                        =   i_link_out_from_aib[AIB_RX_PAUSE];
assign o_rx_pfc                          =   {i_link_out_from_aib[AIB_RX_PFC_7],i_link_out_from_aib[AIB_RX_PFC_6],i_link_out_from_aib[AIB_RX_PFC_5],i_link_out_from_aib[AIB_RX_PFC_4],i_link_out_from_aib[AIB_RX_PFC_3],i_link_out_from_aib[AIB_RX_PFC_2],i_link_out_from_aib[AIB_RX_PFC_1],i_link_out_from_aib[AIB_RX_PFC_0]};      
// assign o_txfifo_pfull                    =   i_link_out_from_aib[AIB_TXFIFO_PFULL];     



//=============================================================================
// Generate SSR input to AIB
// ============================================================================
genvar i;

generate
for (i=0; i<LANES; i=i+1) begin:AIB_SSR
    assign o_link_in_to_aib[i][15:0]= {16{1'b0}}; 
    assign o_link_in_to_aib[i][39:28]= {12{1'b0}}; 
    assign o_link_in_to_aib[i][AIB_PLD_READY]       =       i_pld_ready;     
    assign o_link_in_to_aib[i][AIB_SIGNAL_OK]       =       1'b0;          
    assign o_link_in_to_aib[i][AIB_CLEAR_INTERNAL]  =       i_clear_internal; 
    assign o_link_in_to_aib[i][AIB_TX_PAUSE]        =       i_tx_pause;      
    assign {o_link_in_to_aib[i][AIB_TX_PFC_7],o_link_in_to_aib[i][AIB_TX_PFC_6],o_link_in_to_aib[i][AIB_TX_PFC_5],o_link_in_to_aib[i][AIB_TX_PFC_4],o_link_in_to_aib[i][AIB_TX_PFC_3],o_link_in_to_aib[i][AIB_TX_PFC_2],o_link_in_to_aib[i][AIB_TX_PFC_1],o_link_in_to_aib[i][AIB_TX_PFC_0]}          =       i_tx_pfc;        
end // AIB_SSR
endgenerate

//=============================================================================
// Generate clocks
// ============================================================================

assign o_clk_pll          =   i_link_out_from_aib[PLL_CLK]; 
assign o_clk_tx_div       =   i_link_out_from_aib[DIV66_CLK];  
assign o_clk_rec_div64    =   i_link_out_from_aib[REC_CLK_DIV64];      
assign o_clk_rec_div      =   i_link_out_from_aib[REC_CLK_DIV66];    

endmodule

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q45Kjh2jVOqasQi95nlyWE1KGRtoyvKJ0E1Cv9Tc67CmftLzsf5cNO6zAvYRv9mbflpIsKjz3k/5oeKWcXxoX8WOK6MpsT7y3JQpUtEharvdFMyZbsQ2VHmJlxW78RjOIimdlGJNfchRsr0JxI1j3nOylfXUgnLSNleTk2SPaD6NX1IE7SuecDzRkrL/BcIZ+s+Te6Oi3dAeY26j5tIv2qSqpfz8QH/hSOq/RK61BXh2pCKVZM79rhTo2bKzbLzJy3HAe3cHu5r1zbkOJUPWKThYQ9hwejMyvqQC2kE67Q/cwqcARZXAZWKPSkXfoY1w2djyvf/R/ewRBFv9Y3d6r9V3R4Pldo51zgB3Rc1bXwAN1qRtzMZiF9P3j1h21nj4Rzz2FzzUP0LTaoA+A3VAj+uZXIHBbi/g4yYYen+iOJUIAEGTZho60fBcErP+lo4SKZ9RLyppXP94HaniTk23TPbmN/fpgyHYtsSBgLrwvtZq60kYdArXTq+MePNvo61UH4PGu5DCsSfge6LzeXRTZMPhfFeKY7P9ujALGtyOHWyMMO+TnKaMl492fbRbft200+hpAnlCSg53T6PkD9vXBrTF9eAJI+vYeZH/n/P3jYoA9Xt706i0Cu026tYS5FljUfumG4lPEapSMqmneMk64LmfWn325i0xMozN/fO7b96Z+2xZycpUyScraWFkRS3yhj7bU6x7VdM2PKJyQeCswXrimPv3KQMvZuXIZyc2X7296Pr4w2qwM6fSHqT/bi2r8HtzSmGSsp93v00YOaKyWUUA"
`endif