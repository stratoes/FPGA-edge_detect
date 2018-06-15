`timescale 1ns / 1ps
module erode_tb();
    
    reg clk = 0;
    
    reg [10:0] hcount, vcount;
	reg sobel_value;
    wire [11:0] erode_value;
    
    integer i;
	integer j;
    initial
    begin
        
		vcount = 0;
		#5;
		
		for(j = 0; j <= 10; j = j + 1)
		begin
			hcount = 0;
			clk = 1;
			sobel_value = j[0];
			#1;
			clk = 0;
			#5;
			
			for(i = 1; i <= 20; i = i + 1)
			begin
				clk = ~clk;
				hcount = hcount + 1;
				sobel_value = i[0];
				#1;
				clk = ~clk;
				#5;
			end
			
			vcount = vcount + 1;
		end
    end
    
    erode erode_tb(
    .clk(clk),
    .rst(1'b0),
    .hcount(hcount),
    .vcount(vcount),
	.sobel_value(sobel_value),
    .erode_value(erode_value)
    );
    
endmodule