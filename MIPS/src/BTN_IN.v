module BTN_IN (CLK, RST, KEY, SW, KEYOUT, SWOUT);
input CLK, RST;
input[1:0] KEY;
input[9:0] SW;
output reg[1:0] KEYOUT;
output reg[9:0] SWOUT;

reg[20:0] cnt;

wire en40hz = (cnt==1250000-1);

always @( posedge CLK )
begin
    if ( RST )
        cnt <= 21'b0;
    else if ( en40hz )
        cnt <= 21'b0;
    else
        cnt <= cnt + 21'b1;
end

// ボタン入力をFFで受ける
reg[1:0] ff_KEY1, ff_KEY2;
reg[9:0] ff_SW1, ff_SW2;

always @( posedge CLK )
begin
    if ( RST )
    begin
        ff_KEY1 <= 2'b0;
        ff_KEY2 <= 2'b0;
        ff_SW1 <= 10'b0;
        ff_SW2 <= 10'b0;
    end
    else if ( en40hz )
    begin
        ff_KEY2 <= ff_KEY1;
        ff_KEY1 <= KEY;
        ff_SW2 <= ff_SW2;
        ff_SW1 <= SW;
    end
end

// 立下がり検出
wire[1:0] k_tmp = ~ff_KEY1 & ff_KEY2 & {2{en40hz}};
wire[9:0] s_tmp = ~ff_SW1 & ff_SW2 & {10{en40hz}};

always @( posedge CLK )
begin
    if ( RST )
    begin
        KEYOUT <= 2'b0;
        SWOUT <= 10'b0;
    end
    else
    begin
        KEYOUT <= k_tmp;
        SWOUT <= s_tmp;
    end
end

endmodule
