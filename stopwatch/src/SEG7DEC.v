module SEG7DEC (DIN, nHEX);
input [3:0] DIN;
output reg [7:0] nHEX;

always @(DIN) begin
    case (DIN)
	4'b0000: nHEX = 8'b11000000; // 0
	4'b0001: nHEX = 8'b11111001; // 1
	4'b0010: nHEX = 8'b10100100; // 2
	4'b0011: nHEX = 8'b10110000; // 3
	4'b0100: nHEX = 8'b10011001; // 4
	4'b0101: nHEX = 8'b10010010; // 5
	4'b0110: nHEX = 8'b10000010; // 6
	4'b0111: nHEX = 8'b11111000; // 7
	4'b1000: nHEX = 8'b10000000; // 8
	4'b1001: nHEX = 8'b10010000; // 9
	4'b1010: nHEX = 8'b10001000; // A
	4'b1011: nHEX = 8'b10000011; // B
	4'b1100: nHEX = 8'b11000110; // C
	4'b1101: nHEX = 8'b10100001; // D
	4'b1110: nHEX = 8'b10000110; // E
	4'b1111: nHEX = 8'b10001110; // F
    endcase
end
endmodule
