module mux4 (a, b, sel, y);
input [3:0] a,b;
input sel;
output reg [3:0] y;

always @(a or b or sel)
begin
    if (sel == 0)
        y <= a;
    else
        y <= b;
end
endmodule
