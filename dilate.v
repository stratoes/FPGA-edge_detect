module dilate(
input clk,
input rst,
input [10:0] hcount,
input [10:0] vcount,
input erode_value,
output [11:0] dilate_value
);
	parameter Hor_Addr_Time = 800;
	parameter Width = Hor_Addr_Time >> 1;
	parameter Ver_Addr_Time = 600;
	parameter Height = Ver_Addr_Time >> 1;
	
	reg line_buffer_0 [(Width - 1):0];
    reg line_buffer_1 [(Width - 1):0];
    reg line_buffer_2 [(Width - 1):0];
    
    wire pixel[8:0];
    
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
			line_buffer_2[div_two_hcount] <= erode_value;
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
	
	wire or_0, or_1, or_2;
	wire or_all;
	
	assign dilate_value = {12{or_all}};
	
	Or Or_dut_0(
	.clk(clk),
	.rst(rst),
	.data_0(pixel[0]),
	.data_1(pixel[1]),
	.data_2(pixel[2]),
	.result(or_0)
	);
	
	Or Or_dut_1(
	.clk(clk),
	.rst(rst),
	.data_0(pixel[3]),
	.data_1(pixel[4]),
	.data_2(pixel[5]),
	.result(or_1)
	);
	
	Or Or_dut_2(
	.clk(clk),
	.rst(rst),
	.data_0(pixel[6]),
	.data_1(pixel[7]),
	.data_2(pixel[8]),
	.result(or_2)
	);
	
	Or Or_dut_all(
	.clk(clk),
	.rst(rst),
	.data_0(or_0),
	.data_1(or_1),
	.data_2(or_2),
	.result(or_all));
	
endmodule