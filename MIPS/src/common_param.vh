// common_param.vh
// MIPS命令セット用共通パラメータファイル

// グローバルパラメータ
parameter WIDTH = 32;         // データ幅（32ビット）
parameter IMEM_SIZE = 128;    // 命令メモリサイズ
parameter REGFILE_SIZE = 32;  // レジスタファイルサイズ（32個のレジスタ）
parameter DMEM_SIZE = 128;    // データメモリサイズ

// オペレーションコード (*) Op==6'd0の場合はファンクションコードで判別
parameter R_FORM = 6'd0;      // R形式命令（レジスタ形式）

// オペレーションコード（ファンクションコードなし）
parameter LW   = 6'd35;       // Load Word：メモリからワードをロード
parameter SW   = 6'd43;       // Store Word：メモリにワードをストア

// ファンクションコード（ALU演算）Op==6'd0の場合
parameter ADD  = 6'd32;       // Add：レジスタ加算（オーバーフロー例外あり）
parameter ADDU = 6'd33;       // Add Unsigned：レジスタ加算（オーバーフロー例外なし）
parameter SUB  = 6'd34;       // Subtract：レジスタ減算（オーバーフロー例外あり）
parameter SUBU = 6'd35;       // Subtract Unsigned：レジスタ減算（オーバーフロー例外なし）
parameter AND  = 6'd36;       // Bitwise AND：論理積
parameter OR   = 6'd37;       // Bitwise OR：論理和
parameter XOR  = 6'd38;       // Bitwise XOR：排他的論理和
parameter NOR  = 6'd39;       // Bitwise NOR：論理和の否定
parameter SLT  = 6'd42;       // Set on Less Than：符号付き比較
parameter SLTU = 6'd43;       // Set on Less Than Unsigned：符号なし比較

// オペレーションコード（即値命令）
parameter ADDI  = 6'd8;       // Add Immediate：即値加算（オーバーフロー例外あり）
parameter ADDIU = 6'd9;       // Add Immediate Unsigned：即値加算（オーバーフロー例外なし）
parameter SLTI  = 6'd10;      // Set on Less Than Immediate：即値との符号付き比較
parameter SLTIU = 6'd11;      // Set on Less Than Immediate Unsigned：即値との符号なし比較
parameter ANDI  = 6'd12;      // Bitwise AND Immediate：即値との論理積
parameter ORI   = 6'd13;      // Bitwise OR Immediate：即値との論理和
parameter XORI  = 6'd14;      // Bitwise XOR Immediate：即値との排他的論理和
//parameter LUI   = 6'd15;    // Load Upper Immediate：上位16ビットに即値をロード

// ファンクションコード（シフト演算）Op==6'd0の場合
parameter SLL   = 6'd0;       // Shift Left Logical：論理左シフト（シフト量は即値）
parameter SRL   = 6'd2;       // Shift Right Logical：論理右シフト（シフト量は即値）
parameter SRA   = 6'd3;       // Shift Right Arithmetic：算術右シフト（シフト量は即値）
parameter SLLV  = 6'd4;       // Shift Left Logical Variable：論理左シフト（シフト量はレジスタ）
parameter SRLV  = 6'd6;       // Shift Right Logical Variable：論理右シフト（シフト量はレジスタ）
parameter SRAV  = 6'd7;       // Shift Right Arithmetic Variable：算術右シフト（シフト量はレジスタ）

// ファンクションコード（乗除算）Op==6'd0の場合
parameter MFHI   = 6'd16;     // Move From HI：HIレジスタからの移動
parameter MTHI   = 6'd17;     // Move To HI：HIレジスタへの移動
parameter MFLO   = 6'd18;     // Move From LO：LOレジスタからの移動
parameter MTLO   = 6'd19;     // Move To LO：LOレジスタへの移動
parameter MULT   = 6'd24;     // Multiply：符号付き乗算（結果はHI:LO）
parameter MULTU  = 6'd25;     // Multiply Unsigned：符号なし乗算（結果はHI:LO）
parameter DIV    = 6'd26;     // Divide：符号付き除算（商はLO、余りはHI）
parameter DIVU   = 6'd27;     // Divide Unsigned：符号なし除算（商はLO、余りはHI）

// ファンクションコード（ジャンプ）Op==6'd0の場合
parameter JR     = 6'd8;      // Jump Register：レジスタ値へのジャンプ
parameter JALR   = 6'd9;      // Jump And Link Register：レジスタ値へのジャンプとリンク

// オペレーションコード（ジャンプ・分岐命令）
parameter BLTZ   = 6'd1;      // Branch on Less Than Zero：ゼロより小さい場合分岐
parameter BGEZ   = 6'd1;      // Branch on Greater than or Equal to Zero：ゼロ以上の場合分岐
//parameter BLTZAL = 6'd1;    // Branch on Less Than Zero And Link：ゼロより小さい場合分岐とリンク
//parameter BGEZAL = 6'd1;    // Branch on Greater than or Equal to Zero And Link：ゼロ以上の場合分岐とリンク
parameter J      = 6'd2;      // Jump：無条件ジャンプ
parameter JAL    = 6'd3;      // Jump And Link：無条件ジャンプとリンク
parameter BEQ    = 6'd4;      // Branch on Equal：等しい場合分岐
parameter BNE    = 6'd5;      // Branch on Not Equal：等しくない場合分岐
parameter BLEZ   = 6'd6;      // Branch on Less than or Equal to Zero：ゼロ以下の場合分岐
parameter BGTZ   = 6'd7;      // Branch on Greater Than Zero：ゼロより大きい場合分岐

// rt[20:16]フィールドコード（BLTZまたはBGEZ判別用）
parameter BLTZ_r = 5'd0;      // BLTZ命令の場合のrtフィールド値
parameter BGEZ_r = 5'd1;      // BGEZ命令の場合のrtフィールド値

// End of common_param.vh
