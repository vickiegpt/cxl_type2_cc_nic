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

module eth_f_100g_adapter_wptr_addgen (
    input   logic               i_reset,
    input   logic               i_clk,
    input   logic               i_valid,
    output  logic   [0:1][4:0]  lane_ptrs,
    output  logic   [0:3][7:0]  mem_ptrs
);

    logic   [0:1][5:0]  phase;

    assign lane_ptrs[0] = phase[0][5:1];
    assign lane_ptrs[1] = phase[1][5:1];

    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            phase[0]        <= 6'd1;
            phase[1]        <= 6'd0;
            mem_ptrs[0]    <= 8'd0;
            mem_ptrs[1]    <= 8'd1;
            mem_ptrs[2]    <= 8'd2;
            mem_ptrs[3]    <= 8'd3;
        end else begin
            if (i_valid) begin
                phase[0]        <= phase[0] + 1'b1;
                phase[1]        <= phase[1] + 1'b1;
                mem_ptrs[0]    <= mem_ptrs[0] + 8'd4;
                mem_ptrs[1]    <= mem_ptrs[1] + 8'd4;
                mem_ptrs[2]    <= mem_ptrs[2] + 8'd4;
                mem_ptrs[3]    <= mem_ptrs[3] + 8'd4;
            end else begin
                phase[0]        <= phase[0];
                phase[1]        <= phase[1];
                mem_ptrs[0]    <= mem_ptrs[0];
                mem_ptrs[1]    <= mem_ptrs[1];
                mem_ptrs[2]    <= mem_ptrs[2];
                mem_ptrs[3]    <= mem_ptrs[3];
            end
        end
    end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "4AvUa/AX+twoSNmlxf8DfgbJZtLM0FTYaDfqwIVh58kyS9m523ZPwLwxNf/MAu2Ws24gvNuIWubOgwJDJF/J8SquMj7R1nNyipeKzuCa44Ouq3sVSfXA6vNne7RbKwd87qtqmEuaCdIDSUZZO8uw+CWUHgUS5S0PLelh7tY7EIuUsZeE9mUM9zh2JvtzuWMzW1qicCsSFUI1HHB6Owmf0ylz2E7BXtP0spRRZWMpnQ2MoR1QjIKGuYK+Z3tInzIIiuekBZvNwFIrQiPRJUtySvU+beSpyPUaKT73cK9OXnt3duak7lTndtssVAPHquOTEiEiGVosCiV/ebiRiYvKf56H+p9OKqTT1pVXhFzvFqO7a9V1yBbAUyC5Gd0WjddEwKtA3Tqkps5ju4xesR9yS+bupTZEoILGSCtq9vs8NbhNieis986XzkYVH6Bg2Lxka+20cKusjOtEC3YQxzAf2Xl/pTkP4luTOK7siSluekuYzJaNI7bkgk3331as234j77vs6ZZxjrtyQL2h35E50tcTpKUeO2mbhZ59LWJ24Q7Saf843Ihn+SLZ0Ba5at5RYQWej5JK7odswsWmZHak6CpcW+cihhmh3cxCJjxuUbqXQSGIIApxHpEWZ6yeh1sTpV+Aq7B4B90CtnwGxNG5IvMtGJqbkOAcXcb+0xg/+WALCludKJLFagKEV2B2WR0mCpGXG5zhrNzbhhtlO+dFzALTiAuSfKlNUZ1EG+Edj9Jwnbyu2PSCc1rTQIQChg0rQItQj7YpUQkhU79yomP4EkOf+1kD6WsOYmrT7V8JN9Cy17wHLAcTIRRk3O3TWVYd9IhFZAjUwpdWo2f6kEWrzM8ubRqWng+q86J6NdFF2m3mcJrvDrjeeeWjoNomwKw2S8a132AXGrUo9DwMmYiOLMD9ZRgzVCKqEeuMF/kseyj82ImPfTs5+CXLM0Eq5zTswxOT5V6208OFayMs5znC6EiVp9db5m/mT7Hq0uS2/5Y4uh8DNjktS28pULkCWDRz"
`endif