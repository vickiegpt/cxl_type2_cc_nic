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


module eth_f_pause #(
    parameter DWIDTH        = 64,
    parameter NUM_SEG       = 8,
    parameter AIB_LANES	    =16,
    parameter EHIP_RATE     = 5,
    parameter SIM_EMULATE   = 0
) (
    input   logic                       	i_clk,
    input   logic                       	i_reset,
 
    input   logic   [AIB_LANES-1:0][DWIDTH-1:0]   i_data,
    input   logic   [AIB_LANES-1:0]               i_inframe,
    input   logic   [AIB_LANES-1:0]               i_error,
    input   logic   [AIB_LANES-1:0][2:0]          i_empty,
    input   logic                                 i_valid,
    input   logic   [AIB_LANES-1:0]               i_skip_crc,
    output  logic                                 o_ready_sip,
	 
    input   logic                                 i_qvalid,
    input   logic    [15:0]              	  i_quanta,
    output   logic                    		  o_rx_pause,
    input   logic                                 tx_flow_control, //YES - 1, NO - 0
    input   logic                                 enable_sfc,                     
 
    output  logic   [AIB_LANES-1:0][DWIDTH-1:0]   o_data,
    output  logic   [AIB_LANES-1:0]               o_inframe,
    output  logic   [AIB_LANES-1:0]               o_error,
    output  logic   [AIB_LANES-1:0][2:0]          o_empty,
    output  logic                                 o_valid,
    output  logic   [AIB_LANES-1:0]               o_skip_crc,
    input   logic                                 i_ready
 
);
 
    genvar i;
    localparam  BWIDTH 		= 1+1+1+3+DWIDTH; // if, error, crc, empty, data
    localparam  SEG_WIDTH 	= $clog2(AIB_LANES);
    localparam  PWIDTH 		= 5; //FIFO Address width 
    //localparam  FIFO_LO_THRSH_VAL = 5'h14; //dec 15
    localparam  FIFO_LO_THRSH_VAL = 5'hE; //dec 15

    logic                               reset_str;
 
    logic   [AIB_LANES-1:0]             if_inframe;
    logic   [AIB_LANES-1:0]             if_error;
    logic   [AIB_LANES-1:0][2:0]        if_empty;
    logic   [AIB_LANES-1:0]             if_skip_crc;
    logic   [AIB_LANES-1:0][DWIDTH-1:0] if_data;
    logic   [AIB_LANES-1:0][PWIDTH-1:0] if_write_pointers; 
    logic   [PWIDTH:0]                  fifo_stat_wr; 
    logic   [PWIDTH:0]                  fifo_stat_rd; 
 
    logic   [AIB_LANES-1:0][BWIDTH-1:0]   			write_data;
    logic   [AIB_LANES-1:0][BWIDTH-1:0]   			read_data;
    (* dont_merge *) logic   [AIB_LANES-1:0][BWIDTH-1:0]   	read_data_reg;
    (* dont_merge *) logic   [AIB_LANES-1:0][BWIDTH-1:0]   	read_data_reg_d2;
    logic   [AIB_LANES-1:0]               			o_inframe_int;
    logic   [AIB_LANES-1:0]               			o_inframe_int_tmp;
    logic   [AIB_LANES-1:0]               			o_inframe_int_d2;
    logic   [AIB_LANES-1:0]               			o_inframe_int_d2_tmp;
    logic   [AIB_LANES-1:0]               			inframe_mask_d2;
    logic   [AIB_LANES-1:0]               			rd_sop_d1;
    logic   [AIB_LANES-1:0]               			rd_eop_d1;
	 
    logic   [AIB_LANES-1:0][DWIDTH-1:0]   			o_data_tmp;
    logic   [AIB_LANES-1:0]               			o_error_tmp;
    logic   [AIB_LANES-1:0][2:0]          			o_empty_tmp;
    logic   [AIB_LANES-1:0]               			o_skip_crc_tmp;
    logic   [AIB_LANES-1:0][DWIDTH-1:0]   			o_data_tmp_d2;
    logic   [AIB_LANES-1:0]               			o_error_tmp_d2;
    logic   [AIB_LANES-1:0][2:0]          			o_empty_tmp_d2;
    logic   [AIB_LANES-1:0]               			o_skip_crc_tmp_d2;
    logic           						if_valid;
    logic                     					read_mem, read_mem_d1;
    logic                      					read_mem_t, read_mem_t_d1;
    logic                                               	read_back_d1;
    logic                                               	read_back_d2;
    logic                                               	read_back_d3;
    logic   [AIB_LANES-1:0] [PWIDTH-1:0]   			read_pointers;
   (* dont_merge *)  logic                  			rd_stop_d1;
    logic                                               	rd_idle_d1;
  	 
	 /////Quanta counter
    logic [19:0] 						quanta_count;
    logic 							quanta_in_prog;
    logic 							tx_rd_paused;
    logic 							tx_rd_paused_d1;
    logic 							tx_rd_paused_d2;
    logic 							tx_rd_paused_neg_edge;
    logic 							tx_rd_paused_neg_edge_d1;
    logic 							tx_rd_paused_neg_edge_d2;
    logic 							quanta_done;
    logic                          	rd_flag;
    logic                          	rd_flag_d1, rd_flag_d2;
    logic 							enable_sfc_sync;

 	logic [19:0] 						quanta_value;
	logic [19:0] 						quanta_r;
	logic 							qvalid_r;
	logic 							XON_rcvd;
        logic XOFF_rcvd ;

    logic                                 qvalid_sync;
    logic    [15:0]              	  quanta_sync;


(* dont_merge *)  logic  wr_full_latch;
(* dont_merge *)  logic  rd_empty_latch;
logic tx_flow_control_sync;
logic i_ready_r3;
logic o_ready_gate;

//*****************************************************************************************************************************
 
    eth_f_reset_str_16 rss (
        .i_reset    (i_reset),
        .i_clk      (i_clk),
        .o_reset    (reset_str)
    );

assign quanta_value = (EHIP_RATE == 0)  ?  (quanta_sync << 3)  : 
                      (EHIP_RATE == 1)  ?  (quanta_sync << 3)  : 
                      (EHIP_RATE == 2)  ?  (quanta_sync << 1)  : 
                      (EHIP_RATE == 3)  ?  (quanta_sync << 2)  : 
                      (EHIP_RATE == 4)  ?  (quanta_sync << 1)  : 
                      {4'b000,quanta_sync}  ;


eth_f_xcvr_resync_std #(
           .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0) 
       ) sync_tx_flow_control (
           .clk    (i_clk),
           .reset  (1'b0),
           .d  (tx_flow_control),
           .q  (tx_flow_control_sync)
       );

 eth_f_xcvr_resync_std #(
           .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0) 
       ) sync_enable_sfc (
           .clk    (i_clk),
           .reset  (1'b0),
           .d  (enable_sfc),
           .q  (enable_sfc_sync)
       );

assign quanta_sync = i_quanta;
assign qvalid_sync = i_qvalid;

////registering input quanta
 always_ff @(posedge i_clk) begin
	 if (reset_str ) begin
                qvalid_r    <= 1'b0;
                quanta_r    <= {20{1'b0}};
	 end else begin
	        qvalid_r    <= qvalid_sync;
                quanta_r    <= quanta_value;
	 end 
end	 
	
 ////Quanta counter
 always_ff @(posedge i_clk) begin
	 if (reset_str ) begin
		  quanta_count    <= {20{1'b0}};
	 end else if(~enable_sfc_sync) begin
		  quanta_count   <= {20{1'b0}};
	 end else if(qvalid_r) begin
		  quanta_count   <= quanta_r;
	 end else if (quanta_done) begin  //XON or Cntr expires
		  quanta_count    <= {20{1'b0}};
	 end else if((tx_rd_paused || ~tx_flow_control_sync)  && i_ready) begin
		if(quanta_count == 20'd0)
		  quanta_count <= {20{1'b0}};
		else
	 	  quanta_count   <= quanta_count - 1'b1;
	 end
end

//////quanta done - cleared when non zero quanta value is got
 always_ff @(posedge i_clk) begin
	 if ( reset_str==1'b1  ) begin
		  quanta_done    <= 1'b1;
	 end else if(qvalid_r == 1'b1) begin
                  quanta_done <= (quanta_r == 'd0) ? 1'b1 : 1'b0; //XON/XOFF condition
	 end else if(quanta_count == 20'd0)begin
		  quanta_done   <= 1'b1;
         end else begin
                  quanta_done   <= 1'b0;
	 end 
end 

//geneated w.r.t mac ready but not packet boundaries
always_ff @(posedge i_clk) begin
	 if (reset_str == 1'b1 )
		  quanta_in_prog    <= 1'b0;
	 else if(i_ready)
		  quanta_in_prog   <= (quanta_count == 20'd0) ? 1'b0 : 1'b1;
end 

//geneated w.r.t mac ready and packet boundaries
////quanta in progress, asserted when the packet in flight is completed and EOP is detected.
 always_ff @(posedge i_clk) begin
	 if (reset_str==1'b1) 
		  tx_rd_paused    <= 1'b0;
	 else if((i_ready && ~quanta_in_prog) || (i_ready && ~tx_flow_control_sync))
		  tx_rd_paused   <= 1'b0;
	 else if(rd_stop_d1 && quanta_in_prog && tx_flow_control_sync) //rd_stop_d1 1 cycle delay is adjusted by moving read pointers back
		  tx_rd_paused   <= 1'b1;
end 

////rx pause
always_ff @(posedge i_clk) begin
	 if (reset_str==1'b1 || enable_sfc_sync==1'b0  ) begin 
		  o_rx_pause    <= 1'b0;
	 end else if (XOFF_rcvd == 1'b1) begin
		  o_rx_pause   <= 1'b1;
	 end else if ((quanta_count == 'd0) && i_ready) begin 
		  o_rx_pause   <= 1'b0;
	 end
end

always_ff @(posedge i_clk) begin
	 if (reset_str==1'b1  ) begin
                XON_rcvd    <= 1'b0;
	        XOFF_rcvd   <= 1'b0; 
	end else begin 
                XON_rcvd    <= (quanta_value==20'd0) ? qvalid_sync : 1'b0;   
                XOFF_rcvd   <= (quanta_value!=20'd0) ? qvalid_sync : 1'b0;  
        end
end
 
    //Registering the inputs
    always_ff @(posedge i_clk) 
    begin
        if (reset_str==1'b1 ) begin
            if_data         <= '0;
            if_inframe      <= '0;
            if_empty        <= '0;
            if_error        <= '0;
            if_skip_crc     <= '0;
            if_valid        <= '0;
        end else begin
          for(int j=0;j<AIB_LANES;j=j+1)
          begin
            if_data[j]      <= i_data[j];
            if_inframe[j]   <= i_inframe[j];
            if_empty[j]     <= i_empty[j];
            if_error[j]     <= i_error[j];
            if_skip_crc[j]  <= i_skip_crc[j];
          end   
          if_valid        <= i_valid;
        end
    end

 
    //Write side Logic - Write Pointer generation
    
 
    //Memory - NUM_SEGx segment Memory
    
    generate
        for (i = 0; i < AIB_LANES; i++) begin : mem_loop
            assign write_data[i] = {if_inframe[i], if_error[i], if_skip_crc[i], if_empty[i], if_data[i]};
 
            eth_f_mlab #(
                .WIDTH      (BWIDTH),
                .ADDR_WIDTH (5),
                .SIM_EMULATE(SIM_EMULATE)
            ) mem_0 (
                .wclk       (i_clk),
                .wdata_reg  (write_data[i]),
                .wena       (if_valid),
                .waddr_reg  (if_write_pointers[i][4:0]),
                .raddr      (read_pointers[i][4:0]),
                .rdata      (read_data[i])
            );

            eth_f_wptr_gen_pause #(.PWIDTH(PWIDTH)) wptr_gen_inst (
              .i_reset            (reset_str),
              .i_clk              (i_clk),
              .i_num_write        (if_valid),
              .o_write_pointers   (if_write_pointers[i][4:0]) //1 cycle delay

            );

            eth_f_rptr_gen_pause #(.PWIDTH(PWIDTH)) rptr_gen_inst (
              .i_reset            (reset_str),
              .i_clk              (i_clk),
              .i_read             (read_mem && read_mem_t),
              .i_re_read          (read_back_d1),
              .o_read_pointers    (read_pointers[i][4:0])
            );

            always_ff @(posedge i_clk) begin
              if (reset_str==1'b1) begin
                read_data_reg[i]    <= 'd0;
                read_data_reg_d2[i]    <= 'd0;
              end else  begin
                read_data_reg[i] <= read_data[i];
                read_data_reg_d2[i] <= read_data_reg[i];
              end
            end
        assign {o_inframe_int_tmp[i], o_error_tmp[i], o_skip_crc_tmp[i], o_empty_tmp[i], o_data_tmp[i]} = read_data_reg[i];
        assign o_inframe_int[i] = rd_flag_d1 ? o_inframe_int_tmp[i]: 'h0;
        assign {o_inframe_int_d2_tmp[i], o_error_tmp_d2[i], o_skip_crc_tmp_d2[i], o_empty_tmp_d2[i], o_data_tmp_d2[i]} = read_data_reg_d2[i];
        assign o_inframe_int_d2[i] = rd_flag_d2 ? o_inframe_int_d2_tmp[i]: 'h0;
 end
 endgenerate
//**********************************************************************************************

assign fifo_stat_wr = if_write_pointers[0][PWIDTH-1:0] - read_pointers[0][PWIDTH-1:0];
assign fifo_stat_rd = read_pointers[0][PWIDTH-1:0] - if_write_pointers[0][PWIDTH-1:0];

wire [PWIDTH-1:0] fifo_stat_wr_tmp = fifo_stat_wr[PWIDTH-1:0];
wire [PWIDTH-1:0] fifo_stat_rd_tmp = fifo_stat_rd[PWIDTH-1:0];

always_ff @(posedge i_clk) begin
  if (reset_str==1'b1 ) begin
    rd_flag    <= 1'b0;
  end else if(fifo_stat_rd[PWIDTH-1:0] == 'd0) begin //empty
    rd_flag    <= 1'b0;
  end else if(fifo_stat_wr[PWIDTH-1:0] >= 'd10) begin
    rd_flag <= 1'b1;
  end
end

always_ff @(posedge i_clk) begin
  if (reset_str==1'b1 ) begin
    rd_flag_d1 <= 1'b0;
    rd_flag_d2 <= 1'b0;
  end else begin
    rd_flag_d1 <= rd_flag;
    rd_flag_d2 <= rd_flag_d1;
  end
end


eth_f_delay_reg #(
        .CYCLES (1),
        .WIDTH  (1)
    ) i_ready2_delay (
        .clk    (i_clk),
        .din    (i_ready && rd_flag),
        .dout   (read_mem)
    );	 

eth_f_delay_reg #(
        .CYCLES (3),
        .WIDTH  (1)
    ) i_ready3_delay (
        .clk    (i_clk),
        .din    (i_ready),
        .dout   (i_ready_r3)
    );	
		 
eth_f_sop_eop_detection # (
    .INFRAME (AIB_LANES)
) sop_detect (
   .rx_mac_inframe  (o_inframe_int),
   .clk_i           (i_clk),
   .srst_n_i        (~i_reset),
   .rx_mac_valid    (read_mem_d1 && ~tx_rd_paused_d1),
   .SOP_detected    (rd_sop_d1),
   .EOP_detected    (rd_eop_d1)
 ); 
 
assign rd_idle_d1    = ((o_inframe_int == 'd0) && read_mem_d1 && ~tx_rd_paused_d1) ? 1'b1 : 1'b0;
assign rd_stop_d1    = ((|rd_eop_d1==1'b1) || rd_idle_d1) && ~tx_rd_paused_neg_edge_d1; //cycle is empty or has rd_eop in the cycle 
assign read_mem_t    = ~tx_rd_paused;
assign read_back_d1  = read_mem_d1 && rd_stop_d1 && quanta_in_prog && tx_flow_control_sync && ~tx_rd_paused; //raising edge of the tx_rd_paused adv 
assign tx_rd_paused_neg_edge = ~tx_rd_paused && tx_rd_paused_d1;

    always_ff @(posedge i_clk) begin
        if (reset_str) begin
            read_back_d2                <= 1'b0;
            read_back_d3                <= 1'b0;

            tx_rd_paused_d1             <= 1'b0;
            tx_rd_paused_d2             <= 1'b0;

            read_mem_d1                 <= 1'b0;
            read_mem_t_d1               <= 1'b0;

            tx_rd_paused_neg_edge_d1    <= 1'b0;
            tx_rd_paused_neg_edge_d2    <= 1'b0;
        end else begin
            read_back_d2                <= read_back_d1;
            read_back_d3                <= read_back_d2;

            tx_rd_paused_d1             <= tx_rd_paused;
            tx_rd_paused_d2             <= tx_rd_paused_d1;

            read_mem_d1                 <= read_mem;
            read_mem_t_d1               <= read_mem_t;

            tx_rd_paused_neg_edge_d1    <= tx_rd_paused_neg_edge;
            tx_rd_paused_neg_edge_d2    <= tx_rd_paused_neg_edge_d1;
        end
    end

//****************************************************************************

	eth_f_eop_inframe_mapper #(
			.NUM_SEG      (AIB_LANES)
			) eopmap_0 (
				.i_reset      	(reset_str),
				.i_clk  	(i_clk),
				.i_valid        (read_mem_d1 && read_mem_t_d1),
				.inframe_i      (o_inframe_int),
				.inframe_mask_o (inframe_mask_d2)
				);	

// read_pointers, read_mem, rd_flag_d1, read_data are aligned
        always_ff @(posedge i_clk)
        begin
            if (reset_str==1'b1 )
                o_inframe <= 'd0;
            else if(tx_rd_paused_neg_edge_d2)  //with read_mem_d1
                o_inframe <= o_inframe_int_d2 & ~inframe_mask_d2; //sending the remaing bytes of pause cycle
            else if(read_back_d3)  // one clock after the pos_edge of read pause //dummy cycle (setting address to previous cycle) // no need of ready 
                o_inframe <= 'd0;
            else if(read_back_d2)  //raising edge of the read pause //with read_mem_d1 
                o_inframe <= o_inframe_int_d2 & inframe_mask_d2;  //sending the current packet only
            else if(tx_rd_paused_d2)
                o_inframe <= 'd0;
            else
                o_inframe <= o_inframe_int_d2;
        end

	always_ff @(posedge i_clk) begin
	if (reset_str==1'b1 ) begin
		o_data         <= '0;
		o_empty        <= '0;
		o_error        <= '0;
		o_skip_crc     <= '0;
		o_valid        <= '0;
	end else begin
		o_data       <= o_data_tmp_d2 ;
		o_empty      <= o_empty_tmp_d2 ;
		o_skip_crc   <= o_skip_crc_tmp_d2 ;
		o_error      <= o_error_tmp_d2 ;
		o_valid      <= i_ready_r3;
	end 
	end

          always_ff @(posedge i_clk) begin
            if (reset_str==1'b1 ) begin
              rd_empty_latch <= 1'b0;
            end else if (rd_flag && (fifo_stat_rd[PWIDTH-1:0] == 'h0))  begin
              rd_empty_latch  <= 1'b1;
            end
          end

          always_ff @(posedge i_clk) begin
            if (reset_str==1'b1 ) begin
              wr_full_latch <= 1'b0;
            end else if (fifo_stat_wr[PWIDTH-1:0] == 'h30)  begin
              wr_full_latch <= 1'b1;
            end
          end

    always_ff @(posedge i_clk) begin
        if (reset_str==1'b1 )
            o_ready_gate <= 1'b0;
        else if(i_ready)
            o_ready_gate <= 1'b1; //waiting for the 1st MAC ready
    end
 

      always_ff @(posedge i_clk) begin
          if (reset_str==1'b1 )
              o_ready_sip <= 1'b0;
          else if(fifo_stat_wr[PWIDTH-1:0] >= FIFO_LO_THRSH_VAL) //to make ready low when paused
              o_ready_sip <= 1'b0;
          else
              o_ready_sip <= i_ready; 
              //o_ready_sip <= o_ready_gate && ((fifo_stat_wr[PWIDTH-1:0] < FIFO_LO_THRSH_VAL) || i_ready); 
      end
	 
 
endmodule
 
//*********************************************************************************************************
//*********************************************************************************************************
module eth_f_reset_str_16 (
    input   logic   i_reset,
    input   logic   i_clk,
    output  logic   o_reset
);
    logic   [3:0]   timer;
 
    always_ff @(posedge i_clk) begin
        if (i_reset==1'b1) begin
            timer   <= 4'hF;
            o_reset <= 1'b1;
        end else begin
            if (timer == 4'd0) begin
                timer   <= timer;
                o_reset <= 1'b0;
            end else begin
                timer   <= timer - 1'd1;
                o_reset <= 1'b1;
            end
        end
    end
endmodule
 
module eth_f_rptr_gen_pause #(parameter PWIDTH=5) (
    input   logic               i_reset,
    input   logic               i_clk,
    input   logic               i_read,
	 input   logic          i_re_read,
    output  logic [PWIDTH-1:0]  o_read_pointers
);
    logic   [PWIDTH-1:0]  phase;
 
    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            phase    <= {PWIDTH{1'b0}};
	end else if (i_re_read) begin
                phase    <= phase - PWIDTH'(1);
        end else if (i_read) begin
                phase    <= phase + PWIDTH'(1);
        end
    end
 
    assign o_read_pointers = phase[PWIDTH-1:0];
endmodule
 
 
module eth_f_wptr_gen_pause #(parameter PWIDTH=6) (
    input   logic                       i_reset,
    input   logic                       i_clk,
    input   logic 		         i_num_write,
    output  logic [PWIDTH-1:0]           o_write_pointers
);
 
logic   [PWIDTH-1:0]  phase;
 
    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            phase    <= {PWIDTH{1'b0}};
        end else begin
            if (i_num_write) begin
                phase    <= phase + PWIDTH'(1);
            end
       
        end
    end
 
    assign o_write_pointers = phase[PWIDTH-1:0];
 
endmodule

module eth_f_eop_inframe_mapper #(parameter NUM_SEG=8) (
    input   logic                     i_reset,
    input   logic                     i_clk,
    input   logic                     i_valid,
    input   logic [NUM_SEG-1:0]       inframe_i,
    output  logic [NUM_SEG-1:0]       inframe_mask_o
);
 
 //localparam NUM = (NUM_SEG==8)?4:(NUM_SEG==4)?2:(NUM_SEG==2)?1:0;

	 integer j;
		 

generate 
	 if(NUM_SEG==1) begin
	 	always @(posedge i_clk) begin
	 		inframe_mask_o   <= 1'b1; 
	 	end
	end else if(NUM_SEG==2) begin
		always @(posedge i_clk) begin
		if (inframe_i[0] == 1'b0)
			inframe_mask_o <= 2'b01;
		else 
			inframe_mask_o <= 2'b11;
		end
	end else if(NUM_SEG==4) begin
		always @(posedge i_clk) begin
		if (inframe_i[0] == 1'b0)
			inframe_mask_o <= 4'b0001;
		else if (inframe_i[1] == 1'b0)
			inframe_mask_o <= 4'b0011;
		else if (inframe_i[2] == 1'b0)
			inframe_mask_o <= 4'b0111;
		else  
			inframe_mask_o <= 4'b1111;
		end
	end else if(NUM_SEG==8) begin
		always @(posedge i_clk) begin
		if (inframe_i[0] == 1'b0)
			inframe_mask_o <= 8'b00000001;
		else if (inframe_i[1] == 1'b0)
			inframe_mask_o <= 8'b00000011;
		else if (inframe_i[2] == 1'b0)
			inframe_mask_o <= 8'b00000111;
		else if (inframe_i[3] == 1'b0)
			inframe_mask_o <= 8'b00001111;
		else if (inframe_i[4] == 1'b0)
			inframe_mask_o <= 8'b00011111;
		else if (inframe_i[5] == 1'b0)
			inframe_mask_o <= 8'b00111111;
		else if (inframe_i[6] == 1'b0)
			inframe_mask_o <= 8'b01111111;
		else  
			inframe_mask_o <= 8'b11111111;
		end
	end
endgenerate	 
	 
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "IHWHrFSUaPtjZF1LBDe+5u/fCSc0//dMeoOgG/ez60Rt84WK1OI/WsMDAOmCm2IklwNYebRgS3zVDw7MPxWxM11LRVdkLZ+X/y8WtfqnS7Duroraj/37v+2WHhkPuM7Zr5jlblPypJOlE04iTTEfu+W3Q6H2vZl2TlAJ75jp9EioCxq3Erh26V4am36iNzJ8q9nPT5rffTeZv2243MrLgLaBmit/Byil0W+B47PrapXyyID0sFy3cq7cwpO5g4WIYtSrLMRxL49JwV4pbvoXWlqNAr8EFwrGLcpeUx6yBmOBMYEaZycOTCvJZpgDy5jzC2TZiMAplz2wgGGP0eVrg8KZLLnnCtwd/IMu13xmfv1QHkIOzKhs+TWJyPtlCLG51onyn8ZFbZCAN59DhIH49To88Np+Afl/GctPNhsKmEr4He6Z/xre6KZx/DSlqTKRAxDNjJBK/c2hCxf3RJ1CNtku3glw77ff9o+aGojQBQkr3kICQbcfCgEk4NDtqfBwDwOsjrzaRSaUtSkqWFF1sWG7MmSFMj1D5i/GkzeiQRepaUYOIWNAaW3m9ImpUApWna/HblZ0xqlFfUwl/VoZ9DlubHPHvES7thSfMvwbIDAZ1XtAdu88db1RLJi3NXZpgK4D4LJHlaQ8fpDqAeFY49/qgGTkZBTPGR3AJW4nkxGo8xljJFkdjdCj/5HwGlXWoSrqFYNyZqinkSBbhpD6omGYrfCg+9hwpyiwUFHoeYMwZuG8ty+3mvfIqpST8oMy+KdGXerRSnrmRKtVgLooPEOIRecNNsl6cDR8nZaBcFjMyHeb1qI676WXJPq+Hwml0+cT6DSx2h5hC5OAikSKmHLGctt0bR20wAF2KmanQ+OC0yDUd+gn+EKMTu+VPOhauVLn1N861l5voVyvIML4N0GccRIiLLV+noIHdD1crLvR/IcjL+J8qYAF/gGDzP14Z2L2a72fXm4drkSLsw41M1KDJkeimmySyA0Ab/T6SRctoBB8z+4zIoNDYu6sTrL9"
`endif