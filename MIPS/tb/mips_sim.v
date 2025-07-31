module mips_sim;

// パラメータと信号の定義
reg CLK;
reg RST;
wire [31:0] Result;  // 処理結果の出力

// テスト対象のMIPSプロセッサをインスタンス化
SingleCycleClockMIPS mips0 (
    .CLK(CLK),
    .RST(RST),
    .Result(Result)  // 結果の出力（MIPSモジュールの出力に合わせて調整が必要）
);

// クロック生成
initial begin
    CLK = 0;
    forever #5 CLK = ~CLK; // 10単位時間の周期
end

// テストシナリオ
initial begin
    // 初期化
    RST = 1;
    
    // リセット解除
    #20;
    RST = 0;
    
    // プログラムの実行（十分な時間を確保）
    #1000;
    
    $finish; // シミュレーション終了
end

// モニタリング
initial begin
    $monitor("Time=%t, CLK=%b, RST=%b, Result=%h",
             $time, CLK, RST, Result);
end

// 命令メモリの内容をダンプ（オプション）
initial begin
    $dumpfile("mips_sim.vcd");
    $dumpvars(0, mips_sim);
end

endmodule
