// (C) 2001-2023 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


module eth_f_loopback_client #(
    parameter CLIENT_IF_TYPE     = 1,
    parameter EMPTY_WIDTH        = 6,
    parameter WORDS              = 8,
    parameter DATA_BCNT          = 64,
    parameter CTRL_BCNT          = 2,
    parameter FIFO_ADDR_WIDTH    = 5,
    parameter SIM_EMULATE        = 0,
    parameter INIT_FILE_DATA     = "init_file_data.hex",
    parameter ENABLE_PTP        = 0,
    parameter ENA_CRC_GAP_DA    = 1

) (
    input logic                   i_arst,

    input logic                   i_clk_w,
    input logic                   i_clk_r,
    
    // MAC AVST
    input logic                   i_sop,
    input logic                   i_eop,
    input logic                   i_valid,
    input logic [EMPTY_WIDTH-1:0] i_empty,
    input logic [64*WORDS-1:0]    i_data,
    input logic [6-1:0]           i_error,
//    input logic [64-1:0]        i_preamble, 


    // MAC segmented
    input logic [64*WORDS-1:0]    i_mac_data,
    input logic                   i_mac_valid,
    input logic [WORDS-1:0]       i_mac_inframe,
    input logic [3*WORDS-1:0]     i_mac_eop_empty,
    input logic [2*WORDS-1:0]     i_mac_error,
//    input logic [WORDS-1:0]     i_mac_fcs_error,


    // output data bus
    input  logic                   i_tx_req,
    output logic                   o_tx_data_vld,
    output logic [DATA_BCNT*8-1:0] o_tx_data,
    output logic [CTRL_BCNT*8-1:0] o_tx_ctrl,

        //---csr interface---
        input  logic                   stat_rx_cnt_clr,
        input  logic                   cfg_rom_crc_ena,
        output logic          		    stat_rx_lat_sop,
        output logic                   stat_rx_cnt_vld,
        output logic [7:0]             stat_rx_sop_cnt,
        output logic [7:0]             stat_rx_eop_cnt,
        output logic [7:0]             stat_rx_err_cnt,
        output logic                   o_wr_full_err,
        output logic                   o_rd_empty_err
        
);


    localparam MEM_WIDTH_DATA    = DATA_BCNT*8;
    localparam MEM_WIDTH_CTRL    = CTRL_BCNT*8;
    localparam AVST_SOP_POS      = 0;
    localparam AVST_EOP_POS      = 1;
    localparam AVST_ERR_POS      = 2;
    localparam AVST_SKIP_CRC_POS = 3;
    localparam AVST_EMPTY_POS    = 8;
    localparam SEG_SOP_POS       = 0;
    localparam SEG_EOP_POS       = 1;
    localparam SEG_SKIP_CRC_POS  = 3;
    localparam SEG_INFRAME_POS   = 8;
    localparam SEG_EOP_EMPTY_POS = SEG_INFRAME_POS+WORDS;
    localparam SEG_ERROR_POS     = SEG_EOP_EMPTY_POS+(WORDS*3);


    logic                      r_reset;

    logic                      dcfifo_write_vld, dcfifo_write_vld_r;
    logic                      dcfifo_idle_ctrl, dcfifo_idle_ctrl_r;
    logic [MEM_WIDTH_DATA-1:0] dcfifo_write_data, dcfifo_write_data_r;
    logic [MEM_WIDTH_CTRL-1:0] dcfifo_write_ctrl, dcfifo_write_ctrl_r;

//---------------------------------------------------------------
// MAC AVST
logic                   avst_valid, avst_sop, avst_eop;
logic [EMPTY_WIDTH-1:0] avst_empty;
logic [64*WORDS-1:0]    avst_data;
logic [6-1:0]           avst_error;

// MAC segmented
logic                   seg_valid;
logic [WORDS-1:0]       seg_sop, seg_eop;
logic [64*WORDS-1:0]    seg_data;
logic [WORDS-1:0]       seg_inframe;
logic [3*WORDS-1:0]     seg_eop_empty;
logic [2*WORDS-1:0]     seg_error;

logic [WORDS-1:0]   i_seg_sop, i_seg_eop, i_seg_pkt_boundary;
logic               i_idle_detect, idle_detect;

always @ (posedge i_clk_w) begin
    avst_valid    <= i_valid;
    avst_sop      <= i_sop;
    avst_eop      <= i_eop;
    avst_data     <= i_data;
    avst_empty    <= i_empty;
    avst_error    <= i_error;

    seg_valid     <= i_mac_valid;
    seg_sop       <= i_seg_sop;
    seg_eop       <= i_seg_eop;
    seg_inframe   <= i_mac_inframe;
    seg_data      <= i_mac_data;
    seg_eop_empty <= i_mac_eop_empty;
    seg_error     <= i_mac_error;
    idle_detect   <= i_idle_detect;
end

generate 
    if (WORDS==1) begin: WORDS_1
        assign i_seg_pkt_boundary = seg_inframe[WORDS-1] ^ i_mac_inframe;
        assign i_idle_detect  = (i_mac_inframe[0]==1'b0) && (seg_inframe[0]==1'b0);  
    end else begin: WORDS_more
        assign i_seg_pkt_boundary = {i_mac_inframe[WORDS-2:0], seg_inframe[WORDS-1]} ^ i_mac_inframe;
        assign i_idle_detect  = (i_mac_inframe[WORDS-1:0]=={WORDS{1'b0}}) && (seg_inframe[WORDS-1]==1'b0) & i_mac_valid;  
    end
endgenerate

assign i_seg_sop = i_seg_pkt_boundary & i_mac_inframe;
assign i_seg_eop = i_seg_pkt_boundary & (~i_mac_inframe);

//---------------------------------------------------------------
genvar i; 
generate 
    if (CLIENT_IF_TYPE == 1) begin:AVST
        logic [MEM_WIDTH_CTRL-1:0] avst_ctrl;
        assign dcfifo_write_ctrl  = avst_ctrl;
        assign dcfifo_write_data  = avst_data;
        assign dcfifo_write_vld   = avst_valid;
        assign dcfifo_idle_ctrl   = 1'b0;
        always_comb begin:avst_interface
            avst_ctrl                                 = '0; //tie off unused
            avst_ctrl[AVST_SOP_POS]                   = avst_sop;
            avst_ctrl[AVST_EOP_POS]                   = avst_eop;
            avst_ctrl[AVST_ERR_POS]                   = |avst_error;
            avst_ctrl[AVST_SKIP_CRC_POS]              = 1'b0;
            avst_ctrl[AVST_EMPTY_POS +: EMPTY_WIDTH]  = avst_empty;
        end:avst_interface
    end // AVST
    else if (CLIENT_IF_TYPE == 0) begin:SEG
        logic [MEM_WIDTH_CTRL-1:0] mac_seg_ctrl;
        assign dcfifo_write_ctrl  = mac_seg_ctrl;
        assign dcfifo_write_data  = seg_data;
        assign dcfifo_write_vld   = seg_valid;
        assign dcfifo_idle_ctrl   = idle_detect;
        always_comb begin:mac_seg_interface
            mac_seg_ctrl                                 = '0; //tie off unused
            mac_seg_ctrl[SEG_SOP_POS]                    = |seg_sop;
            mac_seg_ctrl[SEG_EOP_POS]                    = |seg_eop;
            mac_seg_ctrl[SEG_SKIP_CRC_POS]               = 1'b0;
            mac_seg_ctrl[SEG_INFRAME_POS +: WORDS]       = seg_inframe;
            mac_seg_ctrl[SEG_EOP_EMPTY_POS +: (WORDS*3)] = seg_eop_empty;
            for (int i=0; i<2*WORDS; i=i+2) begin:ERR_2_TO_1
               mac_seg_ctrl[SEG_ERROR_POS + i/2]          = seg_error[i] | seg_error[i+1];
            end // ERR_2_TO_1
        end:mac_seg_interface
    end // SEG
    else begin:PCS_MODES
        assign dcfifo_write_ctrl = 'b0;
        assign dcfifo_write_data = 'b0; 
        assign dcfifo_write_vld  = 1'b0;
        assign dcfifo_idle_ctrl  = 1'b0;
    end //PCS_MODES
endgenerate

//---------------------------------------------------------------
always @ (posedge i_clk_w) begin
    dcfifo_write_ctrl_r    <= dcfifo_write_ctrl;
    dcfifo_write_data_r    <= dcfifo_write_data;
    dcfifo_write_vld_r     <= dcfifo_write_vld;
    dcfifo_idle_ctrl_r     <= dcfifo_idle_ctrl;
end

    
//---------------------------------------------------------------
    eth_f_reset_synchronizer reset_sync_read (
        .clk       (i_clk_r),
        .aclr      (i_arst),
        .aclr_sync (r_reset)
    );

    eth_f_loopback_fifo #(
        .DATA_BCNT        (DATA_BCNT),
        .CTRL_BCNT        (CTRL_BCNT),
        .FIFO_ADDR_WIDTH  (FIFO_ADDR_WIDTH),
        .SEG_INFRAME_POS  (SEG_INFRAME_POS),
        .WORDS            (WORDS),
        .CLIENT_IF_TYPE   (CLIENT_IF_TYPE),
        .SIM_EMULATE      (SIM_EMULATE),
	.INIT_FILE_DATA(INIT_FILE_DATA)
    ) eth_f_loopback_fifo (
        .i_arst     (i_arst),
        .i_clk_w    (i_clk_w),
        .i_data     (dcfifo_write_data_r),
        .i_ctrl     (dcfifo_write_ctrl_r),
        .i_valid    (dcfifo_write_vld_r),
        .i_idle     (dcfifo_idle_ctrl_r),
        .i_clk_r    (i_clk_r),
        .i_read_req (i_tx_req),
        .o_data     (o_tx_data),
        .o_ctrl     (o_tx_ctrl),
        .o_valid    (o_tx_data_vld),

        .stat_cnt_clr     (stat_rx_cnt_clr),
        .o_wr_full_err    (o_wr_full_err),
        .o_rd_empty_err   (o_rd_empty_err)
    );

//---------------------------------------------------------------

logic [7:0] stat_rx_err_cnt_t;

generate if (ENABLE_PTP == 0 & ENA_CRC_GAP_DA == 1) begin : ENA_RX_CRC_GAP_DA

if (CLIENT_IF_TYPE == 0) begin: SEG_CRC32_RX_CHK

logic [7:0] stat_seg_err_cnt;

eth_f_seg_crc_rx_chk #(
    .NUM_SEG(WORDS)
) chk_crc32 (
    .clk(i_clk_r),
    .rst(i_arst),
    .ena(cfg_rom_crc_ena),
    .i_data(i_mac_data),
    .i_empty(i_mac_eop_empty),
    .i_inframe(i_mac_inframe),
    .i_vld(i_mac_valid),
    .stat_err_cnt(stat_seg_err_cnt)
);

always @(posedge i_clk_r) stat_rx_err_cnt <= stat_seg_err_cnt + stat_rx_err_cnt_t;
end
else if (CLIENT_IF_TYPE == 1) begin: AvST_CRC32_RX_CHK

logic [7:0] stat_avst_err_cnt;

eth_f_avst_crc_rx_chk #(
    .WORDS(WORDS),
    .EMPTY_WIDTH(EMPTY_WIDTH)
) chk_crc32 (
    .clk(i_clk_r),
    .rst(i_arst),
    .ena(cfg_rom_crc_ena),
    .i_data(i_data),
    .i_empty(i_empty),
    .i_sop(i_sop),
    .i_eop(i_eop),
    .i_vld(i_valid),
    .stat_err_cnt(stat_avst_err_cnt)
);

always @(posedge i_clk_r) stat_rx_err_cnt <= stat_avst_err_cnt + stat_rx_err_cnt_t;
end
end

else begin
assign stat_rx_err_cnt = stat_rx_err_cnt_t;
end
endgenerate

eth_f_pkt_stat_counter stat_counter (
        .i_clk            (i_clk_r),
        .i_rst            (i_arst),

        //---MAC AVST---
        .i_valid          (i_valid),
        .i_sop            (i_sop),
        .i_eop            (i_eop),
        .i_error          (i_error),

        //---MAC segmented---
        .i_mac_valid      (i_mac_valid),
        .i_mac_inframe    (i_mac_inframe),
        .i_mac_error      (i_mac_error),
  //    .i_mac_fcs_error  (i_mac_fcs_error),

        //---csr interface---
        .stat_cnt_clr        (stat_rx_cnt_clr),
		  .stat_lat_sop        (stat_rx_lat_sop),
        .stat_cnt_vld        (stat_rx_cnt_vld),
        .stat_sop_cnt        (stat_rx_sop_cnt),
        .stat_eop_cnt        (stat_rx_eop_cnt),
        .stat_err_cnt        (stat_rx_err_cnt_t)
);
defparam    stat_counter.CLIENT_IF_TYPE     = CLIENT_IF_TYPE;
defparam    stat_counter.WORDS              = WORDS;
defparam    stat_counter.AVST_ERR_WIDTH     = 6;
defparam    stat_counter.SEG_ERR_WIDTH      = 2*WORDS;

//---------------------------------------------------------------
endmodule
