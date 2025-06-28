module CLOCK1 (
    input   CLK, RST,
    input       [2:0]   KEY,
    output [7:0] nHEX0, nHEX1, nHEX2, nHEX3,
    output   CA
);

	wire en1hz, ca;
	wire secup, minup, clr;
	wire [3:0] sec1, min1;
	wire [2:0] sec10, min10;

	BTN_IN btn_in (
		.CLK(CLK),
		.RST(RST),
		.nBIN(KEY),
		.BOUT({secup, minup, clr})
	);
	CNT1SEC cnt1sec (
		.CLK(CLK),
		.RST(RST),
		.EN1HZ(en1hz)
	);
	CNT60 cntsec (
		.CLK(CLK),
		.RST(RST),
		.CLR(clr),
		.EN(en1hz),
		.INC(secup),
		.QH(sec10),
		.QL(sec1),
		.CA(ca)
	);
	CNT60 cntmin (
		.CLK(CLK),
		.RST(RST),
		.CLR(clr),
		.EN(ca),
		.INC(minup),
		.QH(min10),
		.QL(min1),
		.CA(CA)
	);

	SEG7DEC HEX0 (
		.DIN(sec1),
		.nHEX(nHEX0)
	);
	SEG7DEC HEX1 (
		.DIN(sec10),
		.nHEX(nHEX1)
	);
	SEG7DEC HEX2 (
		.DIN(min1),
		.nHEX(nHEX2)
	);
	SEG7DEC HEX3 (
		.DIN(min10),
		.nHEX(nHEX3)
	);

endmodule
