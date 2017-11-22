module Small_Calculator(
input Go, CLK,
input [1:0] Op,
input [2:0] In1, In2,
output Done,
output [2:0] CS, Out
    );

wire we, rea, reb, sel2, done;
wire [1:0] sel1, wa, raa, rab, c;

FSM_CU U0 (.Go(Go), .CLK(CLK), .Op(Op), .Sel1(sel1), .WA(wa), .RAA(raa), .RAB(rab), .C(c), .WE(we), .REA(rea), .REB(reb), .Sel2(sel2), .Done(Done), .CS(CS));
DP U1 (.in1(In1), .in2(In2), .s1(sel1), .clk(CLK), .wa(wa), .we(we), .raa(raa), .rea(rea), .rab(rab), .reb(reb), .c(c), .s2(sel2), .out(Out));
 
Endmodule
