module DM (CLK, RST, WE, Adr, WDATA, Rdata);
input CLK, RST, WE;
input[31:0] Adr, WDATA;
output reg[31:0] Rdata;

always @(posedge CLK)
begin
    if (RST)
        Rdata <= 32'd0;
    else
    begin
        // wip
    end
end

endmodule
