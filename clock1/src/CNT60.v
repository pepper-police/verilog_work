module CNT60(CLK, RST, CLR, EN, INC, QH, QL, CA);
input CLK, RST, CLR, EN, INC;
output reg [2:0] QH;
output reg [3:0] QL;
output CA;

assign CA = EN && QL == 4'd9 && QH == 3'd5;

always @(posedge CLK)
begin
  if (RST || CLR)
    QL <= 4'd0;
  else if (EN || INC)
  begin
    if (QL == 4'd9)
      QL <= 4'd0;
    else
      QL <= QL + 4'd1;
  end
end

always @(posedge CLK)
begin
  if (RST || CLR)
    QH <= 3'd0;
  else if ((EN || INC) && QL == 4'd9)
  begin
    if (QH == 3'd5)
      QH <= 3'd0;
    else
      QH <= QH + 3'd1;
  end
end

endmodule
