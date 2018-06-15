module get_g(
input clk,
input rst,
input [7:0] data_0,
input [7:0] data_1,
input [7:0] data_2,
output reg [10:0] result);

	always @ (posedge clk)
	begin
		if(rst)
			result <= 0;
		else
			result <= data_0 + (data_1 << 1) + data_2;
	end

endmodule