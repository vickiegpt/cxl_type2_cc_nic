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

module eth_f_100g_50g_adapter_tx #(
    parameter EHIP_RATE 			= "100G",
	parameter ENABLE_ASYNC_ADAPTERS = 1,
    parameter INBLOCKS 		    = (EHIP_RATE == "100G") ? 8 : 2, 
    parameter OUTBLOCKS 			= (EHIP_RATE == "100G") ? 4 : 2, 
	parameter READ_LANE            = (EHIP_RATE == "100G") ? 2 : 1,
	parameter ROTATE_WIDTH_PARAM   = (EHIP_RATE == "100G") ? 4 : 1,
	parameter MLAB_ADDR_WIDTH      = (EHIP_RATE == "100G") ? 5 : 4,
	parameter WRITE_DATA_WIDTH	    = (EHIP_RATE == "100G") ? 8 : 3,
	parameter MEMBLOCKS 			= (EHIP_RATE == "100G") ? 8 : 4,
    parameter MEMDEPTH  			= (EHIP_RATE == "100G") ? 'd32 : 'd16,
    //localparam SPEED				= (ENABLE_ASYNC_ADAPTERS == 1) ? write_pointers[0][1] : 4'd5,
   	parameter NUM_WRITTEN_PRAM     = (ENABLE_ASYNC_ADAPTERS == 1) ? ((EHIP_RATE == "100G") ? 6'd41 : 6'd24) : ((EHIP_RATE == "100G") ? 6'd13 : 6'd13), //100G sync and async
	parameter DWIDTH       		    = 64,
    parameter EWIDTH               = (EHIP_RATE == "100G") ? 6 : 4,
    parameter READY_LATENCY         = 0,
	parameter SIM_EMULATE           = 0
) (
    input   logic                                   i_clk_w,
    input   logic                       	  		i_arst,
    input   logic                      			    i_clk_r,
    // Client interface
    input   logic   [0:INBLOCKS-1][DWIDTH-1:0]      i_data,
    input   logic        [EWIDTH-1:0]               i_empty,
    input   logic                                   i_error,
    input   logic                                   i_sop,
    input   logic                                   i_eop,
    input   logic                                   i_valid,
    input   logic                                   i_skip_crc,
    
    input logic [DWIDTH-1:0]                        i_preamble,
    output  logic                                   o_ready,

    output  logic   [0:OUTBLOCKS-1][DWIDTH-1:0]     o_data,
    output  logic   [0:OUTBLOCKS-1]                 o_inframe,
    output  logic   [0:OUTBLOCKS-1]                 o_error,
    output  logic   [0:OUTBLOCKS-1][2:0]            o_empty,
    output  logic                                   o_valid,
    output  logic   [0:OUTBLOCKS-1]                 o_skip_crc,
	input   logic                       		    i_ready,
		
	output  logic   [31:0]                          o_starts_in,
    output  logic   [31:0]                          o_starts_out,
    output  logic   [31:0]                          o_ends_in,
    output  logic   [31:0]                          o_ends_out,
    output  logic   [0:7]                           o_mem_underflow 
);

    genvar i;
 
    localparam  BWIDTH = 1+1+1+3+DWIDTH; // if, error, crc, empty, data
    logic                                          reset_str_delay;
    logic   [0:WRITE_DATA_WIDTH-1]                 if_inframe;
    logic   [0:WRITE_DATA_WIDTH-1]                 if_error;
    logic   [0:WRITE_DATA_WIDTH-1][2:0]            if_empty;
    logic   [0:WRITE_DATA_WIDTH-1]                 if_skip_crc;
    logic   [OUTBLOCKS-1:0]                        if_num_valid;
    logic   [OUTBLOCKS-1:0]                        num_valid_delay;
    
    logic   [0:WRITE_DATA_WIDTH-1][DWIDTH-1:0]            if_data;
    logic   [0:MEMBLOCKS-1][MLAB_ADDR_WIDTH-1:0]   if_write_pointers;
    logic   [0:MEMBLOCKS-1][MLAB_ADDR_WIDTH-1:0]   write_pointers_r2;
    logic   [0:MEMBLOCKS-1][MLAB_ADDR_WIDTH-1:0]   write_pointers_r3;
	logic   [0:MEMBLOCKS-1][MLAB_ADDR_WIDTH-1:0]   write_pointers;
    logic   [2:0]            			           if_offset;
    logic   [$clog2(MEMBLOCKS)-1:0]                        write_data_rotate;
    logic   [0:WRITE_DATA_WIDTH-1][BWIDTH-1:0]     write_data;
    logic   [0:MEMBLOCKS-1][BWIDTH-1:0]            write_data_rotated;
    logic   [0:MEMBLOCKS-1][BWIDTH-1:0]            read_data;
    logic   [0:MEMBLOCKS-1][BWIDTH-1:0]            read_data_reg;
    logic   [0:OUTBLOCKS-1][BWIDTH-1:0]            read_data_rotated;
    logic                                read_data_reg_valid;
    logic                                read_data_rotated_valid;
    logic                                ready_to_read;
	logic                                read_mem;
    logic   [0:1][MLAB_ADDR_WIDTH-1:0]   read_pointers;
    logic                                read_offset;
    logic                                read_offset_r2;
    logic                                ready_int;
    logic                                ready_delay;
    logic   [5:0]                        num_written;
    logic                                read_mem_delay;
    logic   [0:OUTBLOCKS-1]              o_inframe_int;
	logic                                ready_to_read_sync;
	logic   [5:0]                        num_read;
    logic   [5:0]                        num_read_sync;
    logic                                read_ptrs_valid;
    logic                                read_mem_valid;
    logic                                read_data_mux_valid;
	logic                                r_reset;
    logic                                w_reset;
    logic                                r_reset_str;
	
	  eth_f_reset_stretch_16a rss (
			.i_reset    (r_reset),
			.i_clk      (r_clk),
			.o_reset    (r_reset_str)
		);



generate
		if (ENABLE_ASYNC_ADAPTERS == 1 ) begin
			
			assign r_clk= i_clk_r;
			
			assign r_reset = i_arst; //i_clk_r is int_clk_tx in sip logic and i_arst is synchronized in SIP w.r.t int_clk_tx/i_clk_r	
				
			
			eth_f_altera_std_synchronizer_nocut sync_w_rst (
					.clk     (i_clk_w),
					.reset_n (1'b1),
					.din     (r_reset_str),
					.dout    (w_reset)
				);			
		end 
		else begin
			   assign r_reset = i_arst;
			   assign r_clk   = i_clk_w;
			   assign w_reset = r_reset_str;
		end   
endgenerate	

generate
		if (ENABLE_ASYNC_ADAPTERS== 1) begin
			eth_f_altera_std_synchronizer_nocut rtr_sync (
				.clk     (i_clk_r),
				.reset_n (1'b1),
				.din     (ready_to_read),
				.dout    (ready_to_read_sync)
			);
		end
endgenerate		

			always_ff @(posedge i_clk_w) begin
				if (w_reset) begin
					o_ready <= 1'b0;
				end else begin
					o_ready <= ready_int;
				end
			end

generate
		if(EHIP_RATE == "100G")begin
						eth_f_100g_avalon_to_if a2i (
				.i_clk          (i_clk_w),
				.i_reset        (reset_str_delay),

				.i_empty        (i_empty),
				.i_error        (i_error),
				.i_sop          (i_sop && i_valid),
				.i_eop          (i_eop),
				.i_valid        (ready_delay),
				.i_skip_crc     (i_skip_crc),

				.o_inframe      (if_inframe),
				.o_error        (if_error),
				.o_empty        (if_empty),
				.o_skip_crc     (if_skip_crc),
				.o_num_valid    (if_num_valid)      );
		end	
		else begin	
			if(EHIP_RATE == "50G" || EHIP_RATE == "40G") begin
					  eth_f_50g_avst2if_pp avst_to_if (
				.i_clk              (i_clk_w),
				.i_reset            (reset_str_delay),
				.i_valid            (ready_delay),
				.i_data             (i_data),
				.i_sop              (i_valid && i_sop),
				.i_eop              (i_eop),
				.i_empty            (i_empty),
				.i_error            (i_error),
				.i_preamble         (i_preamble),
				.i_skip_crc         (i_skip_crc),
				.o_data             (if_data),
				.o_num_valid        (if_num_valid),
				.o_inframe          (if_inframe),
				.o_empty            (if_empty),
				.o_error            (if_error),
				.o_skip_crc         (if_skip_crc)     );
			
			end
		end
endgenerate

generate
		for (i = 0; i < MEMBLOCKS ; i++) begin : mem_loop
		eth_f_mlab #(
					.WIDTH      (BWIDTH),
					.ADDR_WIDTH (MLAB_ADDR_WIDTH),
					.SIM_EMULATE(SIM_EMULATE)
				) mem (
					.wclk       (i_clk_w),
					.wdata_reg  (write_data_rotated[i]),
					.wena       (1'b1),
					.waddr_reg  (write_pointers[i]),
					.raddr      (read_pointers[i[READ_LANE]]),
					.rdata      (read_data[i])
				);
			end
endgenerate

generate
		for (i = 0; i < WRITE_DATA_WIDTH; i++) begin : write_mem_loop
			assign write_data[i] = {if_inframe[i], if_error[i], if_skip_crc[i], if_empty[i], if_data[i]};
		end
		
		for (i = 0; i < OUTBLOCKS; i++) begin : o_data_loop
			assign {o_inframe_int[i], o_error[i], o_skip_crc[i], o_empty[i], o_data[i]} = read_data_rotated[i];
		end
	
		if (EHIP_RATE == "100G") begin
			assign 	write_pointers = write_pointers_r3;
			assign o_inframe = read_data_rotated_valid ? o_inframe_int : 1'b0; // Mask inframe bits when !o_valid to prevent reset issues
		end 
		else begin
			assign 	write_pointers = write_pointers_r2;
			assign o_inframe = read_data_rotated_valid ? o_inframe_int : 1'b0; // Mask inframe bits when !o_valid to prevent reset issues 
		end
endgenerate

generate
	  if(EHIP_RATE == "100G")begin
	     eth_f_rptr_gen_tx100a rptr_gen_inst (
			.i_reset            (r_reset_str),
			.i_clk              (r_clk),
			.i_read             (read_mem),
			.o_read_pointers    (read_pointers),
			.o_rotation         (read_offset)
         );
	 end
	 else begin	
		if(EHIP_RATE == "50G" || EHIP_RATE == "40G") begin	
		eth_f_50g_tx_pp_rptr_gen_async rptr_gen_async (
			.i_clk              (r_clk),
			.i_reset            (r_reset_str),
			.i_read             (read_mem),
			.o_rotate           (read_offset),
			.o_read_pointers    (read_pointers)
		);
		end
	end
endgenerate

    eth_f_delay_reg #(
        .CYCLES (READY_LATENCY + 1),
        .WIDTH  (1)
    ) dv (
        .clk    (i_clk_w),
        .din    (ready_int),
        .dout   (ready_delay)
    );
localparam NUM_CYCLES     = (EHIP_RATE == "100G") ? 4 : 3;
localparam D_WIDTH     = (EHIP_RATE == "100G") ? 4 : 2;
    eth_f_delay_reg #( 
        .CYCLES (NUM_CYCLES), 
        .WIDTH  (D_WIDTH)
    ) num_write_blocks_delay_inst (
        .clk    (i_clk_w),
        .din    (if_num_valid),
        .dout   (num_valid_delay)
    );

generate
	if (ENABLE_ASYNC_ADAPTERS == 1) begin
    	eth_f_pointer_synchronizer #(
			.WIDTH      (6),
			.SIM_EMULATE(SIM_EMULATE)
		) read_cnt_sync (
			.clk_in     (i_clk_r),
			.ptr_in     (num_read),
			.clk_out    (i_clk_w),
			.ptr_out    (num_read_sync)
		);		
    end
	else begin
		eth_f_delay_reg #(                
			.CYCLES (2),
			.WIDTH  (1)
		) mem_ready_inst (
			.clk    (i_clk_w),
			.din    (read_mem),
			.dout   (read_mem_delay)
		);
	end
endgenerate	
   
    eth_f_delay_reg #(
        .CYCLES (3),
        .WIDTH  (1)
    ) valid_out_delay (
        .clk    (r_clk),
        .din    (i_ready),
        .dout   (o_valid)
    );

	
generate //TODO : need to parameterized for all rate
	if (ENABLE_ASYNC_ADAPTERS==1) begin
		
			eth_f_ready_gen_100g_a #(
				.READY_LATENCY  (READY_LATENCY + ((EHIP_RATE == "50G" || EHIP_RATE == "40G") ? 5: 6)),
				.EHIP_RATE (EHIP_RATE),
				.OUTBLOCKS  (OUTBLOCKS),
				.MEMBLOCKS (MEMBLOCKS),
        .VIRTUAL_USED_PRAM(NUM_WRITTEN_PRAM),
				.MEMDEPTH (MEMDEPTH)
			) ready_gen_inst (
				.i_reset        (w_reset),
				.i_clk          (i_clk_w),
				.i_num_write    (num_valid_delay),  // if_num_valid
				.i_read_ptr     (num_read_sync),
				.o_ready        (ready_int)
			);
		 end 
		 else begin
			eth_f_ready_gen_100g_s #(
				.READY_LATENCY  (READY_LATENCY +((EHIP_RATE == "50G" || EHIP_RATE == "40G") ? 5 : 6 )),
				.EHIP_RATE (EHIP_RATE),
				.OUTBLOCKS  (OUTBLOCKS),
				.MEMBLOCKS (MEMBLOCKS),
        .O_READY_USED(NUM_WRITTEN_PRAM),
				.MEMDEPTH (MEMDEPTH)
			) ready_gen_inst (
				.i_reset        (r_reset_str),
				.i_clk          (i_clk_w),
				.i_num_write    (num_valid_delay),
				.i_read         (read_mem_delay),
				.o_ready        (ready_int)
			);
		 end 		
endgenerate	  
	
generate
		if (EHIP_RATE == "100G") begin
			always_ff @(posedge i_clk_w) if_data <= i_data;
		end
endgenerate		

		
		    eth_f_delay_reg #(
				.CYCLES (READY_LATENCY + 1),
				.WIDTH  (1)
				) reset_delay (
				.clk    (i_clk_w),
				.din    (w_reset),
				.dout   (reset_str_delay)
			);
		
			eth_f_wptr_gen_tx100a #(
				 .EHIP_RATE (EHIP_RATE),
				 .INBLOCKS         (INBLOCKS), 
				 .OUTBLOCKS        (OUTBLOCKS),
				 .MEMBLOCKS        (MEMBLOCKS),
				 .MEMDEPTH         (MEMDEPTH)
				 ) wptr_gen_inst  (
				.i_reset            (w_reset),
				.i_clk              (i_clk_w),
				.i_num_write        (if_num_valid),
				.o_write_pointers   (if_write_pointers),
				.offset             (write_data_rotate)
			);

generate
    if(EHIP_RATE == "100G")begin
		 eth_f_data_rotate_8to8_tx100a #(
				.WIDTH      (BWIDTH)
			) w_data_rotate (
				.i_clk      (i_clk_w),
				.i_rotate   (write_data_rotate),
				.i_data     (write_data),
				.o_data     (write_data_rotated)
			);
	end
	else begin	
	   if(EHIP_RATE == "50G" || EHIP_RATE == "40G") begin	
			eth_f_50g_tx_pp_data_rotate_3to4_async #(
				.WIDTH  (BWIDTH)
			) w_data_rotate (
				.i_clk      (i_clk_w),
				.i_rotation (write_data_rotate),
				.i_data     (write_data),
				.o_data     (write_data_rotated)
			);
	
	   end
   end
  endgenerate

    always_ff @(posedge i_clk_w) begin
        write_pointers_r2   <= if_write_pointers;
        write_pointers_r3   <= write_pointers_r2;
    end

 always_ff @(posedge i_clk_w) begin
        if (w_reset) begin
            num_written     <= 6'd0;
        end else begin
            num_written     <= 6'(num_written + num_valid_delay);
        end
 end


 always_ff @(posedge i_clk_w) begin
	  if (EHIP_RATE == "100G") begin
        if (w_reset) begin
            ready_to_read   <= 1'b0;
        end 
		else begin
			ready_to_read   <= ready_to_read | (num_written >= NUM_WRITTEN_PRAM); 
		end		
    end
	else begin
		if (EHIP_RATE == "50G" || EHIP_RATE == "40G") begin
			//if (r_reset_str) begin
			if (w_reset) begin
				ready_to_read   <= 1'b0;
			end 
			else begin
				if (ENABLE_ASYNC_ADAPTERS == 0) begin
					ready_to_read   <= ready_to_read | (num_written >= NUM_WRITTEN_PRAM);  //7 blocks
				end
				else begin
					if (ENABLE_ASYNC_ADAPTERS == 1) begin
					  ready_to_read <= ready_to_read | (num_written >= NUM_WRITTEN_PRAM);     // Mem has 12 blocks stored
					end
				end	
			end
		end
    end
 end

generate
	always_ff @(posedge i_clk_r) begin  
		if (ENABLE_ASYNC_ADAPTERS == 1) begin
			read_mem                <= i_ready && ready_to_read_sync;
			read_data_reg_valid     <= read_mem;
			read_data_rotated_valid <= read_data_reg_valid;
			if (r_reset_str) begin
				num_read    <= 6'd0;
			end else begin
						num_read    <= read_mem ? num_read + 6'd1 : num_read;
				end
		end
		else begin
			read_mem <= i_ready && ready_to_read; 
			read_data_reg_valid     <= read_mem;  
			read_data_rotated_valid <= read_data_reg_valid; 
		end
	end

endgenerate	

    always_ff @(posedge r_clk) begin             
        read_data_reg       <= read_data;
        read_offset_r2      <= read_offset;
    end

generate
	  if(EHIP_RATE == "100G")begin
			always_ff @(posedge i_clk_r) begin
				read_mem_valid      <= read_ptrs_valid;		
				read_data_mux_valid <= read_mem_valid;
				read_ptrs_valid     <= i_ready;
			end
	   end
	   else begin
		   if (EHIP_RATE == "100G" && ENABLE_ASYNC_ADAPTERS == 1) begin
				assign o_valid = read_data_mux_valid;  
		   end	
		end   
endgenerate	  

    eth_f_data_mux_2to1_tx100a #(
        .WIDTH  (ROTATE_WIDTH_PARAM*BWIDTH),
		.EHIP_RATE (EHIP_RATE)
    ) rd_mux (
        .i_clk  (r_clk),
        .i_sel  (read_offset_r2),
        .i_data (read_data_reg),
        .o_data (read_data_rotated)
    );
	
/* generate
	  if(EHIP_RATE == "100G")begin 
        eth_f_stats_tx100a #(
		.ENABLE_ASYNC_ADAPTERS (ENABLE_ASYNC_ADAPTERS)
		)  stats_inst 
		(
        .i_reset_r          (r_reset_str),
        .i_reset_w          (w_reset),
        .i_clk_w            (i_clk_w),
        .i_clk_r            (r_clk),
        .i_valid_in         (ready_delay),
        .i_valid_out        (o_valid),
        .i_sop              (i_sop && i_valid),
        .i_eop              (i_eop && i_valid),
        .i_inframe          (o_inframe),
        .i_mem_read         (read_mem),
        .i_read_pointers    (read_pointers),
        .i_write_pointers   (write_pointers_r3),
        .o_starts_in        (o_starts_in),
        .o_starts_out       (o_starts_out),
        .o_ends_in          (o_ends_in),
        .o_ends_out         (o_ends_out),
        .o_mem_underflow    (o_mem_underflow)
    );
	end
	else begin
		  if((EHIP_RATE == "50G" || EHIP_RATE == "40G") && ENABLE_ASYNC_ADAPTERS == 0)begin 
		   eth_f_stats_txpp50s #(
		  ) stats_txpp50s (
			.i_reset            (r_reset_str),
			.i_clk              (i_clk_w),
			.i_valid_in         (ready_delay),
			.i_valid_out        (o_valid),
			.i_sop              (i_sop && i_valid),
			.i_eop              (i_eop && i_valid),
			.i_inframe          (o_inframe),
			.o_starts_in        (o_starts_in),
			.o_starts_out       (o_starts_out),
			.o_ends_in          (o_ends_in),
			.o_ends_out         (o_ends_out)
		);
		assign o_mem_underflow = 8'b0;
		end
		else begin
		assign o_ends_in = 32'b0;
		assign o_ends_out = 32'b0;
		assign o_mem_underflow = 8'b0;
		assign o_starts_in = 32'b0;
		assign o_starts_out = 32'b0;
		end
	end 
	
endgenerate	 */

		assign o_ends_in = 32'b0;
		assign o_ends_out = 32'b0;
		assign o_mem_underflow = 8'b0;
		assign o_starts_in = 32'b0;
		assign o_starts_out = 32'b0;
		
endmodule 




















`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "4AvUa/AX+twoSNmlxf8DfgbJZtLM0FTYaDfqwIVh58kyS9m523ZPwLwxNf/MAu2Ws24gvNuIWubOgwJDJF/J8SquMj7R1nNyipeKzuCa44Ouq3sVSfXA6vNne7RbKwd87qtqmEuaCdIDSUZZO8uw+CWUHgUS5S0PLelh7tY7EIuUsZeE9mUM9zh2JvtzuWMzW1qicCsSFUI1HHB6Owmf0ylz2E7BXtP0spRRZWMpnQ1dSpn4toZyzkso/cTsi7eeR6MtOrZEMquxTdcQIwpuB+5wYlAVikrMdMoN1j6rJBMobwnrEUunj0D+KA8m0muQem3uwjbXFdmB8Uezp6wyAJSca6/MZMsyMwz6Mz7EwclWAMHb8CULXwE9SkYx6uEA42thl/h723zdhl/xoCYU4+tTyKAbgUsZn518UGMLW3duV4UEuwJaejuEc362tjh5l9gqALHnRk9Wndnbghk6ELVSdc+KPoyPUH1n3DNPCPYvCk+L4Akh/8iLcnmLCoqTDLpUziq8u9s0A64owkMCfd64/rVl54x1vdoE0rdOWVtJrOj9+WKgP968pFpp5D2J+qvPFHzk/U7UnF3uAkStRLYqKvpPdUr18t+S2g9dRWhvSge9Wvkzop9tulP6Xp2GMo1H+86B3shIUc9lTgF59qhDOiDkglT0uid7/mQtWvMZtTRbdBKprvAcsknhXt5cJe1NpFWpdzJH4TxyfORzyH/F63hwQuiS9ksju/RcS/YpucdQsprWKNAMJUApXeBkTdCDOUNJ0KmKiNo3vsN84l7UtEL8E50rqft0K8V9iBnXXA5AIKDfv7JJcXWkQwPM2oX+WvxwmZ/mqGZbaceFNeXOUd3EYbWrp+cwrwRd1QL+/UUlunP7XMTb1GootqOWi/Dm7AMzKtNkMPSjol8JHlpUAw26V1FxoPGV5jxFLyXAt+LZvJdwO9BCHs77lv+gVF2TUziobOqUhY2nAyDYGp2vBuw4A9V6sKaHMm81nVvLGVcbjtYLhWRDzpG4u4YJ"
`endif