module Calculator_tb;
reg Go_tb, CLK_tb;
reg [1:0] Op_tb;
reg [2:0] In1_tb, In2_tb;
wire Done_tb;
wire [2:0] CS_tb;
wire [2:0]  Out_tb;
integer i,j,k;

Small_Calculator U0(.Go(Go_tb), .CLK(CLK_tb), .Op(Op_tb), .In1(In1_tb), .In2(In2_tb), .Done(Done_tb), .CS(CS_tb), .Out(Out_tb));

task clock; begin #5 CLK_tb = 1;  #5 CLK_tb = 0; end endtask



initial
begin
    CLK_tb = 0; 
    Go_tb=0;
    clock;
    
    for(i=0;i<8;i=i+1) begin
        In1_tb = i;
        for(j=0;j<8;j=j+1) begin
           In2_tb = j;
           for(k=0;k<4;k=k+1)begin
            Op_tb=k;
                while(CS_tb!=4) begin
                   
                    Go_tb=0;
                    clock; //S0
                    Go_tb=1; 
                    clock;  //S1
                    clock;  //s2
                    clock;  //s3
                    clock;  //Done, s4
                    case(Op_tb)
                        2'b11: if(Out_tb != (In1_tb + In2_tb)) begin $display("Add error");  end
                        2'b10: if(Out_tb != (In1_tb - In2_tb)) begin $display("Sub error");  end
                        2'b01: if(Out_tb != (In1_tb & In2_tb)) begin $display("And error");  end
                        default: if(Out_tb != (In1_tb ^ In2_tb)) begin $display("Xor error"); end
                    endcase
                    if(!Done_tb) begin $display("Calculation not finished"); $stop; end
                    end
                    clock;
                end
            end
        end
    
$stop;
$display("done");

end
endmodule
