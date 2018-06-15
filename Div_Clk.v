module Divider (
input I_CLK, //输入时钟信号，上升沿有效
input Rst, //同步复位信号，高电平有效
output O_CLK //输出时钟信号，占空比 50%，先低电平后高电平
);
    parameter cycle = 4;
    integer cnt = 0;
    reg reg_O_CLK = 0;
    assign O_CLK = reg_O_CLK;
    always @ (posedge I_CLK)
    begin
        if(Rst == 1)
        begin
            cnt <= 0;
            reg_O_CLK <= 0;
        end
        else
        begin
            cnt = cnt + 1;
            if((cnt << 1) == cycle)
            begin
                reg_O_CLK = ~reg_O_CLK;
                cnt = 0;
            end
            
        end
    end

endmodule