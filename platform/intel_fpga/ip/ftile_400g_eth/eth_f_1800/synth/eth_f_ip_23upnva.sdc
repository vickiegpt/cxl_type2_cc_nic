# (C) 2001-2025 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


## SDC ##

set dir_name [file dirname [info script]] 
set module_name ftile_400g_eth_eth_f_1800_23upnva


## get current IP instance 
set ip_inst_name [get_current_instance]


## set global variables
global ::ip_sdc_debug


set ip_sdc_debug 0


## Set parameters based on IP configuration


set syspll_outclk_freq_mhz 830.078125
set tx_clk1_dcm_mhz 415.0390625
set rx_clk1_dcm_mhz 415.0390625
set tx_user_clk_mhz 390.625
set rx_user_clk_mhz 390.625




## to limit number of decimal points


set tx_clk1_dcm_mhz [expr double (round(10000*$tx_clk1_dcm_mhz))/10000.0]
set rx_clk1_dcm_mhz [expr double (round(10000*$rx_clk1_dcm_mhz))/10000.0]
set tx_user_clk_mhz [expr double (round(10000*$tx_user_clk_mhz))/10000.0]
set rx_user_clk_mhz [expr double (round(10000*$rx_user_clk_mhz))/10000.0]

## No clocking mode, parallel frequency always syspll frequency; no pma_outclk frequency for ethernet
set tx_parallel_freq   [expr double (round(10000*$syspll_outclk_freq_mhz))/10000.0]
set rx_parallel_freq  [expr double (round(10000*$syspll_outclk_freq_mhz))/10000.0]

set tx_pma_aib_freq $tx_parallel_freq
set rx_transfer_freq $rx_parallel_freq
 
set tx_pld_pcs_freq $tx_clk1_dcm_mhz

set rx_pld_pcs_freq $rx_clk1_dcm_mhz







## Bunch of dphy params not included


# ----------------------------------------------------------------------------- #
# --- Print out the IP parameters when debug is enabled                     --- #
# ----------------------------------------------------------------------------- #
  if {$ip_sdc_debug == 1} {
    post_message -type info "IP SDC: The TX pma parallel frequency is $tx_parallel_freq"
    post_message -type info "IP SDC: The RX pma parallel frequency is $rx_parallel_freq"
  }

# ----------------------------------------------------------------------------- #
# --- Print out the frequency of base clocks when debug is enabled          --- #
# ----------------------------------------------------------------------------- #
  if {$ip_sdc_debug == 1} {
    post_message -type info "IP SDC: The TX pld pcs frequency $tx_pld_pcs_freq"
    post_message -type info "IP SDC: The RX pld pcs frequency $rx_pld_pcs_freq"
  }

## create new dictionary 
set active_chnl_nodes [dict create]
set active_chnl_clks [dict create]
set active_chnl_clks_names [dict create]
set active_chnl_clks_freq [dict create]
set active_chnl_multiply_by_factors [dict create]
set active_chnl_divide_by_factors [dict create]


## set frequency for base clocks
dict set active_chnl_clks_freq tx_pld_pcs_clk_ref $tx_pld_pcs_freq
dict set active_chnl_clks_freq rx_pld_pcs_clk_ref $rx_pld_pcs_freq
dict set active_chnl_clks_freq tx_pma_aib_clk_ref $tx_pma_aib_freq
dict set active_chnl_clks_freq rx_transfer_clk_ref $rx_transfer_freq

 ## TO BE Determined ######??????#######???????###### 
 ## User base clocks frequency ## 

 dict set active_chnl_clks_freq tx_user_clk_ref $tx_user_clk_mhz 
 dict set active_chnl_clks_freq rx_user_clk_ref $rx_user_clk_mhz

 dict set active_chnl_clks_freq pld_pma_hclk_ref 100 


## set multiple_by and divide_by for generated clocks
## set multiple_by and divide_by for generated clocks
 dict set active_chnl_multiply_by_factors     tx_pld_pcs_clk_reg    1
 dict set active_chnl_divide_by_factors       tx_pld_pcs_clk_reg    1
 
 dict set active_chnl_multiply_by_factors     rx_pld_pcs_clk_reg    1
 dict set active_chnl_divide_by_factors       rx_pld_pcs_clk_reg    1
 
 dict set active_chnl_multiply_by_factors     tx_pma_aib_clk_reg    1
 dict set active_chnl_divide_by_factors       tx_pma_aib_clk_reg    1
 
 dict set active_chnl_multiply_by_factors     rx_transfer_clk_reg    1
 dict set active_chnl_divide_by_factors       rx_transfer_clk_reg    1
 
 dict set active_chnl_multiply_by_factors     tx_user_clk_reg    1
 dict set active_chnl_divide_by_factors       tx_user_clk_reg    1
 
 dict set active_chnl_multiply_by_factors     rx_user_clk_reg    1
 dict set active_chnl_divide_by_factors       rx_user_clk_reg    1
 
 dict set active_chnl_multiply_by_factors     pld_pma_hclk_reg    1
 dict set active_chnl_divide_by_factors       pld_pma_hclk_reg    1

dict set active_chnl_multiply_by_factors     tx_clkout    1
dict set active_chnl_divide_by_factors       tx_clkout    1

dict set active_chnl_multiply_by_factors     rx_clkout    1
dict set active_chnl_divide_by_factors       rx_clkout    1

dict set active_chnl_multiply_by_factors     tx_clkout2    1
dict set active_chnl_divide_by_factors       tx_clkout2    1

dict set active_chnl_multiply_by_factors     rx_clkout2    1
dict set active_chnl_divide_by_factors       rx_clkout2    1
 
## find active clocks for tx_div_clk 
set dummy_tx_div_clk_ff_in_sip [get_nodes $ip_inst_name|sip_inst|dummy_out_for_tx_div_clk_timing*|clk]
 
if {[get_collection_size $dummy_tx_div_clk_ff_in_sip] > 0} {
    foreach_in_collection dummy_tx_div_clk_ff_in_sip_node $dummy_tx_div_clk_ff_in_sip {
          set dummy_tx_div_clk_ff_in_sip_node_name [get_node_info -name $dummy_tx_div_clk_ff_in_sip_node]
          set dummy_tx_div_clk_ff_in_sip_fanin [get_fanins $dummy_tx_div_clk_ff_in_sip_node_name]
          ## get dummy ff fanin node name 
          set dummy_tx_div_clk_ff_in_sip_fanin_node_name [get_node_info -name $dummy_tx_div_clk_ff_in_sip_fanin]
		  
          ## find active channel numbers 
          ## get index for ".reg"
          set reg_index [string last .reg $dummy_tx_div_clk_ff_in_sip_fanin_node_name] 
    
          # get active chnl number according to it's single bit or two bits, index-2 is digit means two bits(10~23), otherwise it's single bit(0~9) 
          if { [string is digit [string index $dummy_tx_div_clk_ff_in_sip_fanin_node_name $reg_index-2]] } {
              set chnl [string range $dummy_tx_div_clk_ff_in_sip_fanin_node_name $reg_index-2 $reg_index-1]
          } else {
              set chnl [string index $dummy_tx_div_clk_ff_in_sip_fanin_node_name $reg_index-1]
          }
 
		# get instance name of top__tiles in tile part 
          set top_tile_index [string last ~aib_hssi $dummy_tx_div_clk_ff_in_sip_fanin_node_name] 
          set top_tile_inst_name [string range $dummy_tx_div_clk_ff_in_sip_fanin_node_name 0 $top_tile_index]
          # get instance name of top__tiles in fabric part
          set top_fab_index [string last | $dummy_tx_div_clk_ff_in_sip_fanin_node_name]
          set top_fab_inst_name [string range $dummy_tx_div_clk_ff_in_sip_fanin_node_name 0 $top_fab_index]
 
         
          set rx_pld_pcs_ref_nodes_col aib_hssi_pld_pma_clkdiv_rx_user_ch${chnl}_ref
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$rx_pld_pcs_ref_nodes_col]] > 0} {
              dict lappend active_chnl_clks rx_pld_pcs_clk_ref [get_node_info -name $top_tile_inst_name$rx_pld_pcs_ref_nodes_col]
              ## sorting 
              dict set active_chnl_clks rx_pld_pcs_clk_ref [lsort -dictionary [dict get $active_chnl_clks rx_pld_pcs_clk_ref]]
              if {$ip_sdc_debug == 1} {
               post_message -type info "IP SDC: RX pld pcs clk ref node info: [dict get $active_chnl_clks rx_pld_pcs_clk_ref]"
              }
          }
		  
          set rx_pld_pcs_reg_nodes_col aib_hssi_pld_pma_clkdiv_rx_user_ch${chnl}.reg
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$rx_pld_pcs_reg_nodes_col]] > 0} {
             dict lappend active_chnl_clks rx_pld_pcs_clk_reg [get_node_info -name $top_tile_inst_name$rx_pld_pcs_reg_nodes_col] 
             ## sorting
             dict set active_chnl_clks rx_pld_pcs_clk_reg [lsort -dictionary [dict get $active_chnl_clks rx_pld_pcs_clk_reg]]
             if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: RX pld pcs clk reg node info: [dict get $active_chnl_clks rx_pld_pcs_clk_reg]"
             }
          }
 
          set tx_user_ref_nodes_col aib_hssi_pld_pma_clkdiv_tx_user_ch${chnl}_ref
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$tx_user_ref_nodes_col]] > 0} {
            dict lappend active_chnl_clks tx_user_clk_ref [get_node_info -name $top_tile_inst_name$tx_user_ref_nodes_col]
            ## sorting
            dict set active_chnl_clks tx_user_clk_ref [lsort -dictionary [dict get $active_chnl_clks tx_user_clk_ref]]
            if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: TX user clk ref node info: [dict get $active_chnl_clks tx_user_clk_ref]"
            }
          }
 
          set tx_user_reg_nodes_col aib_hssi_pld_pma_clkdiv_tx_user_ch${chnl}.reg
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$tx_user_reg_nodes_col]] > 0} {
            dict lappend active_chnl_clks tx_user_clk_reg [get_node_info -name $top_tile_inst_name$tx_user_reg_nodes_col]
            ## sorting
            dict set active_chnl_clks tx_user_clk_reg [lsort -dictionary [dict get $active_chnl_clks tx_user_clk_reg]]
            if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: TX user clk reg node info: [dict get $active_chnl_clks tx_user_clk_reg]"
            }
          }
 
          set rx_user_ref_nodes_col aib_hssi_pld_pcs_rx_clk_out_ch${chnl}_ref
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$rx_user_ref_nodes_col]] > 0} {
            dict lappend active_chnl_clks rx_user_clk_ref [get_node_info -name $top_tile_inst_name$rx_user_ref_nodes_col]
            ## sorting
            dict set active_chnl_clks rx_user_clk_ref [lsort -dictionary [dict get $active_chnl_clks rx_user_clk_ref]]
            if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: RX user clk ref node info: [dict get $active_chnl_clks rx_user_clk_ref]"
            }
          }
 
          set rx_user_reg_nodes_col aib_hssi_pld_pcs_rx_clk_out_ch${chnl}.reg
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$rx_user_reg_nodes_col]] > 0} {
            dict lappend active_chnl_clks rx_user_clk_reg [get_node_info -name $top_tile_inst_name$rx_user_reg_nodes_col]
            ## sorting
            dict set active_chnl_clks rx_user_clk_reg [lsort -dictionary [dict get $active_chnl_clks rx_user_clk_reg]]
            if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: RX user clk reg node info: [dict get $active_chnl_clks rx_user_clk_reg]"
            }
          }
 
          set rx_pld_pcs_out1_dcm_nodes_col hdpldadapt_rx_chnl_${chnl}|pld_pcs_rx_clk_out2_dcm  
          if {[get_collection_size [get_nodes -nowarn $top_fab_inst_name$rx_pld_pcs_out1_dcm_nodes_col]] > 0} {
              dict lappend active_chnl_clks rx_clkout [get_node_info -name $top_fab_inst_name$rx_pld_pcs_out1_dcm_nodes_col]
             ## sorting
             dict set active_chnl_clks rx_clkout [lsort -dictionary [dict get $active_chnl_clks rx_clkout]]
             if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: PLD PCS RX OUT1 DCM CLK node info: [dict get $active_chnl_clks rx_clkout]"
             }
          } 
 
          set tx_pld_pcs_out2_dcm_nodes_col hdpldadapt_tx_chnl_${chnl}|pld_pcs_tx_clk_out2_dcm 
          if {[get_collection_size [get_nodes -nowarn $top_fab_inst_name$tx_pld_pcs_out2_dcm_nodes_col]] > 0} {
             dict lappend active_chnl_clks tx_clkout2 [get_node_info -name $top_fab_inst_name$tx_pld_pcs_out2_dcm_nodes_col]
            ## sorting
             dict set active_chnl_clks tx_clkout2 [lsort -dictionary [dict get $active_chnl_clks tx_clkout2]]
             if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: PLD PCS TX OUT2 DCM CLK node info: [dict get $active_chnl_clks tx_clkout2]"
             }
          } 
 
          set rx_pld_pcs_out2_dcm_nodes_col hdpldadapt_rx_chnl_${chnl}|pld_pcs_rx_clk_out1_dcm  
          if {[get_collection_size [get_nodes -nowarn $top_fab_inst_name$rx_pld_pcs_out2_dcm_nodes_col]] > 0} {
            dict lappend active_chnl_clks rx_clkout2 [get_node_info -name $top_fab_inst_name$rx_pld_pcs_out2_dcm_nodes_col]
            ## sorting
            dict set active_chnl_clks rx_clkout2 [lsort -dictionary [dict get $active_chnl_clks rx_clkout2]]
            if {$ip_sdc_debug == 1} {
               post_message -type info "IP SDC: PLD PCS RX OUT2 DCM CLK node info: [dict get $active_chnl_clks rx_clkout2]"
            }
          }
     }; # end of foreach_in_collection dummy ff
} else {
   if {$ip_sdc_debug == 1} {
      post_message -type info "IP SDC: Could not find active CLKOUT ports for user facing clocks"
   }
 
}
 
 
## find active clocks through tx_clkout
set dummy_ff_in_sip [get_nodes $ip_inst_name|sip_inst|dummy_out_for_timing*|clk]

 ## find active channels through tx_clkout
 if {[get_collection_size $dummy_ff_in_sip] > 0} {
    foreach_in_collection dummy_ff_in_sip_node $dummy_ff_in_sip {
          set dummy_ff_in_sip_node_name [get_node_info -name $dummy_ff_in_sip_node]
          set dummy_ff_in_sip_fanin [get_fanins $dummy_ff_in_sip_node_name]
          ## get dummy ff fanin node name 
          set dummy_ff_in_sip_fanin_node_name [get_node_info -name $dummy_ff_in_sip_fanin]
          
          ## find active channel numbers 
          ## get index for ".reg"
          set reg_index [string last .reg $dummy_ff_in_sip_fanin_node_name] 
    
          # get active chnl number according to it's single bit or two bits, index-2 is digit means two bits(10~23), otherwise it's single bit(0~9) 
          if { [string is digit [string index $dummy_ff_in_sip_fanin_node_name $reg_index-2]] } {
              set chnl [string range $dummy_ff_in_sip_fanin_node_name $reg_index-2 $reg_index-1]
          } else {
              set chnl [string index $dummy_ff_in_sip_fanin_node_name $reg_index-1]
          }

          # get instance name of top__tiles in tile part 
          set top_tile_index [string last ~aib_hssi $dummy_ff_in_sip_fanin_node_name] 
          set top_tile_inst_name [string range $dummy_ff_in_sip_fanin_node_name 0 $top_tile_index]
          # get instance name of top__tiles in fabric part
          set top_fab_index [string last | $dummy_ff_in_sip_fanin_node_name]
          set top_fab_inst_name [string range $dummy_ff_in_sip_fanin_node_name 0 $top_fab_index]
          
           if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: instance name of top_tiles in tile part is $top_tile_inst_name"
                post_message -type info "IP SDC: instance name of top_tiles in fab part is $top_fab_inst_name"
             }


            ## set *ref node and *reg node to dictionary
          set tx_pld_pcs_ref_nodes_col aib_hssi_pld_pcs_tx_clk_out_ch${chnl}_ref
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$tx_pld_pcs_ref_nodes_col]] > 0} {
              dict lappend active_chnl_clks tx_pld_pcs_clk_ref [get_node_info -name $top_tile_inst_name$tx_pld_pcs_ref_nodes_col]
              ## sorting 
              dict set active_chnl_clks tx_pld_pcs_clk_ref [lsort -dictionary [dict get $active_chnl_clks tx_pld_pcs_clk_ref]]
              if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: TX pld pcs clk ref node info: [dict get $active_chnl_clks tx_pld_pcs_clk_ref]"
              }
          }

          set tx_pld_pcs_reg_nodes_col aib_hssi_pld_pcs_tx_clk_out_ch${chnl}.reg 
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$tx_pld_pcs_reg_nodes_col]] > 0} {
              dict lappend active_chnl_clks tx_pld_pcs_clk_reg [get_node_info -name $top_tile_inst_name$tx_pld_pcs_reg_nodes_col]
              ## sorting
              dict set active_chnl_clks tx_pld_pcs_clk_reg [lsort -dictionary [dict get $active_chnl_clks tx_pld_pcs_clk_reg]]
              if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: TX pld pcs clk reg node info: [dict get $active_chnl_clks tx_pld_pcs_clk_reg]"
              }
          }
 
          
   
          set tx_pma_aib_ref_nodes_col aib_hssi_pma_aib_tx_clk_ch${chnl}_ref 
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$tx_pma_aib_ref_nodes_col]] > 0} {
             dict lappend active_chnl_clks tx_pma_aib_clk_ref [get_node_info -name $top_tile_inst_name$tx_pma_aib_ref_nodes_col]
             ## sorting 
             dict set active_chnl_clks tx_pma_aib_clk_ref [lsort -dictionary [dict get $active_chnl_clks tx_pma_aib_clk_ref]]
             if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: TX pma aib clk ref node info: [dict get $active_chnl_clks tx_pma_aib_clk_ref]"
             }
          }
   
          set tx_pma_aib_reg_nodes_col aib_hssi_pma_aib_tx_clk_ch${chnl}.reg
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$tx_pma_aib_reg_nodes_col]] > 0} {
             dict lappend active_chnl_clks tx_pma_aib_clk_reg [get_node_info -name $top_tile_inst_name$tx_pma_aib_reg_nodes_col]
            ## sorting
             dict set active_chnl_clks tx_pma_aib_clk_reg [lsort -dictionary [dict get $active_chnl_clks tx_pma_aib_clk_reg]]
             if {$ip_sdc_debug == 1} {
                 post_message -type info "IP SDC: TX pma aib clk reg node info: [dict get $active_chnl_clks tx_pma_aib_clk_reg]"
             }
          }
       
          set rx_transfer_ref_nodes_col aib_hssi_rx_transfer_clk_ch${chnl}_ref
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$rx_transfer_ref_nodes_col]] > 0} {
            dict lappend active_chnl_clks rx_transfer_clk_ref [get_node_info -name $top_tile_inst_name$rx_transfer_ref_nodes_col]
            ## sorting 
            dict set active_chnl_clks rx_transfer_clk_ref [lsort -dictionary [dict get $active_chnl_clks rx_transfer_clk_ref]]
            if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: RX transfer clk ref node info: [dict get $active_chnl_clks rx_transfer_clk_ref]"
            }
          }
   
          set rx_transfer_reg_nodes_col aib_hssi_rx_transfer_clk_ch${chnl}.reg
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$rx_transfer_reg_nodes_col]] > 0} {
            dict lappend active_chnl_clks rx_transfer_clk_reg [get_node_info -name $top_tile_inst_name$rx_transfer_reg_nodes_col]
            ## sorting
            dict set active_chnl_clks rx_transfer_clk_reg [lsort -dictionary [dict get $active_chnl_clks rx_transfer_clk_reg]]
            if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: RX transfer clk reg node info: [dict get $active_chnl_clks rx_transfer_clk_reg]"
            }
          }
 
         
 
          set pld_pma_hclk_ref_nodes_col aib_hssi_pld_pma_hclk_ch${chnl}_ref
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$pld_pma_hclk_ref_nodes_col]] > 0} {
            dict lappend active_chnl_clks pld_pma_hclk_ref [get_node_info -name $top_tile_inst_name$pld_pma_hclk_ref_nodes_col]
            ## sorting
            dict set active_chnl_clks pld_pma_hclk_ref [lsort -dictionary [dict get $active_chnl_clks pld_pma_hclk_ref]]
            if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: pld pma hclk ref node info: [dict get $active_chnl_clks pld_pma_hclk_ref]"
            }
          }

          set pld_pma_hclk_reg_nodes_col aib_hssi_pld_pma_hclk_ch${chnl}.reg
          if {[get_collection_size [get_nodes -nowarn $top_tile_inst_name$pld_pma_hclk_reg_nodes_col]] > 0} {
            dict lappend active_chnl_clks pld_pma_hclk_reg [get_node_info -name $top_tile_inst_name$pld_pma_hclk_reg_nodes_col]
            ## sorting
            dict set active_chnl_clks pld_pma_hclk_reg [lsort -dictionary [dict get $active_chnl_clks pld_pma_hclk_reg]]
            if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: pld pma hclk reg node info: [dict get $active_chnl_clks pld_pma_hclk_reg]"
            }
          }
          
          set tx_pld_pcs_out1_dcm_nodes_col hdpldadapt_tx_chnl_${chnl}|pld_pcs_tx_clk_out1_dcm  
          if {[get_collection_size [get_nodes -nowarn $top_fab_inst_name$tx_pld_pcs_out1_dcm_nodes_col]] > 0} {
            dict lappend active_chnl_clks tx_clkout [get_node_info -name $top_fab_inst_name$tx_pld_pcs_out1_dcm_nodes_col]
            ## sorting
            dict set active_chnl_clks tx_clkout [lsort -dictionary [dict get $active_chnl_clks tx_clkout]]
            if {$ip_sdc_debug == 1} {
                post_message -type info "IP SDC: PLD PCS TX OUT1 DCM CLK node info: [dict get $active_chnl_clks tx_clkout]"
            }
          } 

           
    }; # end of foreach_in_collection dummy ff
} else {
   if {$ip_sdc_debug == 1} {
      post_message -type info "IP SDC: Could not find active CLKOUT ports for user facing clocks"
   }

}



  proc native_prepare_to_create_clocks_all_ch {clks_grp clks active_chnl_clks_freq active_chnl_multiply_by_factors active_chnl_divide_by_factors ip_inst_name top_tile_inst_name master_clocks source_nodes} {
    ## call global variable 
    global ::ip_sdc_debug
  
        foreach clk $clks {
                if {$clks_grp == "tx_pld_pcs_clk_ref" || $clks_grp == "rx_pld_pcs_clk_ref" || $clks_grp == "tx_pma_aib_clk_ref" || $clks_grp == "rx_transfer_clk_ref" || $clks_grp == "tx_user_clk_ref" || $clks_grp == "rx_user_clk_ref" || $clks_grp == "pld_pma_hclk_ref"} {
                     ## get active chnl number according to it's single bit or two bits, index-2 is digit means two bits(10~23), otherwise it's single bit(0~9)
                     set chnl_index [string last _ref $clk]
                     if { [string is digit [string index $clk $chnl_index-2]] } {
                          set chnl [string range $clk $chnl_index-2 $chnl_index-1]
                        } else {
                          set chnl [string index $clk $chnl_index-1]
                        }
  
                     set grp_freq [dict get $active_chnl_clks_freq $clks_grp]
                    
                     ## create clock name based on clock group and channel 
                     set clk_name $ip_inst_name|$clks_grp|ch$chnl
                     dict lappend active_chnl_clks_names tx_pld_pcs_clks_ref_name $clk_name
                     
                          ## create_clock  
                          create_clock \
                                       -name $clk_name \
                                       -period "$grp_freq MHz" \
                                       -add    $clk
                           if {$ip_sdc_debug == 1} {
                                 post_message -type info "IP SDC: Creating base clock: $clk_name, period $grp_freq MHz, at node $clk"
                                 post_message -type info "IP SDC: Creating base clock: period is $grp_freq MHz"
                                 post_message -type info "IP SDC: Creating base clock: at node $clk"
                           }               
                } elseif {$clks_grp == "tx_pld_pcs_clk_reg" || $clks_grp == "rx_pld_pcs_clk_reg" || $clks_grp == "tx_pma_aib_clk_reg" || $clks_grp == "rx_transfer_clk_reg" || $clks_grp == "tx_user_clk_reg" || $clks_grp == "rx_user_clk_reg" || $clks_grp == "pld_pma_hclk_reg" || $clks_grp == "tx_clkout" || $clks_grp == "rx_clkout" || $clks_grp == "tx_clkout2" || $clks_grp == "rx_clkout2"} {
                         ## get active chnl number according to it's single bit or two bits, index-2 is digit means two bits(10~23), otherwise it's single bit(0~9)
                         if {$clks_grp == "tx_pld_pcs_clk_reg" || $clks_grp == "rx_pld_pcs_clk_reg" || $clks_grp == "tx_pma_aib_clk_reg" || $clks_grp == "rx_transfer_clk_reg" || $clks_grp == "tx_user_clk_reg" || $clks_grp == "rx_user_clk_reg" || $clks_grp == "pld_pma_hclk_reg"} {
                            set chnl_index [string last .reg $clk]
                         } elseif {$clks_grp == "tx_clkout" || $clks_grp == "rx_clkout" || $clks_grp == "tx_clkout2" || $clks_grp == "rx_clkout2"} {
                            set chnl_index [string last |pld_pcs_ $clk]
                         }
  
                         if { [string is digit [string index $clk $chnl_index-2]] } {
                               set chnl [string range $clk $chnl_index-2 $chnl_index-1]
                         } else {
                               set chnl [string index $clk $chnl_index-1]
                         }
   
                         set multiply_by [dict get $active_chnl_multiply_by_factors $clks_grp]
                         set divide_by [dict get $active_chnl_divide_by_factors $clks_grp]
                         set clk_name $ip_inst_name|$clks_grp|ch$chnl
                          
                          set skip_ip_inst_name [string map {\[ \\[ \] \\]\\ } $ip_inst_name] 
                          set master_clock [lsearch -inline $master_clocks $skip_ip_inst_name*$chnl*]
                          set skip_top_inst_name [string map {\[ \\[ \] \\]\\ } $top_tile_inst_name] 
                          set source_node  [lsearch -inline $source_nodes $skip_top_inst_name*$chnl*]
       
                         ## create_generated_clock  
                         create_generated_clock \
                                      -name $clk_name \
                                      -source $source_node \
                                      -master_clock $master_clock \
                                      -multiply_by $multiply_by \
                                      -divide_by $divide_by \
                                      -duty_cycle 50 \
                                      -add    $clk
                           if {$ip_sdc_debug == 1} {
                                 post_message -type info "IP SDC: Creating generated clock: $clk_name"
                                 post_message -type info "IP SDC: Creating generated clock: at node $clk"
                                 post_message -type info "IP SDC: Creating generated clock: source node is $source_node"
                                 post_message -type info "IP SDC: Creating generated clock: master clock is $master_clock"
                                 post_message -type info "IP SDC: Creating generated clock: multiply_by factor is $multiply_by"
                                 post_message -type info "IP SDC: Creating generated clock: divide_by factor is $divide_by"
                           }         
            }; ## end of if-elseif condition
        }; ## end of foreach clk
  
  }; ## end of proc {native_prepare_to_create_clocks_all_ch}


  ## iterate through each clock group, set master clock and source node
  foreach {clks_grp clks} $active_chnl_clks {
    ## call global variable 
    global ::ip_sdc_debug
  
        foreach clk $clks {
              if {$clks_grp == "tx_pld_pcs_clk_ref" || $clks_grp == "rx_pld_pcs_clk_ref" || $clks_grp == "tx_pma_aib_clk_ref" || $clks_grp == "rx_transfer_clk_ref" || $clks_grp == "tx_user_clk_ref" || $clks_grp == "rx_user_clk_ref" || $clks_grp == "pld_pma_hclk_ref"} {
                  ## get active chnl number according to it's single bit or two bits, index-2 is digit means two bits(10~23), otherwise it's single bit(0~9)
                  set chnl_index [string last _ref $clk]
                  if { [string is digit [string index $clk $chnl_index-2]] } {
                        set chnl [string range $clk $chnl_index-2 $chnl_index-1]
                     } else {
                        set chnl [string index $clk $chnl_index-1]
                     }
                  
                  set clk_name $ip_inst_name|$clks_grp|ch$chnl
                  dict lappend active_chnl_clks_names $clks_grp $clk_name
                  set master_clocks ""
                  set source_nodes ""
              } elseif {$clks_grp == "tx_pld_pcs_clk_reg" || $clks_grp == "rx_pld_pcs_clk_reg" || $clks_grp == "tx_pma_aib_clk_reg" || $clks_grp == "rx_transfer_clk_reg" || $clks_grp == "tx_user_clk_reg" || $clks_grp == "rx_user_clk_reg" || $clks_grp == "pld_pma_hclk_reg" || $clks_grp == "tx_clkout" || $clks_grp == "rx_clkout" || $clks_grp == "tx_clkout2" || $clks_grp == "rx_clkout2"} {
                        ## get active chnl number according to it's single bit or two bits, index-2 is digit means two bits(10~23), otherwise it's single bit(0~9)
                        if {$clks_grp == "tx_pld_pcs_clk_reg" || $clks_grp == "rx_pld_pcs_clk_reg" || $clks_grp == "tx_pma_aib_clk_reg" || $clks_grp == "rx_transfer_clk_reg" || $clks_grp == "tx_user_clk_reg" || $clks_grp == "rx_user_clk_reg" || $clks_grp == "pld_pma_hclk_reg"} {
                            set chnl_index [string last .reg $clk]
                        } elseif {$clks_grp == "tx_clkout" || $clks_grp == "rx_clkout" || $clks_grp == "tx_clkout2" || $clks_grp == "rx_clkout2"} {
                            set chnl_index [string last |pld_pcs $clk]
                        }
  
                        if { [string is digit [string index $clk $chnl_index-2]] } {
                             set chnl [string range $clk $chnl_index-2 $chnl_index-1]
                        } else {
                             set chnl [string index $clk $chnl_index-1]
                        }
   
                        set clk_name $ip_inst_name|$clks_grp|ch$chnl
                        dict lappend active_chnl_clks_names $clks_grp $clk_name
              }; ## end of if-elseif condition
  
        }; ## end of foreach clk 
       
         
      if {$clks_grp == "tx_pld_pcs_clk_reg"} {
              set master_clocks [dict get $active_chnl_clks_names tx_pld_pcs_clk_ref]
              set source_nodes  [dict get $active_chnl_clks tx_pld_pcs_clk_ref]
             } elseif {$clks_grp == "rx_pld_pcs_clk_reg"} {
              set master_clocks [dict get $active_chnl_clks_names rx_pld_pcs_clk_ref]
              set source_nodes  [dict get $active_chnl_clks rx_pld_pcs_clk_ref]
             } elseif {$clks_grp == "tx_pma_aib_clk_reg"} {
              set master_clocks [dict get $active_chnl_clks_names tx_pma_aib_clk_ref]
              set source_nodes  [dict get $active_chnl_clks tx_pma_aib_clk_ref]
             } elseif {$clks_grp == "rx_transfer_clk_reg"} {
              set master_clocks [dict get $active_chnl_clks_names rx_transfer_clk_ref]
              set source_nodes  [dict get $active_chnl_clks rx_transfer_clk_ref]
             }  elseif {$clks_grp == "tx_user_clk_reg"} {
              set master_clocks [dict get $active_chnl_clks_names tx_user_clk_ref]
              set source_nodes  [dict get $active_chnl_clks tx_user_clk_ref]
             } elseif {$clks_grp == "rx_user_clk_reg"} {
              set master_clocks [dict get $active_chnl_clks_names rx_user_clk_ref]
              set source_nodes  [dict get $active_chnl_clks rx_user_clk_ref]
             } elseif {$clks_grp == "pld_pma_hclk_reg"} {
              set master_clocks [dict get $active_chnl_clks_names pld_pma_hclk_ref]
              set source_nodes  [dict get $active_chnl_clks pld_pma_hclk_ref]
             } elseif {$clks_grp == "tx_clkout"} {
              set master_clocks [dict get $active_chnl_clks_names tx_pld_pcs_clk_reg]
              set source_nodes  [dict get $active_chnl_clks tx_pld_pcs_clk_reg]
             } elseif {$clks_grp == "rx_clkout"} {
	      set master_clocks [dict get $active_chnl_clks_names rx_pld_pcs_clk_reg]
              set source_nodes  [dict get $active_chnl_clks rx_pld_pcs_clk_reg]
             } elseif {$clks_grp == "tx_clkout2"} {
              set master_clocks [dict get $active_chnl_clks_names tx_user_clk_reg]
              set source_nodes  [dict get $active_chnl_clks tx_user_clk_reg]
             } elseif {$clks_grp == "rx_clkout2"} {
	      set master_clocks [dict get $active_chnl_clks_names rx_user_clk_reg]
              set source_nodes  [dict get $active_chnl_clks rx_user_clk_reg]
             }


        ## call proc to create clocks 
        native_prepare_to_create_clocks_all_ch $clks_grp $clks $active_chnl_clks_freq $active_chnl_multiply_by_factors $active_chnl_divide_by_factors $ip_inst_name $top_tile_inst_name $master_clocks $source_nodes
  }; ## end of dict for
  
  #-------------------------------------------------- #
  #---                                            --- #
  #--- DISABLE MIN_PULSE_WIDTH CHECK              --- #
  #---                                            --- #
  #-------------------------------------------------- #
  ## Disable min_pulse_width for TX source clocks
  set tx_source_clks_list [list]
  if {[dict exists $active_chnl_clks_names tx_pld_pcs_clk_ref]} {
    set tx_source_clks_list [dict get $active_chnl_clks_names tx_pld_pcs_clk_ref]
  }
  if {[dict exists $active_chnl_clks_names tx_pma_aib_clk_ref]} {
    set tx_source_clks_list [concat $tx_source_clks_list  [dict get $active_chnl_clks_names tx_pma_aib_clk_ref]]
  }
  if {[dict exists $active_chnl_clks_names tx_user_clk_ref]} {
    set tx_source_clks_list [concat $tx_source_clks_list [dict get $active_chnl_clks_names tx_user_clk_ref]]
  }

  
  foreach tx_src_clk $tx_source_clks_list {
    disable_min_pulse_width $tx_src_clk
  }
  
  
  ## Disable min_pulse_width for RX source clocks
  set rx_source_clks_list [list]
  if {[dict exists $active_chnl_clks_names rx_pld_pcs_clk_ref]} {
    set rx_source_clks_list [dict get $active_chnl_clks_names rx_pld_pcs_clk_ref]
  }
  if {[dict exists $active_chnl_clks_names rx_transfer_clk_ref]} {
    set rx_source_clks_list [concat $rx_source_clks_list  [dict get $active_chnl_clks_names rx_transfer_clk_ref]]
  }
  if {[dict exists $active_chnl_clks_names rx_user_clk_ref]} {
    set rx_source_clks_list [concat $rx_source_clks_list [dict get $active_chnl_clks_names rx_user_clk_ref]]
  }
  

  foreach rx_src_clk $rx_source_clks_list {
    disable_min_pulse_width $rx_src_clk
  }
  
  ## Disable min_pulse_width for HCLK 
  if {[dict exists $active_chnl_clks_names pld_pma_hclk_ref]} {
    disable_min_pulse_width [dict get $active_chnl_clks_names pld_pma_hclk_ref] 
  }
 
  

############################################################################################################
###########################  Hard IP Timing Violations temporary fix ################################################
############################################################################################################
set aib_fabric_pld_pma_hclk_reg_col [get_registers -nowarn *hdpldadapt_rx_chnl_*~aib_fabric_pld_pma_hclk.reg]
set aib_fabric_pma_aib_tx_clk_reg_col [get_registers -nowarn *hdpldadapt_tx_chnl_*~aib_fabric_pma_aib_tx_clk.reg]
set pld_rx_clk1_dcm_reg_col [get_registers -nowarn *hdpldadapt_rx_chnl_*~pld_rx_clk1_dcm.reg]
set pld_rx_clk1_rowclk_reg_clk [get_registers -nowarn *hdpldadapt_rx_chnl_*~pld_rx_clk1_rowclk.reg]


if {[get_collection_size $aib_fabric_pld_pma_hclk_reg_col] > 0 && [get_collection_size $aib_fabric_pma_aib_tx_clk_reg_col] > 0} {
    set_false_path -from $aib_fabric_pld_pma_hclk_reg_col -to $aib_fabric_pma_aib_tx_clk_reg_col
  }

if {[get_collection_size $aib_fabric_pld_pma_hclk_reg_col] > 0 && [get_collection_size $pld_rx_clk1_dcm_reg_col] > 0} {
    set_false_path -from $aib_fabric_pld_pma_hclk_reg_col -to $pld_rx_clk1_dcm_reg_col
  }

if {[get_collection_size $aib_fabric_pld_pma_hclk_reg_col] > 0 && [get_collection_size $pld_rx_clk1_rowclk_reg_clk] > 0} {
    set_false_path -from $aib_fabric_pld_pma_hclk_reg_col -to $pld_rx_clk1_rowclk_reg_clk
  }

if {[get_collection_size $aib_fabric_pld_pma_hclk_reg_col] > 0} {
   set_false_path -to $aib_fabric_pld_pma_hclk_reg_col
}

set tx_pma_aib_clk_reg_col_minpulse [get_registers -nowarn *xtxdatapath_tx*~aib_fabric_tx_transfer_clk.reg]
set tx_pma_aib_clk_reg_col_minpulse [add_to_collection $tx_pma_aib_clk_reg_col_minpulse [get_registers -nowarn *hdpldadapt_tx_chnl*~aib_fabric_pma_aib_tx_clk.reg]]
 if {[get_collection_size $tx_pma_aib_clk_reg_col_minpulse] > 0} {
         disable_min_pulse_width $tx_pma_aib_clk_reg_col_minpulse
 }

set rx_transfer_clk_reg_col_minpulse [get_registers -nowarn *hdpldadapt_rx_chnl*~aib_fabric_rx_transfer_clk.reg]
 if {[get_collection_size $rx_transfer_clk_reg_col_minpulse] > 0} {
         disable_min_pulse_width $rx_transfer_clk_reg_col_minpulse
 }

set tx_user_clk_reg_col [get_pins -compatibility_mode -nowarn *hdpldadapt_tx_chnl_*aib_fabric_pld_pma_clkdiv_tx_user]
 if {[get_collection_size $tx_user_clk_reg_col] > 0} {
         disable_min_pulse_width $tx_user_clk_reg_col
 }



# ----------------------------------------------------------------------------- #
# ---  Clock Crosser constraint and skew constraint                       --- #
# ----------------------------------------------------------------------------- #

proc eth_f_constraint_net_delay {from_reg to_reg max_net_delay {check_exist 0} {get_pins 1} {set_skew_constraint 1} {set_mstable 1} {set_no_synchronizer 0}} {
    # Check for instances
    set inst [get_registers -nowarn ${to_reg}]
    
    # Check number of instances
    set inst_num [llength [query_collection -report -all $inst]]
    if {$inst_num > 0} {
        # Uncomment line below for debug purpose
        #puts "${inst_num} ${to_reg} instance(s) found"
    } else {
        # Uncomment line below for debug purpose
        #puts "No ${to_reg} instance found"
    }

  if {($set_skew_constraint == 0)} {   
    if {($check_exist == 0) || ($inst_num > 0)} {
        if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
            if {$set_no_synchronizer == 1} {
                set_max_delay -no_synchronizer -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] 200ns
            } else {
                set_max_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] 200ns
            }
            set_min_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] -200ns
        } else {
            if {$get_pins == 0} {
                set_net_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] -max $max_net_delay
            } else {
                set_net_delay -from [get_pins -compatibility_mode ${from_reg}|q] -to [get_registers ${to_reg}] -max $max_net_delay
            }
            
            # Relax the fitter effort
            if {$set_no_synchronizer == 1} {
                set_max_delay -no_synchronizer -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] 200ns
            } else {
                set_max_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] 200ns
            }
            set_min_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] -200ns
        }
    }
  } else {   
        #set skew and min/max delay for EFIFO
        # control skew for bits
        set_max_skew -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] -get_skew_value_from_clock_period src_clock_period -skew_value_multiplier 0.8
        # path delay (exception for net delay)
        if { ![string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
            set_net_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8
        }
        #relax setup and hold calculation
        if {$set_no_synchronizer == 1} {
            set_max_delay -no_synchronizer -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] 100
        } else {
            set_max_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] 100
        }
        set_min_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] -100		
  }
	
    #set Meta stability for EFIFO 
    if {($set_mstable == 1)} {
		if { ![string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
			set_net_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8
		}
    }
}


proc apply_constraints {hier_path} {
#general: synchronizer
eth_f_constraint_net_delay  * \
                            *|resync_chains[*].synchronizer_nocut|din_s1 \
                            2.2ns 1 0 0 0 0
eth_f_constraint_net_delay  * \
                            *|*.synchronizer_nocut_inst|din_s1 \
                            2.2ns 1 0 0 0 0
eth_f_constraint_net_delay  * \
                            *|sip_inst|rx_dsk_rst_sync_inst|din_s1 \
                            2.2ns 1 0 0 0 0
eth_f_constraint_net_delay  * \
                            *|sip_inst|lanes_stable_sync_inst|din_s1 \
                            2.2ns 1 0 0 0 0
eth_f_constraint_net_delay  * \
                            *|sip_inst|rx_adapt_dropped_frame_count_sync_inst|valid_sync_0|din_s1 \
                            2.2ns 1 0 0 0 0
eth_f_constraint_net_delay  * \
                            *|sip_inst|rx_adapt_dropped_frame_count_sync_inst|rst_sync_0|din_s1 \
                            2.2ns 1 0 0 0 0
eth_f_constraint_net_delay  * \
                            *|sip_inst|rx_adapt_dropped_frame_count_sync_inst|ack_sync_0|din_s1 \
                            2.2ns 1 0 0 0 0
eth_f_constraint_net_delay  * \
                            *|sip_inst|rx_adapt_dropped_frame_count_sync_inst|data_out[*] \
                            2.2ns 1 0 0 0 0
eth_f_constraint_net_delay  * \
                            *|sip_inst|dropped_clear_sync_inst|din_s1 \
                            2.2ns 1 0 0 0 0


# csr_readdata
eth_f_constraint_net_delay  * \
                            *|soft_csr|readdata[*] \
                            2.2ns 1 0 0 0 0

# Additional common paths

eth_f_constraint_net_delay  * \
                            *|sip_inst|tx_dsk_rst_sync_inst|din_s1\
                            2.2ns 1 0 0 0 0
eth_f_constraint_net_delay  * \
                            *|sip_inst|csr_inst|soft_csr|eth_reset_eio_sys_rst\
                            2.2ns 1 0 0 0 0
eth_f_constraint_net_delay  * \
                            *|sip_inst|o_rx_pcs_ready*\
                            2.2ns 1 0 0 0 0
									 
eth_f_constraint_net_delay  * \
                            *|sip_inst|csr_inst|soft_csr|eth_reset_soft_tx_rst\
                            2.2ns 1 0 0 0 0
									 
eth_f_constraint_net_delay  * \
                            *|sip_inst|o_tx_lanes_stable*\
                            2.2ns 1 0 0 0 0

eth_f_constraint_net_delay  * \
                            *|sip_inst|delay_pll_lock_inst|bit_loop[*].delay_1b|g_n_cycle.state[*]\
                            2.2ns 1 0 0 0 0

eth_f_constraint_net_delay  * \
                            *|sip_inst|csr_inst|soft_csr|eth_reset_soft_rx_rst\
                            2.2ns 1 0 0 0 0
			
eth_f_constraint_net_delay  * \
                            *|sip_inst|rx_pcs_fully_aligned_sync_int_rx\
                            2.2ns 1 0 0 0 0



eth_f_constraint_net_delay  * \
                            *|sip_inst|tx_pll_locked_sync_int_clk_inst|din_s1\
                            2.2ns 1 0 0 0 0





# --------------------------------------------------------------------
# --------------------------------------------------------------------



}

proc apply_constraints_inst {entity_name} {
set inst_list [get_entity_instances $entity_name]
foreach each_inst $inst_list {
    apply_constraints ${each_inst}
}
}

apply_constraints_inst ftile_400g_eth_eth_f_1800_23upnva


#disabling min_pulse_width
    #disable_min_pulse_width [get_clocks {*|tx_clkout|ch*}]
    #disable_min_pulse_width [get_clocks {*|rx_transfer_clk_reg|ch*}]
    #disable_min_pulse_width [get_clocks {*|tx_pma_aib_clk_reg|ch*}]
set txclks  [get_clocks -nowarn {*|tx_clkout|ch*}]
if {[get_collection_size $txclks] > 0} {
    disable_min_pulse_width $txclks
}
set rxclks  [get_clocks -nowarn {*|rx_transfer_clk_reg|ch*}]
if {[get_collection_size $rxclks] > 0} {
    disable_min_pulse_width $rxclks
}
set txpmaclks  [get_clocks -nowarn {*|tx_pma_aib_clk_reg|ch*}]
if {[get_collection_size $txpmaclks] > 0} {
    disable_min_pulse_width $txpmaclks
}

