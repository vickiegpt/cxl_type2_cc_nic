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


module eth_f_50g_avst2if_pp (
    input   logic               i_clk,
    input   logic               i_reset,

    // Client interface
    input   logic               i_valid,
    input   logic   [127:0]     i_data,
    input   logic               i_sop,
    input   logic               i_eop,
    input   logic   [3:0]       i_empty,
    input   logic               i_error,
    input   logic   [63:0]      i_preamble,
    input   logic               i_skip_crc,

    output  logic   [0:2][63:0] o_data,
    output  logic   [1:0]       o_num_valid,
    output  logic   [0:2]       o_inframe,
    output  logic   [0:2][2:0]  o_empty,
    output  logic   [0:2]       o_error,
    output  logic   [0:2]       o_skip_crc
);

    enum logic {INFRAME, IDLE} mode;

    logic   [1:0]   num_valid_next;
    logic   [0:2]   inframe_next;

    always_ff @(posedge i_clk) begin
        o_data      <= i_sop ? {i_preamble, i_data} : {i_data, 64'd0};
        o_empty     <= {3{i_empty[2:0]}};
        o_error     <= {3{i_error}};
        o_skip_crc  <= {3{i_skip_crc}};
        o_num_valid <= num_valid_next;
        o_inframe   <= inframe_next;
    end

    always_comb begin
        if (i_reset) begin
            num_valid_next = 2'd0;
            inframe_next   = 3'b000;
        end else begin
            if (i_valid) begin
                if (mode == INFRAME) begin
                    if (i_eop) begin
                        if (i_empty[3]) begin
                            num_valid_next = 2'd1;
                            inframe_next   = 3'b000;
                        end else begin
                            num_valid_next = 2'd2;
                            inframe_next   = 3'b100;
                        end
                    end else begin
                        num_valid_next = 2'd2;
                        inframe_next   = 3'b110;
                    end
                end else begin
                    if (i_sop) begin
                        if (i_eop) begin
                            if (i_empty[3]) begin
                                num_valid_next = 2'd2;
                                inframe_next   = 3'b100;
                            end else begin
                                num_valid_next = 2'd3;
                                inframe_next   = 3'b110;
                            end
                        end else begin
                            num_valid_next = 2'd3;
                            inframe_next   = 3'b111;
                        end
                    end else begin
                        num_valid_next = 2'd2;
                        inframe_next   = 3'b000;
                    end
                end
            end else begin
                num_valid_next = 2'd0;
                inframe_next   = 3'b000;
            end
        end
    end

    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            mode    <= IDLE;
        end else begin
            if (i_valid) begin
                if (i_eop) begin
                    mode    <= IDLE;
                end else begin
                    if (i_sop) begin
                        mode    <= INFRAME;
                    end else begin
                        mode    <= mode;
                    end
                end
            end else begin
                mode    <= mode;
            end
        end
    end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q44EvC2i2CslvOs/mODScXGkSnsHqGdttDQJ+Xoe37goI4mSU8oA/ksIeDq+lV5y8zGAVAFGPV9M0HUEo8qCPP9RFacA13sAKCkW2a2czSkE8yCX2vid3SuMIQ4uQVl5DG+vgpkMW5jcDOZb72CuVpX+c7mmAJKFE7PMVgIFBEQyFX51/xfTNeqcPk9B0DfNmeNRk+2xF0wyZplHcIee9OGktCZRFqy688mER2bTMu5PTqyCspvZYmEntfRfWQeH+SLhtua8XtQx9IGgERa2htQ6odi0nV1oAbtvtcXyewBexXdb4YlmYg3fs520vGtt1x0807R7etEs0bMCy4XhreBJkDorMBRoqH7nigr7Pcn2lb3e5eaqYsOE1vGxAYInkMyChc4p6z0khcKHRUjNqGQhQph2+lM2RLlcO5hQWftTFIbr/bpEoFLKgd25vMEIsOLHasm91VcgqGhZ+LuV+yGNImkAM2VDuYJ0FVaqA9lT9T4uDSOMf6h/Vn7yV4YGxne4zMHl0OPObva4TgxmFiR+xCS6gzfrdkGooN4NOyWSp3SAjZaMueX7A9aaN9ERrpN7/BdF0ym4UtlTVnomHKHLbVC7+owVXwJydhsEUaerKCz2liHvHRvFppW3v393xW37NlLEVjLLSMyU+3lu4tkWc4BO9fGi2cIm0AzokeQNC8uMj6Fcei1AOl3erMBFQz/FEpcNmDh5HmhAmLYDEfIDzy1JlyUB4/u/YLT9sQLeqG8qIfEqjb1Z5siGyc5qM1ealwIKHLzmSnh0dD1hiDJm"
`endif