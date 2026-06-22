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


 
//----------------------------------------------------------------------------- 
//  Project Name:  avmm_bridge_1024_ed                                   
//  Module Name :  intel_pcie_bam_avmm_intf.v                                                                 
//  Description :  This module interfaces with avmm slave, generating the write/read
//                 requests and accepting read back data from slave
//-----------------------------------------------------------------------------  


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module intel_pcie_bam_v2_avmm_intf
   # (
      parameter PFNUM_WIDTH = 2,
      parameter VFNUM_WIDTH = 12,
      parameter BAM_DATAWIDTH = 1024
     )
    (
     input logic                                  clk,
     input logic                                  rst_n,

     output logic [2:0]                           bam_bar_o,
     output logic                                 bam_vfactive_o,
     output logic [PFNUM_WIDTH-1:0]               bam_pfnum_o,
     output logic [VFNUM_WIDTH-1:0]               bam_vfnum_o,
     output logic                                 bam_write_o,
     output logic [63:0]                          bam_address_o,
     output logic [BAM_DATAWIDTH-1:0]                         bam_writedata_o,
     output logic [(BAM_DATAWIDTH/8-1):0]                          bam_byteenable_o,
     output logic [3:0]                           bam_burstcount_o,
     input logic                                  bam_waitrequest_i,
     output logic                                 bam_read_o,
     input logic [BAM_DATAWIDTH-1:0]                          bam_readdata_i,
     input logic                                  bam_readdatavalid_i,
     input logic                                  bam_writeresponsevalid_i,
     input logic [1:0]                            bam_response_i,

     output logic                                 bam_writeresponsevalid_o,

     // Cmd/Data FIFO interface
     output logic                                 avmm_cmd_fifo_rreq_o, 
     input logic [214: 0]                         avmm_cmd_fifo_rdata_i,
     input logic                                  avmm_cmd_fifo_empty_i, 
     
     output logic                                 avmm_data_fifo_rreq_o, 
     input logic [BAM_DATAWIDTH+127: 0]                         avmm_data_fifo_rdata_i,
     
     input  logic                                 cpl_ram_rdreq_i,
     output logic [BAM_DATAWIDTH:0]                         cplram_read_data_o,
     output logic                                 avmm_read_data_valid_o,
     input  logic                                 write_done_i

  );

  localparam [1:0]                      RXM_IDLE       = 2'b00;
  localparam [1:0]                      RXM_POP_CMD    = 2'b01;
  localparam [1:0]                      RXM_WR         = 2'b10;      
  localparam [1:0]                      RXM_RD         = 2'b11;
  
logic                srst_reg;
logic   [1:0]        rxm_state; 
logic   [1:0]        rxm_nxt_state;  
logic                pop_cmd_state; 
logic                wr_state;      
logic                rd_state;      
logic   [3:0]        avmm_burst_counter;
logic                cmd_avail_reg; 
logic                wait_req_reg;
logic   [214:0]      cmd_reg;
logic   [63:0]       avmm_address_reg;
logic   [(BAM_DATAWIDTH/8-1):0]       avmm_rd_be_reg;
logic   [3:0]        avmm_bcnt_reg;  
logic   [11:0]       avmm_vfnum_reg;
logic   [1:0]        avmm_pfnum_reg; 
logic                avmm_vfactive_reg;   
logic                avmm_is_wr_reg;          
logic    [63:0]      avmm_address_reg2;
logic    [63:0]      avmm_address_reg3;
logic    [63:0]      avmm_address_reg4;
logic    [3:0]       avmm_bcnt_reg2;    
logic    [3:0]       avmm_bcnt_reg3;    
logic    [3:0]       avmm_bcnt_reg4;    
logic    [(BAM_DATAWIDTH/8-1):0]      avmm_rd_be_reg2;  
logic    [(BAM_DATAWIDTH/8-1):0]      avmm_rd_be_reg3;  
logic    [11:0]      avmm_vfnum_reg2;  
logic    [11:0]      avmm_vfnum_reg3;   
logic    [11:0]      avmm_vfnum_reg4; 
logic    [1:0]       avmm_pfnum_reg2;  
logic    [1:0]       avmm_pfnum_reg3;  
logic    [1:0]       avmm_pfnum_reg4;  
logic                avmm_vfactive_reg2;     
logic                avmm_vfactive_reg3;     
logic                avmm_vfactive_reg4;    
logic     [2:0]      avmm_bar_reg;  
logic     [2:0]      avmm_bar_reg2;    
logic     [2:0]      avmm_bar_reg3;    
logic     [2:0]      avmm_bar_reg4;    
logic                avmm_wr_reg;  
logic                avmm_wr_reg2; 
logic                avmm_wr_reg3; 
logic                avmm_wr_reg4; 
logic                avmm_rd_reg;  
logic                avmm_rd_reg2; 
logic                avmm_rd_reg3; 
logic                avmm_rd_reg4; 
logic    [63:0]      avmm_be_reg4;
logic    [BAM_DATAWIDTH-1:0]     read_data_reg;  
logic    [1:0]       read_response_reg;  
logic    [8:0]       cplram_wraddr_cntr;
logic    [8:0]       cplram_rdaddr_cntr; 
logic    [3:0]       avmm_bcnt;
logic    [BAM_DATAWIDTH-1:0]     avmm_wrdat_reg4;
logic    [BAM_DATAWIDTH-1:0]     avmm_wrdat_reg3;
logic    [BAM_DATAWIDTH-1:0]     avmm_wrdat_reg2;
logic    [BAM_DATAWIDTH-1:0]     avmm_wrdat_reg1;
logic    [63:0]      avmm_wr_be_reg1;
logic    [63:0]      avmm_wr_be_reg2;
logic    [63:0]      avmm_wr_be_reg3;
logic    [63:0]      avmm_wr_be_reg4;
logic    [(BAM_DATAWIDTH/8-1):0]      avmm_be_reg1;
logic                rd_data_valid_reg;
logic                writeresponsevalid_reg;
logic     [9:0]      cpl_buffer_limit_cntr;
logic                cpl_ram_rdreq_reg;
logic     [9:0]      cpl_buffer_consume_cntr;
logic     [9:0]      cpl_buff_sub;
logic                cpl_buff_ok;
logic                cpl_buff_ok_reg;


always_ff @(posedge clk) 
  begin
  	if(srst_reg)
  	  writeresponsevalid_reg <= 1'b0;
    else
  	  writeresponsevalid_reg <= write_done_i;
   end  
   
 assign bam_writeresponsevalid_o = writeresponsevalid_reg;
	  
always_ff @(posedge clk) 
  begin
    srst_reg        <= ~rst_n;
  end  
 
/// AVMM state machine
always_ff @(posedge clk) 
    if (srst_reg) 
      rxm_state                   <= RXM_IDLE;
   else 
      rxm_state                   <= rxm_nxt_state;  
 
 always_comb 
    case(rxm_state) 
      RXM_IDLE     : 
        if(cmd_avail_reg & ~wait_req_reg & cpl_buff_ok_reg)
          rxm_nxt_state = RXM_POP_CMD;
        else 
           rxm_nxt_state = RXM_IDLE;
      
      RXM_POP_CMD:
        if(avmm_is_wr_reg)
          rxm_nxt_state = RXM_WR;
        else
         rxm_nxt_state = RXM_RD;
      
      RXM_WR:
        if (avmm_burst_counter[3:0] == 4'h1)
          rxm_nxt_state = RXM_IDLE;
        else
          rxm_nxt_state = RXM_WR;
      
      RXM_RD:
        rxm_nxt_state = RXM_IDLE;
      
      default: 
        rxm_nxt_state = RXM_IDLE;
    endcase


assign pop_cmd_state =  (rxm_state == RXM_POP_CMD);
assign wr_state      =  (rxm_state == RXM_WR);  
assign rd_state      =  (rxm_state == RXM_RD);

/// write burst counter
always_ff @(posedge clk) 
    if(pop_cmd_state)
      avmm_burst_counter[3:0] <= avmm_bcnt[3:0];
    else if(wr_state)
      avmm_burst_counter[3:0] <= avmm_burst_counter - 1'b1;

always_ff @(posedge clk)
  begin 
    cmd_avail_reg <= ~avmm_cmd_fifo_empty_i;
    wait_req_reg <= bam_waitrequest_i;
  end

/// latching command
always_ff @(posedge clk) 
    if(pop_cmd_state) begin
        if(BAM_DATAWIDTH == 1024) begin
          cmd_reg[214:0] <= avmm_cmd_fifo_rdata_i;
        end else if(BAM_DATAWIDTH == 512) begin
          cmd_reg[150:0] <= avmm_cmd_fifo_rdata_i[150:0];
        end else if(BAM_DATAWIDTH == 256) begin
          cmd_reg[118:0] <= avmm_cmd_fifo_rdata_i[118:0];
        end
    end

/// decode command
  if(BAM_DATAWIDTH == 1024) begin
    assign avmm_address_reg[63:0] = cmd_reg[63:0];
    assign avmm_rd_be_reg[127:0]   = cmd_reg[191:64];
    assign avmm_bcnt_reg[3:0]     = cmd_reg[195:192];
    assign avmm_vfnum_reg[11:0]   = cmd_reg[207:196];
    assign avmm_pfnum_reg[1:0]    = cmd_reg[209:208];
    assign avmm_bar_reg[2:0]      = cmd_reg[213:211];
    assign avmm_vfactive_reg      = cmd_reg[210];
    assign avmm_is_wr_reg             = avmm_cmd_fifo_rdata_i[214];
    assign avmm_bcnt[3:0]         = avmm_cmd_fifo_rdata_i[195:192];
  end else if(BAM_DATAWIDTH == 512) begin
    assign avmm_address_reg[63:0] = cmd_reg[63:0];
    assign avmm_rd_be_reg[63:0]   = cmd_reg[127:64];
    assign avmm_bcnt_reg[3:0]     = cmd_reg[131:128];
    assign avmm_vfnum_reg[11:0]   = cmd_reg[143:132];
    assign avmm_pfnum_reg[1:0]    = cmd_reg[145:144];
    assign avmm_bar_reg[2:0]      = cmd_reg[149:147];
    assign avmm_vfactive_reg      = cmd_reg[146];
    assign avmm_is_wr_reg             = avmm_cmd_fifo_rdata_i[150];
    assign avmm_bcnt[3:0]         = avmm_cmd_fifo_rdata_i[131:128];
  end else if(BAM_DATAWIDTH == 256) begin
    assign avmm_address_reg[63:0] = cmd_reg[63:0];
    assign avmm_rd_be_reg[31:0]   = cmd_reg[95:64];
    assign avmm_bcnt_reg[3:0]     = cmd_reg[99:96];
    assign avmm_vfnum_reg[11:0]   = cmd_reg[111:100];
    assign avmm_pfnum_reg[1:0]    = cmd_reg[113:112];
    assign avmm_bar_reg[2:0]      = cmd_reg[117:115];
    assign avmm_vfactive_reg      = cmd_reg[114];
    assign avmm_is_wr_reg             = avmm_cmd_fifo_rdata_i[118];
    assign avmm_bcnt[3:0]         = avmm_cmd_fifo_rdata_i[99:96];
  end


//avmm pipe-line

always_ff @(posedge clk)
  begin
  	avmm_address_reg2[63:0] <= avmm_address_reg;
  	avmm_address_reg3[63:0] <= avmm_address_reg2;
  	avmm_address_reg4[63:0] <= avmm_address_reg3;
  	avmm_bcnt_reg2[3:0]     <= avmm_bcnt_reg;
  	avmm_bcnt_reg3[3:0]     <= avmm_bcnt_reg2;
  	avmm_bcnt_reg4[3:0]     <= avmm_bcnt_reg3;  
        if(BAM_DATAWIDTH == 1024) begin
          avmm_rd_be_reg2[127:0]   <= avmm_rd_be_reg;
          avmm_rd_be_reg3[127:0]   <= avmm_rd_be_reg2;
        end else if(BAM_DATAWIDTH == 512) begin
          avmm_rd_be_reg2[63:0]   <= avmm_rd_be_reg;
          avmm_rd_be_reg3[63:0]   <= avmm_rd_be_reg2;
        end else if(BAM_DATAWIDTH == 256) begin
          avmm_rd_be_reg2[31:0]   <= avmm_rd_be_reg;
          avmm_rd_be_reg3[31:0]   <= avmm_rd_be_reg2;
        end
  	avmm_vfnum_reg2[11:0]   <= avmm_vfnum_reg; 
  	avmm_vfnum_reg3[11:0]   <= avmm_vfnum_reg2;   	
    avmm_vfnum_reg4[11:0]   <= avmm_vfnum_reg3;	
  	avmm_pfnum_reg2[1:0]    <= avmm_pfnum_reg;
    avmm_pfnum_reg3[1:0]    <= avmm_pfnum_reg2;	
    avmm_pfnum_reg4[1:0]    <= avmm_pfnum_reg3;    
    avmm_vfactive_reg2      <= avmm_vfactive_reg;  
    avmm_vfactive_reg3      <= avmm_vfactive_reg2;	
    avmm_vfactive_reg4      <= avmm_vfactive_reg3;	
    avmm_bar_reg2[2:0]       <= avmm_bar_reg;
    avmm_bar_reg3[2:0]       <= avmm_bar_reg2;   
    avmm_bar_reg4[2:0]       <= avmm_bar_reg3;
     
  end
 
always_ff @(posedge clk)
 if(~rst_n)
   begin
    avmm_wr_reg  <=  1'b0;
    avmm_wr_reg2 <=  1'b0;
    avmm_wr_reg3 <=  1'b0;
    avmm_wr_reg4 <=  1'b0;
    avmm_rd_reg  <=  1'b0;
    avmm_rd_reg2 <=  1'b0;
    avmm_rd_reg3 <=  1'b0;
    avmm_rd_reg4 <=  1'b0;
   end
 else
  begin
    avmm_wr_reg  <=  wr_state;
    avmm_wr_reg2 <=  avmm_wr_reg;
    avmm_wr_reg3 <=  avmm_wr_reg2;
    avmm_wr_reg4 <=  avmm_wr_reg3;
    avmm_rd_reg  <=  rd_state;
    avmm_rd_reg2 <=  avmm_rd_reg;
    avmm_rd_reg3 <=  avmm_rd_reg2;
    avmm_rd_reg4 <=  avmm_rd_reg3;
  end 

/// Write Data pipeline                                       
always_ff @(posedge clk)      
  begin                                
    avmm_wrdat_reg1[BAM_DATAWIDTH-1:0] <= avmm_data_fifo_rdata_i[BAM_DATAWIDTH-1:0];   
    avmm_wrdat_reg2[BAM_DATAWIDTH-1:0] <= avmm_wrdat_reg1[BAM_DATAWIDTH-1:0]; 
    avmm_wrdat_reg3[BAM_DATAWIDTH-1:0] <= avmm_wrdat_reg2[BAM_DATAWIDTH-1:0]; 
    avmm_wrdat_reg4[BAM_DATAWIDTH-1:0] <= avmm_wrdat_reg3[BAM_DATAWIDTH-1:0];
  end 


always_ff @(posedge clk)
  begin
    if(BAM_DATAWIDTH == 1024) begin
       avmm_be_reg1[127:0]     <= rd_state? avmm_rd_be_reg[127:0]: avmm_data_fifo_rdata_i[BAM_DATAWIDTH+127:BAM_DATAWIDTH];
     end else if(BAM_DATAWIDTH == 512) begin
       avmm_be_reg1[63:0]     <= rd_state? avmm_rd_be_reg[63:0]: avmm_data_fifo_rdata_i[BAM_DATAWIDTH+63:BAM_DATAWIDTH];
     end else if(BAM_DATAWIDTH == 256) begin
       avmm_be_reg1[31:0]     <= rd_state? avmm_rd_be_reg[31:0]: avmm_data_fifo_rdata_i[BAM_DATAWIDTH+31:BAM_DATAWIDTH];
     end
  end

assign bam_write_o = avmm_wr_reg;
if(BAM_DATAWIDTH == 1024) begin
  assign bam_address_o = {avmm_address_reg2[63:7],7'h0};
end else if(BAM_DATAWIDTH == 512) begin
  assign bam_address_o = {avmm_address_reg2[63:6],6'h0};
end else if(BAM_DATAWIDTH == 256) begin
  assign bam_address_o = {avmm_address_reg2[63:5],5'h0};
end
//assign bam_address_o = {avmm_address_reg2[63:6],6'h0};
assign bam_writedata_o = avmm_wrdat_reg1;
assign bam_byteenable_o = avmm_be_reg1  ;
assign bam_burstcount_o = avmm_bcnt_reg;
assign bam_read_o = avmm_rd_reg;
assign bam_bar_o[2:0] = avmm_bar_reg2;
assign bam_vfactive_o = avmm_vfactive_reg2; 
assign bam_pfnum_o = avmm_pfnum_reg2;     
assign bam_vfnum_o = avmm_vfnum_reg2;     

assign avmm_cmd_fifo_rreq_o = pop_cmd_state;
assign avmm_data_fifo_rreq_o = wr_state;              

/// Read response buffer
 altsyncram
        #(
          .intended_device_family("Stratix 10"),
          .operation_mode("DUAL_PORT"),
          .width_a(BAM_DATAWIDTH+1),
          .widthad_a(9),
          .numwords_a(512),
          .width_b(BAM_DATAWIDTH+1),
          .widthad_b(9),
          .numwords_b(512),
          .lpm_type("altsyncram"),
          .width_byteena_a(1),
          .outdata_reg_b("UNREGISTERED"),
          .indata_aclr_a("NONE"),
          .wrcontrol_aclr_a("NONE"),
          .address_aclr_a("NONE"),
          .address_reg_b("CLOCK0"),
          .address_aclr_b("NONE"),
          .outdata_aclr_b("NONE"),
          .power_up_uninitialized("FALSE"),
          .ram_block_type("AUTO"),
          .read_during_write_mode_mixed_ports("OLD_DATA")
        )

    cplram_data_buff (
                   .wren_a (rd_data_valid_reg),
                   .clocken1 (),
                   .clock0 (clk),
                   .clock1 (),
                   .address_a (cplram_wraddr_cntr[8:0]),
                   .address_b (cplram_rdaddr_cntr[8:0]),
                   .data_a ({|read_response_reg,read_data_reg}),
                   .q_b (cplram_read_data_o),
                   .aclr0 (),
                   .aclr1 (),
                   .addressstall_a (),
                   .addressstall_b (),
                   .byteena_a (),
                   .byteena_b (),
                   .clocken0 (),
                   .data_b (),
                   .q_a (),
                   .rden_b (),
                   .wren_b ()
                   );

//


always_ff @(posedge clk) 
  begin
    read_data_reg   <= bam_readdata_i;
    read_response_reg[1:0] <= bam_response_i; 
    rd_data_valid_reg      <= bam_readdatavalid_i;
end
  
always_ff @(posedge clk) 
    if (srst_reg) 
      cplram_wraddr_cntr[8:0] <= 9'h0;
    else if(rd_data_valid_reg)
      cplram_wraddr_cntr[8:0] <= cplram_wraddr_cntr[8:0] + 1'b1;

always_ff @(posedge clk) 
    if (srst_reg) 
      cplram_rdaddr_cntr[8:0] <= 9'h0;
    else if(cpl_ram_rdreq_i)
      cplram_rdaddr_cntr[8:0] <= cplram_rdaddr_cntr[8:0] + 1'b1;

assign avmm_read_data_valid_o = rd_data_valid_reg;
      
      
/// buffer size monitor

 always @(posedge clk)
      begin
        if(srst_reg)
          cpl_buffer_limit_cntr <= 10'h1E0; 
        else if (cpl_ram_rdreq_reg)
          cpl_buffer_limit_cntr <= cpl_buffer_limit_cntr + 10'h1;
      end 
   
always @(posedge clk)
      begin
        if(srst_reg)
          cpl_buffer_consume_cntr <= 10'h0; 
        else if (avmm_rd_reg)
          cpl_buffer_consume_cntr <= cpl_buffer_consume_cntr + avmm_bcnt_reg[3:0];
      end 

 assign cpl_buff_sub = cpl_buffer_limit_cntr - cpl_buffer_consume_cntr;

  assign cpl_buff_ok = cpl_buff_sub <= 10'd512;

  always @ (posedge clk)
    begin 
      cpl_buff_ok_reg   <= cpl_buff_ok;
      cpl_ram_rdreq_reg <= cpl_ram_rdreq_i;
    end

endmodule

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "Ct7RU5a/p+bqNMEu7Q8vVGkxrD9sml63wG3pH4RTYVLEkGP54+ko4S6h4izCOGh2sb1MtzKT4NgdJp4xN+yn2JGIZmbeOFlk7RGH2eFw9e3st+RwkxWCxS7KD1tPqriXtOc8UJty5UDKXbnNqnBAVeHZ6nPhWp1yOkMMqFi8IxMQBLtdbH85F6ety+Cx+QHBoe8B/SyEjMHeHo/WVdxxY872sbe9f+B4kDnQPeiLXt5Yao9tZRdOEHitsvgdeJhbzEvRSx3nRbgYLeaNeRw03kZstjw2xw8xpnIfokTEoDa/SvWV7B2siLNQhnhNFfG6WVTB/DWDdRKSnwsbZZsytdW+di1CwBoOlBfG0zawlaeuNSqqtylcEVYtBK2862nPy0c9TDZGI1KGfRp4JZ9OBm0voBydzVXfHcZaJPKSeWg+a0en1pPc0LSTahoZHcgA3EaW32MY6YWP1sPdsbU/r43yfWgE6XcqbwkUV6yHpm57QgXN9ppTOHdeVPlfRZI3cSGXSz+h+FZXk0w8SjLSh7GKu8R6C0MpG1AUK4FubACpEBDLDhxlbNLCnXQIs/OC9NiiDt7P5QOY+EzEiCTvbYXkzt4JU9xSUkCm4OcDhCk3z62cfmiFVpGWXM74SnmwscWPZc75kcjGqNG6/y/Z2xe6GTTgVQUeuIinNf9vaFMZYsibB1Y3YnU4RAN/yZY3bXc/NofJF2tKqjp8G4BQsy1oh5TGlfRUBjUCUMPayGNWOolg1mDj+PIxzbBwnO7KZYOHm3uvoG0i6Zk9SYXUjH807MAMy8uzH1cAWto7yAwF2UAG1M1+/CvVV8BcRHdd++UwfTJtNsuDXBdxghK71tSigPnzK9BHd4KJzQbkNsQKvTeEtpoB0nJs6ghf3OUfkiPUtGi7FXZGLI2RtdLqZXBe7bbXTbaNMjfbQ7BLf2nuEoNpu2eYx7EXUXNgzPNSUrchUB7m/1hdXR+XbuekOJbCF/ctD5fZk2ABhCDWHgP4s2VEWz2Yi6sxq2tPTa96"
`endif