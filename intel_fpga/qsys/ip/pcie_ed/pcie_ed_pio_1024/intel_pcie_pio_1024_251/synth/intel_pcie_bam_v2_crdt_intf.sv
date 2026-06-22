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


//----------------------------------------------------------------------------- 
//  Project Name:  avmm_bridge_1024_ed                                   
//  Module Name :  intel_pcie_bam_cpl_v2                                 
//  Author      :  klai4                                   
//  Date        :  Mon Jan 11, 2021                                 
//  Description :  This module is to create the credit interface to interact with qhip
//-----------------------------------------------------------------------------

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module intel_pcie_bam_v2_crdt_intf
  #(
    parameter INIT_RX_DATA_P_COUNTER = 85,
    parameter INIT_RX_DATA_NP_COUNTER = 85,
    parameter INIT_RX_DATA_CPL_COUNTER = 85,
    parameter INIT_RX_HDR_P_COUNTER = 11,
    parameter INIT_RX_HDR_NP_COUNTER = 11,
    parameter INIT_RX_HDR_CPL_COUNTER = 10

   )
    (
     input logic          clk,
     input logic          rst_n,

     //rx hcrdt 
     output logic [2:0]		  rx_st_hcrdt_update_o,
     output logic [5:0]		  rx_st_hcrdt_update_cnt_o,
     output logic [2:0]		  rx_st_hcrdt_init_o,
     input  logic [2:0]              rx_st_hcrdt_init_ack_i,

     //rx dcrdt
     output logic [2:0]             rx_st_dcrdt_update_o,
     output logic [11:0]             rx_st_dcrdt_update_cnt_o,
     output logic [2:0]             rx_st_dcrdt_init_o,
     input  logic [2:0]             rx_st_dcrdt_init_ack_i,

     //tx hcrdt
     input logic [2:0]             tx_st_hcrdt_update_i,
     input logic [5:0]             tx_st_hcrdt_update_cnt_i,
     input logic [2:0]             tx_st_hcrdt_init_i,
     output  logic [2:0]             tx_st_hcrdt_init_ack_o,

     //tx dcrdt
     input logic [2:0]             tx_st_dcrdt_update_i,
     input logic [11:0]             tx_st_dcrdt_update_cnt_i,
     input logic [2:0]             tx_st_dcrdt_init_i,
     output  logic [2:0]             tx_st_dcrdt_init_ack_o,

     //input logics to determine return credit count
     input logic [9:0] 	       hdr_len_i,   // to connect to intel_pcie_bam_v2_cmd_preproc tlp_len_reg7
     input logic 	       hdr_valid_i,  // hdr_valid_reg7
     input logic 	       hdr_is_rd_i,  // tlp_is_rd_reg7
     input logic  	       hdr_is_wr_i,  // tlp_is_wr_reg7
     input logic 	       bam_rx_signal_ready_i, // connect to sch level bam_rx_ready_o
     input logic               pio_tx_st_ready_i,
     output logic              bam_tx_signal_ready_o,
     input logic [9:0]        tx_hdr_i,   // to get the length. It will tell how many DW of data in this TLP. Connect to bam_txc_header_o[9:0] at sch level
     input logic 	       tx_hdr_valid_i  // signal to tell the header is valid. Connect to bam_txc_valid_o

);
     localparam [2:0]                      RX_CRDT_INIT       = 3'b001;
     localparam [2:0]                      RX_CRDT_INIT_RET   = 3'b011;
     localparam [2:0]                      CRDT_IDLE         = 3'b010;
     localparam [2:0]                      TX_CRDT_INIT_CAP   = 3'b000;

    //logic declaration
     logic                   srst_reg;    
     logic  [2:0] crdt_state;
     logic  [2:0] crdt_nxt_state;
     //rx hcrdt
     logic [2:0]             rx_st_hcrdt_init_ack_reg;

     //rx dcrdt
     logic [2:0]             rx_st_dcrdt_init_ack_reg;

     //tx hcrdt
     logic [2:0]             tx_st_hcrdt_update_reg;
     logic [5:0]             tx_st_hcrdt_update_cnt_reg;
     logic [2:0]             tx_st_hcrdt_init_reg;
     logic [2:0]             tx_st_hcrdt_init_ack_reply_reg;

     //tx dcrdt
     logic [2:0]             tx_st_dcrdt_update_reg;
     logic [11:0]            tx_st_dcrdt_update_cnt_reg;
     logic [2:0]             tx_st_dcrdt_init_reg;
     logic [2:0]             tx_st_dcrdt_init_ack_reply_reg;

     logic  [9:0] hdr_len_reg;
     logic        hdr_valid_reg;
     logic        hdr_is_rd_reg;
     logic        hdr_is_wr_reg;
     logic  [9:0] hdr_len_reg2;
     logic        hdr_valid_reg2;
     logic        hdr_is_rd_reg2;
     logic        hdr_is_wr_reg2;

     logic        bam_to_signal_ready_reg;
     logic  [7:0] length_data_credit;
     
     logic [7:0]            rx_init_p_data_counter;
     logic [7:0]            rx_init_np_data_counter;
     logic [7:0]            rx_init_cpl_data_counter;
     logic [7:0]            rx_init_p_header_counter;
     logic [7:0]            rx_init_np_header_counter;
     logic [7:0]            rx_init_cpl_header_counter;
     
     logic [15:0]            rx_p_data_counter;
     logic [15:0]            rx_np_data_counter;
     logic [15:0]            rx_cpl_data_counter;
     logic [12:0]            rx_p_header_counter;
     logic [12:0]            rx_np_header_counter;
     logic [12:0]            rx_cpl_header_counter;
     
     logic [16:0]            tx_p_data_counter_cl;
     logic [16:0]            tx_np_data_counter_cl;
     logic [16:0]            tx_cpl_data_counter_cl;
     logic [12:0]            tx_p_header_counter_cl;
     logic [12:0]            tx_np_header_counter_cl;
     logic [12:0]            tx_cpl_header_counter_cl;

     logic [16:0]            tx_p_data_counter_cc;
     logic [16:0]            tx_np_data_counter_cc;
     logic [16:0]            tx_cpl_data_counter_cc;
     logic [16:0]            tx_cpl_data_counter_cc_w;
     logic [12:0]            tx_p_header_counter_cc;
     logic [12:0]            tx_np_header_counter_cc;
     logic [12:0]            tx_cpl_header_counter_cc;
	 
     logic                   tx_cpl_header_counter_cl_cc_overflow;
     logic                   tx_cpl_data_counter_cl_cc_overflow;
    logic                        tx_p_data_infinite;
    logic                        tx_np_data_infinite;
    logic                        tx_cpl_data_infinite;
    logic                        tx_p_header_infinite;
    logic                        tx_np_header_infinite;
    logic                        tx_cpl_header_infinite;
     	
     logic [3:0]                  sum_of_all_rx_counter;
     logic [3:0]                  sum_of_all_init_rx_counter;

     logic [9:0]        tx_hdr_w;
     logic              tx_hdr_valid_reg;
     logic 		state_rx_crdt_init;
     logic 		state_crdt_idle;
     logic 		state_tx_crdt_init_capture;
     logic 		state_rx_crdt_init_ret;
     

always_ff @(posedge clk)
  begin
    srst_reg        <= ~rst_n;
    if (srst_reg)
      crdt_state                   <= RX_CRDT_INIT;
    else begin
      crdt_state                   <= crdt_nxt_state;

      // capture all input ports	
      //rx header
      rx_st_hcrdt_init_ack_reg		<= rx_st_hcrdt_init_ack_i;

      //rx data
      rx_st_dcrdt_init_ack_reg          <= rx_st_dcrdt_init_ack_i; 

      //tx header
      tx_st_hcrdt_update_reg            <= tx_st_hcrdt_update_i;
      tx_st_hcrdt_update_cnt_reg        <= tx_st_hcrdt_update_cnt_i;
      tx_st_hcrdt_init_reg              <= tx_st_hcrdt_init_i;

      //tx data
      tx_st_dcrdt_update_reg            <= tx_st_dcrdt_update_i;
      tx_st_dcrdt_update_cnt_reg        <= tx_st_dcrdt_update_cnt_i;
      tx_st_dcrdt_init_reg              <= tx_st_dcrdt_init_i;

      hdr_len_reg	<=  hdr_len_i;
      hdr_valid_reg	<=  hdr_valid_i;	
      hdr_is_rd_reg	<=  hdr_is_rd_i;
      hdr_is_wr_reg	<=  hdr_is_wr_i;
      bam_to_signal_ready_reg		<=  bam_rx_signal_ready_i;
      hdr_valid_reg2 <= hdr_valid_reg;
      hdr_is_rd_reg2 <= hdr_is_rd_reg;
      hdr_is_wr_reg2 <= hdr_is_wr_reg;
     end

  end
 
  always_comb begin
    case(crdt_state)
      RX_CRDT_INIT   : // Entering RX Init Mode
          crdt_nxt_state = RX_CRDT_INIT_RET;

      RX_CRDT_INIT_RET : // Return credit for Init Mode
         if((bam_to_signal_ready_reg == 1 )&& (~|sum_of_all_init_rx_counter) && (~|sum_of_all_rx_counter)) begin //if all value initialized?
           crdt_nxt_state = CRDT_IDLE;
         end
         else
           crdt_nxt_state = RX_CRDT_INIT_RET;

      CRDT_IDLE: /// Idle Mode
         if((|tx_st_hcrdt_init_reg)||(|tx_st_dcrdt_init_reg))
           crdt_nxt_state = TX_CRDT_INIT_CAP;
         else
           crdt_nxt_state = CRDT_IDLE;

      TX_CRDT_INIT_CAP:   /// Return credit
         if(!((|tx_st_hcrdt_init_reg)||(|tx_st_dcrdt_init_reg)))
           crdt_nxt_state = CRDT_IDLE;
         else
           crdt_nxt_state = TX_CRDT_INIT_CAP;

       default:
         crdt_nxt_state = CRDT_IDLE;

    endcase
  end 

assign sum_of_all_rx_counter = |rx_p_data_counter + |rx_np_data_counter + |rx_cpl_data_counter + |rx_p_header_counter + |rx_np_header_counter + |rx_cpl_header_counter;
assign sum_of_all_init_rx_counter = |rx_init_p_data_counter + |rx_init_np_data_counter + |rx_init_cpl_data_counter + |rx_init_p_header_counter + |rx_init_np_header_counter + |rx_init_cpl_header_counter;
assign state_rx_crdt_init = (crdt_state == RX_CRDT_INIT);
assign state_rx_crdt_init_ret = (crdt_state == RX_CRDT_INIT_RET);
assign state_crdt_idle = (crdt_state == CRDT_IDLE);
//assign state_tx_crdt_init_capture = (crdt_state == TX_CRDT_INIT_CAP);

always_ff @ (posedge clk) begin
  if(state_rx_crdt_init) begin
    // default state --> all rx output zero out

  end
end

always_ff @ (posedge clk) begin
  if(hdr_valid_reg) begin //valid header detected
    if(hdr_len_reg[1:0] == 2'b00)  //1 header is having 1024DW. Every 4DW or 16B = 1 Credit. The length is in DW unit
      length_data_credit[7:0] <= hdr_len_reg[9:2]; // taking only by bit2 onward is equivalent to divided by 4
    else
      length_data_credit[7:0] <= hdr_len_reg[9:2] + 8'b00000001; //any remainder after divided by 4 will be added by 1 credit
  end
end

always_ff @ (posedge clk) begin
  if (srst_reg) begin
    rx_st_hcrdt_update_o[2:0] <= 0;
    rx_st_hcrdt_update_cnt_o[5:0] <= 0;
    rx_st_hcrdt_init_o[2:0] <= 3'b000;
    rx_st_dcrdt_update_o[2:0] <= 0;
    rx_st_dcrdt_update_cnt_o[11:0] <= 0;
    rx_st_dcrdt_init_o[2:0] <= 3'b000;
    rx_p_data_counter <= 0;
    rx_np_data_counter <= 0;
    rx_cpl_data_counter <= 0;
    rx_p_header_counter <= 0;
    rx_np_header_counter <= 0;
    rx_cpl_header_counter <= 0;
    rx_init_p_data_counter <= INIT_RX_DATA_P_COUNTER;
    rx_init_np_data_counter <= INIT_RX_DATA_NP_COUNTER;
    rx_init_cpl_data_counter <= INIT_RX_DATA_CPL_COUNTER;
    rx_init_p_header_counter <= INIT_RX_HDR_P_COUNTER;
    rx_init_np_header_counter <= INIT_RX_HDR_NP_COUNTER;
    rx_init_cpl_header_counter <= INIT_RX_HDR_CPL_COUNTER;

    
  end else begin
    if((state_crdt_idle)&&(|rx_st_dcrdt_init_o)&&(|rx_st_hcrdt_init_o)) begin //all value initialized when in idle mode
           rx_st_hcrdt_init_o = 0;  // end of Init Mode
           rx_st_dcrdt_init_o = 0;
    end
    if(state_rx_crdt_init_ret) begin  // transfering when counter not zero
      rx_st_hcrdt_init_o[2:0] <= 3'b111;
      rx_st_dcrdt_init_o[2:0] <= 3'b111;  
      if(rx_st_dcrdt_init_ack_i[0]) begin   //bit0 P, bit1 NP, bit2 CPL
        rx_p_data_counter <= rx_init_p_data_counter;
        rx_init_p_data_counter <= 0;  //reseting init counter
      end
      if(rx_st_dcrdt_init_ack_i[1]) begin   //bit0 P, bit1 NP, bit2 CPL
        rx_np_data_counter <= rx_init_np_data_counter;
        rx_init_np_data_counter <= 0;  //reseting init counter
      end
      if(rx_st_dcrdt_init_ack_i[2]) begin   //bit0 P, bit1 NP, bit2 CPL
        rx_cpl_data_counter <= rx_init_cpl_data_counter;
        rx_init_cpl_data_counter <= 0;  //reseting init counter
      end
      if(rx_st_hcrdt_init_ack_i[0]) begin   //bit0 P, bit1 NP, bit2 CPL
        rx_p_header_counter <= rx_init_p_header_counter;
        rx_init_p_header_counter <= 0;  //reseting init counter
      end
      if(rx_st_hcrdt_init_ack_i[1]) begin   //bit0 P, bit1 NP, bit2 CPL
        rx_np_header_counter <= rx_init_np_header_counter;
        rx_init_np_header_counter <= 0;  //reseting init counter
      end
      if(rx_st_hcrdt_init_ack_i[2]) begin   //bit0 P, bit1 NP, bit2 CPL
        rx_cpl_header_counter <= rx_init_cpl_header_counter;
        rx_init_cpl_header_counter <= 0;  //reseting init counter
      end
    end
  
    // transfering when counter not zero
    if(rx_p_data_counter == 0) begin  //Posted data
      rx_st_dcrdt_update_o[0] <= 1'b0;
      rx_st_dcrdt_update_cnt_o[3:0] <= 4'h0;
    end
    else if((rx_p_data_counter > 0)&&(rx_p_data_counter <= 15)) begin //maximum 15 credit per clk cycle
      rx_st_dcrdt_update_o[0] <= 1'b1;
      rx_st_dcrdt_update_cnt_o[3:0] <= rx_p_data_counter[3:0];
      rx_p_data_counter <= 16'h0;
    end
    else if(rx_p_data_counter > 15) begin
      rx_st_dcrdt_update_o[0] <= 1'b1;
      rx_st_dcrdt_update_cnt_o[3:0] <= 4'hF;
      rx_p_data_counter <= rx_p_data_counter - 4'hF;
    end 
    if(rx_np_data_counter == 0) begin  //Non Posted data
      rx_st_dcrdt_update_o[1] <= 1'b0;
      rx_st_dcrdt_update_cnt_o[7:4] <= 4'h0;
    end
    else if((rx_np_data_counter > 0)&&(rx_np_data_counter <= 15)) begin //maximum 15 credit per clk cycle
      rx_st_dcrdt_update_o[1] <= 1'b1;
      rx_st_dcrdt_update_cnt_o[7:4] <= rx_np_data_counter[3:0];
      rx_np_data_counter <= 16'h0;
    end
    else if(rx_np_data_counter > 15) begin
      rx_st_dcrdt_update_o[1] <= 1'b1;
      rx_st_dcrdt_update_cnt_o[7:4] <= 4'hF;
      rx_np_data_counter <= rx_np_data_counter - 4'hF;
    end
    if(rx_cpl_data_counter == 0) begin  //CPL data
      rx_st_dcrdt_update_o[2] <= 1'b0;
      rx_st_dcrdt_update_cnt_o[11:8] <= 4'h0;
    end
    else if((rx_cpl_data_counter > 0)&&(rx_cpl_data_counter <= 15)) begin //maximum 15 credit per clk cycle
      rx_st_dcrdt_update_o[2] <= 1'b1;
      rx_st_dcrdt_update_cnt_o[11:8] <= rx_cpl_data_counter[3:0];
      rx_cpl_data_counter <= 16'h0;
    end
    else if(rx_cpl_data_counter > 15) begin
      rx_st_dcrdt_update_o[2] <= 1'b1;
      rx_st_dcrdt_update_cnt_o[11:8] <= 4'hF;
      rx_cpl_data_counter <= rx_cpl_data_counter - 4'hF;
    end
    if(rx_p_header_counter == 0) begin  //Posted header
      rx_st_hcrdt_update_o[0] <= 1'b0;
      rx_st_hcrdt_update_cnt_o[1:0] <= 2'b0;
    end
    else if((rx_p_header_counter > 0)&&(rx_p_header_counter <= 3)) begin //maximum 3 credit per clk cycle
      rx_st_hcrdt_update_o[0] <= 1'b1;
      rx_st_hcrdt_update_cnt_o[1:0] <= rx_p_header_counter[1:0];
      rx_p_header_counter <= 13'h0;
    end
    else if(rx_p_header_counter > 3) begin
      rx_st_hcrdt_update_o[0] <= 1'b1;
      rx_st_hcrdt_update_cnt_o[1:0] <= 2'b11;
      rx_p_header_counter <= rx_p_header_counter - 2'b11;
    end
    if(rx_np_header_counter == 0) begin  //Non Posted header
      rx_st_hcrdt_update_o[1] <= 1'b0;
      rx_st_hcrdt_update_cnt_o[3:2] <= 2'b0;
    end
    else if((rx_np_header_counter > 0)&&(rx_np_header_counter <= 3)) begin //maximum 3 credit per clk cycle
      rx_st_hcrdt_update_o[1] <= 1'b1;
      rx_st_hcrdt_update_cnt_o[3:2] <= rx_np_header_counter[1:0];
      rx_np_header_counter <= 13'h0;
    end
    else if(rx_np_header_counter > 3) begin
      rx_st_hcrdt_update_o[1] <= 1'b1;
      rx_st_hcrdt_update_cnt_o[3:2] <= 2'b11;
      rx_np_header_counter <= rx_np_header_counter - 2'b11;
    end
    if(rx_cpl_header_counter == 0) begin  //CPL header
      rx_st_hcrdt_update_o[2] <= 1'b0;
      rx_st_hcrdt_update_cnt_o[5:4] <= 2'b0;
    end
    else if((rx_cpl_header_counter > 0)&&(rx_cpl_header_counter <= 3)) begin //maximum 3 credit per clk cycle
      rx_st_hcrdt_update_o[2] <= 1'b1;
      rx_st_hcrdt_update_cnt_o[5:4] <= rx_cpl_header_counter[1:0];
      rx_cpl_header_counter <= 13'h0;
    end
    else if(rx_cpl_header_counter > 3) begin
      rx_st_hcrdt_update_o[2] <= 1'b1;
      rx_st_hcrdt_update_cnt_o[5:4] <= 2'b11;
      rx_cpl_header_counter <= rx_cpl_header_counter - 2'b11;
    end
  
    if(hdr_valid_reg2) begin //1 cycle after valid header detected
      if(hdr_is_rd_reg2) begin
      rx_np_header_counter <= rx_np_header_counter + 1'b1;  //No data payload transfer at read. Only header credit is return.
      end
      else begin // considering write transaction is a posted message. Other posted message also having same procedure
      rx_p_header_counter <= rx_p_header_counter + 1'b1;
      rx_p_data_counter <= rx_p_data_counter + length_data_credit;
      end
    end
  end 

end

always_ff @ (posedge clk) begin  // TX dding to counter when updated
  if(srst_reg) begin
    tx_p_data_counter_cl <= 0;
    tx_np_data_counter_cl <= 0;
    tx_cpl_data_counter_cl <= 0;
    tx_p_header_counter_cl <= 0;
    tx_np_header_counter_cl <= 0;
    tx_cpl_header_counter_cl <= 0;
    tx_st_hcrdt_init_ack_reply_reg[2:0] <= 0;
    tx_st_dcrdt_init_ack_reply_reg[2:0] <= 0;
    tx_p_data_infinite <= 0;
    tx_np_data_infinite <= 0;
    tx_cpl_data_infinite <= 0;
    tx_p_header_infinite <= 0;
    tx_np_header_infinite <= 0;
    tx_cpl_header_infinite <= 0;
  end else begin
    if(tx_st_dcrdt_update_i[0]) begin  //Posted data
      tx_p_data_counter_cl <= tx_p_data_counter_cl + tx_st_dcrdt_update_cnt_i[3:0];
      if((tx_st_dcrdt_init_reg[0] == 1'b1)&&(tx_st_dcrdt_update_cnt_i[3:0] == 4'b0)) begin
        tx_p_data_infinite <= 1'b1;
      end
    end
    if(tx_st_dcrdt_update_i[1]) begin  //Non Posted data
      tx_np_data_counter_cl <= tx_np_data_counter_cl + tx_st_dcrdt_update_cnt_i[7:4];
      if((tx_st_dcrdt_init_reg[1] == 1'b1)&&(tx_st_dcrdt_update_cnt_i[7:4] == 4'b0)) begin
        tx_np_data_infinite <= 1'b1;
      end
    end
    if(tx_st_dcrdt_update_i[2]) begin  //CPL data
      tx_cpl_data_counter_cl <= tx_cpl_data_counter_cl + tx_st_dcrdt_update_cnt_i[11:8];
      if((tx_st_dcrdt_init_reg[2] == 1'b1)&&(tx_st_dcrdt_update_cnt_i[11:8] == 4'b0)) begin
        tx_cpl_data_infinite <= 1'b1;
      end
    end
	else if (tx_cpl_data_counter_cl_cc_overflow && ~tx_hdr_valid_i) begin //to unset when no update activities
      tx_cpl_data_counter_cl[16] <= 1'b0;	
	end
    if(tx_st_hcrdt_update_i[0]) begin  //Posted header
      tx_p_header_counter_cl <= tx_p_header_counter_cl + tx_st_hcrdt_update_cnt_i[1:0];
      if((tx_st_hcrdt_init_reg[0] == 1'b1)&&(tx_st_hcrdt_update_cnt_i[1:0] == 2'b0)) begin
        tx_p_header_infinite <= 1'b1;
      end
    end
    if(tx_st_hcrdt_update_i[1]) begin  //Non Posted header
      tx_np_header_counter_cl <= tx_np_header_counter_cl + tx_st_hcrdt_update_cnt_i[3:2];
      if((tx_st_hcrdt_init_reg[1] == 1'b1)&&(tx_st_hcrdt_update_cnt_i[3:2] == 2'b0)) begin
        tx_np_header_infinite <= 1'b1;
      end
    end
    if(tx_st_hcrdt_update_i[2]) begin  //CPL header
      tx_cpl_header_counter_cl <= tx_cpl_header_counter_cl + tx_st_hcrdt_update_cnt_i[5:4];
      if((tx_st_hcrdt_init_reg[2] == 1'b1)&&(tx_st_hcrdt_update_cnt_i[5:4] == 2'b0)) begin
        tx_cpl_header_infinite <= 1'b1;
      end
    end
	else if (tx_cpl_header_counter_cl_cc_overflow && ~tx_hdr_valid_i) begin //to unset when no update activities
      tx_cpl_header_counter_cl[12] <= 1'b0;	
	end
   // if((tx_hdr_valid_reg)&&(!state_rx_crdt_init)) begin  //to calculate the consumption of cpl credit
   //   tx_cpl_data_counter <= tx_cpl_data_counter - tx_hdr_reg;
   //   tx_cpl_header_counter <= tx_cpl_header_counter - 13'h1;
   // end
 // tx_hdr_reg <= (|tx_hdr_i[1:0]) ? ((tx_hdr_i >> 2) + 1'b1) : (tx_hdr_i >> 2);
 // tx_hdr_valid_reg <= tx_hdr_valid_i;
  end

end
always_comb begin
  tx_hdr_w = (|tx_hdr_i[1:0]) ? ((tx_hdr_i >> 2) + 1'b1) : (tx_hdr_i >> 2);	
  tx_cpl_data_counter_cc_w = tx_cpl_data_counter_cc + tx_hdr_w;
  tx_cpl_data_counter_cl_cc_overflow = tx_cpl_data_counter_cl[16] & tx_cpl_data_counter_cc[16]; //can initiate to unset both bit 16 to reset counter
  tx_cpl_header_counter_cl_cc_overflow = tx_cpl_header_counter_cl[12] & tx_cpl_header_counter_cc[12];
end

always_ff @ (posedge clk) begin
  if(srst_reg) begin
    tx_p_data_counter_cc <= 0;
    tx_np_data_counter_cc <= 0;
    tx_cpl_data_counter_cc <= 0;
    tx_p_header_counter_cc <= 0;
    tx_np_header_counter_cc <= 0;
    tx_cpl_header_counter_cc <= 0;  
  end
  else begin
    if(tx_hdr_valid_i) begin
      tx_cpl_data_counter_cc <= tx_cpl_data_counter_cc_w;	
	  tx_cpl_header_counter_cc <= tx_cpl_header_counter_cc + 13'h1;
	end
	if (tx_cpl_header_counter_cl_cc_overflow && ~tx_hdr_valid_i && ~tx_st_hcrdt_update_i[2]) begin //to unset when no update activities
      tx_cpl_header_counter_cc[12] <= 1'b0;	
	end
	if (tx_cpl_data_counter_cl_cc_overflow && ~tx_hdr_valid_i && ~tx_st_dcrdt_update_i[2]) begin //to unset when no update activities
      tx_cpl_data_counter_cc[16] <= 1'b0;	
	end
  end
end

always_ff @ (posedge clk) begin
  if(srst_reg) begin

  end
  else begin
    if(((tx_p_header_counter_cc > tx_p_header_counter_cl) && (!tx_p_header_infinite)) || ((tx_p_data_counter_cc > tx_p_data_counter_cl) && (!tx_p_data_infinite)) || ((tx_np_header_counter_cc > tx_np_header_counter_cl) && (!tx_np_header_infinite)) || ((tx_np_data_counter_cc > tx_np_data_counter_cl) && (!tx_np_data_infinite)) || ((tx_cpl_header_counter_cc > tx_cpl_header_counter_cl) && (!tx_cpl_header_infinite)) || ((tx_cpl_data_counter_cc > tx_cpl_data_counter_cl) && (!tx_cpl_data_infinite))) // start to back pressure BAM
    bam_tx_signal_ready_o <= 1'b0;
    else 
    bam_tx_signal_ready_o <= pio_tx_st_ready_i;
  end
end


intel_pcie_bam_v2_crdt_tx_ack tx_st_ack_p_data (
   .clk(clk), 
   .rst_n(rst_n),
   .state_tx_crdt_init_capture(|tx_st_dcrdt_init_reg),
   .tx_st_init_reg(tx_st_dcrdt_init_reg[0]),
   .tx_st_init_ack_o(tx_st_dcrdt_init_ack_o[0])
   );
intel_pcie_bam_v2_crdt_tx_ack tx_st_ack_np_data (
   .clk(clk),
   .rst_n(rst_n),
   .state_tx_crdt_init_capture(|tx_st_dcrdt_init_reg),
   .tx_st_init_reg(tx_st_dcrdt_init_reg[1]),
   .tx_st_init_ack_o(tx_st_dcrdt_init_ack_o[1])
   );
intel_pcie_bam_v2_crdt_tx_ack tx_st_ack_cpl_data (
   .clk(clk),
   .rst_n(rst_n),
   .state_tx_crdt_init_capture(|tx_st_dcrdt_init_reg),
   .tx_st_init_reg(tx_st_dcrdt_init_reg[2]),
   .tx_st_init_ack_o(tx_st_dcrdt_init_ack_o[2])
   );
intel_pcie_bam_v2_crdt_tx_ack tx_st_ack_p_header (
   .clk(clk),
   .rst_n(rst_n),
   .state_tx_crdt_init_capture(|tx_st_hcrdt_init_reg),
   .tx_st_init_reg(tx_st_hcrdt_init_reg[0]),
   .tx_st_init_ack_o(tx_st_hcrdt_init_ack_o[0])
   );
intel_pcie_bam_v2_crdt_tx_ack tx_st_ack_np_header (
   .clk(clk),
   .rst_n(rst_n),
   .state_tx_crdt_init_capture(|tx_st_hcrdt_init_reg),
   .tx_st_init_reg(tx_st_hcrdt_init_reg[1]),
   .tx_st_init_ack_o(tx_st_hcrdt_init_ack_o[1])
   );
intel_pcie_bam_v2_crdt_tx_ack tx_st_ack_cpl_header (
   .clk(clk),
   .rst_n(rst_n),
   .state_tx_crdt_init_capture(|tx_st_hcrdt_init_reg),
   .tx_st_init_reg(tx_st_hcrdt_init_reg[2]),
   .tx_st_init_ack_o(tx_st_hcrdt_init_ack_o[2])
   );


endmodule

module intel_pcie_bam_v2_crdt_tx_ack  //reply init ack only
   (
     input logic          clk,
     input logic          rst_n,

     input logic	state_tx_crdt_init_capture,
     input logic 	tx_st_init_reg,
     output logic       tx_st_init_ack_o
   );

  logic                   tx_st_init_ack_reply_reg;
  logic                   srst_reg;

  always_ff @ (posedge clk) begin
    srst_reg        <= ~rst_n;
    if (srst_reg) begin
      tx_st_init_ack_reply_reg <= 0;
      tx_st_init_ack_o <= 0;
    end
    else begin
      if(state_tx_crdt_init_capture) begin
        if(tx_st_init_reg) begin  //posted data
           if(tx_st_init_ack_reply_reg == 0) begin
             tx_st_init_ack_o <= 1;
             tx_st_init_ack_reply_reg <= 1;
           end
           else begin
             tx_st_init_ack_o <= 0;
           end
        end
        else begin
          tx_st_init_ack_reply_reg <=0;
	end
      end  //posted data end
    end
  end 
endmodule

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "Ct7RU5a/p+bqNMEu7Q8vVGkxrD9sml63wG3pH4RTYVLEkGP54+ko4S6h4izCOGh2sb1MtzKT4NgdJp4xN+yn2JGIZmbeOFlk7RGH2eFw9e3st+RwkxWCxS7KD1tPqriXtOc8UJty5UDKXbnNqnBAVeHZ6nPhWp1yOkMMqFi8IxMQBLtdbH85F6ety+Cx+QHBoe8B/SyEjMHeHo/WVdxxY872sbe9f+B4kDnQPeiLXt6gkJzV9zok+C32AA746aUjaVqJThPAsbnAzNYlYG0k6H+5cb+eZ1dAiOPRCK3gZ6ZmOwAtTlKI2Cn7pbIXYYDGtWFD54diwduELDRlaSIEXYP/IA05baqWOa14ye+3FgE1YDPlrU81xCPjfXzchchZUdni5T8LWUPaJ9qAYycIg94oeDnbwog0w0ToEJjvDGBvyq4ufHPP3KcDp8lzEjCBq4cH6BvFJg6TNdiOSrZf2Ecf+WA/VZjA7Fb5DkyjIdIsMqHCfXqvogQJyW7O/OhuJpg9W0wigBghOUBdB2v6czATBaYIbiNTbLfdBe3IsSIBtUxm6B79+0vZTSzmQpVaO0Y8XwmcLF0p9xR52YuVfKfJmAN0CkWuS+AnUTBfN+MbRffLYQ+12/TcGfUaYhvbrPcC+hLhWAaMmrF0xN6ipz6P2tN1yo1290nvAJY7OcuU42j0y/1nAODUNGIpd8TVSjG1mA1LD04cNUYS2xcTdIOXGqutKGpJ53u6YgrrT280HyxC7NYcjDpZArEJEGZP7avJzb52AKivAWaNILjnMYO5K2Ck8nS7rfxthEtJh4QAWs78S5RMsosUU/kCBivzCjiwXJLTGsYWOLiLpQgMG+JLJ4VTh1I1xtzQ6+iekQlg7DwN2Cn7b2fzS+93oCcZG5jPe6lfA6dnZ0VMYhza9NCY8pDNJSWxBjB5kFTOPZTQixwHUyoa0ZUoMKCNPg2CvULB9IPzwY/seOQLCtybyinQJ2iZiUFMEUBeYZWmL5i2JOtF0wiMC1pZX6idGfNd"
`endif