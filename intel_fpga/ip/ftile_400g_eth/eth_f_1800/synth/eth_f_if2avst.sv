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

module eth_f_if2avst #(
    parameter MASK_VALID = 1,
    parameter EHIP_RATE="50G",
    parameter I_BLOCK=(EHIP_RATE=="100G")? 8:2,
    parameter BIT_WIDTH=(EHIP_RATE=="100G")? 6:4,
    parameter SEL_EMP=(EHIP_RATE=="100G")? 3:4
	
) (
    input  logic                              i_clk,
    input  logic                              i_reset,
	
    input  logic  [0:I_BLOCK-1]               i_inframe,
    input  logic                              i_valid,
    input  wire   [0:I_BLOCK-1][2:0]          i_status,
    input  logic  [0:I_BLOCK-1]               i_fcs_error,
    input  wire   [0:I_BLOCK-1][2:0]          i_empty,
    input  wire   [0:I_BLOCK-1][1:0]          i_error,

    output logic  [BIT_WIDTH-1:0]             o_empty,   
    output logic                              o_sop,
    output logic                              o_eop,
    output logic                              o_valid,
    output logic  [5:0]                       o_error, 
    output logic  [39:0]                      o_status,
    output logic                              o_status_valid
);

    logic   [SEL_EMP-1:0]                     selected_empty;  
    logic   [1:0]                             selected_error;
    logic                                     selected_fcs_error;
    logic   [2:0]                             selected_status;	

    logic                                     malformed_frame;
    logic                                     crc_error;
    logic                                     length_error;
    logic                                     size_error;
    logic                                     stacked_vlan;
    logic                                     vlan;
    logic                                     control;
    logic                                     pause;
    logic                                     pfc;
    logic                                     vlan_svlan;
    logic                                     pfc_sfc;
    logic                                     bcast_mcast;

    logic                                     inframe_last;
	
	
    always_ff @(posedge i_clk) begin      
        if (i_reset) begin
            inframe_last    <= 1'b0;
        end else begin
            if (i_valid) begin
                inframe_last    <= &i_inframe;
            end else begin
                inframe_last    <= inframe_last; 
            end
        end
    end

    always_ff @(posedge i_clk) begin
        malformed_frame <= (selected_error == 2'd1);     
        crc_error       <= selected_fcs_error;             
        length_error    <= (selected_error == 2'd3);
        size_error       <= (selected_error == 2'd2);

        vlan_svlan        <= (selected_status == 3'd5);
        pfc_sfc           <= (selected_status == 3'd4);
        bcast_mcast       <= (selected_status == 3'd2);
        control           <= (selected_status == 3'd4) || (selected_status == 3'd7);
    end

    generate
        if (MASK_VALID) begin                      
            always_ff @(posedge i_clk) begin
                if (i_reset) begin
                    o_valid <= 1'b0;         
                end else begin
                    if (i_valid) begin          
                        o_valid <= inframe_last || i_inframe[0];
                    end else begin
                        o_valid <= 1'b0;  
                    end
                end
            end
        end else begin
            always_ff @(posedge i_clk) begin
                o_valid <= i_valid;            
            end
        end
    endgenerate

   always_ff @(posedge i_clk) begin
	if (i_reset) begin  
		o_sop <=1'b0;   
	end
    else if (i_valid) begin
            if ({inframe_last, i_inframe[0]} == 2'b01) begin
                o_sop   <= 1'b1;
            end else begin
                o_sop   <= 1'b0;                  
            end
        end else begin
            o_sop   <= o_sop; 
        end
    end 

    generate
		always_ff @(posedge i_clk) begin
			if (i_reset) begin                           
				o_eop <= 1'b0;                            
			    o_status_valid <= 1'b0;  
			end
			else if (~i_valid) begin
			     o_status_valid <= 1'b0;
				 o_eop <=1'b0; 
            end					
			else  begin      
					 if (EHIP_RATE=="100G") begin
						case ({inframe_last, i_inframe}) inside
							9'b10???????    : begin o_eop <= 1'b1; o_status_valid <= 1'b1; end
							9'b?10??????    : begin o_eop <= 1'b1; o_status_valid <= 1'b1; end
							9'b?110?????    : begin o_eop <= 1'b1; o_status_valid <= 1'b1; end
							9'b?1110????    : begin o_eop <= 1'b1; o_status_valid <= 1'b1; end
							9'b?11110???    : begin o_eop <= 1'b1; o_status_valid <= 1'b1; end
							9'b?111110??    : begin o_eop <= 1'b1; o_status_valid <= 1'b1; end
							9'b?1111110?    : begin o_eop <= 1'b1; o_status_valid <= 1'b1; end
							9'b?11111110    : begin o_eop <= 1'b1; o_status_valid <= 1'b1; end
							default         : begin o_eop <= 1'b0; o_status_valid <= 1'b0; end
						endcase
					end
					else if (EHIP_RATE=="50G" || EHIP_RATE=="40G") begin
						case ({inframe_last, i_inframe}) inside
							3'b10? : begin o_eop <= 1'b1; o_status_valid <= 1'b1; end 
							3'b?10 : begin o_eop <= 1'b1; o_status_valid <= 1'b1; end
							default: begin o_eop <= 1'b0; o_status_valid <= 1'b0; end
						endcase
					end
					else
					o_eop <=1'b0; 	
			end
		end
    endgenerate
   
	generate
		always_comb begin
			if (EHIP_RATE=="100G") begin
				case (i_inframe) inside
					8'b0??????? : begin
						selected_empty      = i_empty[0];
						selected_error      = i_error[0];
						selected_fcs_error  = i_fcs_error[0];
						selected_status     = i_status[0];
					end
					8'b10?????? : begin
						selected_empty      = i_empty[1];
						selected_error      = i_error[1];
						selected_fcs_error  = i_fcs_error[1];
						selected_status     = i_status[1];
					end
					8'b110????? : begin
						selected_empty      = i_empty[2];
						selected_error      = i_error[2];
						selected_fcs_error  = i_fcs_error[2];
						selected_status     = i_status[2];
					end
					8'b1110???? : begin
						selected_empty      = i_empty[3];
						selected_error      = i_error[3];
						selected_fcs_error  = i_fcs_error[3];
						selected_status     = i_status[3];
					end
					8'b11110??? : begin
						selected_empty      = i_empty[4];
						selected_error      = i_error[4];
						selected_fcs_error  = i_fcs_error[4];
						selected_status     = i_status[4];
					end
					8'b111110?? : begin
						selected_empty      = i_empty[5];
						selected_error      = i_error[5];
						selected_fcs_error  = i_fcs_error[5];
						selected_status     = i_status[5];
					end
					8'b1111110? : begin
						selected_empty      = i_empty[6];
						selected_error      = i_error[6];
						selected_fcs_error  = i_fcs_error[6];
						selected_status     = i_status[6];
					end
					8'b11111110 : begin
						selected_empty      = i_empty[7];
						selected_error      = i_error[7];
						selected_fcs_error  = i_fcs_error[7];
						selected_status     = i_status[7];
					end
					default     : begin
						selected_empty      = 3'd0;
						selected_error      = 2'b00;
						selected_fcs_error  = 1'b0;
						selected_status     = 3'd0;
					end
				endcase
			end	
			else if (EHIP_RATE=="50G" || EHIP_RATE=="40G") begin
				case ({inframe_last, i_inframe}) inside
					3'b10? : begin
						selected_empty       = {1'b1, i_empty[0]};
						selected_error       = i_error[0];
						selected_fcs_error   = i_fcs_error[0];
						selected_status      = i_status[0]; 
					end
					3'b?10 : begin
						selected_empty       = {1'b0, i_empty[1]};
						selected_error       = i_error[1];
						selected_fcs_error   = i_fcs_error[1];
						selected_status      = i_status[1];
					end
					default : begin
						selected_empty       = 4'd0;
						selected_error       = 2'd0;
						selected_fcs_error   = 1'd0;
						selected_status      = 3'd0;
					end
				endcase
			end
		end
    endgenerate
	
	
	generate
		always_ff @(posedge i_clk) begin
			if (EHIP_RATE=="50G" || EHIP_RATE=="40G") begin
				o_empty <= selected_empty;
			end
			else if (EHIP_RATE=="100G") begin
				o_empty [2:0]   <= selected_empty;
				case (i_inframe) inside
					8'b0??????? : o_empty[5:3]    <= 3'd7;
					8'b10?????? : o_empty[5:3]    <= 3'd6;
					8'b110????? : o_empty[5:3]    <= 3'd5;
					8'b1110???? : o_empty[5:3]    <= 3'd4;
					8'b11110??? : o_empty[5:3]    <= 3'd3;
					8'b111110?? : o_empty[5:3]    <= 3'd2;
					8'b1111110? : o_empty[5:3]    <= 3'd1;
					8'b11111110 : o_empty[5:3]    <= 3'd0;
					default     : o_empty[5:3]    <= 3'd0;
				endcase
			end
		end
    endgenerate
    
	assign o_error[0]   = malformed_frame;
    assign o_error[1]   = crc_error;
    assign o_error[2]   = size_error;        
    assign o_error[3]   = 1'b0;         
    assign o_error[4]   = length_error;
    assign o_error[5]   = 1'b0;          

    assign o_status[31:0]   = 32'd0;       
    assign o_status[32]     = 1'b0; //stacked_vlan;
    assign o_status[33]     = vlan_svlan;
    assign o_status[34]     = control;
    assign o_status[35]     = pfc_sfc; //pause;
    assign o_status[36]     = 1'd0;         
    assign o_status[37]     = bcast_mcast; //1'd0;         
    assign o_status[39:38]  = 2'd0;         
endmodule

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q474kZUnVOjM0CmdIhzamZmZHjV8g+1fwi8OFaBvcf7/YybuA9/87i9LGKXM0hxrJq9fmp4zEr3IVl793x3UEf9lIZsQ5Z6ucqrcQumouODen3HDPConwNy/Agi0kPcxv0apDrJlQUwtRn7m8ZhMJYVouHnTnS8aN7dHTDKvvhhyVEFuN3VzAjgqXQVzDFcr1oOCTDGh+T8/PPkepTiG8zBR58VSirQw5IuoCs7T7S6kjVnk8ZfH8DCoZZmXiV0SThFF90A7QonQNt0SjKrriS2bk0Ayym8VNf3fQG3j5MflVoCP5bEpPcRNLplPCiA/jV+NFzPN4H3S7Pg4DTFxX6FC2sxGHGMxpLBaSmTpM5B1Ndzw0aUsOgnEsNWJVasTR+SopA6OHste5CN6xMPIp7lmNuguI+lAFtDqsrHWwA8uf/aA2XWNcCcTwYhYAO9LOZVdU0ps2g5E7/+ZQzhXaLvYKpUOd5v7KrepD+35amDCzACo9VjPLDVdFciawxb+9GqgbWFRlJ5Vr4uy9x4xE6qkDtBVPG2ZuseSRgZlhC8128D80Z9gdEQLKAnEZnwCZ6Gr1STeQ7x/3i1PUoSB8XlDy/P5n1zWzSquJBySPhL2k2PZb9sv9GPKzcwTGWfnjDTe6s2RQP9eHBET3QJv87BlrzWsC04LZMgyVVahU+vaMcJvj9+12xryQ52urDQ9KBN0TGT6E/xVCi67cfjHlOeUbFmgDqX8YRroh/TAaMuVb4ZAGxQgh6NXP/1aG1/wbq1ipIsPR58qVqG5CLXztJh0"
`endif