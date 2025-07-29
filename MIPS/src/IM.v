module DM (CLK, RST, WE, W_Ins, Ins);
input CLK, RST, WE;
input[31:0] W_Ins;
output reg[31:0] Ins;

always @(posedge CLK)
begin
    if (RST)
        Ins <= 32'd0;
    else
    begin
        // wip
    end
end

endmodule
