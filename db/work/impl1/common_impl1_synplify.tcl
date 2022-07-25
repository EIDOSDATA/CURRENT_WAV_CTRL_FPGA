#-- Lattice Semiconductor Corporation Ltd.
#-- Synplify OEM project file

#device options
set_option -technology MACHXO2
set_option -part LCMXO2_2000ZE
set_option -package TG100C
set_option -speed_grade -1

#compilation/mapping options
set_option -symbolic_fsm_compiler true
set_option -resource_sharing true

#use verilog 2001 standard option
set_option -vlog_std v2001

#map options
set_option -frequency 100
set_option -maxfan 1000
set_option -auto_constrain_io 0
set_option -disable_io_insertion false
set_option -retiming false; set_option -pipe true
set_option -force_gsr false
set_option -compiler_compatible 0
set_option -dup false

add_file -constraint {C:/Users/hsi74/GitHub/CURRENT_WAV_CTRL_FPGA/CURRENT_WAV_CTRL_FPGA/db/sdc/common.sdc}
set_option -default_enum_encoding default

#simulation options


#timing analysis options



#automatic place and route (vendor) options
set_option -write_apr_constraint 1

#synplifyPro options
set_option -fix_gated_and_generated_clocks 1
set_option -update_models_cp 0
set_option -resolve_multiple_driver 0


set_option -seqshift_no_replicate 0

#-- add_file options
set_option -include_path {C:/Users/hsi74/GitHub/CURRENT_WAV_CTRL_FPGA/CURRENT_WAV_CTRL_FPGA/db/work}
set_option -hdl_define -set "XO2"
add_file -verilog -vlog_std v2001 {C:/Users/hsi74/GitHub/CURRENT_WAV_CTRL_FPGA/CURRENT_WAV_CTRL_FPGA/db/top/ci_stim_fpga.v}

#-- top module name
set_option -top_module ci_stim_fpga_wrapper

#-- set result format/file last
project -result_file {C:/Users/hsi74/GitHub/CURRENT_WAV_CTRL_FPGA/CURRENT_WAV_CTRL_FPGA/db/work/impl1/common_impl1.edi}

#-- error message log file
project -log_file {common_impl1.srf}

#-- set any command lines input by customer


#-- run Synplify with 'arrange HDL file'
project -run
