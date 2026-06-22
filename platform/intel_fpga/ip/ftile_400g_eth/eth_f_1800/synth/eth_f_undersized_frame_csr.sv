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


module eth_f_undersized_frame_csr #(
    parameter PREAMBLE_PASSTHROUGH  = 0,
    parameter CRC_PASSTHROUGH       = 0,
    parameter MIN_FRAME_SIZE        = 16'd64
) (
    input   logic           clk,
    input   logic           reset,

    input   logic   [31:0]  avmm_addr,
    input   logic   [31:0]  avmm_data,
    input   logic           avmm_write,

    output  logic   [15:0]  min_mac_octets
);

    logic           crc_pass_en;
    logic           pream_pass_en;

    logic   [15:0]  crc_offset;
    logic   [15:0]  pream_offset;

    assign crc_offset   = crc_pass_en   ? 16'd0 : -16'd4;
    assign pream_offset = pream_pass_en ? 16'd8 :  16'd0;

    always_ff @(posedge clk) begin
        min_mac_octets   <= 16'(MIN_FRAME_SIZE[15:0] + crc_offset + pream_offset);
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            crc_pass_en     <= CRC_PASSTHROUGH;
            pream_pass_en   <= PREAMBLE_PASSTHROUGH;
        end else begin
            crc_pass_en     <= crc_pass_en;
            pream_pass_en   <= pream_pass_en;
            if (avmm_write) begin
                case (avmm_addr) inside
                    32'h507 : crc_pass_en   <= avmm_data[0];
                    32'h50B : pream_pass_en <= avmm_data[0];
                endcase
            end
        end
    end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "4AvUa/AX+twoSNmlxf8DfgbJZtLM0FTYaDfqwIVh58kyS9m523ZPwLwxNf/MAu2Ws24gvNuIWubOgwJDJF/J8SquMj7R1nNyipeKzuCa44Ouq3sVSfXA6vNne7RbKwd87qtqmEuaCdIDSUZZO8uw+CWUHgUS5S0PLelh7tY7EIuUsZeE9mUM9zh2JvtzuWMzW1qicCsSFUI1HHB6Owmf0ylz2E7BXtP0spRRZWMpnQ0soM+47ZIeMvwYcQTPYncg7JAQmWo/kvLOLJ/1Q5OZyIcCL5rlKBKYt/H5PA9Bc2VauYTU1OC+VDt2wUQBDYpXPE6hRBGvxC0+V6KPQmLNBBDyaxIcy4URrC0DRvr+t8QYpIkLp5shLPu0DXXOEUxpqMj0HqHQ3V5mL+Ci0QJMGrXoMm78qoZpyyNQ0S1QJTK9BUI+Z2d2L/XZ3gAEQ7EAOOU5fokYF//navaKbrKdfCTEyoUKvaKtEEb8N79M4URlyhmy0XeS1remQww2MSEelt2wuOUDCmiFh5DyGVDRS0yDRRb/vfGrk/0UmQOJloYvs2pEG1kQhvdeNOZucJ/nQbK2FvRoiVYQ8tpkWWOzayKFiXTsmeBD3IcTNAy3kZcFFTqjQZ9kMez0lolkRfncXtYtusYHuhEX3sfNVwS+pFMbTYzn9ku+iWqmmhjX70+RuMDhJHBtLcUhTRApomjWMTw2AHt89gpLtL8PetMh05ezUBbA+RrSRa8LTpaMxXi5yY6eEK5O+BfYq/nCBUV1+gDevC1EwgTJritYa04AV+qEHi2CqPMBHJwzoCnWczyS8ygnn2kg9RaRWdfQjQNytyOk6NlRrFkv0uK2kcqK+A791L3+wOKhurhJ57y8XSseWJ5QJiPGKjv/TMBo2/bQWgEYRbZ+XuHXk1pOkz74eytm4T2iB+aRPDEv5IqAlPQ01mSHiIrOG61RLxo2AU4OFaEmBKHJXSXOhKQP76G/3cvcJk5jrOJahj+PpnoVw1iIuTFeTi/BnnsgXWGjec5K"
`endif