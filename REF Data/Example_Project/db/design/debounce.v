module debounce (
	i_clk,
	i_rst_n,
	i_pb_in,
	o_db_pb   
);

	input i_clk;
	input i_rst_n;

	input i_pb_in;

	output o_db_pb;
	
	reg [2:0] r_pb_in;

	assign o_db_pb = &r_pb_in;
		
	always @(posedge i_clk or negedge i_rst_n)
		if (~i_rst_n)
			begin
				r_pb_in <= 3'b111;
			end
		else
			begin
				r_pb_in <= {r_pb_in[1:0],i_pb_in};
			end

endmodule