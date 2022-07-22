setactivelib -work
#Compiling UUT module design files
comp -include C:\Users\TOPBOY\CloudStation\ToDoc\Design\git.repos\alaska-fpga\design\common\source\ci_stim_fpga.v
comp -include "$dsn\src\TestBench\ci_stim_fpga_wrapper_TB.v"
asim +access +r ci_stim_fpga_wrapper_tb

wave
wave -noreg i_rst_n
wave -noreg sw1_a
wave -noreg sw1_b
wave -noreg sw1_pb
wave -noreg sw2_a
wave -noreg sw2_b
wave -noreg sw2_pb
wave -noreg polarity
wave -noreg led_out
wave -noreg lv_dir
wave -noreg lv_oe_n
wave -noreg dummy_low_N15
wave -noreg clk_out
wave -noreg data_out
wave -noreg stim_comp_err
wave -noreg stim_comp_en_n
wave -noreg stim_an
wave -noreg stim_ca
wave -noreg stim_dac0_val
wave -noreg stim_dac1_val
wave -noreg stim_bcg0_sel
wave -noreg stim_bcg1_sel

run

#End simulation macro
