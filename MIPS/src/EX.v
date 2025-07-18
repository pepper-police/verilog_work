module EX (CLK, RST, Ins, Rdata1, Rdata2, Ed32, nextPC, Result, newPC);
`include "common_param.vh"
input CLK, RST;
input [31:0] Ins, Rdata1, Rdata2, Ed32, nextPC;
output [31:0] Result, newPC;

wire [31:0] MUX2, MUX4, MUX5;

assign MUX2 = Ins[31:26] == R_FORM ? MUX2 : Ed32;
assign MUX4 = Result == 0 ? nextPC : (nextPC + (Ed32 << 2));
assign MUX5 = (Ins[31:26] == JALR || Ins[5:0] == JR) ? Rdata1 : // 3
              (Ins[31:26] == J || Ins[5:0] == JAL) ? {nextPC[31:28], (Ins[25:0] << 2)} : // 2
              (Ins[31:26] == BEQ || Ins[31:26] == BNE) ? MUX4 : // 1
               nextPC; // 0

assign Result = ALU(Ins, Rdata1, MUX2)

function [31:0] ALU(Ins, Rdata1, MUX2);
input [31:0] Ins, Rdata1, MUX2;
output [31:0] Result;
begin
    case(Ins[31:26])
        R_FORM:
        case(Ins[5:0])
            ADD:
                ALU = Rdata1 + MUX2;
            ADDU:
                ALU = $unsigned(Rdata1) + $unsigned(MUX2);
            SUB:
                ALU = Rdata1 - MUX2;
            SUBU:
                ALU = $unsigned(Rdata1) - $unsigned(MUX2);
            AND:
                ALU = Rdata1 & MUX2;
            OR:
                ALU = Rdata1 | MUX2;
            XOR:
                ALU = Rdata1 ^ MUX2;
            NOR:
                ALU = Rdata1 ~| MUX2;
            SLT:
                ALU = Rdata1 < MUX2;
            SLTU:
                ALU = $unsigned(Rdata1) < $unsigned(MUX2);
        endcase
        ADDI:
            ALU = Rdata1 + MUX2;
        ADDIU:
            ALU = $unsigned(Rdata1) + $unsigned(MUX2);
        SLTI:
            ALU = Rdata1 < MUX2;
        ANDI:
            ALU = Rdata1 & MUX2;
        ORI:
            ALU = Rdata1 | MUX2;
        XORI:
            ALU = Rdata1 ^ MUX2;
        default:
            ALU = 0
    endcase
end
endfunction


endmodule