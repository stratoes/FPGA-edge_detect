module YCrCb(
input clk,
input rst,
input [4:0] R,
input [5:0] G,
input [4:0] B,
output [7:0] Y);

    wire [7:0] R0, G0, B0;
    assign R0 = {R, R[4:2]};
    assign G0 = {G, G[5:4]};
    assign B0 = {B, B[4:2]};
    
    reg [15:0] R1, G1, B1;
    
	always @ (posedge clk or posedge rst)
	begin
		if(rst)
		begin
			R1 <= 0;
			G1 <= 0;
			B1 <= 0;
			
		end
		
		else
		begin
			R1 <= R0 * 77;
			G1 <= G0 * 150;
			B1 <= B0 * 29;
		end			
	end
    
	reg [15:0] Y0;
	
	always @ (posedge clk or posedge rst)
	begin
		if(rst)
		begin
			Y0 <= 0;
		end
		
		else
		begin
			Y0 <= R1 + G1 + B1;
		end
	end

	assign Y = Y0[15:8];
	
endmodule