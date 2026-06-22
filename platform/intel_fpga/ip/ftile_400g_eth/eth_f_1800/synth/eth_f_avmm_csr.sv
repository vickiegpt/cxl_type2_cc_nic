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


`timescale 1 ps/1 ps

module eth_f_avmm_csr 
// Import package with parameters for the soft addresses and offsets
//import      eth_f_avmm_h::*;
import      eth_f_package::*;
#(
  parameter                               dbg_capability_reg_enable        = 0,
  parameter                               dbg_user_identifier              = 0,
  parameter                               dbg_stat_soft_logic_enable       = 0,
  parameter                               dbg_ctrl_soft_logic_enable       = 0,
  parameter                               channels                         = 1,
  parameter                               channel_num                      = 1,
  parameter                               l_num_aib                        = 1,
  parameter                               addr_width                       = 10,
  parameter                               duplex_mode                      = "duplex",
  parameter                               num_aib_per_xcvr                 = 0

) (
  // avmm signals
  input                                   avmm_clk,
  input                                   avmm_reset,
  input  [addr_width-1:0]                 avmm_address,
  input  [7:0]                            avmm_writedata,
  input                                   avmm_write,
  input                                   avmm_read,
  output reg [7:0]                        avmm_readdata,
  output                                  avmm_waitrequest,

  // input status signals from the channel
  input                                   rx_is_lockedtodata,
  // <TODO: case:335703>
  input                                   tx_transfer_ready,
  input                                   rx_transfer_ready,
  
  // input control signals
  input                                   rx_analogreset,
  input                                   rx_digitalreset,
  input                                   tx_analogreset,
  input                                   tx_digitalreset,  

  // inputs from the reset controller
  input                                   tx_ready,
  input                                   rx_ready,


  // output control signals to the channel
  output                                  csr_rx_analogreset,
  output                                  csr_rx_digitalreset,  
  output                                  csr_tx_analogreset,
  output                                  csr_tx_digitalreset


);



// Reg for generating waitrequest and data valid
reg         avmm_valid;

/**********************************************************************/
// wires and bus declaration
/**********************************************************************/
wire [7:0]  rd_channel;
wire [7:0]  rd_channel_num;
wire [7:0]  rd_duplex;
wire [7:0]  rd_system_id;
wire [7:0]  rd_status_en;
wire [7:0]  rd_control_en;
wire [7:0]  rd_ltr_status;
wire [7:0]  rd_chnl_reset;
wire [7:0]  rd_chnl_ready;
wire [7:0]  rd_aib_ready;
wire [7:0]  rd_chnl_aib;

/**********************************************************************/
//generate waitrequest
/**********************************************************************/
assign avmm_waitrequest = (~avmm_valid & avmm_read);


/**********************************************************************/
// soft CSRs for embedded debug
/**********************************************************************/
always@(posedge avmm_clk) begin
  if(~avmm_read) begin
    avmm_valid    <= 1'b0;
    avmm_readdata <= RD_UNUSED;
  end else begin
    avmm_valid    <= avmm_waitrequest;
    case(avmm_address)

      // Address for Capabilities
      AGX_F_ADDR_ID_0:                   avmm_readdata <= rd_system_id;
      AGX_F_ADDR_STATUS_EN:              avmm_readdata <= rd_status_en;
      AGX_F_ADDR_CONTROL_EN:             avmm_readdata <= rd_control_en;
      AGX_F_ADDR_NAT_CHNLS:              avmm_readdata <= rd_channel;
      AGX_F_ADDR_NAT_CHNL_NUM:           avmm_readdata <= rd_channel_num;
      AGX_F_ADDR_NAT_DUPLEX:             avmm_readdata <= rd_duplex;
      AGX_F_ADDR_NAT_DUAL_CHNL:          avmm_readdata <= rd_chnl_aib;

      // Address for status registers
      AGX_F_ADDR_GP_RD_LTR:              avmm_readdata <= rd_ltr_status;
      AGX_F_ADDR_GP_RD_CHNL_STATUS:      avmm_readdata <= rd_chnl_ready;
      AGX_F_ADDR_XFER_STATUS:            avmm_readdata <= rd_aib_ready;

      // Addresses for control registers
      AGX_F_ADDR_CHNL_RESET:             avmm_readdata <= rd_chnl_reset;

      //Embedded reconfig
      //rx de-skew
      default:                            avmm_readdata <= RD_UNUSED;
    endcase
  end
end

/**********************************************************************/
// Generate Capability Registers
/**********************************************************************/
generate if(dbg_capability_reg_enable == 1) begin: g_capability_reg_en
    assign rd_channel     = channels[7:0];
    assign rd_channel_num = channel_num[7:0];
    assign rd_duplex      = (duplex_mode == "duplex") ? 8'h3 :
                            (duplex_mode == "tx")     ? 8'h2 : 8'h1;
    assign rd_chnl_aib   = l_num_aib[7:0];
    assign rd_system_id   = dbg_user_identifier[7:0];
    assign rd_status_en   = dbg_stat_soft_logic_enable[7:0];
    assign rd_control_en  = dbg_ctrl_soft_logic_enable[7:0];
  end else begin: g_capability_reg_dis 
    assign rd_channel     = RD_UNUSED;
    assign rd_channel_num = RD_UNUSED;
    assign rd_chnl_aib   = RD_UNUSED;
    assign rd_duplex      = RD_UNUSED;
    assign rd_system_id   = RD_UNUSED;
    assign rd_status_en   = RD_UNUSED;
    assign rd_control_en  = RD_UNUSED;
  end
endgenerate // End generate for g_capability_reg


/**********************************************************************/
// Generate registers for status signals
/**********************************************************************/
generate if(dbg_stat_soft_logic_enable == 1) begin: g_status_reg_en

    /**********************************************************************/
    // Wires for status signal synchronizers inside generate to avoid un-used wires
    /**********************************************************************/
    wire rx_is_ltd_sync;
    wire tx_cal_busy_sync;
    wire rx_cal_busy_sync;


    /**********************************************************************/
    // Instantiate Synchronizers and read logic for rx_is_lockedtodata
    /**********************************************************************/
    eth_f_alt_xcvr_resync_etile #(
      .SYNC_CHAIN_LENGTH         ( 3 ),
      .WIDTH                     ( 1 )  // two bits, one for locktodata and one for locktoref
    ) rx_is_locked_sync (
      .clk                       (avmm_clk),
      .reset                     (avmm_reset),
      .d                         ({rx_is_lockedtodata}),
      .q                         ({rx_is_ltd_sync}) 
    );

    assign rd_ltr_status[AGX_F_OFFSET_RD_LTD] = rx_is_ltd_sync;
    assign rd_ltr_status[AGX_F_OFFSET_LTR_UNUSED+:AGX_F_LTR_UNUSED_LEN] = {AGX_F_LTR_UNUSED_LEN{1'b0}};

    /**********************************************************************/
    // Wires for status signal synchronizers inside generate to avoid un-used wires
    /**********************************************************************/
    wire rx_ready_sync;
    wire tx_ready_sync;


    /**********************************************************************/
    // Instantiate Synchronizers and read logic for rx_is_lockedtodata
    /**********************************************************************/
    eth_f_alt_xcvr_resync_etile #(
      .SYNC_CHAIN_LENGTH         ( 3 ),
      .WIDTH                     ( 2 )  // two bits, one for locktodata and one for locktoref
    ) chnl_ready_sync (
      .clk                       (avmm_clk),
      .reset                     (avmm_reset),
      .d                         ({tx_ready, rx_ready}),
      .q                         ({tx_ready_sync, rx_ready_sync}) 
    );

    assign rd_chnl_ready[AGX_F_OFFSET_TX_RST_READY] = tx_ready_sync;
    assign rd_chnl_ready[AGX_F_OFFSET_RX_RST_READY] = rx_ready_sync;
    assign rd_chnl_ready[AGX_F_OFFSET_CHNL_STATUS_UNUSED+:AGX_F_RST_CHNL_STATUS_UNUSED_LEN] = {AGX_F_RST_CHNL_STATUS_UNUSED_LEN{1'b0}};

    /**********************************************************************/
    // Wires for status signal synchronizers inside generate to avoid un-used wires
    /**********************************************************************/
    wire rx_transfer_ready_sync;
    wire tx_transfer_ready_sync;


    /**********************************************************************/
    // Instantiate Synchronizers and read logic for rx_is_lockedtodata
    /**********************************************************************/
    eth_f_alt_xcvr_resync_etile #(
      .SYNC_CHAIN_LENGTH         ( 3 ),
      .WIDTH                     ( 2 )  // two bits, one for locktodata and one for locktoref
    ) chnl_transfer_ready_sync (
      .clk                       (avmm_clk),
      .reset                     (avmm_reset),
      .d                         ({tx_transfer_ready, rx_transfer_ready}),
      .q                         ({tx_transfer_ready_sync, rx_transfer_ready_sync}) 
    );

    assign rd_aib_ready[AGX_F_OFFSET_TX_XFER_READY] = tx_transfer_ready_sync;
    assign rd_aib_ready[AGX_F_OFFSET_RX_XFER_READY] = rx_transfer_ready_sync;
    assign rd_aib_ready[AGX_F_OFFSET_XFER_STATUS_UNUSED+:AGX_F_XFER_STATUS_UNUSED_LEN] = {AGX_F_XFER_STATUS_UNUSED_LEN{1'b0}};


  end else begin: g_status_reg_dis
    assign rd_aib_ready                           = RD_UNUSED;
    assign rd_ltr_status                          = RD_UNUSED;
    assign rd_chnl_ready                          = RD_UNUSED;

  end
endgenerate //End generate g_status_reg


/**********************************************************************/
// Generate registers for control signals
/**********************************************************************/
generate if(dbg_ctrl_soft_logic_enable == 1) begin: g_control_reg

    /**********************************************************************/
    // Registers for Channel Resets and Overrides
    /**********************************************************************/
    reg r_rx_analogreset;
    reg r_rx_digitalreset;
    reg r_tx_analogreset;
    reg r_tx_digitalreset;
    reg r_rx_analogreset_override;
    reg r_rx_digitalreset_override;
    reg r_tx_analogreset_override;
    reg r_tx_digitalreset_override;

    // readback the control registers for the channel resets and overrides
    assign rd_chnl_reset[AGX_F_OFFSET_RX_ANA]     = r_rx_analogreset;
    assign rd_chnl_reset[AGX_F_OFFSET_RX_DIG]     = r_rx_digitalreset;
    assign rd_chnl_reset[AGX_F_OFFSET_TX_ANA]     = r_tx_analogreset;
    assign rd_chnl_reset[AGX_F_OFFSET_TX_DIG]     = r_tx_digitalreset;
    assign rd_chnl_reset[AGX_F_OFFSET_RX_ANA_OVR] = r_rx_analogreset_override;
    assign rd_chnl_reset[AGX_F_OFFSET_RX_DIG_OVR] = r_rx_digitalreset_override;
    assign rd_chnl_reset[AGX_F_OFFSET_TX_ANA_OVR] = r_tx_analogreset_override;
    assign rd_chnl_reset[AGX_F_OFFSET_TX_DIG_OVR] = r_tx_digitalreset_override;

    // assign the output signals to the channel
    assign csr_rx_analogreset         = (rd_chnl_reset[AGX_F_OFFSET_RX_ANA_OVR]) ? rd_chnl_reset[AGX_F_OFFSET_RX_ANA] : rx_analogreset;
    assign csr_rx_digitalreset        = (rd_chnl_reset[AGX_F_OFFSET_RX_DIG_OVR]) ? rd_chnl_reset[AGX_F_OFFSET_RX_DIG] : rx_digitalreset;
    assign csr_tx_analogreset         = (rd_chnl_reset[AGX_F_OFFSET_TX_ANA_OVR]) ? rd_chnl_reset[AGX_F_OFFSET_TX_ANA] : tx_analogreset;
    assign csr_tx_digitalreset        = (rd_chnl_reset[AGX_F_OFFSET_TX_DIG_OVR]) ? rd_chnl_reset[AGX_F_OFFSET_TX_DIG] : tx_digitalreset;

    // write reset and reset override registers
    always@(posedge avmm_clk or posedge avmm_reset) begin
      if(avmm_reset) begin
        r_rx_analogreset              <= 1'b0;
        r_rx_digitalreset             <= 1'b0;
        r_tx_analogreset              <= 1'b0;
        r_tx_digitalreset             <= 1'b0;
        r_rx_analogreset_override     <= 1'b0;
        r_rx_digitalreset_override    <= 1'b0;
        r_tx_analogreset_override     <= 1'b0;
        r_tx_digitalreset_override    <= 1'b0;
      end else if(avmm_write && avmm_address == AGX_F_ADDR_CHNL_RESET) begin
        r_rx_analogreset              <= avmm_writedata[AGX_F_OFFSET_RX_ANA]; 
        r_rx_digitalreset             <= avmm_writedata[AGX_F_OFFSET_RX_DIG]; 
        r_tx_analogreset              <= avmm_writedata[AGX_F_OFFSET_TX_ANA]; 
        r_tx_digitalreset             <= avmm_writedata[AGX_F_OFFSET_TX_DIG]; 
        r_rx_analogreset_override     <= avmm_writedata[AGX_F_OFFSET_RX_ANA_OVR]; 
        r_rx_digitalreset_override    <= avmm_writedata[AGX_F_OFFSET_RX_DIG_OVR]; 
        r_tx_analogreset_override     <= avmm_writedata[AGX_F_OFFSET_TX_ANA_OVR]; 
        r_tx_digitalreset_override    <= avmm_writedata[AGX_F_OFFSET_TX_DIG_OVR]; 
      end
    end
        
  end else begin: g_control_reg_dis
    // assign LTR control signals when control registers are disabled
    assign rd_chnl_reset              = RD_UNUSED;

    // pass through control signals
    assign csr_rx_analogreset         = (rx_analogreset);
    assign csr_rx_digitalreset        = (rx_digitalreset);
    assign csr_tx_analogreset         = (tx_analogreset);
    assign csr_tx_digitalreset        = (tx_digitalreset);
  end
endgenerate // End generate g_control_reg

/**********************************************************************/
// Embedded reconfig registers
/**********************************************************************/


endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "o2ONPYJ6JWO2K/lQHkyApXo6DVczB8sUyJtLpEiYtF7LL07s93qi8rQ7d2s1AdTOt/BNVdBoSTLCdACDT58BR3umvYuucV6Cbb36lNsOsJegwtedOJsDvTnB14ZLU41EvDEX+uxr7iJUYiTmn7hunq22K1+T/Nc7+FaTNr6AMH3CCuiZmo/CmXjVXLRPwF034Kg1mVvlsNTpZhm0ORjPpNI8tuMP0bMp6HLhHMKVKvfK5KY2vk3yH3cW5XInGF1wlCNz02rJwymQiliNT2fB5IJrrIWMTe+y4G5KpPrG1wMQe8JsjH1LkmHWJIMlS5AeDkfYItH09c27RE5MdIMaQOygi2+sLTG/USHM6mRmAL3BoTaTI5s4xJUhlFVFviLozKOEIIeQtiSqV455Sj8t8GD7EcfNemSQQ3bZ7lOmL+ZGinKg9do54KE5dSFVvq6yeYT+aY27xvQrZO/LxI3NmyjCdwVA5rtNXxLzlA8xlOPXsNeugBN7DprZOCf2YR1Xq/wGch6NR8CdZHMm1aRRASesAOGBNn5P1QfW3NB727OKR55tGXrMM2ZyzizROnpEliSzIgxLdIOauJJsaf3Hodl8ak8HD4OmJkGUbwzTdEp3wzbj/3tG9GYALH0ee42YbvWpYa4xaJ5LdOfsHsY1/9eDeTUfHHI8s0w+jYo7ze4xQEzHx9sLJyPfLKzlGuUmt1XW0EINecXN7bbp970JACUusPj2xNDl4hfGEJndySm5Da89hRT3Z1IpcoOvAXHmazuShukq861zDFhIcbf2rys8KJzactORZ8/gOKXOswYhnA+XuVgUHoS8vo3NYrQRNzypYR5EsV9H8C54kxl00IFvNOJ8P4zbVE1+RJXegawaNgAs9dYEShzfHND21hhK1zQbDn8XjVsKMdX+Q230S2qTCETd+F9tET4RPJEBIRbt9vS139D4qDpHjeSDaRRIRBRrN3QJRz1wQLBWq41TwBm0sKpa2vFeW4HKbed9VyvKlymWWg+7gtS4UTFLXoWJ"
`endif