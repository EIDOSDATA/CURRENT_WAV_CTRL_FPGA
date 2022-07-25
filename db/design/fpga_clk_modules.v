module div4_clk (
	i_clk,
	i_rst_n,
	o_gen_clk
 ) ;
 
	input i_clk;
	input i_rst_n;
  
	output o_gen_clk;
  
	reg div4_count;
	reg r_gen_clk;
	
	assign o_gen_clk = r_gen_clk;
		
  
	always @(posedge i_clk or negedge i_rst_n)
		if (~i_rst_n)
			div4_count <= 1;
		else
		if (div4_count == 0)
			div4_count <= 1;
		else
			div4_count <= div4_count - 1;

	always @(posedge i_clk or negedge i_rst_n)
		if (~i_rst_n)
			r_gen_clk <= 0;
		else
		if (div4_count == 0)
			r_gen_clk <= ~r_gen_clk;
	
endmodule
	
module div64_clk (
	i_clk,
	i_rst_n,
	o_gen_clk
);
	input i_clk;
	input i_rst_n;
	
	output o_gen_clk;
	
	reg [4:0] div64_count;
	reg r_gen_clk;
	
	assign o_gen_clk = r_gen_clk;
		
	always @(posedge i_clk or negedge i_rst_n)
		if (~i_rst_n)
			div64_count <= 31;
		else
		if (div64_count == 0)
			div64_count <= 31;
		else
			div64_count <= div64_count - 1;
			
	always @(posedge i_clk or negedge i_rst_n)
		if (~i_rst_n)
			r_gen_clk <= 0;
		else
		if (div64_count == 0)
			r_gen_clk <= ~r_gen_clk;
			


endmodule

module div2_clk (
	i_clk,
	i_rst_n,
	o_gen_clk
);
			
	input i_clk;
	input i_rst_n;
	
	output o_gen_clk;
	
	reg div2_count;
	reg r_gen_clk;
	assign o_gen_clk = r_gen_clk;

	always @(posedge i_clk or negedge i_rst_n)
		if (~i_rst_n)
			div2_count <= 1;
		else
			div2_count <= ~div2_count;
			
	always @(posedge i_clk or negedge i_rst_n)
		if (~i_rst_n)
			r_gen_clk <= 0;
		else
		if (div2_count == 0)
			r_gen_clk <= ~r_gen_clk;	
	
endmodule