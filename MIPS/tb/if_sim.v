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
    
    // 命令メモリへの書き込み（例）
    #10;
    WE = 1;
    W_Ins = 32'h20010005; // addi $1, $0, 5
    newPC = 32'h0;
    #10;
    W_Ins = 32'h20020007; // addi $2, $0, 7
    newPC = 32'h4;
    #10;
    W_Ins = 32'h00221820; // add $3, $1, $2
    newPC = 32'h8;
    #10;
    WE = 0;
    
    // 命令フェッチのテスト
    newPC = 32'h0;
    #10;
    $display("PC=%h, nextPC=%h, Ins=%h", PC, nextPC, Ins);
    newPC = nextPC;
    
    #10;
    $display("PC=%h, nextPC=%h, Ins=%h", PC, nextPC, Ins);
    newPC = nextPC;
    
    #10;
    $display("PC=%h, nextPC=%h, Ins=%h", PC, nextPC, Ins);
    
    // リセットテスト
    #10;
    RST = 1;
    #10;
    $display("After Reset: PC=%h, nextPC=%h, Ins=%h", PC, nextPC, Ins);
    
end

// モニタリング
initial begin
    $monitor("Time=%t, CLK=%b, RST=%b, newPC=%h, PC=%h, nextPC=%h, Ins=%h, WE=%b",
             $time, CLK, RST, newPC, PC, nextPC, Ins, WE);
end

endmodule
