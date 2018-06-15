module Compare(
input clk,
input rst,
input [7:0] data_1,
input [7:0] data_2,
input [7:0] data_3,
output reg [7:0] data_min,
output reg [7:0] data_middle,
output reg [7:0] data_max);

    always @ (posedge clk or posedge rst)
	begin
		if(rst)
		begin
			data_max <= 0;
			data_min <= 0;
			data_middle <= 0;
		end
		
		else
		begin
			if(data_1 < data_2)
			begin
				if(data_2 < data_3)
				begin
					data_min <= data_1;
					data_middle <= data_2;
					data_max <= data_3;
				end
				
				else if(data_3 < data_1)
				begin
					data_min <= data_3;
					data_middle <= data_1;
					data_max <= data_2;
				end
				
				else
				begin
					data_min <= data_1;
					data_middle <= data_3;
					data_max <= data_2;
				end
			end
			
			else
			begin
				if(data_1 < data_3)
				begin
					data_min <= data_2;
					data_middle <= data_1;
					data_max <= data_3;
				end
				
				else if(data_3 < data_2)
				begin
					data_min <= data_3;
					data_middle <= data_2;
					data_max <= data_1;
				end
				
				else
				begin
					data_min <= data_2;
					data_middle <= data_3;
					data_max <= data_1;
				end
			end
		end
	end
	
endmodule