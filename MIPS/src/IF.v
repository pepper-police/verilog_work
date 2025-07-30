// Instruction Fetch (IF) Module for MIPS Processor
module IF (CLK, RST, newPC, PC, W_Ins, WE, nextPC, Ins);
`include "common_param.vh"
input CLK, RST, WE;
input[31:0] newPC, W_Ins;
output nextPC;
output reg[31:0] PC, Ins;

wire[31:0] im_out;

assign nextPC = PC + 32'd4;
assign Ins = im_out;

always @(posedge CLK)
begin
    if (RST)
    begin
        PC <= 32'd0;
        Ins <= 32'd0;
    end
    else
        PC <= newPC;
end

IM IM0(.CLK(CLK), .RST(RST), .WE(WE), .W_Ins(W_Ins), .Ins(im_out));

endmodule
