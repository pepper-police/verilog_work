module id_sim;

// パラメータと信号の定義
reg CLK;
reg RST;
reg [31:0] Ins;  // 命令
wire [4:0] Rs, Rt, Rd;  // レジスタ番号
wire [31:0] Rdata1, Rdata2;  // レジスタからの読み出しデータ
wire [31:0] Ed32;  // 符号拡張されたイミディエート
wire RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump;  // 制御信号

// テスト対象のモジュールをインスタンス化
ID id0 (
    .CLK(CLK),
    .RST(RST),
    .Ins(Ins),
    .Rs(Rs),
    .Rt(Rt),
    .Rd(Rd),
    .Rdata1(Rdata1),
    .Rdata2(Rdata2),
    .Ed32(Ed32),
    .RegDst(RegDst),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .Branch(Branch),
    .Jump(Jump)
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
    Ins = 32'h0;
    
    // リセット解除
    #20;
    RST = 0;
    
    // R形式命令のテスト (add $3, $1, $2)
    #10;
    Ins = 32'h00221820;  // opcode=0, rs=1, rt=2, rd=3, shamt=0, funct=add(32)
    
    // I形式命令のテスト (addi $2, $1, 100)
    #10;
    Ins = 32'h20220064;  // opcode=8(addi), rs=1, rt=2, imm=100
    
    // lw命令のテスト (lw $2, 4($1))
    #10;
    Ins = 32'h8C220004;  // opcode=35(lw), rs=1, rt=2, imm=4
    
    // sw命令のテスト (sw $2, 8($1))
    #10;
    Ins = 32'hAC220008;  // opcode=43(sw), rs=1, rt=2, imm=8
    
    // beq命令のテスト (beq $1, $2, 16)
    #10;
    Ins = 32'h10220010;  // opcode=4(beq), rs=1, rt=2, imm=16
    
    // J形式命令のテスト (j 1024)
    #10;
    Ins = 32'h08000400;  // opcode=2(j), address=1024
    
    #20;
    $finish; // シミュレーション終了
end

// モニタリング
initial begin
    $monitor("Time=%t, CLK=%b, RST=%b, Ins=%h, Rs=%d, Rt=%d, Rd=%d, Rdata1=%h, Rdata2=%h, Ed32=%h, RegDst=%b, ALUSrc=%b, MemtoReg=%b, RegWrite=%b, MemRead=%b, MemWrite=%b, Branch=%b, Jump=%b",
             $time, CLK, RST, Ins, Rs, Rt, Rd, Rdata1, Rdata2, Ed32, RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump);
end

endmodule
