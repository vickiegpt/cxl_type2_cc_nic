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


//****************************************************************************************************************
// Name:        ctfb_avmm_maib_if.sv; based on nadder ct3_xcvr_avmm_soft_logic_core.sv 
// Author:      Ensheng  Huang
// Description: This module provides soft glue logic needed by the transceiver AVMM interfaces 
//                to abstract away the pipelined nature of the transceiver implementation and 
//                provide users a non-pipelined interface that is subject only to a single
//                waitrequest signal. The logic here supports both AVMM1 and AVMM2
//****************************************************************************************************************

module eth_f_ctfb_avmm_maib_if 
#(
  parameter avmm_interface_type  = "avmm1", //Virtual. Valid values: avmm1, avmm2
  parameter rcfg_enable          = 0        //Enable/disable reconfig interface in the Native PHY or PLL IP
)  
(
  // Inputs from user or AVMM atom
  input  wire         avmm_clk,
  input  wire         avmm_reset,
  input  wire  [7:0]  avmm_writedata, 
  input  wire  [20:0] avmm_address,
  input  wire         avmm_write,
  input  wire         avmm_read,
  input  wire  [7:0]  avmm_readdata_int,
  input  wire         avmm_readdatavalid,
  input  wire         avmm_cmdfifo_pfull,
  input  wire         avmm_busy,
  input  wire         avmm_writedone,
  input  wire  [2:0]  avmm_reservedout, 
  
  output reg   [7:0]  avmm_readdata, 
  output wire         soft_avmm_write,  // added to single-pulse writes
  output wire         soft_avmm_read,   // added to single-pulse reads for AVMM2 
  output wire         avmm_waitrequest,
  output wire         avmm_request
  //PORT_LIST_END
  ); 

//****************************************************
//                   LOCALPARAMS
//****************************************************
localparam STARTUP_CNTR_WIDTH       = 3;                      //Width of the start-up wait counter to hold waitrequest high 
localparam MAX_WAIT_STARTUP_CNT     = 3'b111;                 //7 avmm_clk cycles after avmm_clk starts toggling

localparam RESET_SYNC_LEN           = 3;                      //3 flip-flop stage reset synchronizer
localparam RESET_INIT_VAL           = {RESET_SYNC_LEN{1'b1}}; //Init value of the synchronization registers

//****************************************************
//                   SIGNALS
//****************************************************
(* altera_attribute  = "disable_da_rule=D103" *)

wire                          avmm_reset_sync;

reg                           avmm_read_r;
reg                           avmm_readdatavalid_r;
reg                           avmm_readdatavalid_wait;

reg                           avmm_writedone_wait;

reg                           avmm_waitrequest_cmdfifo_pfull;
wire                          avmm_waitrequest_read;
wire                          avmm_waitrequest_write;
reg  [STARTUP_CNTR_WIDTH-1:0] startup_cntr;  

reg                           avmm_write_prev         ; 
wire                          avmm_write_detect       ;
wire                          avmm_write_data_changed ;
wire                          avmm_write_addr_changed ;
reg  [7:0]                    avmm_write_data_prev    ;
reg  [20:0]                   avmm_addr_prev          ;
wire                          crete_write             ; 

assign avmm_reset_sync =avmm_reset;

//***********************************************************************************
//
// Generate avmm_waitrequest
//
//***********************************************************************************
// AVMM slave in hardware:
//  avmm_write -> variable latency 
//  avmm_read  -> variable latency 

//***********************************************************************************
//**************** Generate waitrequest for read operation *************************
// Register avmm_read
always @ (posedge avmm_clk ) begin //sync reset
  if (avmm_reset_sync) begin
    avmm_read_r   <= 1'b0; 
  end else begin
    if (avmm_readdatavalid_r)
      avmm_read_r <= 1'b0; //to indicate the completion of current read
    else 
      avmm_read_r <= avmm_read;
  end
end

// Register avmm_readdatavalid
always @ (posedge avmm_clk ) begin //sync reset
  if (avmm_reset_sync) begin
    avmm_readdatavalid_r  <= 1'b0; 
  end else begin
    avmm_readdatavalid_r  <= avmm_readdatavalid;
  end
end

// Assert:
 //   - when avmm_read is asserted (combinatorially)
 //   - when pfull is asserted (sequentially)
 // Stay asserted:
 //   - there is a pending read AND readdatavalid has not come back
 //   - 
 // Deassert:
 //   - when reset is deasserted (sequentially)
 //   - For a pending read, readdadatavalid has come back (sequentialy)
 //   - 

 // Wait for readdatavalid
 always @ (posedge avmm_clk ) begin //sync reset
   if (avmm_reset_sync) begin
     avmm_readdatavalid_wait <= 1'b0;     
   end else begin
     if (avmm_read & ~avmm_read_r & ~avmm_readdatavalid_wait) begin
       avmm_readdatavalid_wait <= 1'b1;
     end else if (avmm_readdatavalid) begin
       avmm_readdatavalid_wait <= 1'b0;
     end 
     //else
       //no change
   end
 end   

 // waitrequest for read
 assign avmm_waitrequest_read = ( avmm_read  & !avmm_read_r ) | avmm_readdatavalid_wait;

///***********************************************************************************
//**************** Generate waitrequest for write operation *************************

wire write_done_mux;
assign write_done_mux = (avmm_interface_type == "avmm2" ) ? avmm_writedone : avmm_reservedout[1];

always @ (posedge avmm_clk ) begin //sync reset
  if      (avmm_reset_sync)                     avmm_writedone_wait <= 1'b0; 
  else if (soft_avmm_write & crete_write )      avmm_writedone_wait <= 1'b1; 
  else if (write_done_mux & crete_write )  avmm_writedone_wait <= 1'b0; 
end

 //[ADW]: use soft_avmm_write instead of write_detect only  
 //       use avmm_address[8] directly instead of registering
 //       use avmm_reservedout[1] directly instead of registering
 //       avmm_address[9:8]: 2'b00: indicates Crete-side adapter/IP Byte Accesses
 //                          2'b01: indicates Crete-side adapter/IP Dwrod Accesses
 //                          2'b10: Not used with F-tile
 //                          2'b11: indicates Nadder-side adapter accesses
 assign crete_write = (avmm_interface_type == "avmm2" ) ? 1'b1 : (avmm_address[9] == 1'b0);
 //[ADW]: I am generating a waitrequest for all writes
 //       note that is introduces an extra cycle of latency for non-crete writes
 assign avmm_waitrequest_write = (soft_avmm_write | avmm_writedone_wait); 

 always @(posedge avmm_clk ) begin //sync reset
   if      (avmm_reset_sync) begin
     avmm_write_prev      <= 1'b0;
     avmm_write_data_prev <= 8'b0;
     avmm_addr_prev       <= 21'b0;
   end
   else begin
     avmm_write_prev      <= avmm_write;
     avmm_write_data_prev <= avmm_writedata;
     avmm_addr_prev       <= avmm_address;
   end
 end
 
 assign avmm_write_detect       = avmm_write & !avmm_write_prev;
 assign avmm_write_data_changed = avmm_write & (avmm_write_data_prev != avmm_writedata);
 assign avmm_write_addr_changed = avmm_write & (avmm_addr_prev != avmm_address);
 assign soft_avmm_write         = avmm_write_detect | avmm_write_data_changed | avmm_write_addr_changed;
 
//***********************************************************************************
//**************** Generate waitrequest for Command FIFO PFULL***********************
 // Assert:
 //  - when reset is asserted
 //  - when avmm_clk starts toggling first -> using this signal to wait for start-up counter instead of overloading avmm_waitrequest_busy version
 //  - when PFULL = 1 (sequentially)
 // Stay asserted:
 //  - reset
 //  - as long as startup counter != max count defined
 //  - as long as PFULL =  1
 // Deassert:
 //  - when PFULL = 0 (sequentially)
 
//Start-up counter
 always @ (posedge avmm_clk ) begin //sync reset
   if (avmm_reset_sync)
     startup_cntr <= 0; 
   else begin
     if (startup_cntr != MAX_WAIT_STARTUP_CNT) 
       startup_cntr <= startup_cntr + 1'b1; 
   end
 end
 
 always @ (posedge avmm_clk ) begin //sync reset
   if (avmm_reset_sync)
     avmm_waitrequest_cmdfifo_pfull <= 1'b1; //reset to 1 to have waitrequest asserted during reset
   else 
     if (startup_cntr != MAX_WAIT_STARTUP_CNT) 
       avmm_waitrequest_cmdfifo_pfull <= 1'b1;
     else 
       avmm_waitrequest_cmdfifo_pfull <= avmm_cmdfifo_pfull;
 end   
  

 // user waitrequest
 assign avmm_waitrequest = avmm_waitrequest_read | avmm_waitrequest_write | avmm_waitrequest_cmdfifo_pfull;

 //******************************************************************
 //*************** Register readdata to match latency ***************
 always @ (posedge avmm_clk ) begin //sync reset
   if (avmm_reset_sync)
     avmm_readdata[7:0] <= 8'b0; 
   else 
     avmm_readdata[7:0] <= avmm_readdata_int[7:0];
 end  

//***************************************************************************************************************
//
// Generate avmm_request 
//
// If reconfig interface is NOT enabled in the PHY GUI:
//     tie-off avmm_request to 1'b0 => park the avmm_request bit to always be in the "not request" mode => allow Nios to do adaptive calibration

 if(rcfg_enable == 1) begin: g_rcfg_en
     //Park the interface request favoring the user AVMM 
     assign avmm_request = 1'b1; 
 end else begin : g_rcfg_dis
   //Park the interface request favoring the Nios if reconfiguration is not enabled by the user
   assign avmm_request = 1'b0; 
 end 

//***********************************************************************************************************
//
// AVMM2 specific soft block signals to conform to hardware requirements maintaining the same AVMM usemodel
// as AVMM1 interface
//
//***********************************************************************************************************
generate 
if(avmm_interface_type == "avmm2") begin: g_avmm2_block_sig

 reg  avmm_read_prev   ; 
 wire avmm_read_detect ;
wire avmm_read_addr_changed ;
 always @(posedge avmm_clk ) begin //sync reset
   if      (avmm_reset_sync) begin
     avmm_read_prev  <= 1'b0;
   end
   else begin
     avmm_read_prev  <= avmm_read;
   end
 end
 
 assign avmm_read_detect       = avmm_read & !avmm_read_prev;
 assign avmm_read_addr_changed = avmm_read & (avmm_addr_prev != avmm_address);
 assign soft_avmm_read         = avmm_read_detect | avmm_read_addr_changed;

end else 
    assign soft_avmm_read = '0; //not used in avmm1
endgenerate

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "o2ONPYJ6JWO2K/lQHkyApXo6DVczB8sUyJtLpEiYtF7LL07s93qi8rQ7d2s1AdTOt/BNVdBoSTLCdACDT58BR3umvYuucV6Cbb36lNsOsJegwtedOJsDvTnB14ZLU41EvDEX+uxr7iJUYiTmn7hunq22K1+T/Nc7+FaTNr6AMH3CCuiZmo/CmXjVXLRPwF034Kg1mVvlsNTpZhm0ORjPpNI8tuMP0bMp6HLhHMKVKvc2gHMd1yIr91YKgpAxS5kjrQWMuMMqKEDFvUIVhK7S89cQnrbnqL09vywSST9+nC44iVjHrhfEN/9cxywPkLNfVCWWzIfDxndKHTuWYVgrJ/J3tfMGOGHw4gQuRUUjW6Rvi1umtLT9K7EwYaW27Cn4ZIgIsJ4jtaQ75otbEQia0QL1NQuiOAt+CjzHtq/F7/vD3zWZSnAo3D2bf6w6WDNmlgU6e7YfTgll3YepmC1ULvaWzBV/fylIVEhyh8TCOEdK6xX27UrPGrqfJ50qjnjS6DqhfU3REgIEZVE3m/toaKyhcTABz8f7KA6gMezbtvwXGHSd2/wDhbOHG3w9d1ZoCZnrONd5l6xGJlsIsUzN4G3MebbFZF7PMtJPzfgaMCxHLTlfizjVM8Z0L+ugU0BxKFLj3AUMGN7SoK+RQh84EQquePHEJv1gclOCBLWLTb3xio1kZLwawLWFngO7Y432XyQu02AbCQRuc9yy30pw0nQmBVvwzG1Xyhs8Q7Gi7H9cZtO2yMInVRaSsS86trv9mhKUnSGTOyXaKt8POQTb/E21U0sptFdWg2V19bNADJeG7lLBWXfgY1Yn0723rpM6vZwmLYWi6s8BfL8HWeoJsBAvFICdyJM6HdUKgB7LxxOCV2utH/XnwSyQ3n4Qyuogg80rkG1FCA7UYf+Laf+cVAF15TC+FepAbZdlbtretzBJBvmNc0LbFsZ4NHzMZoCHhFPe2gxCkIe6dvmeA3qHzLXfj6Xui5H0bPln6x4RcwCxslekqbLqo3SPPpnysiN1"
`endif