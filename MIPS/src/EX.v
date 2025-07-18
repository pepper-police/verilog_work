module EX (CLK, RST, Ins, Rdata1, Rdata2, Ed32, nextPC, Result, newPC);
`include "common_param.vh"
input CLK, RST;
input [31:0] Ins, Rdata1, Rdata2, Ed32, nextPC;
output [31:0] Result, newPC;

wire [31:0] MUX2, MUX4, MUX5, alu_res;

assign MUX2 = Ins[31:26] == R_FORM ? Rdata2 : Ed32;
assign MUX4 = alu_res == 0 ? nextPC : (nextPC + (Ed32 << 2));
assign MUX5 = (Ins[31:26] == JALR || Ins[5:0] == JR) ? Rdata1 : // 3
              (Ins[31:26] == J || Ins[5:0] == JAL) ? {nextPC[31:28], (Ins[25:0] << 2)} : // 2
              (Ins[31:26] == BEQ || Ins[31:26] == BNE) ? MUX4 : // 1
               nextPC; // 0

assign alu_res = ALU(Ins, Rdata1, MUX2);
assign Result = alu_res;
assign newPC = MUX5;

function [31:0] ALU(input[31:0] f_Ins, f_Rdata1, f_MUX2);
case(f_Ins[31:26])
    R_FORM:
    case(f_Ins[5:0])
        ADD:
            ALU = f_Rdata1 + f_MUX2;
        ADDU:
            ALU = $unsigned(f_Rdata1) + $unsigned(f_MUX2);
        SUB:
            ALU = f_Rdata1 - f_MUX2;
        SUBU:
            ALU = $unsigned(f_Rdata1) - $unsigned(f_MUX2);
        AND:
            ALU = f_Rdata1 & f_MUX2;
        OR:
            ALU = f_Rdata1 | f_MUX2;
        XOR:
            ALU = f_Rdata1 ^ f_MUX2;
        NOR:
            ALU = ~(f_Rdata1 | f_MUX2);
        SLT:
            ALU = f_Rdata1 < f_MUX2;
        SLTU:
            ALU = $unsigned(f_Rdata1) < $unsigned(f_MUX2);
        default:
            ALU = 32'hxxxxxxxx;
    endcase
    ADDI:
        ALU = f_Rdata1 + f_MUX2;
    ADDIU:
        ALU = $unsigned(f_Rdata1) + $unsigned(f_MUX2);
    SLTI:
        ALU = f_Rdata1 < f_MUX2;
    ANDI:
        ALU = f_Rdata1 & f_MUX2;
    ORI:
        ALU = f_Rdata1 | f_MUX2;
    XORI:
        ALU = f_Rdata1 ^ f_MUX2;
    default:
        ALU = 32'hxxxxxxxx;
endcase
endfunction


endmodule