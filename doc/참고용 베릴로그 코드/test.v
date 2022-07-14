`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:20:56 02/04/2015 
// Design Name: 
// Module Name:    top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module test(
	input osc,
	output reg Buzz,
	output reg Relay
    );

reg [1:0]reset_cnt = 0;
reg reset = 1'b1;
always@(posedge osc)
begin
	if(reset==1'b1)
	begin
	reset_cnt <= reset_cnt + 1'b1;
	end 
   if(reset_cnt==2)
	begin
	reset <= 1'b0;
	end
end 

reg [25:0]cnt_RB = 0;
always@(posedge osc or posedge reset)
begin
	if(reset==1'b1)
	begin
		Relay <= 1'b0;
		Buzz <= 1'b0;
		cnt_RB <= 32'd0;
	end 
	else if(cnt_RB==26'd50000000)
	begin
		cnt_RB <= 32'd0;
		Relay <= ~Relay;
		Buzz <= ~Buzz;
	end
	else cnt_RB <= cnt_RB +1'b1;
end

endmodule
