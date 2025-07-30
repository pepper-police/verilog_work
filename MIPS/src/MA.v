// Memory Access (MA) Module for MIPS Processor
module MA(CLK, RST, Result, Rdata2, nextPC, Ins, Wdata);
`include "common_param.vh"
input CLK, RST;
input[31:0] Result, Rdata2, nextPC, Ins;
output[31:0] Wdata;

wire WE;
wire[31:0] dm_out;

wire [5:0] op, func;
assign op = Ins[31:26];
assign func = Ins[5:0];

assign WE = op == SW;
assign MUX3 = (op == JAL || (op == R_FORM && func == JALR)) ? nextPC : // ジャンプ
              (op == R_FORM || (6'd8 <= op && op <= 6'd15)) ? Result : // I形式算術命令，R形式命令
              (op == LW) ? dm_out : // ロード命令
              32'hxxxxxxxx; // otherwise
assign Wdata = MUX3;

DM DM0(.CLK(CLK), .RST(RST), .WE(WE), .Adr(Result), .WDATA(Rdata2), .Rdata(dm_out));

endmodule
