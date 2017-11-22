module FSM_CU(
input Go, CLK,
input [1:0] Op,
output reg [1:0] Sel1, WA, RAA, RAB, C,
output reg WE, REA, REB, Sel2, Done,
output reg [2:0] CS
    );

parameter 
S0 = 3'b000,
S1 = 3'b001,
S2 = 3'b010,
S3 = 3'b011,
S4 = 3'b100,
Idle = 15'b01_00_0_00_0_00_0_00_0_0,
LoadA = 15'b11_01_1_00_0_00_0_00_0_0, 
LoadB = 15'b10_10_1_00_0_00_0_00_0_0,
Wait  = 15'b01_00_0_00_0_00_0_00_0_0,
Add   = 15'b00_11_1_01_1_10_1_00_0_0, 
Sub   = 15'b00_11_1_01_1_10_1_01_0_0, 
And   = 15'b00_11_1_01_1_10_1_10_0_0, 
Xor   = 15'b00_11_1_01_1_10_1_11_0_0, 
Display  = 15'b01_00_0_11_1_11_1_10_1_1;

reg [2:0] NS;
reg [14:0] Control;

always @ (posedge CLK) CS <= NS;

always @ (Control) {Sel1, WA, WE, RAA, REA, RAB, REB, C, Sel2, Done} = Control;

always @ (*)
begin
    case (CS)
    S0: begin
        Control = Idle;
        if (!Go) NS = S0;
        else NS = S1;
        end
    S1: begin
        Control = LoadA;
        NS = S2;
        end
    S2: begin
        Control = LoadB;
        NS = S3;
        end
    S3: begin 
        Control = Wait; 
        case (Op)
        2'b11 : Control = Add; 
        2'b10 : Control = Sub; 
        2'b01 : Control = And; 
        default : Control = Xor;
        endcase
        NS = S4;
        end
    S4: begin
        Control = Display;
        NS = S0;
        end
    default: begin
        Control = Idle;
        NS = S0; // this is the default state
        end
    endcase
end

endmodule
