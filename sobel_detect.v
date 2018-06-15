module sobel_detect(
input clk,
input rst,
input [10:0] hcount,
input [10:0] vcount,
input [7:0] median_value,
output [11:0] sobel_value
);
	parameter Hor_Addr_Time = 800;
	parameter Width = Hor_Addr_Time >> 1;
	parameter Ver_Addr_Time = 600;
	parameter Height = Ver_Addr_Time >> 1;
	
	reg [7:0] line_buffer_0 [(Width - 1):0];
    reg [7:0] line_buffer_1 [(Width - 1):0];
    reg [7:0] line_buffer_2 [(Width - 1):0];
    
    wire [7:0] pixel[8:0];
    
    wire [10:0] div_two_hcount, div_two_vcount;
	
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
			line_buffer_2[div_two_hcount] <= median_value;
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
	assign pixel[7] = (div_two_hcount >= 1 && div_two_hcount <= Width + 1 && div_two_vcount <= Height) ? line_buffer_2[div_two_hcount - 1] : 0;
	assign pixel[8] = (div_two_hcount <= Width && div_two_vcount <= Height) ? line_buffer_2[div_two_hcount] : 0;
	
	wire [10:0] gx_0, gx_2;
	wire [10:0] gy_0, gy_2;
	
	get_g get_g_dut_gx_0(
	.clk(clk),
	.rst(rst),
	.data_0(pixel[0]),
	.data_1(pixel[3]),
	.data_2(pixel[6]),
	.result(gx_0));
	
	get_g get_g_dut_gx_2(
	.clk(clk),
	.rst(rst),
	.data_0(pixel[2]),
	.data_1(pixel[5]),
	.data_2(pixel[8]),
	.result(gx_2));
	
	get_g get_g_dut_gy_0(
	.clk(clk),
	.rst(rst),
	.data_0(pixel[0]),
	.data_1(pixel[1]),
	.data_2(pixel[2]),
	.result(gy_0));
	
	get_g get_g_dut_gy_2(
	.clk(clk),
	.rst(rst),
	.data_0(pixel[6]),
	.data_1(pixel[7]),
	.data_2(pixel[8]),
	.result(gy_2));
	
	wire signed [11:0] gx, gy;
	
	add_g add_dut_gx(
	.clk(clk),
	.rst(rst),
	.data_0(gx_0),
	.data_1(gx_2),
	.result(gx));
	
	add_g add_dut_gy(
	.clk(clk),
	.rst(rst),
	.data_0(gy_2),
	.data_1(gy_0),
	.result(gy));
	
	wire [12:0] length;
	
	get_length get_length_dut(
	.clk(clk),
	.rst(rst),
	.data_0(gx),
	.data_1(gy),
	.result(length));
	
	threshold_detect threshold_detect_dut(
	.clk(clk),
	.rst(rst),
	.length(length),
	.result(sobel_value));
	
endmodule