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


set FAMILY              "Agilex 7"

set refclk_per 10
set pldclk_per 2
set aib_clk_per [expr $pldclk_per/2.0]
set avmm_clk_per 8.0
set pcie_sdc_debug 0
set recfg_clk_created 0

set csb2wire_en 1
set csb_clk_div 1
set sdc_rev_a_b 1

set pcie_topo 1x16

set inst [get_current_instance]
if {$pcie_sdc_debug == 1} {
   post_message -type info "Current instance: $inst"
}

#########  Proc #################
# Check if port exists
proc pcie_port_existence {port_name} {
   set port_collection [get_ports -nowarn $port_name]
   if { [get_collection_size $port_collection] > 0 } {
      return 1
   } else {
      return 0
   }
}

# Return existing clock target list
proc pcie_get_clock_target_list {} {
   upvar 1 pcie_sdc_debug pcie_sdc_debug

   set result [list]
   set clocks_collection [get_clocks -nowarn]
   foreach_in_collection clock $clocks_collection {
      if { ![is_clock_defined $clock] } {
         continue
      }
      set clock_name       [get_clock_info -name $clock]
      set clock_target_col [get_clock_info -targets $clock]
      lappend result       [query_collection -report -all $clock_target_col]
      if {$pcie_sdc_debug} { post_message -type info "clock_name : $clock_name" }
   }
   if {$pcie_sdc_debug} { post_message -type info "PCIe clock_target list: $result" }

   return $result
}

set pcie_clock_target_list [pcie_get_clock_target_list]
#################################



########### Note ######################################################################################################################
### Refclk and avmm clk only will be created when top level port matches QHIP port.  Else no refclk and avmm clk will be created. #####
### User need to aware of the port name used.  This SDC is for user reference for top level clk creation.                         #####
#######################################################################################################################################

############### clock ###############
#refclk
set pcie_refclk0_ext  [pcie_port_existence refclk0]
set pcie_refclk0_lsrc [lsearch -exact $pcie_clock_target_list refclk0]
if {$pcie_refclk0_ext && $pcie_refclk0_lsrc == -1} {
   create_clock -period 10 -name refclk0 refclk0
}

set pcie_refclk1_ext  [pcie_port_existence refclk1]
set pcie_refclk1_lsrc [lsearch -exact $pcie_clock_target_list refclk1]
if {$pcie_refclk1_ext && $pcie_refclk1_lsrc == -1} {
   create_clock -period 10 -name refclk1 refclk1
}

#reconfig clk
set pcie_recfg_ext  [pcie_port_existence reconfig_clk]
set pcie_recfg_lsrc [lsearch -exact $pcie_clock_target_list reconfig_clk]
if {$pcie_recfg_ext && $pcie_recfg_lsrc == -1} {
   create_clock -period $avmm_clk_per -name reconfig_clk reconfig_clk
   set recfg_clk_created 1
}

#pldclk
create_clock -name ${inst}_ref_clock_ch15 -period $aib_clk_per [get_nodes ${inst}|maib_and_tile|z1578a~pld_pcs_tx_clk_out_ch15_ref] -add

disable_min_pulse_width [get_clocks ${inst}_ref_clock_ch15]

create_generated_clock -name ${inst}_pld_clkout -source [get_nodes ${inst}|maib_and_tile|z1578a~pld_pcs_tx_clk_out_ch15_ref] -master_clock ${inst}_ref_clock_ch15 -multiply_by 1 -divide_by 2 [get_registers ${inst}|maib_and_tile|z1578a~pld_pcs_tx_clk_out_ch15.reg] -add

set_multicycle_path -setup 2 -from [get_keepers ${inst}|rnr_pcie_reset_ctrl_inst|pld_adapter_rx_pld_rst_n_r_ch[*]] -to [get_keepers ${inst}|maib_and_tile|hdpldadapt_rx_chnl_*~pld_rx_clk1_dcm.reg]
set_multicycle_path -hold 1 -from [get_keepers ${inst}|rnr_pcie_reset_ctrl_inst|pld_adapter_rx_pld_rst_n_r_ch[*]] -to [get_keepers ${inst}|maib_and_tile|hdpldadapt_rx_chnl_*~pld_rx_clk1_dcm.reg]

###### slow clk
# A0
if {$sdc_rev_a_b ==0 && $csb2wire_en == 1} {
if {$csb_clk_div ==1} {
create_generated_clock -name ${inst}_pld_clkout_slow -source [get_registers ${inst}|maib_and_tile|z1578a~pld_pcs_tx_clk_out_ch15.reg] -master_clock ${inst}_pld_clkout -multiply_by 1 -divide_by 4 [get_registers ${inst}|u_rnr_pcie_soft_rx_tx_wrapper|rnr_csb_divclk_inst|cnt[1]] -add
} else {
create_generated_clock -name ${inst}_pld_clkout_slow -source [get_registers ${inst}|maib_and_tile|z1578a~pld_pcs_tx_clk_out_ch15.reg] -master_clock ${inst}_pld_clkout -multiply_by 1 -divide_by 2 [get_registers ${inst}|u_rnr_pcie_soft_rx_tx_wrapper|rnr_csb_divclk_inst|cnt[0]] -add
}
set_clock_groups -async -group ${inst}_pld_clkout_slow -group ${inst}_pld_clkout
}

# B0
if {$sdc_rev_a_b ==1 && $csb2wire_en == 1} {
create_clock -name ${inst}_ref_clock_ch12 -period $aib_clk_per [get_nodes ${inst}|maib_and_tile|z1578a~pld_pcs_rx_clk_out_ch12_ref] -add
disable_min_pulse_width [get_clocks ${inst}_ref_clock_ch12]

if {$csb_clk_div ==1} {
create_generated_clock -name ${inst}_pld_clkout_slow -source [get_nodes ${inst}|maib_and_tile|z1578a~pld_pcs_rx_clk_out_ch12_ref] -master_clock ${inst}_ref_clock_ch12 -multiply_by 1 -divide_by 8 [get_registers ${inst}|maib_and_tile|z1578a~pld_pcs_rx_clk_out_ch12.reg] -add
} else {
create_generated_clock -name ${inst}_pld_clkout_slow -source [get_nodes ${inst}|maib_and_tile|z1578a~pld_pcs_rx_clk_out_ch12_ref] -master_clock ${inst}_ref_clock_ch12 -multiply_by 1 -divide_by 4 [get_registers ${inst}|maib_and_tile|z1578a~pld_pcs_rx_clk_out_ch12.reg] -add
}
set_clock_groups -async -group ${inst}_pld_clkout_slow -group ${inst}_pld_clkout
}


############### false path ###############
if {$recfg_clk_created == 1} {
        set_clock_groups -async -group reconfig_clk 
}


set flop [get_registers -nowarn ${inst}|rnr_pcie_reset_ctrl_inst|p*_reset_status_sync|din_s1]
set flop1 [query_collection -report -all $flop]
foreach flop2 $flop1 {
        set_false_path -to [get_pins ${flop2}|d]
}

set flop [get_registers -nowarn ${inst}|rnr_pcie_reset_ctrl_inst|pin_perst_n_sync|din_s1]
set flop1 [query_collection -report -all $flop]
foreach flop2 $flop1 {
        set_false_path -to [get_pins ${flop2}|d]
}

#Remove chnl 18 for Rx B0.  Tx no change. Look for ltssm mapping
if {  [regexp "x16" $pcie_topo] } {
#unused in x16 for row18-23 in A0
#unused in x16 for row19-23 in B0
if {$sdc_rev_a_b ==0} {
set_false_path -from [get_keepers ${inst}|maib_and_tile|hdpldadapt_rx_chnl_18~pld_rx_clk1_dcm.reg]
set_false_path -from [get_keepers ${inst}|rnr_pcie_reset_ctrl_inst|pld_adapter_rx_pld_rst_n_r_ch[18]] -to [get_keepers ${inst}|maib_and_tile|hdpldadapt_rx_chnl_18~pld_rx_clk1_dcm.reg]
}
set_false_path -from [get_keepers ${inst}|maib_and_tile|hdpldadapt_rx_chnl_19~pld_rx_clk1_dcm.reg]
set_false_path -from [get_keepers ${inst}|maib_and_tile|hdpldadapt_rx_chnl_20~pld_rx_clk1_dcm.reg]
set_false_path -from [get_keepers ${inst}|maib_and_tile|hdpldadapt_rx_chnl_21~pld_rx_clk1_dcm.reg]
set_false_path -from [get_keepers ${inst}|maib_and_tile|hdpldadapt_rx_chnl_22~pld_rx_clk1_dcm.reg]
set_false_path -from [get_keepers ${inst}|maib_and_tile|hdpldadapt_rx_chnl_23~pld_rx_clk1_dcm.reg]

set_false_path -from [get_keepers ${inst}|rnr_pcie_reset_ctrl_inst|pld_adapter_rx_pld_rst_n_r_ch[19]] -to [get_keepers ${inst}|maib_and_tile|hdpldadapt_rx_chnl_19~pld_rx_clk1_dcm.reg]
set_false_path -from [get_keepers ${inst}|rnr_pcie_reset_ctrl_inst|pld_adapter_rx_pld_rst_n_r_ch[20]] -to [get_keepers ${inst}|maib_and_tile|hdpldadapt_rx_chnl_20~pld_rx_clk1_dcm.reg]
set_false_path -from [get_keepers ${inst}|rnr_pcie_reset_ctrl_inst|pld_adapter_rx_pld_rst_n_r_ch[21]] -to [get_keepers ${inst}|maib_and_tile|hdpldadapt_rx_chnl_21~pld_rx_clk1_dcm.reg]
set_false_path -from [get_keepers ${inst}|rnr_pcie_reset_ctrl_inst|pld_adapter_rx_pld_rst_n_r_ch[22]] -to [get_keepers ${inst}|maib_and_tile|hdpldadapt_rx_chnl_22~pld_rx_clk1_dcm.reg]
set_false_path -from [get_keepers ${inst}|rnr_pcie_reset_ctrl_inst|pld_adapter_rx_pld_rst_n_r_ch[23]] -to [get_keepers ${inst}|maib_and_tile|hdpldadapt_rx_chnl_23~pld_rx_clk1_dcm.reg]

set_false_path -to [get_keepers ${inst}|maib_and_tile|hdpldadapt_tx_chnl_18~pld_tx_clk1_dcm.reg]
set_false_path -to [get_keepers ${inst}|maib_and_tile|hdpldadapt_tx_chnl_19~pld_tx_clk1_dcm.reg]
set_false_path -to [get_keepers ${inst}|maib_and_tile|hdpldadapt_tx_chnl_20~pld_tx_clk1_dcm.reg]
set_false_path -to [get_keepers ${inst}|maib_and_tile|hdpldadapt_tx_chnl_21~pld_tx_clk1_dcm.reg]
set_false_path -to [get_keepers ${inst}|maib_and_tile|hdpldadapt_tx_chnl_22~pld_tx_clk1_dcm.reg]
set_false_path -to [get_keepers ${inst}|maib_and_tile|hdpldadapt_tx_chnl_23~pld_tx_clk1_dcm.reg]
}

#Tx no change. Look for ltssm mapping
if {  [regexp "2x8" $pcie_topo] } {
#unused in 2x8 for Rx row10,11,22,23 in A0
#unused in 2x8 for Rx row10,22 in B0
#But need to time Tx deskew marker
set_false_path -from [get_keepers ${inst}|maib_and_tile|hdpldadapt_rx_chnl_10~pld_rx_clk1_dcm.reg]
set_false_path -from [get_keepers ${inst}|maib_and_tile|hdpldadapt_rx_chnl_22~pld_rx_clk1_dcm.reg]
set_false_path -from [get_keepers ${inst}|rnr_pcie_reset_ctrl_inst|pld_adapter_rx_pld_rst_n_r_ch[10]] -to [get_keepers ${inst}|maib_and_tile|hdpldadapt_rx_chnl_10~pld_rx_clk1_dcm.reg]
set_false_path -from [get_keepers ${inst}|rnr_pcie_reset_ctrl_inst|pld_adapter_rx_pld_rst_n_r_ch[22]] -to [get_keepers ${inst}|maib_and_tile|hdpldadapt_rx_chnl_22~pld_rx_clk1_dcm.reg]

if {$sdc_rev_a_b ==0} {
set_false_path -from [get_keepers ${inst}|maib_and_tile|hdpldadapt_rx_chnl_11~pld_rx_clk1_dcm.reg]
set_false_path -from [get_keepers ${inst}|maib_and_tile|hdpldadapt_rx_chnl_23~pld_rx_clk1_dcm.reg]
set_false_path -from [get_keepers ${inst}|rnr_pcie_reset_ctrl_inst|pld_adapter_rx_pld_rst_n_r_ch[11]] -to [get_keepers ${inst}|maib_and_tile|hdpldadapt_rx_chnl_11~pld_rx_clk1_dcm.reg]
set_false_path -from [get_keepers ${inst}|rnr_pcie_reset_ctrl_inst|pld_adapter_rx_pld_rst_n_r_ch[23]] -to [get_keepers ${inst}|maib_and_tile|hdpldadapt_rx_chnl_23~pld_rx_clk1_dcm.reg]
}
}

########## SRC BTI Related #################
##SRC Signals using free_run_clk is expected to be asynchronous going into MAIB
set_false_path -from [get_keepers ${inst}|rnr_pcie_reset_ctrl_inst|pld_adapter_tx_pld_rst_n_r_ch[*]] -to [get_keepers ${inst}|maib_and_tile|hdpldadapt_tx_chnl_*~pld_tx_clk1_dcm.reg] 
set_false_path -from [get_keepers ${inst}|rnr_pcie_reset_ctrl_inst|pld_adapter_rx_pld_rst_n_r_ch[*]] -to [get_keepers ${inst}|maib_and_tile|hdpldadapt_rx_chnl_*~pld_rx_clk1_dcm.reg]
set_false_path -from [get_keepers ${inst}|rnr_pcie_reset_ctrl_inst|cur_state_*] -to [get_keepers ${inst}|rnr_pcie_reset_ctrl_inst|*_sync|din_s1]
set_false_path -from [get_keepers ${inst}|rnr_pcie_reset_ctrl_inst|pld_hssi_osc_transfer_en_2r] -to [get_keepers ${inst}|rnr_pcie_reset_ctrl_inst|osc_transfer_en*_sync|din_s1]
#set_false_path -from [get_keepers ${inst}|] -to [get_keepers ${inst}|]


############### Debug Toolkit ###############
if {1} {
# Timing Analyzer Cookbook: https://www.intel.com/content/www/us/en/programmable/documentation/mwh1452708879095.html
# KDB: https://www.intel.com/content/www/us/en/programmable/support/support-resources/knowledge-base/solutions/rd04282008_867.html
set tck_clk_ext  [pcie_port_existence altera_reserved_tck]
set tck_clk_lsrc [lsearch -exact $pcie_clock_target_list altera_reserved_tck]
if {$tck_clk_ext && $tck_clk_lsrc == -1} {
   create_clock -name altera_reserved_tck -period 30 altera_reserved_tck
   set_clock_groups -asynchronous -group {altera_reserved_tck}
}
}

