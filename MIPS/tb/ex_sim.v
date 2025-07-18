`timescale 1 ps/ 1 ps

module ex_sim();
    parameter PERIOD = 10000;  // (clock period)/2

    // constants                                           
    // general purpose registers
    reg         clk, rst;
    reg  [31:0] ins, rdata1, rdata2, ed32, nextpc;
    reg  [31:0] result, newpc;
    
    // wires                                               
    wire [31:0] mux2, mux4, mux5;

    // assign statements (if any)                          
    CLOCK1 u1 (
        // port map - connection between master ports and signals/registers   
        .CLK(clk),
        .RST(rst),
        .Ins(ins),
        .Rdata1(rdata1),
        .Rdata2(rdata2),
        .Ed32(ed32),
        .nextPC(nextpc),
        .Result(result),
        .newPC(newpc)
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
