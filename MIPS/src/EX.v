module EX (CLK, RST, Ins, Rdata1, Rdata2, Ed32, nextPC, Result, newPC);
`include "common_param.vh"
input CLK, RST;
input [31:0] Ins, Rdata1, Rdata2, Ed32, nextPC;
output [31:0] Result, newPC;

reg [31:0] HI, LO;
wire [31:0] MUX2, MUX4, MUX5, alu_res;

wire [5:0] op, func;
wire [4:0] rs, shamt;
assign op = Ins[31:26];
assign rs = Ins[25:21];
assign shamt = Ins[10:6];
assign func = Ins[5:0];

assign MUX2 = op == R_FORM ? Rdata2 : Ed32;
assign MUX4 = alu_res == 0 ? nextPC : (nextPC + (Ed32 << 2));
assign MUX5 = (op == JALR || Ins[5:0] == JR) ? Rdata1 : // 3
              (op == J || Ins[5:0] == JAL) ? {nextPC[31:28], (Ins[25:0] << 2)} : // 2
              (op == BEQ || op == BNE) ? MUX4 : // 1
               nextPC; // 0

assign alu_res = ALU(op, rs, shamt, func, Rdata1, MUX2, HI, LO);
assign Result = alu_res;
assign newPC = MUX5;

function [31:0] ALU(input[31:0] f_op, f_rs, f_shamt, f_func, f_Rdata1, f_MUX2, f_HI, f_LO);
case(f_op)
    R_FORM:
    case(f_func)
        ADD:
            ALU = $signed(f_Rdata1) + $signed(f_MUX2);
        ADDU:
            ALU = f_Rdata1 + f_MUX2;
        SUB:
            ALU = $signed(f_Rdata1) - $signed(f_MUX2);
        SUBU:
            ALU = f_Rdata1 - f_MUX2;
        AND:
            ALU = f_Rdata1 & f_MUX2;
        OR:
            ALU = f_Rdata1 | f_MUX2;
        XOR:
            ALU = f_Rdata1 ^ f_MUX2;
        NOR:
            ALU = ~(f_Rdata1 | f_MUX2);
        SLT:
            ALU = $signed(f_Rdata1) < $signed(f_MUX2);
        SLTU:
            ALU = f_Rdata1 < f_MUX2;
        SLL:
            ALU = f_Rdata2 << f_shamt;
        SRL:
            ALU = f_Rdata2 >> f_shamt;
        SRA:
            ALU = f_Rdata2 >>> f_shamt;
        SLLV:
            ALU = f_Rdata2 << f_Rdata1;
        SRLV:
            ALU = f_Rdata2 >> f_Rdata1;
        SRAV:
            ALU = f_Rdata2 >>> f_Rdata1;
        MFHI:
            ALU = HI;
        MFLO:
            ALU = LO;
        default:
            ALU = 32'hxxxxxxxx;
    endcase
    ADDI:
        ALU = $signed(f_Rdata1) + $signed(f_MUX2);
    ADDIU:
        ALU = (f_Rdata1) + (f_MUX2);
    SLTI:
        ALU = $signed(f_Rdata1) < $signed(f_MUX2);
    SLTIU:
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

always @(posedge CLK)
begin
    case(op)
        R_FORM:
            case(func)
                MTHI:
                    HI = MUX2;
                MTLO:
                    LO = MUNX2;
                MULT:
                    {HI, LO} = $signed(Rdata1) * $signed(Rdata2);
                MULTU:
                
            endcase
    endcase
end


endmodule