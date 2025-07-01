`timescale 1 ps/ 1 ps

module clock1_sim();
parameter PERIOD=10000;  // (clock period)/2

// constants                                           
// general purpose registers
    reg   clk, rst;
    reg       [2:0]   key;
// wires                                               
    wire CA;
    wire [7:0] nhex0, nhex1, nhex2, nhex3;

// assign statements (if any)                          
CLOCK1 u1 (
// port map - connection between master ports and signals/registers   
    .CLK(clk),
    .RST(rst),
    .KEY(key),
    .nHEX0(nhex0),
    .nHEX1(nhex1),
    .nHEX2(nhex2),
    .nHEX3(nhex3),
    .CA(CA)
);

// rst, clr
initial begin
  rst =              1'b0;
  rst = #(PERIOD*3)  1'b1;
  rst = #(PERIOD)    1'b0;
  rst = #(PERIOD*20) 1'b1;
  rst = #(PERIOD)    1'b0;
end 

// clk
initial begin
	clk = 1'b0;
end
always #(PERIOD/2) clk = ~clk;


endmodule
