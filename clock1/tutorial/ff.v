module ff (clk, aclr, clken, d, q);
input clk, aclr, clken;
input d;
output reg q;

always @(posedge clk or negedge aclr)
begin
    if (aclr == 1'b0)
        q <= 1'b0;
    else if (clken)
        q <= d;
end
endmodule
