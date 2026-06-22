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


## SDC when ENABLE_ANLT_GUI=1 ##

#set dir_name [file dirname [info script]] 
#set module_name ftile_400g_eth_eth_f_1800_23upnva

## get current IP instance 
set ip_inst_name [get_current_instance]
# ----------------------------------------------------------------------------- #
proc eth_f_constraint_net_delay {from_reg to_reg max_net_delay {check_exist 0} {get_pins 1}} {
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
    
    if {($check_exist == 0) || ($inst_num > 0)} {
        if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
            set_max_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] 200ns
            set_min_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] -200ns
        } else {
            if {$get_pins == 0} {
                set_net_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] -max $max_net_delay
            } else {
                set_net_delay -from [get_pins -compatibility_mode ${from_reg}|q] -to [get_registers ${to_reg}] -max $max_net_delay
            }
            
            # Relax the fitter effort
            set_max_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] 200ns
            set_min_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] -200ns
        }
    }
}

### readdata

# eth_f_constraint_net_delay  *|ip_inst|sip_inst|rx_status_sync0|resync_chains[*].synchronizer_nocut|dreg[1] \
#			    *|eth_anlt_f_kr_cpu|kr_stat0|readdata[1] \
#			    2.2ns 1 0

# eth_f_constraint_net_delay  *|x_f_tile_soft_reset_ctlr_sip_v1|x_ftile_reset|rst_ctrl|*x_lane_current_state_r[*] \
#			    *|eth_anlt_f_kr_cpu|kr_stat0|readdata[0] \
#			    2.2ns 1 0

eth_f_constraint_net_delay  * \
                               "kr_dut|eth_anlt_f_0|ip_inst|sip_inst|KR_STAT[*].kr_stat_sync_inst|sync[*].synchronizer_nocut_inst|din_s1" \
                                2.2ns 1 0


