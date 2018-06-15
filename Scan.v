module Scan(
input rst,
input clk,
output reg[10:0] hcount = 0,
output reg[10:0] vcount = 0,
output hs,
output vs);

    parameter Hor_Sync_Time = 128;
    parameter Hor_Total_Time = 1056;
    parameter Ver_Sync_Time = 4;
    parameter Ver_Total_Time = 628;
    
    assign hs = (hcount < Hor_Sync_Time) ? 0 : 1;
    always @ (posedge clk or posedge rst)
    begin
        if(rst || hcount == Hor_Total_Time - 1)
        begin
            hcount <= 0;
        end
        else
        begin
            hcount <= hcount + 1;
        end
    end
    
    assign vs = (vcount < Ver_Sync_Time) ? 0 : 1;
	always @ (posedge clk or posedge rst)
	begin
		if(rst)
		begin
			vcount <= 0;
		end
		else if(hcount == Hor_Total_Time - 1)
		begin
			if(vcount == Ver_Total_Time - 1)
			begin
				vcount <= 0;
			end
			else
			begin
				vcount <= vcount + 1;
			end
		end
	end
                
endmodule