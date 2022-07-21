# clock definitions
create_clock -name rootClk  -period 71 [get_nets w_clk]
create_clock -name ck_sw1_a  -period 10000 [get_nets sw1_a]
create_clock -name ck_sw2_a  -period 10000 [get_nets sw2_a]

create_generated_clock [get_nets w_cg_fsm_clk] \
                       -name ck_cg_fsm \
											 -master_clock [get_clocks rootClk] \
                       -source [get_nets w_clk] \
                       -multiply_by 1

create_generated_clock [get_nets w_div4_clk] \
                       -name ck_div4 \
											 -master_clock [get_clocks rootClk] \
                       -source [get_nets w_clk] \
                       -multiply_by 4
											 
create_generated_clock [get_nets w_div64_clk] \
                       -name ck_div64 \
											 -master_clock [get_clocks rootClk] \
                       -source [get_nets w_clk] \
                       -divide_by 64
											 
create_generated_clock [get_nets w_div64x64_clk] \
                       -name ck_div64x64 \
											 -master_clock [get_clocks ck_div64] \
                       -source [get_nets w_div64_clk] \
                       -divide_by 64

create_generated_clock [get_nets w_db_clk] \
                       -name ck_db \
											 -master_clock [get_clocks ck_div64x64] \
                       -source [get_nets w_div64x64_clk] \
                       -divide_by 2

create_generated_clock [get_nets w_div64x4_clk] \
                       -name ck_div64x4 \
											 -master_clock [get_clocks ck_div64] \
                       -source [get_nets w_div64_clk] \
                       -divide_by 4

create_generated_clock [get_nets w_slow_clk] \
                       -name ck_slow \
											 -master_clock [get_clocks ck_div64x4] \
                       -source [get_nets w_div64x4_clk] \
                       -divide_by 4

# path constraints
#set_false_path -from [get_cells u_i2cSlave.u_registerInterface.swReset] -to [get_cells swReset_s*]
#set_max_delay 40 -from [get_cells rstPipe*]
set_false_path -from [get_clocks rootClk] -to [get_clocks ck_sw1_a]
set_false_path -to [get_clocks rootClk] -from [get_clocks ck_sw1_a]
set_false_path -from [get_clocks rootClk] -to [get_clocks ck_sw2_a]
set_false_path -to [get_clocks rootClk] -from [get_clocks ck_sw2_a]
set_false_path -from [get_clocks ck_sw1_a] -to [get_clocks ck_sw2_a]
set_false_path -to [get_clocks ck_sw1_a] -from [get_clocks ck_sw2_a]
set_false_path -to [get_clocks ck_cg_fsm] -from [get_clocks ck_div4]
set_false_path -from [get_clocks ck_cg_fsm] -to [get_clocks ck_div4]
