`timescale 1 ps/ 1 ps


module cnt60_sim();
parameter PERIOD=10000;  // (clock period)/2

// constants                                           
// general purpose registers
  reg clk;
  reg rst;
  reg clr;
  reg en;
  reg inc;
// wires                                               
  wire [2:0] qh;
  wire [3:0] ql;
  wire ca;

// assign statements (if any)                          
CNT60 u1 (
// port map - connection between master ports and signals/registers   
  .RST(rst),
  .CLR(clr),
  .EN(en),
  .INC(inc),
  .QH(qh),
  .QL(ql),
  .CA(ca),
  .CLK(clk)
);

// rst, clr
initial begin
  rst =              1'b0; clr=rst;
  rst = #(PERIOD*3)  1'b1; clr=rst;
  rst = #(PERIOD)    1'b0; clr=rst;
  rst = #(PERIOD*20) 1'b1; clr=rst;
  rst = #(PERIOD)    1'b0; clr=rst;
end 

// clk
initial begin
	clk = 1'b0;
end
always #(PERIOD/2) clk = ~clk;

// en,inc
initial begin
  en =              1'b1; inc=en;
  en = #(PERIOD*20) 1'b0; inc=en;
  en = #(PERIOD*20) 1'b1; inc=en;
end 

endmodule
