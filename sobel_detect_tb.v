`timescale 1ns / 1ps
module sobel_detect_tb();
    
    reg clk = 0;
    
    reg [10:0] hcount, vcount;
	reg [7:0] median_value;
    wire [11:0] sobel_value;
    
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
			median_value = vcount;
			#1;
			clk = 0;
			#5;
			
			for(i = 1; i <= 20; i = i + 1)
			begin
				clk = ~clk;
				hcount = hcount + 1;
				median_value = i[7:0] + vcount;
				#1;
				clk = ~clk;
				#5;
			end
			
			vcount = vcount + 1;
		end
    end
    
    sobel_detect sobel_detect_dut(
    .clk(clk),
    .rst(1'b0),
    .hcount(hcount),
    .vcount(vcount),
	.median_value(median_value),
    .sobel_value(sobel_value)
    );
    
endmodule