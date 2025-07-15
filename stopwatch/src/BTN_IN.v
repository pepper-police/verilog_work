module BTN_IN (
    input CLK, RST,  //RST:SW[9]
    input [1:0]   KEY,
    input [1:0]   SW, // sw0, sw2
    output reg  [3:0] BOUT // KEY, SW
);

// 40Hz を作成
reg [20:0] cnt;

wire en40hz = (cnt==1250000-1);

always @(posedge CLK)
begin
    if (RST)
        cnt <= 21'b0;
    else if (en40hz)
        cnt <= 21'b0;
    else
        cnt <= cnt + 21'b1;
end

// ff で受け取り
reg [1:0] KEY_ff1, KEY_ff2, SW_ff1, SW_ff2;

always @(posedge CLK)
begin
    if (RST)
    begin
        KEY_ff1 <= 2'b0;
        KEY_ff2 <= 2'b0;
        SW_ff1 <= 2'b0;
        SW_ff2 <= 2'b0;
    end
    else if (en40hz)
    begin
        KEY_ff1 <= KEY;
        KEY_ff2 <= KEY_ff1;
        SW_ff1 <= SW;
        SW_ff2 <= SW_ff1;
    end
end

// KEY は立下がりを検出
wire [1:0] KEY_wire = ~KEY_ff1 & KEY_ff2 & {2{en40hz}};
// SW は立上りを検出
wire [1:0] SW_wire = SW_ff1 & ~SW_ff2 & {2{en40hz}};

// ff で受ける
always @(posedge CLK)
begin
    if (RST)
        BOUT <= 4'b0;
    else
	     BOUT <= {{KEY_wire[0], KEY_wire[1], SW_wire[0], SW_wire[1]}};
end


endmodule
