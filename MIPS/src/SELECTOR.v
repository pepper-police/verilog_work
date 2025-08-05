module SELECTOR (Rdata1, Rdata2, Result, SEL, Wdata, NextPC, SEL_LED, Vdata);
  input [31:0] Rdata1, Rdata2, Result, Wdata, NextPC;
  input [2:0] SEL;
  output [4:0] SEL_LED;
  output [31:0] Vdata;

  wire [4:0] SEL_LED = (SEL == 3'd0) ? 5'b00001 : // Rdata1
                       (SEL == 3'd1) ? 5'b00010 : // Rdata2
                       (SEL == 3'd2) ? 5'b00100 : // Result
                       (SEL == 3'd3) ? 5'b01000 : // Wdata
                       (SEL == 3'd4) ? 5'b10000 : // nextPC
                       5'b00000; // default
  wire [31:0] Vdata = (SEL == 3'd0) ? Rdata1 :
                       (SEL == 3'd1) ? Rdata2 :
                       (SEL == 3'd2) ? Result :
                       (SEL == 3'd3) ? Wdata :
                       (SEL == 3'd4) ? NextPC :
                       32'b0; // default
endmodule
