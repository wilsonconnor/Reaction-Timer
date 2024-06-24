module oneShotOutput(
    input clk,
    input in,
    input reset,
    output reg out
    );
    
    reg [1:0] state;
    
    localparam IDLE = 0;
    localparam OUTPUT1 = 1;
    localparam WAITFOR0 = 2;
    
    always@(posedge clk)
    begin
        if(reset)
        begin
            state <= IDLE;
        end
        else
        begin
            case(state)
            IDLE:
                begin
                    if(in)
                    begin
                        state <= OUTPUT1;
                    end
                end
            OUTPUT1:
                begin
                    state <= WAITFOR0;
                end
            WAITFOR0:
                begin
                    if(~in)
                    begin
                        state <= IDLE;
                    end
                end
            default:
            begin
                state <= IDLE;
            end 
            endcase
        end
    end
    
    always@(state)
    begin
        case(state)
            IDLE: out = 0;
            OUTPUT1: out = 1;
            WAITFOR0: out = 0;
            default: out = 0;
        endcase
    end 
endmodule
