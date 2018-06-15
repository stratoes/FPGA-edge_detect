module Or(
input clk,
input rst,
input data_0,
input data_1,
input data_2,
output reg result);

	always @ (posedge clk)
	begin
		if(rst)
			result <= 0;
		else
			result <= (data_0 | data_1 | data_2);
	end

endmodule