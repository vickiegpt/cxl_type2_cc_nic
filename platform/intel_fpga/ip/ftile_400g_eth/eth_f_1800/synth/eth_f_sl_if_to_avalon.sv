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

module eth_f_sl_if_to_avalon #(
    parameter WORD_WIDTH  = 64,
    parameter EMPTY_BITS  = 3
) (
    input                     i_clk,
    input                     i_reset,

    input  [WORD_WIDTH-1:0]   i_data,
    input  [EMPTY_BITS-1:0]   i_empty,
    input  [1:0]              i_error,
    input                     i_fcs_error,
    input  [2:0]              i_status,
    input                     i_valid,
    input                     i_inframe,

    output reg [WORD_WIDTH-1:0]   o_data,
    output reg                    o_valid,
    output reg                    o_sop,
    output reg                    o_eop,
    output reg [EMPTY_BITS-1:0]   o_empty,
    output reg [5:0]              o_error,
    output reg [39:0]             o_status
);

    //capture all incoming signals
    reg                    inframe_cap;
    reg [WORD_WIDTH-1:0]   data_cap;
    reg [WORD_WIDTH-1:0]   data_realigned_cap;
    reg [EMPTY_BITS-1:0]   empty_cap;
    reg [EMPTY_BITS:0]     empty_cap_calc;
    reg [1:0]              error_cap;
    reg [5:0]              error_pp_cap; //post-processed
    reg                    fcs_error_cap;
    reg [2:0]              status_cap;
    reg [39:0]             status_pp_cap; //post-processed 
    reg                    valid_cap;
    reg                    sop_cap;
    reg                    eop_cap;

    reg [WORD_WIDTH-1:0]   data_shifted;
    reg [EMPTY_BITS-1:0]   empty_shifted;
    reg [5:0]              error_shifted;
    reg [39:0]             status_shifted;

    reg [2:0]              shift_state;
    reg                    start_of_shift;
    reg                    end_of_shift;
    reg                    shift;

    localparam  IDLE_SHIFT     = 3'h0,
                START_OF_SHIFT = 3'h1,
                SHIFT          = 3'h2,
                HOLD_EOP       = 3'h3;

    wire                   inframe        = i_valid ? i_inframe : inframe_cap;
    wire [EMPTY_BITS-1:0]  empty          = i_valid ? i_empty : empty_cap;
    wire [1:0]             error          = i_valid ? i_error : error_cap;
    wire                   fcs_error      = i_valid ? i_fcs_error : fcs_error_cap;
    wire [2:0]             status         = i_valid ? i_status : status_cap;
    wire                   valid          = i_valid & ((inframe && i_empty!=3'd4) | inframe_cap | shift_state==HOLD_EOP); //FB524454 - to make valid only high within a frame
    wire                   sop            = {inframe_cap, inframe} == 2'b01 ? 1'b1 : 1'b0;
    wire                   eop            = {inframe_cap, inframe} == 2'b10 ? 1'b1 : 1'b0;
    wire [WORD_WIDTH-1:0]  data           = i_valid ? i_data : data_cap;
    wire [WORD_WIDTH-1:0]  data_realigned = i_valid ? {data_cap[31:0], i_data[63:32]} : data_realigned_cap;

    wire        malformed_err  = (error == 2'b01) ? 1'b1 : 1'b0;
    wire        crc_err        = fcs_error;
    wire        length_err     = (error == 2'b11) ? 1'b1 : 1'b0;
    wire        size_err  = (error == 2'b10) ? 1'b1 : 1'b0;

    wire [5:0]  error_comb  = {1'b0,length_err,1'b0,size_err,crc_err,malformed_err};

    wire        vlan_svlan   = (status == 3'd5) ? 1'b1 : 1'b0;
    wire        pfc_sfc      = (status == 3'd4) ? 1'b1 : 1'b0;
    wire        bcast_mcast  = (status == 3'd2) ? 1'b1 : 1'b0;
    wire        control      = (status == 3'd7) || (status == 3'd4);

    wire        reserved     = (status == 3'd3) ? 1'b1 : 1'b0; //unused
    wire        illegal      = (status == 3'd6) ? 1'b1 : 1'b0; //unused
    wire        nonfc        = (status == 3'd1) ? 1'b1 : 1'b0; //unused
    wire        nonethertype = (status == 3'd0) ? 1'b1 : 1'b0; //unused

    wire [39:0] status_comb = {2'd0,bcast_mcast,1'd0,pfc_sfc,control,vlan_svlan,33'd0};

    always @(posedge i_clk) begin
      if (i_reset) begin
        inframe_cap          <= 0;
        empty_cap            <= 0;
        data_cap             <= 0;
        data_realigned_cap   <= 0;
        error_cap            <= 0;
        error_pp_cap         <= 0;
        fcs_error_cap        <= 0;
        status_cap           <= 0;
        status_pp_cap        <= 0;
        valid_cap            <= 0;
        sop_cap              <= 0;
        eop_cap              <= 0;
      end
      else begin
        inframe_cap          <= inframe;
        empty_cap            <= empty;
        data_cap             <= data;
        data_realigned_cap   <= data_realigned;
        error_cap            <= error;
        error_pp_cap         <= error_comb;
        fcs_error_cap        <= fcs_error;
        status_cap           <= status;
        status_pp_cap        <= status_comb;
        valid_cap            <= valid;
        sop_cap              <= sop;
        eop_cap              <= eop;
      end
    end

    reg [EMPTY_BITS-1:0]   empty_realigned;

    assign empty_cap_calc = 4'd8-(3'd4-empty_cap);

    always @(posedge i_clk) begin
      if (i_reset) begin
        shift_state     <= 0;
        start_of_shift  <= 0;
        end_of_shift    <= 0;
        empty_realigned <= 0;
        shift           <= 0;
      end
      else begin
        case (shift_state)
        IDLE_SHIFT : begin
                       start_of_shift  <= 0;
                       end_of_shift    <= 0;
                       empty_realigned <= 0;
                       shift           <= 0;
                       if ({inframe_cap,inframe}==2'b01)
                         if (empty==3'd4) begin
                           shift <= 1;
                           //start_of_shift <= 1;
                           shift_state <= START_OF_SHIFT;
                         end
                     end
        START_OF_SHIFT : begin
                           if (i_valid) begin
                             if ({inframe_cap, inframe}==2'b10)
                               shift_state <= IDLE_SHIFT;
                             else
                               shift_state <= SHIFT;
                           end
                           start_of_shift <= 1;
                         end
        SHIFT : begin
                  start_of_shift <= 0;
                  if ({inframe_cap,inframe}==2'b10) begin
                    if (empty>=4) begin
                      empty_realigned <= empty-3'd4;
                      end_of_shift <= 1;
                      shift_state <= IDLE_SHIFT;
                    end
                    else  
                      shift_state <= HOLD_EOP;
                  end
                end
        HOLD_EOP : begin
                     if (i_valid) begin
                       end_of_shift <= 1;
                       empty_realigned <= empty_cap_calc[EMPTY_BITS-1:0];
                       shift_state <= IDLE_SHIFT;
                     end
                   end
        endcase
      end //else
    end //always

    always @(posedge i_clk) begin
      if (i_reset) begin
        data_shifted   <= 0;
        empty_shifted  <= 0;
        error_shifted  <= 0;
        status_shifted <= 0;
      end
      else begin
        data_shifted   <= data_realigned; 
        empty_shifted  <= empty_realigned;
        error_shifted  <= error_pp_cap;
        status_shifted <= status_pp_cap;
      end
    end

    // Output data
    always @* begin
      o_sop    = shift ? start_of_shift : sop_cap;
      o_eop    = shift ? end_of_shift : eop_cap;
      o_data   = shift ? data_shifted : data_cap;
      o_empty  = shift ? empty_realigned: empty_cap;
      o_error  = shift ? (empty_cap>=4 ? error_pp_cap : error_shifted) : error_pp_cap;
      o_status = shift ? (empty_cap>=4 ? status_pp_cap : status_shifted) : status_pp_cap;
      o_valid  = valid_cap;
    end

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q44Afw/RTNkKjwWI55P/IZQjC4x3QL0PEvCv2LgRg279bi65W6IrfPdXzpZms9RC5R5/F4SbaGM6ep1B/tRluPFmlnHfmb5c48aW5Fdu/m+HfkgzsGb+5ojisc2EzSWXSR5uFck6VAOx96yqmH8ZhMJxBxjgF5P5FJGYLz055T7PcDCnuU06WVDl3iAMg0jcEydCZyrJbnA4Gu2QXjg00rlSUS9yaWb1Uj5if1Ir/8yJZNTD/zn8xoP5Ep6mnzK3OLIwP0BMyPDDd0j8gA0/Wm0xsGJ8tk9XJ4/Z/k6avw0w3x51o/mn89kgqOTNao20aoV/JY5B5EWZ5b0bhKRB+gIwTB/bWXHZaTOsTpT0TDoj33T8crqrS5aWK7kP7OZKmb3xP5ahBHipgWg9ZKm95sIQD8I4WS9cCXSfhSAt05TouQMXj/WnZGI0L2aKWXbeA5SkNblubISw7Nl2A+pOYR2gtislIAzf1Y4HqLN8ZdzCkQmpxZBp5osRyB0e3bAPuYRt1pen/i1JDVrC4JCi+fmhF19AlWiPjmhnaCNlFUq5EW0rcR/yLx3tbtAqihkHlvzzNqdRMddDPg1zt7CeN2SSN/xHzXsMat5I6sDdtgLEOb38pAwtW7w7quHmAI0d/TIB0pOWGbIINGMfRfvYJZXG/Rr64E9QUKOl+MCcola3+xIlrH1aiRhY1Vg5Vit3NBwB9UM1o21928K0aufAtkgmRUk68FxIEuz/lvB4o9AGiKIUBFslgtkFBO8+Kde9mFmuRR0G0Z4EcGoZzgu77EXV"
`endif