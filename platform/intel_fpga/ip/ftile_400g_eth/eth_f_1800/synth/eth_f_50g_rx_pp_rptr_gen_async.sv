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
module eth_f_50g_rx_pp_rptr_gen_async (              
    input   logic               i_clk,
    input   logic   [6:0]       i_ptr,
    output  logic   [0:3][4:0]  o_ptr
);

    always_ff @(posedge i_clk) begin
        case (i_ptr[1:0])
            2'd0 : o_ptr <= {i_ptr[6:2],        i_ptr[6:2], i_ptr[6:2], i_ptr[6:2] - 1'd1};
            2'd1 : o_ptr <= {i_ptr[6:2],        i_ptr[6:2], i_ptr[6:2], i_ptr[6:2]};
            2'd2 : o_ptr <= {i_ptr[6:2],        i_ptr[6:2], i_ptr[6:2], i_ptr[6:2]};
            2'd3 : o_ptr <= {i_ptr[6:2] + 1'd1, i_ptr[6:2], i_ptr[6:2], i_ptr[6:2]};
        endcase
    end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q46Xz7zuZi4+PcseuB5sIEP2zdo3gUQny9oPTDHcUlWamd4GoZe38vTRS9sXmRznG2RojdW8T+KGPzNI0xad/RIbh3Oclrj7A1i0ss0tG4ArP7/2sVE5HEXrQP4SHXJTZjSiDlCC/C5BvHVGIswmlwACgQNXkGrZAPVXxn/c070RVb4QGSz5xtGQ5LEB0tDEFqRA7mtCO5ySvSquZivypn9Qhg3rSozo6SF7+qISzcEHPJiuEr7xQ02HDO7nBxBtYs3X2gkA/8X0cBSc4BtnvEWJ1qCU6CR7gTHpMR7FPhfGG8PwwEAoTm/QgieCr67H6mrcboSodvinMBjTZEiuNtEFCW33X/HDHvfi0S4aLKdjW0CPoT8IQX6DXaygj7exp9cfUIQr6rIg+0Ka8gPupzjSr/4BRQ4XzULlT3CBKVEHasf44ZVJZGY6qF7J+rDxtXAIzTcKtuyqsn+ZeDvPoFP463g13tztX622IIea2akykD5SmJAhssPuOUsHkLmZQB0vvGCmsVR4p7CFxnV6LoclPtnD6FWD52Jb3Swf8p3Pm0NdSJsZsLSBT7lv7RV94c7gPlMiYekcjaLjx47RL6CLjZ2QDNZ5YSaNnsOJhRAIqwiYINF5QUC3LvBSH0JR0rBDqoqCYtdcifTVwXgtoaYN/SVlvQSqdoyJyUKLzz2vQnvzcgiRP3Y7b+u7nfxhOISFzNsQiV0eOuf0PiHXA3LT+Lawsj17UzCk4MiukkgIAcv2GCsmbvQzGI4BYmCNREOUQZMZtk52S9wOuweh/03n"
`endif