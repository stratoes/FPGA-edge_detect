module GetAddr(
input clk,
input rst,
input [10:0] hcount,
input [10:0] vcount,
output reg [16:0] Addr = 0
);
    reg [16:0] hcount1 = 0, vcount1 = 0, vcount2 = 0;
    always @ (posedge clk or posedge rst)
    begin
        if(rst)
        begin
            hcount1 <= 0;
            vcount1 <= 0;
        end
        else
        begin
            hcount1 <= (hcount >> 1);
            vcount1 <= (vcount >> 1);
        end
    end
    
    always @ (posedge clk or posedge rst)
        begin
            if(rst)
                vcount2 <= 0;
            else
                vcount2 <= vcount1 * 400;
        end
    
    always @ (posedge clk or posedge rst)
    begin
        if(rst)
            Addr <= 0;
        else
            Addr <= hcount1 + vcount2;
    end
    
endmodule