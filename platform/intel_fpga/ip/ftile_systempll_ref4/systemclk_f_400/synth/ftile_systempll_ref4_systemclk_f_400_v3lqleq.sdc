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

## The SDC is added as a ENTITY_SDC_FILE, hence paths are relative to the ip_inst_name this is associated with
set ip_inst_name [get_current_instance]


foreach_in_collection node1 [get_nodes $ip_inst_name|x_sip|gen_systempll[2].enabled.ctrl_pll_aibrc_clock_top__pll_slice1_clk_sdc|clk] {
    foreach edge [get_node_info -synch_edges $node1] {
        set clk_name  [get_node_info -name [get_edge_info -src $edge]]
        set freq [expr 415039062 / 1000000.0]
        create_clock -period "$freq MHz" -name $clk_name $clk_name
    }
}



set enable_refclk_watchdog_timer_0_inst_din [get_registers -nowarn $ip_inst_name|x_sip|enable_refclk_watchdog_timer_0_inst0|resync_chains[0].synchronizer_nocut|din_s11]
      if {[get_collection_size $enable_refclk_watchdog_timer_0_inst_din] > 0} {
	  set_max_delay  -to $enable_refclk_watchdog_timer_0_inst_din 100
	  set_min_delay  -to $enable_refclk_watchdog_timer_0_inst_din -100
      }

 set avmm_reset_in_sync_0_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset_in_sync_0_inst0|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset_in_sync_0_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset_in_sync_0_sync_inst_din 100
	  set_min_delay  -to $avmm_reset_in_sync_0_sync_inst_din -100
      }
	  
 set avmm_reset_ip_sync_0_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset_ip_sync_0_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset_ip_sync_0_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset_ip_sync_0_sync_inst_din 100
	  set_min_delay  -to $avmm_reset_ip_sync_0_sync_inst_din -100
      }

 set d_store_cnoc_clk_0_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|d_store_cnoc_clk_0_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $d_store_cnoc_clk_0_sync_inst_din] > 0} {
	  set_max_delay  -to $d_store_cnoc_clk_0_sync_inst_din 100
	  set_min_delay  -to $d_store_cnoc_clk_0_sync_inst_din -100
      }
 set d_store_core_clk_0_limit_inst_din [get_registers -nowarn $ip_inst_name|x_sip|d_store_core_clk_0_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $d_store_core_clk_0_limit_inst_din] > 0} {
	  set_max_delay  -to $d_store_core_clk_0_limit_inst_din 100
	  set_min_delay  -to $d_store_core_clk_0_limit_inst_din -100
      }

 set avmm_reset2_0_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset2_0_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset2_0_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset2_0_sync_inst_din 100
	  set_min_delay  -to $avmm_reset2_0_sync_inst_din -100
      }
   set cnoc_0_count_limit_inst_din [get_registers -nowarn $ip_inst_name|x_sip|cnoc_0_count_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $cnoc_0_count_limit_inst_din] > 0} {
	  set_max_delay  -to $cnoc_0_count_limit_inst_din 100
	  set_min_delay  -to $cnoc_0_count_limit_inst_din -100
      }
	  
  set en_refclk_fgt_0_sync_din [get_registers -nowarn $ip_inst_name|x_sip|en_refclk_fgt_0_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $en_refclk_fgt_0_sync_din] > 0} {
	  set_max_delay  -to $en_refclk_fgt_0_sync_din 100
	  set_min_delay  -to $en_refclk_fgt_0_sync_din -100
      }
   set monitor_0_chickenbit_core_din [get_registers -nowarn $ip_inst_name|x_sip|monitor_0_chickenbit_core_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $monitor_0_chickenbit_core_din] > 0} {
	  set_max_delay  -to $monitor_0_chickenbit_core_din 100
	  set_min_delay  -to $monitor_0_chickenbit_core_din -100
      }
   set monitor_0_chickenbit_sync_din [get_registers -nowarn $ip_inst_name|x_sip|monitor_0_chickenbit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $monitor_0_chickenbit_sync_din] > 0} {
	  set_max_delay  -to $monitor_0_chickenbit_sync_din 100
	  set_min_delay  -to $monitor_0_chickenbit_sync_din -100
      }
   set one_state_0_store_sync_din [get_registers -nowarn $ip_inst_name|x_sip|one_state_0_store_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $one_state_0_store_sync_din] > 0} {
	  set_max_delay  -to $one_state_0_store_sync_din 100
	  set_min_delay  -to $one_state_0_store_sync_din -100
      }
    set refclk_fgt_enabled_0_st_sync_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_fgt_enabled_0_st_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_fgt_enabled_0_st_sync_din] > 0} {
	  set_max_delay  -to $refclk_fgt_enabled_0_st_sync_din 100
	  set_min_delay  -to $refclk_fgt_enabled_0_st_sync_din -100
      }
    set refclk_monitor_0_sync_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_monitor_0_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_monitor_0_sync_din] > 0} {
	  set_max_delay  -to $refclk_monitor_0_sync_din 100
	  set_min_delay  -to $refclk_monitor_0_sync_din -100
      }

	set store_cnoc_clk_0_limit_sync_din [get_registers -nowarn $ip_inst_name|x_sip|store_cnoc_clk_0_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $store_cnoc_clk_0_limit_sync_din] > 0} {
	  set_max_delay  -to $store_cnoc_clk_0_limit_sync_din 100
	  set_min_delay  -to $store_cnoc_clk_0_limit_sync_din -100
      }
     	set in_coreclk_0_div_sync_inst_sync_din [get_registers -nowarn $ip_inst_name|x_sip|in_coreclk_0_div_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $in_coreclk_0_div_sync_inst_sync_din] > 0} {
	  set_max_delay  -to $in_coreclk_0_div_sync_inst_sync_din 100
	  set_min_delay  -to $in_coreclk_0_div_sync_inst_sync_din -100
      }

      set no_coreclk_0_div_sync_inst_sync_din [get_registers -nowarn $ip_inst_name|x_sip|no_coreclk_0_div_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $no_coreclk_0_div_sync_inst_sync_din] > 0} {
	  set_max_delay  -to $no_coreclk_0_div_sync_inst_sync_din 100
	  set_min_delay  -to $no_coreclk_0_div_sync_inst_sync_din -100
      }

      set refclk_count0_data_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_count0_data_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_count0_data_sync_inst_din] > 0} {
	  set_max_delay  -to $refclk_count0_data_sync_inst_din 100
	  set_min_delay  -to $refclk_count0_data_sync_inst_din -100
      }


set enable_refclk_watchdog_timer_1_inst_din [get_registers -nowarn $ip_inst_name|x_sip|enable_refclk_watchdog_timer_1_inst0|resync_chains[0].synchronizer_nocut|din_s11]
      if {[get_collection_size $enable_refclk_watchdog_timer_1_inst_din] > 0} {
	  set_max_delay  -to $enable_refclk_watchdog_timer_1_inst_din 100
	  set_min_delay  -to $enable_refclk_watchdog_timer_1_inst_din -100
      }

 set avmm_reset_in_sync_1_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset_in_sync_1_inst0|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset_in_sync_1_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset_in_sync_1_sync_inst_din 100
	  set_min_delay  -to $avmm_reset_in_sync_1_sync_inst_din -100
      }
	  
 set avmm_reset_ip_sync_1_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset_ip_sync_1_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset_ip_sync_1_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset_ip_sync_1_sync_inst_din 100
	  set_min_delay  -to $avmm_reset_ip_sync_1_sync_inst_din -100
      }

 set d_store_cnoc_clk_1_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|d_store_cnoc_clk_1_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $d_store_cnoc_clk_1_sync_inst_din] > 0} {
	  set_max_delay  -to $d_store_cnoc_clk_1_sync_inst_din 100
	  set_min_delay  -to $d_store_cnoc_clk_1_sync_inst_din -100
      }
 set d_store_core_clk_1_limit_inst_din [get_registers -nowarn $ip_inst_name|x_sip|d_store_core_clk_1_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $d_store_core_clk_1_limit_inst_din] > 0} {
	  set_max_delay  -to $d_store_core_clk_1_limit_inst_din 100
	  set_min_delay  -to $d_store_core_clk_1_limit_inst_din -100
      }

 set avmm_reset2_1_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset2_1_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset2_1_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset2_1_sync_inst_din 100
	  set_min_delay  -to $avmm_reset2_1_sync_inst_din -100
      }
   set cnoc_1_count_limit_inst_din [get_registers -nowarn $ip_inst_name|x_sip|cnoc_1_count_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $cnoc_1_count_limit_inst_din] > 0} {
	  set_max_delay  -to $cnoc_1_count_limit_inst_din 100
	  set_min_delay  -to $cnoc_1_count_limit_inst_din -100
      }
	  
  set en_refclk_fgt_1_sync_din [get_registers -nowarn $ip_inst_name|x_sip|en_refclk_fgt_1_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $en_refclk_fgt_1_sync_din] > 0} {
	  set_max_delay  -to $en_refclk_fgt_1_sync_din 100
	  set_min_delay  -to $en_refclk_fgt_1_sync_din -100
      }
   set monitor_1_chickenbit_core_din [get_registers -nowarn $ip_inst_name|x_sip|monitor_1_chickenbit_core_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $monitor_1_chickenbit_core_din] > 0} {
	  set_max_delay  -to $monitor_1_chickenbit_core_din 100
	  set_min_delay  -to $monitor_1_chickenbit_core_din -100
      }
   set monitor_1_chickenbit_sync_din [get_registers -nowarn $ip_inst_name|x_sip|monitor_1_chickenbit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $monitor_1_chickenbit_sync_din] > 0} {
	  set_max_delay  -to $monitor_1_chickenbit_sync_din 100
	  set_min_delay  -to $monitor_1_chickenbit_sync_din -100
      }
   set one_state_1_store_sync_din [get_registers -nowarn $ip_inst_name|x_sip|one_state_1_store_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $one_state_1_store_sync_din] > 0} {
	  set_max_delay  -to $one_state_1_store_sync_din 100
	  set_min_delay  -to $one_state_1_store_sync_din -100
      }
    set refclk_fgt_enabled_1_st_sync_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_fgt_enabled_1_st_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_fgt_enabled_1_st_sync_din] > 0} {
	  set_max_delay  -to $refclk_fgt_enabled_1_st_sync_din 100
	  set_min_delay  -to $refclk_fgt_enabled_1_st_sync_din -100
      }
    set refclk_monitor_1_sync_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_monitor_1_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_monitor_1_sync_din] > 0} {
	  set_max_delay  -to $refclk_monitor_1_sync_din 100
	  set_min_delay  -to $refclk_monitor_1_sync_din -100
      }

	set store_cnoc_clk_1_limit_sync_din [get_registers -nowarn $ip_inst_name|x_sip|store_cnoc_clk_1_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $store_cnoc_clk_1_limit_sync_din] > 0} {
	  set_max_delay  -to $store_cnoc_clk_1_limit_sync_din 100
	  set_min_delay  -to $store_cnoc_clk_1_limit_sync_din -100
      }
     	set in_coreclk_1_div_sync_inst_sync_din [get_registers -nowarn $ip_inst_name|x_sip|in_coreclk_1_div_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $in_coreclk_1_div_sync_inst_sync_din] > 0} {
	  set_max_delay  -to $in_coreclk_1_div_sync_inst_sync_din 100
	  set_min_delay  -to $in_coreclk_1_div_sync_inst_sync_din -100
      }

      set no_coreclk_1_div_sync_inst_sync_din [get_registers -nowarn $ip_inst_name|x_sip|no_coreclk_1_div_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $no_coreclk_1_div_sync_inst_sync_din] > 0} {
	  set_max_delay  -to $no_coreclk_1_div_sync_inst_sync_din 100
	  set_min_delay  -to $no_coreclk_1_div_sync_inst_sync_din -100
      }

      set refclk_count1_data_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_count1_data_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_count1_data_sync_inst_din] > 0} {
	  set_max_delay  -to $refclk_count1_data_sync_inst_din 100
	  set_min_delay  -to $refclk_count1_data_sync_inst_din -100
      }



foreach_in_collection node2 [get_nodes $ip_inst_name|x_sip|refclk_fgt_passthru[2].coreclk_enabled.coreclk_sdc|clk] {
    foreach edge1 [get_node_info -synch_edges $node2] {
        set clk_name  [get_node_info -name [get_edge_info -src $edge1]]
        set freq [expr 156250000 / 1000000.0]
        create_clock -period "$freq MHz" -name $clk_name $clk_name
    }
}


set enable_refclk_watchdog_timer_2_inst_din [get_registers -nowarn $ip_inst_name|x_sip|enable_refclk_watchdog_timer_2_inst0|resync_chains[0].synchronizer_nocut|din_s11]
      if {[get_collection_size $enable_refclk_watchdog_timer_2_inst_din] > 0} {
	  set_max_delay  -to $enable_refclk_watchdog_timer_2_inst_din 100
	  set_min_delay  -to $enable_refclk_watchdog_timer_2_inst_din -100
      }

 set avmm_reset_in_sync_2_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset_in_sync_2_inst0|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset_in_sync_2_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset_in_sync_2_sync_inst_din 100
	  set_min_delay  -to $avmm_reset_in_sync_2_sync_inst_din -100
      }
	  
 set avmm_reset_ip_sync_2_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset_ip_sync_2_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset_ip_sync_2_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset_ip_sync_2_sync_inst_din 100
	  set_min_delay  -to $avmm_reset_ip_sync_2_sync_inst_din -100
      }

 set d_store_cnoc_clk_2_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|d_store_cnoc_clk_2_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $d_store_cnoc_clk_2_sync_inst_din] > 0} {
	  set_max_delay  -to $d_store_cnoc_clk_2_sync_inst_din 100
	  set_min_delay  -to $d_store_cnoc_clk_2_sync_inst_din -100
      }
 set d_store_core_clk_2_limit_inst_din [get_registers -nowarn $ip_inst_name|x_sip|d_store_core_clk_2_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $d_store_core_clk_2_limit_inst_din] > 0} {
	  set_max_delay  -to $d_store_core_clk_2_limit_inst_din 100
	  set_min_delay  -to $d_store_core_clk_2_limit_inst_din -100
      }

 set avmm_reset2_2_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset2_2_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset2_2_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset2_2_sync_inst_din 100
	  set_min_delay  -to $avmm_reset2_2_sync_inst_din -100
      }
   set cnoc_2_count_limit_inst_din [get_registers -nowarn $ip_inst_name|x_sip|cnoc_2_count_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $cnoc_2_count_limit_inst_din] > 0} {
	  set_max_delay  -to $cnoc_2_count_limit_inst_din 100
	  set_min_delay  -to $cnoc_2_count_limit_inst_din -100
      }
	  
  set en_refclk_fgt_2_sync_din [get_registers -nowarn $ip_inst_name|x_sip|en_refclk_fgt_2_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $en_refclk_fgt_2_sync_din] > 0} {
	  set_max_delay  -to $en_refclk_fgt_2_sync_din 100
	  set_min_delay  -to $en_refclk_fgt_2_sync_din -100
      }
   set monitor_2_chickenbit_core_din [get_registers -nowarn $ip_inst_name|x_sip|monitor_2_chickenbit_core_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $monitor_2_chickenbit_core_din] > 0} {
	  set_max_delay  -to $monitor_2_chickenbit_core_din 100
	  set_min_delay  -to $monitor_2_chickenbit_core_din -100
      }
   set monitor_2_chickenbit_sync_din [get_registers -nowarn $ip_inst_name|x_sip|monitor_2_chickenbit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $monitor_2_chickenbit_sync_din] > 0} {
	  set_max_delay  -to $monitor_2_chickenbit_sync_din 100
	  set_min_delay  -to $monitor_2_chickenbit_sync_din -100
      }
   set one_state_2_store_sync_din [get_registers -nowarn $ip_inst_name|x_sip|one_state_2_store_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $one_state_2_store_sync_din] > 0} {
	  set_max_delay  -to $one_state_2_store_sync_din 100
	  set_min_delay  -to $one_state_2_store_sync_din -100
      }
    set refclk_fgt_enabled_2_st_sync_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_fgt_enabled_2_st_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_fgt_enabled_2_st_sync_din] > 0} {
	  set_max_delay  -to $refclk_fgt_enabled_2_st_sync_din 100
	  set_min_delay  -to $refclk_fgt_enabled_2_st_sync_din -100
      }
    set refclk_monitor_2_sync_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_monitor_2_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_monitor_2_sync_din] > 0} {
	  set_max_delay  -to $refclk_monitor_2_sync_din 100
	  set_min_delay  -to $refclk_monitor_2_sync_din -100
      }

	set store_cnoc_clk_2_limit_sync_din [get_registers -nowarn $ip_inst_name|x_sip|store_cnoc_clk_2_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $store_cnoc_clk_2_limit_sync_din] > 0} {
	  set_max_delay  -to $store_cnoc_clk_2_limit_sync_din 100
	  set_min_delay  -to $store_cnoc_clk_2_limit_sync_din -100
      }
     	set in_coreclk_2_div_sync_inst_sync_din [get_registers -nowarn $ip_inst_name|x_sip|in_coreclk_2_div_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $in_coreclk_2_div_sync_inst_sync_din] > 0} {
	  set_max_delay  -to $in_coreclk_2_div_sync_inst_sync_din 100
	  set_min_delay  -to $in_coreclk_2_div_sync_inst_sync_din -100
      }

      set no_coreclk_2_div_sync_inst_sync_din [get_registers -nowarn $ip_inst_name|x_sip|no_coreclk_2_div_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $no_coreclk_2_div_sync_inst_sync_din] > 0} {
	  set_max_delay  -to $no_coreclk_2_div_sync_inst_sync_din 100
	  set_min_delay  -to $no_coreclk_2_div_sync_inst_sync_din -100
      }

      set refclk_count2_data_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_count2_data_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_count2_data_sync_inst_din] > 0} {
	  set_max_delay  -to $refclk_count2_data_sync_inst_din 100
	  set_min_delay  -to $refclk_count2_data_sync_inst_din -100
      }



foreach_in_collection node2 [get_nodes $ip_inst_name|x_sip|refclk_fgt_passthru[3].coreclk_enabled.coreclk_sdc|clk] {
    foreach edge1 [get_node_info -synch_edges $node2] {
        set clk_name  [get_node_info -name [get_edge_info -src $edge1]]
        set freq [expr 156250000 / 1000000.0]
        create_clock -period "$freq MHz" -name $clk_name $clk_name
    }
}


set enable_refclk_watchdog_timer_3_inst_din [get_registers -nowarn $ip_inst_name|x_sip|enable_refclk_watchdog_timer_3_inst0|resync_chains[0].synchronizer_nocut|din_s11]
      if {[get_collection_size $enable_refclk_watchdog_timer_3_inst_din] > 0} {
	  set_max_delay  -to $enable_refclk_watchdog_timer_3_inst_din 100
	  set_min_delay  -to $enable_refclk_watchdog_timer_3_inst_din -100
      }

 set avmm_reset_in_sync_3_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset_in_sync_3_inst0|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset_in_sync_3_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset_in_sync_3_sync_inst_din 100
	  set_min_delay  -to $avmm_reset_in_sync_3_sync_inst_din -100
      }
	  
 set avmm_reset_ip_sync_3_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset_ip_sync_3_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset_ip_sync_3_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset_ip_sync_3_sync_inst_din 100
	  set_min_delay  -to $avmm_reset_ip_sync_3_sync_inst_din -100
      }

 set d_store_cnoc_clk_3_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|d_store_cnoc_clk_3_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $d_store_cnoc_clk_3_sync_inst_din] > 0} {
	  set_max_delay  -to $d_store_cnoc_clk_3_sync_inst_din 100
	  set_min_delay  -to $d_store_cnoc_clk_3_sync_inst_din -100
      }
 set d_store_core_clk_3_limit_inst_din [get_registers -nowarn $ip_inst_name|x_sip|d_store_core_clk_3_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $d_store_core_clk_3_limit_inst_din] > 0} {
	  set_max_delay  -to $d_store_core_clk_3_limit_inst_din 100
	  set_min_delay  -to $d_store_core_clk_3_limit_inst_din -100
      }

 set avmm_reset2_3_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset2_3_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset2_3_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset2_3_sync_inst_din 100
	  set_min_delay  -to $avmm_reset2_3_sync_inst_din -100
      }
   set cnoc_3_count_limit_inst_din [get_registers -nowarn $ip_inst_name|x_sip|cnoc_3_count_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $cnoc_3_count_limit_inst_din] > 0} {
	  set_max_delay  -to $cnoc_3_count_limit_inst_din 100
	  set_min_delay  -to $cnoc_3_count_limit_inst_din -100
      }
	  
  set en_refclk_fgt_3_sync_din [get_registers -nowarn $ip_inst_name|x_sip|en_refclk_fgt_3_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $en_refclk_fgt_3_sync_din] > 0} {
	  set_max_delay  -to $en_refclk_fgt_3_sync_din 100
	  set_min_delay  -to $en_refclk_fgt_3_sync_din -100
      }
   set monitor_3_chickenbit_core_din [get_registers -nowarn $ip_inst_name|x_sip|monitor_3_chickenbit_core_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $monitor_3_chickenbit_core_din] > 0} {
	  set_max_delay  -to $monitor_3_chickenbit_core_din 100
	  set_min_delay  -to $monitor_3_chickenbit_core_din -100
      }
   set monitor_3_chickenbit_sync_din [get_registers -nowarn $ip_inst_name|x_sip|monitor_3_chickenbit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $monitor_3_chickenbit_sync_din] > 0} {
	  set_max_delay  -to $monitor_3_chickenbit_sync_din 100
	  set_min_delay  -to $monitor_3_chickenbit_sync_din -100
      }
   set one_state_3_store_sync_din [get_registers -nowarn $ip_inst_name|x_sip|one_state_3_store_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $one_state_3_store_sync_din] > 0} {
	  set_max_delay  -to $one_state_3_store_sync_din 100
	  set_min_delay  -to $one_state_3_store_sync_din -100
      }
    set refclk_fgt_enabled_3_st_sync_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_fgt_enabled_3_st_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_fgt_enabled_3_st_sync_din] > 0} {
	  set_max_delay  -to $refclk_fgt_enabled_3_st_sync_din 100
	  set_min_delay  -to $refclk_fgt_enabled_3_st_sync_din -100
      }
    set refclk_monitor_3_sync_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_monitor_3_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_monitor_3_sync_din] > 0} {
	  set_max_delay  -to $refclk_monitor_3_sync_din 100
	  set_min_delay  -to $refclk_monitor_3_sync_din -100
      }

	set store_cnoc_clk_3_limit_sync_din [get_registers -nowarn $ip_inst_name|x_sip|store_cnoc_clk_3_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $store_cnoc_clk_3_limit_sync_din] > 0} {
	  set_max_delay  -to $store_cnoc_clk_3_limit_sync_din 100
	  set_min_delay  -to $store_cnoc_clk_3_limit_sync_din -100
      }
     	set in_coreclk_3_div_sync_inst_sync_din [get_registers -nowarn $ip_inst_name|x_sip|in_coreclk_3_div_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $in_coreclk_3_div_sync_inst_sync_din] > 0} {
	  set_max_delay  -to $in_coreclk_3_div_sync_inst_sync_din 100
	  set_min_delay  -to $in_coreclk_3_div_sync_inst_sync_din -100
      }

      set no_coreclk_3_div_sync_inst_sync_din [get_registers -nowarn $ip_inst_name|x_sip|no_coreclk_3_div_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $no_coreclk_3_div_sync_inst_sync_din] > 0} {
	  set_max_delay  -to $no_coreclk_3_div_sync_inst_sync_din 100
	  set_min_delay  -to $no_coreclk_3_div_sync_inst_sync_din -100
      }

      set refclk_count3_data_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_count3_data_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_count3_data_sync_inst_din] > 0} {
	  set_max_delay  -to $refclk_count3_data_sync_inst_din 100
	  set_min_delay  -to $refclk_count3_data_sync_inst_din -100
      }



foreach_in_collection node2 [get_nodes $ip_inst_name|x_sip|refclk_fgt_passthru[4].coreclk_enabled.coreclk_sdc|clk] {
    foreach edge1 [get_node_info -synch_edges $node2] {
        set clk_name  [get_node_info -name [get_edge_info -src $edge1]]
        set freq [expr 156250000 / 1000000.0]
        create_clock -period "$freq MHz" -name $clk_name $clk_name
    }
}


set enable_refclk_watchdog_timer_4_inst_din [get_registers -nowarn $ip_inst_name|x_sip|enable_refclk_watchdog_timer_4_inst0|resync_chains[0].synchronizer_nocut|din_s11]
      if {[get_collection_size $enable_refclk_watchdog_timer_4_inst_din] > 0} {
	  set_max_delay  -to $enable_refclk_watchdog_timer_4_inst_din 100
	  set_min_delay  -to $enable_refclk_watchdog_timer_4_inst_din -100
      }

 set avmm_reset_in_sync_4_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset_in_sync_4_inst0|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset_in_sync_4_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset_in_sync_4_sync_inst_din 100
	  set_min_delay  -to $avmm_reset_in_sync_4_sync_inst_din -100
      }
	  
 set avmm_reset_ip_sync_4_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset_ip_sync_4_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset_ip_sync_4_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset_ip_sync_4_sync_inst_din 100
	  set_min_delay  -to $avmm_reset_ip_sync_4_sync_inst_din -100
      }

 set d_store_cnoc_clk_4_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|d_store_cnoc_clk_4_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $d_store_cnoc_clk_4_sync_inst_din] > 0} {
	  set_max_delay  -to $d_store_cnoc_clk_4_sync_inst_din 100
	  set_min_delay  -to $d_store_cnoc_clk_4_sync_inst_din -100
      }
 set d_store_core_clk_4_limit_inst_din [get_registers -nowarn $ip_inst_name|x_sip|d_store_core_clk_4_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $d_store_core_clk_4_limit_inst_din] > 0} {
	  set_max_delay  -to $d_store_core_clk_4_limit_inst_din 100
	  set_min_delay  -to $d_store_core_clk_4_limit_inst_din -100
      }

 set avmm_reset2_4_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset2_4_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset2_4_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset2_4_sync_inst_din 100
	  set_min_delay  -to $avmm_reset2_4_sync_inst_din -100
      }
   set cnoc_4_count_limit_inst_din [get_registers -nowarn $ip_inst_name|x_sip|cnoc_4_count_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $cnoc_4_count_limit_inst_din] > 0} {
	  set_max_delay  -to $cnoc_4_count_limit_inst_din 100
	  set_min_delay  -to $cnoc_4_count_limit_inst_din -100
      }
	  
  set en_refclk_fgt_4_sync_din [get_registers -nowarn $ip_inst_name|x_sip|en_refclk_fgt_4_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $en_refclk_fgt_4_sync_din] > 0} {
	  set_max_delay  -to $en_refclk_fgt_4_sync_din 100
	  set_min_delay  -to $en_refclk_fgt_4_sync_din -100
      }
   set monitor_4_chickenbit_core_din [get_registers -nowarn $ip_inst_name|x_sip|monitor_4_chickenbit_core_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $monitor_4_chickenbit_core_din] > 0} {
	  set_max_delay  -to $monitor_4_chickenbit_core_din 100
	  set_min_delay  -to $monitor_4_chickenbit_core_din -100
      }
   set monitor_4_chickenbit_sync_din [get_registers -nowarn $ip_inst_name|x_sip|monitor_4_chickenbit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $monitor_4_chickenbit_sync_din] > 0} {
	  set_max_delay  -to $monitor_4_chickenbit_sync_din 100
	  set_min_delay  -to $monitor_4_chickenbit_sync_din -100
      }
   set one_state_4_store_sync_din [get_registers -nowarn $ip_inst_name|x_sip|one_state_4_store_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $one_state_4_store_sync_din] > 0} {
	  set_max_delay  -to $one_state_4_store_sync_din 100
	  set_min_delay  -to $one_state_4_store_sync_din -100
      }
    set refclk_fgt_enabled_4_st_sync_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_fgt_enabled_4_st_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_fgt_enabled_4_st_sync_din] > 0} {
	  set_max_delay  -to $refclk_fgt_enabled_4_st_sync_din 100
	  set_min_delay  -to $refclk_fgt_enabled_4_st_sync_din -100
      }
    set refclk_monitor_4_sync_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_monitor_4_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_monitor_4_sync_din] > 0} {
	  set_max_delay  -to $refclk_monitor_4_sync_din 100
	  set_min_delay  -to $refclk_monitor_4_sync_din -100
      }

	set store_cnoc_clk_4_limit_sync_din [get_registers -nowarn $ip_inst_name|x_sip|store_cnoc_clk_4_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $store_cnoc_clk_4_limit_sync_din] > 0} {
	  set_max_delay  -to $store_cnoc_clk_4_limit_sync_din 100
	  set_min_delay  -to $store_cnoc_clk_4_limit_sync_din -100
      }
     	set in_coreclk_4_div_sync_inst_sync_din [get_registers -nowarn $ip_inst_name|x_sip|in_coreclk_4_div_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $in_coreclk_4_div_sync_inst_sync_din] > 0} {
	  set_max_delay  -to $in_coreclk_4_div_sync_inst_sync_din 100
	  set_min_delay  -to $in_coreclk_4_div_sync_inst_sync_din -100
      }

      set no_coreclk_4_div_sync_inst_sync_din [get_registers -nowarn $ip_inst_name|x_sip|no_coreclk_4_div_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $no_coreclk_4_div_sync_inst_sync_din] > 0} {
	  set_max_delay  -to $no_coreclk_4_div_sync_inst_sync_din 100
	  set_min_delay  -to $no_coreclk_4_div_sync_inst_sync_din -100
      }

      set refclk_count4_data_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_count4_data_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_count4_data_sync_inst_din] > 0} {
	  set_max_delay  -to $refclk_count4_data_sync_inst_din 100
	  set_min_delay  -to $refclk_count4_data_sync_inst_din -100
      }



foreach_in_collection node2 [get_nodes $ip_inst_name|x_sip|refclk_fgt_passthru[5].coreclk_enabled.coreclk_sdc|clk] {
    foreach edge1 [get_node_info -synch_edges $node2] {
        set clk_name  [get_node_info -name [get_edge_info -src $edge1]]
        set freq [expr 156250000 / 1000000.0]
        create_clock -period "$freq MHz" -name $clk_name $clk_name
    }
}


set enable_refclk_watchdog_timer_5_inst_din [get_registers -nowarn $ip_inst_name|x_sip|enable_refclk_watchdog_timer_5_inst0|resync_chains[0].synchronizer_nocut|din_s11]
      if {[get_collection_size $enable_refclk_watchdog_timer_5_inst_din] > 0} {
	  set_max_delay  -to $enable_refclk_watchdog_timer_5_inst_din 100
	  set_min_delay  -to $enable_refclk_watchdog_timer_5_inst_din -100
      }

 set avmm_reset_in_sync_5_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset_in_sync_5_inst0|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset_in_sync_5_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset_in_sync_5_sync_inst_din 100
	  set_min_delay  -to $avmm_reset_in_sync_5_sync_inst_din -100
      }
	  
 set avmm_reset_ip_sync_5_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset_ip_sync_5_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset_ip_sync_5_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset_ip_sync_5_sync_inst_din 100
	  set_min_delay  -to $avmm_reset_ip_sync_5_sync_inst_din -100
      }

 set d_store_cnoc_clk_5_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|d_store_cnoc_clk_5_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $d_store_cnoc_clk_5_sync_inst_din] > 0} {
	  set_max_delay  -to $d_store_cnoc_clk_5_sync_inst_din 100
	  set_min_delay  -to $d_store_cnoc_clk_5_sync_inst_din -100
      }
 set d_store_core_clk_5_limit_inst_din [get_registers -nowarn $ip_inst_name|x_sip|d_store_core_clk_5_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $d_store_core_clk_5_limit_inst_din] > 0} {
	  set_max_delay  -to $d_store_core_clk_5_limit_inst_din 100
	  set_min_delay  -to $d_store_core_clk_5_limit_inst_din -100
      }

 set avmm_reset2_5_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset2_5_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset2_5_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset2_5_sync_inst_din 100
	  set_min_delay  -to $avmm_reset2_5_sync_inst_din -100
      }
   set cnoc_5_count_limit_inst_din [get_registers -nowarn $ip_inst_name|x_sip|cnoc_5_count_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $cnoc_5_count_limit_inst_din] > 0} {
	  set_max_delay  -to $cnoc_5_count_limit_inst_din 100
	  set_min_delay  -to $cnoc_5_count_limit_inst_din -100
      }
	  
  set en_refclk_fgt_5_sync_din [get_registers -nowarn $ip_inst_name|x_sip|en_refclk_fgt_5_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $en_refclk_fgt_5_sync_din] > 0} {
	  set_max_delay  -to $en_refclk_fgt_5_sync_din 100
	  set_min_delay  -to $en_refclk_fgt_5_sync_din -100
      }
   set monitor_5_chickenbit_core_din [get_registers -nowarn $ip_inst_name|x_sip|monitor_5_chickenbit_core_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $monitor_5_chickenbit_core_din] > 0} {
	  set_max_delay  -to $monitor_5_chickenbit_core_din 100
	  set_min_delay  -to $monitor_5_chickenbit_core_din -100
      }
   set monitor_5_chickenbit_sync_din [get_registers -nowarn $ip_inst_name|x_sip|monitor_5_chickenbit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $monitor_5_chickenbit_sync_din] > 0} {
	  set_max_delay  -to $monitor_5_chickenbit_sync_din 100
	  set_min_delay  -to $monitor_5_chickenbit_sync_din -100
      }
   set one_state_5_store_sync_din [get_registers -nowarn $ip_inst_name|x_sip|one_state_5_store_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $one_state_5_store_sync_din] > 0} {
	  set_max_delay  -to $one_state_5_store_sync_din 100
	  set_min_delay  -to $one_state_5_store_sync_din -100
      }
    set refclk_fgt_enabled_5_st_sync_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_fgt_enabled_5_st_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_fgt_enabled_5_st_sync_din] > 0} {
	  set_max_delay  -to $refclk_fgt_enabled_5_st_sync_din 100
	  set_min_delay  -to $refclk_fgt_enabled_5_st_sync_din -100
      }
    set refclk_monitor_5_sync_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_monitor_5_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_monitor_5_sync_din] > 0} {
	  set_max_delay  -to $refclk_monitor_5_sync_din 100
	  set_min_delay  -to $refclk_monitor_5_sync_din -100
      }

	set store_cnoc_clk_5_limit_sync_din [get_registers -nowarn $ip_inst_name|x_sip|store_cnoc_clk_5_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $store_cnoc_clk_5_limit_sync_din] > 0} {
	  set_max_delay  -to $store_cnoc_clk_5_limit_sync_din 100
	  set_min_delay  -to $store_cnoc_clk_5_limit_sync_din -100
      }
     	set in_coreclk_5_div_sync_inst_sync_din [get_registers -nowarn $ip_inst_name|x_sip|in_coreclk_5_div_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $in_coreclk_5_div_sync_inst_sync_din] > 0} {
	  set_max_delay  -to $in_coreclk_5_div_sync_inst_sync_din 100
	  set_min_delay  -to $in_coreclk_5_div_sync_inst_sync_din -100
      }

      set no_coreclk_5_div_sync_inst_sync_din [get_registers -nowarn $ip_inst_name|x_sip|no_coreclk_5_div_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $no_coreclk_5_div_sync_inst_sync_din] > 0} {
	  set_max_delay  -to $no_coreclk_5_div_sync_inst_sync_din 100
	  set_min_delay  -to $no_coreclk_5_div_sync_inst_sync_din -100
      }

      set refclk_count5_data_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_count5_data_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_count5_data_sync_inst_din] > 0} {
	  set_max_delay  -to $refclk_count5_data_sync_inst_din 100
	  set_min_delay  -to $refclk_count5_data_sync_inst_din -100
      }


set enable_refclk_watchdog_timer_6_inst_din [get_registers -nowarn $ip_inst_name|x_sip|enable_refclk_watchdog_timer_6_inst0|resync_chains[0].synchronizer_nocut|din_s11]
      if {[get_collection_size $enable_refclk_watchdog_timer_6_inst_din] > 0} {
	  set_max_delay  -to $enable_refclk_watchdog_timer_6_inst_din 100
	  set_min_delay  -to $enable_refclk_watchdog_timer_6_inst_din -100
      }

 set avmm_reset_in_sync_6_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset_in_sync_6_inst0|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset_in_sync_6_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset_in_sync_6_sync_inst_din 100
	  set_min_delay  -to $avmm_reset_in_sync_6_sync_inst_din -100
      }
	  
 set avmm_reset_ip_sync_6_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset_ip_sync_6_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset_ip_sync_6_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset_ip_sync_6_sync_inst_din 100
	  set_min_delay  -to $avmm_reset_ip_sync_6_sync_inst_din -100
      }

 set d_store_cnoc_clk_6_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|d_store_cnoc_clk_6_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $d_store_cnoc_clk_6_sync_inst_din] > 0} {
	  set_max_delay  -to $d_store_cnoc_clk_6_sync_inst_din 100
	  set_min_delay  -to $d_store_cnoc_clk_6_sync_inst_din -100
      }
 set d_store_core_clk_6_limit_inst_din [get_registers -nowarn $ip_inst_name|x_sip|d_store_core_clk_6_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $d_store_core_clk_6_limit_inst_din] > 0} {
	  set_max_delay  -to $d_store_core_clk_6_limit_inst_din 100
	  set_min_delay  -to $d_store_core_clk_6_limit_inst_din -100
      }

 set avmm_reset2_6_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset2_6_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset2_6_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset2_6_sync_inst_din 100
	  set_min_delay  -to $avmm_reset2_6_sync_inst_din -100
      }
   set cnoc_6_count_limit_inst_din [get_registers -nowarn $ip_inst_name|x_sip|cnoc_6_count_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $cnoc_6_count_limit_inst_din] > 0} {
	  set_max_delay  -to $cnoc_6_count_limit_inst_din 100
	  set_min_delay  -to $cnoc_6_count_limit_inst_din -100
      }
	  
  set en_refclk_fgt_6_sync_din [get_registers -nowarn $ip_inst_name|x_sip|en_refclk_fgt_6_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $en_refclk_fgt_6_sync_din] > 0} {
	  set_max_delay  -to $en_refclk_fgt_6_sync_din 100
	  set_min_delay  -to $en_refclk_fgt_6_sync_din -100
      }
   set monitor_6_chickenbit_core_din [get_registers -nowarn $ip_inst_name|x_sip|monitor_6_chickenbit_core_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $monitor_6_chickenbit_core_din] > 0} {
	  set_max_delay  -to $monitor_6_chickenbit_core_din 100
	  set_min_delay  -to $monitor_6_chickenbit_core_din -100
      }
   set monitor_6_chickenbit_sync_din [get_registers -nowarn $ip_inst_name|x_sip|monitor_6_chickenbit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $monitor_6_chickenbit_sync_din] > 0} {
	  set_max_delay  -to $monitor_6_chickenbit_sync_din 100
	  set_min_delay  -to $monitor_6_chickenbit_sync_din -100
      }
   set one_state_6_store_sync_din [get_registers -nowarn $ip_inst_name|x_sip|one_state_6_store_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $one_state_6_store_sync_din] > 0} {
	  set_max_delay  -to $one_state_6_store_sync_din 100
	  set_min_delay  -to $one_state_6_store_sync_din -100
      }
    set refclk_fgt_enabled_6_st_sync_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_fgt_enabled_6_st_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_fgt_enabled_6_st_sync_din] > 0} {
	  set_max_delay  -to $refclk_fgt_enabled_6_st_sync_din 100
	  set_min_delay  -to $refclk_fgt_enabled_6_st_sync_din -100
      }
    set refclk_monitor_6_sync_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_monitor_6_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_monitor_6_sync_din] > 0} {
	  set_max_delay  -to $refclk_monitor_6_sync_din 100
	  set_min_delay  -to $refclk_monitor_6_sync_din -100
      }

	set store_cnoc_clk_6_limit_sync_din [get_registers -nowarn $ip_inst_name|x_sip|store_cnoc_clk_6_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $store_cnoc_clk_6_limit_sync_din] > 0} {
	  set_max_delay  -to $store_cnoc_clk_6_limit_sync_din 100
	  set_min_delay  -to $store_cnoc_clk_6_limit_sync_din -100
      }
     	set in_coreclk_6_div_sync_inst_sync_din [get_registers -nowarn $ip_inst_name|x_sip|in_coreclk_6_div_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $in_coreclk_6_div_sync_inst_sync_din] > 0} {
	  set_max_delay  -to $in_coreclk_6_div_sync_inst_sync_din 100
	  set_min_delay  -to $in_coreclk_6_div_sync_inst_sync_din -100
      }

      set no_coreclk_6_div_sync_inst_sync_din [get_registers -nowarn $ip_inst_name|x_sip|no_coreclk_6_div_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $no_coreclk_6_div_sync_inst_sync_din] > 0} {
	  set_max_delay  -to $no_coreclk_6_div_sync_inst_sync_din 100
	  set_min_delay  -to $no_coreclk_6_div_sync_inst_sync_din -100
      }

      set refclk_count6_data_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_count6_data_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_count6_data_sync_inst_din] > 0} {
	  set_max_delay  -to $refclk_count6_data_sync_inst_din 100
	  set_min_delay  -to $refclk_count6_data_sync_inst_din -100
      }


set enable_refclk_watchdog_timer_7_inst_din [get_registers -nowarn $ip_inst_name|x_sip|enable_refclk_watchdog_timer_7_inst0|resync_chains[0].synchronizer_nocut|din_s11]
      if {[get_collection_size $enable_refclk_watchdog_timer_7_inst_din] > 0} {
	  set_max_delay  -to $enable_refclk_watchdog_timer_7_inst_din 100
	  set_min_delay  -to $enable_refclk_watchdog_timer_7_inst_din -100
      }

 set avmm_reset_in_sync_7_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset_in_sync_7_inst0|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset_in_sync_7_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset_in_sync_7_sync_inst_din 100
	  set_min_delay  -to $avmm_reset_in_sync_7_sync_inst_din -100
      }
	  
 set avmm_reset_ip_sync_7_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset_ip_sync_7_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset_ip_sync_7_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset_ip_sync_7_sync_inst_din 100
	  set_min_delay  -to $avmm_reset_ip_sync_7_sync_inst_din -100
      }

 set d_store_cnoc_clk_7_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|d_store_cnoc_clk_7_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $d_store_cnoc_clk_7_sync_inst_din] > 0} {
	  set_max_delay  -to $d_store_cnoc_clk_7_sync_inst_din 100
	  set_min_delay  -to $d_store_cnoc_clk_7_sync_inst_din -100
      }
 set d_store_core_clk_7_limit_inst_din [get_registers -nowarn $ip_inst_name|x_sip|d_store_core_clk_7_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $d_store_core_clk_7_limit_inst_din] > 0} {
	  set_max_delay  -to $d_store_core_clk_7_limit_inst_din 100
	  set_min_delay  -to $d_store_core_clk_7_limit_inst_din -100
      }

 set avmm_reset2_7_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset2_7_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset2_7_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset2_7_sync_inst_din 100
	  set_min_delay  -to $avmm_reset2_7_sync_inst_din -100
      }
   set cnoc_7_count_limit_inst_din [get_registers -nowarn $ip_inst_name|x_sip|cnoc_7_count_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $cnoc_7_count_limit_inst_din] > 0} {
	  set_max_delay  -to $cnoc_7_count_limit_inst_din 100
	  set_min_delay  -to $cnoc_7_count_limit_inst_din -100
      }
	  
  set en_refclk_fgt_7_sync_din [get_registers -nowarn $ip_inst_name|x_sip|en_refclk_fgt_7_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $en_refclk_fgt_7_sync_din] > 0} {
	  set_max_delay  -to $en_refclk_fgt_7_sync_din 100
	  set_min_delay  -to $en_refclk_fgt_7_sync_din -100
      }
   set monitor_7_chickenbit_core_din [get_registers -nowarn $ip_inst_name|x_sip|monitor_7_chickenbit_core_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $monitor_7_chickenbit_core_din] > 0} {
	  set_max_delay  -to $monitor_7_chickenbit_core_din 100
	  set_min_delay  -to $monitor_7_chickenbit_core_din -100
      }
   set monitor_7_chickenbit_sync_din [get_registers -nowarn $ip_inst_name|x_sip|monitor_7_chickenbit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $monitor_7_chickenbit_sync_din] > 0} {
	  set_max_delay  -to $monitor_7_chickenbit_sync_din 100
	  set_min_delay  -to $monitor_7_chickenbit_sync_din -100
      }
   set one_state_7_store_sync_din [get_registers -nowarn $ip_inst_name|x_sip|one_state_7_store_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $one_state_7_store_sync_din] > 0} {
	  set_max_delay  -to $one_state_7_store_sync_din 100
	  set_min_delay  -to $one_state_7_store_sync_din -100
      }
    set refclk_fgt_enabled_7_st_sync_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_fgt_enabled_7_st_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_fgt_enabled_7_st_sync_din] > 0} {
	  set_max_delay  -to $refclk_fgt_enabled_7_st_sync_din 100
	  set_min_delay  -to $refclk_fgt_enabled_7_st_sync_din -100
      }
    set refclk_monitor_7_sync_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_monitor_7_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_monitor_7_sync_din] > 0} {
	  set_max_delay  -to $refclk_monitor_7_sync_din 100
	  set_min_delay  -to $refclk_monitor_7_sync_din -100
      }

	set store_cnoc_clk_7_limit_sync_din [get_registers -nowarn $ip_inst_name|x_sip|store_cnoc_clk_7_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $store_cnoc_clk_7_limit_sync_din] > 0} {
	  set_max_delay  -to $store_cnoc_clk_7_limit_sync_din 100
	  set_min_delay  -to $store_cnoc_clk_7_limit_sync_din -100
      }
     	set in_coreclk_7_div_sync_inst_sync_din [get_registers -nowarn $ip_inst_name|x_sip|in_coreclk_7_div_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $in_coreclk_7_div_sync_inst_sync_din] > 0} {
	  set_max_delay  -to $in_coreclk_7_div_sync_inst_sync_din 100
	  set_min_delay  -to $in_coreclk_7_div_sync_inst_sync_din -100
      }

      set no_coreclk_7_div_sync_inst_sync_din [get_registers -nowarn $ip_inst_name|x_sip|no_coreclk_7_div_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $no_coreclk_7_div_sync_inst_sync_din] > 0} {
	  set_max_delay  -to $no_coreclk_7_div_sync_inst_sync_din 100
	  set_min_delay  -to $no_coreclk_7_div_sync_inst_sync_din -100
      }

      set refclk_count7_data_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_count7_data_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_count7_data_sync_inst_din] > 0} {
	  set_max_delay  -to $refclk_count7_data_sync_inst_din 100
	  set_min_delay  -to $refclk_count7_data_sync_inst_din -100
      }


set enable_refclk_watchdog_timer_8_inst_din [get_registers -nowarn $ip_inst_name|x_sip|enable_refclk_watchdog_timer_8_inst0|resync_chains[0].synchronizer_nocut|din_s11]
      if {[get_collection_size $enable_refclk_watchdog_timer_8_inst_din] > 0} {
	  set_max_delay  -to $enable_refclk_watchdog_timer_8_inst_din 100
	  set_min_delay  -to $enable_refclk_watchdog_timer_8_inst_din -100
      }

 set avmm_reset_in_sync_8_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset_in_sync_8_inst0|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset_in_sync_8_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset_in_sync_8_sync_inst_din 100
	  set_min_delay  -to $avmm_reset_in_sync_8_sync_inst_din -100
      }
	  
 set avmm_reset_ip_sync_8_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset_ip_sync_8_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset_ip_sync_8_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset_ip_sync_8_sync_inst_din 100
	  set_min_delay  -to $avmm_reset_ip_sync_8_sync_inst_din -100
      }

 set d_store_cnoc_clk_8_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|d_store_cnoc_clk_8_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $d_store_cnoc_clk_8_sync_inst_din] > 0} {
	  set_max_delay  -to $d_store_cnoc_clk_8_sync_inst_din 100
	  set_min_delay  -to $d_store_cnoc_clk_8_sync_inst_din -100
      }
 set d_store_core_clk_8_limit_inst_din [get_registers -nowarn $ip_inst_name|x_sip|d_store_core_clk_8_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $d_store_core_clk_8_limit_inst_din] > 0} {
	  set_max_delay  -to $d_store_core_clk_8_limit_inst_din 100
	  set_min_delay  -to $d_store_core_clk_8_limit_inst_din -100
      }

 set avmm_reset2_8_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset2_8_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset2_8_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset2_8_sync_inst_din 100
	  set_min_delay  -to $avmm_reset2_8_sync_inst_din -100
      }
   set cnoc_8_count_limit_inst_din [get_registers -nowarn $ip_inst_name|x_sip|cnoc_8_count_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $cnoc_8_count_limit_inst_din] > 0} {
	  set_max_delay  -to $cnoc_8_count_limit_inst_din 100
	  set_min_delay  -to $cnoc_8_count_limit_inst_din -100
      }
	  
  set en_refclk_fgt_8_sync_din [get_registers -nowarn $ip_inst_name|x_sip|en_refclk_fgt_8_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $en_refclk_fgt_8_sync_din] > 0} {
	  set_max_delay  -to $en_refclk_fgt_8_sync_din 100
	  set_min_delay  -to $en_refclk_fgt_8_sync_din -100
      }
   set monitor_8_chickenbit_core_din [get_registers -nowarn $ip_inst_name|x_sip|monitor_8_chickenbit_core_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $monitor_8_chickenbit_core_din] > 0} {
	  set_max_delay  -to $monitor_8_chickenbit_core_din 100
	  set_min_delay  -to $monitor_8_chickenbit_core_din -100
      }
   set monitor_8_chickenbit_sync_din [get_registers -nowarn $ip_inst_name|x_sip|monitor_8_chickenbit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $monitor_8_chickenbit_sync_din] > 0} {
	  set_max_delay  -to $monitor_8_chickenbit_sync_din 100
	  set_min_delay  -to $monitor_8_chickenbit_sync_din -100
      }
   set one_state_8_store_sync_din [get_registers -nowarn $ip_inst_name|x_sip|one_state_8_store_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $one_state_8_store_sync_din] > 0} {
	  set_max_delay  -to $one_state_8_store_sync_din 100
	  set_min_delay  -to $one_state_8_store_sync_din -100
      }
    set refclk_fgt_enabled_8_st_sync_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_fgt_enabled_8_st_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_fgt_enabled_8_st_sync_din] > 0} {
	  set_max_delay  -to $refclk_fgt_enabled_8_st_sync_din 100
	  set_min_delay  -to $refclk_fgt_enabled_8_st_sync_din -100
      }
    set refclk_monitor_8_sync_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_monitor_8_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_monitor_8_sync_din] > 0} {
	  set_max_delay  -to $refclk_monitor_8_sync_din 100
	  set_min_delay  -to $refclk_monitor_8_sync_din -100
      }

	set store_cnoc_clk_8_limit_sync_din [get_registers -nowarn $ip_inst_name|x_sip|store_cnoc_clk_8_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $store_cnoc_clk_8_limit_sync_din] > 0} {
	  set_max_delay  -to $store_cnoc_clk_8_limit_sync_din 100
	  set_min_delay  -to $store_cnoc_clk_8_limit_sync_din -100
      }
     	set in_coreclk_8_div_sync_inst_sync_din [get_registers -nowarn $ip_inst_name|x_sip|in_coreclk_8_div_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $in_coreclk_8_div_sync_inst_sync_din] > 0} {
	  set_max_delay  -to $in_coreclk_8_div_sync_inst_sync_din 100
	  set_min_delay  -to $in_coreclk_8_div_sync_inst_sync_din -100
      }

      set no_coreclk_8_div_sync_inst_sync_din [get_registers -nowarn $ip_inst_name|x_sip|no_coreclk_8_div_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $no_coreclk_8_div_sync_inst_sync_din] > 0} {
	  set_max_delay  -to $no_coreclk_8_div_sync_inst_sync_din 100
	  set_min_delay  -to $no_coreclk_8_div_sync_inst_sync_din -100
      }

      set refclk_count8_data_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_count8_data_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_count8_data_sync_inst_din] > 0} {
	  set_max_delay  -to $refclk_count8_data_sync_inst_din 100
	  set_min_delay  -to $refclk_count8_data_sync_inst_din -100
      }


set enable_refclk_watchdog_timer_9_inst_din [get_registers -nowarn $ip_inst_name|x_sip|enable_refclk_watchdog_timer_9_inst0|resync_chains[0].synchronizer_nocut|din_s11]
      if {[get_collection_size $enable_refclk_watchdog_timer_9_inst_din] > 0} {
	  set_max_delay  -to $enable_refclk_watchdog_timer_9_inst_din 100
	  set_min_delay  -to $enable_refclk_watchdog_timer_9_inst_din -100
      }

 set avmm_reset_in_sync_9_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset_in_sync_9_inst0|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset_in_sync_9_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset_in_sync_9_sync_inst_din 100
	  set_min_delay  -to $avmm_reset_in_sync_9_sync_inst_din -100
      }
	  
 set avmm_reset_ip_sync_9_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset_ip_sync_9_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset_ip_sync_9_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset_ip_sync_9_sync_inst_din 100
	  set_min_delay  -to $avmm_reset_ip_sync_9_sync_inst_din -100
      }

 set d_store_cnoc_clk_9_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|d_store_cnoc_clk_9_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $d_store_cnoc_clk_9_sync_inst_din] > 0} {
	  set_max_delay  -to $d_store_cnoc_clk_9_sync_inst_din 100
	  set_min_delay  -to $d_store_cnoc_clk_9_sync_inst_din -100
      }
 set d_store_core_clk_9_limit_inst_din [get_registers -nowarn $ip_inst_name|x_sip|d_store_core_clk_9_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $d_store_core_clk_9_limit_inst_din] > 0} {
	  set_max_delay  -to $d_store_core_clk_9_limit_inst_din 100
	  set_min_delay  -to $d_store_core_clk_9_limit_inst_din -100
      }

 set avmm_reset2_9_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset2_9_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset2_9_sync_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset2_9_sync_inst_din 100
	  set_min_delay  -to $avmm_reset2_9_sync_inst_din -100
      }
   set cnoc_9_count_limit_inst_din [get_registers -nowarn $ip_inst_name|x_sip|cnoc_9_count_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $cnoc_9_count_limit_inst_din] > 0} {
	  set_max_delay  -to $cnoc_9_count_limit_inst_din 100
	  set_min_delay  -to $cnoc_9_count_limit_inst_din -100
      }
	  
  set en_refclk_fgt_9_sync_din [get_registers -nowarn $ip_inst_name|x_sip|en_refclk_fgt_9_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $en_refclk_fgt_9_sync_din] > 0} {
	  set_max_delay  -to $en_refclk_fgt_9_sync_din 100
	  set_min_delay  -to $en_refclk_fgt_9_sync_din -100
      }
   set monitor_9_chickenbit_core_din [get_registers -nowarn $ip_inst_name|x_sip|monitor_9_chickenbit_core_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $monitor_9_chickenbit_core_din] > 0} {
	  set_max_delay  -to $monitor_9_chickenbit_core_din 100
	  set_min_delay  -to $monitor_9_chickenbit_core_din -100
      }
   set monitor_9_chickenbit_sync_din [get_registers -nowarn $ip_inst_name|x_sip|monitor_9_chickenbit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $monitor_9_chickenbit_sync_din] > 0} {
	  set_max_delay  -to $monitor_9_chickenbit_sync_din 100
	  set_min_delay  -to $monitor_9_chickenbit_sync_din -100
      }
   set one_state_9_store_sync_din [get_registers -nowarn $ip_inst_name|x_sip|one_state_9_store_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $one_state_9_store_sync_din] > 0} {
	  set_max_delay  -to $one_state_9_store_sync_din 100
	  set_min_delay  -to $one_state_9_store_sync_din -100
      }
    set refclk_fgt_enabled_9_st_sync_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_fgt_enabled_9_st_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_fgt_enabled_9_st_sync_din] > 0} {
	  set_max_delay  -to $refclk_fgt_enabled_9_st_sync_din 100
	  set_min_delay  -to $refclk_fgt_enabled_9_st_sync_din -100
      }
    set refclk_monitor_9_sync_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_monitor_9_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_monitor_9_sync_din] > 0} {
	  set_max_delay  -to $refclk_monitor_9_sync_din 100
	  set_min_delay  -to $refclk_monitor_9_sync_din -100
      }

	set store_cnoc_clk_9_limit_sync_din [get_registers -nowarn $ip_inst_name|x_sip|store_cnoc_clk_9_limit_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $store_cnoc_clk_9_limit_sync_din] > 0} {
	  set_max_delay  -to $store_cnoc_clk_9_limit_sync_din 100
	  set_min_delay  -to $store_cnoc_clk_9_limit_sync_din -100
      }
     	set in_coreclk_9_div_sync_inst_sync_din [get_registers -nowarn $ip_inst_name|x_sip|in_coreclk_9_div_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $in_coreclk_9_div_sync_inst_sync_din] > 0} {
	  set_max_delay  -to $in_coreclk_9_div_sync_inst_sync_din 100
	  set_min_delay  -to $in_coreclk_9_div_sync_inst_sync_din -100
      }

      set no_coreclk_9_div_sync_inst_sync_din [get_registers -nowarn $ip_inst_name|x_sip|no_coreclk_9_div_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $no_coreclk_9_div_sync_inst_sync_din] > 0} {
	  set_max_delay  -to $no_coreclk_9_div_sync_inst_sync_din 100
	  set_min_delay  -to $no_coreclk_9_div_sync_inst_sync_din -100
      }

      set refclk_count9_data_sync_inst_din [get_registers -nowarn $ip_inst_name|x_sip|refclk_count9_data_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclk_count9_data_sync_inst_din] > 0} {
	  set_max_delay  -to $refclk_count9_data_sync_inst_din 100
	  set_min_delay  -to $refclk_count9_data_sync_inst_din -100
      }



    foreach_in_collection node2 [get_nodes -nowarn $ip_inst_name|x_sip|cnoc_clk] {
        set clk_name  [get_node_info -name $node2]
        create_clock -period "250 MHz" -name $clk_name $clk_name
    }


set osc_clks [get_registers -nowarn "${ip_inst_name}|x_sip|*avmm_clk" ]
if {[get_collection_size $osc_clks] > 0} {
create_generated_clock -divide_by 2 \
       -source [get_nodes {*|intosc|oscillator_dut~oscillator_clock}] \
         -name "${ip_inst_name}_divided_osc_clk"  [get_registers "${ip_inst_name}|x_sip|*avmm_clk" ]
}
 set enable_syspll_watchdog_sync_inst0 [get_registers -nowarn $ip_inst_name|x_sip|enable_syspll_watchdog_sync_inst0|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $enable_syspll_watchdog_sync_inst0] > 0} {
	  set_max_delay  -to $enable_syspll_watchdog_sync_inst0 100
	  set_min_delay  -to $enable_syspll_watchdog_sync_inst0 -100
      } 

   set avmm_reset2_sync_inst_inst_din [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset2_sync_inst|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset2_sync_inst_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset2_sync_inst_inst_din 100
	  set_min_delay  -to $avmm_reset2_sync_inst_inst_din -100
      }
   set avmm_reset_in_sync_inst0_inst_din  [get_registers -nowarn $ip_inst_name|x_sip|avmm_reset_in_sync_inst0|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $avmm_reset_in_sync_inst0_inst_din] > 0} {
	  set_max_delay  -to $avmm_reset_in_sync_inst0_inst_din 100
	  set_min_delay  -to $avmm_reset_in_sync_inst0_inst_din -100
      }
   set refclock_ready_sync_inst0_din [get_registers -nowarn $ip_inst_name|x_sip|refclock_ready_sync_inst0|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclock_ready_sync_inst0_din] > 0} {
	  set_max_delay  -to $refclock_ready_sync_inst0_din 100
	  set_min_delay  -to $refclock_ready_sync_inst0_din -100
      }
   set refclock_ready_sync_inst1_din [get_registers -nowarn $ip_inst_name|x_sip|refclock_ready_sync_inst1|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclock_ready_sync_inst1_din] > 0} {
	  set_max_delay  -to $refclock_ready_sync_inst1_din 100
	  set_min_delay  -to $refclock_ready_sync_inst1_din -100
      }
   set refclock_ready_sync_inst2_din [get_registers -nowarn $ip_inst_name|x_sip|refclock_ready_sync_inst2|resync_chains[0].synchronizer_nocut|din_s1]
      if {[get_collection_size $refclock_ready_sync_inst2_din] > 0} {
	  set_max_delay  -to $refclock_ready_sync_inst2_din 100
	  set_min_delay  -to $refclock_ready_sync_inst2_din -100
      }

