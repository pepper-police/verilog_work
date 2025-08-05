module SEG7DEC (DIN, EN, DOT, nHEX);
input [3:0] DIN;
input EN, DOT;
output [7:0] nHEX;
reg [7:0] tmp;

assign nHEX = EN ? (DOT ? tmp & 8'b01111111 : tmp) : 8'b11111111;

always @(DIN) begin
  case (DIN)
    4'b0000: tmp = 8'b11000000; // 0
    4'b0001: tmp = 8'b11111001; // 1
    4'b0010: tmp = 8'b10100100; // 2
    4'b0011: tmp = 8'b10110000; // 3
    4'b0100: tmp = 8'b10011001; // 4
    4'b0101: tmp = 8'b10010010; // 5
    4'b0110: tmp = 8'b10000010; // 6
    4'b0111: tmp = 8'b11111000; // 7
    4'b1000: tmp = 8'b10000000; // 8
    4'b1001: tmp = 8'b10010000; // 9
    4'b1010: tmp = 8'b10001000; // A
    4'b1011: tmp = 8'b10000011; // B
    4'b1100: tmp = 8'b11000110; // C
    4'b1101: tmp = 8'b10100001; // D
    4'b1110: tmp = 8'b10000110; // E
    4'b1111: tmp = 8'b10001110; // F
    default: tmp = 8'b10111111; // -
  endcase
end
endmodule
