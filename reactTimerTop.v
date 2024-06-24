module reactTimerTop(
    input clk,
    input reset,
    input button1,
    input button2,
    input [2:0] sw,
    output [3:0] an,
    output [7:0] seg,
    output [15:0] led
    );
    
    wire [1:0] tempWires;
    wire [1:0] tempOneShotWires;
    wire startW, stopW;
    wire [15:0] countWire;
    //reg [15:0] cntWire100k;
    wire clk1;
       
    assign led = countWire;
    
    debounceFSM # (.CLKSPDMHZ(100), .DELAYMS(3)) db1 (.clk(clk), .reset(reset), .in(tempWires[1]), .out(tempOneShotWires[1]));
    debounceFSM # (.CLKSPDMHZ(100), .DELAYMS(3)) db2 (.clk(clk), .reset(reset), .in(tempWires[0]), .out(tempOneShotWires[0]));
    oneShotOutput os1(.clk(clk), .in(tempOneShotWires[1]), .out(startW), .reset(reset));
    oneShotOutput os2(.clk(clk), .in(tempOneShotWires[0]), .out(stopW), .reset(reset));

    msTimer milliTimer(.start(startW), .stop(stopW), .res(reset), .clk(clk), .msElapsed(countWire));
    displayDriver dispDr (.indata(countWire), .clk(clk), .sseg(seg), .latchAN(an), .reset(reset));
    synchronizer # (.NUMBITS(2)) synch1 (.clk(clk), .in({button1, button2}), .out(tempWires));

endmodule
