`timescale 1ns / 1ps
module median_filter(
input clk,
input rst,
input [10:0] hcount,
input [10:0] vcount,
input [7:0] Y,
output [7:0] pixel_value
);
	parameter Hor_Addr_Time = 800;
	parameter Width = Hor_Addr_Time >> 1;
	parameter Ver_Addr_Time = 600;
	parameter Height = Ver_Addr_Time >> 1;
	
	reg [7:0] line_buffer_0 [(Width - 1):0];
    reg [7:0] line_buffer_1 [(Width - 1):0];
    reg [7:0] line_buffer_2 [(Width - 1):0];
    
    wire [7:0] pixel[8:0];
    wire [7:0] Min[2:0];
    wire [7:0] Middle[2:0];
    wire [7:0] Max[2:0];
	
	wire [7:0] minMax;
	wire [7:0] maxMin;
	wire [7:0] midMid;
     
    
    //wire [7:0] minMax, maxMin, midMid;
	wire [7:0] middlest;
	
    assign pixel_value = (rst ? 8'b0 : middlest);
    
    wire [10:0] div_two_hcount, div_two_vcount;
    
	//wire RealClk;
    //assign RealClk = (~hcount[0]) ? clk : 0;
	
	genvar line_buffer_i;
	generate	
	   for(line_buffer_i = Width - 1; ~line_buffer_i; line_buffer_i = line_buffer_i - 1)
	   begin:Line_0
	       always @ (posedge clk)
	       begin
	           if(~rst && ~vcount[0] && hcount == 0)
	           begin
	               line_buffer_0[line_buffer_i] <= line_buffer_1[line_buffer_i];
	               line_buffer_1[line_buffer_i] <= line_buffer_2[line_buffer_i];
	           end
	       end
	  end
    endgenerate 
    
   always @ (posedge clk)
   begin
	   if(~rst && ~vcount[0] && ~hcount[0])
	   begin
			line_buffer_2[div_two_hcount] <= Y;
	   end
   end
	
	assign div_two_hcount = hcount >> 1;
	assign div_two_vcount = vcount >> 1;
	
	assign pixel[0] = (div_two_hcount >= 2 && div_two_vcount >= 2 && div_two_hcount <= Width + 2 && div_two_vcount <= Height + 2) ? line_buffer_0[div_two_hcount - 2] : 0;
	assign pixel[1] = (div_two_hcount >= 1 && div_two_vcount >= 2 && div_two_hcount <= Width + 1 && div_two_vcount <= Height + 2) ? line_buffer_0[div_two_hcount - 1] : 0;
	assign pixel[2] = (div_two_vcount >= 2 && div_two_hcount <= Width && div_two_vcount <= Height + 2) ? line_buffer_0[div_two_hcount] : 0;
	
	assign pixel[3] = (div_two_hcount >= 2 && div_two_vcount >= 1 && div_two_hcount <= Width + 2 && div_two_vcount <= Height + 1) ? line_buffer_1[div_two_hcount - 2] : 0;
	assign pixel[4] = (div_two_hcount >= 1 && div_two_vcount >= 1 && div_two_hcount <= Width + 1 && div_two_vcount <= Height + 1) ? line_buffer_1[div_two_hcount - 1] : 0;
	assign pixel[5] = (div_two_vcount >= 1 && div_two_hcount <= Width && div_two_vcount <= Height + 1) ? line_buffer_1[div_two_hcount] : 0;
	
	assign pixel[6] = (div_two_hcount >= 2 && div_two_hcount <= Width + 2 && div_two_vcount <= Height) ? line_buffer_2[div_two_hcount - 2] : 0;
	//assign pixel[6] = (div_two_hcount >= 2) ? line_buffer_2[div_two_hcount - 2] : 0;
	assign pixel[7] = (div_two_hcount >= 1 && div_two_hcount <= Width + 1 && div_two_vcount <= Height) ? line_buffer_2[div_two_hcount - 1] : 0;
	assign pixel[8] = (div_two_hcount <= Width && div_two_vcount <= Height) ? line_buffer_2[div_two_hcount] : 0;
	
	Compare cmp_dut0(
	.clk(clk),
	.rst(rst),
	.data_1(pixel[0]),
	.data_2(pixel[1]),
	.data_3(pixel[2]),
	.data_min(Min[0]),
	.data_middle(Middle[0]),
	.data_max(Max[0]));
	
	Compare cmp_dut1(
	.clk(clk),
	.rst(rst),
	.data_1(pixel[3]),
	.data_2(pixel[4]),
	.data_3(pixel[5]),
	.data_min(Min[1]),
	.data_middle(Middle[1]),
	.data_max(Max[1]));
	
	Compare cmp_dut2(
	.clk(clk),
	.rst(rst),
	.data_1(pixel[6]),
	.data_2(pixel[7]),
	.data_3(pixel[8]),
	.data_min(Min[2]), 
	.data_middle(Middle[2]),
	.data_max(Max[2]));
	
	Compare cmp_maxMin(
	.clk(clk),
	.rst(rst),
	.data_1(Min[0]),
	.data_2(Min[1]),
	.data_3(Min[2]),
	.data_max(maxMin));
	
	Compare cmp_midMid(
	.clk(clk),
	.rst(rst),
	.data_1(Middle[0]),
	.data_2(Middle[1]),
	.data_3(Middle[2]),
	.data_middle(midMid));
	
	Compare cmp_minMax(
	.clk(clk),
	.rst(rst),
	.data_1(Max[0]),
	.data_2(Max[1]),
	.data_3(Max[2]),
	.data_min(minMax));
	
	Compare cmp_Middle(
	.clk(clk),
	.rst(rst),
	.data_1(minMax),
	.data_2(midMid),
	.data_3(maxMin),
	.data_middle(middlest));

endmodule