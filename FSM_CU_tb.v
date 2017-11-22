module FSM_CU_tb;
reg Go_tb, CLK_tb;
reg [1:0] Op_tb;
wire [1:0] Sel1_tb, WA_tb, RAA_tb, RAB_tb, C_tb;
wire WE_tb, REA_tb, REB_tb, Sel2_tb, Done_tb;
wire [2:0] CS_tb;
parameter 
Idle = 15'b01_00_0_00_0_00_0_00_0_0,
LoadA = 15'b11_01_1_00_0_00_0_00_0_0, 
LoadB = 15'b10_10_1_00_0_00_0_00_0_0,
Wait  = 15'b01_00_0_00_0_00_0_00_0_0,
Add   = 15'b00_11_1_01_1_10_1_00_0_0, 
Sub   = 15'b00_11_1_01_1_10_1_01_0_0, 
And   = 15'b00_11_1_01_1_10_1_10_0_0, 
Xor   = 15'b00_11_1_01_1_10_1_11_0_0, 
Display  = 15'b01_00_0_11_1_11_1_10_1_1;

reg [14:0] Control_tb;
integer i, j;

FSM_CU U0(.Go(Go_tb), .CLK(CLK_tb), .Op(Op_tb), .Sel1(Sel1_tb), .WA(WA_tb), .RAA(RAA_tb), .RAB(RAB_tb), .C(C_tb), .WE(WE_tb), .REA(REA_tb), .REB(REB_tb), .Sel2(Sel2_tb), .Done(Done_tb), .CS(CS_tb));

task clock; begin #5 CLK_tb = 1;  #5 CLK_tb = 0; end endtask
task fiveclock; begin clock; clock; clock; clock; clock; end endtask

always @ (*) Control_tb = {Sel1_tb, WA_tb, WE_tb, RAA_tb, REA_tb, RAB_tb, REB_tb, C_tb, Sel2_tb, Done_tb};


initial
begin

CLK_tb =0;

for(j=0;j<4;j=j+1)begin
    Op_tb=j;
    Go_tb=0;
    clock; //S0
    if(Control_tb != Idle) begin $display("S0 error"); $stop; end
    
    Go_tb=1;
    clock; //S1
    if(Control_tb != LoadA) begin $display("S1 error"); $stop; end
    
    clock; //S2
    if(Control_tb != LoadB) begin $display("S2 error"); $stop; end
    
    clock; //S3
    if({Control_tb[14:4],Control_tb[1:0]} != 13'b00_11_1_01_1_10_1_0_0)
        case(Op_tb)
        2'b11: if(Control_tb[3:2]!= 2'b11) begin $display("S3 Add error"); $stop; end
        2'b10: if(Control_tb[3:2]!= 2'b10) begin $display("S3 Sub error"); $stop; end
        2'b01: if(Control_tb[3:2]!= 2'b01) begin $display("S3 And error"); $stop; end
        default: if(Control_tb[3:2]!= 2'b00) begin $display("S3 Xor error"); $stop; end
        endcase
    
    clock; //S4
    if(Control_tb != Display) begin $display("S4 error"); $stop; end
    
    clock;
    end

    $stop;
    $display("done");
end
endmodule
