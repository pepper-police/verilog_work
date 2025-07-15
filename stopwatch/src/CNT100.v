module CNT100(CLK, RST, CLR, EN, INC, QH, QL, CA);
input CLK, RST, CLR, EN, INC;
output reg [3:0] QH;
output reg [3:0] QL;
output CA;

assign CA = (EN || INC) && QL == 4'd9 && QH == 4'd9;

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
    QH <= 4'd0;
  else if ((EN || INC) && QL == 4'd9)
  begin
    if (QH == 4'd9)
      QH <= 4'd0;
    else
      QH <= QH + 4'd1;
  end
end

endmodule
