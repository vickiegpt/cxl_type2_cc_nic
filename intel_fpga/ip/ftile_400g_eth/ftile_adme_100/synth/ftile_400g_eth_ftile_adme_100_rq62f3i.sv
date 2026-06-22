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


module ftile_400g_eth_ftile_adme_100_rq62f3i #(
                parameter avmm1_is_used                 = 0,
                parameter avmm1_ehip_port_count         = 1,
                parameter avmm1_ehip_port_frac_skipping = 0,
                parameter avmm1_ehip_frac_size          = "F25G",
                parameter avmm1_enable_cwbin_gui        = 0,  
                parameter avmm1_duplex_mode             = "duplex",
                parameter avmm1_expose_local_port       = 0,
                parameter avmm1_addr_width              = 14,
                parameter avmm1_slave_map               = "",
                parameter avmm1_has_rdv                 = 0,

		        parameter avmm2_is_used                 = 0,
                parameter avmm2_pma_port_count          = 1,
                parameter avmm2_pma_type                = "FGT",
                parameter avmm2_pma_modulation          = "NRZ",
                parameter avmm2_pma_datarate            = "25781.25",
                parameter avmm2_duplex_mode             = "duplex",
                parameter avmm2_expose_local_port       = 0,
                parameter avmm2_addr_width              = 18,
                parameter avmm2_slave_map               = "",
                parameter avmm2_has_rdv                 = 0,
                parameter device_revision               = "",

                parameter        Profile0_ENABLED = 0,
                parameter        Profile1_ENABLED = 0,
                parameter        Profile2_ENABLED = 0,
                parameter        Profile3_ENABLED = 0,
                parameter        Profile4_ENABLED = 0,
                parameter        Profile5_ENABLED = 0,
                parameter        Profile6_ENABLED = 0,
                parameter        Profile7_ENABLED = 0,
                parameter        Profile8_ENABLED = 0,
                parameter        Profile9_ENABLED = 0,
                parameter        Profile10_ENABLED = 0,
                parameter        Profile11_ENABLED = 0,
                parameter        Profile12_ENABLED = 0,
                parameter        Profile13_ENABLED = 0,
                parameter        Profile14_ENABLED = 0,
                parameter        Profile15_ENABLED = 0,
                parameter        Profile16_ENABLED = 0,
                parameter        Profile17_ENABLED = 0,
                parameter        Profile18_ENABLED = 0,
                parameter        Profile19_ENABLED = 0,
                parameter        Profile20_ENABLED = 0,
                parameter        Profile21_ENABLED = 0,
                parameter        Profile22_ENABLED = 0,
                parameter        Profile23_ENABLED = 0,
                parameter        Profile24_ENABLED = 0,
                parameter        Profile25_ENABLED = 0,
                parameter        Profile26_ENABLED = 0,
                parameter        Profile27_ENABLED = 0,
                parameter        Profile28_ENABLED = 0,
                parameter        Profile29_ENABLED = 0,
                parameter        Profile30_ENABLED = 0,
                parameter        Profile31_ENABLED = 0,
                parameter        Profile32_ENABLED = 0,
				
                parameter        prof0_pma_data_rate = "",
                parameter        prof1_pma_data_rate = "",
                parameter        prof2_pma_data_rate = "",
                parameter        prof3_pma_data_rate = "",
                parameter        prof4_pma_data_rate = "",
                parameter        prof5_pma_data_rate = "",
                parameter        prof6_pma_data_rate = "",
                parameter        prof7_pma_data_rate = "",
                parameter        prof8_pma_data_rate = "",
                parameter        prof9_pma_data_rate = "",
                parameter        prof10_pma_data_rate = "",
                parameter        prof11_pma_data_rate = "",
                parameter        prof12_pma_data_rate = "",
                parameter        prof13_pma_data_rate = "",
                parameter        prof14_pma_data_rate = "",
                parameter        prof15_pma_data_rate = "",
                parameter        prof16_pma_data_rate = "",
                parameter        prof17_pma_data_rate = "",
                parameter        prof18_pma_data_rate = "",
                parameter        prof19_pma_data_rate = "",
                parameter        prof20_pma_data_rate = "",
                parameter        prof21_pma_data_rate = "",
                parameter        prof22_pma_data_rate = "",
                parameter        prof23_pma_data_rate = "",
                parameter        prof24_pma_data_rate = "",
                parameter        prof25_pma_data_rate = "",
                parameter        prof26_pma_data_rate = "",
                parameter        prof27_pma_data_rate = "",
                parameter        prof28_pma_data_rate = "",
                parameter        prof29_pma_data_rate = "",
                parameter        prof30_pma_data_rate = "",
                parameter        prof31_pma_data_rate = "",
                parameter        prof32_pma_data_rate = "", 
				
                parameter        prof0_pma_modulation = "",
                parameter        prof1_pma_modulation = "",
                parameter        prof2_pma_modulation = "",
                parameter        prof3_pma_modulation = "",
                parameter        prof4_pma_modulation = "",
                parameter        prof5_pma_modulation = "",
                parameter        prof6_pma_modulation = "",
                parameter        prof7_pma_modulation = "",
                parameter        prof8_pma_modulation = "",
                parameter        prof9_pma_modulation = "",
                parameter        prof10_pma_modulation = "",
                parameter        prof11_pma_modulation = "",
                parameter        prof12_pma_modulation = "",
                parameter        prof13_pma_modulation = "",
                parameter        prof14_pma_modulation = "",
                parameter        prof15_pma_modulation = "",
                parameter        prof16_pma_modulation = "",
                parameter        prof17_pma_modulation = "",
                parameter        prof18_pma_modulation = "",
                parameter        prof19_pma_modulation = "",
                parameter        prof20_pma_modulation = "",
                parameter        prof21_pma_modulation = "",
                parameter        prof22_pma_modulation = "",
                parameter        prof23_pma_modulation = "",
                parameter        prof24_pma_modulation = "",
                parameter        prof25_pma_modulation = "",
                parameter        prof26_pma_modulation = "",
                parameter        prof27_pma_modulation = "",
                parameter        prof28_pma_modulation = "",
                parameter        prof29_pma_modulation = "",
                parameter        prof30_pma_modulation = "",
                parameter        prof31_pma_modulation = "",
                parameter        prof32_pma_modulation = "", 				

                parameter        profile_group_id_prof0  = 0,
                parameter        profile_group_id_prof1  = 0,
                parameter        profile_group_id_prof2  = 0,
                parameter        profile_group_id_prof3  = 0,
                parameter        profile_group_id_prof4  = 0,
                parameter        profile_group_id_prof5  = 0,
                parameter        profile_group_id_prof6  = 0,
                parameter        profile_group_id_prof7  = 0,
                parameter        profile_group_id_prof8  = 0,
                parameter        profile_group_id_prof9  = 0,
                parameter        profile_group_id_prof10 = 0,
                parameter        profile_group_id_prof11 = 0,
                parameter        profile_group_id_prof12 = 0,
                parameter        profile_group_id_prof13 = 0,
                parameter        profile_group_id_prof14 = 0,
                parameter        profile_group_id_prof15 = 0,
                parameter        profile_group_id_prof16 = 0,
                parameter        profile_group_id_prof17 = 0,
                parameter        profile_group_id_prof18 = 0,
                parameter        profile_group_id_prof19 = 0,
                parameter        profile_group_id_prof20 = 0,
                parameter        profile_group_id_prof21 = 0,
                parameter        profile_group_id_prof22 = 0,
                parameter        profile_group_id_prof23 = 0,
                parameter        profile_group_id_prof24 = 0,
                parameter        profile_group_id_prof25 = 0,
                parameter        profile_group_id_prof26 = 0,
                parameter        profile_group_id_prof27 = 0,
                parameter        profile_group_id_prof28 = 0,
                parameter        profile_group_id_prof29 = 0,
                parameter        profile_group_id_prof30 = 0,
                parameter        profile_group_id_prof31 = 0,
                parameter        profile_group_id_prof32 = 0, 
				
                parameter        prof0_num_xcvr  = 0,
                parameter        prof1_num_xcvr  = 0,
                parameter        prof2_num_xcvr  = 0,
                parameter        prof3_num_xcvr  = 0,
                parameter        prof4_num_xcvr  = 0,
                parameter        prof5_num_xcvr  = 0,
                parameter        prof6_num_xcvr  = 0,
                parameter        prof7_num_xcvr  = 0,
                parameter        prof8_num_xcvr  = 0,
                parameter        prof9_num_xcvr  = 0,
                parameter        prof10_num_xcvr = 0,
                parameter        prof11_num_xcvr = 0,
                parameter        prof12_num_xcvr = 0,
                parameter        prof13_num_xcvr = 0,
                parameter        prof14_num_xcvr = 0,
                parameter        prof15_num_xcvr = 0,
                parameter        prof16_num_xcvr = 0,
                parameter        prof17_num_xcvr = 0,
                parameter        prof18_num_xcvr = 0,
                parameter        prof19_num_xcvr = 0,
                parameter        prof20_num_xcvr = 0,
                parameter        prof21_num_xcvr = 0,
                parameter        prof22_num_xcvr = 0,
                parameter        prof23_num_xcvr = 0,
                parameter        prof24_num_xcvr = 0,
                parameter        prof25_num_xcvr = 0,
                parameter        prof26_num_xcvr = 0,
                parameter        prof27_num_xcvr = 0,
                parameter        prof28_num_xcvr = 0,
                parameter        prof29_num_xcvr = 0,
                parameter        prof30_num_xcvr = 0,
                parameter        prof31_num_xcvr = 0,
                parameter        prof32_num_xcvr = 0, 
				
                parameter        pma_trgt_4profile_Prof0   = "",
                parameter        pma_trgt_4profile_Prof1   = "",
                parameter        pma_trgt_4profile_Prof2   = "",
                parameter        pma_trgt_4profile_Prof3   = "",
                parameter        pma_trgt_4profile_Prof4   = "",
                parameter        pma_trgt_4profile_Prof5   = "",
                parameter        pma_trgt_4profile_Prof6   = "",
                parameter        pma_trgt_4profile_Prof7   = "",
                parameter        pma_trgt_4profile_Prof8   = "",
                parameter        pma_trgt_4profile_Prof9   = "",
                parameter        pma_trgt_4profile_Prof10  = "",
                parameter        pma_trgt_4profile_Prof11  = "",
                parameter        pma_trgt_4profile_Prof12  = "",
                parameter        pma_trgt_4profile_Prof13  = "",
                parameter        pma_trgt_4profile_Prof14  = "",
                parameter        pma_trgt_4profile_Prof15  = "",
                parameter        pma_trgt_4profile_Prof16  = "",
                parameter        pma_trgt_4profile_Prof17  = "",
                parameter        pma_trgt_4profile_Prof18  = "",
                parameter        pma_trgt_4profile_Prof19  = "",
                parameter        pma_trgt_4profile_Prof20  = "",
                parameter        pma_trgt_4profile_Prof21  = "",
                parameter        pma_trgt_4profile_Prof22  = "",
                parameter        pma_trgt_4profile_Prof23  = "",
                parameter        pma_trgt_4profile_Prof24  = "",
                parameter        pma_trgt_4profile_Prof25  = "",
                parameter        pma_trgt_4profile_Prof26  = "",
                parameter        pma_trgt_4profile_Prof27  = "",
                parameter        pma_trgt_4profile_Prof28  = "",
                parameter        pma_trgt_4profile_Prof29  = "",
                parameter        pma_trgt_4profile_Prof30  = "",
                parameter        pma_trgt_4profile_Prof31  = "",
                parameter        pma_trgt_4profile_Prof32  = "", 	

                parameter        rcfg_subset_Prof0    = "",
                parameter        rcfg_subset_Prof1    = "",
                parameter        rcfg_subset_Prof2    = "",
                parameter        rcfg_subset_Prof3    = "",
                parameter        rcfg_subset_Prof4    = "",
                parameter        rcfg_subset_Prof5    = "",
                parameter        rcfg_subset_Prof6    = "",
                parameter        rcfg_subset_Prof7    = "",
                parameter        rcfg_subset_Prof8    = "",
                parameter        rcfg_subset_Prof9    = "",
                parameter        rcfg_subset_Prof10   = "",
                parameter        rcfg_subset_Prof11   = "",
                parameter        rcfg_subset_Prof12   = "",
                parameter        rcfg_subset_Prof13   = "",
                parameter        rcfg_subset_Prof14   = "",
                parameter        rcfg_subset_Prof15   = "",
                parameter        rcfg_subset_Prof16   = "",
                parameter        rcfg_subset_Prof17   = "",
                parameter        rcfg_subset_Prof18   = "",
                parameter        rcfg_subset_Prof19   = "",
                parameter        rcfg_subset_Prof20   = "",
                parameter        rcfg_subset_Prof21   = "",
                parameter        rcfg_subset_Prof22   = "",
                parameter        rcfg_subset_Prof23   = "",
                parameter        rcfg_subset_Prof24   = "",
                parameter        rcfg_subset_Prof25   = "",
                parameter        rcfg_subset_Prof26   = "",
                parameter        rcfg_subset_Prof27   = "",
                parameter        rcfg_subset_Prof28   = "",
                parameter        rcfg_subset_Prof29   = "",
                parameter        rcfg_subset_Prof30   = "",
                parameter        rcfg_subset_Prof31   = "",
                parameter        rcfg_subset_Prof32   = "", 

                parameter        Use_profile_startup_Prof0    = 0,
                parameter        Use_profile_startup_Prof1    = 0,
                parameter        Use_profile_startup_Prof2    = 0,
                parameter        Use_profile_startup_Prof3    = 0,
                parameter        Use_profile_startup_Prof4    = 0,
                parameter        Use_profile_startup_Prof5    = 0,
                parameter        Use_profile_startup_Prof6    = 0,
                parameter        Use_profile_startup_Prof7    = 0,
                parameter        Use_profile_startup_Prof8    = 0,
                parameter        Use_profile_startup_Prof9    = 0,
                parameter        Use_profile_startup_Prof10   = 0,
                parameter        Use_profile_startup_Prof11   = 0,
                parameter        Use_profile_startup_Prof12   = 0,
                parameter        Use_profile_startup_Prof13   = 0,
                parameter        Use_profile_startup_Prof14   = 0,
                parameter        Use_profile_startup_Prof15   = 0,
                parameter        Use_profile_startup_Prof16   = 0,
                parameter        Use_profile_startup_Prof17   = 0,
                parameter        Use_profile_startup_Prof18   = 0,
                parameter        Use_profile_startup_Prof19   = 0,
                parameter        Use_profile_startup_Prof20   = 0,
                parameter        Use_profile_startup_Prof21   = 0,
                parameter        Use_profile_startup_Prof22   = 0,
                parameter        Use_profile_startup_Prof23   = 0,
                parameter        Use_profile_startup_Prof24   = 0,
                parameter        Use_profile_startup_Prof25   = 0,
                parameter        Use_profile_startup_Prof26   = 0,
                parameter        Use_profile_startup_Prof27   = 0,
                parameter        Use_profile_startup_Prof28   = 0,
                parameter        Use_profile_startup_Prof29   = 0,
                parameter        Use_profile_startup_Prof30   = 0,
                parameter        Use_profile_startup_Prof31   = 0,
                parameter        Use_profile_startup_Prof32   = 0,	
			
				
                parameter ip_name    = "",
                parameter DATA_WIDTH = 32
	) (

		input  wire                         avmm1_clk_user,             
		input  wire                         avmm1_reset_user,           
		input  wire [avmm1_addr_width-1:0]  avmm1_address_user,         
		input  wire [DATA_WIDTH/8-1:0]      avmm1_byte_enable_user,     
		input  wire                         avmm1_write_user,           
		input  wire                         avmm1_read_user,            
		input  wire [DATA_WIDTH-1:0]        avmm1_write_data_user,      
		output wire [DATA_WIDTH-1:0]        avmm1_read_data_user,       
		output wire                         avmm1_waitrequest_user,     
		output wire                         avmm1_read_data_valid_user, 

		output wire                         avmm1_clk_tile,             
		output wire                         avmm1_reset_tile,           
		output wire [avmm1_addr_width-1:0]  avmm1_address_tile,         
		output wire [DATA_WIDTH/8-1:0]      avmm1_byte_enable_tile,     
		output wire                         avmm1_write_tile,           
		output wire                         avmm1_read_tile,            
		output wire [DATA_WIDTH-1:0]        avmm1_write_data_tile,      
		input  wire [DATA_WIDTH-1:0]        avmm1_read_data_tile,       
		input  wire                         avmm1_waitrequest_tile,     
		input  wire                         avmm1_read_data_valid_tile,  


		input  wire                         avmm2_clk_user,             
		input  wire                         avmm2_reset_user,           
		input  wire [avmm2_addr_width-1:0]  avmm2_address_user,         
		input  wire [DATA_WIDTH/8-1:0]      avmm2_byte_enable_user,     
		input  wire                         avmm2_write_user,           
		input  wire                         avmm2_read_user,            
		input  wire [DATA_WIDTH-1:0]        avmm2_write_data_user,      
		output wire [DATA_WIDTH-1:0]        avmm2_read_data_user,       
		output wire                         avmm2_waitrequest_user,     
		output wire                         avmm2_read_data_valid_user, 

		output wire                         avmm2_clk_tile,             
		output wire                         avmm2_reset_tile,           
		output wire [avmm2_addr_width-1:0]  avmm2_address_tile,         
		output wire [DATA_WIDTH/8-1:0]      avmm2_byte_enable_tile,     
		output wire                         avmm2_write_tile,           
		output wire                         avmm2_read_tile,            
		output wire [DATA_WIDTH-1:0]        avmm2_write_data_tile,      
		input  wire [DATA_WIDTH-1:0]        avmm2_read_data_tile,       
		input  wire                         avmm2_waitrequest_tile,     
		input  wire                         avmm2_read_data_valid_tile

	);

// Pass-through's: (also fanned in to JTAG ADME)
   assign  avmm1_reset_tile = avmm1_reset_user;
   assign  avmm2_reset_tile = avmm2_reset_user;

   assign  avmm1_clk_tile = avmm1_clk_user;
   assign  avmm2_clk_tile = avmm2_clk_user;

   assign  avmm1_read_data_user = avmm1_read_data_tile;
   assign  avmm2_read_data_user = avmm2_read_data_tile;



// AVMM1:
   if (avmm1_is_used) begin: ftile_adme1

            // Raw JTAG signals
            wire [avmm1_addr_width-1:0]              jtag_address;
            wire [DATA_WIDTH/8-1:0]                  jtag_byteenable;
            wire [DATA_WIDTH-1:0]                    jtag_writedata;
            wire [DATA_WIDTH-1:0]                    jtag_readdata;
            wire                                     jtag_waitrequest;
	    wire                                     jtag_readdatavalid;

            wire                                     jtag_write;
            wire                                     jtag_read;
            wire                                     jtag_read_write;
            wire                                     user_read_write;

	    assign  jtag_read_write =       jtag_read | jtag_write;
	    assign  user_read_write = avmm1_read_user | avmm1_write_user;
	    assign  jtag_byteenable = {(DATA_WIDTH/8){1'b1}};
	    assign  jtag_readdata   = avmm1_read_data_tile;


            // When doing RTL sims, remove the altera_debug_master_endpoint, as 
            // there is no RTL simulation model.  Pre and Post Fit sims are ok.
            `ifdef ALTERA_RESERVED_QIS


              altera_debug_master_endpoint
              #(
                .ADDR_WIDTH                            ( avmm1_addr_width ),
                .DATA_WIDTH                            ( DATA_WIDTH                    ),
                .HAS_RDV                               ( avmm1_has_rdv                 ),
                .SLAVE_MAP                             ( avmm1_slave_map               ),
                .PREFER_HOST                           ( " "                           ),
                .CLOCK_RATE_CLK                        ( 0                             )
              ) adme (
                .clk                                   ( avmm1_clk_user                ),
                .reset                                 ( avmm1_reset_user              ),
                .master_write                          ( jtag_write                    ),
                .master_read                           ( jtag_read                     ),
                .master_address                        ( jtag_address                  ),
                .master_writedata                      ( jtag_writedata                ),
                .master_waitrequest                    ( jtag_waitrequest              ),
                .master_readdatavalid                  ( jtag_readdatavalid            ),  // 1'b0 before.  Why?
                .master_readdata                       ( jtag_readdata                 )
              );
            `else
               // Simulation: no ADME activity 
              assign jtag_write                         = 1'b0;
              assign jtag_read                          = 1'b0;
              assign jtag_address                       = {avmm1_addr_width{1'b0}};
                  // jtag_byteenable: always 0
              assign jtag_writedata                     = {DATA_WIDTH{1'b0}};
            `endif


	    // arbiter 
            alt_xcvr_avmm_arb #(
              .TOTAL_MASTERS (2),
              .CHANNELS ( 1 ),
              .ADDRESS_WIDTH (avmm1_addr_width),
              .DATA_WIDTH  (DATA_WIDTH)
            ) 
            avmm1_adme_arb_inst (
              .ini_clk           ( avmm1_clk_user   ),
              .ini_reset         ( avmm1_reset_user ),
                       
              .ini_read          ( {jtag_read,          avmm1_read_user            } ),
              .ini_write         ( {jtag_write,         avmm1_write_user           } ),
              .ini_address       ( {jtag_address,       avmm1_address_user         } ),
              .ini_byteenable    ( {jtag_byteenable,    avmm1_byte_enable_user     } ),
              .ini_writedata     ( {jtag_writedata,     avmm1_write_data_user      } ),
              .ini_read_write    ( {jtag_read_write,    user_read_write            } ),
              .ini_waitrequest   ( {jtag_waitrequest,   avmm1_waitrequest_user     } ),
              .ini_readdatavalid ( {jtag_readdatavalid, avmm1_read_data_valid_user } ),

              .avmm_waitrequest  ( avmm1_waitrequest_tile     ),
	      .avmm_readdatavalid( avmm1_read_data_valid_tile ),
              .avmm_read         ( avmm1_read_tile            ),
              .avmm_write        ( avmm1_write_tile           ),
              .avmm_address      ( avmm1_address_tile         ),
              .avmm_byteenable   ( avmm1_byte_enable_tile     ),
              .avmm_writedata    ( avmm1_write_data_tile      )
	    );
        end   
   else begin: no_adme1 
             assign         avmm1_address_tile = avmm1_address_user;
             assign     avmm1_byte_enable_tile = avmm1_byte_enable_user;
             assign           avmm1_write_tile = avmm1_write_user;
             assign            avmm1_read_tile = avmm1_read_user;
             assign      avmm1_write_data_tile = avmm1_write_data_user;

             assign     avmm1_waitrequest_user = avmm1_waitrequest_tile;
	     assign avmm1_read_data_valid_user = avmm1_read_data_valid_tile;
   end 



// AVMM2:
   if (avmm2_is_used) begin: ftile_adme2

            // Raw JTAG signals
            wire [avmm2_addr_width-1:0]              jtag_address;
            wire [DATA_WIDTH/8-1:0]                  jtag_byteenable;
            wire [DATA_WIDTH-1:0]                    jtag_writedata;
            wire [DATA_WIDTH-1:0]                    jtag_readdata;
            wire                                     jtag_waitrequest;
	    wire                                     jtag_readdatavalid;

            wire                                     jtag_write;
            wire                                     jtag_read;
            wire                                     jtag_read_write;
            wire                                     user_read_write;

	    assign  jtag_read_write =       jtag_read | jtag_write;
	    assign  user_read_write = avmm2_read_user | avmm2_write_user;
	    assign  jtag_byteenable = {(DATA_WIDTH/8){1'b1}};
	    assign  jtag_readdata   = avmm2_read_data_tile;

            // When doing RTL sims, remove the altera_debug_master_endpoint, as 
            // there is no RTL simulation model.  Pre and Post Fit sims are ok.
            `ifdef ALTERA_RESERVED_QIS

              altera_debug_master_endpoint
              #(
                .ADDR_WIDTH                            ( avmm2_addr_width ),
                .DATA_WIDTH                            ( DATA_WIDTH                    ),
                .HAS_RDV                               ( avmm2_has_rdv                 ),
                .SLAVE_MAP                             ( avmm2_slave_map               ),
                .PREFER_HOST                           ( " "                           ),
                .CLOCK_RATE_CLK                        ( 0                             )
              ) adme (
                .clk                                   ( avmm2_clk_user                ),
                .reset                                 ( avmm2_reset_user              ),
                .master_write                          ( jtag_write                    ),
                .master_read                           ( jtag_read                     ),
                .master_address                        ( jtag_address                  ),
                .master_writedata                      ( jtag_writedata                ),
                .master_waitrequest                    ( jtag_waitrequest              ),
                .master_readdatavalid                  ( jtag_readdatavalid            ),  // 1'b0 before.  Why?
                .master_readdata                       ( jtag_readdata                 )
              );
            `else
              assign jtag_write                         = 1'b0;
              assign jtag_read                          = 1'b0;
              assign jtag_address                       = {avmm2_addr_width{1'b0}};
              assign jtag_writedata                     = {DATA_WIDTH{1'b0}};
            `endif


	    // arbiter 
            alt_xcvr_avmm_arb #(
              .TOTAL_MASTERS (2),
              .CHANNELS ( 1 ),
              .ADDRESS_WIDTH (avmm2_addr_width),
              .DATA_WIDTH  (DATA_WIDTH)
            ) 
            avmm2_adme_arb_inst (
              .ini_clk           ( avmm2_clk_user   ),
              .ini_reset         ( avmm2_reset_user ),
                       
              .ini_read          ( {jtag_read,          avmm2_read_user            } ),
              .ini_write         ( {jtag_write,         avmm2_write_user           } ),
              .ini_address       ( {jtag_address,       avmm2_address_user         } ),
              .ini_byteenable    ( {jtag_byteenable,    avmm2_byte_enable_user     } ),
              .ini_writedata     ( {jtag_writedata,     avmm2_write_data_user      } ),
              .ini_read_write    ( {jtag_read_write,    user_read_write            } ),
              .ini_waitrequest   ( {jtag_waitrequest,   avmm2_waitrequest_user     } ),
              .ini_readdatavalid ( {jtag_readdatavalid, avmm2_read_data_valid_user } ),

              .avmm_waitrequest  ( avmm2_waitrequest_tile     ),
	      .avmm_readdatavalid( avmm2_read_data_valid_tile ),
              .avmm_read         ( avmm2_read_tile            ),
              .avmm_write        ( avmm2_write_tile           ),
              .avmm_address      ( avmm2_address_tile         ),
              .avmm_byteenable   ( avmm2_byte_enable_tile     ),
              .avmm_writedata    ( avmm2_write_data_tile      )
	    );
        end   
   else begin: no_adme2 
             assign         avmm2_address_tile = avmm2_address_user;
             assign     avmm2_byte_enable_tile = avmm2_byte_enable_user;
             assign           avmm2_write_tile = avmm2_write_user;
             assign            avmm2_read_tile = avmm2_read_user;
             assign      avmm2_write_data_tile = avmm2_write_data_user;

             assign     avmm2_waitrequest_user = avmm2_waitrequest_tile;
	     assign avmm2_read_data_valid_user = avmm2_read_data_valid_tile;
   end 

endmodule

