module binaryToBCDDabble(
     input clk,
     input reset,
     input start,
     input [13:0] val,
     output [3:0] bcd3,
     output [3:0] bcd2,
     output [3:0] bcd1,
     output [3:0] bcd0,
     output reg done
    );
    
    reg [2:0] state;
    localparam IDLESTATE = 0;
    localparam SHIFTSTATE = 1;
    localparam CHECKSHIFTSTATE = 2;
    localparam ADDSTATE = 3;
    localparam CHECKADDSTATE = 4;
    localparam DONESTATE = 5;
    
    reg [3:0] shiftCount = 0;
    reg [29:0] workReg = 0;
    
    assign {bcd3, bcd2, bcd1, bcd0} = workReg[29:14];
    
    always@(posedge clk)
    begin
        case(state)
        IDLESTATE:
            begin
                shiftCount <= 0;
                done <= 0;
                if(start)
                begin
                    workReg <= {16'h0000, val};
                    state <= SHIFTSTATE;
                end
                else
                begin
                    state <= IDLESTATE;
                end
            end    
        SHIFTSTATE:
            begin
                workReg <= workReg << 1;
                state <= CHECKSHIFTSTATE;
            end
        CHECKSHIFTSTATE:
            begin
                if(shiftCount == 13)
                begin
                    state <= DONESTATE;
                end
                else
                begin
                    shiftCount <= shiftCount + 1;
                    state <= ADDSTATE;
                end
            end
        ADDSTATE:
            begin
                state <= SHIFTSTATE;
                if(workReg[29:26] > 4)
                    workReg[29:26] <= workReg[29:26] + 3;
                if(workReg[25:22] > 4)
                    workReg[25:22] <= workReg[25:22] + 3;
                if(workReg[21:18] > 4)
                    workReg[21:18] <= workReg[21:18] + 3;
                if(workReg[17:14] > 4)
                    workReg[17:14] <= workReg[17:14] + 3;
            end
        DONESTATE:
            begin
                done <= 1;
                state <= IDLESTATE;
            end
        default:
            begin
                state <= IDLESTATE;
            end
        endcase
    end
endmodule
