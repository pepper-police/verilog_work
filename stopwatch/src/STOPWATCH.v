// 10ms まで記録
module STOPWATCH(CLK, RST, KEY, SW0, SW2, nHEX0, nHEX1, nHEX2, nHEX3, nHEX4, nHEX5, CA);
input CLK, RST, SW0, SW2;
input [1:0] KEY;
output [7:0] nHEX0, nHEX1, nHEX2, nHEX3, nHEX4, nHEX5;
output CA;

wire en100hz, ms_ca, s_ca, start, secup, minup, clr;
wire [4:0] msec10, msec100, sec1, sec10, min1, min10;

BTN_IN btn_in(
    .CLK(CLK),
    .RST(RST),
    .KEY(KEY),
    .SW({SW2, SW0}),
    .BOUT({secup, minup, clr, start})
);

CNT10MS cnt10ms(
    .CLK(CLK),
    .RST(RST),
    .SW(start),
    .EN100HZ(en100hz)
);

CNT100 cntms(
    .CLK(CLK),
    .RST(RST),
	 .CLR(clr),
    .EN(en100hz),
    .INC(1'b0),
    .QH(msec100),
    .QL(msec10),
    .CA(ms_ca)
);

CNT60 cntsec(
    .CLK(CLK),
    .RST(RST),
    .CLR(clr),
    .EN(ms_ca),
    .INC(secup),
    .QH(sec10),
    .QL(sec1),
    .CA(s_ca)
);

CNT60 cntmin(
    .CLK(CLK),
    .RST(RST),
    .CLR(clr),
    .EN(s_ca),
    .INC(minup),
    .QH(min10),
    .QL(min1),
    .CA(CA)
);

SEG7DEC HEX0 (
    .DIN(msec10),
    .EN(1'b1),
    .DOT(1'b1),
    .nHEX(nHEX0)
);
SEG7DEC HEX1 (
    .DIN(msec100),
    .EN(msec100 != 3'd0),
    .DOT(1'b0),
    .nHEX(nHEX1)
);
SEG7DEC HEX2 (
    .DIN(sec1),
    .EN(1'b1),
    .DOT(1'b1),
    .nHEX(nHEX2)
);
SEG7DEC HEX3 (
    .DIN(sec10),
    .EN(sec10 != 3'd0),
    .DOT(1'b0),
    .nHEX(nHEX3)
);
SEG7DEC HEX4 (
    .DIN(min1),
    .EN(1'b1),
    .DOT(1'b1),
    .nHEX(nHEX4)
);
SEG7DEC HEX5 (
    .DIN(min10),
    .EN(min10 != 3'd0),
    .DOT(1'b0),
    .nHEX(nHEX5)
);

endmodule
