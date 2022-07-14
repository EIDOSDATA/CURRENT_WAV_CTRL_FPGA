`timescale 1ps /1ps 
module PWM_tb;
reg clk;            
wire PWM_out;
wire [7:0] counter_out;
reg [7:0] PWM_CW;
assign counter_out = PWM_inst_1.counter_inst.counter_out;
parameter CYCLE = 2000;
parameter HALF_CYCLE = 1000;

//Added a parameter
parameter pwmCycle = 512000;
//
initial 
begin
  clk=1'b0;
  PWM_inst_1.counter_inst.counter_out=8'b0;
  PWM_CW=8'b00000000;
end


	begin 
		#pwmCycle PWM_CW=PWM_CW+1;
	end
//Changed Part Ends

always
	begin
		#HALF_CYCLE clk = !clk;
	end

PWM_Controller PWM_inst_1 (
	.clk (clk),
	.PWM_CW (PWM_CW),
	.PWM_out (PWM_out)
);
endmodule