module displayDriver # (parameter CLKFREQ = 100, parameter DISPFREQ = 75)(
    input [15:0] indata,
    input clk,
    input reset,
    output reg[7:0] sseg,
    output reg[3:0] latchAN
    );
    
    reg [1:0] segselect;
    reg [15:0] data;
    //wire [3:0] hex0, hex1, hex2, hex3; - These must be reg for dabble
    reg [31:0] count;
    
    reg [3:0] hex0, hex1, hex2, hex3;
    wire [3:0] ddhex0, ddhex1, ddhex2, ddhex3;
    reg [1:0] pollState;
    reg start;
    wire done;
    
    localparam HEX_0_STOP = $rtoi(0.25 * CLKFREQ * 1000000 / (DISPFREQ * 4));
    localparam HEX_1_STOP = $rtoi(0.5 * CLKFREQ * 1000000 / (DISPFREQ * 4));
    localparam HEX_2_STOP = $rtoi(0.75 * CLKFREQ * 1000000 / (DISPFREQ * 4));
    localparam HEX_3_STOP = $rtoi(1.0 * CLKFREQ * 1000000 / (DISPFREQ * 4)); 
    
    // dabble params
    localparam STARTON = 0;
    localparam STARTOFF = 1;
    localparam LATCHVALS = 2;
    
    //assign hex3 = indata[15:12];
    //assign hex2 = indata[11:8];
    //assign hex1 = indata[7:4];
    //assign hex0 = indata[3:0]; 
    
    //binaryToBCDLookup bcdrom(.val(indata), .bcd3(hex3), .bcd2(hex2), .bcd1(hex1), .bcd0(hex0));
    //binaryToBCDRam bcdram(.clk(clk), .val(indata), .bcd3(hex3), .bcd2(hex2), .bcd1(hex1), .bcd0(hex0));
    //binaryToBCDDivideMod bcdmod(.clk(clk), .val(indata), .bcd3(hex3), .bcd2(hex2), .bcd1(hex1), .bcd0(hex0));
    binaryToBCDDabble bcddab(.clk(clk), .reset(reset), .start(start), .val(indata), .bcd3(ddhex3), .bcd2(ddhex2), .bcd1(ddhex1), .bcd0(ddhex0), .done(done));
    
    // BCDDD logic
    always@(posedge clk)
    begin
        case(pollState)
        STARTON:
        begin
            start <= 1;
            pollState <= STARTOFF;
        end
        STARTOFF:
        begin
            start <= 0;
            if (done)
                pollState <= LATCHVALS;
        end
        LATCHVALS:
        begin
            hex3 <= ddhex3;
            hex2 <= ddhex2;
            hex1 <= ddhex1;
            hex0 <= ddhex0;
            if (~done)
                pollState <= STARTON;
        end
        default:
        begin
            start <= 0;
            pollState <= STARTON;
        end
        endcase
    end   
    
    always@(posedge clk)
    begin
        count <= count + 1;
        if(count < HEX_0_STOP)
            segselect <= 3;
         else if (count < HEX_1_STOP)
            segselect <= 2;
         else if (count <= HEX_2_STOP)
            segselect <= 1;
         else if (count <= HEX_3_STOP)
            segselect <= 0;
         else
            count <= 0;
    end
    
    reg [3:0] hexVal;
    reg [3:0] AN;
    
    always@(segselect, hex0, hex1, hex2, hex3)
    begin
        case(segselect)
            0:
                begin
                    hexVal = hex0;
                    AN = 4'b1110;
                end
            1: 
                begin
                    hexVal = hex1;
                    AN = 4'b1101;
                end
            2:
                begin
                    hexVal = hex2;
                    AN = 4'b1011;
                end
            3:
                begin
                    hexVal = hex3;
                    AN = 4'b0111;
                end
        endcase
    end
    
    always@(posedge clk)
    begin
        latchAN <= AN;
        case(hexVal)
            4'b0000: sseg <= 8'b11000000;
            4'b0001: sseg <= 8'b11111001;
            4'b0010: sseg <= 8'b10100100;
            4'b0011: sseg <= 8'b10110000;
            4'b0100: sseg <= 8'b10011001;
            4'b0101: sseg <= 8'b10010010;
            4'b0110: sseg <= 8'b10000010;
            4'b0111: sseg <= 8'b11111000;
            4'b1000: sseg <= 8'b10000000;
            4'b1001: sseg <= 8'b10011000;
            4'b1010: sseg <= 8'b10001000;
            4'b1011: sseg <= 8'b10000011;
            4'b1100: sseg <= 8'b10100111;
            4'b1101: sseg <= 8'b10100001;
            4'b1110: sseg <= 8'b10000110;
            4'b1111: sseg <= 8'b10001110;
    
            default: sseg = 8'b11111111;
        endcase
    end 
endmodule
