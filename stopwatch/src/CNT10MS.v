// 10ms 毎にパルス生成 (100Hz)
module CNT10MS(CLK, RST, SW, EN100HZ);
input CLK, RST, SW;
output EN100HZ;

reg state;

// 500KHz カウンタ 2^19 = 524,288
reg[18:0] cnt;

always @(posedge CLK)
begin
    if (RST)
    begin
        cnt <= 19'b0;
        state <= 1'b0;
    end
    else if (EN100HZ)
        cnt <= 19'b0;
    else if (SW)
        state = ~state;
    else if (state)
        cnt <= cnt + 19'b1;
end

// 100Hz のイネーブル信号
assign EN100HZ = (cnt == 19'd499_999);

endmodule