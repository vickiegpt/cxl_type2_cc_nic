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

module eth_f_ft_avmm_32to8_bridge 
#( 
    parameter READ_PIPELINE_ENABLE = 1, 
    parameter ADDR_WIDTH = 20
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
   output  logic [ADDR_WIDTH:0]   o_avmm_m8_addr           ,//  ...
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


assign o_avmm_m8_addr  = {dw_acc, i_avmm_s32_addr[ADDR_WIDTH-1:2], cur_byte};
assign o_avmm_m8_wdata = (cur_st==ST_WRITE)? dw_data[cur_byte*8+:8] : 8'h0;
assign o_avmm_m8_write = (cur_st==ST_WRITE)? 1'b1 : 1'b0;
assign o_avmm_m8_read  = (cur_st==ST_READ)? 1'b1 : 1'b0;

assign o_avmm_s32_readdata    = (cur_st==ST_READ_DONE || (READ_PIPELINE_ENABLE && o_avmm_s32_readdatavalid))?
                                dw_data[31:0] : 32'h0;
assign o_avmm_s32_waitrequest = (cur_st==ST_READ_DONE || cur_st==ST_WRITE_DONE)? 1'b0 : 1'b1;


// convertion FSM 
//

always_ff @(posedge i_clk) begin
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
			next_byte = 2'(cur_byte + 1);
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
			next_byte = 2'(cur_byte + 1);
	         end

	 ST_WRITE_DONE: begin
			next_st = ST_IDLE;
	         end

    endcase  

end    // always_comb



endmodule: eth_f_ft_avmm_32to8_bridge
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "o2ONPYJ6JWO2K/lQHkyApXo6DVczB8sUyJtLpEiYtF7LL07s93qi8rQ7d2s1AdTOt/BNVdBoSTLCdACDT58BR3umvYuucV6Cbb36lNsOsJegwtedOJsDvTnB14ZLU41EvDEX+uxr7iJUYiTmn7hunq22K1+T/Nc7+FaTNr6AMH3CCuiZmo/CmXjVXLRPwF034Kg1mVvlsNTpZhm0ORjPpNI8tuMP0bMp6HLhHMKVKvcXL4IVn3Y6dhR0PS3vl9lVXoCkDMXDHeBzuzIyb7txoM5bcB5eZ8XSZGklgh0xvYfBvWxzuvyfHMHogs2+XpsR+n5NC0j5g0OL8R09btSgysBJ1aYHznTA8up+6MXE3T3rLEBjxobdzLKG76/afV/CesflqnCXUx2S423jLubr0YgY+NEG2ULMD6L9Hmg80zfqeKTU5gb6AXWuNb31NTDuLaToQO6fbKJRgPqG9L4BhgkAAMFLVM8nc5slmMGx9Ci1CQ2tR90ij+ChjqZvRn5K+DoK9ofB/OSN8yu46FlCSEsu/p14JAgysixsAEWJw/YacbCgnpefj7zd25yYGxjc4o7wSFJGzwHoXKNbmgrZPIuqG1uBrGwg9YRe4e3x66/ywTXnlJbrX0l8ROiwwnUq0HGfFdsnxfPh7nh8FA/HFlP8YNRB5l4Vf8vNkhDAzQFdboII8OABFXTT46s6bVIgfANDDBvc9LK3I3NzjRZa+atJU3hPLfHmJDp4Urh+0jLyzJQkOGilADF/8Ydz+LX+bDrwQvY5hNS6jMJGug0tBTSLp9N6lpqGF6omWCikR9Hrap7DDC+nWmOH7ApI/OI5Vpkd6+ybtFEWoP3QocCdcdYlBhRitXUVeBCZfcICKRaY6EtA/ofKWIi8W/6Jl6V61f96TLDPA6uJAxBZ96F8rMROTeamOxN8SfqYX8aUFIiOrOMhihqpfSSrKgSnFtHJ76X6zPRzZAmLjHY0Pvy980K4ljKj1aRpmRN/HT6rVj/imRIytAc5chmY2Y6uMJ+N"
`endif