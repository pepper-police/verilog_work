module MA(CLK, RST, Result, Rdata2, newPC, Ins, Wdata);
`include "common_param.vh"
input CLK, RST;
input[31:0] Result, Rdata2, newPC, Ins;
output[31:0] Wdata;

wire WE;
wire[31:0] dm_out;

wire [5:0] op;
assign op = Ins[31:26];

assign WE = (op == SW) ? 1 : 0;
assign MUX3 = (op == R_FORM) ? Result : // R形式
              (6'd8 <= op && op <= 6'd15) ? Result : // I形式算術命令
              (op == LW) ? dm_out : // ロード命令
              newPC; // otherwise
assign Wdata = MUX3;

DM DM0(.CLK(CLK), .RST(RST), .WE(WE), .Adr(Result), .WDATA(Rdata2), .Rdata(dm_out));

endmodule
