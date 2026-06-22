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


/*************************************************************************************************************
eth_f_reset_controller.sv
 
Function :  
combines hard resets and soft resets
 
// All resets in this module are active high
**************************************************************************************************************/
// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module eth_f_reset_logic
#(	
	parameter NUM_CHANNELS = 1,
	parameter SIM_EMULATE = 1
)
(
    // User hard Reset signals
    input wire 			   i_rst, // User reset (~i_rst_n) Resets Transcivers, EHIP
    input wire 			   i_tx_rst, // User reset (~i_tx_rst_n) Resets EHIP TX
    input wire 			   i_rx_rst, // User reset (~i_rx_rst_n) Resets EHIP RX
    
    // Soft CSR reset signals
    input wire 			   i_soft_tx_rst, 
    input wire 			   i_soft_rx_rst,
    input wire 			   i_soft_sys_rst, 

    // Output
    output wire        o_tx_dp_rst, // Reset TX datapath 
    output wire        o_rx_dp_rst // Reset RX datapath    
     
);
   
assign o_tx_dp_rst    = i_rst | i_tx_rst | i_soft_sys_rst | i_soft_tx_rst;
assign o_rx_dp_rst    = i_rst | i_rx_rst | i_soft_sys_rst | i_soft_rx_rst;

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "IHWHrFSUaPtjZF1LBDe+5u/fCSc0//dMeoOgG/ez60Rt84WK1OI/WsMDAOmCm2IklwNYebRgS3zVDw7MPxWxM11LRVdkLZ+X/y8WtfqnS7Duroraj/37v+2WHhkPuM7Zr5jlblPypJOlE04iTTEfu+W3Q6H2vZl2TlAJ75jp9EioCxq3Erh26V4am36iNzJ8q9nPT5rffTeZv2243MrLgLaBmit/Byil0W+B47PrapXL9wt16meDohZj5TXOhALiPP4i735U101NSCv1PpolWZsWqeasMwipwIco11FKWi7/PjhDbk9yls7iHcLGSW4ZlSVQit7nJPGqfEtyaEbAGHVuQatrBlBAryW75n0l3fX5wcRRzb8N3vAUuO0VegF5Vx/831BxtUnRpjgRVr7Tf2tiJ1ZRogwrRkgg0xmirsw5oBTx/ABHykBFzm9vqTcaqoqJAdPxMQuYib6wUxCBsj8cgb5Lokl97nwazeh8/SsReqxZGhxG2/AfPEpgL0+lPL/xKwItFXgNZEmf22IVgK1xpoR4ZJ232pohiOS4Aruc5mf1g/LHbuiShQTRZ9OdMTJuKmF1a1zN0/ofjXHiiLAFKtAQXcChapQJA2/AHA9SUSlMOniG9ST+R5eAosvuAzfDG7Tj9hKfSc8rsbUqZ5HvMhERcNyH8OnHS7Zr/CoJmQpNOH5Noh0jD4neYAnshbXoKnHkp85uS97Gbc0hMAOfV1I4kA0XlQkeAQOSuce4I6KYy/+zhbT5rVo6eykEjprri8/l+Ex0wR+vH4J93H+d2PxzfbWRHF3Xuiz92r+PAnCAuy7iaOzMHX69Ao+CS9gb9YcIaZN8oPnKvXa2etdlT7/GmTeNunv8Jc3zrvrojFwDvbfhHd55qlzORbCodc7nHd5Xsucs+MLSU2XpZd1D7hHZlHljXh6YRXZsoQj9myAciMFxUj3R/ptTz1b+ZAUmEMLmLuVOgeTcbwao+V38sKECqBU2BpVOos8nMmbza/CWMF/pzuNlO/Fxzp/b"
`endif