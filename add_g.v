module add_g(
input clk,
input rst,
input [10:0] data_0,
input [10:0] data_1,
output reg signed [11:0] result);

	always @ (posedge clk)
	begin
		if(rst)
			result <= 0;
		else
			result <= data_1 - data_0;
	end

endmodule