// Instruction Memory (IM) Module for MIPS Processor
module IM (CLK, RST, WE, W_Ins, PC, Ins);
`include "common_param.vh"
input CLK, RST, WE;
input[31:0] W_Ins, PC;
output[31:0] Ins;

reg [31:0] IMem[0:IMEM_SIZE-1];

initial
begin
    $readmemh("IMem.txt", IMem);
end

always @(posedge CLK)
begin
    if (~RST && WE)
        IMem[PC>>2] <= W_Ins;
end

assign Ins = IMem[PC>>2];

endmodule
