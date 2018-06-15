module Controller(
input clk,
input rst,
input [3:0] Edge,
output [11:0] pixel,
output hs,
output vs
);  

    parameter Hor_Blank_Time = 256;
	parameter Hor_Addr_Time = 800;
	parameter Hor_End_Time = Hor_Blank_Time + Hor_Addr_Time - 1;
	parameter Hor_Pic_End_Time = Hor_Blank_Time + (Hor_Addr_Time >> 1) - 1;
	
	parameter Ver_Blank_Time = 28;
	parameter Ver_Addr_Time = 600;
	parameter Ver_End_Time = Ver_Blank_Time + Ver_Addr_Time - 1;
	parameter Ver_Pic_End_Time = Ver_Blank_Time + (Ver_Addr_Time >> 1) - 1;
    
	wire [10:0] hcount, vcount;
	wire [15:0] douta;
	wire div_clk;
	wire [10:0] latency;
	
	assign latency = (Edge == 4'b0001 ? 6 : (Edge == 4'b0010 ? 9 : (Edge == 4'b0011 ? 13 : (Edge == 4'b0100 ? 15 : (Edge == 4'b0101 ? 17 : 3)))));
	
	Scan scan_dut(
	.rst(rst),
	.clk(div_clk),
	.hcount(hcount),
	.vcount(vcount),
	.hs(hs), 
	.vs(vs));

    wire [16:0] Addr;
	
    wire RealClk;
	wire enable;

	wire [10:0] RealVcount, RealHcount;
	wire [10:0] RealVcount1, RealHcount1; 
	wire [10:0] RealVcount2, RealHcount2; 
	wire [10:0] RealVcount3, RealHcount3; 
	wire [10:0] RealVcount4, RealHcount4;
	wire [10:0] RealVcount5, RealHcount5;
	
	//当前hs和vs对应的显示块中的位置
    assign RealVcount = vcount - Ver_Blank_Time;
	assign RealHcount = hcount - Hor_Blank_Time + latency;
	
	assign RealVcount1 = (Edge >= 4'b0010 ? (RealVcount2 + 2) : RealVcount2);
	assign RealHcount1 = (Edge >= 4'b0010 ? (RealHcount2 + 2) : RealHcount2);
	
	assign RealVcount2 = (Edge >= 4'b0011 ? (RealVcount3 + 2) : RealVcount3);
	assign RealHcount2 = (Edge >= 4'b0011 ? (RealHcount3 + 2) : RealHcount3);
	
	assign RealVcount3 = (Edge >= 4'b0100 ? (RealVcount4 + 2) : RealVcount4);
	assign RealHcount3 = (Edge >= 4'b0100 ? (RealHcount4 + 2) : RealHcount4);
	
	assign RealVcount4 = (Edge >= 4'b0101 ? (RealVcount5 + 2) : RealVcount5);
	assign RealHcount4 = (Edge >= 4'b0101 ? (RealHcount5 + 2) : RealHcount5);
	
	assign RealVcount5 = RealVcount;
	assign RealHcount5 = RealHcount;
	
	assign enable = (vcount >= Ver_Blank_Time && vcount <= Ver_End_Time) && (hcount >= Hor_Blank_Time && hcount <= Hor_End_Time);
	//assign pic = (vcount >= Ver_Blank_Time && vcount <= Ver_Pic_End_Time) && (hcount >= Hor_Blank_Time && hcount <= Hor_Pic_End_Time);
	
	//计算 RealVcount1 �??? RealHcount1 对应的读出地�???
	GetAddr get_addr_dut(
	.clk(div_clk),
	.rst(rst),
	.hcount(RealHcount1),
	.vcount(RealVcount1),
	.Addr(Addr));
	
    //assign Addr = (RealHcount >> 1) + ((RealVcount >> 1) * 400);
	
	//assign Addr = pic ? (RealHcount + RealVcount * 400) : 0;
    
	//输出地址Addr对应的pixel_value
    blk_mem_gen_0 blk_dut_output_original(
      .clka(div_clk),    // input wire clka
      .addra(Addr),  // input wire [16 : 0] addra
      .douta(douta)  // output wire [15 : 0] douta
    );
	
	wire [7:0] Y;
	
	//计算对应pixel_value的灰�?
	YCrCb YCrCb_dut(
	.clk(div_clk),
	.rst(rst),
	.R(douta[15:11]),
	.G(douta[10:5]),
	.B(douta[4:0]),
	.Y(Y));
	
	wire [7:0] median_filter_pixel_value;
	
	//计算对应灰度的做完中值滤波后的pixel_value
	median_filter median_filter_dut(
	.clk(div_clk),
	.rst(rst),
	.hcount(RealHcount2),
	.vcount(RealVcount2),
	.Y(Y),
	.pixel_value(median_filter_pixel_value)
	);
	
	wire [11:0] sobel_value;
	
	sobel_detect sobel_detect_dut(
	.clk(div_clk),
	.rst(rst),
	.hcount(RealHcount3),
	.vcount(RealVcount3),
	.median_value(median_filter_pixel_value),
	.sobel_value(sobel_value));
    
	wire [11:0] erode_value;
	
	erode erode_dut(
	.clk(div_clk),
	.rst(rst),
	.hcount(RealHcount4),
	.vcount(RealVcount4),
	.sobel_value(sobel_value[0]),
	.erode_value(erode_value));
	
	wire [11:0] dilate_value;
	
	dilate dilate_dut(
	.clk(div_clk),
	.rst(rst),
	.hcount(RealHcount5),
	.vcount(RealVcount5),
	.erode_value(erode_value[0]),
	.dilate_value(dilate_value));
	
	//VGA时序分频
     clk_wiz_0 divider_dut
     (
     // Clock in ports
      .clk(clk),      // input clk
      // Clock out ports
      .div_clk(div_clk),     // output div_clk
      // Status and control signals
      .reset(rst));       // input reset
    
	//输出对应模式下的当前像素
	//assign pixel =  enable ? (pic ? {douta[15:12], douta[10:7], douta[4:1]} : 12'b000000000000) : 12'b000100010001;
	assign pixel =  enable ? 
	                    (Edge == 4'b0001 ? 
	                           {3{Y[7:4]}}
	                             :(Edge == 4'b0010 ?
	                                    {3{median_filter_pixel_value[7:4]}}
	                                    :(Edge == 4'b0011 ?
	                                        sobel_value
	                                        :(Edge == 4'b0100 ?
												erode_value
												:(Edge == 4'b0101 ?
													dilate_value
													:{douta[15:12], douta[10:7], douta[4:1]})))))
	                    :12'b000100010001;
	
endmodule

