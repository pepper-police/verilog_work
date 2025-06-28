module CNT60 (CLK, RST, CLR, EN, INC, QH, QL, CA);
input CLK, RST, CLR, EN, INC;
output [2:0] QH;
output [3:0] QL;
output CA;
reg [2:0] QH;
reg [3:0] QL;
wire ca10, EN10, CA;

assign EN10 = EN | INC;
assign ca10 = (QL == 4'd9) & EN10; // carry regardless of the clock
assign CA = (QH == 3'd5) & ca10; 

// 10 counter
always @(posedge CLK) begin
    if (RST|CLR) begin
	    QL <= 4'b0;
    end else if (EN10) begin
	    if (QL >= 4'd9) begin
		    QL <= 4'b0;
	    end else begin
		    QL <= QL + 1'b1;
	    end
    end
end

// 6 counter
always @(posedge CLK) begin
    if (CLR | RST) begin
	QH <= 3'b0;
    end else if (ca10) begin
	    if (QH >= 3'd5) begin
		    QH <= 3'b0;
	    end else begin
		    QH <= QH + 1'b1;
	    end
    end
end

endmodule
