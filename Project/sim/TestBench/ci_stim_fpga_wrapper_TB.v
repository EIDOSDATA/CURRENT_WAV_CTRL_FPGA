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

module ci_stim_fpga_wrapper_tb;


//Internal signals declarations:
reg r_rst_n;
reg r_sw1_a;
reg r_sw1_b;
reg r_sw1_pb;
reg r_sw2_a;
reg r_sw2_b;
reg r_sw2_pb;
reg [2:0] r_polarity;
wire [7:0] led_out;
wire lv_dir;
wire lv_oe_n;
wire clk_out;
wire data_out;
reg [7:0] r_stim_comp_err;
wire stim_comp_en_n;
wire [7:0] stim_an;
wire [7:0] stim_ca;
wire [7:0] stim_dac0_val;
wire [7:0] stim_dac1_val;
wire [2:0] stim_bcg0_sel;
wire [2:0] stim_bcg1_sel;

initial begin
	r_sw1_a = 0;
	r_sw1_b = 0;
	r_sw1_pb = 0;
	r_sw2_a = 0;
	r_sw2_b = 0;
	r_sw2_pb = 0;	
	r_polarity = 3'd2;
	r_stim_comp_err = 8'b0;
end

initial begin
  r_rst_n = 0;
  #(100) 
  r_rst_n = 1;
end

// Unit Under Test port map
	ci_stim_fpga_wrapper UUT (
		.i_rst_n(r_rst_n),
		.sw1_a(r_sw1_a),
		.sw1_b(r_sw1_b),
		.sw1_pb(r_sw1_pb),
		.sw2_a(r_sw2_a),
		.sw2_b(r_sw2_b),
		.sw2_pb(r_sw2_pb),
		.polarity(r_polarity),
		.led_out(led_out),
		.lv_dir(lv_dir),
		.lv_oe_n(lv_oe_n),
		.clk_out(clk_out),
		.data_out(data_out),
		.stim_comp_err(r_stim_comp_err),
		.stim_comp_en_n(stim_comp_en_n),
		.stim_an(stim_an),
		.stim_ca(stim_ca),
		.stim_dac0_val(stim_dac0_val),
		.stim_dac1_val(stim_dac1_val),
		.stim_bcg0_sel(stim_bcg0_sel),
		.stim_bcg1_sel(stim_bcg1_sel));


endmodule
