module synchronizer #(parameter NUMBITS = 8) (
    input clk,
    input [NUMBITS-1:0] in,
    output reg [NUMBITS-1:0] out
    );
    
    reg [NUMBITS-1:0] tempVal;
    
    always@(posedge clk)
    begin
        tempVal <= in;
        out <= tempVal;
    end
    
endmodule
