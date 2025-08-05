module SELECTOR (Rdata1, Rdata2, Result, SEL, Wdata, NextPC, newPC, SEL_LED, Vdata);
  input [31:0] Rdata1, Rdata2, Result, Wdata, NextPC, newPC;
  input [2:0] SEL;
  output [5:0] SEL_LED;
  output [31:0] Vdata;

  wire [4:0] SEL_LED = (SEL == 3'd0) ? 6'b000001 : // Rdata1
                       (SEL == 3'd1) ? 6'b000010 : // Rdata2
                       (SEL == 3'd2) ? 6'b000100 : // Result
                       (SEL == 3'd3) ? 6'b001000 : // Wdata
                       (SEL == 3'd4) ? 6'b010000 : // nextPC
                       (SEL == 3'd5) ? 6'b100000 : // newPC
                       5'b00000; // default
  wire [31:0] Vdata = (SEL == 3'd0) ? Rdata1 :
                       (SEL == 3'd1) ? Rdata2 :
                       (SEL == 3'd2) ? Result :
                       (SEL == 3'd3) ? Wdata :
                       (SEL == 3'd4) ? NextPC :
                       (SEL == 3'd5) ? newPC :
                       32'b0; // default
endmodule
