module seven(inp, a, b, c, d, e, f, g);
input [2:0] inp;
output reg a, b, c, d, e, f, g;

always @(inp)
begin
  case (inp)
    3'b000: begin
      a <= 1'b1;
      b <= 1'b1;
      c <= 1'b1;
      d <= 1'b1;
      e <= 1'b1;
      f <= 1'b1;
      g <= 1'b0;
      end
    3'b001: begin
      a <= 1'b0;
      b <= 1'b1;
      c <= 1'b1;
      d <= 1'b0;
      e <= 1'b0;
      f <= 1'b0;
      g <= 1'b0;
      end
    3'b010: begin
      a <= 1'b1;
      b <= 1'b1;
      c <= 1'b0;
      d <= 1'b1;
      e <= 1'b1;
      f <= 1'b0;
      g <= 1'b1;
      end
    3'b011: begin
      a <= 1'b1;
      b <= 1'b1;
      c <= 2'b1;
      d <= 1'b1;
      e <= 1'b0;
      f <= 1'b0;
      g <= 1'b1;
      end
    default: begin
      a <= 1'b1;
      b <= 1'b0;
      c <= 1'b0;
      d <= 1'b1;
      e <= 1'b1;
      f <= 1'b1;
      g <= 1'b1;
      end
  endcase
end
endmodule
