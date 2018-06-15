`timescale 1ns / 1ps
module YCrCb_tb();
    
    reg clk = 0;
    reg [4:0] R;
    reg [5:0] G;
    reg [4:0] B;
    wire [7:0] Y;
    
    integer i;
	integer j;
	integer k;
	
    initial
    begin
      for(i = 0; i <= 10; i = i + 1)
        for(j = 0; j <= 20; j = j + 1)
          for(k = 0; k <= 20; k = k + 1)
          begin
            R = i[4:0];
            G = j[5:0];
            B = k[4:0];
            #2;
            clk = ~clk;
          end
    end
    
    YCrCb YCrCb_dut(
    .clk(clk),
    .rst(1'b0),
    .R(R),
    .G(G),
    .B(B),
    .Y(Y)
    );
    
endmodule