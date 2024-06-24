module binaryToBCDDivideMod(
    input clk,
    input [15:0] val,
    output reg [3:0] bcd3,
    output reg [3:0] bcd2,
    output reg [3:0] bcd1,
    output reg [3:0] bcd0
    );
    
    reg [15:0] p1,p2;
    always@(posedge clk)
    begin
        bcd3 <= val/1000;
        bcd2 <= (val%1000)/100;
        bcd1 <= ((val%1000)%100)/10;
        bcd0 <= (((val%1000)%100)%10);     
    end
endmodule
