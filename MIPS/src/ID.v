// Instruction Decode (ID) Module for MIPS Processor
module ID (CLK, RST, Ins, Wdata, Rdata1, Rdata2, Ed32);
`include "common_param.vh"
input CLK, RST;
input[31:0] Ins, Wdata;
output reg [31:0] Rdata1, Rdata2, Ed32;

reg[31:0] REGFILE[0:REGFILE_SIZE-1];

wire[5:0] op, func;
wire[4:0] Radr1, Radr2, Wadr;
assign op = Ins[31:26];
assign func = Ins[5:0];
assign Radr1 = Ins[25:21];
assign Radr2 = Ins[20:16];

wire[4:0] MUX1;
assign MUX1 = (op == JAL) ? 5'b11111 : // 2
              (op == R_FORM || op == JALR) ? Ins[15:11] : // 1
              Ins[20:16]; // 2
assign Wadr = MUX1;

wire WE;
assign WE = (op == SW || op == BEQ || op == BNE || op == J  || (op == R_FORM && (func == JR))) ? 1'b1 : 1'b0;

always @(posedge CLK)
begin
    if (RST)
    begin
        Rdata1 <= 32'd0;
        Rdata2 <= 32'd0;
    end
    else
    begin
        if (WE)
        begin
            REGFILE[Wadr] <= Wdata;
            Rdata1 <= 32'd0;
            Rdata2 <= 32'd0;
        end
        else
        begin
            Rdata1 <= REGFILE[Radr1];
            Rdata2 <= REGFILE[Radr2];
        end
    end
end

assign Ed32 = ((op == ADDI || op == ADDIU || op == SLTI ||
                op == ANDI || op == ORI || op == XORI) && Ins[15] == 1'b1) ? {16'b1111111111111111, Ins[15:0]} :
                {16'b0000000000000000, Ins[15:0]};

endmodule