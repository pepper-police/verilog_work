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
    EX u1 (
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

    // ins, rdata1, rdata2, ed32, nextpc
    initial begin
        // Initialize inputs
        ins = 32'h00000000;
        rdata1 = 32'h00000000;
        rdata2 = 32'h00000000;
        ed32 = 32'h00000000;
        nextpc = 32'h00000000;
        result = 32'h00000000;
        newpc = 32'h00000000;

        // Test cases
        // Example: ADD instruction
        ins = 32'h00000020; // ADD instruction
        rdata1 = 32'h00000005; // Register 1 value
        rdata2 = 32'h00000003; // Register 2 value
        ed32 = 32'h00000000; // Immediate value (not used in ADD
        nextpc = 32'h00000004; // Next PC value
        #PERIOD; // Wait for one clock cycle
        // Check result
        if (result !== 32'h00000008) begin
            $display("Test failed: Expected 8, got %h", result);
        end else begin
            $display("Test passed: ADD result is %h", result);
        end
        // Example: SUB instruction
        ins = 32'h00000022; // SUB instruction
        rdata1 = 32'h00000005; // Register 1 value
        rdata2 = 32'h00000003; // Register 2 value
        ed32 = 32'h00000000; // Immediate value (not used in SUB
        nextpc = 32'h00000004; // Next PC value
        #PERIOD; // Wait for one clock cycle
        // Check result
        if (result !== 32'h00000002) begin
            $display("Test failed: Expected 2, got %h", result);
        end else begin
            $display("Test passed: SUB result is %h", result);
        end
        // Example: AND instruction
        ins = 32'h00000024; // AND instruction
        rdata1 = 32'h0000000F; // Register 1 value
        rdata2 = 32'h00000003; // Register 2 value
        ed32 = 32'h00000000; // Immediate value (not used in AND
        nextpc = 32'h00000004; // Next PC value
        #PERIOD; // Wait for one clock cycle
        // Check result
        if (result !== 32'h00000003) begin
            $display("Test failed: Expected 3, got %h", result);
        end else begin
            $display("Test passed: AND result is %h", result);
        end
        // Example: OR instruction
        ins = 32'h00000025; // OR instruction
        rdata1 = 32'h0000000F; // Register 1 value
        rdata2 = 32'h00000003; // Register 2 value
        ed32 = 32'h00000000; // Immediate value (not used in OR
        nextpc = 32'h00000004; // Next PC value
        #PERIOD; // Wait for one clock cycle
        // Check result
        if (result !== 32'h0000000F) begin
            $display("Test failed: Expected 15, got %h", result);
        end else begin
            $display("Test passed: OR result is %h", result);
        end
        // Example: XOR instruction
        ins = 32'h00000026; // XOR instruction
        rdata1 = 32'h0000000F; // Register 1 value
        rdata2 = 32'h00000003; // Register 2 value
        ed32 = 32'h00000000; // Immediate value (not used in XOR
        nextpc = 32'h00000004; // Next PC value
        #PERIOD; // Wait for one clock cycle
        // Check result
        if (result !== 32'h0000000C) begin
            $display("Test failed: Expected 12, got %h", result);
        end else begin
            $display("Test passed: XOR result is %h", result);
        end
        // Example: SLT instruction
        ins = 32'h0000002A; // SLT instruction
        rdata1 = 32'h00000002; // Register 1 value
        rdata2 = 32'h00000003; // Register 2 value
        ed32 = 32'h00000000; // Immediate value (not used in SLT
        nextpc = 32'h00000004; // Next PC value
        #PERIOD; // Wait for one clock cycle
        // Check result
        if (result !== 32'h00000001) begin
            $display("Test failed: Expected 1, got %h", result);
        end else begin
            $display("Test passed: SLT result is %h", result);
        end
        // Example: SLTU instruction
        ins = 32'h0000002B; // SLTU instruction
        rdata1 = 32'h00000002; // Register 1 value
        rdata2 = 32'h00000003; // Register 2 value
        ed32 = 32'h00000000; // Immediate value (not used in SLTU
        nextpc = 32'h00000004; // Next PC value
        #PERIOD; // Wait for one clock cycle
        // Check result
        if (result !== 32'h00000001) begin
            $display("Test failed: Expected 1, got %h", result);
        end else begin
            $display("Test passed: SLTU result is %h", result);
        end
        // Example: ADDI instruction
        ins = 32'h20000003; // ADDI instruction
        rdata1 = 32'h00000005; // Register 1 value
        rdata2 = 32'h00000000; // Register 2 value (not used in ADDI
        ed32 = 32'h00000002; // Immediate value for ADDI
        nextpc = 32'h00000004; // Next PC value
        #PERIOD; // Wait for one clock cycle
        // Check result
        if (result !== 32'h00000007) begin
            $display("Test failed: Expected 7, got %h", result);
        end else begin
            $display("Test passed: ADDI result is %h", result);
        end
        // Example: ANDI instruction
        ins = 32'h30000003; // ANDI instruction
        rdata1 = 32'h0000000F; // Register 1 value
        rdata2 = 32'h00000000; // Register 2 value (not used in ANDI
        ed32 = 32'h00000003; // Immediate value for ANDI
        nextpc = 32'h00000004; // Next PC value
        #PERIOD; // Wait for one clock cycle
        // Check result
        if (result !== 32'h00000003) begin
            $display("Test failed: Expected 3, got %h", result);
        end else begin
            $display("Test passed: ANDI result is %h", result);
        end
        // Example: ORI instruction
        ins = 32'h34000003; // ORI instruction
        rdata1 = 32'h0000000F; // Register 1 value
        rdata2 = 32'h00000000; // Register 2 value (not used in ORI
        ed32 = 32'h00000003; // Immediate value for ORI
        nextpc = 32'h00000004; // Next PC value
        #PERIOD; // Wait for one clock cycle
        // Check result
        if (result !== 32'h0000000F) begin
            $display("Test failed: Expected 15, got %h", result);
        end else begin
            $display("Test passed: ORI result is %h", result);
        end
        // Example: XORI instruction
        ins = 32'h38000003; // XORI instruction
        rdata1 = 32'h0000000F; // Register 1 value
        rdata2 = 32'h00000000; // Register 2 value (not used in XORI
        ed32 = 32'h00000003; // Immediate value for XORI
        nextpc = 32'h00000004; // Next PC value
        #PERIOD; // Wait for one clock cycle
        // Check result
        if (result !== 32'h0000000C) begin
            $display("Test failed: Expected 12, got %h", result);
        end else begin
            $display("Test passed: XORI result is %h", result);
        end

endmodule
