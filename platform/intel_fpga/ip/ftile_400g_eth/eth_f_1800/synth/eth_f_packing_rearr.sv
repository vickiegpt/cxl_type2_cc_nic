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


module eth_f_packing_rearr #(
    parameter DW=64, 
    parameter SEG_WIDTH = 2,
    parameter NUM_SEG=4
) (
    input i_rst,
    input i_clk,
    input i_valid,
    input [NUM_SEG-1:0] i_inframe,
    input [NUM_SEG-1:0][DW-1:0] i_data,
    input wr_packing_disable,
    output logic [NUM_SEG-1:0][DW-1:0] o_data,  //2 cycle delayed
    output logic [SEG_WIDTH:0] o_num_valid
);

//introduced for 50G only. To allow packing of immediate idle cycle after EOP cycle
//in higher rates, this is not required
localparam MAX_WAIT = 1;

logic [SEG_WIDTH:0] num_valid;
logic [NUM_SEG-1:0][SEG_WIDTH:0] out;
logic [NUM_SEG:0][DW-1:0] data_in_d1;
logic eop_cycle, inframe_d1;
logic [3:0] idle_cnt;
logic       idle_drop;

generate
begin
if(NUM_SEG != 16) begin:G40G_200G_ARR

always_ff @ (posedge i_clk)
begin
    if(i_rst)
    begin
        num_valid <= 0;
        //out <= {NUM_SEG{NUM_SEG}};
	if (NUM_SEG==2) begin
	out <= {2{2'd2}};
	end
	if (NUM_SEG==4) begin
	out <= {4{3'd4}};
	end
	if (NUM_SEG==16) begin
	out <= {16{5'd16}};
	end
        eop_cycle <= 0;
        inframe_d1 <= 0;
        idle_cnt   <= 0;
        idle_drop  <= 0;
    end
    else if(i_valid)
    begin
        inframe_d1 <= i_inframe[0];
        //Below case statements will count the number of valid segments in a cycle and record it in "num_valid"
        //Also it generates "out" signal which is used to rearrange all the valid segments to the MSB positions of the cycle
        //"eop_cycle" indicates the cycles where rearrangement is required
        if (NUM_SEG==2) begin
	   if(wr_packing_disable)
           begin
             num_valid <= 2; out <= {2'd2,2'd2}; eop_cycle <= 0;
           end
           else begin
           	casex({inframe_d1,i_inframe[1:0]})
           	    3'b1_00:   begin num_valid <= 1; out <= {2'd1,2'd2}; eop_cycle <= 1; end
           	    3'b0_01:   begin num_valid <= 1; out <= {2'd0,2'd2}; eop_cycle <= 1; end
           	    3'b0_00:   begin 
           	                  if (idle_drop) begin 
           	                     num_valid <= 0; out <= {2'd2,2'd2}; eop_cycle <= 0; 
           	                  end
           	                  else begin
           	                     num_valid <= 2; out <= {2'd2,2'd2}; eop_cycle <= 0; 
           	                  end
           	               end
           	    default:   begin num_valid <= 2; out <= {2'd2,2'd2}; eop_cycle <= 0; end
           	endcase
   	   end

           // counter to count number of IDLE CYCLES
           if ({inframe_d1,i_inframe[1:0]} == 3'd0) begin
              if (idle_cnt <= MAX_WAIT) begin
                 idle_cnt <= idle_cnt + 4'b1;
              end
              else begin
                 idle_cnt <= idle_cnt;
              end
           end
           else begin
              idle_cnt <= 0;
           end

           // flag to indicate idles can be dropped until MAX_WAIT number of IDLES are received
           if (idle_cnt <= MAX_WAIT) begin
              idle_drop <= 1'b0; //1'b1;
           end
           else begin
              idle_drop <= 1'b0;
           end
        end
        if (NUM_SEG==4) begin
	   if(wr_packing_disable)
            begin
               num_valid <= 4; out <= {3'd4,3'd4,3'd4,3'd4}; eop_cycle <= 0;
            end
           else begin
           casex({inframe_d1,i_inframe[3:0]})
               5'b1_0000: begin num_valid <= 1; out <= {3'd3,3'd4,3'd4,3'd4}; eop_cycle <= 1; end
               5'b1_0001: begin num_valid <= 2; out <= {3'd3,3'd0,3'd4,3'd4}; eop_cycle <= 1; end
               5'b1_0011: begin num_valid <= 3; out <= {3'd3,3'd1,3'd0,3'd4}; eop_cycle <= 1; end
               5'b0_0001: begin num_valid <= 1; out <= {3'd0,3'd4,3'd4,3'd4}; eop_cycle <= 1; end
               5'b0_0011: begin num_valid <= 2; out <= {3'd1,3'd0,3'd4,3'd4}; eop_cycle <= 1; end
               5'b0_0111: begin num_valid <= 3; out <= {3'd2,3'd1,3'd0,3'd4}; eop_cycle <= 1; end
               5'bX_1000: begin num_valid <= 2; out <= {3'd3,3'd2,3'd4,3'd4}; eop_cycle <= 1; end
               5'bX_1001: begin num_valid <= 3; out <= {3'd3,3'd2,3'd0,3'd4}; eop_cycle <= 1; end
               5'bX_1100: begin num_valid <= 3; out <= {3'd3,3'd2,3'd1,3'd4}; eop_cycle <= 1; end
               default:   begin num_valid <= 4; out <= {3'd4,3'd4,3'd4,3'd4}; eop_cycle <= 0; end
           endcase
   	  end // end of wr_packing_disable
        end
        if (NUM_SEG==8) begin
        //The smallest legal Ethernet packet is 64B and it will occupy 8 segments. And hence packing needs to be done at the 8 segment level.
        //Note that packet size less than 64B will be passed on without any packing
	  if(wr_packing_disable)
            begin
                num_valid <= 8; out <= {4'd8,4'd8,4'd8,4'd8,4'd8,4'd8,4'd8,4'd8}; eop_cycle <= 0;
            end
	  else
           begin
           casex({inframe_d1,i_inframe[7:0]})
               9'b1_0000_0000: begin num_valid <= 1; out <= {4'd7,4'd8,4'd8,4'd8,4'd8,4'd8,4'd8,4'd8}; eop_cycle <= 1; end
               9'b1_0000_0001: begin num_valid <= 2; out <= {4'd7,4'd0,4'd8,4'd8,4'd8,4'd8,4'd8,4'd8}; eop_cycle <= 1; end
               9'b1_0000_0011: begin num_valid <= 3; out <= {4'd7,4'd1,4'd0,4'd8,4'd8,4'd8,4'd8,4'd8}; eop_cycle <= 1; end
               9'b1_0000_0111: begin num_valid <= 4; out <= {4'd7,4'd2,4'd1,4'd0,4'd8,4'd8,4'd8,4'd8}; eop_cycle <= 1; end
               9'b1_0000_1111: begin num_valid <= 5; out <= {4'd7,4'd3,4'd2,4'd1,4'd0,4'd8,4'd8,4'd8}; eop_cycle <= 1; end
               9'b1_0001_1111: begin num_valid <= 6; out <= {4'd7,4'd4,4'd3,4'd2,4'd1,4'd0,4'd8,4'd8}; eop_cycle <= 1; end
               9'b1_0011_1111: begin num_valid <= 7; out <= {4'd7,4'd5,4'd4,4'd3,4'd2,4'd1,4'd0,4'd8}; eop_cycle <= 1; end

               9'b0_0000_0001: begin num_valid <= 1; out <= {4'd0,4'd8,4'd8,4'd8,4'd8,4'd8,4'd8,4'd8}; eop_cycle <= 1; end
               9'b0_0000_0011: begin num_valid <= 2; out <= {4'd1,4'd0,4'd8,4'd8,4'd8,4'd8,4'd8,4'd8}; eop_cycle <= 1; end
               9'b0_0000_0111: begin num_valid <= 3; out <= {4'd2,4'd1,4'd0,4'd8,4'd8,4'd8,4'd8,4'd8}; eop_cycle <= 1; end
               9'b0_0000_1111: begin num_valid <= 4; out <= {4'd3,4'd2,4'd1,4'd0,4'd8,4'd8,4'd8,4'd8}; eop_cycle <= 1; end
               9'b0_0001_1111: begin num_valid <= 5; out <= {4'd4,4'd3,4'd2,4'd1,4'd0,4'd8,4'd8,4'd8}; eop_cycle <= 1; end
               9'b0_0011_1111: begin num_valid <= 6; out <= {4'd5,4'd4,4'd3,4'd2,4'd1,4'd0,4'd8,4'd8}; eop_cycle <= 1; end
               9'b0_0111_1111: begin num_valid <= 7; out <= {4'd6,4'd5,4'd4,4'd3,4'd2,4'd1,4'd0,4'd8}; eop_cycle <= 1; end

               9'bX_1000_0000: begin num_valid <= 2; out <= {4'd7,4'd6,4'd8,4'd8,4'd8,4'd8,4'd8,4'd8}; eop_cycle <= 1; end
               9'bX_1000_0001: begin num_valid <= 3; out <= {4'd7,4'd6,4'd0,4'd8,4'd8,4'd8,4'd8,4'd8}; eop_cycle <= 1; end
               9'bX_1000_0011: begin num_valid <= 4; out <= {4'd7,4'd6,4'd1,4'd0,4'd8,4'd8,4'd8,4'd8}; eop_cycle <= 1; end
               9'bX_1000_0111: begin num_valid <= 5; out <= {4'd7,4'd6,4'd2,4'd1,4'd0,4'd8,4'd8,4'd8}; eop_cycle <= 1; end
               9'bX_1000_1111: begin num_valid <= 6; out <= {4'd7,4'd6,4'd3,4'd2,4'd1,4'd0,4'd8,4'd8}; eop_cycle <= 1; end
               9'bX_1001_1111: begin num_valid <= 7; out <= {4'd7,4'd6,4'd4,4'd3,4'd2,4'd1,4'd0,4'd8}; eop_cycle <= 1; end

               9'bX_1100_0000: begin num_valid <= 3; out <= {4'd7,4'd6,4'd5,4'd8,4'd8,4'd8,4'd8,4'd8}; eop_cycle <= 1; end
               9'bX_1100_0001: begin num_valid <= 4; out <= {4'd7,4'd6,4'd5,4'd0,4'd8,4'd8,4'd8,4'd8}; eop_cycle <= 1; end
               9'bX_1100_0011: begin num_valid <= 5; out <= {4'd7,4'd6,4'd5,4'd1,4'd0,4'd8,4'd8,4'd8}; eop_cycle <= 1; end
               9'bX_1100_0111: begin num_valid <= 6; out <= {4'd7,4'd6,4'd5,4'd2,4'd1,4'd0,4'd8,4'd8}; eop_cycle <= 1; end
               9'bX_1100_1111: begin num_valid <= 7; out <= {4'd7,4'd6,4'd5,4'd3,4'd2,4'd1,4'd0,4'd8}; eop_cycle <= 1; end

               9'bx_1110_0000: begin num_valid <= 4; out <= {4'd7,4'd6,4'd5,4'd4,4'd8,4'd8,4'd8,4'd8}; eop_cycle <= 1; end
               9'bx_1110_0001: begin num_valid <= 5; out <= {4'd7,4'd6,4'd5,4'd4,4'd0,4'd8,4'd8,4'd8}; eop_cycle <= 1; end
               9'bx_1110_0011: begin num_valid <= 6; out <= {4'd7,4'd6,4'd5,4'd4,4'd1,4'd0,4'd8,4'd8}; eop_cycle <= 1; end
               9'bx_1110_0111: begin num_valid <= 7; out <= {4'd7,4'd6,4'd5,4'd4,4'd2,4'd1,4'd0,4'd8}; eop_cycle <= 1; end

               9'bx_1111_0000: begin num_valid <= 5; out <= {4'd7,4'd6,4'd5,4'd4,4'd3,4'd8,4'd8,4'd8}; eop_cycle <= 1; end
               9'bx_1111_0001: begin num_valid <= 6; out <= {4'd7,4'd6,4'd5,4'd4,4'd3,4'd0,4'd8,4'd8}; eop_cycle <= 1; end
               9'bx_1111_0011: begin num_valid <= 7; out <= {4'd7,4'd6,4'd5,4'd4,4'd3,4'd1,4'd0,4'd8}; eop_cycle <= 1; end

               9'bx_1111_1000: begin num_valid <= 6; out <= {4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd8,4'd8}; eop_cycle <= 1; end
               9'bx_1111_1001: begin num_valid <= 7; out <= {4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd0,4'd8}; eop_cycle <= 1; end

               9'bx_1111_1100: begin num_valid <= 7; out <= {4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1,4'd8}; eop_cycle <= 1; end
               default: 	    begin num_valid <= 8; out <= {4'd8,4'd8,4'd8,4'd8,4'd8,4'd8,4'd8,4'd8}; eop_cycle <= 0; end
           endcase
	 end // end of wr_packing_disable
        end
    end
    else
    begin
        num_valid <= 0;
        //out <= {NUM_SEG{NUM_SEG}};
	if (NUM_SEG==2) begin
	out <= {2{2'd2}};
	end
	if (NUM_SEG==4) begin
	out <= {4{3'd4}};
	end
	if (NUM_SEG==16) begin
	out <= {16{5'd16}};
	end
        eop_cycle <= 0;
    end
end //end always_ff
end //40G_200G_ARR
else begin:G400G_ARR
    logic [(NUM_SEG/2)-1:0][SEG_WIDTH:0] out1, out2;
    logic [NUM_SEG-1:0][SEG_WIDTH:0] out_t1, out_t2, out_t3;
    logic eop_cycle1, eop_cycle2;
    logic [SEG_WIDTH:0] num_valid1, num_valid2;
    logic valid_d1;

    always_ff @ (posedge i_clk)
    begin
    if(i_rst)
    begin
        num_valid1 <= 0;
	num_valid2 <= 0;
        out1 <= {8{5'd16}};
        out2 <= {8{5'd16}};
        eop_cycle1 <= 0;
	eop_cycle2 <= 0;
        inframe_d1 <= 0;
    end
    else if(i_valid)
    begin
        inframe_d1 <= i_inframe[0];
        //in 400G, the case statements are split into two 8-segment cases. The splitting is required because the smallest legal Ethernet 
        //packet is 64B and it will occupy 8 segments. And hence packing needs to be done at the 8 segment level.
        if (NUM_SEG==16) begin
	  if(wr_packing_disable)
             begin
                 num_valid1 <= 8; out1 <= {5'd15,5'd14,5'd13,5'd12,5'd11,5'd10,5'd09,5'd08}; eop_cycle1 <= 1;
                 num_valid2 <= 8; out2 <= {5'd7,5'd6,5'd5,5'd4,5'd3,5'd2,5'd1,5'd0}; eop_cycle2 <= 1;
       	     end
          else
           begin
           casex({inframe_d1,i_inframe[15:8]})
               //below condition is covered in the default statement
               //9'b0_0000_0000: begin num_valid1 <= 8; out1 <= {5'd15,5'd14,5'd13,5'd12,5'd11,5'd10,5'd09,5'd08}; eop_cycle1 <= 0; end
		  
               9'b1_0000_0000: begin num_valid1 <= 1; out1 <= {5'd15,5'd00,5'd00,5'd00,5'd00,5'd00,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'b1_0000_0001: begin num_valid1 <= 2; out1 <= {5'd15,5'd08,5'd00,5'd00,5'd00,5'd00,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'b1_0000_0011: begin num_valid1 <= 3; out1 <= {5'd15,5'd09,5'd08,5'd00,5'd00,5'd00,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'b1_0000_0111: begin num_valid1 <= 4; out1 <= {5'd15,5'd10,5'd09,5'd08,5'd00,5'd00,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'b1_0000_1111: begin num_valid1 <= 5; out1 <= {5'd15,5'd11,5'd10,5'd09,5'd08,5'd00,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'b1_0001_1111: begin num_valid1 <= 6; out1 <= {5'd15,5'd12,5'd11,5'd10,5'd09,5'd08,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'b1_0011_1111: begin num_valid1 <= 7; out1 <= {5'd15,5'd13,5'd12,5'd11,5'd10,5'd09,5'd08,5'd00}; eop_cycle1 <= 1; end

               9'b0_0000_0001: begin num_valid1 <= 1; out1 <= {5'd08,5'd00,5'd00,5'd00,5'd00,5'd00,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'b0_0000_0011: begin num_valid1 <= 2; out1 <= {5'd09,5'd08,5'd00,5'd00,5'd00,5'd00,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'b0_0000_0111: begin num_valid1 <= 3; out1 <= {5'd10,5'd09,5'd08,5'd00,5'd00,5'd00,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'b0_0000_1111: begin num_valid1 <= 4; out1 <= {5'd11,5'd10,5'd09,5'd08,5'd00,5'd00,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'b0_0001_1111: begin num_valid1 <= 5; out1 <= {5'd12,5'd11,5'd10,5'd09,5'd08,5'd00,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'b0_0011_1111: begin num_valid1 <= 6; out1 <= {5'd13,5'd12,5'd11,5'd10,5'd09,5'd08,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'b0_0111_1111: begin num_valid1 <= 7; out1 <= {5'd14,5'd13,5'd12,5'd11,5'd10,5'd09,5'd08,5'd00}; eop_cycle1 <= 1; end

               9'bX_1000_0000: begin num_valid1 <= 2; out1 <= {5'd15,5'd14,5'd00,5'd00,5'd00,5'd00,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'bX_1000_0001: begin num_valid1 <= 3; out1 <= {5'd15,5'd14,5'd08,5'd00,5'd00,5'd00,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'bX_1000_0011: begin num_valid1 <= 4; out1 <= {5'd15,5'd14,5'd09,5'd08,5'd00,5'd00,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'bX_1000_0111: begin num_valid1 <= 5; out1 <= {5'd15,5'd14,5'd10,5'd09,5'd08,5'd00,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'bX_1000_1111: begin num_valid1 <= 6; out1 <= {5'd15,5'd14,5'd11,5'd10,5'd09,5'd08,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'bX_1001_1111: begin num_valid1 <= 7; out1 <= {5'd15,5'd14,5'd12,5'd11,5'd10,5'd09,5'd08,5'd00}; eop_cycle1 <= 1; end

               9'bX_1100_0000: begin num_valid1 <= 3; out1 <= {5'd15,5'd14,5'd13,5'd00,5'd00,5'd00,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'bX_1100_0001: begin num_valid1 <= 4; out1 <= {5'd15,5'd14,5'd13,5'd08,5'd00,5'd00,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'bX_1100_0011: begin num_valid1 <= 5; out1 <= {5'd15,5'd14,5'd13,5'd09,5'd08,5'd00,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'bX_1100_0111: begin num_valid1 <= 6; out1 <= {5'd15,5'd14,5'd13,5'd10,5'd09,5'd08,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'bX_1100_1111: begin num_valid1 <= 7; out1 <= {5'd15,5'd14,5'd13,5'd11,5'd10,5'd09,5'd08,5'd00}; eop_cycle1 <= 1; end

               9'bx_1110_0000: begin num_valid1 <= 4; out1 <= {5'd15,5'd14,5'd13,5'd12,5'd00,5'd00,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'bx_1110_0001: begin num_valid1 <= 5; out1 <= {5'd15,5'd14,5'd13,5'd12,5'd08,5'd00,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'bx_1110_0011: begin num_valid1 <= 6; out1 <= {5'd15,5'd14,5'd13,5'd12,5'd09,5'd08,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'bx_1110_0111: begin num_valid1 <= 7; out1 <= {5'd15,5'd14,5'd13,5'd12,5'd10,5'd09,5'd08,5'd00}; eop_cycle1 <= 1; end

               9'bx_1111_0000: begin num_valid1 <= 5; out1 <= {5'd15,5'd14,5'd13,5'd12,5'd11,5'd00,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'bx_1111_0001: begin num_valid1 <= 6; out1 <= {5'd15,5'd14,5'd13,5'd12,5'd11,5'd08,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'bx_1111_0011: begin num_valid1 <= 7; out1 <= {5'd15,5'd14,5'd13,5'd12,5'd11,5'd09,5'd08,5'd00}; eop_cycle1 <= 1; end

               9'bx_1111_1000: begin num_valid1 <= 6; out1 <= {5'd15,5'd14,5'd13,5'd12,5'd11,5'd10,5'd00,5'd00}; eop_cycle1 <= 1; end
               9'bx_1111_1001: begin num_valid1 <= 7; out1 <= {5'd15,5'd14,5'd13,5'd12,5'd11,5'd10,5'd08,5'd00}; eop_cycle1 <= 1; end

               9'bx_1111_1100: begin num_valid1 <= 7; out1 <= {5'd15,5'd14,5'd13,5'd12,5'd11,5'd10,5'd09,5'd00}; eop_cycle1 <= 1; end
               default:        begin num_valid1 <= 8; out1 <= {5'd15,5'd14,5'd13,5'd12,5'd11,5'd10,5'd09,5'd08}; eop_cycle1 <= 1; end
           endcase

           casex({i_inframe[8],i_inframe[7:0]})
               //below condition is covered in the default statement
               //9'b0_0000_0000: begin num_valid2 <= 8; out2 <= {5'd7,5'd6,5'd5,5'd4,5'd3,5'd2,5'd1,5'd0}; eop_cycle2 <= 0; end
					
			   9'b1_0000_0000: begin num_valid2 <= 1; out2 <= {5'd7,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'b1_0000_0001: begin num_valid2 <= 2; out2 <= {5'd7,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'b1_0000_0011: begin num_valid2 <= 3; out2 <= {5'd7,5'd1,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'b1_0000_0111: begin num_valid2 <= 4; out2 <= {5'd7,5'd2,5'd1,5'd0,5'd0,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'b1_0000_1111: begin num_valid2 <= 5; out2 <= {5'd7,5'd3,5'd2,5'd1,5'd0,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'b1_0001_1111: begin num_valid2 <= 6; out2 <= {5'd7,5'd4,5'd3,5'd2,5'd1,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'b1_0011_1111: begin num_valid2 <= 7; out2 <= {5'd7,5'd5,5'd4,5'd3,5'd2,5'd1,5'd0,5'd0}; eop_cycle2 <= 1; end

               9'b0_0000_0001: begin num_valid2 <= 1; out2 <= {5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'b0_0000_0011: begin num_valid2 <= 2; out2 <= {5'd1,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'b0_0000_0111: begin num_valid2 <= 3; out2 <= {5'd2,5'd1,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'b0_0000_1111: begin num_valid2 <= 4; out2 <= {5'd3,5'd2,5'd1,5'd0,5'd0,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'b0_0001_1111: begin num_valid2 <= 5; out2 <= {5'd4,5'd3,5'd2,5'd1,5'd0,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'b0_0011_1111: begin num_valid2 <= 6; out2 <= {5'd5,5'd4,5'd3,5'd2,5'd1,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'b0_0111_1111: begin num_valid2 <= 7; out2 <= {5'd6,5'd5,5'd4,5'd3,5'd2,5'd1,5'd0,5'd0}; eop_cycle2 <= 1; end

               9'bX_1000_0000: begin num_valid2 <= 2; out2 <= {5'd7,5'd6,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'bX_1000_0001: begin num_valid2 <= 3; out2 <= {5'd7,5'd6,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'bX_1000_0011: begin num_valid2 <= 4; out2 <= {5'd7,5'd6,5'd1,5'd0,5'd0,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'bX_1000_0111: begin num_valid2 <= 5; out2 <= {5'd7,5'd6,5'd2,5'd1,5'd0,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'bX_1000_1111: begin num_valid2 <= 6; out2 <= {5'd7,5'd6,5'd3,5'd2,5'd1,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'bX_1001_1111: begin num_valid2 <= 7; out2 <= {5'd7,5'd6,5'd4,5'd3,5'd2,5'd1,5'd0,5'd0}; eop_cycle2 <= 1; end

               9'bX_1100_0000: begin num_valid2 <= 3; out2 <= {5'd7,5'd6,5'd5,5'd0,5'd0,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'bX_1100_0001: begin num_valid2 <= 4; out2 <= {5'd7,5'd6,5'd5,5'd0,5'd0,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'bX_1100_0011: begin num_valid2 <= 5; out2 <= {5'd7,5'd6,5'd5,5'd1,5'd0,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'bX_1100_0111: begin num_valid2 <= 6; out2 <= {5'd7,5'd6,5'd5,5'd2,5'd1,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'bX_1100_1111: begin num_valid2 <= 7; out2 <= {5'd7,5'd6,5'd5,5'd3,5'd2,5'd1,5'd0,5'd0}; eop_cycle2 <= 1; end

               9'bx_1110_0000: begin num_valid2 <= 4; out2 <= {5'd7,5'd6,5'd5,5'd4,5'd0,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'bx_1110_0001: begin num_valid2 <= 5; out2 <= {5'd7,5'd6,5'd5,5'd4,5'd0,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'bx_1110_0011: begin num_valid2 <= 6; out2 <= {5'd7,5'd6,5'd5,5'd4,5'd1,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'bx_1110_0111: begin num_valid2 <= 7; out2 <= {5'd7,5'd6,5'd5,5'd4,5'd2,5'd1,5'd0,5'd0}; eop_cycle2 <= 1; end

               9'bx_1111_0000: begin num_valid2 <= 5; out2 <= {5'd7,5'd6,5'd5,5'd4,5'd3,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'bx_1111_0001: begin num_valid2 <= 6; out2 <= {5'd7,5'd6,5'd5,5'd4,5'd3,5'd0,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'bx_1111_0011: begin num_valid2 <= 7; out2 <= {5'd7,5'd6,5'd5,5'd4,5'd3,5'd1,5'd0,5'd0}; eop_cycle2 <= 1; end

               9'bx_1111_1000: begin num_valid2 <= 6; out2 <= {5'd7,5'd6,5'd5,5'd4,5'd3,5'd2,5'd0,5'd0}; eop_cycle2 <= 1; end
               9'bx_1111_1001: begin num_valid2 <= 7; out2 <= {5'd7,5'd6,5'd5,5'd4,5'd3,5'd2,5'd0,5'd0}; eop_cycle2 <= 1; end

               9'bx_1111_1100: begin num_valid2 <= 7; out2 <= {5'd7,5'd6,5'd5,5'd4,5'd3,5'd2,5'd1,5'd0}; eop_cycle2 <= 1; end
               default:        begin num_valid2 <= 8; out2 <= {5'd7,5'd6,5'd5,5'd4,5'd3,5'd2,5'd1,5'd0}; eop_cycle2 <= 1; end
           endcase
        end //end of wr_packing_disable
      end //end of NUM_SEG=16
    end // else if(i_valid)
    else
    begin
        num_valid1 <= 0;
	num_valid2 <= 0;
        out1 <= {8{5'd16}};
        out2 <= {8{5'd16}};
        eop_cycle1 <= 0;
	eop_cycle2 <= 0;
    end
	 end //always_ff

    always_ff @ (posedge i_clk)
    begin
        valid_d1 <= i_valid;
        if(valid_d1) begin
           //Add up num_valid from two 8-segments for 400G
           //out needs to undergo shift and OR operation to make sure that out data from lower 8-segment is shifted to 
           //higher seg.
           num_valid <= 5'(num_valid1+num_valid2);
           out <= out_t1 | out_t3;
           eop_cycle <= eop_cycle1 | eop_cycle2;
        end
        else begin
        	num_valid <= 0;
        	//out <= {NUM_SEG{NUM_SEG}};
	if (NUM_SEG==2) begin
	out <= {2{2'd2}};
	end
	if (NUM_SEG==4) begin
	out <= {4{3'd4}};
	end
	if (NUM_SEG==16) begin
	out <= {16{5'd16}};
	end
        	eop_cycle <= 0;
        end
    end
    	 
    assign out_t1 = {out1, {8{5'd0}}};
    assign out_t2 = {{8{5'd0}}, out2};
    assign out_t3 = (out_t2 << ((8-num_valid1)*5));
end //400G_ARR
end
endgenerate

integer i;
generate
if(NUM_SEG != 16) begin: G40G_200G_OUT
    assign data_in_d1[NUM_SEG] = {DW{1'b0}};
    always_ff @ (posedge i_clk)
    begin
        data_in_d1[NUM_SEG-1:0] <= i_data[NUM_SEG-1:0];
        o_num_valid <= num_valid;
        if(eop_cycle)
    		for(i=0;i<NUM_SEG;i=i+1)
            o_data[i] <= data_in_d1[out[i]];
        else
            o_data <= data_in_d1[NUM_SEG-1:0];
    end
end //end of 40G_200G_OUT
else begin: G400G_OUT
    logic [NUM_SEG:0][DW-1:0] data_in_d2;

    assign data_in_d1[NUM_SEG] = {DW{1'b0}};
    assign data_in_d2[NUM_SEG] = {DW{1'b0}};
    
    always_ff @ (posedge i_clk)
    begin
        data_in_d1[NUM_SEG-1:0] <= i_data[NUM_SEG-1:0];
        data_in_d2[NUM_SEG-1:0] <= data_in_d1[NUM_SEG-1:0];
        o_num_valid <= num_valid;
        if(eop_cycle)
    		for(i=0;i<NUM_SEG;i=i+1)
            o_data[i] <= data_in_d2[out[i]];
        else
            o_data <= data_in_d2[NUM_SEG-1:0] ;
    end
end
endgenerate

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q44fwkrmf9dD6fWLcXQDLicxTnPCdwHVGLHtdddAkf/A+g2Tewau2sFz6tJi1bM7O/pojVIJEt0TbxNFzSIXy8vEkGYAN4XKdPw++8BWuaDcbds/fZmdlHlJz42UyvqMfudjWUKhJXO6MeH+a3AGsgCe1r9RFHPMQawursLQFQMNKi1RqlG9wKL8JmtqTaXSyAuLSbLdCRPAObD8RFTZXCtneaYG0liiH/RfQ/+2LVJK4epfkaVM15TVdm2BVuQZtxrI8NYOs2FtQ1nlAAn6ekW0z3OxiuXyX9AylDjlTAEtn8BEcX2WKnKVezk/6Ttv1c5y2saa6OsgPdRf4yerwbTk3C7qM5wYjEcsAfsWujkivwJAKUacryuhOAs4T3OmpQJ0BODiJ4XwMqFnh7Yw3ydtu6pGFgxf+VULwJiUPzm0JKZLNXDuajquiQP8PSm1ghl+7+f3eFCfKE8fQskcujsZuIsdhLvCVfNFJFRH3ptB63s1FukvrUzW9XF3Rjad1+7FRO7opXDHUIlbzZodt6GHs82YErnvm9Kuuf/zolxVCN5q4rghwZy+ZmjUYsFd+K7dxKF/T8cnvH49ZkdNyakLppqRFziiqhInoAAyXvoIGLavAnsPXUyMtmtqckIc7vjvaKWbpKQJvEeqodENIiB2JELHRZpOEfTsZ2gi/DA0hdeEzIaj+iwiMJb3XtpclCXPjz6Y0nSHDP5fR5ePG002D9aVlMSH9VnJGIRLGVAApbHE6dcg3LDkuKcZDwhSNSwFRXjooyi7FKnsuBqNSA+u"
`endif