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


//=============================================================================
//Description
//Generates 80 bit parallel data for MAIB
//=============================================================================

//synthesis translate_off
`timescale 1ns / 1ps
//synthesis translate_on

module eth_f_dp_mapping_tx
import eth_f_package::*;
#(
    parameter   LANES                   =   4,
    parameter   CLIENT_INT              =   1,
    parameter   DATA_RATE               =   "100G"
)
(
    
    //Shared TX ports for the MAC, PCS, and PCS66 modes
    input   logic                          i_stats_snapshot,
    input   logic                          i_custom_cadence,
    input   logic   [LANES-1:0]            i_tx_aib_dsk,

    // MAC Interface
    input   logic   [LANES-1:0][63:0]      i_tx_data,
    input   logic   [LANES-1:0]            i_tx_error,
    input   logic   [LANES-1:0][2:0]       i_tx_empty,
    input   logic   [LANES-1:0]            i_tx_skip_crc,
    input   logic                          i_tx_valid,
    input   logic   [LANES-1:0]            i_tx_inframe,
    input   logic                          i_tx_pause,
    input   logic   [7:0]                  i_tx_pfc,

    //PCS inputs
    input   logic   [LANES-1:0][63:0]      i_tx_mii_d, 
    input   logic   [LANES-1:0][7:0]       i_tx_mii_c, 
    input   logic                          i_tx_mii_valid,
    input   logic                          i_tx_mii_am, 

    //PCS66 inputs
    input   logic   [LANES-1:0][65:0]      i_tx_pcs66_d, 
    input   logic                          i_tx_pcs66_valid,
    input   logic                          i_tx_pcs66_am, 

    //80bit data to aib
    output  logic   [LANES*80-1:0]         o_tx_parallel_data
);

logic   [LANES-1:0][77:0]              tx_mac_client;
logic   [LANES-1:0][77:0]              tx_mii;
logic   [LANES-1:0][77:0]              tx_pcs66;



//========================================================================
//Remap all the TX datapath interfaces
genvar i;

generate
for (i=0; i<LANES; i=i+1) begin:tx_mapping 
  always_comb begin:mac_client_interface
    
    tx_mac_client[i]                                   =   '0; //tie off unused

    tx_mac_client[i] [EPRT_TX_MAC_DATA_0+:32]          =   i_tx_data[i][31:0];
    tx_mac_client[i] [EPRT_TX_MAC_DATA_1+:32]          =   i_tx_data[i][63:32];
    tx_mac_client[i] [EPRT_TX_ERROR]                   =   i_tx_error[i];
    tx_mac_client[i] [EPRT_TX_EOP_EMPTY+:3]            =   i_tx_empty[i];
    tx_mac_client[i] [EPRT_TX_SKIP_CRC]                =   i_tx_skip_crc[i];
    tx_mac_client[i] [EPRT_TX_INFRAME]                 =   i_tx_inframe[i]; 
    if ( i == 0 ) 
    begin:i_zero 
      tx_mac_client[i] [EPRT_TX_VALID]                 =   i_tx_valid;
      if (LANES != 1) begin 
        tx_mac_client[i] [EPRT_TX_PFC0]                =   i_tx_pfc[0];
        tx_mac_client[i] [EPRT_TX_PFC1]                =   i_tx_pfc[1];
        tx_mac_client[i] [EPRT_TX_PFC2]                =   i_tx_pfc[2];
      end 
      tx_mac_client[i] [EPRT_STATS_SNAPSHOT]           =   i_stats_snapshot;
      tx_mac_client[i] [EPRT_CUSTOM_CADENCE]           =   i_custom_cadence;
    end //i_zero 
    if ( i == 1 ) 
    begin:i_one
      tx_mac_client[i] [EPRT_TX_PAUSE]                 =   i_tx_pause;
      tx_mac_client[i] [EPRT_TX_PFC3]                  =   i_tx_pfc[3];
      tx_mac_client[i] [EPRT_TX_PFC4]                  =   i_tx_pfc[4];
      tx_mac_client[i] [EPRT_TX_PFC5]                  =   i_tx_pfc[5];
      tx_mac_client[i] [EPRT_TX_PFC6]                  =   i_tx_pfc[6];
      tx_mac_client[i] [EPRT_TX_PFC7]                  =   i_tx_pfc[7];
    end //i_one
    tx_mac_client[i] [EPRT_DESKEW]                     =   i_tx_aib_dsk[i];
  end //mac_client_interface

  always_comb begin:mii_interface
    
    tx_mii[i]                                          =   '0; //tie off unused

    for(int mii_byte = 0; mii_byte < 8 ; mii_byte++) begin:mii_bytes
        if(mii_byte <4) begin:first4_bytes
            tx_mii[i][9*mii_byte+:8]                   =   i_tx_mii_d[i][8*mii_byte+:8];
            tx_mii[i][9*mii_byte+8]                    =   i_tx_mii_c[i][mii_byte];
        end //first4_bytes
        else begin:last4_bytes
            tx_mii[i][3+9*mii_byte+:8]                 =   i_tx_mii_d[i][8*mii_byte+:8];
            tx_mii[i][3+9*mii_byte+8]                  =   i_tx_mii_c[i][mii_byte];
        end //last4_bytes
    end //mii_bytes

    tx_mii[i][EPRT_DESKEW]                             =   i_tx_aib_dsk[i];
    if ( i == 0 ) begin
      tx_mii[0][EPRT_TX_VALID]                         =   i_tx_mii_valid;
      tx_mii[0][EPRT_TX_AM_VALID]                      =   i_tx_mii_am;
      tx_mii[0][EPRT_STATS_SNAPSHOT]                   =   i_stats_snapshot;
      tx_mii[0][EPRT_CUSTOM_CADENCE]                   =   i_custom_cadence;
    end
  end:mii_interface

  always_comb begin:pcs66_interface
    tx_pcs66[i]                                        =   '0; //tie off unused
    tx_pcs66[i][EPRT_TX_PCS66_DATA_0+:33]              =   i_tx_pcs66_d[i][32:0];
    tx_pcs66[i][EPRT_TX_PCS66_DATA_1+:33]              =   i_tx_pcs66_d[i][65:33];
    tx_pcs66[i][EPRT_DESKEW]                           =   i_tx_aib_dsk[i];
    if ( i == 0 ) begin
      tx_pcs66[0][EPRT_TX_VALID]                       =   i_tx_pcs66_valid;
      tx_pcs66[0][EPRT_TX_AM_VALID]                    =   i_tx_pcs66_am;
      tx_pcs66[0][EPRT_STATS_SNAPSHOT]                 =   i_stats_snapshot;
      tx_pcs66[0][EPRT_CUSTOM_CADENCE]                 =   i_custom_cadence;
    end
  end:pcs66_interface

end:tx_mapping
endgenerate 


// The AIB requires a specific encoding when using the double-wide
// parallel interface - we convert all the interfaces except the PMA
// direct interface to that format here. The PMA direct interface is
// not converted because it might not be using the double-wide
// interface
//
// Split the 78 bits of data for the AIB into 2 39b chunks
// Place the lower 39b into the lower 39b of the aib, then add a 1'b0
// as the 40th bit
// Place the upper 39b into the next set of bits, then add a 1'b1 as
// the top bit
generate
for (i=0; i<LANES; i=i+1) begin:aib_encoding 
  if (CLIENT_INT == 2)
    assign o_tx_parallel_data[i*80+:80] = {1'b1,tx_mii[i][39+:39],1'b0,tx_mii[i][0+:39]};
  else if (CLIENT_INT == 3 || CLIENT_INT == 4)
    assign o_tx_parallel_data[i*80+:80] = {1'b1,tx_pcs66[i][39+:39],1'b0,tx_pcs66[i][0+:39]};
  else
    assign o_tx_parallel_data[i*80+:80] = {1'b1,tx_mac_client[i][39+:39],1'b0,tx_mac_client[i][0+:39]};
end:aib_encoding
endgenerate

endmodule

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "IHWHrFSUaPtjZF1LBDe+5u/fCSc0//dMeoOgG/ez60Rt84WK1OI/WsMDAOmCm2IklwNYebRgS3zVDw7MPxWxM11LRVdkLZ+X/y8WtfqnS7Duroraj/37v+2WHhkPuM7Zr5jlblPypJOlE04iTTEfu+W3Q6H2vZl2TlAJ75jp9EioCxq3Erh26V4am36iNzJ8q9nPT5rffTeZv2243MrLgLaBmit/Byil0W+B47PrapVR0psMb/twwpygtzlFkOb0tiTzZbcPtDr717akxlqIvQsASKwi03ySfhmc640ajw7AgNL1S+3FzISo83JXtapS3pGJorshGrVQgn7ywOlTLUDhYqPy15ta9r7RLA8ZTdeCz5UHZiySYlyH8DKEp0B6aLQpuCXTNNJLQ57Z2C8KdWRU6tcLGZ7whXFHe27/2FUcyYVDPYpydyzcQwL9fnikl+c0iz3HqU8PUM4cSwcO7rnzPPicaW4DsjdtNijDSS3Jeb0WpHhpb924MIwY1eXXb1Y/l68TxusVQ/ddM3jEA22flxWaxO9seLjTNJrJTKJp5FYNhvnvphAqem55F6muyJUGEIjyxo7iD/iFZ+2UXaeo+4t06GweI1U0j7Rr4BW3Epgp1uDD0QzDIjmkJ7lCvqGod2Xq6D3m0O+kHq/tN9wLxRUAKAB7Wix6Czl/1i7G0edUYRxK3Dsw458mDeuLp/Wva8TdkzGou57BUAufAvklXJRhL8tFBUc+WcnwX2ILM41634l7gxX1PT4c8RlCFkCJY5a8lUSqS5Lp+OcHhkpoTAmK5VIp558LtO4uqm/1kXTSxpMGWCv0QtYby9hxamn/E5mW/23/Z9docbcdbJIrB3N+5/8jvf0Lih+6vNu5sHDg0mu/8eXZMgFD0AfZyevcjXSRs0yPhQ0aexYlLfk7muK0lj3dIfZpFC9NiIVORirNj1hcPwMc7OggDscu0DVJDxXpV2CL8PIbyn8vBtzWRn4N5W9zOYyfvpYEMNlltZ5DSMXfNWiDJLiPC6qz"
`endif