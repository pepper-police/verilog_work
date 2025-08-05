module SingleCycleClockMIPS (CLK, RST, W_Ins, WE, PC, Result, Rdata1, Rdata2, Wdata, nextPC);
`include "common_param.vh"
  input CLK, RST, WE;
  input [31:0] W_Ins;
  output [31:0] PC, Result, Rdata1, Rdata2, Wdata, nextPC;

  wire [31:0] newPC, nextPC, Ins;
  wire [31:0] Rdata1, Rdata2, Ed32, Wdata;

IF IF0 (.CLK(CLK), .RST(RST), .newPC(newPC), .PC(PC), .W_Ins(W_Ins), .WE(WE), .nextPC(nextPC), .Ins(Ins));
ID ID0 (.CLK(CLK), .RST(RST), .Ins(Ins), .Wdata(Wdata),
      .Rdata1(Rdata1), .Rdata2(Rdata2), .Ed32(Ed32));
EX EX0 (.CLK(CLK), .RST(RST), .Ins(Ins), .Rdata1(Rdata1), .Rdata2(Rdata2),
      .Ed32(Ed32), .nextPC(nextPC), .Result(Result), .newPC(newPC));
MA MA0 (.CLK(CLK), .RST(RST), .Result(Result), .Rdata2(Rdata2), .nextPC(nextPC),
      .Ins(Ins), .Wdata(Wdata));

endmodule
