module DM (CLK, RST, WE, W_Ins, PC, Ins);
input CLK, RST, WE;
input[31:0] W_Ins, PC;
output reg[31:0] Ins;

reg [31:0] IMem[IMEM_SIZE];

initial
begin
    $readmemb("IMem.txt", IMem);
end

always @(posedge CLK)
begin
    if (~RST && WE)
        IMem[PC>>2] <= W_Ins;
end

assign Ins = RST ? 32'd0 : IMem[PC>>2];

endmodule
