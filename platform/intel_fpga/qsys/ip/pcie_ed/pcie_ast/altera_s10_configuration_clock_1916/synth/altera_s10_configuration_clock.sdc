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


# The clock output is 250MHz for -1 to -5 devices
# The clock output is 200 MHz for -6 devices

post_message -type info "\[CONFIG_CLOCK_IP\] You are currently using Agilex 7 with device speedgrade: "
post_message -type info "\[CONFIG_CLOCK_IP\] The clock output is 250 MHz"

if {[get_collection_size [get_clocks altera_int_osc_clk -nowarn]] == 0} {
  	create_clock -name altera_int_osc_clk -period 4.000 [get_nodes {*|intosc|oscillator_dut~oscillator_clock}]
}

#-------------------------------------------------------------------------------------
#--- Please dont make any changes below as it will be used for SDC naming purpose ----
#-------------------------------------------------------------------------------------

proc apply_sdc_pre_config_clock {entity_name} {

set inst_list [get_entity_instances $entity_name]

}

apply_sdc_pre_config_clock altera_s10_configuration_clock
