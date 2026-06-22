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


// The modeule converts a 32-bit data bus AVMM I/F into a native 
// GDR 8-bit data bus AVMM I/F. The msb of output addr is the indication
// of DWord_Access
 
module ft_avmm_32to8_bridge 
#(  
    parameter READ_PIPELINE_ENABLE = 0, 
    parameter ADDR_WIDTH = 18
) (
   // AVMM slave Port
   input  logic                  i_clk                 ,// 
   input  logic                  i_rst                 ,// 
   
   input  logic [ADDR_WIDTH-1:0] i_avmm_s32_addr           ,// 
   input  logic [31:0]           i_avmm_s32_wdata          ,//
   input  logic                  i_avmm_s32_write          ,//
   input  logic                  i_avmm_s32_read           ,//
   input  logic [3:0]            i_avmm_s32_byte_enable    ,//
   output logic [31:0]           o_avmm_s32_readdata       ,//
   output logic                  o_avmm_s32_waitrequest    ,//
   output logic                  o_avmm_s32_readdatavalid  ,// 
 
   // AVMMM master Port
   output  logic [ADDR_WIDTH+2:0] o_avmm_m8_addr           ,//  <1-bit DW_ACC>, <s32_addr>, <2-bit byte addr>
   output  logic [7:0]            o_avmm_m8_wdata          ,//
   output  logic                  o_avmm_m8_write          ,//
   output  logic                  o_avmm_m8_read           ,//
   input   logic [7:0]            i_avmm_m8_readdata       ,//
   input   logic                  i_avmm_m8_waitrequest     //
);
 
logic [1:0] byte_end, cur_byte, next_byte;  // to represent byteenables
logic       dw_acc;              // 32-bit DWord_access
logic [31:0] dw_data, next_dw_data ;
 
logic [2:0] cur_st, next_st;       // idle, read, write, read_done, or write_done, 
 
localparam ST_IDLE        = 3'b000;
localparam ST_READ        = 3'b001;
localparam ST_READ_PAUSE  = 3'b010;
localparam ST_READ_DONE   = 3'b011;
localparam ST_WRITE       = 3'b100;
localparam ST_WRITE_PAUSE = 3'b101;
localparam ST_WRITE_DONE  = 3'b110;
 
 
assign o_avmm_m8_addr  = {dw_acc, i_avmm_s32_addr[ADDR_WIDTH-1:0], cur_byte};
assign o_avmm_m8_wdata = (cur_st==ST_WRITE)? dw_data[cur_byte*8+:8] : 8'h0;
assign o_avmm_m8_write = (cur_st==ST_WRITE)? 1'b1 : 1'b0;
assign o_avmm_m8_read  = (cur_st==ST_READ)? 1'b1 : 1'b0;
 
assign o_avmm_s32_readdata    = (cur_st==ST_READ_DONE || (READ_PIPELINE_ENABLE && o_avmm_s32_readdatavalid))?
                                dw_data[31:0] : 32'h0;
assign o_avmm_s32_waitrequest = (cur_st==ST_READ_DONE || cur_st==ST_WRITE_DONE)? 1'b0 : 1'b1;
 
 
// convertion FSM 
//
 
always_ff @(posedge i_clk or posedge i_rst) begin
    if (i_rst) begin
        cur_st     <= ST_IDLE;
	dw_data    <= 32'h0;
       	cur_byte   <= 2'b00;   
        o_avmm_s32_readdatavalid <= 1'b0;
    
	dw_acc     <= 1'b0;
	byte_end   <= 2'b00;
    end else begin   // non-reset
	cur_st     <= next_st;
       	cur_byte   <= next_byte;
        dw_data    <= next_dw_data;
	o_avmm_s32_readdatavalid  <= ( READ_PIPELINE_ENABLE && (cur_st==ST_READ_DONE) )? 1'b1 : 1'b0;
	
	if (cur_st==ST_IDLE) begin
	    if (i_avmm_s32_write || i_avmm_s32_read)  begin
		dw_acc <= ( (i_avmm_s32_byte_enable==4'hf) || (i_avmm_s32_byte_enable==4'h0) )? 1'b1 : 1'b0;
		byte_end <= (i_avmm_s32_byte_enable[3])? 2'b11 : (i_avmm_s32_byte_enable[2])? 2'b10 : 
			(i_avmm_s32_byte_enable[1])? 2'b01 : (i_avmm_s32_byte_enable[0])? 2'b00 : 2'b11;
	     end  else begin	// no access
	             dw_acc       <= 1'b0;
		     byte_end     <= 2'b00;
             end 
	end       // ST_IDLE
    end           // non-reset
end     // always
 
 
always_comb  begin
    next_st      = cur_st;
    next_byte    = cur_byte;
    next_dw_data = dw_data;
 
    case (cur_st) 
	ST_IDLE: begin
		if (i_avmm_s32_write || i_avmm_s32_read) begin
			next_st = (i_avmm_s32_write)? ST_WRITE : ST_READ;
		        next_byte = (i_avmm_s32_byte_enable[0])? 2'b00 : (i_avmm_s32_byte_enable[1])? 2'b01 : 
			            (i_avmm_s32_byte_enable[2])? 2'b10 : (i_avmm_s32_byte_enable[3])? 2'b11 : 2'b00;
		        next_dw_data = (i_avmm_s32_write)? i_avmm_s32_wdata : 32'h0;
		    end   // read or write
	         end
 
	ST_READ: begin
		if ( ~i_avmm_m8_waitrequest ) begin
			next_st = (cur_byte==byte_end)? ST_READ_DONE : ST_READ_PAUSE;
			next_dw_data[cur_byte*8+:8] = i_avmm_m8_readdata;
		    end
	         end
 
	 ST_READ_PAUSE: begin
			next_st = ST_READ;
			next_byte = cur_byte + 1'b1;
	         end
 
	 ST_READ_DONE: begin
			next_st = ST_IDLE;
	         end
 
	 ST_WRITE: begin
		if ( ~i_avmm_m8_waitrequest ) begin
			next_st = (cur_byte==byte_end)? ST_WRITE_DONE : ST_WRITE_PAUSE;
		    end
	         end
 
	 ST_WRITE_PAUSE: begin
			next_st = ST_WRITE;
			next_byte = cur_byte + 1'b1;
	         end
 
	 ST_WRITE_DONE: begin
			next_st = ST_IDLE;
	         end
 
    endcase  
 
end    // always_comb
 
 
 
endmodule: ft_avmm_32to8_bridge
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "WfFVdyql8MX8mXVyk/o4uVHSVnI9UjJRGwwb336nmAdX9+mpbJ6mSUQss63YcuDLPsviS3zV3x4H9/ufzDWJhiMsMk5su3c3a5t6emal0wmMuzlCaBg8nX2HnASXWZFYdD2lZ2f9WQiT7YBk8pWHWPxL53F3O5UwUiGEgA9T6isaFpMPrEoSO+HPNTvZNfnymv7c7T92tiM6OA3+qWyhLObaJSiFnbSgEzJeHEkIUwqVZ3kUcHLwuYTXHVdhkZB5Na5f7V3yiiQEhbipMq+drIJU4xSoC9uPn7B1lP9r47TsdQ1AzBw0b/ik6kDNkc3QorYS7iHPOUKjDKvjSxBEkGwMHEQogIvFR9rBFxKmZzr1a45X4FBiQpxMp8MXwWp+h/AxzcEC0bn4VNMpinSgB7O3r6XkvO4vrWGdITYr+D1ma2dCJwYbUqf6yU8Vtwi3gGJifv+5bSNo7n7oeNSqgWznr0vHXdpjFxA48bi+e0f9yp5t7aIEP7m2cqtE31rIBwDWflL0km0ajO2TawEEbMINCcAQG7JKuAVJMWutkcpwBqHHPeiiZ+hIdEzolKInNFsY3hdMTOmflqWgUuZGIPUfqrUL+8Q+tVI0LKxcQgWffJsLrlgsHyXN7MBZ3PDY2ZSZnRG59fJeT3nrBldhcvY1A9OzdRNLABDZCfpomQXJ1s8oI1RxtJ4Hj8IRN9E2olo3OblCvBMz8xK2EiA5b8XmwiShJWl/cyPDOoU4GcmdZTyUxQPVXc2BZaeVZcRjzho82HFkGzkzzoLIJR+XqKwVTCbHTVg5BljSsl+eWDulRFvv9VDcSoCfrsynGWooBKcU0JKWpmZiTIZhIDm4AdfQAHqzTeVC9qJbKMGP70X6/jQVlNrZ9XqBEpBZXVnZo5NEkVuXkeZnzTLLL/o2UWAQf16HYa1ynSw0IxqdqWJA3dqW29ae6miYtkB26zdqf1sAzXIq5dIP6Jc3x3p8JfwZimrbQua6ZncCcs1f3nAqsPUuH10UftB3rGRPzKL7"
`endif