module Calculator_FPGA(
input wire GO,
input wire [1:0] OP,
input wire [2:0] IN_A, IN_B,
input wire button,
input wire rst,
input wire clk100MHz,
output wire DONE,
output wire [7:0] LEDOUT, 
output wire [7:0] LEDSEL
    );
    
wire [2:0] OUT, CS;
wire [7:0] seg1,seg2;
wire clock, DONT_USE, clk_5KHz;
supply1[7:0] vcc;
assign seg1[7]=1;
assign seg2[7]=1;

Small_Calculator U0(.Go(GO), .CLK(clock), .Op(OP), .In1(IN_A), .In2(IN_B), .Done(DONE), .CS(CS), .Out(OUT));
bcd_to_7seg U1({1'b0, OUT}, seg1[0], seg1[1], seg1[2], seg1[3], seg1[4], seg1[5], seg1[6]);
bcd_to_7seg U2({1'b0, CS}, seg2[0], seg2[1], seg2[2], seg2[3], seg2[4], seg2[5], seg2[6]);
led_mux U3(clk_5KHz, rst, vcc, vcc, vcc, vcc, vcc, seg2, vcc, seg1, LEDOUT, LEDSEL);
clk_gen U4 (.clk100MHz(clk100MHz), .rst(rst), .clk_4sec(DONT_USE), .clk_5KHz(clk_5KHz));
button_debouncer U5 (.clk(clk_5KHz),.button(button),.debounced_button(clock));

endmodule
