package type2_nic_pkg;

  localparam int TYPE2_DESC_ADDR_W = 64;
  localparam int TYPE2_DESC_LEN_W  = 16;
  localparam int TYPE2_DESC_META_W = 16;

  typedef struct packed {
    logic [TYPE2_DESC_ADDR_W-1:0] addr;
    logic [TYPE2_DESC_LEN_W-1:0]  len;
    logic [TYPE2_DESC_META_W-1:0] meta;
    logic                         eop;
    logic                         irq_req;
    logic [29:0]                  rsvd;
  } type2_tx_desc_t;

  typedef struct packed {
    logic [TYPE2_DESC_ADDR_W-1:0] addr;
    logic [TYPE2_DESC_LEN_W-1:0]  len;
    logic [TYPE2_DESC_META_W-1:0] meta;
    logic [31:0]                  rsvd;
  } type2_rx_fill_desc_t;

  typedef struct packed {
    logic [15:0] pkt_len;
    logic [15:0] status;
    logic [15:0] meta;
    logic [15:0] queue_id;
    logic [63:0] opaque;
  } type2_cpl_t;

  localparam logic [15:0] TYPE2_CPL_OK         = 16'h0001;
  localparam logic [15:0] TYPE2_CPL_RX_ERR     = 16'h0002;
  localparam logic [15:0] TYPE2_CPL_RX_TRUNC   = 16'h0004;
  localparam logic [15:0] TYPE2_CPL_TX_ERR     = 16'h0008;
  localparam logic [15:0] TYPE2_CPL_LINK_DOWN  = 16'h0010;

endpackage
