// Instruction Fetch (IF) Module for MIPS Processor
module IF (CLK, RST, newPC, PC, W_Ins, WE, nextPC, Ins);
`include "common_param.vh"
input CLK, RST, WE;
input[31:0] newPC, W_Ins;
output[31:0] nextPC, Ins;
output reg[31:0] PC;

wire[31:0] im_out;

assign nextPC = PC + 32'd4;
assign Ins = im_out;

always @(posedge CLK or posedge RST)
begin
    if (RST == 1'b1)
        PC <= 32'd0;
    else
        PC <= newPC;
end

IM IM0(.CLK(CLK), .RST(RST), .WE(WE), .W_Ins(W_Ins), .PC(PC), .Ins(im_out));

endmodule
