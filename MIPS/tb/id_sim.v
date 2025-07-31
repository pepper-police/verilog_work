module id_sim;

parameter PERIOD = 10; // クロック周期

// パラメータと信号の定義
reg CLK;
reg RST;
reg [31:0] Ins;  // 命令
reg [31:0] Wdata;  // 書き込みデータ
wire [31:0] Rdata1, Rdata2;  // レジスタからの読み出しデータ
wire [31:0] Ed32;  // 符号拡張されたイミディエート

// テスト対象のモジュールをインスタンス化
ID id0 (
    .CLK(CLK),
    .RST(RST),
    .Ins(Ins),
    .Wdata(Wdata),
    .Rdata1(Rdata1),
    .Rdata2(Rdata2),
    .Ed32(Ed32)
);

// クロック生成
initial clock = 1'b0;
always #(PERIOD / 2) CLK = ~CLK; // toggle clock

// テストシナリオ
initial begin
    // 初期化
    RST = 1;
    Ins = 32'h0;
    Wdata = 32'h0;
    
    // リセット解除
    #20;
    RST = 0;
    
    // レジスタ1に値をセット
    #10;
    Ins = 32'h34010005;  // ori $1, $0, 5 (レジスタ1に5をセット)
    Wdata = 32'h5;
    
    // レジスタ2に値をセット
    #10;
    Ins = 32'h34020003;  // ori $2, $0, 3 (レジスタ2に3をセット)
    Wdata = 32'h3;
    
    // R形式命令のテスト (add $3, $1, $2)
    #10;
    Ins = 32'h00221820;  // opcode=0, rs=1, rt=2, rd=3, shamt=0, funct=add(32)
    Wdata = 32'h8;  // 実際の加算結果（5+3=8）
    
    // I形式命令のテスト (addi $2, $1, 100)
    #10;
    Ins = 32'h20220064;  // opcode=8(addi), rs=1, rt=2, imm=100
    Wdata = 32'h69;  // 5+100=105(0x69)
    
    // lw命令のテスト (lw $2, 4($1))
    #10;
    Ins = 32'h8C220004;  // opcode=35(lw), rs=1, rt=2, imm=4
    Wdata = 32'h12345678;  // メモリから読み込んだ値のシミュレーション
    
    // sw命令のテスト (sw $2, 8($1))
    #10;
    Ins = 32'hAC220008;  // opcode=43(sw), rs=1, rt=2, imm=8
    Wdata = 32'h0;  // swでは書き込みなし
    
    // beq命令のテスト (beq $1, $2, 16)
    #10;
    Ins = 32'h10220010;  // opcode=4(beq), rs=1, rt=2, imm=16
    Wdata = 32'h0;  // beqでは書き込みなし
    
    // J形式命令のテスト (j 1024)
    #10;
    Ins = 32'h08000400;  // opcode=2(j), address=1024
    Wdata = 32'h0;  // jでは書き込みなし
    
    #20;
    $finish; // シミュレーション終了
end

// モニタリング
initial begin
    $monitor("Time=%t, CLK=%b, RST=%b, Ins=%h, Wdata=%h, Rdata1=%h, Rdata2=%h, Ed32=%h",
             $time, CLK, RST, Ins, Wdata, Rdata1, Rdata2, Ed32);
end

endmodule
