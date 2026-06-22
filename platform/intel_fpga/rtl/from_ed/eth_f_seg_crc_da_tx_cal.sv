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

module eth_f_seg_crc_da_tx_cal #(
    parameter NUM_SEG         = 16,
    parameter SEG_LEN         = 64,
    parameter EMPTY_WIDTH     = 3,
    parameter PACKET_GAP      = 32 
)
  (
    input  logic                                    clk,
    input  logic                                    rst,
    input  logic                                    ena,
    input  logic [NUM_SEG-1:0][SEG_LEN-1:0]         i_data,
    input  logic [NUM_SEG-1:0][EMPTY_WIDTH-1:0]     i_empty,
    input  logic [NUM_SEG-1:0]                      i_inframe,
    input  logic                                    i_vld,
    input  logic                                    i_ready,
    input  logic [NUM_SEG-1:0]                      i_skip_crc,
    input  logic [NUM_SEG-1:0]                      i_error,
    input  logic [48:0]                             i_cfg_rom_dest_addr,

    output  logic [NUM_SEG-1:0][SEG_LEN-1:0]        o_data,
    output  logic [NUM_SEG-1:0]                     o_inframe,
    output  logic [NUM_SEG-1:0]                     o_error,
    output  logic [NUM_SEG-1:0][EMPTY_WIDTH-1:0]    o_empty,
    output  logic                                   o_vld,
    output  logic                                   o_ready,
    output  logic [NUM_SEG-1:0]                     o_skip_crc
   );

    localparam BYTE_CNT     = NUM_SEG*8;
    localparam [2:0] SEG_BYTE_CNT = SEG_LEN/8;
    localparam BIT_CNT      = NUM_SEG*SEG_LEN;
    localparam CRC_LEN      = 6'd32;

    logic eop_r2, eop_i, eop_r1, sop_o, eop_o, sop_r, eop_r, n_vld_sync, sop_r1, sop_r2, sop_i, n_vld_sync_r1,
            custom_da_en, emp_new_cycle, emp_new_cycle_sync, lc_vld_i;
    logic [NUM_SEG-1:0][SEG_LEN-1:0] data_vld_i_r3,data_vld_i_r1,data_vld_i_r2, o_data_t, data_vld_i, data_vld_i_w;
    logic [NUM_SEG-1:0] o_inframe_n, o_inframe_t, inframe_i, inframe_r1, inframe_r2, inframe_r3, error_r1,
            error_r2,error_r3,error_r4,error_r5, skip_crc_r1, skip_crc_r2, skip_crc_r3, skip_crc_r4, skip_crc_r5,
            inframe_w1,inframe_w2,inframe_w3, inframe_w4;
    logic [$clog2(NUM_SEG):0] pos_eop, pos_eop_r2, pos_eop_f;
    logic [NUM_SEG+1:0] inframe_t;
    logic [NUM_SEG-1:0][EMPTY_WIDTH-1:0] empty_i, empty_r3, empty_r2, empty_r1, o_empty_t;
    logic [EMPTY_WIDTH-1:0] n_empty;
    logic [CRC_LEN-1:0] crc32_r1, crc32_w, crc32_r2;
    logic [47:0] pkt_da_rev;
    logic [SEG_LEN-1:0] data_xor_f, data_xor_f_reg;
    logic [NUM_SEG-1:0] eop_ar, sop_ar, eop_ar_w, sop_ar_w;
    logic [NUM_SEG-1:0][$clog2(NUM_SEG):0] pos_ar,pos_ar_w;
    logic [NUM_SEG-1:0][15:0] le_incr;
    logic [3:0][SEG_LEN-1:0] data_xor_w1, data_xor_r1;
    logic [3:0][$clog2(NUM_SEG):0] pos_eop_w1, pos_eop_r1;

    assign sop_o        = sop_r & i_ready;
    assign eop_o        = eop_r & i_ready;  
    assign o_ready      = (ena)? emp_new_cycle_sync & i_ready : i_ready;
    assign o_vld        = (ena)? (((|o_inframe)|eop_o | n_vld_sync_r1) & i_ready) : i_vld;
    assign lc_vld_i     = (ena)? ((~emp_new_cycle_sync | i_vld) & i_ready) : i_vld ;

    assign o_empty      = (ena)? o_empty_t : i_empty;
    assign o_inframe    = (ena)? (i_ready? o_inframe_t : '0) : i_inframe;
    assign o_data       = (ena)? o_data_t : data_vld_i_w;
    assign o_error      = (ena)? error_r5 : i_error;  
    assign o_skip_crc   = (ena)? skip_crc_r5 : i_skip_crc;  

    assign custom_da_en = i_cfg_rom_dest_addr[48];                                         
    assign pkt_da_rev   = custom_da_en? {reverse_data({i_cfg_rom_dest_addr[15:0],16'b0}),reverse_data(i_cfg_rom_dest_addr[47:16])} : '0;                                           

    assign emp_new_cycle   = (!inframe_t[NUM_SEG] & inframe_t[NUM_SEG-1] & !i_empty[NUM_SEG-1][EMPTY_WIDTH-1])? 1'b0:1'b1;

    always_ff @(posedge clk) begin
        if (rst) emp_new_cycle_sync  <= '0;
        else if (i_ready)  emp_new_cycle_sync  <= emp_new_cycle;
                end

    generate
    if (NUM_SEG == 1) 
    assign inframe_t = {i_inframe,inframe_r1[NUM_SEG-1],inframe_r2[NUM_SEG-1]};
    else
    assign inframe_t = {i_inframe,inframe_r1[NUM_SEG-1],inframe_r1[NUM_SEG-2]};
    endgenerate




    genvar seg;
    //1st cycle
    generate
    for (seg=1; seg<=NUM_SEG; seg++) begin : SEG_ITERATE

    always_comb begin
        eop_ar_w[seg-1]       = '0;
        sop_ar_w[seg-1]       = '0;
        pos_ar_w[seg-1]       = '0;
        data_vld_i_w[seg-1]   = '0;
        le_incr[seg-1]        = '0;
        if (inframe_t[seg] & !inframe_t[seg+1] & lc_vld_i) begin
            eop_ar_w[seg-1]         = 1'b1;
            pos_ar_w[seg-1]         = seg-1;
            data_vld_i_w[seg-1]     = i_data[seg-1];
        end
        else if (!inframe_t[seg] & inframe_t[seg+1] & lc_vld_i) begin
            sop_ar_w[seg-1]         = 1'b1;
            data_vld_i_w[seg-1]     = custom_da_en? {i_data[seg-1][63:48],pkt_da_rev} : i_data[seg-1];
        end
        else if (!inframe_t[seg-1] & inframe_t[seg] & inframe_t[seg+1] & lc_vld_i) begin
            le_incr[seg-1]          = (ena)? {i_data[seg-1][39:32],i_data[seg-1][47:40]} + 16'd4 : {i_data[seg-1][39:32],i_data[seg-1][47:40]};
            data_vld_i_w[seg-1]     = {i_data[seg-1][63:48],le_incr[seg-1][7:0],le_incr[seg-1][15:8],i_data[seg-1][31:0]};
        end
        else if (i_inframe[seg-1] & lc_vld_i)
            data_vld_i_w[seg-1]     = i_data[seg-1];
    end
    end

    //for 2nd cycle
    if (NUM_SEG == 16) begin : XOR_400G
    always_comb begin
        pos_eop_w1   = '0;
        data_xor_w1  = '0;
        if (i_ready) begin
            pos_eop_w1[0]   = pos_ar[0] ^ pos_ar[1] ^ pos_ar[2] ^ pos_ar[3];
            data_xor_w1[0]  = data_vld_i[0] ^ data_vld_i[1] ^ data_vld_i[2] ^ data_vld_i[3];
            pos_eop_w1[1]   = pos_ar[4] ^ pos_ar[5] ^ pos_ar[6] ^ pos_ar[7];
            data_xor_w1[1]  = data_vld_i[4] ^ data_vld_i[5] ^ data_vld_i[6] ^ data_vld_i[7];
            pos_eop_w1[2]   = pos_ar[8] ^ pos_ar[9] ^ pos_ar[10] ^ pos_ar[11];
            data_xor_w1[2]  = data_vld_i[8] ^ data_vld_i[9] ^ data_vld_i[10] ^ data_vld_i[11];
            pos_eop_w1[3]   = pos_ar[12] ^ pos_ar[13] ^ pos_ar[14] ^ pos_ar[15];
            data_xor_w1[3]  = data_vld_i[12] ^ data_vld_i[13] ^ data_vld_i[14] ^ data_vld_i[15];
        end 
    end
    end
    else if (NUM_SEG == 8) begin : XOR_200G
    always_comb begin
        pos_eop_w1   = '0;
        data_xor_w1  = '0;
        if (i_ready) begin
            pos_eop_w1[0]   = pos_ar[0] ^ pos_ar[1] ^ pos_ar[2] ^ pos_ar[3];
            data_xor_w1[0]  = data_vld_i[0] ^ data_vld_i[1] ^ data_vld_i[2] ^ data_vld_i[3];
            pos_eop_w1[1]   = pos_ar[4] ^ pos_ar[5] ^ pos_ar[6] ^ pos_ar[7];
            data_xor_w1[1]  = data_vld_i[4] ^ data_vld_i[5] ^ data_vld_i[6] ^ data_vld_i[7];
        end 
    end
    end
    else if (NUM_SEG == 4) begin : XOR_100G
    always_comb begin
        pos_eop_w1   = '0;
        data_xor_w1  = '0;
        if (i_ready) begin
            pos_eop_w1[0]   = pos_ar[0] ^ pos_ar[1] ^ pos_ar[2] ^ pos_ar[3];
            data_xor_w1[0]  = data_vld_i[0] ^ data_vld_i[1] ^ data_vld_i[2] ^ data_vld_i[3];
        end
    end
    end
    else if(NUM_SEG == 2) begin : XOR_40G50G
    always_comb begin
        pos_eop_w1   = '0;
        data_xor_w1  = '0;
        if (i_ready) begin
            pos_eop_w1[0]   = pos_ar[0] ^ pos_ar[1];
            data_xor_w1[0]  = data_vld_i[0] ^ data_vld_i[1];
        end
    end
    end
    else begin : XOR_10G25G
    always_comb begin
        pos_eop_w1   = '0;
        data_xor_w1  = '0;
        if (i_ready) begin
            pos_eop_w1[0]   = pos_ar[0];
            data_xor_w1[0]  = data_vld_i[0];
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

    // assign inframe_w1 = inframe_r1  & i_ready;
    // assign inframe_w2 = inframe_r2  & i_ready;
    // assign inframe_w3 = inframe_r3  & i_ready;
    // assign inframe_w4 = inframe_i   & i_ready;
   
    always_ff @(posedge clk) begin
        if (rst) begin
            inframe_i       <= '0;
            sop_r           <= '0;
            eop_r           <= '0;
            eop_r1          <= '0;
            eop_r2          <= '0;
            eop_i           <= '0;
            data_vld_i_r1   <= '0;
            data_vld_i_r2   <= '0;
            data_vld_i_r3   <= '0;
            crc32_r2        <= '0;
            crc32_r1        <= '0;
            error_r1        <= '0;
            error_r2        <= '0;
            error_r3        <= '0;
            error_r4        <= '0;
            error_r5        <= '0;
            data_xor_f_reg  <= '0;
            skip_crc_r1     <= '0;
            skip_crc_r2     <= '0;
            skip_crc_r3     <= '0;
            skip_crc_r4     <= '0;
            skip_crc_r5     <= '0;
            n_vld_sync_r1   <= '0;
            data_xor_r1     <= '0;
            pos_eop_r1      <= '0;
            pos_eop         <= '0;
            pos_eop_r2      <= '0;
            sop_r1          <= '0;
            sop_r2          <= '0;
            sop_i           <= '0;
            empty_r1        <= '0;
            empty_r2        <= '0;
            empty_r3        <= '0;
            empty_i         <= '0;
            inframe_r1      <= '0;
            inframe_r2      <= '0;
            inframe_r3      <= '0;
            eop_ar          <= '0;
            sop_ar          <= '0;
            pos_ar          <= '0;
            data_vld_i      <= '0;
            
        end
        else if (i_ready) begin
            inframe_r1      <= i_inframe;
            inframe_r2      <= inframe_r1;
            inframe_r3      <= inframe_r2;
            inframe_i       <= inframe_r3;

            empty_r1        <= i_empty;
            empty_r2        <= empty_r1;
            empty_r3        <= empty_r2;
            empty_i         <= empty_r3;

            crc32_r2        <= crc32_r1;
            crc32_r1        <= crc32_w;

            error_r1        <= i_error;
            error_r2        <= error_r1;
            error_r3        <= error_r2;
            error_r4        <= error_r3;
            error_r5        <= error_r4;

            skip_crc_r1     <= i_skip_crc;
            skip_crc_r2     <= skip_crc_r1;
            skip_crc_r3     <= skip_crc_r2;
            skip_crc_r4     <= skip_crc_r3;
            skip_crc_r5     <= skip_crc_r4;

            n_vld_sync_r1   <= n_vld_sync;

            sop_ar          <= sop_ar_w;    
            sop_r1          <= |sop_ar;
            sop_r2          <= sop_r1;
            sop_i           <= sop_r2;
            sop_r           <= sop_i;

            eop_ar          <= eop_ar_w;    
            eop_r1          <= |eop_ar;
            eop_r2          <= eop_r1;
            eop_i           <= eop_r2;
            eop_r           <= eop_i;

            pos_ar          <= pos_ar_w;    
            pos_eop_r1      <= pos_eop_w1;
            pos_eop_r2      <= pos_eop_f;
            pos_eop         <= pos_eop_r2;

            data_xor_r1     <= data_xor_w1;
            data_vld_i      <= data_vld_i_w;
            data_vld_i_r1   <= data_vld_i;
            data_vld_i_r2   <= data_vld_i_r1;
            data_vld_i_r3   <= data_vld_i_r2;

            data_xor_f_reg  <= (sop_r1)? data_xor_f : data_xor_f ^ data_xor_f_reg;

        end
    end


// Append crc to o_data
    always_ff @(posedge clk) begin
        if (rst) begin
            n_vld_sync      <= '0;
            n_empty         <= '0;
            o_data_t        <= '0;
            o_empty_t       <= '0;
            o_inframe_t     <= '0;
        end
        else if (i_ready) begin
            o_data_t        <= data_vld_i_r3;
            o_empty_t       <= empty_i;
            o_inframe_t     <= inframe_i;
            if (eop_i) begin
                if (~empty_i[pos_eop][EMPTY_WIDTH-1]) begin
                    case (empty_i[pos_eop]) 
                        default : begin
                            o_data_t[pos_eop]      <= data_vld_i_r3[pos_eop];
                            o_empty_t[pos_eop]     <= 3'd0;
                            o_inframe_t[pos_eop]   <= 1'b1;
                        end
                        3'd1 : begin
                            o_data_t[pos_eop]      <= {crc32_r1[7:0], data_vld_i_r3[pos_eop][55:0]};
                            o_empty_t[pos_eop]     <= 3'd0;
                            o_inframe_t[pos_eop]   <= 1'b1;
                        end
                        3'd2 : begin
                            o_data_t[pos_eop]      <= {crc32_r1[15:0], data_vld_i_r3[pos_eop][47:0]};
                            o_empty_t[pos_eop]     <= 3'd0;
                            o_inframe_t[pos_eop]   <= 1'b1;
                        end
                        3'd3 : begin
                            o_data_t[pos_eop]      <= {crc32_r1[23:0], data_vld_i_r3[pos_eop][39:0]};
                            o_empty_t[pos_eop]     <= 3'd0;
                            o_inframe_t[pos_eop]   <= 1'b1;
                        end 
                    endcase

                    if (!(pos_eop ^ (NUM_SEG-1))) begin
                        n_empty             <= empty_i[pos_eop];
                        n_vld_sync          <= 1'b1;
                    end else begin
                        o_inframe_t[pos_eop+1'b1]   <= 1'b0;
                        case (empty_i[pos_eop])
                            default: begin 
                                o_data_t[pos_eop+1'b1]     <= {32'd0,crc32_r1[31:0]};
                                o_empty_t[pos_eop+1'b1]    <= 3'd4;
                            end
                            3'd1: begin
                                o_data_t[pos_eop+1'b1]     <= {40'd0,crc32_r1[31:8]};
                                o_empty_t[pos_eop+1'b1]    <= 3'd5;
                            end
                            3'd2: begin
                                o_data_t[pos_eop+1'b1]     <= {48'd0,crc32_r1[31:16]};
                                o_empty_t[pos_eop+1'b1]    <= 3'd6;
                            end
                            3'd3: begin
                                o_data_t[pos_eop+1'b1]     <= {56'd0,crc32_r1[31:24]};
                                o_empty_t[pos_eop+1'b1]    <= 3'd7;
                            end
                        endcase
                    end
                end
                else begin
                    case (empty_i[pos_eop]) 
                        default : begin
                            o_data_t[pos_eop]      <= {crc32_r1[31:0], data_vld_i_r3[pos_eop][31:0]};
                            o_empty_t[pos_eop]     <= 3'd0;
                            o_inframe_t[pos_eop]   <= 1'b0;
                        end
                        3'd5 : begin
                            o_data_t[pos_eop]      <= {8'd0,crc32_r1[31:0], data_vld_i_r3[pos_eop][23:0]};
                            o_empty_t[pos_eop]     <= 3'd1;
                            o_inframe_t[pos_eop]   <= 1'b0;
                        end
                        3'd6 : begin
                            o_data_t[pos_eop]      <= {16'd0,crc32_r1[31:0], data_vld_i_r3[pos_eop][15:0]};
                            o_empty_t[pos_eop]     <= 3'd2;
                            o_inframe_t[pos_eop]   <= 1'b0;
                        end
                        3'd7 : begin
                            o_data_t[pos_eop]      <= {24'd0,crc32_r1[31:0], data_vld_i_r3[pos_eop][7:0]};
                            o_empty_t[pos_eop]     <= 3'd3;
                            o_inframe_t[pos_eop]   <= 1'b0;
                        end
                    endcase
                end 
            end 
            else if (n_vld_sync) begin
                o_inframe_t[0]   <= 1'b0;
                n_vld_sync       <= 1'b0;
                case (n_empty)
                    default:   begin //3'd0
                        o_data_t[0]      <= {32'd0,crc32_r2[31:0]};
                        o_empty_t[0]     <= 3'd4;
                    end
                    3'd1:begin
                        o_data_t[0]      <= {40'd0,crc32_r2[31:8]};
                        o_empty_t[0]     <= 3'd5;
                    end
                    3'd2:begin
                        o_data_t[0]      <= {48'd0,crc32_r2[31:16]};
                        o_empty_t[0]     <= 3'd6;
                    end
                    3'd3:begin
                        o_data_t[0]      <= {56'd0,crc32_r2[31:24]};
                        o_empty_t[0]     <= 3'd7;
                    end
                endcase
            end
        end
    end
   

// calculate crc based on CRC-32/MPEG-2 - https://crccalc.com/
    always_comb begin
        crc32_w[0]  = 1 ^ data_xor_f_reg[0] ^ data_xor_f_reg[6] ^ data_xor_f_reg[9] ^ data_xor_f_reg[10] ^ data_xor_f_reg[12] ^ data_xor_f_reg[16] ^ data_xor_f_reg[24] ^ data_xor_f_reg[25] ^ data_xor_f_reg[26] ^ data_xor_f_reg[28] ^ data_xor_f_reg[29] ^ data_xor_f_reg[30] ^ data_xor_f_reg[31] ^ data_xor_f_reg[32] ^ data_xor_f_reg[34] ^ data_xor_f_reg[37] ^ data_xor_f_reg[44] ^ data_xor_f_reg[45] ^ data_xor_f_reg[47] ^ data_xor_f_reg[48] ^ data_xor_f_reg[50] ^ data_xor_f_reg[53] ^ data_xor_f_reg[54] ^ data_xor_f_reg[55] ^ data_xor_f_reg[58] ^ data_xor_f_reg[60] ^ data_xor_f_reg[61] ^ data_xor_f_reg[63];
        crc32_w[1]  = 0 ^ data_xor_f_reg[0] ^ data_xor_f_reg[1] ^ data_xor_f_reg[6] ^ data_xor_f_reg[7] ^ data_xor_f_reg[9] ^ data_xor_f_reg[11] ^ data_xor_f_reg[12] ^ data_xor_f_reg[13] ^ data_xor_f_reg[16] ^ data_xor_f_reg[17] ^ data_xor_f_reg[24] ^ data_xor_f_reg[27] ^ data_xor_f_reg[28] ^ data_xor_f_reg[33] ^ data_xor_f_reg[34] ^ data_xor_f_reg[35] ^ data_xor_f_reg[37] ^ data_xor_f_reg[38] ^ data_xor_f_reg[44] ^ data_xor_f_reg[46] ^ data_xor_f_reg[47] ^ data_xor_f_reg[49] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[53] ^ data_xor_f_reg[56] ^ data_xor_f_reg[58] ^ data_xor_f_reg[59] ^ data_xor_f_reg[60] ^ data_xor_f_reg[62] ^ data_xor_f_reg[63];
        crc32_w[2]  = 0 ^ data_xor_f_reg[0] ^ data_xor_f_reg[1] ^ data_xor_f_reg[2] ^ data_xor_f_reg[6] ^ data_xor_f_reg[7] ^ data_xor_f_reg[8] ^ data_xor_f_reg[9] ^ data_xor_f_reg[13] ^ data_xor_f_reg[14] ^ data_xor_f_reg[16] ^ data_xor_f_reg[17] ^ data_xor_f_reg[18] ^ data_xor_f_reg[24] ^ data_xor_f_reg[26] ^ data_xor_f_reg[30] ^ data_xor_f_reg[31] ^ data_xor_f_reg[32] ^ data_xor_f_reg[35] ^ data_xor_f_reg[36] ^ data_xor_f_reg[37] ^ data_xor_f_reg[38] ^ data_xor_f_reg[39] ^ data_xor_f_reg[44] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[53] ^ data_xor_f_reg[55] ^ data_xor_f_reg[57] ^ data_xor_f_reg[58] ^ data_xor_f_reg[59];
        crc32_w[3]  = 1 ^ data_xor_f_reg[1] ^ data_xor_f_reg[2] ^ data_xor_f_reg[3] ^ data_xor_f_reg[7] ^ data_xor_f_reg[8] ^ data_xor_f_reg[9] ^ data_xor_f_reg[10] ^ data_xor_f_reg[14] ^ data_xor_f_reg[15] ^ data_xor_f_reg[17] ^ data_xor_f_reg[18] ^ data_xor_f_reg[19] ^ data_xor_f_reg[25] ^ data_xor_f_reg[27] ^ data_xor_f_reg[31] ^ data_xor_f_reg[32] ^ data_xor_f_reg[33] ^ data_xor_f_reg[36] ^ data_xor_f_reg[37] ^ data_xor_f_reg[38] ^ data_xor_f_reg[39] ^ data_xor_f_reg[40] ^ data_xor_f_reg[45] ^ data_xor_f_reg[52] ^ data_xor_f_reg[53] ^ data_xor_f_reg[54] ^ data_xor_f_reg[56] ^ data_xor_f_reg[58] ^ data_xor_f_reg[59] ^ data_xor_f_reg[60];
        crc32_w[4]  = 1 ^ data_xor_f_reg[0] ^ data_xor_f_reg[2] ^ data_xor_f_reg[3] ^ data_xor_f_reg[4] ^ data_xor_f_reg[6] ^ data_xor_f_reg[8] ^ data_xor_f_reg[11] ^ data_xor_f_reg[12] ^ data_xor_f_reg[15] ^ data_xor_f_reg[18] ^ data_xor_f_reg[19] ^ data_xor_f_reg[20] ^ data_xor_f_reg[24] ^ data_xor_f_reg[25] ^ data_xor_f_reg[29] ^ data_xor_f_reg[30] ^ data_xor_f_reg[31] ^ data_xor_f_reg[33] ^ data_xor_f_reg[38] ^ data_xor_f_reg[39] ^ data_xor_f_reg[40] ^ data_xor_f_reg[41] ^ data_xor_f_reg[44] ^ data_xor_f_reg[45] ^ data_xor_f_reg[46] ^ data_xor_f_reg[47] ^ data_xor_f_reg[48] ^ data_xor_f_reg[50] ^ data_xor_f_reg[57] ^ data_xor_f_reg[58] ^ data_xor_f_reg[59] ^ data_xor_f_reg[63];
        crc32_w[5]  = 0 ^ data_xor_f_reg[0] ^ data_xor_f_reg[1] ^ data_xor_f_reg[3] ^ data_xor_f_reg[4] ^ data_xor_f_reg[5] ^ data_xor_f_reg[6] ^ data_xor_f_reg[7] ^ data_xor_f_reg[10] ^ data_xor_f_reg[13] ^ data_xor_f_reg[19] ^ data_xor_f_reg[20] ^ data_xor_f_reg[21] ^ data_xor_f_reg[24] ^ data_xor_f_reg[28] ^ data_xor_f_reg[29] ^ data_xor_f_reg[37] ^ data_xor_f_reg[39] ^ data_xor_f_reg[40] ^ data_xor_f_reg[41] ^ data_xor_f_reg[42] ^ data_xor_f_reg[44] ^ data_xor_f_reg[46] ^ data_xor_f_reg[49] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[53] ^ data_xor_f_reg[54] ^ data_xor_f_reg[55] ^ data_xor_f_reg[59] ^ data_xor_f_reg[61] ^ data_xor_f_reg[63];
        crc32_w[6]  = 1 ^ data_xor_f_reg[1] ^ data_xor_f_reg[2] ^ data_xor_f_reg[4] ^ data_xor_f_reg[5] ^ data_xor_f_reg[6] ^ data_xor_f_reg[7] ^ data_xor_f_reg[8] ^ data_xor_f_reg[11] ^ data_xor_f_reg[14] ^ data_xor_f_reg[20] ^ data_xor_f_reg[21] ^ data_xor_f_reg[22] ^ data_xor_f_reg[25] ^ data_xor_f_reg[29] ^ data_xor_f_reg[30] ^ data_xor_f_reg[38] ^ data_xor_f_reg[40] ^ data_xor_f_reg[41] ^ data_xor_f_reg[42] ^ data_xor_f_reg[43] ^ data_xor_f_reg[45] ^ data_xor_f_reg[47] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[54] ^ data_xor_f_reg[55] ^ data_xor_f_reg[56] ^ data_xor_f_reg[60] ^ data_xor_f_reg[62];
        crc32_w[7]  = 0 ^ data_xor_f_reg[0] ^ data_xor_f_reg[2] ^ data_xor_f_reg[3] ^ data_xor_f_reg[5] ^ data_xor_f_reg[7] ^ data_xor_f_reg[8] ^ data_xor_f_reg[10] ^ data_xor_f_reg[15] ^ data_xor_f_reg[16] ^ data_xor_f_reg[21] ^ data_xor_f_reg[22] ^ data_xor_f_reg[23] ^ data_xor_f_reg[24] ^ data_xor_f_reg[25] ^ data_xor_f_reg[28] ^ data_xor_f_reg[29] ^ data_xor_f_reg[32] ^ data_xor_f_reg[34] ^ data_xor_f_reg[37] ^ data_xor_f_reg[39] ^ data_xor_f_reg[41] ^ data_xor_f_reg[42] ^ data_xor_f_reg[43] ^ data_xor_f_reg[45] ^ data_xor_f_reg[46] ^ data_xor_f_reg[47] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[54] ^ data_xor_f_reg[56] ^ data_xor_f_reg[57] ^ data_xor_f_reg[58] ^ data_xor_f_reg[60];
        crc32_w[8]  = 1 ^ data_xor_f_reg[0] ^ data_xor_f_reg[1] ^ data_xor_f_reg[3] ^ data_xor_f_reg[4] ^ data_xor_f_reg[8] ^ data_xor_f_reg[10] ^ data_xor_f_reg[11] ^ data_xor_f_reg[12] ^ data_xor_f_reg[17] ^ data_xor_f_reg[22] ^ data_xor_f_reg[23] ^ data_xor_f_reg[28] ^ data_xor_f_reg[31] ^ data_xor_f_reg[32] ^ data_xor_f_reg[33] ^ data_xor_f_reg[34] ^ data_xor_f_reg[35] ^ data_xor_f_reg[37] ^ data_xor_f_reg[38] ^ data_xor_f_reg[40] ^ data_xor_f_reg[42] ^ data_xor_f_reg[43] ^ data_xor_f_reg[45] ^ data_xor_f_reg[46] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[54] ^ data_xor_f_reg[57] ^ data_xor_f_reg[59] ^ data_xor_f_reg[60] ^ data_xor_f_reg[63];
        crc32_w[9]  = 1 ^ data_xor_f_reg[1] ^ data_xor_f_reg[2] ^ data_xor_f_reg[4] ^ data_xor_f_reg[5] ^ data_xor_f_reg[9] ^ data_xor_f_reg[11] ^ data_xor_f_reg[12] ^ data_xor_f_reg[13] ^ data_xor_f_reg[18] ^ data_xor_f_reg[23] ^ data_xor_f_reg[24] ^ data_xor_f_reg[29] ^ data_xor_f_reg[32] ^ data_xor_f_reg[33] ^ data_xor_f_reg[34] ^ data_xor_f_reg[35] ^ data_xor_f_reg[36] ^ data_xor_f_reg[38] ^ data_xor_f_reg[39] ^ data_xor_f_reg[41] ^ data_xor_f_reg[43] ^ data_xor_f_reg[44] ^ data_xor_f_reg[46] ^ data_xor_f_reg[47] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[53] ^ data_xor_f_reg[55] ^ data_xor_f_reg[58] ^ data_xor_f_reg[60] ^ data_xor_f_reg[61];
        crc32_w[10] = 0 ^ data_xor_f_reg[0] ^ data_xor_f_reg[2] ^ data_xor_f_reg[3] ^ data_xor_f_reg[5] ^ data_xor_f_reg[9] ^ data_xor_f_reg[13] ^ data_xor_f_reg[14] ^ data_xor_f_reg[16] ^ data_xor_f_reg[19] ^ data_xor_f_reg[26] ^ data_xor_f_reg[28] ^ data_xor_f_reg[29] ^ data_xor_f_reg[31] ^ data_xor_f_reg[32] ^ data_xor_f_reg[33] ^ data_xor_f_reg[35] ^ data_xor_f_reg[36] ^ data_xor_f_reg[39] ^ data_xor_f_reg[40] ^ data_xor_f_reg[42] ^ data_xor_f_reg[50] ^ data_xor_f_reg[52] ^ data_xor_f_reg[55] ^ data_xor_f_reg[56] ^ data_xor_f_reg[58] ^ data_xor_f_reg[59] ^ data_xor_f_reg[60] ^ data_xor_f_reg[62] ^ data_xor_f_reg[63];
        crc32_w[11] = 1 ^ data_xor_f_reg[0] ^ data_xor_f_reg[1] ^ data_xor_f_reg[3] ^ data_xor_f_reg[4] ^ data_xor_f_reg[9] ^ data_xor_f_reg[12] ^ data_xor_f_reg[14] ^ data_xor_f_reg[15] ^ data_xor_f_reg[16] ^ data_xor_f_reg[17] ^ data_xor_f_reg[20] ^ data_xor_f_reg[24] ^ data_xor_f_reg[25] ^ data_xor_f_reg[26] ^ data_xor_f_reg[27] ^ data_xor_f_reg[28] ^ data_xor_f_reg[31] ^ data_xor_f_reg[33] ^ data_xor_f_reg[36] ^ data_xor_f_reg[40] ^ data_xor_f_reg[41] ^ data_xor_f_reg[43] ^ data_xor_f_reg[44] ^ data_xor_f_reg[45] ^ data_xor_f_reg[47] ^ data_xor_f_reg[48] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[54] ^ data_xor_f_reg[55] ^ data_xor_f_reg[56] ^ data_xor_f_reg[57] ^ data_xor_f_reg[58] ^ data_xor_f_reg[59];
        crc32_w[12] = 1 ^ data_xor_f_reg[0] ^ data_xor_f_reg[1] ^ data_xor_f_reg[2] ^ data_xor_f_reg[4] ^ data_xor_f_reg[5] ^ data_xor_f_reg[6] ^ data_xor_f_reg[9] ^ data_xor_f_reg[12] ^ data_xor_f_reg[13] ^ data_xor_f_reg[15] ^ data_xor_f_reg[17] ^ data_xor_f_reg[18] ^ data_xor_f_reg[21] ^ data_xor_f_reg[24] ^ data_xor_f_reg[27] ^ data_xor_f_reg[30] ^ data_xor_f_reg[31] ^ data_xor_f_reg[41] ^ data_xor_f_reg[42] ^ data_xor_f_reg[46] ^ data_xor_f_reg[47] ^ data_xor_f_reg[49] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[53] ^ data_xor_f_reg[54] ^ data_xor_f_reg[56] ^ data_xor_f_reg[57] ^ data_xor_f_reg[59] ^ data_xor_f_reg[61] ^ data_xor_f_reg[63];
        crc32_w[13] = 1 ^ data_xor_f_reg[1] ^ data_xor_f_reg[2] ^ data_xor_f_reg[3] ^ data_xor_f_reg[5] ^ data_xor_f_reg[6] ^ data_xor_f_reg[7] ^ data_xor_f_reg[10] ^ data_xor_f_reg[13] ^ data_xor_f_reg[14] ^ data_xor_f_reg[16] ^ data_xor_f_reg[18] ^ data_xor_f_reg[19] ^ data_xor_f_reg[22] ^ data_xor_f_reg[25] ^ data_xor_f_reg[28] ^ data_xor_f_reg[31] ^ data_xor_f_reg[32] ^ data_xor_f_reg[42] ^ data_xor_f_reg[43] ^ data_xor_f_reg[47] ^ data_xor_f_reg[48] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[53] ^ data_xor_f_reg[54] ^ data_xor_f_reg[55] ^ data_xor_f_reg[57] ^ data_xor_f_reg[58] ^ data_xor_f_reg[60] ^ data_xor_f_reg[62];
        crc32_w[14] = 0 ^ data_xor_f_reg[2] ^ data_xor_f_reg[3] ^ data_xor_f_reg[4] ^ data_xor_f_reg[6] ^ data_xor_f_reg[7] ^ data_xor_f_reg[8] ^ data_xor_f_reg[11] ^ data_xor_f_reg[14] ^ data_xor_f_reg[15] ^ data_xor_f_reg[17] ^ data_xor_f_reg[19] ^ data_xor_f_reg[20] ^ data_xor_f_reg[23] ^ data_xor_f_reg[26] ^ data_xor_f_reg[29] ^ data_xor_f_reg[32] ^ data_xor_f_reg[33] ^ data_xor_f_reg[43] ^ data_xor_f_reg[44] ^ data_xor_f_reg[48] ^ data_xor_f_reg[49] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[53] ^ data_xor_f_reg[54] ^ data_xor_f_reg[55] ^ data_xor_f_reg[56] ^ data_xor_f_reg[58] ^ data_xor_f_reg[59] ^ data_xor_f_reg[61] ^ data_xor_f_reg[63];
        crc32_w[15] = 1 ^ data_xor_f_reg[3] ^ data_xor_f_reg[4] ^ data_xor_f_reg[5] ^ data_xor_f_reg[7] ^ data_xor_f_reg[8] ^ data_xor_f_reg[9] ^ data_xor_f_reg[12] ^ data_xor_f_reg[15] ^ data_xor_f_reg[16] ^ data_xor_f_reg[18] ^ data_xor_f_reg[20] ^ data_xor_f_reg[21] ^ data_xor_f_reg[24] ^ data_xor_f_reg[27] ^ data_xor_f_reg[30] ^ data_xor_f_reg[33] ^ data_xor_f_reg[34] ^ data_xor_f_reg[44] ^ data_xor_f_reg[45] ^ data_xor_f_reg[49] ^ data_xor_f_reg[50] ^ data_xor_f_reg[52] ^ data_xor_f_reg[53] ^ data_xor_f_reg[54] ^ data_xor_f_reg[55] ^ data_xor_f_reg[56] ^ data_xor_f_reg[57] ^ data_xor_f_reg[59] ^ data_xor_f_reg[60] ^ data_xor_f_reg[62];
        crc32_w[16] = 0 ^ data_xor_f_reg[0] ^ data_xor_f_reg[4] ^ data_xor_f_reg[5] ^ data_xor_f_reg[8] ^ data_xor_f_reg[12] ^ data_xor_f_reg[13] ^ data_xor_f_reg[17] ^ data_xor_f_reg[19] ^ data_xor_f_reg[21] ^ data_xor_f_reg[22] ^ data_xor_f_reg[24] ^ data_xor_f_reg[26] ^ data_xor_f_reg[29] ^ data_xor_f_reg[30] ^ data_xor_f_reg[32] ^ data_xor_f_reg[35] ^ data_xor_f_reg[37] ^ data_xor_f_reg[44] ^ data_xor_f_reg[46] ^ data_xor_f_reg[47] ^ data_xor_f_reg[48] ^ data_xor_f_reg[51] ^ data_xor_f_reg[56] ^ data_xor_f_reg[57];
        crc32_w[17] = 0 ^ data_xor_f_reg[1] ^ data_xor_f_reg[5] ^ data_xor_f_reg[6] ^ data_xor_f_reg[9] ^ data_xor_f_reg[13] ^ data_xor_f_reg[14] ^ data_xor_f_reg[18] ^ data_xor_f_reg[20] ^ data_xor_f_reg[22] ^ data_xor_f_reg[23] ^ data_xor_f_reg[25] ^ data_xor_f_reg[27] ^ data_xor_f_reg[30] ^ data_xor_f_reg[31] ^ data_xor_f_reg[33] ^ data_xor_f_reg[36] ^ data_xor_f_reg[38] ^ data_xor_f_reg[45] ^ data_xor_f_reg[47] ^ data_xor_f_reg[48] ^ data_xor_f_reg[49] ^ data_xor_f_reg[52] ^ data_xor_f_reg[57] ^ data_xor_f_reg[58];
        crc32_w[18] = 1 ^ data_xor_f_reg[2] ^ data_xor_f_reg[6] ^ data_xor_f_reg[7] ^ data_xor_f_reg[10] ^ data_xor_f_reg[14] ^ data_xor_f_reg[15] ^ data_xor_f_reg[19] ^ data_xor_f_reg[21] ^ data_xor_f_reg[23] ^ data_xor_f_reg[24] ^ data_xor_f_reg[26] ^ data_xor_f_reg[28] ^ data_xor_f_reg[31] ^ data_xor_f_reg[32] ^ data_xor_f_reg[34] ^ data_xor_f_reg[37] ^ data_xor_f_reg[39] ^ data_xor_f_reg[46] ^ data_xor_f_reg[48] ^ data_xor_f_reg[49] ^ data_xor_f_reg[50] ^ data_xor_f_reg[53] ^ data_xor_f_reg[58] ^ data_xor_f_reg[59];
        crc32_w[19] = 0 ^ data_xor_f_reg[3] ^ data_xor_f_reg[7] ^ data_xor_f_reg[8] ^ data_xor_f_reg[11] ^ data_xor_f_reg[15] ^ data_xor_f_reg[16] ^ data_xor_f_reg[20] ^ data_xor_f_reg[22] ^ data_xor_f_reg[24] ^ data_xor_f_reg[25] ^ data_xor_f_reg[27] ^ data_xor_f_reg[29] ^ data_xor_f_reg[32] ^ data_xor_f_reg[33] ^ data_xor_f_reg[35] ^ data_xor_f_reg[38] ^ data_xor_f_reg[40] ^ data_xor_f_reg[47] ^ data_xor_f_reg[49] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[54] ^ data_xor_f_reg[59] ^ data_xor_f_reg[60];
        crc32_w[20] = 0 ^ data_xor_f_reg[4] ^ data_xor_f_reg[8] ^ data_xor_f_reg[9] ^ data_xor_f_reg[12] ^ data_xor_f_reg[16] ^ data_xor_f_reg[17] ^ data_xor_f_reg[21] ^ data_xor_f_reg[23] ^ data_xor_f_reg[25] ^ data_xor_f_reg[26] ^ data_xor_f_reg[28] ^ data_xor_f_reg[30] ^ data_xor_f_reg[33] ^ data_xor_f_reg[34] ^ data_xor_f_reg[36] ^ data_xor_f_reg[39] ^ data_xor_f_reg[41] ^ data_xor_f_reg[48] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[55] ^ data_xor_f_reg[60] ^ data_xor_f_reg[61];
        crc32_w[21] = 0 ^ data_xor_f_reg[5] ^ data_xor_f_reg[9] ^ data_xor_f_reg[10] ^ data_xor_f_reg[13] ^ data_xor_f_reg[17] ^ data_xor_f_reg[18] ^ data_xor_f_reg[22] ^ data_xor_f_reg[24] ^ data_xor_f_reg[26] ^ data_xor_f_reg[27] ^ data_xor_f_reg[29] ^ data_xor_f_reg[31] ^ data_xor_f_reg[34] ^ data_xor_f_reg[35] ^ data_xor_f_reg[37] ^ data_xor_f_reg[40] ^ data_xor_f_reg[42] ^ data_xor_f_reg[49] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[53] ^ data_xor_f_reg[56] ^ data_xor_f_reg[61] ^ data_xor_f_reg[62];
        crc32_w[22] = 0 ^ data_xor_f_reg[0] ^ data_xor_f_reg[9] ^ data_xor_f_reg[11] ^ data_xor_f_reg[12] ^ data_xor_f_reg[14] ^ data_xor_f_reg[16] ^ data_xor_f_reg[18] ^ data_xor_f_reg[19] ^ data_xor_f_reg[23] ^ data_xor_f_reg[24] ^ data_xor_f_reg[26] ^ data_xor_f_reg[27] ^ data_xor_f_reg[29] ^ data_xor_f_reg[31] ^ data_xor_f_reg[34] ^ data_xor_f_reg[35] ^ data_xor_f_reg[36] ^ data_xor_f_reg[37] ^ data_xor_f_reg[38] ^ data_xor_f_reg[41] ^ data_xor_f_reg[43] ^ data_xor_f_reg[44] ^ data_xor_f_reg[45] ^ data_xor_f_reg[47] ^ data_xor_f_reg[48] ^ data_xor_f_reg[52] ^ data_xor_f_reg[55] ^ data_xor_f_reg[57] ^ data_xor_f_reg[58] ^ data_xor_f_reg[60] ^ data_xor_f_reg[61] ^ data_xor_f_reg[62];
        crc32_w[23] = 0 ^ data_xor_f_reg[0] ^ data_xor_f_reg[1] ^ data_xor_f_reg[6] ^ data_xor_f_reg[9] ^ data_xor_f_reg[13] ^ data_xor_f_reg[15] ^ data_xor_f_reg[16] ^ data_xor_f_reg[17] ^ data_xor_f_reg[19] ^ data_xor_f_reg[20] ^ data_xor_f_reg[26] ^ data_xor_f_reg[27] ^ data_xor_f_reg[29] ^ data_xor_f_reg[31] ^ data_xor_f_reg[34] ^ data_xor_f_reg[35] ^ data_xor_f_reg[36] ^ data_xor_f_reg[38] ^ data_xor_f_reg[39] ^ data_xor_f_reg[42] ^ data_xor_f_reg[46] ^ data_xor_f_reg[47] ^ data_xor_f_reg[49] ^ data_xor_f_reg[50] ^ data_xor_f_reg[54] ^ data_xor_f_reg[55] ^ data_xor_f_reg[56] ^ data_xor_f_reg[59] ^ data_xor_f_reg[60] ^ data_xor_f_reg[62];
        crc32_w[24] = 1 ^ data_xor_f_reg[1] ^ data_xor_f_reg[2] ^ data_xor_f_reg[7] ^ data_xor_f_reg[10] ^ data_xor_f_reg[14] ^ data_xor_f_reg[16] ^ data_xor_f_reg[17] ^ data_xor_f_reg[18] ^ data_xor_f_reg[20] ^ data_xor_f_reg[21] ^ data_xor_f_reg[27] ^ data_xor_f_reg[28] ^ data_xor_f_reg[30] ^ data_xor_f_reg[32] ^ data_xor_f_reg[35] ^ data_xor_f_reg[36] ^ data_xor_f_reg[37] ^ data_xor_f_reg[39] ^ data_xor_f_reg[40] ^ data_xor_f_reg[43] ^ data_xor_f_reg[47] ^ data_xor_f_reg[48] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[55] ^ data_xor_f_reg[56] ^ data_xor_f_reg[57] ^ data_xor_f_reg[60] ^ data_xor_f_reg[61] ^ data_xor_f_reg[63];
        crc32_w[25] = 0 ^ data_xor_f_reg[2] ^ data_xor_f_reg[3] ^ data_xor_f_reg[8] ^ data_xor_f_reg[11] ^ data_xor_f_reg[15] ^ data_xor_f_reg[17] ^ data_xor_f_reg[18] ^ data_xor_f_reg[19] ^ data_xor_f_reg[21] ^ data_xor_f_reg[22] ^ data_xor_f_reg[28] ^ data_xor_f_reg[29] ^ data_xor_f_reg[31] ^ data_xor_f_reg[33] ^ data_xor_f_reg[36] ^ data_xor_f_reg[37] ^ data_xor_f_reg[38] ^ data_xor_f_reg[40] ^ data_xor_f_reg[41] ^ data_xor_f_reg[44] ^ data_xor_f_reg[48] ^ data_xor_f_reg[49] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[56] ^ data_xor_f_reg[57] ^ data_xor_f_reg[58] ^ data_xor_f_reg[61] ^ data_xor_f_reg[62];
        crc32_w[26] = 0 ^ data_xor_f_reg[0] ^ data_xor_f_reg[3] ^ data_xor_f_reg[4] ^ data_xor_f_reg[6] ^ data_xor_f_reg[10] ^ data_xor_f_reg[18] ^ data_xor_f_reg[19] ^ data_xor_f_reg[20] ^ data_xor_f_reg[22] ^ data_xor_f_reg[23] ^ data_xor_f_reg[24] ^ data_xor_f_reg[25] ^ data_xor_f_reg[26] ^ data_xor_f_reg[28] ^ data_xor_f_reg[31] ^ data_xor_f_reg[38] ^ data_xor_f_reg[39] ^ data_xor_f_reg[41] ^ data_xor_f_reg[42] ^ data_xor_f_reg[44] ^ data_xor_f_reg[47] ^ data_xor_f_reg[48] ^ data_xor_f_reg[49] ^ data_xor_f_reg[52] ^ data_xor_f_reg[54] ^ data_xor_f_reg[55] ^ data_xor_f_reg[57] ^ data_xor_f_reg[59] ^ data_xor_f_reg[60] ^ data_xor_f_reg[61] ^ data_xor_f_reg[62];
        crc32_w[27] = 1 ^ data_xor_f_reg[1] ^ data_xor_f_reg[4] ^ data_xor_f_reg[5] ^ data_xor_f_reg[7] ^ data_xor_f_reg[11] ^ data_xor_f_reg[19] ^ data_xor_f_reg[20] ^ data_xor_f_reg[21] ^ data_xor_f_reg[23] ^ data_xor_f_reg[24] ^ data_xor_f_reg[25] ^ data_xor_f_reg[26] ^ data_xor_f_reg[27] ^ data_xor_f_reg[29] ^ data_xor_f_reg[32] ^ data_xor_f_reg[39] ^ data_xor_f_reg[40] ^ data_xor_f_reg[42] ^ data_xor_f_reg[43] ^ data_xor_f_reg[45] ^ data_xor_f_reg[48] ^ data_xor_f_reg[49] ^ data_xor_f_reg[50] ^ data_xor_f_reg[53] ^ data_xor_f_reg[55] ^ data_xor_f_reg[56] ^ data_xor_f_reg[58] ^ data_xor_f_reg[60] ^ data_xor_f_reg[61] ^ data_xor_f_reg[62] ^ data_xor_f_reg[63];
        crc32_w[28] = 0 ^ data_xor_f_reg[2] ^ data_xor_f_reg[5] ^ data_xor_f_reg[6] ^ data_xor_f_reg[8] ^ data_xor_f_reg[12] ^ data_xor_f_reg[20] ^ data_xor_f_reg[21] ^ data_xor_f_reg[22] ^ data_xor_f_reg[24] ^ data_xor_f_reg[25] ^ data_xor_f_reg[26] ^ data_xor_f_reg[27] ^ data_xor_f_reg[28] ^ data_xor_f_reg[30] ^ data_xor_f_reg[33] ^ data_xor_f_reg[40] ^ data_xor_f_reg[41] ^ data_xor_f_reg[43] ^ data_xor_f_reg[44] ^ data_xor_f_reg[46] ^ data_xor_f_reg[49] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[54] ^ data_xor_f_reg[56] ^ data_xor_f_reg[57] ^ data_xor_f_reg[59] ^ data_xor_f_reg[61] ^ data_xor_f_reg[62] ^ data_xor_f_reg[63];
        crc32_w[29] = 1 ^ data_xor_f_reg[3] ^ data_xor_f_reg[6] ^ data_xor_f_reg[7] ^ data_xor_f_reg[9] ^ data_xor_f_reg[13] ^ data_xor_f_reg[21] ^ data_xor_f_reg[22] ^ data_xor_f_reg[23] ^ data_xor_f_reg[25] ^ data_xor_f_reg[26] ^ data_xor_f_reg[27] ^ data_xor_f_reg[28] ^ data_xor_f_reg[29] ^ data_xor_f_reg[31] ^ data_xor_f_reg[34] ^ data_xor_f_reg[41] ^ data_xor_f_reg[42] ^ data_xor_f_reg[44] ^ data_xor_f_reg[45] ^ data_xor_f_reg[47] ^ data_xor_f_reg[50] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[55] ^ data_xor_f_reg[57] ^ data_xor_f_reg[58] ^ data_xor_f_reg[60] ^ data_xor_f_reg[62] ^ data_xor_f_reg[63];
        crc32_w[30] = 1 ^ data_xor_f_reg[4] ^ data_xor_f_reg[7] ^ data_xor_f_reg[8] ^ data_xor_f_reg[10] ^ data_xor_f_reg[14] ^ data_xor_f_reg[22] ^ data_xor_f_reg[23] ^ data_xor_f_reg[24] ^ data_xor_f_reg[26] ^ data_xor_f_reg[27] ^ data_xor_f_reg[28] ^ data_xor_f_reg[29] ^ data_xor_f_reg[30] ^ data_xor_f_reg[32] ^ data_xor_f_reg[35] ^ data_xor_f_reg[42] ^ data_xor_f_reg[43] ^ data_xor_f_reg[45] ^ data_xor_f_reg[46] ^ data_xor_f_reg[48] ^ data_xor_f_reg[51] ^ data_xor_f_reg[52] ^ data_xor_f_reg[53] ^ data_xor_f_reg[56] ^ data_xor_f_reg[58] ^ data_xor_f_reg[59] ^ data_xor_f_reg[61] ^ data_xor_f_reg[63];
        crc32_w[31] = 0 ^ data_xor_f_reg[5] ^ data_xor_f_reg[8] ^ data_xor_f_reg[9] ^ data_xor_f_reg[11] ^ data_xor_f_reg[15] ^ data_xor_f_reg[23] ^ data_xor_f_reg[24] ^ data_xor_f_reg[25] ^ data_xor_f_reg[27] ^ data_xor_f_reg[28] ^ data_xor_f_reg[29] ^ data_xor_f_reg[30] ^ data_xor_f_reg[31] ^ data_xor_f_reg[33] ^ data_xor_f_reg[36] ^ data_xor_f_reg[43] ^ data_xor_f_reg[44] ^ data_xor_f_reg[46] ^ data_xor_f_reg[47] ^ data_xor_f_reg[49] ^ data_xor_f_reg[52] ^ data_xor_f_reg[53] ^ data_xor_f_reg[54] ^ data_xor_f_reg[57] ^ data_xor_f_reg[59] ^ data_xor_f_reg[60] ^ data_xor_f_reg[62];
    end
    
 
    
    
    function [CRC_LEN-1:0] reverse_data;
    input [CRC_LEN-1:0] dIn;

    begin
        for (int i = 0; i<4; i++) //reverse incoming data
            reverse_data[(i*8)+:8] = dIn[((3-i)*8)+:8];
    end
    endfunction
    
endmodule
