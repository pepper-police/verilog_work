`timescale 1 ps/ 1 ps

module ex_sim();
    parameter PERIOD = 10000;  // (clock period)/2

    // Test signals                                       
    reg         clk, rst;
    reg  [31:0] ins, rdata1, rdata2, ed32, nextpc;
    wire  [31:0] result, newpc;
    
    // Test counters
    integer test_count = 0;
    integer pass_count = 0;

    // DUT instantiation                        
    EX u1 (
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

    // Test helper task for complete operation testing
    task test_instruction;
        input [31:0] instruction;
        input [31:0] reg1_val;
        input [31:0] reg2_val;
        input [31:0] immediate;
        input [31:0] next_pc;
        input [31:0] expected_result;
        input [31:0] expected_newpc;
        input [255:0] test_name;
        input check_result;
        input check_newpc;
        begin
            ins = instruction;
            rdata1 = reg1_val;
            rdata2 = reg2_val;
            ed32 = immediate;
            nextpc = next_pc;
            #PERIOD;
            
            test_count = test_count + 1;
            
            if ((!check_result || result === expected_result) && 
                (!check_newpc || newpc === expected_newpc)) begin
                $display("PASS: %s", test_name);
                if (check_result && check_newpc) 
                    $display("      Result=%h, NewPC=%h", result, newpc);
                else if (check_result) 
                    $display("      Result=%h", result);
                else if (check_newpc) 
                    $display("      NewPC=%h", newpc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: %s", test_name);
                if (check_result) 
                    $display("      Expected Result=%h, Got=%h", expected_result, result);
                if (check_newpc) 
                    $display("      Expected NewPC=%h, Got=%h", expected_newpc, newpc);
            end
        end
    endtask

    // Simplified test tasks
    task test_alu;
        input [31:0] instruction;
        input [31:0] reg1_val;
        input [31:0] reg2_val;
        input [31:0] immediate;
        input [31:0] expected_result;
        input [255:0] test_name;
        begin
            test_instruction(instruction, reg1_val, reg2_val, immediate, 32'h00000004, 
                           expected_result, 32'h00000008, test_name, 1'b1, 1'b0);
        end
    endtask

    task test_branch;
        input [31:0] instruction;
        input [31:0] reg1_val;
        input [31:0] reg2_val;
        input [31:0] branch_offset;
        input [31:0] expected_newpc;
        input [255:0] test_name;
        begin
            test_instruction(instruction, reg1_val, reg2_val, branch_offset, 32'h00000004, 
                           32'h00000000, expected_newpc, test_name, 1'b0, 1'b1);
        end
    endtask

    task test_jump;
        input [31:0] instruction;
        input [31:0] reg1_val;
        input [31:0] jump_addr;
        input [31:0] next_pc;
        input [31:0] expected_result;
        input [31:0] expected_newpc;
        input [255:0] test_name;
        begin
            test_instruction(instruction, reg1_val, 32'h00000000, jump_addr, next_pc, 
                           expected_result, expected_newpc, test_name, 1'b1, 1'b1);
        end
    endtask

    // Test procedures for different instruction types
    task run_rtype_alu_tests;
        begin
            $display("\n--- R-type ALU Operations ---");
            test_alu(32'h00000020, 32'h00000005, 32'h00000003, 32'h00000000, 32'h00000008, "ADD");
            test_alu(32'h00000021, 32'h00000005, 32'h00000003, 32'h00000000, 32'h00000008, "ADDU");
            test_alu(32'h00000022, 32'h00000005, 32'h00000003, 32'h00000000, 32'h00000002, "SUB");
            test_alu(32'h00000023, 32'h00000005, 32'h00000003, 32'h00000000, 32'h00000002, "SUBU");
            test_alu(32'h00000024, 32'h0000000F, 32'h00000003, 32'h00000000, 32'h00000003, "AND");
            test_alu(32'h00000025, 32'h0000000F, 32'h00000003, 32'h00000000, 32'h0000000F, "OR");
            test_alu(32'h00000026, 32'h0000000F, 32'h00000003, 32'h00000000, 32'h0000000C, "XOR");
            test_alu(32'h00000027, 32'h0000000F, 32'h00000003, 32'h00000000, 32'hFFFFFFF0, "NOR");
            test_alu(32'h0000002A, 32'h00000002, 32'h00000003, 32'h00000000, 32'h00000001, "SLT (2<3)");
            test_alu(32'h0000002A, 32'hFFFFFFFE, 32'hFFFFFFFD, 32'h00000000, 32'h00000000, "SLT (-2>-3)");
            test_alu(32'h0000002B, 32'h00000002, 32'h00000003, 32'h00000000, 32'h00000001, "SLTU (2<3)");
            test_alu(32'h0000002B, 32'h00000003, 32'h00000001, 32'h00000000, 32'h00000000, "SLTU (3>1)");
        end
    endtask

    task run_shift_tests;
        begin
            $display("\n--- Shift Operations ---");
            // Shift operations (immediate)
            test_alu(32'h00000000, 32'h00000000, 32'h00000003, 32'h00000002, 32'h0000000C, "SLL");
            test_alu(32'h00000002, 32'h00000000, 32'h0000000C, 32'h00000002, 32'h00000003, "SRL");
            test_alu(32'h00000003, 32'h00000000, 32'hFFFFFFF0, 32'h00000002, 32'hFFFFFFFC, "SRA");
            
            // Shift operations (variable)
            test_alu(32'h00000004, 32'h00000002, 32'h00000003, 32'h00000000, 32'h0000000C, "SLLV");
            test_alu(32'h00000006, 32'h00000002, 32'h0000000C, 32'h00000000, 32'h00000003, "SRLV");
            test_alu(32'h00000007, 32'h00000002, 32'hFFFFFFF0, 32'h00000000, 32'hFFFFFFFC, "SRAV");
        end
    endtask

    task run_itype_tests;
        begin
            $display("\n--- I-type Operations ---");
            test_alu(32'h20000003, 32'h00000005, 32'h00000000, 32'h00000002, 32'h00000007, "ADDI");
            test_alu(32'h24000003, 32'h00000005, 32'h00000000, 32'h00000002, 32'h00000007, "ADDIU");
            test_alu(32'h28000003, 32'h00000002, 32'h00000000, 32'h00000003, 32'h00000001, "SLTI");
            test_alu(32'h2C000003, 32'h00000002, 32'h00000000, 32'h00000003, 32'h00000001, "SLTIU");
            test_alu(32'h30000003, 32'h0000000F, 32'h00000000, 32'h00000003, 32'h00000003, "ANDI");
            test_alu(32'h34000003, 32'h0000000F, 32'h00000000, 32'h00000003, 32'h0000000F, "ORI");
            test_alu(32'h38000003, 32'h0000000F, 32'h00000000, 32'h00000003, 32'h0000000C, "XORI");
        end
    endtask

    task run_memory_tests;
        begin
            $display("\n--- Memory Operations ---");
            test_alu(32'h8C000004, 32'h00001000, 32'h00000000, 32'h00000004, 32'h00001004, "LW (addr calc)");
            test_alu(32'hAC000004, 32'h00001000, 32'h12345678, 32'h00000004, 32'h00001004, "SW (addr calc)");
        end
    endtask

    task run_mult_div_tests;
        begin
            $display("\n--- Multiply/Divide Operations ---");
            test_alu(32'h00000018, 32'h00000005, 32'h00000003, 32'h00000000, 32'h0000000F, "MULT");
            test_alu(32'h00000019, 32'h00000005, 32'h00000003, 32'h00000000, 32'h0000000F, "MULTU");
            test_alu(32'h0000001A, 32'h0000000F, 32'h00000003, 32'h00000000, 32'h00000005, "DIV");
            test_alu(32'h0000001B, 32'h0000000F, 32'h00000003, 32'h00000000, 32'h00000005, "DIVU");
        end
    endtask

    task run_jump_tests;
        begin
            $display("\n--- Jump Operations ---");
            test_jump(32'h00000008, 32'h00001000, 32'h00000000, 32'h00000004, 32'h00000000, 32'h00001000, "JR");
            test_jump(32'h00000009, 32'h00002000, 32'h00000000, 32'h00000008, 32'h0000000C, 32'h00002000, "JALR");
            test_branch(32'h08000400, 32'h00000000, 32'h00000000, 32'h00001000, 32'h00001000, "J");
            test_jump(32'h0C000400, 32'h00000000, 32'h00001000, 32'h00000008, 32'h0000000C, 32'h00001000, "JAL");
        end
    endtask

    task run_branch_tests;
        begin
            $display("\n--- Branch Operations ---");
            test_branch(32'h10000002, 32'h00000005, 32'h00000005, 32'h00000008, 32'h00000024, "BEQ (taken)");
            test_branch(32'h10000002, 32'h00000005, 32'h00000003, 32'h00000008, 32'h00000008, "BEQ (not taken)");
            test_branch(32'h14000002, 32'h00000005, 32'h00000003, 32'h00000008, 32'h00000024, "BNE (taken)");
            test_branch(32'h18000002, 32'h00000000, 32'h00000000, 32'h00000008, 32'h00000024, "BLEZ (taken)");
            test_branch(32'h1C000002, 32'h00000005, 32'h00000000, 32'h00000008, 32'h00000024, "BGTZ (taken)");
            test_branch(32'h04000002, 32'hFFFFFFFF, 32'h00000000, 32'h00000008, 32'h00000024, "BLTZ (taken)");
            test_branch(32'h04010002, 32'h00000005, 32'h00000000, 32'h00000008, 32'h00000024, "BGEZ (taken)");
        end
    endtask

    // Reset and clock generation
    initial begin
        rst = 1'b0;
        rst = #(PERIOD*3) 1'b1;
        rst = #(PERIOD) 1'b0;
        rst = #(PERIOD*20) 1'b1;
        rst = #(PERIOD) 1'b0;
    end 

    initial begin
        clk = 1'b0;
    end
    always #(PERIOD/2) clk = ~clk;

    // Test execution
    initial begin
        // Initialize inputs
        ins = 32'h00000000;
        rdata1 = 32'h00000000;
        rdata2 = 32'h00000000;
        ed32 = 32'h00000000;
        nextpc = 32'h00000004;

        $display("=== MIPS EX Stage Test Bench ===");
        
        // Wait for reset deassertion
        wait(rst == 1'b0);
        #(PERIOD*2);

        // Run all test suites
        run_rtype_alu_tests();
        run_shift_tests();
        run_itype_tests();
        run_memory_tests();
        run_mult_div_tests();
        run_jump_tests();
        run_branch_tests();

        // Test summary
        #(PERIOD*5);
        $display("\n=== Test Summary ===");
        $display("Total tests: %0d", test_count);
        $display("Passed: %0d", pass_count);
        $display("Failed: %0d", test_count - pass_count);
        $display("Pass rate: %0.1f%%", (pass_count * 100.0) / test_count);
        
        if (pass_count == test_count) begin
            $display("🎉 ALL TESTS PASSED!");
        end else begin
            $display("❌ SOME TESTS FAILED!");
        end
    end

endmodule
