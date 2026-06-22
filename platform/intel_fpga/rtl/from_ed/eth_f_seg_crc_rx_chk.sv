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


`timescale 1 ps / 1 ps

module eth_f_seg_crc_rx_chk #(
    parameter NUM_SEG         = 16,
    parameter SEG_LEN         = 64,
    parameter EMPTY_WIDTH     = 3
)
  (
    input  logic                                clk,
    input  logic                                rst,
    input  logic                                ena,
    input  logic [NUM_SEG-1:0][SEG_LEN-1:0]     i_data,
    input  logic [NUM_SEG-1:0][EMPTY_WIDTH-1:0] i_empty,
    input  logic [NUM_SEG-1:0]                  i_inframe,
    input  logic                                i_vld,

    output logic [7:0]                          stat_err_cnt

   );

    localparam BYTE_CNT     = NUM_SEG*8;
    localparam SEG_BYTE_CNT = SEG_LEN/8;
    localparam BIT_CNT      = NUM_SEG*64;
    localparam CRC_LEN      = 32;

    logic sop_r1, eop_r1, sop_r2, eop_r2, p_inframe, cnt_vld, p_vld, eop_r3;
    logic [SEG_LEN-1:0] prev_last_seg;
    logic [SEG_LEN-1:0] [CRC_LEN-1:0] cal_crc32_poly;
    logic [NUM_SEG:0] inframe_t;
    logic [CRC_LEN-1:0] crc32_poly_reg, crc32_out, crc32_out_w, crc_in, crc_in_h, crc_in_l, crc_in_full,
            crc_in_h_t, crc_in_l_t, crc_in_full_t, crc_in_prev_seg, crc_in_pad_cur, crc_in_t;
    logic [SEG_LEN-1:0] data_pad_zero, crc_in_pad, data_xor_f, data_xor_f_reg, data_xor_r2, data_xor_t;
    logic [7:0] stat_err_cnt_t;
    logic [3:0] clk_cnt;
    logic [NUM_SEG-1:0] eop_ar_w, sop_ar_w;
    logic [NUM_SEG-1:0][$clog2(NUM_SEG):0] pos_ar_w;
    logic [$clog2(NUM_SEG):0] pos_eop1, pos_eop_t, pos_eop2, pos_eop_f, pos_eop_r2;
    logic [NUM_SEG-1:0][SEG_LEN-1:0] data_vld_i_w, data_r1, data_r2, data_r3;
    logic [NUM_SEG-1:0][EMPTY_WIDTH-1:0] empty_r1, empty_r2, empty_r3;
    logic [NUM_SEG-1:0] inframe_r1;
    logic [3:0][$clog2(NUM_SEG):0] pos_eop_w, pos_eop_r1;
    logic [3:0][SEG_LEN-1:0] data_xor_w, data_xor_r1;

    
    always_ff @(posedge clk) begin 
        if (rst) begin
            stat_err_cnt_t  <= '0;
            cnt_vld         <= '0;
            prev_last_seg   <= '0;
            data_r1         <= '0;
            data_r2         <= '0;
            data_r3         <= '0;
            empty_r1        <= '0;
            empty_r2        <= '0;
            empty_r3        <= '0;
            inframe_r1      <= '0;
            p_inframe       <= '0;
            crc32_out       <= '1;
            pos_eop1        <= '0;
            pos_eop2        <= '0;
            data_xor_r2     <= '0;
            eop_r1          <= '0;
            sop_r1          <= '0;
            eop_r2          <= '0;
            sop_r2          <= '0;
            crc_in          <= '0;
            pos_eop_r1      <= '0;
            pos_eop_r2      <= '0;
            data_xor_r1     <= '0;
        end
        else if (i_vld) begin
            prev_last_seg   <= data_r3[NUM_SEG-1];
            p_inframe       <= inframe_r1[NUM_SEG-1];
            data_r1         <= i_data;
            data_r2         <= data_r1;
            data_r3         <= data_r2;
            inframe_r1      <= i_inframe;
            empty_r1        <= i_empty;
            empty_r2        <= empty_r1;
            empty_r3        <= empty_r2;
            crc32_out       <= crc32_out_w;
            eop_r1          <= |eop_ar_w;
            eop_r2          <= eop_r1;
            sop_r1          <= |sop_ar_w;
            sop_r2          <= sop_r1;
            pos_eop1        <= pos_eop_t;
            pos_eop2        <= pos_eop1;
            data_xor_r2     <= data_xor_f;
            crc_in          <= crc_in_t;
            pos_eop_r1      <= pos_eop_w;
            pos_eop_r2      <= pos_eop_f;
            data_xor_r1     <= data_xor_w;
            eop_r3          <= eop_r2;
            cnt_vld         <= eop_r3;
        if (cnt_vld & ena)
            stat_err_cnt_t  <= stat_err_cnt_t + ((|(crc32_out^crc_in))? 1'b1 : 1'b0);
    end
    end

    always_ff @(posedge clk) begin
        if (rst)    clk_cnt <= 4'b0;
        else        clk_cnt <= clk_cnt + 4'b1;
    end

    always_ff @(posedge clk) begin
        if (rst)    stat_err_cnt <= 0;
        else if (&clk_cnt)  stat_err_cnt <= stat_err_cnt_t;
    end
    
// get previous inframe last bit
    assign inframe_t = {inframe_r1,p_inframe};

// store valid data, find sop, eop
    genvar seg;
    generate
    for (seg=0; seg<NUM_SEG; seg++) begin: SEG_ITERATE
        always_comb begin
            eop_ar_w[seg]       = '0;
            sop_ar_w[seg]       = '0;
            pos_ar_w[seg]       = '0;
            data_vld_i_w[seg]   = '0;
            if (inframe_t[seg] & !inframe_t[seg+1] & i_vld) begin
                eop_ar_w[seg]     = 1'b1;
                pos_ar_w[seg]     = seg;
            end
            else if (!inframe_t[seg] & inframe_t[seg+1] & i_vld) begin
                sop_ar_w[seg]     = 1'b1;
                data_vld_i_w[seg] = data_r1[seg];
            end
            else if (inframe_r1[seg] & i_vld)
                data_vld_i_w[seg]   = data_r1[seg];
        end
    end

    if (NUM_SEG == 16) begin : XOR_400G
    always_comb begin
        pos_eop_w   = '0;
        data_xor_w  = '0;
        if (i_vld) begin
            pos_eop_w[0]   = pos_ar_w[0] ^ pos_ar_w[1] ^ pos_ar_w[2] ^ pos_ar_w[3];
            data_xor_w[0]  = data_vld_i_w[0] ^ data_vld_i_w[1] ^ data_vld_i_w[2] ^ data_vld_i_w[3];
            pos_eop_w[1]   = pos_ar_w[4] ^ pos_ar_w[5] ^ pos_ar_w[6] ^ pos_ar_w[7];
            data_xor_w[1]  = data_vld_i_w[4] ^ data_vld_i_w[5] ^ data_vld_i_w[6] ^ data_vld_i_w[7];
            pos_eop_w[2]   = pos_ar_w[8] ^ pos_ar_w[9] ^ pos_ar_w[10] ^ pos_ar_w[11];
            data_xor_w[2]  = data_vld_i_w[8] ^ data_vld_i_w[9] ^ data_vld_i_w[10] ^ data_vld_i_w[11];
            pos_eop_w[3]   = pos_ar_w[12] ^ pos_ar_w[13] ^ pos_ar_w[14] ^ pos_ar_w[15];
            data_xor_w[3]  = data_vld_i_w[12] ^ data_vld_i_w[13] ^ data_vld_i_w[14] ^ data_vld_i_w[15];
        end 
    end
    end
    else if (NUM_SEG == 8) begin : XOR_200G
    always_comb begin
        pos_eop_w   = '0;
        data_xor_w  = '0;
        if (i_vld) begin
            pos_eop_w[0]   = pos_ar_w[0] ^ pos_ar_w[1] ^ pos_ar_w[2] ^ pos_ar_w[3];
            data_xor_w[0]  = data_vld_i_w[0] ^ data_vld_i_w[1] ^ data_vld_i_w[2] ^ data_vld_i_w[3];
            pos_eop_w[1]   = pos_ar_w[4] ^ pos_ar_w[5] ^ pos_ar_w[6] ^ pos_ar_w[7];
            data_xor_w[1]  = data_vld_i_w[4] ^ data_vld_i_w[5] ^ data_vld_i_w[6] ^ data_vld_i_w[7];
        end 
    end
    end
    else if (NUM_SEG == 4) begin : XOR_100G
    always_comb begin
        pos_eop_w   = '0;
        data_xor_w  = '0;
        if (i_vld) begin
            pos_eop_w[0]   = pos_ar_w[0] ^ pos_ar_w[1] ^ pos_ar_w[2] ^ pos_ar_w[3];
            data_xor_w[0]  = data_vld_i_w[0] ^ data_vld_i_w[1] ^ data_vld_i_w[2] ^ data_vld_i_w[3];
        end
    end
    end
    else if(NUM_SEG == 2) begin : XOR_40G50G
    always_comb begin
        pos_eop_w   = '0;
        data_xor_w  = '0;
        if (i_vld) begin
            pos_eop_w[0]   = pos_ar_w[0] ^ pos_ar_w[1];
            data_xor_w[0]  = data_vld_i_w[0] ^ data_vld_i_w[1];
        end
    end
    end
    else begin : XOR_10G25G
    always_comb begin
        pos_eop_w   = '0;
        data_xor_w  = '0;
        if (i_vld) begin
            pos_eop_w[0]   = pos_ar_w[0];
            data_xor_w[0]  = data_vld_i_w[0];
        end
    end
    end
    
    //for 3rd cycle
    case(NUM_SEG)
    8: begin
    assign data_xor_f   = data_xor_r1[0] ^ data_xor_r1[1];
    assign pos_eop_f    = pos_eop_r1[0] ^ pos_eop_r1[1];
    end 
    16: begin
    assign data_xor_f   = data_xor_r1[0] ^ data_xor_r1[1] ^ data_xor_r1[2] ^ data_xor_r1[3];
    assign pos_eop_f    = pos_eop_r1[0] ^ pos_eop_r1[1] ^ pos_eop_r1[2] ^ pos_eop_r1[3];
    end   
    default :   begin
    assign pos_eop_f    = pos_eop_r1[0];
    assign data_xor_f   = data_xor_r1[0];
    end
    endcase
    endgenerate

// fetch incoming crc
    always_ff @(posedge clk) begin
        if (rst)
            crc_in_t <= '0;
        else if (i_vld & eop_r2)   
            case (empty_r3[pos_eop_r2]) 
                3'd0 : crc_in_t <=  data_r3[pos_eop_r2][63-:32];
                3'd1 : crc_in_t <=  data_r3[pos_eop_r2][55-:32];
                3'd2 : crc_in_t <=  data_r3[pos_eop_r2][47-:32];
                3'd3 : crc_in_t <=  data_r3[pos_eop_r2][39-:32];
                3'd4 : crc_in_t <=  data_r3[pos_eop_r2][31:0];
                3'd5 : crc_in_t <=  {data_r3[pos_eop_r2][23:0], ((|pos_eop_r2)? data_r3[pos_eop_r2-1'b1][(SEG_LEN-1)-:8] : prev_last_seg[(SEG_LEN-1)-:8])};
                3'd6 : crc_in_t <=  {data_r3[pos_eop_r2][15:0], ((|pos_eop_r2)? data_r3[pos_eop_r2-1'b1][(SEG_LEN-1)-:16] : prev_last_seg[(SEG_LEN-1)-:16])};
                3'd7 : crc_in_t <=  {data_r3[pos_eop_r2][7:0], ((|pos_eop_r2)? data_r3[pos_eop_r2-1'b1][(SEG_LEN-1)-:24] : prev_last_seg[(SEG_LEN-1)-:24])};
            endcase
    end


// remove crc to cleanup data when eop comes
    always_ff @(posedge clk) begin
        if (rst) data_xor_f_reg <= '0;
        if (i_vld) begin
            case ({sop_r2,eop_r2})
                2'b00 : data_xor_f_reg <= data_xor_f_reg ^ data_xor_r2;
                2'b01 : begin
                    case (empty_r3[pos_eop_r2])
                        3'd0 : data_xor_f_reg <=  data_xor_r2 ^ {32'b0, data_r3[pos_eop_r2][31:0]} ^ data_xor_f_reg;
                        3'd1 : data_xor_f_reg <=  data_xor_r2 ^ {40'b0, data_r3[pos_eop_r2][23:0]} ^ data_xor_f_reg;
                        3'd2 : data_xor_f_reg <=  data_xor_r2 ^ {48'b0, data_r3[pos_eop_r2][15:0]} ^ data_xor_f_reg;
                        3'd3 : data_xor_f_reg <=  data_xor_r2 ^ {56'b0, data_r3[pos_eop_r2][7:0]} ^ data_xor_f_reg;
                        3'd4 : data_xor_f_reg <=  (|pos_eop_r2)? data_xor_r2 ^ data_xor_f_reg : data_xor_f_reg;
                        3'd5 : data_xor_f_reg <=  (|pos_eop_r2)? data_xor_r2 ^ data_r3[pos_eop_r2-1'b1] ^ {8'b0, data_r3[pos_eop_r2-1'b1][55:0]} ^ data_xor_f_reg :data_xor_f_reg ^ prev_last_seg ^ {8'b0,prev_last_seg[55:0]};
                        3'd6 : data_xor_f_reg <=  (|pos_eop_r2)? data_xor_r2 ^ data_r3[pos_eop_r2-1'b1] ^ {16'b0, data_r3[pos_eop_r2-1'b1][47:0]} ^ data_xor_f_reg :data_xor_f_reg ^ prev_last_seg ^ {16'b0,prev_last_seg[47:0]};
                        3'd7 : data_xor_f_reg <=  (|pos_eop_r2)? data_xor_r2 ^ data_r3[pos_eop_r2-1'b1] ^ {24'b0, data_r3[pos_eop_r2-1'b1][39:0]} ^ data_xor_f_reg :data_xor_f_reg ^ prev_last_seg ^ {24'b0,prev_last_seg[39:0]};
                    endcase
                end
                2'b10 : data_xor_f_reg <= data_xor_r2;
                2'b11 : begin
                    case (empty_r3[pos_eop_r2])
                        3'd0 : data_xor_f_reg <=  data_xor_r2 ^ {32'b0, data_r3[pos_eop_r2][31:0]};
                        3'd1 : data_xor_f_reg <=  data_xor_r2 ^ {40'b0, data_r3[pos_eop_r2][23:0]};
                        3'd2 : data_xor_f_reg <=  data_xor_r2 ^ {48'b0, data_r3[pos_eop_r2][15:0]};
                        3'd3 : data_xor_f_reg <=  data_xor_r2 ^ {56'b0, data_r3[pos_eop_r2][7:0]};
                        3'd4 : data_xor_f_reg <=  data_xor_r2;
                        3'd5 : data_xor_f_reg <=  data_xor_r2 ^ data_r3[pos_eop_r2-1'b1] ^ {8'b0, data_r3[pos_eop_r2-1'b1][55:0]};
                        3'd6 : data_xor_f_reg <=  data_xor_r2 ^ data_r3[pos_eop_r2-1'b1] ^ {16'b0, data_r3[pos_eop_r2-1'b1][47:0]};
                        3'd7 : data_xor_f_reg <=  data_xor_r2 ^ data_r3[pos_eop_r2-1'b1] ^ {24'b0, data_r3[pos_eop_r2-1'b1][39:0]};
                    endcase
                end
            endcase
        end
    end



 
// calculate crc based on CRC-32/MPEG-2 - https://crccalc.com/
    always @(*) begin
        crc32_out_w[0] = 1 ^ data_xor_f_reg[0] ^ data_xor_f_reg[6] ^ data_xor_f_reg[9] ^ data_xor_f_reg[10] ^ data_xor_f_reg[12] ^ data_xor_f_reg[16] ^ data_xor_f_reg[24] ^ data_xor_f_reg[25] ^ data_xor_f_reg[26] ^ data_xor_f_reg[28] ^ data_xor_f_reg[29] ^ data_xor_f_reg[30] ^ data_xor_f_reg[31] ^ data_xor_f_reg[32] ^ data_xor_f_reg[34] ^ data_xor_f_reg[37] ^ data_xor_f_reg[44] ^ data_xor_f_reg[45] ^ data_xor_f_reg[47] ^ data_xor_f_reg[48] ^ data_xor_f_reg[50] ^ data_xor_f_reg[53] ^ data_xor_f_reg[54] ^ data_xor_f_reg[55] ^ data_xor_f_reg[58] ^ data_xor_f_reg[60] ^ data_xor_f_reg[61] ^ data_xor_f_reg[63];
        crc32_out_w[1] = 0 ^ data_xor_f_reg[0] ^ data_xor_f_reg[1] ^ data_xor_f_reg[6] ^ data_xor_f_reg[7] ^ data_xor_f_reg[9] ^ data_xor_f_reg[11] ^ data_xor_f_reg[12] ^ data_xor_f_reg[13] ^ data_xor_f_reg[16] ^ data_xor_f_reg[17] ^ data_xor_f_reg[24] ^ data_xor_f_reg[27] ^ data_xor_f_reg[28] ^ data_xor_f_reg[33] ^ data_xor_f_reg[34] ^ data_xor_f_reg[35] ^ data_xor_f_reg[37] ^ data_xor_f_reg[38] ^ data_xor_f_reg[44] ^ data_xor_f_reg[46] ^ data_xor_f_reg[47] ^ data_xor_f_reg[49] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[53] ^ data_xor_f_reg[56] ^ data_xor_f_reg[58] ^ data_xor_f_reg[59] ^ data_xor_f_reg[60] ^ data_xor_f_reg[62] ^ data_xor_f_reg[63];
        crc32_out_w[2] = 0 ^ data_xor_f_reg[0] ^ data_xor_f_reg[1] ^ data_xor_f_reg[2] ^ data_xor_f_reg[6] ^ data_xor_f_reg[7] ^ data_xor_f_reg[8] ^ data_xor_f_reg[9] ^ data_xor_f_reg[13] ^ data_xor_f_reg[14] ^ data_xor_f_reg[16] ^ data_xor_f_reg[17] ^ data_xor_f_reg[18] ^ data_xor_f_reg[24] ^ data_xor_f_reg[26] ^ data_xor_f_reg[30] ^ data_xor_f_reg[31] ^ data_xor_f_reg[32] ^ data_xor_f_reg[35] ^ data_xor_f_reg[36] ^ data_xor_f_reg[37] ^ data_xor_f_reg[38] ^ data_xor_f_reg[39] ^ data_xor_f_reg[44] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[53] ^ data_xor_f_reg[55] ^ data_xor_f_reg[57] ^ data_xor_f_reg[58] ^ data_xor_f_reg[59];
        crc32_out_w[3] = 1 ^ data_xor_f_reg[1] ^ data_xor_f_reg[2] ^ data_xor_f_reg[3] ^ data_xor_f_reg[7] ^ data_xor_f_reg[8] ^ data_xor_f_reg[9] ^ data_xor_f_reg[10] ^ data_xor_f_reg[14] ^ data_xor_f_reg[15] ^ data_xor_f_reg[17] ^ data_xor_f_reg[18] ^ data_xor_f_reg[19] ^ data_xor_f_reg[25] ^ data_xor_f_reg[27] ^ data_xor_f_reg[31] ^ data_xor_f_reg[32] ^ data_xor_f_reg[33] ^ data_xor_f_reg[36] ^ data_xor_f_reg[37] ^ data_xor_f_reg[38] ^ data_xor_f_reg[39] ^ data_xor_f_reg[40] ^ data_xor_f_reg[45] ^ data_xor_f_reg[52] ^ data_xor_f_reg[53] ^ data_xor_f_reg[54] ^ data_xor_f_reg[56] ^ data_xor_f_reg[58] ^ data_xor_f_reg[59] ^ data_xor_f_reg[60];
        crc32_out_w[4] = 1 ^ data_xor_f_reg[0] ^ data_xor_f_reg[2] ^ data_xor_f_reg[3] ^ data_xor_f_reg[4] ^ data_xor_f_reg[6] ^ data_xor_f_reg[8] ^ data_xor_f_reg[11] ^ data_xor_f_reg[12] ^ data_xor_f_reg[15] ^ data_xor_f_reg[18] ^ data_xor_f_reg[19] ^ data_xor_f_reg[20] ^ data_xor_f_reg[24] ^ data_xor_f_reg[25] ^ data_xor_f_reg[29] ^ data_xor_f_reg[30] ^ data_xor_f_reg[31] ^ data_xor_f_reg[33] ^ data_xor_f_reg[38] ^ data_xor_f_reg[39] ^ data_xor_f_reg[40] ^ data_xor_f_reg[41] ^ data_xor_f_reg[44] ^ data_xor_f_reg[45] ^ data_xor_f_reg[46] ^ data_xor_f_reg[47] ^ data_xor_f_reg[48] ^ data_xor_f_reg[50] ^ data_xor_f_reg[57] ^ data_xor_f_reg[58] ^ data_xor_f_reg[59] ^ data_xor_f_reg[63];
        crc32_out_w[5] = 0 ^ data_xor_f_reg[0] ^ data_xor_f_reg[1] ^ data_xor_f_reg[3] ^ data_xor_f_reg[4] ^ data_xor_f_reg[5] ^ data_xor_f_reg[6] ^ data_xor_f_reg[7] ^ data_xor_f_reg[10] ^ data_xor_f_reg[13] ^ data_xor_f_reg[19] ^ data_xor_f_reg[20] ^ data_xor_f_reg[21] ^ data_xor_f_reg[24] ^ data_xor_f_reg[28] ^ data_xor_f_reg[29] ^ data_xor_f_reg[37] ^ data_xor_f_reg[39] ^ data_xor_f_reg[40] ^ data_xor_f_reg[41] ^ data_xor_f_reg[42] ^ data_xor_f_reg[44] ^ data_xor_f_reg[46] ^ data_xor_f_reg[49] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[53] ^ data_xor_f_reg[54] ^ data_xor_f_reg[55] ^ data_xor_f_reg[59] ^ data_xor_f_reg[61] ^ data_xor_f_reg[63];
        crc32_out_w[6] = 1 ^ data_xor_f_reg[1] ^ data_xor_f_reg[2] ^ data_xor_f_reg[4] ^ data_xor_f_reg[5] ^ data_xor_f_reg[6] ^ data_xor_f_reg[7] ^ data_xor_f_reg[8] ^ data_xor_f_reg[11] ^ data_xor_f_reg[14] ^ data_xor_f_reg[20] ^ data_xor_f_reg[21] ^ data_xor_f_reg[22] ^ data_xor_f_reg[25] ^ data_xor_f_reg[29] ^ data_xor_f_reg[30] ^ data_xor_f_reg[38] ^ data_xor_f_reg[40] ^ data_xor_f_reg[41] ^ data_xor_f_reg[42] ^ data_xor_f_reg[43] ^ data_xor_f_reg[45] ^ data_xor_f_reg[47] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[54] ^ data_xor_f_reg[55] ^ data_xor_f_reg[56] ^ data_xor_f_reg[60] ^ data_xor_f_reg[62];
        crc32_out_w[7] = 0 ^ data_xor_f_reg[0] ^ data_xor_f_reg[2] ^ data_xor_f_reg[3] ^ data_xor_f_reg[5] ^ data_xor_f_reg[7] ^ data_xor_f_reg[8] ^ data_xor_f_reg[10] ^ data_xor_f_reg[15] ^ data_xor_f_reg[16] ^ data_xor_f_reg[21] ^ data_xor_f_reg[22] ^ data_xor_f_reg[23] ^ data_xor_f_reg[24] ^ data_xor_f_reg[25] ^ data_xor_f_reg[28] ^ data_xor_f_reg[29] ^ data_xor_f_reg[32] ^ data_xor_f_reg[34] ^ data_xor_f_reg[37] ^ data_xor_f_reg[39] ^ data_xor_f_reg[41] ^ data_xor_f_reg[42] ^ data_xor_f_reg[43] ^ data_xor_f_reg[45] ^ data_xor_f_reg[46] ^ data_xor_f_reg[47] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[54] ^ data_xor_f_reg[56] ^ data_xor_f_reg[57] ^ data_xor_f_reg[58] ^ data_xor_f_reg[60];
        crc32_out_w[8] = 1 ^ data_xor_f_reg[0] ^ data_xor_f_reg[1] ^ data_xor_f_reg[3] ^ data_xor_f_reg[4] ^ data_xor_f_reg[8] ^ data_xor_f_reg[10] ^ data_xor_f_reg[11] ^ data_xor_f_reg[12] ^ data_xor_f_reg[17] ^ data_xor_f_reg[22] ^ data_xor_f_reg[23] ^ data_xor_f_reg[28] ^ data_xor_f_reg[31] ^ data_xor_f_reg[32] ^ data_xor_f_reg[33] ^ data_xor_f_reg[34] ^ data_xor_f_reg[35] ^ data_xor_f_reg[37] ^ data_xor_f_reg[38] ^ data_xor_f_reg[40] ^ data_xor_f_reg[42] ^ data_xor_f_reg[43] ^ data_xor_f_reg[45] ^ data_xor_f_reg[46] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[54] ^ data_xor_f_reg[57] ^ data_xor_f_reg[59] ^ data_xor_f_reg[60] ^ data_xor_f_reg[63];
        crc32_out_w[9] = 1 ^ data_xor_f_reg[1] ^ data_xor_f_reg[2] ^ data_xor_f_reg[4] ^ data_xor_f_reg[5] ^ data_xor_f_reg[9] ^ data_xor_f_reg[11] ^ data_xor_f_reg[12] ^ data_xor_f_reg[13] ^ data_xor_f_reg[18] ^ data_xor_f_reg[23] ^ data_xor_f_reg[24] ^ data_xor_f_reg[29] ^ data_xor_f_reg[32] ^ data_xor_f_reg[33] ^ data_xor_f_reg[34] ^ data_xor_f_reg[35] ^ data_xor_f_reg[36] ^ data_xor_f_reg[38] ^ data_xor_f_reg[39] ^ data_xor_f_reg[41] ^ data_xor_f_reg[43] ^ data_xor_f_reg[44] ^ data_xor_f_reg[46] ^ data_xor_f_reg[47] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[53] ^ data_xor_f_reg[55] ^ data_xor_f_reg[58] ^ data_xor_f_reg[60] ^ data_xor_f_reg[61];
        crc32_out_w[10] = 0 ^ data_xor_f_reg[0] ^ data_xor_f_reg[2] ^ data_xor_f_reg[3] ^ data_xor_f_reg[5] ^ data_xor_f_reg[9] ^ data_xor_f_reg[13] ^ data_xor_f_reg[14] ^ data_xor_f_reg[16] ^ data_xor_f_reg[19] ^ data_xor_f_reg[26] ^ data_xor_f_reg[28] ^ data_xor_f_reg[29] ^ data_xor_f_reg[31] ^ data_xor_f_reg[32] ^ data_xor_f_reg[33] ^ data_xor_f_reg[35] ^ data_xor_f_reg[36] ^ data_xor_f_reg[39] ^ data_xor_f_reg[40] ^ data_xor_f_reg[42] ^ data_xor_f_reg[50] ^ data_xor_f_reg[52] ^ data_xor_f_reg[55] ^ data_xor_f_reg[56] ^ data_xor_f_reg[58] ^ data_xor_f_reg[59] ^ data_xor_f_reg[60] ^ data_xor_f_reg[62] ^ data_xor_f_reg[63];
        crc32_out_w[11] = 1 ^ data_xor_f_reg[0] ^ data_xor_f_reg[1] ^ data_xor_f_reg[3] ^ data_xor_f_reg[4] ^ data_xor_f_reg[9] ^ data_xor_f_reg[12] ^ data_xor_f_reg[14] ^ data_xor_f_reg[15] ^ data_xor_f_reg[16] ^ data_xor_f_reg[17] ^ data_xor_f_reg[20] ^ data_xor_f_reg[24] ^ data_xor_f_reg[25] ^ data_xor_f_reg[26] ^ data_xor_f_reg[27] ^ data_xor_f_reg[28] ^ data_xor_f_reg[31] ^ data_xor_f_reg[33] ^ data_xor_f_reg[36] ^ data_xor_f_reg[40] ^ data_xor_f_reg[41] ^ data_xor_f_reg[43] ^ data_xor_f_reg[44] ^ data_xor_f_reg[45] ^ data_xor_f_reg[47] ^ data_xor_f_reg[48] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[54] ^ data_xor_f_reg[55] ^ data_xor_f_reg[56] ^ data_xor_f_reg[57] ^ data_xor_f_reg[58] ^ data_xor_f_reg[59];
        crc32_out_w[12] = 1 ^ data_xor_f_reg[0] ^ data_xor_f_reg[1] ^ data_xor_f_reg[2] ^ data_xor_f_reg[4] ^ data_xor_f_reg[5] ^ data_xor_f_reg[6] ^ data_xor_f_reg[9] ^ data_xor_f_reg[12] ^ data_xor_f_reg[13] ^ data_xor_f_reg[15] ^ data_xor_f_reg[17] ^ data_xor_f_reg[18] ^ data_xor_f_reg[21] ^ data_xor_f_reg[24] ^ data_xor_f_reg[27] ^ data_xor_f_reg[30] ^ data_xor_f_reg[31] ^ data_xor_f_reg[41] ^ data_xor_f_reg[42] ^ data_xor_f_reg[46] ^ data_xor_f_reg[47] ^ data_xor_f_reg[49] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[53] ^ data_xor_f_reg[54] ^ data_xor_f_reg[56] ^ data_xor_f_reg[57] ^ data_xor_f_reg[59] ^ data_xor_f_reg[61] ^ data_xor_f_reg[63];
        crc32_out_w[13] = 1 ^ data_xor_f_reg[1] ^ data_xor_f_reg[2] ^ data_xor_f_reg[3] ^ data_xor_f_reg[5] ^ data_xor_f_reg[6] ^ data_xor_f_reg[7] ^ data_xor_f_reg[10] ^ data_xor_f_reg[13] ^ data_xor_f_reg[14] ^ data_xor_f_reg[16] ^ data_xor_f_reg[18] ^ data_xor_f_reg[19] ^ data_xor_f_reg[22] ^ data_xor_f_reg[25] ^ data_xor_f_reg[28] ^ data_xor_f_reg[31] ^ data_xor_f_reg[32] ^ data_xor_f_reg[42] ^ data_xor_f_reg[43] ^ data_xor_f_reg[47] ^ data_xor_f_reg[48] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[53] ^ data_xor_f_reg[54] ^ data_xor_f_reg[55] ^ data_xor_f_reg[57] ^ data_xor_f_reg[58] ^ data_xor_f_reg[60] ^ data_xor_f_reg[62];
        crc32_out_w[14] = 0 ^ data_xor_f_reg[2] ^ data_xor_f_reg[3] ^ data_xor_f_reg[4] ^ data_xor_f_reg[6] ^ data_xor_f_reg[7] ^ data_xor_f_reg[8] ^ data_xor_f_reg[11] ^ data_xor_f_reg[14] ^ data_xor_f_reg[15] ^ data_xor_f_reg[17] ^ data_xor_f_reg[19] ^ data_xor_f_reg[20] ^ data_xor_f_reg[23] ^ data_xor_f_reg[26] ^ data_xor_f_reg[29] ^ data_xor_f_reg[32] ^ data_xor_f_reg[33] ^ data_xor_f_reg[43] ^ data_xor_f_reg[44] ^ data_xor_f_reg[48] ^ data_xor_f_reg[49] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[53] ^ data_xor_f_reg[54] ^ data_xor_f_reg[55] ^ data_xor_f_reg[56] ^ data_xor_f_reg[58] ^ data_xor_f_reg[59] ^ data_xor_f_reg[61] ^ data_xor_f_reg[63];
        crc32_out_w[15] = 1 ^ data_xor_f_reg[3] ^ data_xor_f_reg[4] ^ data_xor_f_reg[5] ^ data_xor_f_reg[7] ^ data_xor_f_reg[8] ^ data_xor_f_reg[9] ^ data_xor_f_reg[12] ^ data_xor_f_reg[15] ^ data_xor_f_reg[16] ^ data_xor_f_reg[18] ^ data_xor_f_reg[20] ^ data_xor_f_reg[21] ^ data_xor_f_reg[24] ^ data_xor_f_reg[27] ^ data_xor_f_reg[30] ^ data_xor_f_reg[33] ^ data_xor_f_reg[34] ^ data_xor_f_reg[44] ^ data_xor_f_reg[45] ^ data_xor_f_reg[49] ^ data_xor_f_reg[50] ^ data_xor_f_reg[52] ^ data_xor_f_reg[53] ^ data_xor_f_reg[54] ^ data_xor_f_reg[55] ^ data_xor_f_reg[56] ^ data_xor_f_reg[57] ^ data_xor_f_reg[59] ^ data_xor_f_reg[60] ^ data_xor_f_reg[62];
        crc32_out_w[16] = 0 ^ data_xor_f_reg[0] ^ data_xor_f_reg[4] ^ data_xor_f_reg[5] ^ data_xor_f_reg[8] ^ data_xor_f_reg[12] ^ data_xor_f_reg[13] ^ data_xor_f_reg[17] ^ data_xor_f_reg[19] ^ data_xor_f_reg[21] ^ data_xor_f_reg[22] ^ data_xor_f_reg[24] ^ data_xor_f_reg[26] ^ data_xor_f_reg[29] ^ data_xor_f_reg[30] ^ data_xor_f_reg[32] ^ data_xor_f_reg[35] ^ data_xor_f_reg[37] ^ data_xor_f_reg[44] ^ data_xor_f_reg[46] ^ data_xor_f_reg[47] ^ data_xor_f_reg[48] ^ data_xor_f_reg[51] ^ data_xor_f_reg[56] ^ data_xor_f_reg[57];
        crc32_out_w[17] = 0 ^ data_xor_f_reg[1] ^ data_xor_f_reg[5] ^ data_xor_f_reg[6] ^ data_xor_f_reg[9] ^ data_xor_f_reg[13] ^ data_xor_f_reg[14] ^ data_xor_f_reg[18] ^ data_xor_f_reg[20] ^ data_xor_f_reg[22] ^ data_xor_f_reg[23] ^ data_xor_f_reg[25] ^ data_xor_f_reg[27] ^ data_xor_f_reg[30] ^ data_xor_f_reg[31] ^ data_xor_f_reg[33] ^ data_xor_f_reg[36] ^ data_xor_f_reg[38] ^ data_xor_f_reg[45] ^ data_xor_f_reg[47] ^ data_xor_f_reg[48] ^ data_xor_f_reg[49] ^ data_xor_f_reg[52] ^ data_xor_f_reg[57] ^ data_xor_f_reg[58];
        crc32_out_w[18] = 1 ^ data_xor_f_reg[2] ^ data_xor_f_reg[6] ^ data_xor_f_reg[7] ^ data_xor_f_reg[10] ^ data_xor_f_reg[14] ^ data_xor_f_reg[15] ^ data_xor_f_reg[19] ^ data_xor_f_reg[21] ^ data_xor_f_reg[23] ^ data_xor_f_reg[24] ^ data_xor_f_reg[26] ^ data_xor_f_reg[28] ^ data_xor_f_reg[31] ^ data_xor_f_reg[32] ^ data_xor_f_reg[34] ^ data_xor_f_reg[37] ^ data_xor_f_reg[39] ^ data_xor_f_reg[46] ^ data_xor_f_reg[48] ^ data_xor_f_reg[49] ^ data_xor_f_reg[50] ^ data_xor_f_reg[53] ^ data_xor_f_reg[58] ^ data_xor_f_reg[59];
        crc32_out_w[19] = 0 ^ data_xor_f_reg[3] ^ data_xor_f_reg[7] ^ data_xor_f_reg[8] ^ data_xor_f_reg[11] ^ data_xor_f_reg[15] ^ data_xor_f_reg[16] ^ data_xor_f_reg[20] ^ data_xor_f_reg[22] ^ data_xor_f_reg[24] ^ data_xor_f_reg[25] ^ data_xor_f_reg[27] ^ data_xor_f_reg[29] ^ data_xor_f_reg[32] ^ data_xor_f_reg[33] ^ data_xor_f_reg[35] ^ data_xor_f_reg[38] ^ data_xor_f_reg[40] ^ data_xor_f_reg[47] ^ data_xor_f_reg[49] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[54] ^ data_xor_f_reg[59] ^ data_xor_f_reg[60];
        crc32_out_w[20] = 0 ^ data_xor_f_reg[4] ^ data_xor_f_reg[8] ^ data_xor_f_reg[9] ^ data_xor_f_reg[12] ^ data_xor_f_reg[16] ^ data_xor_f_reg[17] ^ data_xor_f_reg[21] ^ data_xor_f_reg[23] ^ data_xor_f_reg[25] ^ data_xor_f_reg[26] ^ data_xor_f_reg[28] ^ data_xor_f_reg[30] ^ data_xor_f_reg[33] ^ data_xor_f_reg[34] ^ data_xor_f_reg[36] ^ data_xor_f_reg[39] ^ data_xor_f_reg[41] ^ data_xor_f_reg[48] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[55] ^ data_xor_f_reg[60] ^ data_xor_f_reg[61];
        crc32_out_w[21] = 0 ^ data_xor_f_reg[5] ^ data_xor_f_reg[9] ^ data_xor_f_reg[10] ^ data_xor_f_reg[13] ^ data_xor_f_reg[17] ^ data_xor_f_reg[18] ^ data_xor_f_reg[22] ^ data_xor_f_reg[24] ^ data_xor_f_reg[26] ^ data_xor_f_reg[27] ^ data_xor_f_reg[29] ^ data_xor_f_reg[31] ^ data_xor_f_reg[34] ^ data_xor_f_reg[35] ^ data_xor_f_reg[37] ^ data_xor_f_reg[40] ^ data_xor_f_reg[42] ^ data_xor_f_reg[49] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[53] ^ data_xor_f_reg[56] ^ data_xor_f_reg[61] ^ data_xor_f_reg[62];
        crc32_out_w[22] = 0 ^ data_xor_f_reg[0] ^ data_xor_f_reg[9] ^ data_xor_f_reg[11] ^ data_xor_f_reg[12] ^ data_xor_f_reg[14] ^ data_xor_f_reg[16] ^ data_xor_f_reg[18] ^ data_xor_f_reg[19] ^ data_xor_f_reg[23] ^ data_xor_f_reg[24] ^ data_xor_f_reg[26] ^ data_xor_f_reg[27] ^ data_xor_f_reg[29] ^ data_xor_f_reg[31] ^ data_xor_f_reg[34] ^ data_xor_f_reg[35] ^ data_xor_f_reg[36] ^ data_xor_f_reg[37] ^ data_xor_f_reg[38] ^ data_xor_f_reg[41] ^ data_xor_f_reg[43] ^ data_xor_f_reg[44] ^ data_xor_f_reg[45] ^ data_xor_f_reg[47] ^ data_xor_f_reg[48] ^ data_xor_f_reg[52] ^ data_xor_f_reg[55] ^ data_xor_f_reg[57] ^ data_xor_f_reg[58] ^ data_xor_f_reg[60] ^ data_xor_f_reg[61] ^ data_xor_f_reg[62];
        crc32_out_w[23] = 0 ^ data_xor_f_reg[0] ^ data_xor_f_reg[1] ^ data_xor_f_reg[6] ^ data_xor_f_reg[9] ^ data_xor_f_reg[13] ^ data_xor_f_reg[15] ^ data_xor_f_reg[16] ^ data_xor_f_reg[17] ^ data_xor_f_reg[19] ^ data_xor_f_reg[20] ^ data_xor_f_reg[26] ^ data_xor_f_reg[27] ^ data_xor_f_reg[29] ^ data_xor_f_reg[31] ^ data_xor_f_reg[34] ^ data_xor_f_reg[35] ^ data_xor_f_reg[36] ^ data_xor_f_reg[38] ^ data_xor_f_reg[39] ^ data_xor_f_reg[42] ^ data_xor_f_reg[46] ^ data_xor_f_reg[47] ^ data_xor_f_reg[49] ^ data_xor_f_reg[50] ^ data_xor_f_reg[54] ^ data_xor_f_reg[55] ^ data_xor_f_reg[56] ^ data_xor_f_reg[59] ^ data_xor_f_reg[60] ^ data_xor_f_reg[62];
        crc32_out_w[24] = 1 ^ data_xor_f_reg[1] ^ data_xor_f_reg[2] ^ data_xor_f_reg[7] ^ data_xor_f_reg[10] ^ data_xor_f_reg[14] ^ data_xor_f_reg[16] ^ data_xor_f_reg[17] ^ data_xor_f_reg[18] ^ data_xor_f_reg[20] ^ data_xor_f_reg[21] ^ data_xor_f_reg[27] ^ data_xor_f_reg[28] ^ data_xor_f_reg[30] ^ data_xor_f_reg[32] ^ data_xor_f_reg[35] ^ data_xor_f_reg[36] ^ data_xor_f_reg[37] ^ data_xor_f_reg[39] ^ data_xor_f_reg[40] ^ data_xor_f_reg[43] ^ data_xor_f_reg[47] ^ data_xor_f_reg[48] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[55] ^ data_xor_f_reg[56] ^ data_xor_f_reg[57] ^ data_xor_f_reg[60] ^ data_xor_f_reg[61] ^ data_xor_f_reg[63];
        crc32_out_w[25] = 0 ^ data_xor_f_reg[2] ^ data_xor_f_reg[3] ^ data_xor_f_reg[8] ^ data_xor_f_reg[11] ^ data_xor_f_reg[15] ^ data_xor_f_reg[17] ^ data_xor_f_reg[18] ^ data_xor_f_reg[19] ^ data_xor_f_reg[21] ^ data_xor_f_reg[22] ^ data_xor_f_reg[28] ^ data_xor_f_reg[29] ^ data_xor_f_reg[31] ^ data_xor_f_reg[33] ^ data_xor_f_reg[36] ^ data_xor_f_reg[37] ^ data_xor_f_reg[38] ^ data_xor_f_reg[40] ^ data_xor_f_reg[41] ^ data_xor_f_reg[44] ^ data_xor_f_reg[48] ^ data_xor_f_reg[49] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[56] ^ data_xor_f_reg[57] ^ data_xor_f_reg[58] ^ data_xor_f_reg[61] ^ data_xor_f_reg[62];
        crc32_out_w[26] = 0 ^ data_xor_f_reg[0] ^ data_xor_f_reg[3] ^ data_xor_f_reg[4] ^ data_xor_f_reg[6] ^ data_xor_f_reg[10] ^ data_xor_f_reg[18] ^ data_xor_f_reg[19] ^ data_xor_f_reg[20] ^ data_xor_f_reg[22] ^ data_xor_f_reg[23] ^ data_xor_f_reg[24] ^ data_xor_f_reg[25] ^ data_xor_f_reg[26] ^ data_xor_f_reg[28] ^ data_xor_f_reg[31] ^ data_xor_f_reg[38] ^ data_xor_f_reg[39] ^ data_xor_f_reg[41] ^ data_xor_f_reg[42] ^ data_xor_f_reg[44] ^ data_xor_f_reg[47] ^ data_xor_f_reg[48] ^ data_xor_f_reg[49] ^ data_xor_f_reg[52] ^ data_xor_f_reg[54] ^ data_xor_f_reg[55] ^ data_xor_f_reg[57] ^ data_xor_f_reg[59] ^ data_xor_f_reg[60] ^ data_xor_f_reg[61] ^ data_xor_f_reg[62];
        crc32_out_w[27] = 1 ^ data_xor_f_reg[1] ^ data_xor_f_reg[4] ^ data_xor_f_reg[5] ^ data_xor_f_reg[7] ^ data_xor_f_reg[11] ^ data_xor_f_reg[19] ^ data_xor_f_reg[20] ^ data_xor_f_reg[21] ^ data_xor_f_reg[23] ^ data_xor_f_reg[24] ^ data_xor_f_reg[25] ^ data_xor_f_reg[26] ^ data_xor_f_reg[27] ^ data_xor_f_reg[29] ^ data_xor_f_reg[32] ^ data_xor_f_reg[39] ^ data_xor_f_reg[40] ^ data_xor_f_reg[42] ^ data_xor_f_reg[43] ^ data_xor_f_reg[45] ^ data_xor_f_reg[48] ^ data_xor_f_reg[49] ^ data_xor_f_reg[50] ^ data_xor_f_reg[53] ^ data_xor_f_reg[55] ^ data_xor_f_reg[56] ^ data_xor_f_reg[58] ^ data_xor_f_reg[60] ^ data_xor_f_reg[61] ^ data_xor_f_reg[62] ^ data_xor_f_reg[63];
        crc32_out_w[28] = 0 ^ data_xor_f_reg[2] ^ data_xor_f_reg[5] ^ data_xor_f_reg[6] ^ data_xor_f_reg[8] ^ data_xor_f_reg[12] ^ data_xor_f_reg[20] ^ data_xor_f_reg[21] ^ data_xor_f_reg[22] ^ data_xor_f_reg[24] ^ data_xor_f_reg[25] ^ data_xor_f_reg[26] ^ data_xor_f_reg[27] ^ data_xor_f_reg[28] ^ data_xor_f_reg[30] ^ data_xor_f_reg[33] ^ data_xor_f_reg[40] ^ data_xor_f_reg[41] ^ data_xor_f_reg[43] ^ data_xor_f_reg[44] ^ data_xor_f_reg[46] ^ data_xor_f_reg[49] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[54] ^ data_xor_f_reg[56] ^ data_xor_f_reg[57] ^ data_xor_f_reg[59] ^ data_xor_f_reg[61] ^ data_xor_f_reg[62] ^ data_xor_f_reg[63];
        crc32_out_w[29] = 1 ^ data_xor_f_reg[3] ^ data_xor_f_reg[6] ^ data_xor_f_reg[7] ^ data_xor_f_reg[9] ^ data_xor_f_reg[13] ^ data_xor_f_reg[21] ^ data_xor_f_reg[22] ^ data_xor_f_reg[23] ^ data_xor_f_reg[25] ^ data_xor_f_reg[26] ^ data_xor_f_reg[27] ^ data_xor_f_reg[28] ^ data_xor_f_reg[29] ^ data_xor_f_reg[31] ^ data_xor_f_reg[34] ^ data_xor_f_reg[41] ^ data_xor_f_reg[42] ^ data_xor_f_reg[44] ^ data_xor_f_reg[45] ^ data_xor_f_reg[47] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[55] ^ data_xor_f_reg[57] ^ data_xor_f_reg[58] ^ data_xor_f_reg[60] ^ data_xor_f_reg[62] ^ data_xor_f_reg[63];
        crc32_out_w[30] = 1 ^ data_xor_f_reg[4] ^ data_xor_f_reg[7] ^ data_xor_f_reg[8] ^ data_xor_f_reg[10] ^ data_xor_f_reg[14] ^ data_xor_f_reg[22] ^ data_xor_f_reg[23] ^ data_xor_f_reg[24] ^ data_xor_f_reg[26] ^ data_xor_f_reg[27] ^ data_xor_f_reg[28] ^ data_xor_f_reg[29] ^ data_xor_f_reg[30] ^ data_xor_f_reg[32] ^ data_xor_f_reg[35] ^ data_xor_f_reg[42] ^ data_xor_f_reg[43] ^ data_xor_f_reg[45] ^ data_xor_f_reg[46] ^ data_xor_f_reg[48] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[53] ^ data_xor_f_reg[56] ^ data_xor_f_reg[58] ^ data_xor_f_reg[59] ^ data_xor_f_reg[61] ^ data_xor_f_reg[63];
        crc32_out_w[31] = 0 ^ data_xor_f_reg[5] ^ data_xor_f_reg[8] ^ data_xor_f_reg[9] ^ data_xor_f_reg[11] ^ data_xor_f_reg[15] ^ data_xor_f_reg[23] ^ data_xor_f_reg[24] ^ data_xor_f_reg[25] ^ data_xor_f_reg[27] ^ data_xor_f_reg[28] ^ data_xor_f_reg[29] ^ data_xor_f_reg[30] ^ data_xor_f_reg[31] ^ data_xor_f_reg[33] ^ data_xor_f_reg[36] ^ data_xor_f_reg[43] ^ data_xor_f_reg[44] ^ data_xor_f_reg[46] ^ data_xor_f_reg[47] ^ data_xor_f_reg[49] ^ data_xor_f_reg[52] ^ data_xor_f_reg[53] ^ data_xor_f_reg[54] ^ data_xor_f_reg[57] ^ data_xor_f_reg[59] ^ data_xor_f_reg[60] ^ data_xor_f_reg[62];
    end

   
endmodule