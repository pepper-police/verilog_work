// Data Memory (DM) Module for MIPS Processor
module DM (CLK, RST, WE, Adr, WDATA, Rdata);
`include "common_param.vh"
input CLK, RST, WE;
input[31:0] Adr, WDATA;
output[31:0] Rdata;

reg [31:0] DMem[0:DMEM_SIZE-1];

assign Rdata = DMem[Adr>>2];

always @(posedge CLK)
begin
    if (~RST && WE)
        DMem[Adr>>2] <= WDATA;
end

endmodule