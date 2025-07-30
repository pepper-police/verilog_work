module DM (CLK, RST, WE, Adr, WDATA, Rdata);
`include "common_param.vh"
input CLK, RST, WE;
input[31:0] Adr, WDATA;
output reg[31:0] Rdata;

reg [31:0] DMem[0:DMEM_SIZE-1];

integer i;
initial
begin
    for (i = 0; i < DMEM_SIZE; i = i + 1)
    begin
        DMem[i] = 32'b0;
    end
end

always @(posedge CLK)
begin
    if (RST)
        Rdata <= 32'd0;
    else
    begin
        if (WE)
        begin
            DMem[Adr>>2] <= WDATA;
            Rdata <= 32'd0;
        end
        else
            Rdata <= DMem[Adr>>2];
    end
end

endmodule