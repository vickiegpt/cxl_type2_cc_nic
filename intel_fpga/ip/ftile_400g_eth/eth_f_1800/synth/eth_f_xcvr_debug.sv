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


`timescale 1ps/1ps
 
module eth_f_xcvr_debug
#(
    parameter LANE_NUM = 8,
    parameter ADDR_WIDTH = 18
 
)
(
    // Clock and Reset
    input   wire                                i_reconfig_clk, 
    input   wire                                i_reconfig_reset,
	
	// XCVR Reconfig Interface - from FTILE ADME MODULE
    input   wire                     			i_reconfig_ttk_write,
    input   wire    [3:0]            			i_reconfig_ttk_byteenable,
    input   wire                     			i_reconfig_ttk_read,
    input   wire    [ADDR_WIDTH-1:0]      i_reconfig_ttk_addr,
    input   wire    [31:0]           			i_reconfig_ttk_writedata,
    output  wire    [31:0]            			o_reconfig_ttk_readdata,
    output  wire                   				o_reconfig_ttk_readdata_valid,
    output  wire                   				o_reconfig_ttk_waitrequest,
 
    // XCVR Reconfig Interface - USER AVMM MASTER can be Example Design JTAG Master
    input   wire    [LANE_NUM-1:0]              i_reconfig_xcvr_write,
    input   wire    [LANE_NUM*4-1:0]            i_reconfig_xcvr_byteenable,
    input   wire    [LANE_NUM-1:0]              i_reconfig_xcvr_read,
    input   wire    [LANE_NUM*18-1:0]           i_reconfig_xcvr_addr,
    input   wire    [LANE_NUM*32-1:0]           i_reconfig_xcvr_writedata,
    output  wire    [LANE_NUM*32-1:0]            o_reconfig_xcvr_readdata,
    output  wire    [LANE_NUM-1:0]               o_reconfig_xcvr_readdata_valid,
    output  wire    [LANE_NUM-1:0]               o_reconfig_xcvr_waitrequest,
 
    // XCVR Combined Reconfig Interface AVMM SLAVE from Transceiver 0 trhough 7
    output  wire    [LANE_NUM-1:0]              i_reconfig_xcvr_write_jtag_arb,
    output  wire    [LANE_NUM*4-1:0]            i_reconfig_xcvr_byteenable_jtag_arb,
    output  wire    [LANE_NUM-1:0]              i_reconfig_xcvr_read_jtag_arb,
    output  wire    [LANE_NUM*18-1:0]           i_reconfig_xcvr_addr_jtag_arb,
    output  wire    [LANE_NUM*32-1:0]           i_reconfig_xcvr_writedata_jtag_arb,
    input   wire    [LANE_NUM*32-1:0]           o_reconfig_xcvr_readdata_jtag_arb,
    input   wire    [LANE_NUM-1:0]              o_reconfig_xcvr_readdata_valid_jtag_arb,
    input   wire    [LANE_NUM-1:0]              o_reconfig_xcvr_waitrequest_jtag_arb
 
 
);
 

    // Design Example AVMM Decoding

    wire    [LANE_NUM-1:0]      xcvr_cs;
    wire    [LANE_NUM-1:0]      xcvr_jtag_read;
    wire    [LANE_NUM-1:0]      xcvr_jtag_write;
    wire    [LANE_NUM-1:0]      xcvr_jtag_waitrequest;
    wire    [LANE_NUM-1:0]      xcvr_jtag_readdata_valid;
 
    genvar ch;
 
    generate
	//JTAG Addess Decode Scheme for GDR
       
        //jtag to xcvr decode
        for (ch = 0; ch < LANE_NUM; ch=ch+1) begin : XCVR_AVMM_CS
	    `ifdef ALTERA_RESERVED_QIS
              assign xcvr_cs[ch]                  = (LANE_NUM==1)? 1'b1 : (i_reconfig_ttk_addr[ADDR_WIDTH-1:18] == ch)? 1'b1 :1'b0;
            `else
              assign xcvr_cs[ch]                  = (LANE_NUM==1)? 1'b1 : (i_reconfig_ttk_addr[ADDR_WIDTH-1:17] == ch)? 1'b1 :1'b0;
            `endif
            assign xcvr_jtag_read[ch]           = i_reconfig_ttk_read && xcvr_cs[ch];
            assign xcvr_jtag_write[ch]          = i_reconfig_ttk_write && xcvr_cs[ch];
        end

	
	if(LANE_NUM == 8) begin: EIGHT_LANE_MUX
                //ehip vs xcvr decoder 
                assign  o_reconfig_ttk_waitrequest  =   xcvr_cs[0] ? xcvr_jtag_waitrequest[0] :
														xcvr_cs[1] ? xcvr_jtag_waitrequest[1] :
														xcvr_cs[2] ? xcvr_jtag_waitrequest[2] :
														xcvr_cs[3] ? xcvr_jtag_waitrequest[3] :
														xcvr_cs[4] ? xcvr_jtag_waitrequest[4] :
														xcvr_cs[5] ? xcvr_jtag_waitrequest[5] :
														xcvr_cs[6] ? xcvr_jtag_waitrequest[6] :
														xcvr_cs[7] ? xcvr_jtag_waitrequest[7] :
														1'b0;
                assign  o_reconfig_ttk_readdata_valid = xcvr_cs[0] ? xcvr_jtag_readdata_valid[0] :
														xcvr_cs[1] ? xcvr_jtag_readdata_valid[1] :
														xcvr_cs[2] ? xcvr_jtag_readdata_valid[2] :
														xcvr_cs[3] ? xcvr_jtag_readdata_valid[3] :
														xcvr_cs[4] ? xcvr_jtag_readdata_valid[4] :
														xcvr_cs[5] ? xcvr_jtag_readdata_valid[5] :
														xcvr_cs[6] ? xcvr_jtag_readdata_valid[6] :
														xcvr_cs[7] ? xcvr_jtag_readdata_valid[7] :
														1'b0;
                assign  o_reconfig_ttk_readdata     =   xcvr_jtag_readdata_valid[0] ? o_reconfig_xcvr_readdata_jtag_arb[31:0   ] :
														xcvr_jtag_readdata_valid[1] ? o_reconfig_xcvr_readdata_jtag_arb[63:32  ] :
														xcvr_jtag_readdata_valid[2] ? o_reconfig_xcvr_readdata_jtag_arb[95:64  ] :
														xcvr_jtag_readdata_valid[3] ? o_reconfig_xcvr_readdata_jtag_arb[127:96 ] : 
														xcvr_jtag_readdata_valid[4] ? o_reconfig_xcvr_readdata_jtag_arb[159:128] :
														xcvr_jtag_readdata_valid[5] ? o_reconfig_xcvr_readdata_jtag_arb[191:160] :
														xcvr_jtag_readdata_valid[6] ? o_reconfig_xcvr_readdata_jtag_arb[223:192] :
														xcvr_jtag_readdata_valid[7] ? o_reconfig_xcvr_readdata_jtag_arb[255:224] : 
														32'hdeadc0de;
        end
	else if (LANE_NUM == 4) begin: FOUR_LANE_MUX
                //ehip vs xcvr decoder 
                assign  o_reconfig_ttk_waitrequest  =   xcvr_cs[0] ? xcvr_jtag_waitrequest[0] :
														xcvr_cs[1] ? xcvr_jtag_waitrequest[1] :
														xcvr_cs[2] ? xcvr_jtag_waitrequest[2] :
														xcvr_cs[3] ? xcvr_jtag_waitrequest[3] :
														1'b0;
                assign  o_reconfig_ttk_readdata_valid  =    xcvr_cs[0] ? xcvr_jtag_readdata_valid[0] :
															xcvr_cs[1] ? xcvr_jtag_readdata_valid[1] :
															xcvr_cs[2] ? xcvr_jtag_readdata_valid[2] :
															xcvr_cs[3] ? xcvr_jtag_readdata_valid[3] :
															1'b0;															 
                assign  o_reconfig_ttk_readdata     =   xcvr_jtag_readdata_valid[0] ? o_reconfig_xcvr_readdata_jtag_arb[31:0   ] :
														xcvr_jtag_readdata_valid[1] ? o_reconfig_xcvr_readdata_jtag_arb[63:32  ] :
														xcvr_jtag_readdata_valid[2] ? o_reconfig_xcvr_readdata_jtag_arb[95:64  ] :
														xcvr_jtag_readdata_valid[3] ? o_reconfig_xcvr_readdata_jtag_arb[127:96 ] : 
														32'hdeadc0de;
        end
	else if (LANE_NUM == 2) begin: TWO_LANE_MUX
                //ehip vs xcvr decoder 
                assign  o_reconfig_ttk_waitrequest  =   xcvr_cs[0] ? xcvr_jtag_waitrequest[0] :
														xcvr_cs[1] ? xcvr_jtag_waitrequest[1] :
														1'b0;
                assign  o_reconfig_ttk_readdata_valid = xcvr_cs[0] ? xcvr_jtag_readdata_valid[0] :
														xcvr_cs[1] ? xcvr_jtag_readdata_valid[1] :
														1'b0;															 
                assign  o_reconfig_ttk_readdata     =   xcvr_jtag_readdata_valid[0] ? o_reconfig_xcvr_readdata_jtag_arb[31:0   ] :
														xcvr_jtag_readdata_valid[1] ? o_reconfig_xcvr_readdata_jtag_arb[63:32  ] :
														32'hdeadc0de;
        end
	else if (LANE_NUM == 1) begin: ONE_LANE_MUX
                //ehip vs xcvr decoder 
                assign  o_reconfig_ttk_waitrequest  =   xcvr_cs[0] ? xcvr_jtag_waitrequest[0] :
														1'b0;
                assign  o_reconfig_ttk_readdata_valid = xcvr_cs[0] ? xcvr_jtag_readdata_valid[0] :
														1'b0;															 
                assign  o_reconfig_ttk_readdata     =   xcvr_jtag_readdata_valid[0] ? o_reconfig_xcvr_readdata_jtag_arb[31:0   ] :
														32'hdeadc0de;
        end
 
 
    for (ch = 0; ch < LANE_NUM; ch=ch+1) begin : XCVR_JTAG_ARB
 
    eth_f_rcfg_arb #(
            .TOTAL_MASTERS  (2), // Reuse arbiter from alt_xcvr_avmm_arb.sv 
            .CHANNELS       (1),
            .ADDRESS_WIDTH  (18),
            .DATA_WIDTH     (32)
    ) arb_jtag_xcvr (
 
            // Basic AVMM inputs
            .ini_clk            (i_reconfig_clk),
            .ini_reset          (i_reconfig_reset),
            // USER and JTAG EHIP Reconfig
            .ini_read           ({i_reconfig_xcvr_read[ch], xcvr_jtag_read[ch]}),
            .ini_write          ({i_reconfig_xcvr_write[ch], xcvr_jtag_write[ch]}),
            .ini_address        ({i_reconfig_xcvr_addr[ch*18+:18], i_reconfig_ttk_addr[17:0]}),
            .ini_byteenable     ({i_reconfig_xcvr_byteenable[ch*4+:4],4'hF}),
            .ini_writedata      ({i_reconfig_xcvr_writedata[ch*32+:32], i_reconfig_ttk_writedata}),
            .ini_read_write     ({i_reconfig_xcvr_read[ch] || i_reconfig_xcvr_write[ch], xcvr_jtag_read[ch] || xcvr_jtag_write[ch]}),
            .ini_waitrequest    ({o_reconfig_xcvr_waitrequest[ch], xcvr_jtag_waitrequest[ch]}),
            .ini_readdatavalid  ({o_reconfig_xcvr_readdata_valid[ch], xcvr_jtag_readdata_valid[ch]}),
 
            // Combined EHIP Reconfig
            .avmm_read          (i_reconfig_xcvr_read_jtag_arb[ch]),
            .avmm_write         (i_reconfig_xcvr_write_jtag_arb[ch]),
            .avmm_address       (i_reconfig_xcvr_addr_jtag_arb[ch*18+:18]),
            .avmm_byteenable    (i_reconfig_xcvr_byteenable_jtag_arb[ch*4+:4]),
            .avmm_writedata     (i_reconfig_xcvr_writedata_jtag_arb[ch*32+:32]),
            .avmm_readdatavalid (o_reconfig_xcvr_readdata_valid_jtag_arb[ch]),
            .avmm_waitrequest   (o_reconfig_xcvr_waitrequest_jtag_arb[ch])
 
    );
 
    end
 
    assign o_reconfig_xcvr_readdata = o_reconfig_xcvr_readdata_jtag_arb;
   
    endgenerate
 
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q45O2h1ZLEVXv9CIPNFkCYropWcshlggCPRAr6Yrr21YtUsvHmIKEXMJ9eJEYIkAppyA8qhdFDETJCm3QTsM1pSaSBVBEtTKF4UaLn/2f2adPgaudkqJXeA9DfpElgwmm2y3yg7lDu8PCg0jDf08y2I2aRR324aD4jaRcro8B4WlVGyPIYYrwzgXc4AdbTMUip+nNe9AQHj2Hny4y2jbXlRvFncDB+BNK6Hi0nxDuYzobOEsKh01z3iys08e8ep6Xr58smusbo7smzGe2f+E3f/femkCjNaOuZl7L57lWh0aYkLqqj7JyahiE0ivB9i13PefOPJ1Pg3GOMtvhkwBeY8ZGR+vGvnNi2B5m+y45tUw5TmGQyF4BLRoBxjFIL4wPuzXr932DemyLCsZxolbaq1ppJw6EVah2MPVAb9TkASVgk/cobwcmaAOBtj/lSToNkdprDmKvZ+dZBzr+acRUAOO2bE+0FlESNjBXaS/TQWW+WiCNbyEBigE9ISYQOEReiQ81a+wZDwgH0IEVF4cD1noI2yUCiyqNSDZqQNa5IMlXTdfz/XIJdvPARWrSQE0Y+iXz9wyO0iDnSCtU2FuAlcXMSTUxhiS2blveJxRMibo2rGwMN8kj4T6NLXAPntd/z7YKAh4C0cdQ4qQTw0wa+UEsic0sux/AjKkoM6Ajw7dCr50tpJE+OnpNnUSs/eLX9jNVsqOCEzCkOoMJ59LNEjxmoZbJORJpQR974TcsPfgse/0e7obgUBkwFq8xVFTLqitbhSrC1wywuyJEErMgL/F"
`endif