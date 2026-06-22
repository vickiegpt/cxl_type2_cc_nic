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


module eth_f_avmm2 #(
    parameter          num_sys_cop                                              = 1,  //number of systems, only 1
    parameter          num_xcvr                                                 = 1,  //number of xcvr each system
    parameter          l_num_aib                                                = 1,  //number of AIB lanes
    parameter          l_sys_xcvrs                                              = 1,
    parameter          l_tx_enable                                              = 0,  //for soft_csr
    parameter          l_rx_enable                                              = 0,  //for soft_csr
    parameter          avmm2_split                                              = 1,  //one AVMM2 interface has multiple xcvr if split=0
    parameter          avmm2_jtag_enable                                        = 0,  //ADME enable
    parameter          l_av2_enable                                             = 1,  //AVMM2 enabled
    parameter          l_num_avmm2                                              = 1,  //number of avmm2 bb
    parameter          l_av2_ifaces                                             = 1,  //number of interface across systems
    parameter          l_av2_addr_bits                                          = 21, //AVMM2 addr bits
    parameter          l_soft_csr_enable                                        = 0,  //soft_csr_enable
    parameter          DATA_WIDTH                                               = 32
) (  
    input   [l_av2_ifaces-1:0]                  reconfig_clk,             //       reconfig_clk.clk
    input   [l_av2_ifaces-1:0]                  reconfig_reset,           //     reconfig_reset.reset
    input   [l_av2_ifaces-1:0]                  reconfig_write,           //      reconfig_avmm.write
    input   [l_av2_ifaces-1:0]                  reconfig_read,            //                   .read
    input   [l_av2_addr_bits*l_av2_ifaces-1:0]  reconfig_address,         //                   .address
    input   [l_av2_ifaces*4-1:0]                reconfig_byteenable,      //                   .byteenable
    input   [l_av2_ifaces*DATA_WIDTH-1:0]       reconfig_writedata,       //                   .writedata
    output logic [l_av2_ifaces*DATA_WIDTH-1:0]       reconfig_readdata,        //                   .readdata
    output  [l_av2_ifaces-1:0]                  reconfig_waitrequest,     //                   .waitrequest
    output logic [l_av2_ifaces-1:0]             reconfig_readdata_valid,  //                   .readdata_valid

    //  for AVMM2 bb ports
    output  wire  [l_num_avmm2-1:0]      hip_avmm_read,
    input   wire  [8*l_num_avmm2-1:0]    hip_avmm_readdata,
    input   wire  [l_num_avmm2-1:0]      hip_avmm_readdatavalid,
    output  wire  [21*l_num_avmm2-1:0]   hip_avmm_reg_addr,
    input   wire  [5*l_num_avmm2-1:0]    hip_avmm_reserved_out,
    output  wire  [l_num_avmm2-1:0]      hip_avmm_write,
    output  wire  [8*l_num_avmm2-1:0]    hip_avmm_writedata,
    input   wire  [l_num_avmm2-1:0]      hip_avmm_writedone,
    input   wire  [l_num_avmm2-1:0]      pld_avmm2_busy,
    output  wire  [l_num_avmm2-1:0]      pld_avmm2_clk_rowclk,
    input   wire  [l_num_avmm2-1:0]      pld_avmm2_cmdfifo_wr_full,
    input   wire  [l_num_avmm2-1:0]      pld_avmm2_cmdfifo_wr_pfull,
    output  wire  [l_num_avmm2-1:0]      pld_avmm2_request,
    input   wire  [l_num_avmm2-1:0]      pld_pll_cal_done,
            // below are unused ports in hip mode
    output  wire  [l_num_avmm2-1:0]      pld_avmm2_write,
    output  wire  [l_num_avmm2-1:0]      pld_avmm2_read,
    output  wire  [9*l_num_avmm2-1:0]    pld_avmm2_reg_addr,
    input   wire  [8*l_num_avmm2-1:0]    pld_avmm2_readdata,
    output  wire  [8*l_num_avmm2-1:0]    pld_avmm2_writedata,
    input   wire  [l_num_avmm2-1:0]      pld_avmm2_readdatavalid,
    output  wire  [6*l_num_avmm2-1:0]   pld_avmm2_reserved_in,
    input   wire  [1*l_num_avmm2-1:0]    pld_avmm2_reserved_out
);
  //Temp workaround by Jacky
  wire [l_av2_ifaces*DATA_WIDTH-1:0]       reconfig_readdata_r;
  wire [l_av2_ifaces-1:0]                 reconfig_readdata_valid_r;

  genvar q;
  generate
    for (q=0; q<l_av2_ifaces; q=q+1) begin:readdata_valid_delay
      always @ (posedge reconfig_clk[q]) begin 
        reconfig_readdata_valid[q] <= reconfig_readdata_valid_r[q]; //Need to delay one cycle
        reconfig_readdata[q*DATA_WIDTH+:DATA_WIDTH] <= reconfig_readdata_r[q*DATA_WIDTH+:DATA_WIDTH];
      end
    end
  endgenerate

  //\TODO  TEMPORARILY COPIED FUNCTION UNTIL TILE_IP HANDLES PACKAGES PROPERLY
  localparam integer MAX_CHARS_ALT_XCVR_NATIVE_S10 = 86; // To accomodate LONG parameter lists.
  ////////////////////////////////////////////////////////////////////
  // Convert an integer to a string
  function [MAX_CHARS_ALT_XCVR_NATIVE_S10*8-1:0] int2str_alt_xcvr_native_s10(
    input integer in_int
  );
    integer i;
    integer this_char;
    i = 0;
    int2str_alt_xcvr_native_s10 = "";
    do
    begin
      this_char = (in_int % 10) + 48;
      int2str_alt_xcvr_native_s10[i*8+:8] = this_char[7:0];
      i=i+1;
      in_int = in_int / 10; 
    end
    while(in_int > 0);
  endfunction

  localparam  ifs_psys    = (avmm2_split)? num_xcvr : 1;        //number of AVMM2 interface each system
  localparam  xcvr_pif    = (avmm2_split)? 1 : num_xcvr;        //number fo xcvr each AVMM2 interface
  localparam  ch_sel_bits = (l_soft_csr_enable)? l_av2_addr_bits-21  :  l_av2_addr_bits-20; //select xcvr under one interface, won't be used if xcvr_pif=1
  localparam  BE_WIDTH    = DATA_WIDTH/8;

  wire    [l_av2_ifaces-1:0]    m32_read;
  wire    [l_av2_ifaces-1:0]    m32_write;
  wire    [DATA_WIDTH-1:0]      m32_writedata   [l_av2_ifaces-1:0];
  wire    [DATA_WIDTH-1:0]      m32_readdata    [l_av2_ifaces-1:0];
  wire    [l_av2_ifaces-1:0]    m32_waitrequest;
  wire    [l_av2_ifaces-1:0]    m32_readdata_valid;
  wire    [l_av2_addr_bits-1:0] m32_address     [l_av2_ifaces-1:0];
  wire    [3:0]                 m32_byteenable  [l_av2_ifaces-1:0];

  wire    [l_av2_ifaces-1:0]    m8_read;
  wire    [l_av2_ifaces-1:0]    m8_write;
  wire    [7:0]                 m8_writedata   [l_av2_ifaces-1:0];
  wire    [7:0]                 m8_readdata    [l_av2_ifaces-1:0];
  wire    [l_av2_ifaces-1:0]    m8_waitrequest;
  wire    [l_av2_addr_bits:0]   m8_addr        [l_av2_ifaces-1:0];  // from coverter, as <Dword Access>, <ch_sel>, {soft_csr}, [19:0]
  wire    [l_av2_addr_bits:0]   m8_addr_av2    [l_av2_ifaces-1:0];  // arranged as <ch_sel>, {soft_csr}, <Dword Access>,  [19:0]
                                                                    // only Dword will be added at MSB from converter
                                                                    // ch_sel and soft_csr are part of input port address
genvar ig, ifs_idx, xcvr_idx;
generate
  if (!l_av2_enable) begin: av2_dis
    eth_f_ctfb_avmm2_soft_logic #(  
       .avmm_interfaces(l_num_avmm2),                         //Number of AVMM interfaces required - one for each XCVR or PCIe IP
       .rcfg_enable (l_av2_enable)                            //Enable/disable reconfig interface in the XCVR PMA or PCIe IPs
    ) avmm2_dis_inst (
      // AVMM slave interface signals (user)
       .avmm_clk ({ l_num_avmm2{1'b0} }) ,
       .avmm_reset ({ l_num_avmm2{1'b0} } ),
       .avmm_writedata ({ (l_num_avmm2*8){1'b0} }), 
       .avmm_address ({ (l_num_avmm2*21){1'b0} }), 
       .avmm_write ({ l_num_avmm2{1'b0} }),
       .avmm_read ({ l_num_avmm2{1'b0} }),
       .avmm_readdata (), 
       .avmm_waitrequest (),
      //AVMM interface busy with calibration
       .avmm_busy (),

      // Expose clkchnl to wire up with pld_adapt avmmclk for Place and Route in Fitter
       .avmm_clkchnl (),

      // ports to/from hip ports of building block
       .hip_avmm_read_real ( hip_avmm_read ),
       .hip_avmm_readdata_real ( { (l_num_avmm2*8){1'b0} } ),
       .hip_avmm_readdatavalid_real ( { l_num_avmm2{1'b0} } ),
       .hip_avmm_reg_addr_real ( hip_avmm_reg_addr ),
       .hip_avmm_reserved_out_real ( hip_avmm_reserved_out ),
       .hip_avmm_write_real ( hip_avmm_write ),
       .hip_avmm_writedata_real ( hip_avmm_writedata ),
       .hip_avmm_writedone_real ( { l_num_avmm2{1'b0} } ),
       .pld_avmm2_busy_real ( { l_num_avmm2{1'b0} } ),
       .pld_avmm2_clk_rowclk_real ( pld_avmm2_clk_rowclk ),
       .pld_avmm2_cmdfifo_wr_full_real ( pld_avmm2_cmdfifo_wr_full ),
       .pld_avmm2_cmdfifo_wr_pfull_real ( pld_avmm2_cmdfifo_wr_pfull ),
       .pld_avmm2_request_real ( pld_avmm2_request ),
       .pld_pll_cal_done_real ( pld_pll_cal_done ),
      // below are unused ports in hip mode
       .pld_avmm2_write_real ( pld_avmm2_write ),
       .pld_avmm2_read_real ( pld_avmm2_read ),
       .pld_avmm2_reg_addr_real ( pld_avmm2_reg_addr ),
       .pld_avmm2_readdata_real ( pld_avmm2_readdata ),
       .pld_avmm2_writedata_real (pld_avmm2_writedata  ),
       .pld_avmm2_readdatavalid_real ( pld_avmm2_readdatavalid ),
       .pld_avmm2_reserved_in_real ( pld_avmm2_reserved_in ),
       .pld_avmm2_reserved_out_real ( { (l_num_avmm2){1'b0} } )
    );
  end   else begin:av2_ena
    for(ig=0;ig<num_sys_cop;ig=ig+1) begin: av2_sys     //counting systems
      for (ifs_idx=0; ifs_idx<ifs_psys; ifs_idx=ifs_idx+1) begin: av2_ifs   //counting interface under one systems
        localparam  av2_idx     = ig*num_xcvr+ifs_idx*xcvr_pif;     //accumulated xcvr across systems
        localparam  sys_ifs_idx = ig*ifs_psys + ifs_idx;    //accumulated interface across systems
        // per xcvr read/write signals for soft csr and avmm port
        wire [xcvr_pif-1:0] ch_write, ch_read, ch_waitrequest;
        wire [xcvr_pif-1:0] csr_write, csr_read, csr_waitrequest;
        wire [xcvr_pif-1:0] [7:0] ch_readdata, csr_readdata ;

        //assign reconfig_readdata[sys_ifs_idx*DATA_WIDTH+:DATA_WIDTH] = m32_readdata[sys_ifs_idx];
        assign reconfig_readdata_r[sys_ifs_idx*DATA_WIDTH+:DATA_WIDTH] = m32_readdata[sys_ifs_idx];//Jacky
        assign reconfig_readdata_valid_r[sys_ifs_idx] = m32_readdata_valid[sys_ifs_idx];//Jacky

        assign m8_addr_av2[sys_ifs_idx] =  m8_addr[sys_ifs_idx]; // No ch_sel bits and soft_csr bits, no need to rearrange
        /*
        assign m8_addr_av2[sys_ifs_idx] = (l_av2_addr_bits==20)? m8_addr[sys_ifs_idx] :
                                                                 {m8_addr[sys_ifs_idx][l_av2_addr_bits-1:20], m8_addr[sys_ifs_idx][l_av2_addr_bits], m8_addr[sys_ifs_idx][19:0]};
        */

      if (avmm2_jtag_enable) begin: w_adme
         // add ADME and Arbiter
         // Set the slave type for the ADME.  Since the span needs to be a string, 2^(total addr_bits) will
         // give the max value, however since the adme uses byte alignment, shift the span by two bits.
         localparam                      ADME_SLAVE_MAP              = "directphy_f";
         localparam                      ADME_ASSGN_MAP              = " ";
         localparam set_slave_span = int2str_alt_xcvr_native_s10(2**l_av2_addr_bits);
         localparam set_slave_map  = {"{typeName ",ADME_SLAVE_MAP," address 0x0 span ",set_slave_span," hpath {}",ADME_ASSGN_MAP,"}"};

         // Raw JTAG signals
         wire                                     jtag_write;
         wire                                     jtag_read;
         wire                                     jtag_read_write;
         wire [l_av2_addr_bits-1:0]               jtag_address;
         wire [DATA_WIDTH-1:0]                    jtag_writedata;
         wire [BE_WIDTH-1:0]                      jtag_byteenable;
         wire [DATA_WIDTH-1:0]                    jtag_readdata;
         wire                                     jtag_waitrequest;

         assign  jtag_readdata = m32_readdata[sys_ifs_idx];
         assign  jtag_read_write = jtag_read | jtag_write;

         // When doing RTL sims, remove the altera_debug_master_endpoint, as 
         // there is no RTL simulation model.  Pre and Post Fit sims are ok.
         `ifdef ALTERA_RESERVED_QIS
            assign jtag_byteenable                    = {BE_WIDTH{1'b1}};
            altera_debug_master_endpoint
            #(
              .ADDR_WIDTH                            ( l_av2_addr_bits ),
              .DATA_WIDTH                            ( DATA_WIDTH                    ),
              .HAS_RDV                               ( 0                             ),
              .SLAVE_MAP                             ( set_slave_map                 ),
              .PREFER_HOST                           ( " "                           ),
              .CLOCK_RATE_CLK                        ( 0                             )
            ) adme (
              .clk                                   ( reconfig_clk[sys_ifs_idx]     ),
              .reset                                 ( reconfig_reset[sys_ifs_idx]   ),
              .master_write                          ( jtag_write                    ),
              .master_read                           ( jtag_read                     ),
              .master_address                        ( jtag_address                  ),
              .master_writedata                      ( jtag_writedata                ),
              .master_waitrequest                    ( jtag_waitrequest              ),
              .master_readdatavalid                  ( 1'b0                          ),
              .master_readdata                       ( jtag_readdata                 )
            );
         `else
            assign jtag_write                         = 1'b0;
            assign jtag_read                          = 1'b0;
            assign jtag_address                       = {l_av2_addr_bits{1'b0}};
            assign jtag_byteenable                    = {BE_WIDTH{1'b0}};
            assign jtag_writedata                     = {DATA_WIDTH{1'b0}};
         `endif

         // arbiter 
         eth_f_alt_xcvr_avmm_arb #(
           .TOTAL_MASTERS (2),
           .CHANNELS ( 1 ),
           .ADDRESS_WIDTH (l_av2_addr_bits),
           .DATA_WIDTH  (DATA_WIDTH)
           ) avmm_2to1_arb_inst (
           .ini_clk    (reconfig_clk[sys_ifs_idx]),
           .ini_reset  (reconfig_reset[sys_ifs_idx]),
           .ini_read        ( {jtag_read, reconfig_read[sys_ifs_idx]} ),
           .ini_write       ( {jtag_write, reconfig_write[sys_ifs_idx]} ),
           .ini_address     ( {jtag_address, reconfig_address[sys_ifs_idx*l_av2_addr_bits+:l_av2_addr_bits]} ),
           .ini_byteenable  ( {jtag_byteenable, reconfig_byteenable[sys_ifs_idx*BE_WIDTH+:BE_WIDTH]} ),
           .ini_writedata   ( {jtag_writedata, reconfig_writedata[sys_ifs_idx*DATA_WIDTH+:DATA_WIDTH]} ),
           .ini_read_write  ( {jtag_read_write, reconfig_read[sys_ifs_idx]|reconfig_write[sys_ifs_idx]} ),
           .ini_waitrequest ( {jtag_waitrequest, reconfig_waitrequest[sys_ifs_idx]} ),
           .avmm_waitrequest  (m32_waitrequest[sys_ifs_idx]),
           .avmm_read         (m32_read[sys_ifs_idx]),
           .avmm_write        (m32_write[sys_ifs_idx]),
           .avmm_address      (m32_address[sys_ifs_idx]),
           .avmm_byteenable   (m32_byteenable[sys_ifs_idx]),
           .avmm_writedata    (m32_writedata[sys_ifs_idx])
         );
      end   else begin   : no_adme
         assign reconfig_waitrequest[sys_ifs_idx]  = m32_waitrequest[sys_ifs_idx];
         assign m32_read[sys_ifs_idx]         = reconfig_read[sys_ifs_idx];
         assign m32_write[sys_ifs_idx]        = reconfig_write[sys_ifs_idx];
         assign m32_address[sys_ifs_idx]      = reconfig_address[sys_ifs_idx*l_av2_addr_bits+:l_av2_addr_bits];
         assign m32_byteenable[sys_ifs_idx]   = reconfig_byteenable[sys_ifs_idx*BE_WIDTH+:BE_WIDTH];
         assign m32_writedata[sys_ifs_idx]    = reconfig_writedata[sys_ifs_idx*DATA_WIDTH+:DATA_WIDTH];
      end
        // 32 to 8 conversion
        eth_f_ft_avmm_32to8_bridge 
             #(   
                  .ADDR_WIDTH ( l_av2_addr_bits ),
                  .READ_PIPELINE_ENABLE (1)
              )
          avmm_32to8_inst (
           // AVMM slave Port
           .i_clk                   ( reconfig_clk[sys_ifs_idx] ),
           .i_rst                   ( reconfig_reset[sys_ifs_idx] ),

           .i_avmm_s32_addr         ( m32_address[sys_ifs_idx] ),
           .i_avmm_s32_wdata        ( m32_writedata[sys_ifs_idx] ),
           .i_avmm_s32_write        ( m32_write[sys_ifs_idx] ),
           .i_avmm_s32_read         ( m32_read[sys_ifs_idx] ),
           .i_avmm_s32_byte_enable  ( m32_byteenable[sys_ifs_idx] ),
           .o_avmm_s32_readdata     ( m32_readdata[sys_ifs_idx] ),
           .o_avmm_s32_waitrequest  ( m32_waitrequest[sys_ifs_idx] ),
           .o_avmm_s32_readdatavalid  ( m32_readdata_valid[sys_ifs_idx] ),

           // Master Port
           .o_avmm_m8_addr          ( m8_addr[sys_ifs_idx] ),
           .o_avmm_m8_wdata         ( m8_writedata[sys_ifs_idx] ),
           .o_avmm_m8_write         ( m8_write[sys_ifs_idx] ),
           .o_avmm_m8_read          ( m8_read[sys_ifs_idx] ),
           .i_avmm_m8_readdata      ( m8_readdata[sys_ifs_idx] ),
           .i_avmm_m8_waitrequest   ( m8_waitrequest[sys_ifs_idx] )
          );

        //  decoding multi-xcvr and csr 
        if (xcvr_pif==1)  begin: sin
          if (!l_soft_csr_enable) begin: sin_no_csr
             assign ch_write     [0]                          = m8_write[sys_ifs_idx];
             assign ch_read      [0]                          = m8_read[sys_ifs_idx] ;
             assign m8_readdata[sys_ifs_idx]                  = ch_readdata[0];
             assign m8_waitrequest[sys_ifs_idx]               = ch_waitrequest[0]; //Jacky
          end else begin: sin_csr
             assign csr_write    [0]                          = m8_write[sys_ifs_idx] & m8_addr_av2[sys_ifs_idx][21];
             assign csr_read     [0]                          = m8_read[sys_ifs_idx]  & m8_addr_av2[sys_ifs_idx][21];
             assign ch_write     [0]                          = m8_write[sys_ifs_idx] & ~m8_addr_av2[sys_ifs_idx][21];
             assign ch_read      [0]                          = m8_read[sys_ifs_idx]  & ~m8_addr_av2[sys_ifs_idx][21];
             assign m8_readdata[sys_ifs_idx]                  = (m8_addr_av2[sys_ifs_idx][21])? csr_readdata[0] : ch_readdata[0];
          end
        end else begin: mul //when xcvr_pif!=1, one avmm2 interface connects to multiple xcvr
            wire [ch_sel_bits-1:0]             ch_sel;
            assign ch_sel  = m8_addr_av2[sys_ifs_idx][l_av2_addr_bits-:ch_sel_bits];
            // This part for write/read signals
            for(xcvr_idx=0;xcvr_idx<xcvr_pif; xcvr_idx=xcvr_idx+1) begin: g_xcvr
              if (!l_soft_csr_enable) begin: mul_no_csr
                  assign ch_write     [xcvr_idx]                   = m8_write[sys_ifs_idx] & (ch_sel == xcvr_idx);
                  assign ch_read      [xcvr_idx]                   = m8_read[sys_ifs_idx]  & (ch_sel == xcvr_idx);
              end else begin: mul_csr
                  assign csr_write    [xcvr_idx]                   = m8_write[sys_ifs_idx] & (ch_sel == xcvr_idx) & m8_addr_av2[sys_ifs_idx][21];
                  assign csr_read     [xcvr_idx]                   = m8_read[sys_ifs_idx] & (ch_sel == xcvr_idx)  & m8_addr_av2[sys_ifs_idx][21];
                  assign ch_write     [xcvr_idx]                   = m8_write[sys_ifs_idx] & (ch_sel == xcvr_idx) & ~m8_addr_av2[sys_ifs_idx][21];
                  assign ch_read      [xcvr_idx]                   = m8_read[sys_ifs_idx] & (ch_sel == xcvr_idx)  & ~m8_addr_av2[sys_ifs_idx][21];
              end
            end
            // This part for readata
            if (!l_soft_csr_enable) begin
                assign m8_readdata[sys_ifs_idx]                  = ch_readdata[ch_sel];
                assign m8_waitrequest[sys_ifs_idx]               = ch_waitrequest[ch_sel];
            end   else begin
                assign m8_readdata[sys_ifs_idx]                  = (m8_addr_av2[sys_ifs_idx][21])? csr_readdata[ch_sel] : ch_readdata[ch_sel];
                assign m8_waitrequest[sys_ifs_idx]               = (m8_addr_av2[sys_ifs_idx][21])? csr_waitrequest[ch_sel] : ch_waitrequest[ch_sel];
            end
        end     // mul

        // connect to avmm2 port soft logic 
        eth_f_ctfb_avmm2_soft_logic
        #(  .avmm_interfaces       (xcvr_pif),                 //Number of AVMM ports required - one for each xcvr channel or PCIe HIP
            .rcfg_enable           (l_av2_enable)               //Enable/disable reconfig interface in the XCVR PMA or PCIe IPs
         ) avmm2_cl_inst   (
        // AVMM slave interface signals (user)
         .avmm_clk                 ( {xcvr_pif{reconfig_clk[sys_ifs_idx]}} ) ,
         .avmm_reset               ( {xcvr_pif{reconfig_reset[sys_ifs_idx]}} ),
         .avmm_writedata           ( {xcvr_pif{m8_writedata[sys_ifs_idx]}}), 
         .avmm_address             ( {xcvr_pif{m8_addr_av2[sys_ifs_idx][0+:21]}} ), //bit 20 dw_acc, 19:0 addr
         .avmm_write               ( ch_write ),
         .avmm_read                ( ch_read ),
         .avmm_readdata            ( ch_readdata ), 
         .avmm_waitrequest         ( ch_waitrequest ),
        //AVMM interface busy with calibration
         .avmm_busy (),

        // Expose clkchnl to wire up with pld_adapt avmmclk for Place and Route in Fitter
         .avmm_clkchnl (),

        // ports to/from hip ports of building block
         .hip_avmm_read_real             ( hip_avmm_read[av2_idx+:xcvr_pif] ),
         .hip_avmm_readdata_real         ( hip_avmm_readdata[av2_idx*8+:xcvr_pif*8] ),
         .hip_avmm_readdatavalid_real    ( hip_avmm_readdatavalid[av2_idx+:xcvr_pif] ),
         .hip_avmm_reg_addr_real         ( hip_avmm_reg_addr[av2_idx*21+:xcvr_pif*21] ),
         .hip_avmm_reserved_out_real     ( hip_avmm_reserved_out[av2_idx*5+:xcvr_pif*5] ),
         .hip_avmm_write_real            ( hip_avmm_write[av2_idx+:xcvr_pif] ),
         .hip_avmm_writedata_real        ( hip_avmm_writedata[av2_idx*8+:xcvr_pif*8] ),
         .hip_avmm_writedone_real        ( hip_avmm_writedone[av2_idx+:xcvr_pif] ),
         .pld_avmm2_busy_real            ( pld_avmm2_busy[av2_idx+:xcvr_pif] ),
         .pld_avmm2_clk_rowclk_real      ( pld_avmm2_clk_rowclk[av2_idx+:xcvr_pif] ),
         .pld_avmm2_cmdfifo_wr_full_real ( pld_avmm2_cmdfifo_wr_full[av2_idx+:xcvr_pif] ),
         .pld_avmm2_cmdfifo_wr_pfull_real( pld_avmm2_cmdfifo_wr_pfull[av2_idx+:xcvr_pif] ),
         .pld_avmm2_request_real         ( pld_avmm2_request[av2_idx+:xcvr_pif] ),
         .pld_pll_cal_done_real          ( pld_pll_cal_done[av2_idx+:xcvr_pif] ),
        // below are unused ports in hip mode
         .pld_avmm2_write_real           ( pld_avmm2_write[av2_idx+:xcvr_pif] ),
         .pld_avmm2_read_real            ( pld_avmm2_read[av2_idx+:xcvr_pif] ),
         .pld_avmm2_reg_addr_real        ( pld_avmm2_reg_addr[av2_idx*9+:xcvr_pif*9] ),
         .pld_avmm2_readdata_real        ( pld_avmm2_readdata[av2_idx*8+:xcvr_pif*8] ),
         .pld_avmm2_writedata_real       ( pld_avmm2_writedata[av2_idx*8+:xcvr_pif*8] ),
         .pld_avmm2_readdatavalid_real   ( pld_avmm2_readdatavalid[av2_idx+:xcvr_pif] ),
         .pld_avmm2_reserved_in_real     ( pld_avmm2_reserved_in[av2_idx*6+:xcvr_pif*6] ),
         .pld_avmm2_reserved_out_real    ( pld_avmm2_reserved_out[av2_idx*1+:xcvr_pif*1] )
         );

       // add CSR register instance
       if (l_soft_csr_enable) begin
        for (xcvr_idx=0;xcvr_idx<xcvr_pif; xcvr_idx=xcvr_idx+1) begin: g_xcvr_csr
            eth_f_avmm_csr # (
                    .dbg_capability_reg_enable        (1),
                    .dbg_user_identifier              (1),
                    .dbg_stat_soft_logic_enable       (1),
                    .dbg_ctrl_soft_logic_enable       (1),
                    .channels                         (num_xcvr),
                    .channel_num                      (xcvr_idx),
                    .addr_width                       (10),
                    .duplex_mode                      ((l_tx_enable)? ((l_rx_enable)? "duplex" : "tx") : "rx"),
                    .num_aib_per_xcvr                 (l_num_aib)
            ) eth_avmm_csr_inst (
                   .avmm_clk                   ( reconfig_clk[sys_ifs_idx] ),
                   .avmm_reset                 ( reconfig_reset[sys_ifs_idx] ),
                   .avmm_address               ( m8_addr_av2[sys_ifs_idx][9:0] ),
                   .avmm_writedata             ( m8_writedata[sys_ifs_idx] ),
                   .avmm_write                 ( csr_write[xcvr_idx] ),
                   .avmm_read                  ( csr_read[xcvr_idx] ) ,
                   .avmm_readdata              ( csr_readdata[xcvr_idx] ),
                   .avmm_waitrequest           ( csr_waitrequest[xcvr_idx] ),

                   .rx_is_lockedtodata         (1'b1),

                   .tx_transfer_ready          (1'b1),
                   .rx_transfer_ready          (1'b1),

                   .rx_analogreset             (1'b1),
                   .rx_digitalreset            (1'b1),
                   .tx_analogreset             (1'b1),
                   .tx_digitalreset            (1'b1),

                   .tx_ready                   (1'b1),
                   .rx_ready                   (1'b1),

                   .csr_rx_analogreset         (),
                   .csr_rx_digitalreset        (),
                   .csr_tx_analogreset         (),
                   .csr_tx_digitalreset        ()
           );
        end  // g_xcvr_csr
       end  // l_soft_csr_enable
      end  // av2_ifs
    end   // av2_sys
  end   // av2_ena
endgenerate

endmodule

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "o2ONPYJ6JWO2K/lQHkyApXo6DVczB8sUyJtLpEiYtF7LL07s93qi8rQ7d2s1AdTOt/BNVdBoSTLCdACDT58BR3umvYuucV6Cbb36lNsOsJegwtedOJsDvTnB14ZLU41EvDEX+uxr7iJUYiTmn7hunq22K1+T/Nc7+FaTNr6AMH3CCuiZmo/CmXjVXLRPwF034Kg1mVvlsNTpZhm0ORjPpNI8tuMP0bMp6HLhHMKVKveEOMgfPqyueJcdJ8+49UytSiEa/45O1NK0XmdGYhlItcZ9QYjJ0PrM9aPvOLDiwaffeCWOMfDpWnGf5nkn743FmzVFK2Qcokk+ZxD7lRlfTKA9xVH5EybIwtsVnUF0///NZ1YSjq4wArd0Pm+DMmw5use8n1bgPzWE5p88Bnq91aEZpM7NkLC07wZLpVlce/RThZSekRe9fXVsaAcfaTsFBhd8LBEmrNC8W6x7DLzxUULVPyOHAnnuQF1/h6YTDkSW6jDWDdPpsQO4p2B4LoONsN+WR4wkdv6TMaMC4wqgKRYRsHMVT5q1jKC8RWWsO+G1i7jTjbDa0+JDYja4QLUgQ50IV4GDGYbl9+ZUhfX4EucPnDd68+C+Az2eaIS09Au2Ae9ZbFMnsOFB1mRY8Un2Q1QbdkTXPcFkbfcyR3fF2ScxJUTVK3munoXkUfZyz5izozVNXbEujGPu9UzEtDFusHAeKWQgzkkpWi3MzkETD1C2lIPQ4v8R6JFhzkO6ge0IzAtEd1j3RO9NjngH+CaZwnlqco93vRvn9qjcl4MRkRNxH4QFRQpyI+TGNFSekUUoZq0unC4CKhQ9kC9wgWyHJeOvLN5+9JPvZ8eWnO6stpo0V+xGbTJRsixmM/47i8bdPaUhQG+rFjCYw+g5xtbPmXX3/k7EtwjxyoypuKVsPeexEVE1LxnI56MQYGbeLICcFA+6DpkGc9XE+MW3YagFJ6MLv6S8eiklaHhVmvOMzXtWhNqq0V91JQvF8ZtX1BMpMhnqAviMPrq0qy+OUTOn"
`endif