module debounceFSM #(parameter CLKSPDMHZ = 100, parameter DELAYMS = 5) (
    input clk,
    input reset,
    input in,
    output reg out
    );
 
    //calculate and define end of count with parameters
    localparam cntEnd = CLKSPDMHZ * DELAYMS * 1000;
 
    reg cntDn;
    reg [2:0] state;
    //define states
    localparam OUTPUT0 = 0;
    localparam DETECT1 = 1;
    localparam OUTPUT1 = 2;
    localparam DETECT0 = 3;

    //reg to hold count
    reg [21:0] cnt;
    
    //next state logic
    always@(posedge clk)
    begin
        if (reset)
            state <= OUTPUT0;
        else
        begin
            case(state)
            OUTPUT0:
                begin
                    if (in == 1)
                        state <= DETECT1;
                end
            DETECT1:
                begin
                    if (cntDn == 1)
                        state <= OUTPUT1;
                end
            OUTPUT1:
                begin
                    if (in == 0)
                        state <= DETECT0;
                end
            DETECT0:
                begin
                    if (cntDn == 1)
                        state <= OUTPUT0;
                end
            default:
                state <= OUTPUT0;
            endcase
        end
    end
 
    //counter logic
    always@(posedge clk)
    begin
        if (reset)
        begin
            cnt <= 0;
            cntDn <= 0;
        end
        else
        begin
            if (state == OUTPUT1 || state == OUTPUT0)
                cnt <= 0;
            else if (state == DETECT1 || state == DETECT0)
                cnt <= cnt + 1;
                
            if (cnt > cntEnd)
                cntDn <= 1;
            else
                cntDn <= 0;
        end
    end
 
    //output mapping
    always@(state)
    begin
        case(state)
        OUTPUT0: out = 0;
        DETECT1: out = 0;
        OUTPUT1: out = 1;
        DETECT0: out = 1;
        default: out = 0;
        endcase
    end
 
endmodule
