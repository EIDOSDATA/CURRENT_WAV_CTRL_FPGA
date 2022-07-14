//-----------------------------------------------------------------------------
//
// Title       : ci_stim_fpga_wrapper_tb
// Design      : ci_stim_fpga
// Author      : Aldec, Inc
// Company     : Aldec, Inc
//
//-----------------------------------------------------------------------------
//
// File        : ci_stim_fpga_wrapper_TB.v
// Generated   : Fri May 31 13:37:54 2019
// From        : C:\Users\TOPBOY\CloudStation\ToDoc\Design\git.repos\alaska-fpga\design\common\work\sim\ci_stim_fpga\src\TestBench\ci_stim_fpga_wrapper_TB_settings.txt
// By          : tb_verilog.pl ver. ver 1.2s
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------

`timescale 1ns / 10ps 

`define CLK_OFFSET (20)
`define CLK_HALF_PERIOD (150)

module ci_stim_fpga_wrapper_tb;


//Internal signals declarations:
reg r_rst_n;
reg r_in;
reg r_clk;

// input vector generation
initial begin
	r_in = 0;
end

// reset generation
initial begin
  r_rst_n = 0;
  #(100);
  r_rst_n = 1;
end

// simulation time
initial begin
  #(3000_000_000);
  $finish;
end

// clock generation
initial begin
  r_clk = 0;
  forever begin
    r_clk = 0;
	#(`CLK_OFFSET);
	r_clk = 1;
    #(`CLK_HALF_PERIOD);
	r_clk = 0;
	#(`CLK_HALF_PERIOD-`CLK_OFFSET);
	r_clk = 0;
  end
end

always @(*)	force UUT.w_force_clk = r_clk;

// Unit Under Test port map
ci_stim_fpga_wrapper UUT (
	.i_rst_n(r_rst_n),

	.out_sw1_sig(),
	.out_sw2_sig(),
	.out_sw3_sig(),
	.out_sw4_sig(),
	.output_ctrl_sig()
);


endmodule