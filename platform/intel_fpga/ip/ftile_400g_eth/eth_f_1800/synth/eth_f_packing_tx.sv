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

module eth_f_packing_tx #(
    parameter DWIDTH        = 64,
    parameter NUM_SEG       = 4,
    parameter SIM_EMULATE   = 0
) (
    input   logic                       i_clk,
    input   logic                       i_reset,
    input   logic                       i_clr_stats,
    output  logic   [5:0]               o_max_fifo_level,
    output  logic   [5:0]               o_min_fifo_level,
    output  logic   [3:0]               o_fifo_empty_cnt,

    input   wire    [NUM_SEG-1:0][DWIDTH-1:0]   i_data,
    input   logic   [NUM_SEG-1:0]               i_inframe,
    input   logic   [NUM_SEG-1:0]               i_error,
    input   wire    [NUM_SEG-1:0][2:0]          i_empty,
    input   logic                               i_valid,
    input   logic   [NUM_SEG-1:0]               i_skip_crc,
    output  logic                               o_ready,

    output  logic   [NUM_SEG-1:0][DWIDTH-1:0]   o_data,
    output  logic   [NUM_SEG-1:0]               o_inframe,
    output  logic   [NUM_SEG-1:0]               o_error,
    output  logic   [NUM_SEG-1:0][2:0]          o_empty,
    output  logic                               o_valid,
    output  logic   [NUM_SEG-1:0]               o_skip_crc,
    input   logic                               i_ready

);

    genvar i;
    localparam  BWIDTH = 1+1+1+3+DWIDTH; // if, error, crc, empty, data
    localparam  SEG_WIDTH = $clog2(NUM_SEG);
    localparam  PWIDTH = 6; //FIFO Address width 
    localparam  FIFO_LO_THRSH_VAL = 6'h14; 
    // rev1: HSD-16016891928: reducing threshold from 20 to 12 to have more room to accomodate incoming packets when o_ready is low
    // rev2: increasing threshold to 6'h14 as sometimes during packing, the FIFO level drops and hence threshold needs to be high enough to prevent underflow
    //       increase fifo depth to 64 with increased threshold to prevent FIFO overflow when i_ready is low for multiple cycles together
    //       note that fifo level may drop due to high packing or fill up due to i_ready going low for multiple cycles and hence thresh needs to be in mid-range
    //       during overflow, fifo level was going upto 6'h20 (maybe go higher based on i_ready low duration)

    logic                               reset_str;
    logic                               reset_str_delay;

    logic   [NUM_SEG-1:0]               if_inframe;
    logic   [NUM_SEG-1:0]               if_error;
    logic   [NUM_SEG-1:0][2:0]          if_empty;
    logic   [NUM_SEG-1:0]               if_skip_crc;
    logic   [NUM_SEG-1:0][DWIDTH-1:0]   if_data;
    logic   [NUM_SEG-1:0][PWIDTH-1:0]   if_write_pointers;
    logic   [NUM_SEG-1:0][PWIDTH-1:0]   write_pointers_r2;
    logic   [NUM_SEG-1:0][PWIDTH-1:0]   write_pointers_r3;

    logic   [NUM_SEG-1:0][BWIDTH-1:0]   write_data;
    logic   [NUM_SEG-1:0][BWIDTH-1:0]   write_data_rearr;
    logic   [NUM_SEG-1:0][BWIDTH-1:0]   write_data_rotated;
    logic   [NUM_SEG-1:0][BWIDTH-1:0]   read_data;
    logic   [NUM_SEG-1:0][BWIDTH-1:0]   read_data_0, read_data_1;
    logic  [NUM_SEG-1:0][BWIDTH-1:0]  read_data_reg_0, read_data_reg_1;
    logic mux_sel_bit_read_ptr;
    logic   [NUM_SEG-1:0][BWIDTH-1:0]   read_data_reg;
    logic   [NUM_SEG-1:0]               o_inframe_int;
    logic   [NUM_SEG-1:0]               rd_inframe;

    logic                               read_data_reg_valid;
    logic                               ready_to_read;

    logic                               read_mem, read_mem_1;
    //logic   [PWIDTH-1:0]                read_pointers;    
(* dont_merge *) logic  [NUM_SEG-1:0] [PWIDTH-1:0]                read_pointers_0;

    logic                               read_offset;
    logic   [PWIDTH-1:0]                debug_write_ptr;

    logic                               if_valid;
    logic                               ready_delay;
    logic                               ready_pedge, ready_d1;

    logic   [SEG_WIDTH:0]               if_num_valid;
    logic   [SEG_WIDTH-1:0]             if_offset;

    logic   [NUM_SEG-1:0][DWIDTH-1:0]   o_data_tmp;
    logic   [NUM_SEG-1:0]               o_inframe_tmp;
    logic   [NUM_SEG-1:0]               o_error_tmp;
    logic   [NUM_SEG-1:0][2:0]          o_empty_tmp;
    logic   [NUM_SEG-1:0]               o_skip_crc_tmp;
    
    logic   [NUM_SEG-1:0][PWIDTH:0]     fifo_stat_wr;
    logic 				read_data_valid;
    logic 				wr_packing_disable;
    //logic 				 rd_stop, rd_stop_disable_timer;
    logic 				rd_stop_disable_timer;
    logic   [NUM_SEG-1:0]	        rd_stop;   
    integer                             j;
(* preserve_syn_only *) logic 	                        fifo_empty;
logic				i_clr_cntr_r1, i_clr_cntr_r2;
 
always @ (posedge i_clk) begin
    i_clr_cntr_r1 <= i_clr_stats;
    i_clr_cntr_r2 <= i_clr_cntr_r1;
end

    eth_f_reset_stretch_16 rss (
        .i_reset    (i_reset),
        .i_clk      (i_clk),
        .o_reset    (reset_str)
    );

    //Reverse segments again before packing logic
    always_ff @(posedge i_clk) 
    begin
        for(j=0;j<NUM_SEG;j=j+1)
        begin
          if_data[j]      <= i_data[NUM_SEG-1-j];
          if_inframe[j]   <= i_inframe[NUM_SEG-1-j];
          if_empty[j]     <= i_empty[NUM_SEG-1-j];
          if_error[j]     <= i_error[NUM_SEG-1-j];
          if_skip_crc[j]  <= i_skip_crc[NUM_SEG-1-j];
        end   
          if_valid        <= i_valid;
    end
    
    //Segment Re-arrangment and generate "valid seg no"
    eth_f_packing_rearr #(.DW(BWIDTH),.NUM_SEG(NUM_SEG),.SEG_WIDTH(SEG_WIDTH)) u_data_rearr
        (
        .i_clk(i_clk),
        .i_rst(reset_str),
        .i_data(write_data),
        .i_valid(if_valid),
        .i_inframe(if_inframe),
	.wr_packing_disable(wr_packing_disable),
        .o_data(write_data_rearr),  //2 cycle delay for 40G-200G; 3 cycle delay for 400G
        .o_num_valid(if_num_valid)  //same as above
        );

    //Write side Logic - Write Pointer generation
    eth_f_wptr_gen_tx100s #(.NUM_SEG(NUM_SEG),.SEG_WIDTH(SEG_WIDTH),.PWIDTH(PWIDTH)) wptr_gen_inst (
        .i_reset            (reset_str),
        .i_clk              (i_clk),
        .i_num_write        (if_num_valid),
        .o_write_pointers   (if_write_pointers), //1 cycle delay
        .offset             (if_offset) //1 cycle delay
    );

    //Rotation of data as per offset generated by wptr_gen module
    eth_f_data_rotate_8to8_tx100s #(
        .WIDTH      (BWIDTH),
        .NUM_SEG    (NUM_SEG),
		.SEG_WIDTH  (SEG_WIDTH)
    ) w_data_rotate (
        .i_clk      (i_clk),
        .i_rotate   (if_offset),
        .i_data     (write_data_rearr),
        .o_data     (write_data_rotated)  //2 cycle delay 
    );

    //matching delay of write_data_rotated
    always_ff @(posedge i_clk) begin
        write_pointers_r2   <= if_write_pointers;
        write_pointers_r3   <= write_pointers_r2; 
    end

    always_ff @(posedge i_clk) begin
        if (reset_str) begin
            wr_packing_disable   <= 1'b0;
        end else if(fifo_stat_wr[0][PWIDTH-1:0] < 5'd8) begin
	    wr_packing_disable	 <= 1'b1;
        end else if(fifo_stat_wr[0][PWIDTH-1:0] > 5'd16) begin
	    wr_packing_disable	 <= 1'b0;
	end
    end            

    always_ff @(posedge i_clk) begin
        if (reset_str) begin
            o_max_fifo_level   <= 6'd0;
        end else if(i_clr_cntr_r2) begin   
            o_max_fifo_level   <= 6'd0;
        end else if(fifo_stat_wr[0][PWIDTH-1:0] > o_max_fifo_level) begin
	    o_max_fifo_level	<= fifo_stat_wr[0][PWIDTH-1:0];
	end
    end            

    always_ff @(posedge i_clk) begin
        if (reset_str) begin
            o_min_fifo_level   <= 6'h3F;
        end else if(i_clr_cntr_r2) begin   
            o_min_fifo_level   <= 6'h3F;
        end else if(fifo_stat_wr[0][PWIDTH-1:0] < o_min_fifo_level) begin
	    o_min_fifo_level	<= fifo_stat_wr[0][PWIDTH-1:0];
	end
    end            

    always_ff @(posedge i_clk) begin
        if (reset_str) begin
            o_fifo_empty_cnt   <= 4'h0;
        end else if(i_clr_cntr_r2) begin   
            o_fifo_empty_cnt   <= 4'h0;
        end else if(fifo_empty) begin
		if(o_fifo_empty_cnt >= 4'h0F)
			o_fifo_empty_cnt <= 4'h0F;
		else
			o_fifo_empty_cnt <= o_fifo_empty_cnt + 1'd1; 
	end
    end            

    assign debug_write_ptr = write_pointers_r3[NUM_SEG-1][PWIDTH-1:0];

    //Memory - NUM_SEGx segment Memory
    //instantiating 2x MLABs with 32 depth to create depth of 64
    generate
        for (i = 0; i < NUM_SEG; i++) begin : mem_loop
            assign write_data[i] = {if_inframe[i], if_error[i], if_skip_crc[i], if_empty[i], if_data[i]};

// added read pointer for each segment to duplicate the pointer output to mem_0 and mem_1			
(* dont_merge *) eth_f_rptr_gen_tx100s #(.PWIDTH(PWIDTH)) rptr_gen_inst_0 (
        .i_reset            (reset_str),
        .i_clk              (i_clk),
        .i_read             (read_mem_1 & ~rd_stop[0]),
        .o_read_pointers    (read_pointers_0[i])
    );
	 
// duplicated for each segment
    assign fifo_stat_wr[i] = write_pointers_r3[NUM_SEG-1][PWIDTH-1:0] - read_pointers_0[i][PWIDTH-1:0];	 
    assign rd_stop[i] = 1'b0;//(fifo_stat_wr[i][PWIDTH-1:0] < (FIFO_LO_THRSH_VAL[PWIDTH-1:0]-2)) & (rd_inframe[0]==1'b0) & (o_valid == 1'b1);	 			
	
            eth_f_mlab #(
                .WIDTH      (BWIDTH),
                .ADDR_WIDTH (5),
                .SIM_EMULATE(SIM_EMULATE)
            ) mem_0 (
                .wclk       (i_clk),
                .wdata_reg  (write_data_rotated[i]),
                .wena       (1'b1 & ~write_pointers_r3[i][5]),
                .waddr_reg  (write_pointers_r3[i][4:0]),
                .raddr      (read_pointers_0[i][4:0]),
                .rdata      (read_data_0[i])
            );

            eth_f_mlab #(
                .WIDTH      (BWIDTH),
                .ADDR_WIDTH (5),
                .SIM_EMULATE(SIM_EMULATE)
            ) mem_1 (
                .wclk       (i_clk),
                .wdata_reg  (write_data_rotated[i]),
                .wena       (1'b1 & write_pointers_r3[i][5]),
                .waddr_reg  (write_pointers_r3[i][4:0]),
                .raddr      (read_pointers_0[i][4:0]),
                .rdata      (read_data_1[i])
            );

        end

        for (i = 0; i < NUM_SEG; i++) begin : o_data_loop
            assign rd_inframe[i] = mux_sel_bit_read_ptr ? read_data_reg_1[i][BWIDTH-1] : read_data_reg_0[i][BWIDTH-1]; 
            assign {o_inframe_int[i], o_error_tmp[i], o_skip_crc_tmp[i], o_empty_tmp[i], o_data_tmp[i]} = read_data_reg[i];
	     // considered read_data_valid to get the correct o_inframe at the output
            assign o_inframe_tmp[i] = read_data_valid ? o_inframe_int[i] : 1'b0; // Mask inframe bits when !o_valid to prevent reset issues
        end
    endgenerate

    always_ff @(posedge i_clk) begin
	if (rd_stop[0] == 1'b0) begin
        	read_data_reg_0       <= read_data_0;
        	read_data_reg_1       <= read_data_1;
		mux_sel_bit_read_ptr  <= read_pointers_0[0][5];
	end
    end

    assign read_data = (mux_sel_bit_read_ptr)? read_data_reg_1 : read_data_reg_0;
    
    //assign fifo_stat_wr = write_pointers_r3[NUM_SEG-1][PWIDTH-1:0] - read_pointers_0[0][PWIDTH-1:0];
    assign fifo_empty = (write_pointers_r3[NUM_SEG-1][PWIDTH-1:0] == read_pointers_0[0][PWIDTH-1:0]);
	
    assign read_data_reg       = read_data;

    always_ff @(posedge i_clk) begin
        if (reset_str) begin
            ready_to_read   <= 1'b0;
        end else if(fifo_empty) begin
				    ready_to_read	 <= 1'b0;
        end else begin
            ready_to_read   <= ready_to_read | (fifo_stat_wr[0][PWIDTH-1:0] >= FIFO_LO_THRSH_VAL);
        end            

        read_mem <= (i_ready && ready_to_read) | ready_pedge; //added ready_pedge to initiate read imm after i_ready goes high

	// since rd_stop is dealyed by 1 clock cycle so delayed read_mem by 1 clock cycle
	read_mem_1 <= read_mem;

	read_data_valid         <= read_mem_1 & ~rd_stop[0];
        read_data_reg_valid     <= read_data_valid;

        ready_d1 <= i_ready;
     end
	assign ready_pedge = ~ready_d1 & i_ready;

    //stop read whenever there is a idle oppurtunity along with low threshold condition
    //Last bit of inframe indicates end of packet in the current cycle. This gives 
    //oppurtunity to insert idles in between packets
//  assign rd_stop = (fifo_stat_wr[PWIDTH-1:0] < (FIFO_LO_THRSH_VAL[PWIDTH-1:0]-2)) & (rd_inframe[0]==1'b0);

//(* dont_merge *) eth_f_rptr_gen_tx100s #(.PWIDTH(PWIDTH)) rptr_gen_inst_0 (
//        .i_reset            (reset_str),
//        .i_clk              (i_clk),
//        .i_read             (read_mem & ~rd_stop),
//        .o_read_pointers    (read_pointers_0)
//    );
	 
    always_ff @(posedge i_clk) begin
        if (reset_str)
            o_ready <= 1'b0;
        else
            o_ready <= i_ready | (fifo_stat_wr[0][PWIDTH-1:0] < (FIFO_LO_THRSH_VAL+2));
    end

    eth_f_delay_reg #(
        .CYCLES (3),
        .WIDTH  (1)
    ) valid_out_delay (
        .clk    (i_clk),
        .din    (i_ready),
        .dout   (o_valid)
    );

    //Reverse segments again before final output
    always_comb begin
      for(int k=0;k<NUM_SEG;k=k+1)
      begin
          o_data[k]      = o_data_tmp[NUM_SEG-1-k];
          o_inframe[k]   = o_inframe_tmp[NUM_SEG-1-k];
          o_empty[k]     = o_empty_tmp[NUM_SEG-1-k];
          o_skip_crc[k]  = o_skip_crc_tmp[NUM_SEG-1-k];
          o_error[k]     = o_error_tmp[NUM_SEG-1-k];
      end
    end

endmodule

module eth_f_reset_stretch_16 (
    input   logic   i_reset,
    input   logic   i_clk,
    output  logic   o_reset
);
    logic   [3:0]   timer;

    always_ff @(posedge i_clk) begin
        if (i_reset) begin
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

module eth_f_rptr_gen_tx100s #(parameter PWIDTH=5) (
    input   logic               i_reset,
    input   logic               i_clk,
    input   logic               i_read,
    output  logic [PWIDTH-1:0]  o_read_pointers
);
(* preserve_syn_only *) logic   [PWIDTH-1:0]  phase;

    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            phase    <= {PWIDTH{1'b0}};
        end else begin
            if (i_read) begin
                phase    <= phase + PWIDTH'(1);
            end
        end
    end

    assign o_read_pointers = phase[PWIDTH-1:0];
endmodule

module eth_f_data_rotate_8to8_tx100s #(
    parameter WIDTH = 8,
    parameter NUM_SEG = 4,
    parameter SEG_WIDTH = 2
) (
    input   logic                               i_clk,
    input   logic   [SEG_WIDTH-1:0]             i_rotate,
    input   wire    [NUM_SEG-1:0][WIDTH-1:0]    i_data,
    output  logic   [NUM_SEG-1:0][WIDTH-1:0]    o_data
);

    logic   [NUM_SEG-1:0][WIDTH-1:0]    o_data_reg;

    generate 
    if(NUM_SEG==2) begin
        always_ff @(posedge i_clk) begin
            case (i_rotate)
                1'd0 : o_data_reg   <= i_data;
                1'd1 : o_data_reg   <= {i_data[0],   i_data[1]};
            endcase
            o_data <= o_data_reg;
        end
    end
    else if(NUM_SEG==4) begin
        always_ff @(posedge i_clk) begin
            case (i_rotate)
                2'd0 : o_data_reg   <= i_data;
                2'd1 : o_data_reg   <= {i_data[0],   i_data[3:1]};
                2'd2 : o_data_reg   <= {i_data[1:0], i_data[3:2]};
                2'd3 : o_data_reg   <= {i_data[2:0], i_data[3]};
            endcase
            o_data <= o_data_reg;
        end
    end
    else if(NUM_SEG==8) begin
        always_ff @(posedge i_clk) begin
            case (i_rotate)
                3'd0 : o_data_reg   <= i_data;
                3'd1 : o_data_reg   <= {i_data[0],   i_data[7:1]};
                3'd2 : o_data_reg   <= {i_data[1:0], i_data[7:2]};
                3'd3 : o_data_reg   <= {i_data[2:0], i_data[7:3]};
                3'd4 : o_data_reg   <= {i_data[3:0], i_data[7:4]};
                3'd5 : o_data_reg   <= {i_data[4:0], i_data[7:5]};
                3'd6 : o_data_reg   <= {i_data[5:0], i_data[7:6]};
                3'd7 : o_data_reg   <= {i_data[6:0], i_data[7]};
            endcase
            o_data <= o_data_reg;
        end
    end
    else if(NUM_SEG==16) begin
        always_ff @(posedge i_clk) begin
            case (i_rotate)
                4'd0  : o_data_reg   <= i_data;
                4'd1  : o_data_reg   <= {i_data[0],    i_data[15:1]};
                4'd2  : o_data_reg   <= {i_data[1:0],  i_data[15:2]};
                4'd3  : o_data_reg   <= {i_data[2:0],  i_data[15:3]};
                4'd4  : o_data_reg   <= {i_data[3:0],  i_data[15:4]};
                4'd5  : o_data_reg   <= {i_data[4:0],  i_data[15:5]};
                4'd6  : o_data_reg   <= {i_data[5:0],  i_data[15:6]};
                4'd7  : o_data_reg   <= {i_data[6:0],  i_data[15:7]};
                4'd8  : o_data_reg   <= {i_data[7:0],  i_data[15:8]};
                4'd9  : o_data_reg   <= {i_data[8:0],  i_data[15:9]};
                4'd10 : o_data_reg   <= {i_data[9:0],  i_data[15:10]};
                4'd11 : o_data_reg   <= {i_data[10:0], i_data[15:11]};
                4'd12 : o_data_reg   <= {i_data[11:0], i_data[15:12]};
                4'd13 : o_data_reg   <= {i_data[12:0], i_data[15:13]};
                4'd14 : o_data_reg   <= {i_data[13:0], i_data[15:14]};
                4'd15 : o_data_reg   <= {i_data[14:0], i_data[15]};
            endcase
            o_data <= o_data_reg;
        end
    end
   
    endgenerate
endmodule

module eth_f_wptr_gen_tx100s #(parameter NUM_SEG=4, parameter SEG_WIDTH=2, parameter PWIDTH=6) (
    input   logic                       i_reset,
    input   logic                       i_clk,
    input   logic [SEG_WIDTH:0]         i_num_write,
    output  logic [NUM_SEG-1:0][PWIDTH-1:0] o_write_pointers,
    output  logic [SEG_WIDTH-1:0]       offset
);

    logic   [NUM_SEG-1:0][9:0]  phase;
    genvar i;
    generate
        for (i = 0; i < NUM_SEG; i++) begin: phase_loop
            always_ff @(posedge i_clk) begin
                if (i_reset) begin
                    phase[i]    <= i[9:0];
                end else begin
                    phase[i]    <= 10'(phase[i] + i_num_write);
                end
            end
            assign o_write_pointers[i] = phase[i][SEG_WIDTH+PWIDTH-1:SEG_WIDTH];
        end
    endgenerate

    assign offset           = phase[0][SEG_WIDTH-1:0];
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q477vayrXvlxBBdWrTAEI3IgQjhgC9VX8ickJZcHZ1rys7NC3WpJB54JS0+uaNq/H6vHDvtdxRLp8tBNXlfsrwe5LMn/Wl8r2ATlP7gfjfoHcoqFmmX8hbMgzSDCEEKZNOzr+j9jE7PzO/aAgpKfZOHQPy+gewgoGib96GBi+8sh5H2vibgtX4kGyqKsoCKaJra05MMXtFOoJlUoRsNF6wczqOa3Os3reRZaZZ9xTTL7EecXvEUAtlEiBSYqP1lbD4kHMHI+JtqTGvdRoXtxmEG6d84kZSuqvB3d7I8IiVF4TgZtbWSiY5GkeDUa2tKrde5xo/NADF8vhIIeI5OTalziBUHYRIvrdrsvevPAEfvNYhSLppNBfFIOy0otzptrSB4TykI17QTShvb60qb0D6XxsSjc81danvrJ/gFdBgAw904uxxWKQ0oQezQ9d9BmOUBt9SbHr96AFTpFuwdit+6xkRO2H0gxR16pdvyJV3ZtHd/QX2BocnFOmytqPkvTJbHD/qm6bx4svQVPVH0E8/MN8SWtUVBEO4CnB8eL9lu+zMBnr61XtgoW2AdUGJs5QNiHc7gIsEdy34lwj6Y40RP5lbrCy7dvna1UE8msCQtGnOM6ulK6hz0HtoiMzlMVOxrsdAuB28fbZFoYtru7GzxhqWwYUfqqGhRez1oAUHZCg0TiE4oMDTqVPL5ezheJL9c7orwOQ2+3vO4DWJZUGrfxieHIHqDjKtzRe9MZA3dUk2w1dbwB/7mSPWy6Vs40N4Ay8Or3YiQGohuMjxKZTMYb"
`endif