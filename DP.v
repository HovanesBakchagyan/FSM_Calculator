module DP(in1, in2, s1, clk, wa, we, raa, rea, rab, reb, c, s2, out);
input [2:0] in1, in2;
input [1:0] s1, wa, raa, rab, c;
input we, rea, reb, s2, clk;
output [2:0] out;
wire [2:0] mux1out;
wire [2:0] douta;
wire [2:0] doutb;
wire [2:0] aluout;
// instantiate the building blocks
MUX1 U0(.in1(in1), .in2(in2), .in3(3'b000), .in4(aluout), .s1(s1), .m1out(mux1out));
RF U1(.clk(clk), .rea(rea), .reb(reb), .raa(raa), .rab(rab), .we(we), .wa(wa), .din(mux1out), .douta(douta), .doutb(doutb));
ALU U2(.in1(douta), .in2(doutb), .c(c), .aluout(aluout));
MUX2 U3(.in1(aluout), .in2(3'b000), .s2(s2), .m2out(out));
endmodule //DP
/* Source Code for the Building Blocks Used */
module MUX1(in1, in2, in3, in4, s1, m1out);
input [2:0] in1, in2, in3, in4;
input [1:0] s1;
output reg [2:0] m1out;
always @ (in1, in2, in3, in4, s1)
begin
    case (s1)
        2'b11: m1out = in1;
        2'b10: m1out = in2;
        2'b01: m1out = in3;
        default: m1out = in4; // 2'b00
    endcase
end
endmodule //MUX1

module RF(clk, rea, reb, raa, rab, we, wa, din, douta, doutb);
input clk, rea, reb, we;
input [1:0] raa, rab, wa;
input [2:0] din;
output reg [2:0] douta, doutb;
reg [2:0] RegFile [3:0];
always @(rea, reb, raa, rab)
begin
    if (rea)
        douta = RegFile[raa];
    else douta = 3'b000;
    if (reb)
        doutb = RegFile[rab];
    else doutb = 3'b000;
end

always@(posedge clk)
begin
    if (we)
        RegFile[wa] = din;
    else
        RegFile[wa] = RegFile[wa];
end
endmodule //RF

module ALU (in1, in2, c, aluout);
input [2:0] in1, in2;
input [1:0] c;
output reg [2:0] aluout;
always @ (in1, in2, c)
begin
    case (c)
        2'b00: aluout = in1 + in2;
        2'b01: aluout = in1 - in2;
        2'b10: aluout = in1 & in2;
        default: aluout = in1 ^ in2; // 2'b11;
    endcase
end
endmodule //ALU

module MUX2 (in1, in2, s2, m2out);
input [2:0] in1, in2;
input s2;
output reg [2:0] m2out;
always @ (in1, in2, s2)
begin
    if (s2)
        m2out = in1;
    else
        m2out = in2;
end
endmodule //MUX2
