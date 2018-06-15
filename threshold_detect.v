module threshold_detect(
input clk,
input rst,
input [12:0] length,
output reg [11:0] result);
	
	parameter threshold = 140;
	
	always @ (posedge clk)
	begin
		if(rst)
			result <= 0;
		else
			result <= (length >= threshold ? {12{1'b1}} : 0);
	end

endmodule