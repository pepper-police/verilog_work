`timescale 1ns / 1ps

module mips_sim;

    // テストベンチ用の信号
    reg CLK;
    reg RST;
    reg [31:0] W_Ins; // 今回のテストでは使用しない
    reg WE;          // 今回のテストでは使用しない

    // DUT(テスト対象デバイス)からの出力
    wire [31:0] PC;
    wire [31:0] Result;

    // DUTのインスタンス化
    SingleCycleClockMIPS uut (
        .CLK(CLK),
        .RST(RST),
        .W_Ins(W_Ins),
        .WE(WE),
        .PC(PC),
        .Result(Result)
    );

    // クロック生成 (10ns周期 = 100MHz)
    parameter CLK_PERIOD = 10;
    always begin
        CLK = 1'b0;
        #(CLK_PERIOD / 2);
        CLK = 1'b1;
        #(CLK_PERIOD / 2);
    end

    // シミュレーションの制御
    initial begin
        // 初期化とリセット
        RST = 1'b1; // アクティブハイのリセット
        WE = 1'b0;
        W_Ins = 32'b0;

        uut.ID0.REGFILE[23] = 32'h00000000; // $s7 レジスタを初期化
        uut.ID0.REGFILE[16] = 32'h00000000; // $s0 レジスタを初期化
        uut.ID0.REGFILE[17] = 32'h0000000b; // $s1 レジスタを初期化
        uut.ID0.REGFILE[18] = 32'h00000000; // $s2 レジスタを初期化


        // Dmemに初期値を書き込む
        uut.MA0.DM0.DMem[0] = 32'h00000000;
        uut.MA0.DM0.DMem[1] = 32'h00000001;
        uut.MA0.DM0.DMem[2] = 32'h00000002;
        uut.MA0.DM0.DMem[3] = 32'h00000003;
        uut.MA0.DM0.DMem[4] = 32'h00000004;
        uut.MA0.DM0.DMem[5] = 32'h00000005;
        uut.MA0.DM0.DMem[6] = 32'h00000006;
        uut.MA0.DM0.DMem[7] = 32'h00000007;
        uut.MA0.DM0.DMem[8] = 32'h00000008;
        uut.MA0.DM0.DMem[9] = 32'h00000009;


        // コンソールに表示する情報のヘッダ
        $display("Time\tPC\tInstruction\tALU_Result");
        // 信号が変化するたびにコンソールに値を表示
        $monitor("%0t ns\t0x%08h\t0b%32b\t0x%08h", $time, PC, uut.Ins, Result);

        // 2クロック分リセットを維持
        #(CLK_PERIOD * 2);
        RST = 1'b0; // リセット解除

        // 160サイクル実行してシミュレーションを終了
        #1600;
        $display("==== Simulation Results ====");
        $display("$s0 register (R16) final value: 0x%08h", uut.ID0.REGFILE[16]);
        //$display("$s1 register (R17) final value: 0x%08h", uut.ID0.REGFILE[17]);
        //$display("$s3 register (R19) final value: 0x%08h", uut.ID0.REGFILE[19]);
        //$display("$t1 register (R9) final value: 0x%08h", uut.ID0.REGFILE[9]);
        $display("DMem[0] final value: 0x%08h", uut.MA0.DM0.DMem[0]);
        $display("DMem[1] final value: 0x%08h", uut.MA0.DM0.DMem[1]);
        $display("DMem[2] final value: 0x%08h", uut.MA0.DM0.DMem[2]);
        $display("DMem[3] final value: 0x%08h", uut.MA0.DM0.DMem[3]);
        $display("DMem[4] final value: 0x%08h", uut.MA0.DM0.DMem[4]);
        $display("DMem[5] final value: 0x%08h", uut.MA0.DM0.DMem[5]);
        $display("DMem[6] final value: 0x%08h", uut.MA0.DM0.DMem[6]);
        $display("DMem[7] final value: 0x%08h", uut.MA0.DM0.DMem[7]);
        $display("DMem[8] final value: 0x%08h", uut.MA0.DM0.DMem[8]);
        $display("DMem[9] final value: 0x%08h", uut.MA0.DM0.DMem[9]);
        $display("Simulation finished.");
        $finish;
    end

endmodule
