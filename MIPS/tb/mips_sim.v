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

        uut.ID0.REGFILE[23] = 32'h00000000;

        // Dmemに初期値を書き込む
        uut.MA0.DM0.DMem[0] = 32'h00000001; 
        uut.MA0.DM0.DMem[1] = 32'h00000002;
        uut.MA0.DM0.DMem[2] = 32'h00000003;
        uut.MA0.DM0.DMem[3] = 32'h00000000;


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
        $display("$s3 register (R19) final value: 0x%08h", uut.ID0.REGFILE[19]);
        $display("Simulation finished.");
        $finish;
    end

endmodule
