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




// check rotation index
module eth_f_100g_50g_adapter_rx  #(
	parameter EHIP_RATE                   =   "50G", 
    parameter MASK_VALID                  =   1,
	parameter ENABLE_ASYNC_ADAPTERS       =   1,
	parameter PREAMBLE_PASSTHROUGH        =   0,
    parameter SB_WIDTH                    =   1+3+2+1+3+1+1, // inframe + empty + error + fcs_error + status + undersized + oversized
	parameter MEMBLOCKS                  =   (EHIP_RATE=="50G" || EHIP_RATE == "40G")?((PREAMBLE_PASSTHROUGH ==1)? 4:2):8,
	parameter DCFIFO_WID                 =   (EHIP_RATE=="50G" || EHIP_RATE == "40G")?((PREAMBLE_PASSTHROUGH ==1) ? 7: 6):8,
	parameter INFRAME_WIDTH              =   (EHIP_RATE=="50G" || EHIP_RATE == "40G")? 2 :4,
	parameter VALID_WIDTH                =   (EHIP_RATE=="50G" || EHIP_RATE == "40G")? 1:4, 
	parameter WPTR                       =   (EHIP_RATE=="50G" || EHIP_RATE == "40G")?((PREAMBLE_PASSTHROUGH ==1)? 2:1):2,
	parameter ALIGNED_SB_WIDTH           =   (EHIP_RATE=="50G" || EHIP_RATE == "40G")? 2:8,
	parameter O_DATA                     =   (EHIP_RATE=="50G" || EHIP_RATE == "40G")? 128 : 512,
	parameter R_INDEX                    =   (EHIP_RATE=="50G" || EHIP_RATE == "40G") ? ((PREAMBLE_PASSTHROUGH ==1)?2 : 1) : 3,
	parameter EMPTY                      =   (EHIP_RATE=="50G" || EHIP_RATE == "40G") ? 4 : 6
) (
    input   logic                             i_arst,   
    input   logic                             i_clk_w,  
    input   logic                             i_clk_r,  
	
    input                                     i_clear_counters,
    output          [63:0]                    o_dropped_frames,

    output  logic   [O_DATA-1:0]              o_data,
    output  logic   [63:0]                    o_preamble,
    output  logic                             o_valid,
    output  logic                             o_sop,
    output  logic                             o_eop,
    output  logic   [EMPTY-1:0]               o_empty,
    output  logic   [39:0]                    o_status,
    output  logic                             o_status_valid,
    output  logic   [5:0]                     o_error,

    input   logic   [15:0]                    i_min_frame_octets, 
    input   logic   [0:INFRAME_WIDTH-1]              i_inframe,
    input   wire    [0:INFRAME_WIDTH-1][63:0]        i_data,
    input   logic                                    i_valid,
    input   wire    [0:INFRAME_WIDTH-1][2:0]         i_empty,
    input   wire    [0:VALID_WIDTH-1][1:0]      i_error,
    input   logic   [0:VALID_WIDTH-1]           i_fcs_error,
    input   wire    [0:VALID_WIDTH-1][2:0]      i_status,
    
    // wire to ptp_adapter_rx
    output  logic   [0:INFRAME_WIDTH-1]   o_dbg_filtered_if,
    output  logic                         o_dbg_filtered_if_valid
);

    genvar i;
    logic                                     w_reset; 
    logic                                     r_reset; 
    logic   [0:INFRAME_WIDTH-1]                      filtered_if;
    logic                                     filtered_if_valid;
    logic   [0:1]                             inframe_r2;
    logic   [0:INFRAME_WIDTH-1][2:0]                 empty_r2;
    logic   [0:VALID_WIDTH-1][1:0]              error_r2;
    logic   [0:VALID_WIDTH-1]                   fcs_error_r2;
    logic   [0:VALID_WIDTH-1][2:0]              status_r2;
    logic                                     val_i;
    //logic   [6:0]                             ptr_i;
    logic   [DCFIFO_WID-1:0]                             ptr_i;
    logic   [0:INFRAME_WIDTH-1]               if_i;
	
    logic   [0:WPTR-1][4:0]                   write_pointers;
    logic   [0:WPTR-1][4:0]                   write_pointers_r2; 
    logic   [6:0]                             block_pointer_pp; 
    logic   [6:0]                             block_pointer_pp_r2;
    logic   [0:MEMBLOCKS-1][4:0]              w_pointer;
    logic   [0:MEMBLOCKS-1][63:0]             data;
    logic   [0:MEMBLOCKS-1][4:0]              w_pointer_r2;
    logic   [0:MEMBLOCKS-1][SB_WIDTH-1:0]     sb_data;
	
	
	
    logic   [DCFIFO_WID-1:0]                  block_pointer_start;
    logic                                     block_pointer_start_valid;
    logic   [DCFIFO_WID-1:0]                  block_pointer_start_sync; 
    logic                                     block_pointer_start_sync_valid; 
	
	logic   [DCFIFO_WID-1:0]                  block_pointer_start_sync_new; 
    logic                                     block_pointer_start_sync_valid_new;

    logic   [0:MEMBLOCKS-1][4:0]              rotated_rptrs;
    logic   [0:MEMBLOCKS-1][4:0]              rotated_rptrs_r2;
    logic                                     rotated_rptrs_valid; 
    logic   [R_INDEX -1:0]                    rotation_index; 

    logic   [0:MEMBLOCKS-1][63:0]             read_data_data; 
    logic   [0:MEMBLOCKS-1][63:0]             read_data_data_reg; 
    logic   [0:MEMBLOCKS-1][SB_WIDTH-1:0]     read_sb_data;
    logic   [0:MEMBLOCKS-1][SB_WIDTH-1:0]     read_sb_data_reg;
    logic   [R_INDEX -1:0]                    sb_rotation_index;
    logic   [R_INDEX -1:0]                    data_rotation_index; 
    logic                                     read_sb_data_valid;
    logic   [0:3][SB_WIDTH-1:0]               rd_sb_data_pp;
    logic   [0:3][63:0]                       rd_data_data_reg_pp;

    logic   [0:ALIGNED_SB_WIDTH-1][SB_WIDTH-1:0]         aligned_sb_data; 
    logic   [0:ALIGNED_SB_WIDTH-1]                       aligned_if; 
    logic   [0:ALIGNED_SB_WIDTH-1][2:0]                  aligned_empty; 
    logic   [0:ALIGNED_SB_WIDTH-1][1:0]                  aligned_error; 
    logic   [0:ALIGNED_SB_WIDTH-1]                       aligned_fcs_error;
    logic   [0:ALIGNED_SB_WIDTH-1][2:0]                  aligned_status; 

    logic                                     sb_valid;
    logic                                     if_avst_sb_valid;

    logic   [0:ALIGNED_SB_WIDTH-1]                       Zeros;
    logic   [0:ALIGNED_SB_WIDTH-1]                       unused1,unused2;
    
    logic                                     dc_fifo_read;   
    logic                                     dc_fifo_empty;   
    logic                                     dc_fifo_full;   

    logic   [0:INFRAME_WIDTH-1]                      inframe_reg;
    logic   [0:3][SB_WIDTH-4:0]               sideband_r2;
    logic   [0:3][SB_WIDTH-4:0]               sideband_r3;
    logic   [0:WPTR-1][4:0]                   write_pointers_r1;  
    logic   [0:1][4:0]                        write_pointers_r3;
    logic   [0:3][7:0]                        write_mem_pointers;
    logic   [0:3][7:0]                        write_mem_pointers_r1;
    logic   [0:3][7:0]                        write_mem_pointers_r2;
    logic   [0:3][7:0]                        write_mem_pointers_r3;
    logic   [0:INFRAME_WIDTH-1]                      if_unfiltered;
    logic   [0:INFRAME_WIDTH-1]                      unfiltered;
    logic                                     sb_data_aligned_valid;
    logic                                     clk_r;
    logic   [DCFIFO_WID-1:0]                  ptr_h;
	
    assign Zeros = {ALIGNED_SB_WIDTH{1'b0}};
    assign o_dbg_filtered_if = filtered_if;
    assign o_dbg_filtered_if_valid = filtered_if_valid;

	generate 
		if(ENABLE_ASYNC_ADAPTERS ==1) begin
			assign clk_r= i_clk_r ;
			
			assign w_reset = i_arst; //i_clk_w is int_clk_rx in sip logic and i_arst is synchronized in SIP w.r.t int_clk_rx/i_clk_w	


			eth_f_altera_std_synchronizer_nocut sync_rst_r (
					.clk     (clk_r),
					.reset_n (1'b1),
					.din     (i_arst),
					.dout    (r_reset)
				);
				
	
		end
		else begin
			assign clk_r=i_clk_w;
			assign r_reset = i_arst;
			assign w_reset = i_arst;
		end
	endgenerate	
	
	
	generate
		always_ff @(posedge i_clk_w) begin
			if(EHIP_RATE=="50G" || EHIP_RATE == "40G") begin
				write_pointers_r2   <= write_pointers; 
				block_pointer_pp_r2 <= block_pointer_pp;
				inframe_r2          <= i_inframe;
				empty_r2            <= i_empty;
				error_r2            <= i_error;
				fcs_error_r2        <= i_fcs_error;
				status_r2           <= i_status;
			end	
		
			else if (EHIP_RATE=="100G") begin
				if (i_valid) begin
						empty_r2                <= i_empty;
						error_r2                <= i_error;
						fcs_error_r2            <= i_fcs_error;
						status_r2               <= i_status;
						sideband_r2[0]          <= {empty_r2[0], error_r2[0], fcs_error_r2[0], status_r2[0]};
						sideband_r2[1]          <= {empty_r2[1], error_r2[1], fcs_error_r2[1], status_r2[1]};
						sideband_r2[2]          <= {empty_r2[2], error_r2[2], fcs_error_r2[2], status_r2[2]};
						sideband_r2[3]          <= {empty_r2[3], error_r2[3], fcs_error_r2[3], status_r2[3]};
						write_pointers_r1       <= write_pointers;
						write_pointers_r2       <= write_pointers_r1;
						write_mem_pointers_r1   <= write_mem_pointers;
						write_mem_pointers_r2   <= write_mem_pointers_r1;
					end else begin
						empty_r2                <= empty_r2;
						error_r2                <= error_r2;
						fcs_error_r2            <= fcs_error_r2;
						status_r2               <= status_r2;
						sideband_r2             <= sideband_r2;
						write_pointers_r1       <= write_pointers_r1;
						write_pointers_r2       <= write_pointers_r2;
						write_mem_pointers_r1   <= write_mem_pointers_r1;
						write_mem_pointers_r2   <= write_mem_pointers_r2;
					end

					write_pointers_r3           <= write_pointers_r2;
					write_mem_pointers_r3       <= write_mem_pointers_r2;
					sideband_r3                 <= sideband_r2;
			end
		end
	endgenerate
	
	generate	
		for (i = 0; i < MEMBLOCKS; i++) begin : mem_loop4
		
			if ((EHIP_RATE=="50G" || EHIP_RATE == "40G")&& PREAMBLE_PASSTHROUGH ==1) begin
			
				assign w_pointer[i]=write_pointers[i[1]];
				assign data[i]=i_data[i%2];
				assign w_pointer_r2[i]=write_pointers_r2[i[1]];
				assign sb_data[i]={filtered_if[i%2], empty_r2[i%2], error_r2, fcs_error_r2, status_r2, Zeros[i%2], Zeros[i%2]};
		
			end
			
			else if (EHIP_RATE=="100G") begin
				assign w_pointer[i]=write_pointers[i[2]];
				assign data[i]= i_data[i%4];
				assign w_pointer_r2[i]=write_pointers_r3[i[2]];
				assign sb_data[i] = {filtered_if[i%4], sideband_r3[i%4],Zeros[i%4], Zeros[i%4]}; end
			
			else begin

				assign w_pointer[i]=write_pointers;
				assign data[i]=i_data[i];
				assign w_pointer_r2[i]=write_pointers_r2;
				assign sb_data[i]={inframe_r2[i], empty_r2[i][2:0], error_r2, fcs_error_r2, status_r2, Zeros[i], Zeros[i]}; 		
			end
            eth_f_mlab #(
                .WIDTH  (64)
            ) mem_data (
                .wclk       (i_clk_w),
                .wena       (1'b1),
                .waddr_reg  (w_pointer[i]),
                .wdata_reg  (data[i]),
                .raddr      (rotated_rptrs_r2[i]), 
                .rdata      (read_data_data[i])  
            );
	
            eth_f_mlab #(
                .WIDTH  (SB_WIDTH)
            ) sideband_data (
                .wclk       (i_clk_w),
                .wena       (1'b1),
                .waddr_reg  (w_pointer_r2[i]),
                .wdata_reg  (sb_data[i]),
                .raddr      (rotated_rptrs[i]),
                .rdata      (read_sb_data[i])
            );
        end
		for (i = 0; i < ALIGNED_SB_WIDTH; i++) begin : output_loop2
			assign {aligned_if[i],
					aligned_empty[i],
					aligned_error[i],
					aligned_fcs_error[i],
					aligned_status[i],
					unused1[i],
					unused2[i]} = aligned_sb_data[i];
		end
					
    endgenerate
	
	
	generate 
		if ((EHIP_RATE=="50G" || EHIP_RATE == "40G") && PREAMBLE_PASSTHROUGH ==1) begin
			eth_f_preamble_filter2 filter_p (
				.i_clk      (i_clk_w),
				.i_reset    (w_reset),
				.i_valid    (i_valid),
				.i_inframe  (i_inframe),
				.o_valid    (filtered_if_valid),
				.o_inframe  (filtered_if)
			);
		
			always_ff @(posedge i_clk_w) begin
				inframe_reg   <= w_reset ? 2'b00 : i_inframe;  
			end
			eth_f_50g_rx_pp_wptr_gen wptr_gen_inst (
				.i_clk              (i_clk_w),
				.i_reset            (w_reset),
				.i_valid            (i_valid),
				.o_write_pointers   (write_pointers),
				.o_block_pointer    (block_pointer_pp)
			);
			
			eth_f_50g_rx_pp_rptr_gen_async rptr_gen_async_inst (
				.i_clk  (clk_r),                        
				.i_ptr  (block_pointer_start_sync_new), 
				.o_ptr  (rotated_rptrs)
			);
			
			
		end
		
		else if ((EHIP_RATE=="50G" || EHIP_RATE == "40G") && !PREAMBLE_PASSTHROUGH ==1) begin
			eth_f_preamble_filter2 filter_p (
				.i_clk      (i_clk_w),
				.i_reset    (w_reset),
				.i_valid    (i_valid),
				.i_inframe  (i_inframe),
				.o_valid    (filtered_if_valid),
				.o_inframe  (filtered_if)
			);
	
			eth_f_50g_rx_wptr_gen_async wptr_gen_async_inst (
				.i_reset        (w_reset),
				.i_clk          (i_clk_w),
				.i_valid        (i_valid),
				.write_pointer  (write_pointers)
			);
	
			eth_f_50g_rx_rptr_gen_async rptr_gen_async_inst (
				.i_clk  (clk_r),
				.i_ptr  (block_pointer_start_sync_new),
				.o_ptr  (rotated_rptrs)
			);
			
			assign block_pointer_pp = 7'b0;
		end
		
		else begin
			eth_f_if_filter5 #(
				.SB_WIDTH(4)
			) filter5 (
				.reset      (w_reset),
				.clk        (i_clk_w),
				.din        (i_inframe),
				.sb_din     (i_inframe),
				.valid_in   (i_valid),
				.dout       (filtered_if),
				.sb_dout    (if_unfiltered),
				.valid_out  (filtered_if_valid)
			);
			
			eth_f_100g_rx_aligner sop_aligner (
				.i_clk      (i_clk_w),
				.i_reset    (w_reset),
				.i_valid    (filtered_if_valid),//check
				.i_inframe  (filtered_if), 
				.i_ptr      (write_mem_pointers_r3[0][7:2]),
				.o_ptr      (block_pointer_start),
				.o_valid    (block_pointer_start_valid)
			);
			
			eth_f_100g_adapter_wptr_addgen wptr_addgen (
				.i_reset    (w_reset),
				.i_clk      (i_clk_w),
				.i_valid    (i_valid),
				.lane_ptrs  (write_pointers),
				.mem_ptrs   (write_mem_pointers)
			);

		end
		
	endgenerate
	
	generate 
		if((PREAMBLE_PASSTHROUGH ==1 && (EHIP_RATE=="50G" || EHIP_RATE == "40G")) || EHIP_RATE=="100G") begin
			if (EHIP_RATE=="100G") assign unfiltered = if_unfiltered;
			else  assign unfiltered=inframe_reg;
			
			eth_f_dropped_frame_count #(
				.LANES          (EHIP_RATE=="100G"?4:2),
				.FRAME_MARKERS  (EHIP_RATE=="100G" ? "sop":"eop")
			) drop_frm_counter_inst (
				.clk                    (i_clk_w),
				.reset                  (w_reset),
				.clear_count            (i_clear_counters),
				.valid                  (filtered_if_valid),
				.inframe_unfiltered     (unfiltered),
				.inframe_filtered       (filtered_if),  
				.dropped_frames         (o_dropped_frames)
			);
		end
		else assign o_dropped_frames = {64{1'b0}};
	endgenerate
	 
	
	generate 
		if(EHIP_RATE=="50G" || EHIP_RATE == "40G") begin
			
			if (PREAMBLE_PASSTHROUGH ==1) begin
				assign val_i = filtered_if_valid;
				assign if_i = filtered_if;
				assign ptr_i = block_pointer_pp_r2; 
				assign 	rd_sb_data_pp =read_sb_data_reg;
				assign rd_data_data_reg_pp= read_data_data_reg ;
				end
			else begin
				assign val_i = i_valid; ///HSD https://hsdes.intel.com/resource/16011534051 to fix the destination address mismatch in PP disabled Mode
				assign if_i = i_inframe;  ///HSD https://hsdes.intel.com/resource/16011534051 to fix the destination address mismatch in PP disabled Mode
				assign ptr_i = {write_pointers, 1'b0}; 
				assign rd_sb_data_pp= {2{read_sb_data_reg}};
				assign rd_data_data_reg_pp={2{read_data_data_reg}};
				end

			
			eth_f_50g_rx_pp_block_shifter #(
                .PW ((PREAMBLE_PASSTHROUGH==1)? 7 : 6)
            ) block_ptr_gen (
					.i_clk      (i_clk_w),
					.i_reset    (w_reset),
					.i_valid    (val_i),
					.i_inframe  (if_i),
					.i_ptr      (ptr_i),
					.o_ptr      (block_pointer_start),
					.o_valid    (block_pointer_start_valid)
				);
				
	if (PREAMBLE_PASSTHROUGH ==1) begin				
			eth_f_50g_rx_pp_data_rotate_async #(                  
				.WIDTH  (SB_WIDTH),
                .PREAMBLE_PASSTHROUGH (PREAMBLE_PASSTHROUGH)
			) sb_rotate_inst (
				.i_clk      (clk_r),    
				.i_index    (sb_rotation_index),
				.i_data     (rd_sb_data_pp),
				.o_data     (aligned_sb_data),
				.o_preamble (/* unused */)
			);
	
			eth_f_50g_rx_pp_data_rotate_async #(                             
				.WIDTH  (64),
                .PREAMBLE_PASSTHROUGH (PREAMBLE_PASSTHROUGH)
			) data_rotate_async_inst (
				.i_clk      (clk_r),      
				.i_index    (data_rotation_index),
				.i_data     (rd_data_data_reg_pp),
				.o_data     (o_data),
				.o_preamble (o_preamble)
			);
    end
   else begin
	eth_f_50g_rx_pp_data_rotate_async #(                  
				.WIDTH  (SB_WIDTH),
                .PREAMBLE_PASSTHROUGH (PREAMBLE_PASSTHROUGH)
			) sb_rotate_inst (
				.i_clk      (clk_r),    
				.i_index    ({1'b0, sb_rotation_index}),
				.i_data     (rd_sb_data_pp),
				.o_data     (aligned_sb_data),
				.o_preamble (/* unused */)
			);
	
			eth_f_50g_rx_pp_data_rotate_async #(                             
				.WIDTH  (64),
                .PREAMBLE_PASSTHROUGH (PREAMBLE_PASSTHROUGH)
			) data_rotate_async_inst (
				.i_clk      (clk_r),      
				.i_index    ({1'b0,data_rotation_index}),
				.i_data     (rd_data_data_reg_pp),
				.o_data     (o_data),
				.o_preamble (o_preamble)
			);
	end
	
			
		end
		else if (EHIP_RATE=="100G")
			begin
			eth_f_100g_adapter_data_aligner_async #(
					.WIDTH  (SB_WIDTH )
				) sb_aligner (
					.clk    (clk_r),
					.din    (read_sb_data_reg),
					.index  (sb_rotation_index),
					.dout   (aligned_sb_data)
				);

				eth_f_100g_adapter_data_aligner_async #(
					.WIDTH  (64)
				) data_aligner (
					.clk    (clk_r),
					.din    (read_data_data_reg),
					.index  (data_rotation_index),
					.dout   (o_data)
				);
			
			if(ENABLE_ASYNC_ADAPTERS ==1) 
					assign ptr_h =block_pointer_start_sync;
			else
				assign ptr_h =block_pointer_start;
				
			eth_f_100g_adapter_rptr_addgen ptr_gen0 (
				.clk    (clk_r),
				.i_ptr  (ptr_h), 
				.o_ptr  (rotated_rptrs)
			);
			assign o_preamble = 64'b0;
		end
		else
		assign o_preamble = 64'b0;
	endgenerate
	
	generate
		if (ENABLE_ASYNC_ADAPTERS ==1) begin
			assign dc_fifo_read = !dc_fifo_empty;
			eth_f_dcfifo_mlab #(
				.WIDTH          (DCFIFO_WID), 
				.SYNC_ACLR_W    ("OFF"),
				.SYNC_ACLR_R    ("ON")
			) rd_ptr_sync (
				.aclr   (w_reset),
				.wclk   (i_clk_w),
				.write  (!dc_fifo_full && block_pointer_start_valid),
				.wdata  (block_pointer_start), 
				.full   (dc_fifo_full),
				.rclk   (i_clk_r),
				.read   (dc_fifo_read),
				.rdata  (block_pointer_start_sync),
				.empty  (dc_fifo_empty)
			);

			always_ff @(posedge clk_r) 
				block_pointer_start_sync_valid  <= dc_fifo_read; 
			
		end
	endgenerate
	
	generate
		
		if (ENABLE_ASYNC_ADAPTERS ==1) begin
			assign block_pointer_start_sync_valid_new=block_pointer_start_sync_valid;
			assign block_pointer_start_sync_new=block_pointer_start_sync;
			end
		else begin
			assign block_pointer_start_sync_valid_new=block_pointer_start_valid;
			assign block_pointer_start_sync_new=block_pointer_start; 
		end
			
	endgenerate
	
    always_ff @(posedge clk_r) begin
        rotated_rptrs_valid  <= block_pointer_start_sync_valid_new;
        rotation_index       <= block_pointer_start_sync_new[R_INDEX-1:0];  
        rotated_rptrs_r2     <= rotated_rptrs;
        read_data_data_reg   <= read_data_data; 
        read_sb_data_reg     <= read_sb_data;
        sb_rotation_index    <= rotation_index;
        data_rotation_index   <= sb_rotation_index;
        read_sb_data_valid    <= rotated_rptrs_valid; 
        sb_valid              <= read_sb_data_valid; 	
		sb_data_aligned_valid <= sb_valid; 
	
    end
	
	generate 
		if (EHIP_RATE=="100G")
		     assign if_avst_sb_valid =sb_data_aligned_valid;
		else assign if_avst_sb_valid =sb_valid;
		
		eth_f_if2avst
		 #(           
			.MASK_VALID (MASK_VALID),
			.EHIP_RATE (EHIP_RATE)
		) if2avst (
			.i_clk          (clk_r),  
			.i_reset        (r_reset),  
			.i_empty        (aligned_empty),
			.i_error        (aligned_error), 
			.i_fcs_error    (aligned_fcs_error), 
			.i_status       (aligned_status), 
			.i_valid        (if_avst_sb_valid), 
			.i_inframe      (aligned_if),  
			.o_valid        (o_valid),
			.o_sop          (o_sop),
			.o_eop          (o_eop),
			.o_empty        (o_empty),
			.o_status       (o_status),
			.o_status_valid (o_status_valid),
			.o_error        (o_error)
		);
		
	endgenerate
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "4AvUa/AX+twoSNmlxf8DfgbJZtLM0FTYaDfqwIVh58kyS9m523ZPwLwxNf/MAu2Ws24gvNuIWubOgwJDJF/J8SquMj7R1nNyipeKzuCa44Ouq3sVSfXA6vNne7RbKwd87qtqmEuaCdIDSUZZO8uw+CWUHgUS5S0PLelh7tY7EIuUsZeE9mUM9zh2JvtzuWMzW1qicCsSFUI1HHB6Owmf0ylz2E7BXtP0spRRZWMpnQ104/L/akAV+jcKhsen1nkRNVc5Pmknz3+Cf7n34ZtDClCHqkYHJD0WorSzOwEIG0hgFtaA5F71bsMQJKTtPGsRyW1L0nrJeK53D+TbNQoVdHih34PJJx93GVUNHn1nrJw6M4PwoILAXprFb/Rq8eWwi1G+gIqdKyOg+/hl2sBYzmsVVMkOU5m0umL4z7/RNNwyo1oZzYUN0xRtAx44AtESiBMZL232nDAm43p6O5MXhOyZfBZ3nzw6WHVW7stnuTQiK2vCZ6y7UnGDbYHsfHdyhaBw0cZnlZ4oaWOHwc5TquOGlnFt4+Ak5tSE3sBKekYlRWuqReYMQq3+9kf2mMVm4O3PQ98XHSxcarcg/UN6+MWiLIDmFGMcex1BqjlDLgwPMdOx8jsPksNw7d8YDlR8HNH7tKLjpNzB0/j+hvG9gSdE7kwuQPF5TlH33BHMUDhaphfSD+GKJ5D+3tk30jhV1xLueevPwrWLj2kAx8PJ9cag+O+XWMSIqc5q6kdPkiaPw1ThPxNyV7mN0I9DugllxvyO0mgTBWrrjelrezmQ26TaQjHRBHk11+wZM3/AY3Q5lwsvwD8mJiTC8hSYAJQWsM2jJQdZ0p15kbaEYY/qu56haYSbywpaiHC+fPVFVDPK250qwKJ+zrTkxiBBC7oCJwNiKnh7vWtpRCv7D0NLVW7ZljYveC9+cPXpe2drRWMMTe0rjMivwPUN/c1Yx3iUHwYtiSF3qR95d6IXYCLTkKonSYjmQ1axjLcGsGJq+bLEZW+2yj3Lm+gSBLaeFsu1"
`endif