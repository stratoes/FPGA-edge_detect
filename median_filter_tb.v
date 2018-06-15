`timescale 1ns / 1ps
module median_filter_tb();
    
    reg clk = 0;
    
    reg [10:0] hcount, vcount;
	reg [7:0] Y;
    wire [7:0] pixel_value;
    
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
			Y = vcount;
			#1;
			clk = 0;
			#5;
			
			for(i = 1; i <= 20; i = i + 1)
			begin
				clk = ~clk;
				hcount = hcount + 1;
				Y = i[7:0] + vcount;
				#1;
				clk = ~clk;
				#5;
			end
			
			vcount = vcount + 1;
		end
    end
    
    median_filter filter(
    .clk(clk),
    .rst(1'b0),
    .hcount(hcount),
    .vcount(vcount),
	.Y(Y),
    .pixel_value(pixel_value)
    );
    
endmodule