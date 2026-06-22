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
module eth_f_data_mux_2to1_tx100a  #(
    parameter WIDTH                 = 8,
	parameter EHIP_RATE             = "100G",
	parameter I_DATA_SIZE 			= (EHIP_RATE == "100G") ? 2 : 4,
	parameter O_DATA_SIZE 			= (EHIP_RATE == "100G") ? 1 : 2
) (
    input   logic                       i_clk,
    input   logic                       i_sel,
    input   wire    [0:I_DATA_SIZE-1][WIDTH-1:0]    i_data,
    output  logic   [0:O_DATA_SIZE-1][WIDTH-1:0]    o_data
);
	
    always_ff @(posedge i_clk) begin
        case (i_sel)
            1'd0 : o_data  <= i_data[0: (I_DATA_SIZE/2)-1];
            1'd1 : o_data  <= i_data[(I_DATA_SIZE/2):(I_DATA_SIZE-1)];
        endcase
    end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q47a/xLJWScNIRa3xX3dcQVGwAzATVlQngtnthpxbGnCV6bNZvxtj7DxUMXCSiKq2IJ41Yu8QZApaQdOWzjKBEA/+PIr15z/oR1x7JNWeSGnwyeO2umTM/8kFFdSMilu13QsNKKByy7ksYuKwN7zCqSxKjGWBrhi0loP2QqIkDypopr4iNVhsKGak3NO6ep3ghrUqL11jm0UPWYBHXEBFRZ7Wn81+mH3NiLfpTv3yKWKgAc1lQsWEiXw8DB61KMfTfNOOpwYAUSCYBN4Yytou9pcGjKhSvZ8mL0YJmAQSrjGk8wuk951oSmwTkqyFRN/Qstf0A6kHoJC0EQBbLDRcI2aYYFGcvKzncDiyPd5v7yyb9CLlxghlzxYI7e80W7rBKjq+V2lRmd76emjhoVF4SLbfTAx8FyYkyEqtxzjVumybLWtA/4bLVOJvvvK/sxA9bYPju8sZD0wWlg9TzfpTaEh7tDzYA4gktyHwRvr6zEjJBGKvTjra0bdPGzURIrGwd2rEHpUCymJ2pFnNpKuv+OA2gUSo9zt+UcXW9X7bR09icuBs8xabPiBFarCkJEEcOjiIr+EsCQ6aZQtIhaVM5C8udpFn1HbTASDwEodfrF6EifHQyme/P9FtTQQZ2i3x+tIkudtGPvMsOhWNd7d+p5oDLht4ZlSukD9cGlq9h+drLyLQYmokZLpdsljYnGdL77PIUxQESX61+AGWqm3cqQG4BS+aIFRt9Btw3BqrN7eh3G2wBfHh33MwWBYI9zhB7/05zM9rV6iZbqYZU2oJpCK"
`endif