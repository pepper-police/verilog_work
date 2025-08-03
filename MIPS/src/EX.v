// Execution (EX) Module for MIPS Processor
module EX (CLK, RST, Ins, Rdata1, Rdata2, Ed32, nextPC, Result, newPC);
`include "common_param.vh"
input CLK, RST;
input [31:0] Ins, Rdata1, Rdata2, Ed32, nextPC;
output [31:0] Result, newPC;

reg [31:0] HI, LO;
wire [31:0] MUX2, MUX4, MUX5, alu_res, b_addr;

wire [5:0] op, func;
wire [4:0] shamt, rt;
wire branch;
assign op = Ins[31:26];
assign rt = Ins[20:16];
assign shamt = Ins[10:6];
assign func = Ins[5:0];

assign branch = (op == BEQ && alu_res == 32'd0) ||
                (op == BNE && alu_res != 32'd0) ||
                (op == BLEZ && $signed(Rdata1) <= 32'd0) ||
                (op == BGTZ && $signed(Rdata1) > 32'd0) ||
                (op == BLTZ && rt == BLTZ_r && $signed(Rdata1) < $signed(32'd0)) ||
                (op == BGEZ && rt == BGEZ_r && $signed(Rdata1) >= $signed(32'd0));
assign b_addr = nextPC + (Ed32 << 2); // 分岐先アドレス
assign MUX2 = (op == R_FORM || op == BEQ || op == BNE) ? Rdata2 : Ed32;
assign MUX4 = branch ? b_addr : nextPC;
assign MUX5 = (op == R_FORM && (func == JR || func == JALR)) ? Rdata1 : // 3
              (op == J || op == JAL) ? {nextPC[31:28], (Ins[25:0] << 2)} : // 2
              (op == BEQ || op == BNE || op == BLEZ || op == BGTZ || (op == BLTZ && rt == BLTZ_r) || (op == BGEZ && rt == BGEZ_r)) ? MUX4 : // 1
              nextPC; // 0

assign alu_res = ALU(op, shamt, func, Rdata1, MUX2, HI, LO);
assign Result = alu_res;
assign newPC = MUX5;

function [31:0] ALU(input[31:0] f_op, f_shamt, f_func, f_Rdata1, f_MUX2, f_HI, f_LO);
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
        SLT: // 32bit値を返す
            ALU = ($signed(f_Rdata1) < $signed(f_MUX2) ? 32'b1: 32'b0);
        SLTU:
            ALU = (f_Rdata1 < f_MUX2 ? 32'b1: 32'b0);
        SLL:
            ALU = f_MUX2 << f_shamt;
        SRL:
            ALU = f_MUX2 >> f_shamt;
        SRA:
            ALU = $signed(f_MUX2) >>> f_shamt;
        SLLV:
            ALU = f_MUX2 << f_Rdata1[4:0];
        SRLV:
            ALU = f_MUX2 >> f_Rdata1[4:0];
        SRAV:
            ALU = $signed(f_MUX2) >>> f_Rdata1[4:0];
        MFHI:
            ALU = f_HI;
        MFLO:
            ALU = f_LO;
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
    BEQ:
        ALU = $signed(f_Rdata1) - $signed(f_MUX2);
    BNE:
        ALU = $signed(f_Rdata1) - $signed(f_MUX2);
    BLEZ:
        ALU = f_Rdata1;
    BGTZ:
        ALU = f_Rdata1;
    LW:
        ALU = f_Rdata1 + f_MUX2;
    SW:
        ALU = f_Rdata1 + f_MUX2;
    default:
        ALU = 32'hxxxxxxxx;
endcase
endfunction

always @(posedge CLK or posedge RST)
begin
    if (RST) begin // 非同期リセット
        HI <= 32'd0;
        LO <= 32'd0;
    end
    else
    begin
        if (op == R_FORM) begin
            case (func)
                MTHI:  HI <= Rdata1; // MTHIはrs(Rdata1)の値をHIへ
                MTLO:  LO <= Rdata1; // MTLOはrs(Rdata1)の値をLOへ
                MULT:  {HI, LO} <= $signed(Rdata1) * $signed(MUX2);
                MULTU: {HI, LO} <= Rdata1 * MUX2;
                DIV:
                begin
                    if (MUX2 != 0)
                    begin
                        LO <= $signed(Rdata1) / $signed(MUX2);
                        HI <= $signed(Rdata1) % $signed(MUX2);
                    end
                    else
                    begin
                        LO <= 32'hxxxxxxxx; // ゼロ除算の処理
                        HI <= 32'hxxxxxxxx; // ゼロ除算の処理
                    end
                end
                DIVU:
                begin
                    if (MUX2 != 0)
                    begin
                        LO <= Rdata1 / MUX2;
                        HI <= Rdata1 % MUX2;
                    end
                    else
                    begin
                        LO <= 32'hxxxxxxxx; // ゼロ除算の処理
                        HI <= 32'hxxxxxxxx; // ゼロ除算の処理
                    end
                end
                default:; // 他の命令は何もしない
            endcase
        end
    end
end


endmodule
