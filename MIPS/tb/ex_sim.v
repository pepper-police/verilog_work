`timescale 1 ps/ 1 ps

module ex_sim();
    parameter PERIOD = 10000;  // (clock period)/2

    // Test signals
    reg         clk, rst;
    reg  [31:0] ins, rdata1, rdata2, ed32, nextpc;
    wire [31:0] result, newpc;

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
    task automatic test_instruction(
        input [31:0] instruction,
        input [31:0] reg1_val,
        input [31:0] reg2_val,
        input [31:0] immediate,
        input [31:0] next_pc,
        input [31:0] expected_result,
        input [31:0] expected_newpc,
        input [512:0] test_name,
        input check_result,
        input check_newpc
    );
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
            $display("      Inputs: instruction=%h, reg1_val=%h, reg2_val=%h, immediate=%h, next_pc=%h", instruction, reg1_val, reg2_val, immediate, next_pc);
            if (check_result && check_newpc) 
                $display("      Result=%h, NewPC=%h", result, newpc);
            else if (check_result) 
                $display("      Result=%h", result);
            else if (check_newpc) 
                $display("      NewPC=%h", newpc);
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: %s", test_name);
            $display("      Inputs: instruction=%h, reg1_val=%h, reg2_val=%h, immediate=%h, next_pc=%h", instruction, reg1_val, reg2_val, immediate, next_pc);
            if (check_result) 
                $display("      Expected Result=%h, Got=%h", expected_result, result);
            if (check_newpc) 
                $display("      Expected NewPC=%h, Got=%h", expected_newpc, newpc);
        end
    end
    endtask

    // Simplified test tasks
    task automatic test_alu(
        input [31:0] instruction,
        input [31:0] reg1_val,
        input [31:0] reg2_val,
        input [31:0] immediate,
        input [31:0] expected_result,
        input [512:0] test_name
    );
    begin
        test_instruction(instruction, reg1_val, reg2_val, immediate, 32'h00000004, 
                       expected_result, 32'h00000008, test_name, 1'b1, 1'b0);
    end
    endtask

    task automatic test_branch(
        input [31:0] instruction,
        input [31:0] reg1_val,
        input [31:0] reg2_val,
        input [31:0] branch_offset,
        input [31:0] expected_newpc,
        input [255:0] test_name
    );
    begin
        test_instruction(instruction, reg1_val, reg2_val, branch_offset, 32'h00000004, 
                       32'h00000000, expected_newpc, test_name, 1'b0, 1'b1);
    end
    endtask

    task automatic test_jump(
        input [31:0] instruction,
        input [31:0] reg1_val,
        input [31:0] jump_addr,
        input [31:0] next_pc,
        input [31:0] expected_result,
        input [31:0] expected_newpc,
        input [512:0] test_name
    );
    begin
        test_instruction(instruction, reg1_val, 32'h00000000, jump_addr, next_pc, 
                       expected_result, expected_newpc, test_name, 1'b1, 1'b1);
    end
    endtask

    // Test procedures for different instruction types
    task automatic run_rtype_alu_tests;
        begin
            $display("\n--- R-type ALU Operations ---");
            // op(6):000000, rs(5):1, rt(5):2, rd(5):3, shamt(5):0, funct(6):100000 (ADD)
            test_alu(32'b000000_00001_00010_00011_00000_100000, 32'h00000005, 32'h00000003, 32'h00000000, 32'h00000008, "ADD $3,$1,$2");
            // op(6):000000, rs(5):1, rt(5):2, rd(5):3, shamt(5):0, funct(6):100001 (ADDU)
            test_alu(32'b000000_00001_00010_00011_00000_100001, 32'h00000005, 32'h00000003, 32'h00000000, 32'h00000008, "ADDU $3,$1,$2");
            // op(6):000000, rs(5):1, rt(5):2, rd(5):3, shamt(5):0, funct(6):100010 (SUB)
            test_alu(32'b000000_00001_00010_00011_00000_100010, 32'h00000005, 32'h00000003, 32'h00000000, 32'h00000002, "SUB $3,$1,$2");
            // op(6):000000, rs(5):1, rt(5):2, rd(5):3, shamt(5):0, funct(6):100011 (SUBU)
            test_alu(32'b000000_00001_00010_00011_00000_100011, 32'h00000005, 32'h00000003, 32'h00000000, 32'h00000002, "SUBU $3,$1,$2");
            // op(6):000000, rs(5):15, rt(5):3, rd(5):4, shamt(5):0, funct(6):100100 (AND)
            test_alu(32'b000000_01111_00011_00100_00000_100100, 32'h0000000F, 32'h00000003, 32'h00000000, 32'h00000003, "AND $4,$15,$3");
            // op(6):000000, rs(5):15, rt(5):3, rd(5):4, shamt(5):0, funct(6):100101 (OR)
            test_alu(32'b000000_01111_00011_00100_00000_100101, 32'h0000000F, 32'h00000003, 32'h00000000, 32'h0000000F, "OR $4,$15,$3");
            // op(6):000000, rs(5):15, rt(5):3, rd(5):4, shamt(5):0, funct(6):100110 (XOR)
            test_alu(32'b000000_01111_00011_00100_00000_100110, 32'h0000000F, 32'h00000003, 32'h00000000, 32'h0000000C, "XOR $4,$15,$3");
            // op(6):000000, rs(5):15, rt(5):3, rd(5):4, shamt(5):0, funct(6):100111 (NOR)
            test_alu(32'b000000_01111_00011_00100_00000_100111, 32'h0000000F, 32'h00000003, 32'h00000000, 32'hFFFFFFF0, "NOR $4,$15,$3");
            // op(6):000000, rs(5):2, rt(5):3, rd(5):4, shamt(5):0, funct(6):101010 (SLT)
            test_alu(32'b000000_00010_00011_00100_00000_101010, 32'h00000002, 32'h00000003, 32'h00000000, 32'h00000001, "SLT $4,$2,$3");
            // op(6):000000, rs(5):30, rt(5):29, rd(5):4, shamt(5):0, funct(6):101010 (SLT)
            test_alu(32'b000000_11110_11101_00100_00000_101010, 32'hFFFFFFFE, 32'hFFFFFFFD, 32'h00000000, 32'h00000000, "SLT $4,$30,$29");
            // op(6):000000, rs(5):2, rt(5):3, rd(5):4, shamt(5):0, funct(6):101011 (SLTU)
            test_alu(32'b000000_00010_00011_00100_00000_101011, 32'h00000002, 32'h00000003, 32'h00000000, 32'h00000001, "SLTU $4,$2,$3");
            // op(6):000000, rs(5):3, rt(5):1, rd(5):4, shamt(5):0, funct(6):101011 (SLTU)
            test_alu(32'b000000_00011_00001_00100_00000_101011, 32'h00000003, 32'h00000001, 32'h00000000, 32'h00000000, "SLTU $4,$3,$1");
        end
    endtask

    task automatic run_shift_tests;
        begin
            $display("\n--- Shift Operations ---");
            // SLL: op=0, rs=0, rt=2, rd=3, shamt=2, funct=0
            test_alu(32'b000000_00000_00010_00011_00010_000000, 32'h00000000, 32'h00000001, 32'h00000000, 32'h00000004, "SLL $3,$2,2");
            // SLL: op=0, rs=0, rt=2, rd=3, shamt=4, funct=0
            test_alu(32'b000000_00000_00010_00011_00100_000000, 32'h00000000, 32'h000000FF, 32'h00000000, 32'h00000FF0, "SLL $3,$2,4");
            // SRL: op=0, rs=0, rt=2, rd=3, shamt=2, funct=2
            test_alu(32'b000000_00000_00010_00011_00010_000010, 32'h00000000, 32'h0000000C, 32'h00000000, 32'h00000003, "SRL $3,$2,2");
            // SRL: op=0, rs=0, rt=2, rd=3, shamt=31, funct=2
            test_alu(32'b000000_00000_00010_00011_11111_000010, 32'h00000000, 32'h80000000, 32'h00000000, 32'h00000001, "SRL $3,$2,31");
            // SRA: op=0, rs=0, rt=2, rd=3, shamt=2, funct=3
            test_alu(32'b000000_00000_00010_00011_00010_000011, 32'h00000000, 32'hFFFFFFF0, 32'h00000000, 32'hFFFFFFFC, "SRA $3,$2,2");
            // SRA: op=0, rs=0, rt=2, rd=3, shamt=31, funct=3
            test_alu(32'b000000_00000_00010_00011_11111_000011, 32'h00000000, 32'h80000000, 32'h00000000, 32'hFFFFFFFF, "SRA $3,$2,31");
            // SLLV: op=0, rs=4, rt=2, rd=3, shamt=0, funct=4
            test_alu(32'b000000_00100_00010_00011_00000_000100, 32'h00000002, 32'h00000003, 32'h00000000, 32'h0000000C, "SLLV $3,$2,$4");
            // SRLV: op=0, rs=4, rt=2, rd=3, shamt=0, funct=6
            test_alu(32'b000000_00100_00010_00011_00000_000110, 32'h00000004, 32'h000000F0, 32'h00000000, 32'h0000000F, "SRLV $3,$2,$4");
            // SRAV: op=0, rs=4, rt=2, rd=3, shamt=0, funct=7
            test_alu(32'b000000_00100_00010_00011_00000_000111, 32'h00000004, 32'hFFFFFFF0, 32'h00000000, 32'hFFFFFFFF, "SRAV $3,$2,$4");
        end
    endtask

    task automatic run_itype_tests;
        begin
            $display("\n--- I-type Operations ---");
            test_alu(32'b001000_00000_00000_0000000000000011, 32'h00000005, 32'h00000000, 32'h00000002, 32'h00000007, "ADDI");
            test_alu(32'b001001_00000_00000_0000000000000011, 32'h00000005, 32'h00000000, 32'h00000002, 32'h00000007, "ADDIU");
            test_alu(32'b001010_00000_00000_0000000000000011, 32'h00000002, 32'h00000000, 32'h00000003, 32'h00000001, "SLTI");
            test_alu(32'b001011_00000_00000_0000000000000011, 32'h00000002, 32'h00000000, 32'h00000003, 32'h00000001, "SLTIU");
            test_alu(32'b001100_00000_00000_0000000000000011, 32'h0000000F, 32'h00000000, 32'h00000003, 32'h00000003, "ANDI");
            test_alu(32'b001101_00000_00000_0000000000000011, 32'h0000000F, 32'h00000000, 32'h00000003, 32'h0000000F, "ORI");
            test_alu(32'b001110_00000_00000_0000000000000011, 32'h0000000F, 32'h00000000, 32'h00000003, 32'h0000000C, "XORI");
        end
    endtask

    task automatic run_memory_tests;
        begin
            $display("\n--- Memory Operations ---");
            test_alu(32'b100011_00000_00000_0000000000000100, 32'h00001000, 32'h00000000, 32'h00000004, 32'h00001004, "LW (addr calc)");
            test_alu(32'b101011_00000_00000_0000000000000100, 32'h00001000, 32'h12345678, 32'h00000004, 32'h00001004, "SW (addr calc)");
        end
    endtask

    task automatic run_mult_div_tests;
        begin
            $display("\n--- Multiply/Divide Operations with HI/LO Verification ---");
            
            // Test 1: MULT 5 * 3 = 15 -> HI=0, LO=15
            $display("\nTest 1: MULT 5 * 3");
            ins = 32'b000000_00001_00010_00000_00000_011000; // MULT $1, $2
            rdata1 = 32'h00000005; rdata2 = 32'h00000003; ed32 = 32'h00000000; nextpc = 32'h00000004;
            #PERIOD;
            // Add an extra clock cycle to ensure HI/LO registers are updated
            #PERIOD;
            // Check LO register (should be 15)
            test_alu(32'b000000_00000_00000_00011_00000_010010, 32'h00000000, 32'h00000000, 32'h00000000, 32'h0000000F, "MFLO after MULT (LO=15)");
            // Check HI register (should be 0)
            test_alu(32'b000000_00000_00000_00011_00000_010000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, "MFHI after MULT (HI=0)");
            
            // Test 2: MULTU 5 * 3 = 15 -> HI=0, LO=15
            $display("\nTest 2: MULTU 5 * 3");
            ins = 32'b000000_00001_00010_00000_00000_011001; // MULTU $1, $2
            rdata1 = 32'h00000005; rdata2 = 32'h00000003; ed32 = 32'h00000000; nextpc = 32'h00000004;
            #PERIOD;
            // Add an extra clock cycle to ensure HI/LO registers are updated
            #PERIOD;
            // Check LO register (should be 15)
            test_alu(32'b000000_00000_00000_00011_00000_010010, 32'h00000000, 32'h00000000, 32'h00000000, 32'h0000000F, "MFLO after MULTU (LO=15)");
            // Check HI register (should be 0)
            test_alu(32'b000000_00000_00000_00011_00000_010000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, "MFHI after MULTU (HI=0)");
            
            // Test 3: Large MULT 0xFFFFFFFF * 0x00000002 = 0x1FFFFFFFE -> HI=0x1, LO=0xFFFFFFFE  
            $display("\nTest 3: MULT 0xFFFFFFFF * 0x00000002 (large multiplication)");
            ins = 32'b000000_00001_00010_00000_00000_011000; // MULT $1, $2
            rdata1 = 32'hFFFFFFFF; rdata2 = 32'h00000002; ed32 = 32'h00000000; nextpc = 32'h00000004;
            #PERIOD;
            // Add an extra clock cycle to ensure HI/LO registers are updated
            #PERIOD;
            // Check LO register (should be 0xFFFFFFFE)
            test_alu(32'b000000_00000_00000_00011_00000_010010, 32'h00000000, 32'h00000000, 32'h00000000, 32'hFFFFFFFE, "MFLO after large MULT (LO=0xFFFFFFFE)");
            // Check HI register (should be 0xFFFFFFFF for signed multiplication)
            test_alu(32'b000000_00000_00000_00011_00000_010000, 32'h00000000, 32'h00000000, 32'h00000000, 32'hFFFFFFFF, "MFHI after large MULT (HI=0xFFFFFFFF)");
            
            // Test 4: DIV 17 / 5 = 3 remainder 2 -> LO=3, HI=2
            $display("\nTest 4: DIV 17 / 5");
            ins = 32'b000000_00001_00010_00000_00000_011010; // DIV $1, $2
            rdata1 = 32'h00000011; rdata2 = 32'h00000005; ed32 = 32'h00000000; nextpc = 32'h00000004;
            #PERIOD;
            // Add an extra clock cycle to ensure HI/LO registers are updated
            #PERIOD;
            // Check LO register (quotient should be 3)
            test_alu(32'b000000_00000_00000_00011_00000_010010, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000003, "MFLO after DIV (quotient=3)");
            // Check HI register (remainder should be 2)
            test_alu(32'b000000_00000_00000_00011_00000_010000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000002, "MFHI after DIV (remainder=2)");
            
            // Test 5: DIVU 20 / 6 = 3 remainder 2 -> LO=3, HI=2
            $display("\nTest 5: DIVU 20 / 6");
            ins = 32'b000000_00001_00010_00000_00000_011011; // DIVU $1, $2
            rdata1 = 32'h00000014; rdata2 = 32'h00000006; ed32 = 32'h00000000; nextpc = 32'h00000004;
            #PERIOD;
            // Check LO register (quotient should be 3)
            test_alu(32'b000000_00000_00000_00011_00000_010010, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000003, "MFLO after DIVU (quotient=3)");
            // Check HI register (remainder should be 2)
            test_alu(32'b000000_00000_00000_00011_00000_010000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000002, "MFHI after DIVU (remainder=2)");
            
            // Test 6: DIV with zero remainder 15 / 3 = 5 remainder 0 -> LO=5, HI=0
            $display("\nTest 6: DIV 15 / 3 (zero remainder)");
            ins = 32'b000000_00001_00010_00000_00000_011010; // DIV $1, $2
            rdata1 = 32'h0000000F; rdata2 = 32'h00000003; ed32 = 32'h00000000; nextpc = 32'h00000004;
            #PERIOD;
            // Check LO register (quotient should be 5)
            test_alu(32'b000000_00000_00000_00011_00000_010010, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000005, "MFLO after DIV (quotient=5)");
            // Check HI register (remainder should be 0)
            test_alu(32'b000000_00000_00000_00011_00000_010000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, "MFHI after DIV (remainder=0)");
            
            // Test 7: MTLO - Move value to LO register
            $display("\nTest 7: MTLO (Move to LO register)");
            ins = 32'b000000_00001_00000_00000_00000_010011; // MTLO $1
            rdata1 = 32'hAABBCCDD; rdata2 = 32'h00000000; ed32 = 32'h00000000; nextpc = 32'h00000004;
            #PERIOD;
            // Check LO register (should contain the value we just moved)
            test_alu(32'b000000_00000_00000_00011_00000_010010, 32'h00000000, 32'h00000000, 32'h00000000, 32'hAABBCCDD, "MFLO after MTLO");
            
            // Test 8: MTHI - Move value to HI register
            $display("\nTest 8: MTHI (Move to HI register)");
            ins = 32'b000000_00001_00000_00000_00000_010001; // MTHI $1
            rdata1 = 32'h11223344; rdata2 = 32'h00000000; ed32 = 32'h00000000; nextpc = 32'h00000004;
            #PERIOD;
            // Check HI register (should contain the value we just moved)
            test_alu(32'b000000_00000_00000_00011_00000_010000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h11223344, "MFHI after MTHI");
            
            // Test 9: MTLO/MTHI - Verify that they don't affect each other
            $display("\nTest 9: MTLO/MTHI independence check");
            // Set LO register
            ins = 32'b000000_00001_00000_00000_00000_010011; // MTLO $1
            rdata1 = 32'h55667788; rdata2 = 32'h00000000; ed32 = 32'h00000000; nextpc = 32'h00000004;
            #PERIOD;
                        // Check LO register (should still have the value from the MTLO)
            test_alu(32'b000000_00000_00000_00011_00000_010010, 32'h00000000, 32'h00000000, 32'h00000000, 32'h55667788, "MFLO after MTHI (should be unchanged)");
            // Set HI register
            ins = 32'b000000_00010_00000_00000_00000_010001; // MTHI $1
            rdata1 = 32'h99AABBCC; rdata2 = 32'h00000000; ed32 = 32'h00000000; nextpc = 32'h00000004;
            #PERIOD;

            // Check HI register (should have the new value from MTHI)
            test_alu(32'b000000_00000_00000_00011_00000_010000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h99AABBCC, "MFHI after MTLO (should have new value)");
        end
    endtask

    task automatic run_jump_tests;
        // test_jump(instruction, reg1_val, jump_addr, next_pc, expected_result, expected_newpc, test_name)
        begin
            $display("\n--- Jump Operations ---");
            test_jump(32'b000000_00000_00000_00000_00000_001000, 32'h00001000, 32'h00000000, 32'h00000004, 32'h00000000, 32'h00001000, "JR");
            test_jump(32'b000000_00000_00000_00000_00000_001001, 32'h00002000, 32'h00000000, 32'h00000008, 32'h0000000C, 32'h00002000, "JALR");
            test_branch(32'b000010_00000000000000010000000000, 32'h00000000, 32'h00000000, 32'h00001000, 32'h00001000, "J");
            test_jump(32'b000011_00000000000000010000000000, 32'h00000000, 32'h00000000, 32'h00001000, 32'h00001000, 32'h00001000, "JAL");
        end
    endtask

    task automatic run_branch_tests;
        // test_branch(instruction, reg1_val, reg2_val, branch_offset, expected_newpc, test_name)
        begin
            $display("\n--- Branch Operations ---");
            test_branch(32'b000100_00000_00000_0000000000000010, 32'h00000005, 32'h00000005, 32'h00000008, 32'h00000024, "BEQ (taken)");
            test_branch(32'b000100_00000_00000_0000000000000010, 32'h00000005, 32'h00000003, 32'h00000008, 32'h00000004, "BEQ (not taken)");
            test_branch(32'b000101_00000_00000_0000000000000010, 32'h00000005, 32'h00000003, 32'h00000008, 32'h00000024, "BNE (taken)");
            test_branch(32'b000110_00000_00000_0000000000000010, 32'h00000000, 32'h00000000, 32'h00000008, 32'h00000024, "BLEZ (taken)");
            test_branch(32'b000111_00000_00000_0000000000000010, 32'h00000005, 32'h00000000, 32'h00000008, 32'h00000024, "BGTZ (taken)");
            test_branch(32'b000001_00000_00000_0000000000000010, 32'hFFFFFFFF, 32'h00000000, 32'h00000008, 32'h00000024, "BLTZ (taken)");
            test_branch(32'b000001_00001_00000_0000000000000010, 32'h00000005, 32'h00000000, 32'h00000008, 32'h00000024, "BGEZ (taken)");
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

    initial clk = 1'b0;
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
        //run_rtype_alu_tests();
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
