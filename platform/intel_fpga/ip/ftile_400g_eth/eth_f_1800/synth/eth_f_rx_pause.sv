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


module eth_f_rx_pause # (

parameter       AIB_LANES                = 1
) (

input wire                             clk_i,
input wire                             srst_n_i,

input wire  [AIB_LANES-1:0]        rx_mac_inframe,
input wire                         rx_mac_valid,
input wire  [AIB_LANES-1:0][2:0]   rx_mac_status,
input wire  [AIB_LANES-1:0]        rx_mac_fcs_error,
input wire  [AIB_LANES-1:0][63:0]  rx_data_in,   
input wire  [AIB_LANES-1:0] [2:0]  rx_mac_empty,
input wire  [AIB_LANES-1:0][1:0]   rx_mac_error,
input wire                         forward_user_rx_pause,
input wire  [47:0]                 mac_rxpause_daddr,                
input wire                         preamble_enable,    //preamble             

output wire  [AIB_LANES-1:0]       o_rx_mac_inframe,
output wire                        o_rx_mac_valid,
output wire  [AIB_LANES-1:0][2:0]  o_rx_mac_status,
output wire  [AIB_LANES-1:0]       o_rx_mac_fcs_error,
output wire  [AIB_LANES-1:0][63:0] o_rx_data_out,   
output wire  [AIB_LANES-1:0] [2:0] o_rx_mac_empty,
output wire  [AIB_LANES-1:0][1:0]  o_rx_mac_error,

output logic     [15:0]            SFC_quanta,
output logic                       SFC_valid
     
);
      
  logic [AIB_LANES-1:0]        rx_mac_sop, rx_mac_eop;

	logic												 rx_mac_valid_reg1;
  logic [AIB_LANES-1:0]        rx_mac_sop_reg1;
  logic [AIB_LANES-1:0]        rx_mac_eop_reg1;
  logic [AIB_LANES-1:0]        rx_mac_inframe_reg1;
	logic [AIB_LANES-1:0][63:0]  rx_mac_data_in_reg1;   
	logic [AIB_LANES-1:0][2:0]   rx_mac_status_reg1;
	logic [AIB_LANES-1:0]        rx_mac_fcs_error_reg1;
	logic [AIB_LANES-1:0] [2:0]  rx_mac_empty_reg1;
	logic [AIB_LANES-1:0][1:0]   rx_mac_error_reg1;

	logic												 rx_mac_valid_reg2;
  logic [AIB_LANES-1:0]        rx_mac_sop_reg2;
  logic [AIB_LANES-1:0]        rx_mac_eop_reg2;
  logic [AIB_LANES-1:0]        rx_mac_inframe_reg2;
	logic [AIB_LANES-1:0][63:0]  rx_mac_data_in_reg2;   
	logic [AIB_LANES-1:0][2:0]   rx_mac_status_reg2;
	logic [AIB_LANES-1:0]        rx_mac_fcs_error_reg2;
	logic [AIB_LANES-1:0] [2:0]  rx_mac_empty_reg2;
	logic [AIB_LANES-1:0][1:0]   rx_mac_error_reg2;

  logic [AIB_LANES-1:0]        rx_mac_sop_reg3;

  logic [AIB_LANES-1:0]        da_match, da_match_pre;
  logic [AIB_LANES-1:0]        da_match_reg1, da_match_pre_reg1;
  logic [AIB_LANES-1:0]        code_match,code_match_pre;
  logic [AIB_LANES-1:0]        pause_frm_detect, pause_frm_detect_pre;
  logic [AIB_LANES-1:0]        pause_frm_detect_reg1, pause_frm_detect_pre_reg1;
  logic                   	   pause_frame_detected_reg1;
  logic                   	   pause_frame_detected_reg2;
  logic [AIB_LANES-1:0]        SOP_DA_aligned, SOP_CODE_aligned;
  //logic [AIB_LANES-1:0]        SOP_QUANTA_aligned;
  //logic [AIB_LANES-1:0]        pause_quanta_en_reg1, pause_quanta_en_reg2;
  logic  [AIB_LANES-1:0]        pause_quanta_en;
  logic  [AIB_LANES-1:0]        pause_quanta_en_reg;
  logic [AIB_LANES-1:0]        da_match_code_algiend, da_match_code_algiend_pre;
  logic [2*AIB_LANES-1:0]        pause_frm_detect_align;
  logic [2*AIB_LANES-1:0]        pause_frm_detect_align_pre;

  //
  logic [47:0]                 mac_rxpause_daddr_reg; 
	logic                        forward_user_rx_pause_reg;
 	reg  [3:0]									 sop_num, eop_num;

  logic                        pause_frame_detected;
  logic                        frame_in_progress;
  logic                        pause_frame_in_progress;
  //logic                        pause_frame_in_progress_reg1;
  logic                        preamble_enable_reg;   //preamble             

	//
	//After data alignment
  logic                        int_rx_valid;
  logic [AIB_LANES-1:0]        int_rx_sop;
  logic [AIB_LANES-1:0]        int_rx_eop;
  logic [AIB_LANES-1:0]        int_rx_inframe;
  logic [AIB_LANES-1:0][63:0]  int_rx_data;
  logic [AIB_LANES-1:0][2:0]   int_rx_empty;
  logic [AIB_LANES-1:0][1:0]   int_rx_error;
  logic [AIB_LANES-1:0]        int_rx_fcs_error;
  logic [AIB_LANES-1:0][2:0]   int_rx_status;

      
  logic                        int_rx_valid_r1;
  logic [AIB_LANES-1:0]        int_rx_sop_r1;
  logic [AIB_LANES-1:0]        int_rx_eop_r1;
  logic [AIB_LANES-1:0]        int_rx_inframe_r1;
  logic [AIB_LANES-1:0][63:0]  int_rx_data_r1;
  logic [AIB_LANES-1:0][2:0]   int_rx_empty_r1;
  logic [AIB_LANES-1:0][1:0]   int_rx_error_r1;
  logic [AIB_LANES-1:0]        int_rx_fcs_error_r1;
  logic [AIB_LANES-1:0][2:0]   int_rx_status_r1;
  
  //logic                        int_rx_valid_r2;
  //logic [AIB_LANES-1:0]        int_rx_sop_r2;
  //logic [AIB_LANES-1:0]        int_rx_eop_r2;
  //logic [AIB_LANES-1:0]        int_rx_inframe_r2;
  //logic [AIB_LANES-1:0][63:0]  int_rx_data_r2;
  //logic [AIB_LANES-1:0][2:0]   int_rx_empty_r2;
  //logic [AIB_LANES-1:0][1:0]   int_rx_error_r2;
  //logic [AIB_LANES-1:0]        int_rx_fcs_error_r2;
  //logic [AIB_LANES-1:0][2:0]   int_rx_status_r2;

 
  logic [AIB_LANES-1:0]   rx_sfc_valid;
  logic    		  rx_sfc_valid_r;
  logic    		  rx_sfc_valid_r1;
  logic [AIB_LANES-1:0]   stop_inframes_r1;
  //logic [AIB_LANES-1:0]   stop_inframes_r2;


//*************************************************************************************************
//Sync
//*************************************************************************************************
eth_f_xcvr_resync_std #(
           .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0) 
       ) sync_1 (
           .clk    (clk_i),
           .reset  (1'b0),
           .d  (forward_user_rx_pause),
           .q  (forward_user_rx_pause_reg)
       );

eth_f_xcvr_resync_std #(
           .SYNC_CHAIN_LENGTH(3),    .WIDTH(48),  .INIT_VALUE(0) 
       ) sync_2 (
           .clk    (clk_i),
           .reset  (1'b0),
           .d  (mac_rxpause_daddr),
           .q  (mac_rxpause_daddr_reg)
       );


eth_f_xcvr_resync_std #(
           .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0) 
       ) sync_3 (
           .clk    (clk_i),
           .reset  (1'b0),
           .d  (preamble_enable),
           .q  (preamble_enable_reg)
       );
             

//*************************************************************************************************
//*********************************   Pause frame detection ***************************************
//*************************************************************************************************
eth_f_sop_eop_detection # (
    .INFRAME (AIB_LANES)
) sop_eop_dut (

   .rx_mac_inframe  (rx_mac_inframe),
   .clk_i           (clk_i),
   .srst_n_i        (srst_n_i),
   .rx_mac_valid    (rx_mac_valid),
   .SOP_detected    (rx_mac_sop),
   .EOP_detected    (rx_mac_eop)
 );
always @(posedge clk_i)
begin
	if (~srst_n_i)begin
		rx_mac_valid_reg1					<= 'h0;
		rx_mac_valid_reg2					<= 'h0;
	end
	else begin
		rx_mac_valid_reg1					<= rx_mac_valid; 
		rx_mac_valid_reg2					<= rx_mac_valid_reg1;
	end
end

always @(posedge clk_i)
begin
	if (~srst_n_i)begin
		rx_mac_sop_reg1 			<= 'h0;
		rx_mac_eop_reg1				<= 'h0;
		rx_mac_inframe_reg1  			<= 'h0;
		rx_mac_data_in_reg1  			<= 'h0;
		rx_mac_empty_reg1   			<= 'h0;
		rx_mac_status_reg1  			<= 'h0;
		rx_mac_fcs_error_reg1			<= 'h0;
		rx_mac_error_reg1   			<= 'h0;
	
        	da_match_reg1 				<= 'h0;
		da_match_pre_reg1 			<= 'h0;
		pause_frm_detect_reg1 	  <= 'h0; 
		pause_frm_detect_pre_reg1 <= 'h0; 
  end
  else if(rx_mac_valid) begin
		rx_mac_sop_reg1 			<= rx_mac_sop;
		rx_mac_eop_reg1				<= rx_mac_eop;
		rx_mac_inframe_reg1  			<= rx_mac_inframe;
		rx_mac_data_in_reg1  			<= rx_data_in;
		rx_mac_empty_reg1   			<= rx_mac_empty;
		rx_mac_status_reg1  			<= rx_mac_status;
		rx_mac_fcs_error_reg1			<= rx_mac_fcs_error;
		rx_mac_error_reg1   			<= rx_mac_error;
		//
		da_match_reg1				<= da_match;
		da_match_pre_reg1			<= da_match_pre;
		pause_frm_detect_reg1                   <= pause_frm_detect;
		pause_frm_detect_pre_reg1               <= pause_frm_detect_pre;
  end
end

always @(posedge clk_i)
begin
	if (~srst_n_i)begin
		rx_mac_sop_reg2 			<= 'h0;
		rx_mac_eop_reg2				<= 'h0;
		rx_mac_inframe_reg2  			<= 'h0;
		rx_mac_data_in_reg2  			<= 'h0;
		rx_mac_empty_reg2   			<= 'h0;
		rx_mac_status_reg2  			<= 'h0;
		rx_mac_fcs_error_reg2			<= 'h0;
		rx_mac_error_reg2   			<= 'h0;
                pause_frame_detected_reg2               <= 'h0;
  end
  else if(rx_mac_valid) begin  //this is latching the data not delay
		rx_mac_sop_reg2 			<= rx_mac_sop_reg1;
		rx_mac_eop_reg2				<= rx_mac_eop_reg1;
		rx_mac_inframe_reg2  			<= rx_mac_inframe_reg1;
		rx_mac_data_in_reg2  			<= rx_mac_data_in_reg1;
		rx_mac_empty_reg2   			<= rx_mac_empty_reg1;
		rx_mac_status_reg2  			<= rx_mac_status_reg1;
		rx_mac_fcs_error_reg2			<= rx_mac_fcs_error_reg1;
		rx_mac_error_reg2   			<= rx_mac_error_reg1;
    pause_frame_detected_reg2 <= pause_frame_detected_reg1;
    //pause_quanta_en_reg2      <= pause_quanta_en_reg1; 
  end
end

always @(posedge clk_i)
begin
	if (~srst_n_i)begin
		rx_mac_sop_reg3 					<= 'h0;
  end
  else if(rx_mac_valid) begin //this is latching the data not delay
		rx_mac_sop_reg3 					<= rx_mac_sop_reg2;
  end
end

if (AIB_LANES == 'd1)
begin
	assign SOP_DA_aligned            = rx_mac_sop_reg1;  //one seg delayed of SOP
	assign SOP_CODE_aligned 				 = rx_mac_sop_reg2;  //two seg delayed of SOP
	//assign SOP_QUANTA_aligned 			 = rx_mac_sop_reg3;  //3 seg delayed of SOP
	assign da_match_code_algiend 		 = da_match_reg1; //one seg delay
	assign da_match_code_algiend_pre = da_match_pre_reg1; //one seg delay
	assign pause_frm_detect_align    = pause_frm_detect; 
	assign pause_frm_detect_align_pre= pause_frm_detect_pre; 
	assign pause_frame_detected_reg1 = preamble_enable_reg ?  pause_frm_detect_pre : pause_frm_detect; // aligned to Latch-1 in normal, Latch-2 in preamble single seg
  assign pause_quanta_en           = preamble_enable_reg ? pause_frm_detect_pre_reg1 : pause_frm_detect_reg1;
end
else if(AIB_LANES == 'd2) begin
	assign SOP_DA_aligned 					 = {rx_mac_sop[AIB_LANES-2:0], rx_mac_sop_reg1[AIB_LANES-1]};
	assign SOP_CODE_aligned 				 = rx_mac_sop_reg1[AIB_LANES-1:0];
	//assign SOP_QUANTA_aligned				 = {rx_mac_sop_reg1[AIB_LANES-2:0], rx_mac_sop_reg2[AIB_LANES-1]};
	assign da_match_code_algiend 		 = {da_match[AIB_LANES-2:0], da_match_reg1[AIB_LANES-1]}; //one seg delay
	assign da_match_code_algiend_pre = {da_match_pre[AIB_LANES-2:0], da_match_pre_reg1[AIB_LANES-1]}; //one seg delay

	assign pause_frm_detect_align    = {pause_frm_detect[AIB_LANES-1:0], pause_frm_detect_reg1[AIB_LANES-1:0]} >> 1;   //this is the aligned frm detect to sop of one clock delayed data
	assign pause_frm_detect_align_pre= {pause_frm_detect_pre[AIB_LANES-1:0], pause_frm_detect_pre_reg1[AIB_LANES-1:0]} >> 2;
	assign pause_frame_detected_reg1 = preamble_enable_reg ? (|pause_frm_detect_align_pre[AIB_LANES-1:0])  : (|pause_frm_detect_align[AIB_LANES-1:0]); // aligned to Latch1 data 
  assign pause_quanta_en           = preamble_enable_reg ? {pause_frm_detect_pre[AIB_LANES-2:0], pause_frm_detect_pre_reg1[AIB_LANES-1]} : {pause_frm_detect[AIB_LANES-2:0], pause_frm_detect_reg1[AIB_LANES-1]};
end
else begin // 4 and 8 segment case
	assign SOP_DA_aligned 				   = {rx_mac_sop[AIB_LANES-2:0], rx_mac_sop_reg1[AIB_LANES-1]};
	assign SOP_CODE_aligned          = {rx_mac_sop[AIB_LANES-3:0], rx_mac_sop_reg1[AIB_LANES-1], rx_mac_sop_reg1[AIB_LANES-2]};
	//assign SOP_QUANTA_aligned        = {rx_mac_sop[AIB_LANES-4:0], rx_mac_sop_reg1[AIB_LANES-1], rx_mac_sop_reg1[AIB_LANES-2], rx_mac_sop_reg1[AIB_LANES-3]};
  assign da_match_code_algiend     = {da_match[AIB_LANES-2:0], da_match_reg1[AIB_LANES-1]}; //one seg delay
	assign da_match_code_algiend_pre = {da_match_pre[AIB_LANES-2:0], da_match_pre_reg1[AIB_LANES-1]}; //one seg delay
  //assign pause_frm_detect_align    = {pause_frm_detect_reg1[AIB_LANES-1:0], pause_frm_detect[AIB_LANES-1:0]} >> (AIB_LANES+AIB_LANES-6); //Delaying by AIB_LANES-2 seg's to algin to data
  //assign pause_frm_detect_align_pre= {pause_frm_detect_pre_reg1[AIB_LANES-1:0], pause_frm_detect_pre[AIB_LANES-1:0]} >> (AIB_LANES+AIB_LANES-6);
	assign pause_frm_detect_align    = {pause_frm_detect[AIB_LANES-1:0], pause_frm_detect_reg1[AIB_LANES-1:0]} >> 1;   //this is the aligned frm detect to sop of one clock delayed data
	assign pause_frm_detect_align_pre= {pause_frm_detect_pre[AIB_LANES-1:0], pause_frm_detect_pre_reg1[AIB_LANES-1:0]} >> 2;
	assign pause_frame_detected_reg1 = preamble_enable_reg ? (|pause_frm_detect_align_pre[AIB_LANES-1:0])  : (|pause_frm_detect_align[AIB_LANES-1:0]); // aligned to Latch1 data 
  assign pause_quanta_en           = preamble_enable_reg ? {pause_frm_detect_pre[AIB_LANES-2:0], pause_frm_detect_pre_reg1[AIB_LANES-1]} : {pause_frm_detect[AIB_LANES-2:0], pause_frm_detect_reg1[AIB_LANES-1]};  //one seg delayed
end

///////////////////////// DA detection //////////////////////

//TBD - check counter based and also add op-code check
genvar d;
generate
  for (d = 0; d < AIB_LANES; d = d + 1) begin : data_en_opcode_gen
    assign da_match[d]        = ((mac_rxpause_daddr_reg == {rx_data_in[d][7:0],rx_data_in[d][15:8],rx_data_in[d][23:16],rx_data_in[d][31:24],rx_data_in[d][39:32],rx_data_in[d][47:40]}) && rx_mac_sop[d] && (rx_mac_valid == 1'b1)) ? 1'b1: 1'b0;
    assign code_match[d]      = (((32'h8808_0001 == {rx_data_in[d][39:32],rx_data_in[d][47:40],rx_data_in[d][55:48],rx_data_in[d][63:56]}) && SOP_DA_aligned[d] && (rx_mac_valid == 1'b1)) || ((32'h8808_0101 == {rx_data_in[d][39:32],rx_data_in[d][47:40],rx_data_in[d][55:48],rx_data_in[d][63:56]}) && SOP_DA_aligned[d] && (rx_mac_valid == 1'b1)) ) ? 1'b1: 1'b0;

    assign da_match_pre[d]    = ((mac_rxpause_daddr_reg == {rx_data_in[d][7:0],rx_data_in[d][15:8],rx_data_in[d][23:16],rx_data_in[d][31:24],rx_data_in[d][39:32],rx_data_in[d][47:40]}) && SOP_DA_aligned[d] && (rx_mac_valid == 1'b1)) ? 1'b1: 1'b0;
    assign code_match_pre[d]  = (((32'h8808_0001 == {rx_data_in[d][39:32],rx_data_in[d][47:40],rx_data_in[d][55:48],rx_data_in[d][63:56]}) && SOP_CODE_aligned[d] && (rx_mac_valid == 1'b1)) || ((32'h8808_0101 == {rx_data_in[d][39:32],rx_data_in[d][47:40],rx_data_in[d][55:48],rx_data_in[d][63:56]}) && SOP_CODE_aligned[d] && (rx_mac_valid == 1'b1))) ? 1'b1: 1'b0;
  end
endgenerate

assign pause_frm_detect     = da_match_code_algiend & code_match;
assign pause_frm_detect_pre = da_match_code_algiend_pre & code_match_pre;

always@(posedge clk_i)
  begin
   if (~srst_n_i) begin
        int_rx_valid                <= 'h0;
                int_rx_sop     				<= 'h0; 
	  	int_rx_eop     				<= 'h0; 
		int_rx_inframe 				<= 'h0; 
		int_rx_data    				<= 'h0; 
		int_rx_empty   				<= 'h0; 
                int_rx_fcs_error 			<= 'h0; 
		int_rx_status    		        <= 'h0; 
		int_rx_error    		        <= 'h0; 
                pause_frame_detected 	                <= 'h0; 

      end


   else if(preamble_enable_reg && (AIB_LANES == 1))
      begin
	  int_rx_valid     			<= rx_mac_valid;
         if(rx_mac_valid)
           begin
	  	int_rx_sop     				<= rx_mac_sop_reg2; 
	  	int_rx_eop     				<= rx_mac_eop_reg2; 
		int_rx_inframe 				<= rx_mac_inframe_reg2;   
		int_rx_data    				<= rx_mac_data_in_reg2;
		int_rx_empty   				<= rx_mac_empty_reg2;
                int_rx_fcs_error 			<= rx_mac_fcs_error_reg2;  
		int_rx_status    		        <= rx_mac_status_reg2;
		int_rx_error    		        <= rx_mac_error_reg2;
                pause_frame_detected 	                <= pause_frame_detected_reg1;  //in single seg preabmle case reg1 aligned to reg2 data
          end
         end
  else 
     begin
	  int_rx_valid     			<= rx_mac_valid;
           if(rx_mac_valid)
             begin
	  	int_rx_sop     				<= rx_mac_sop_reg1; 
	  	int_rx_eop     				<= rx_mac_eop_reg1; 
	        int_rx_inframe 				<= rx_mac_inframe_reg1;
		int_rx_data    				<= rx_mac_data_in_reg1;
		int_rx_empty   				<= rx_mac_empty_reg1;
                int_rx_fcs_error 			<= rx_mac_fcs_error_reg1;  
		int_rx_status    			<= rx_mac_status_reg1;
		int_rx_error    			<= rx_mac_error_reg1;
      pause_frame_detected 	<= pause_frame_detected_reg1;
      //pause_quanta_en       <= pause_quanta_en_reg1; 
    end
  end
end

always @ (posedge clk_i) 
begin
	if (~srst_n_i)
	  sop_num <= 4'd0;
	else 
	begin
	  for (int i = 0;i < AIB_LANES; i= i+1) begin: encoder_output
	    if (rx_mac_sop_reg1[i] == 1'b1  && rx_mac_valid == 1'b1)
	      sop_num <= i + 1'd1;  //not used in single seg case
	  end //for loop
	end //else
end //always

always @ (posedge clk_i) 
begin
	if (~srst_n_i)
	  eop_num <= 3'd0;
	else 
	begin
	  for (int i = 0;i < AIB_LANES; i= i+1) begin: eop_num_det
	    if (rx_mac_eop_reg1[i] == 1'b1  && rx_mac_valid == 1'b1)
	      eop_num <= i + 1'd1;
	  end //for loop
	end //else
end //always

//algined to int_rx_?? signals
always @(posedge clk_i) begin
  if (~srst_n_i)
    frame_in_progress <= 1'b0;
	else 
	begin
  	if (pause_frame_detected && (int_rx_sop < int_rx_eop) && int_rx_valid) //No SOP & pre-EOP or pre-EOP //end of packet
  	  frame_in_progress <= 1'b0; 
  	else if (pause_frame_detected  && (int_rx_sop > int_rx_eop) && int_rx_valid) //No SOP & pre-EOP or pre-EOP //end of packet
  	  frame_in_progress <= 1'b1; 
  	else if (~pause_frame_detected && (int_rx_eop != 'h0) && int_rx_valid) 
  	  frame_in_progress <= 1'b0; 
  	else
  	  frame_in_progress <= frame_in_progress; 
  end
end 

assign pause_frame_in_progress = frame_in_progress;// || pause_frame_detected;

//*************************************************************************************************
//*********************************   Pause Quanta  ***********************************************
//*************************************************************************************************
always @ (posedge clk_i) 
begin
	if (~srst_n_i)
	  pause_quanta_en_reg <= 'h0;
	else 
	  pause_quanta_en_reg <= pause_quanta_en;
end //always

always @ (posedge clk_i) 
begin
	if (~srst_n_i)
	  SFC_quanta <= 16'd0;
	else 
	begin
	  for (int i = 0;i < AIB_LANES; i= i+1) begin: quanta_output
	    if (pause_quanta_en_reg[i] == 1'b1 && rx_mac_valid_reg1)
	      SFC_quanta <= {rx_mac_data_in_reg1[i][7:0], rx_mac_data_in_reg1[i][15:8]};
	  end //for loop
	end //else
end //always

/*
eth_f_lut_logic # (
           
  .DATA_WIDTH (AIB_LANES),
  .INFRAME (AIB_LANES) 
)
 lut_dut (
    .clk_i                   (clk_i),
    .srst_n_i                (srst_n_i),
    .SOP_detected            (int_rx_sop),
    .EOP_detected            (int_rx_eop),
    .rx_mac_inframe          (int_rx_inframe),
    .rx_mac_valid            (int_rx_valid),
    .data_in                 (int_rx_data),
    .preamble_enable         (preamble_enable_reg),
    .pause_frame_detected    (pause_frame_detected),
    .frame_in_progress			 (pause_frame_in_progress),
    .Quanta_out              (SFC_quanta)
);
*/

genvar i;
generate
  for (i = 0; i < AIB_LANES; i = i + 1) begin : SFC_gen
    assign rx_sfc_valid[i] = (rx_mac_eop_reg1[i] == 1'b1 && rx_mac_status_reg1[i] == 3'b100 && rx_mac_error_reg1[i] == 'd0 &&  rx_mac_valid_reg1 == 1'b1) ? 1'b1 : 1'b0;
  end
endgenerate

assign rx_sfc_valid_r = |rx_sfc_valid;

//assign pause_error0 = pause_frame_in_progress && (rx_sfc_valid == 'h0);
//assign pause_error1 = ~pause_frame_in_progress && (rx_sfc_valid != 'h0);

always @ (posedge clk_i) begin
if (~srst_n_i) begin
	SFC_valid <= 1'b0; 
        rx_sfc_valid_r1 <= 1'b0;
end else begin
	rx_sfc_valid_r1 <= rx_sfc_valid_r;
        SFC_valid  <= rx_sfc_valid_r1 || rx_sfc_valid_r;
end 
end


always_ff @(posedge clk_i) begin
  if (~srst_n_i)
	begin
	  int_rx_valid_r1        <= 'h0 ;
	  //int_rx_valid_r2        <= 'h0 ;
	end
  else
	begin
	  int_rx_valid_r1        <= int_rx_valid;
	  //int_rx_valid_r2        <= int_rx_valid_r1;
	end
end

always_ff @(posedge clk_i) begin
  if (~srst_n_i)
      begin
          int_rx_data_r1         <= 'h0;
          int_rx_inframe_r1      <= 'h0; 
          int_rx_sop_r1          <= 'h0; 
          int_rx_eop_r1          <= 'h0; 
          int_rx_empty_r1        <= 'h0;
          int_rx_error_r1        <= 'h0;
          int_rx_fcs_error_r1    <= 'h0; 
	  		  int_rx_status_r1       <= 'h0;
					//
					//pause_frame_in_progress_reg1 <= 1'b0;
      end
     else begin
          int_rx_data_r1         <= int_rx_data;
          int_rx_inframe_r1      <= int_rx_inframe; 
          int_rx_sop_r1          <= int_rx_sop; 
          int_rx_eop_r1          <= int_rx_eop; 
          int_rx_empty_r1        <= int_rx_empty;
          int_rx_error_r1        <= int_rx_error;
          int_rx_fcs_error_r1    <= int_rx_fcs_error; 
	  			int_rx_status_r1       <= int_rx_status;
					//
          //if(int_rx_valid) //latching prev pause frame sig 
					  //pause_frame_in_progress_reg1 <= pause_frame_in_progress;
    end
end //always

   
 // always_ff @(posedge clk_i) begin
 //    if (~srst_n_i)
 //      begin
 //         int_rx_data_r2         <=  'h0;
 //         int_rx_inframe_r2      <=  'h0; 
 //         int_rx_sop_r2          <=  'h0; 
 //         int_rx_eop_r2          <=  'h0; 
 //         int_rx_empty_r2        <=  'h0;
 //         int_rx_error_r2        <=  'h0;
 //         int_rx_fcs_error_r2    <=  'h0; 
 //   			int_rx_status_r2       <=  'h0;
 // 				//
 // 				stop_inframes_r2       <=  'h1;
 //      end
 //   else begin
 //         int_rx_data_r2         <= int_rx_data_r1;
 //         int_rx_inframe_r2      <= int_rx_inframe_r1;
 //         int_rx_sop_r2          <= int_rx_sop_r1; 
 //         int_rx_eop_r2          <= int_rx_eop_r1; 
 //         int_rx_empty_r2        <= int_rx_empty_r1;
 //         int_rx_error_r2        <= int_rx_error_r1;
 //         int_rx_fcs_error_r2    <= int_rx_fcs_error_r1; 
 //   			int_rx_status_r2       <= int_rx_status_r1;
 // 				//
 // 				stop_inframes_r2       <= stop_inframes_r1;
 //   end
 //end //always
 

 //---------------------------------------------------------------------------------------------------------// 
//generating inframe disable signal, for pause frames with fwd is disabled then stop_inframes_r1 is made 0b0
  always @(posedge clk_i) 
  begin
    if(~srst_n_i)
 		 	stop_inframes_r1 <= {AIB_LANES{1'b1}};
    else if(forward_user_rx_pause_reg == 1'b1)
 		 	stop_inframes_r1 <= {AIB_LANES{1'b1}};
    else if(int_rx_valid)
		begin
 	  	if(AIB_LANES == 1)
 			 	stop_inframes_r1 <= (pause_frame_in_progress || pause_frame_detected) ? 1'b0 : 1'b1; 
    	else
 	 		begin
 			 	if(pause_frame_in_progress && pause_frame_detected) //back to back pause frames
 			 		stop_inframes_r1 <= {AIB_LANES{1'h0}};
 			 	else if(pause_frame_detected)  //assuming minimum 64-byte packet
 			 		stop_inframes_r1 <= {AIB_LANES{1'h1}} >> (AIB_LANES+1-sop_num);
 			 	else if(pause_frame_in_progress)
 			 		stop_inframes_r1 <= (int_rx_eop == 'h0) ? {AIB_LANES{1'h0}} : (({AIB_LANES{1'h1}} >> eop_num) << eop_num);
 			 	else
 			 		stop_inframes_r1 <= {AIB_LANES{1'h1}};
 	  	end
 	 	end
   end

	assign  o_rx_mac_inframe    = int_rx_inframe_r1 & stop_inframes_r1;
	assign  o_rx_mac_valid      = int_rx_valid_r1;
	assign  o_rx_mac_status     = int_rx_status_r1;
	assign  o_rx_mac_fcs_error  = int_rx_fcs_error_r1;
	assign  o_rx_data_out       = int_rx_data_r1;
	assign  o_rx_mac_empty      = int_rx_empty_r1;
	assign  o_rx_mac_error      = int_rx_error_r1;

endmodule

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "IHWHrFSUaPtjZF1LBDe+5u/fCSc0//dMeoOgG/ez60Rt84WK1OI/WsMDAOmCm2IklwNYebRgS3zVDw7MPxWxM11LRVdkLZ+X/y8WtfqnS7Duroraj/37v+2WHhkPuM7Zr5jlblPypJOlE04iTTEfu+W3Q6H2vZl2TlAJ75jp9EioCxq3Erh26V4am36iNzJ8q9nPT5rffTeZv2243MrLgLaBmit/Byil0W+B47PrapW3I2j1+XZtvdzmP9XiuoWEdNtl4QX2kZ1VHqZ96jqwe1FkaTS9B4i+B9QF0+WRGg5SpY299a1nA63EezPsbQsAKTx61M3zOG1czvhQARqMwC9kG/ezIOZrFJqEHewI3GNqZ4NJRYv3zEuEIOv48uOMWt9XuUDmuVpDp36vuWmvVvzsKeLlu8ChsPSZO6bzAXymF16frtbixCBseQIDxURRve9LHWCE+rVxpK9P9di37rRQo2jH1OlDB1GjfJxzmhoNf6ch6PiOZpvoTBOv7Y6uL/UuplkR/BaoQLpVlWzROvZCf2xT3j28xdUaqHNWfVua2mBYeF/wc0QohuAeh/iUwEcBpsAubUliQgs8zHnFCMCN5THjIj9LL7YRiVmnTHtn2cavY/82vRrwiSrTRxPDSGVFx/7n1jPzU6oQmCqxTwqH4CAdS57P8Zy+VtielOi6p5kFODhSlBgVpkpR47FQgrGUecAICV48JTkwkA35BlN1t38QetxehKdQC4Ch0vpNbQgHFmCIpUlKobMbMq+4ugeFSVlS1E4KpUS+dFdCxMwMjUvAmeYXd4iBgbmkyPKYKSEsAExAVe22BjCn76cijCMjI7RbJLO2MJjVww4M1Npq7lz4cYWl2cQU/dKwleZ/FxJLCw/g2VT8FFzk1HbNrg1D2Fhs+dmIotK3achFCmTxBTRSU7CmAkfzK/QkfKscJcqiV4k3wRb06Bz+nWDunK9gaUdiTRKylSjMvFm/sda3lAB7CwdKVh7nc4jemxapxunwEL6XDLVigl2YxsC0"
`endif