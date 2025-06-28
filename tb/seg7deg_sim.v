`timescale 1 ps/ 1 ps
module seg7deg_sim();
// constants                                           
// general purpose registers
reg [3:0] din; // input to the module
wire [7:0] nhex; // output from the module
// wires                                               
//
// assign statements (if any)                          
SEG7DEC u1 (
// port map - connection between master ports and signals/registers   
    .DIN(din),
    .nHEX(nhex)
);

parameter CYCLE=4000;

initial
begin
  din = 4'b0000;
end

always # (CYCLE/2)
	din <= din + 1; 

endmodule
