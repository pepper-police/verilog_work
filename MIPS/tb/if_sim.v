module if_sim;

// パラメータと信号の定義
reg CLK;
reg RST;
reg WE;
reg [31:0] newPC, W_Ins;
wire [31:0] PC, nextPC, Ins;

// テスト対象のモジュールをインスタンス化
IF if0 (
    .CLK(CLK),
    .RST(RST),
    .newPC(newPC),
    .PC(PC),
    .W_Ins(W_Ins),
    .WE(WE),
    .nextPC(nextPC),
    .Ins(Ins)
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
    WE = 0;
    newPC = 32'h0;
    W_Ins = 32'h0;
    
    // リセット解除
    #20;
    RST = 0;
    
    // PCを進めるためにnewPCを更新
    #10;
    newPC = 32'h4;  // PC=4 (2番目の命令)
    #10;
    newPC = 32'h8;  // PC=8 (3番目の命令)
    #10;
    newPC = 32'hC;  // PC=12 (4番目の命令)
    #10;
    newPC = 32'h10; // PC=16 (5番目の命令)
    
    // 命令メモリへの書き込みテスト (オプション)
    #10;
    WE = 1;
    newPC = 32'h20; // アドレス0x20に書き込む
    W_Ins = 32'hAABBCCDD; // テスト用の命令
    #10;
    WE = 0;
    
    #20;
    $finish; // シミュレーション終了
end

// モニタリング
initial begin
    $monitor("Time=%t, CLK=%b, RST=%b, newPC=%h, PC=%h, nextPC=%h, Ins=%h, WE=%b",
             $time, CLK, RST, newPC, PC, nextPC, Ins, WE);
end

endmodule
