module get_length(
input clk,
input rst,
input signed [11:0] data_0,
input signed [11:0] data_1,
output reg [12:0] result);

	always @ (posedge clk)
	begin
		if(rst)
			result <= 0;
		else
			result <= (data_0 >= 0 ? data_0 : -data_0) + (data_1 >= 0 ? data_1 : -data_1);
	end

endmodule