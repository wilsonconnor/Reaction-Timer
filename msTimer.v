module msTimer #(parameter CLKSPDMHZ = 100)(
    input start,
    input stop,
    input res,
    input clk,
    output reg [15:0] msElapsed
    );
    
    reg en;
    reg [31:0] count;
 
    localparam STOP_COUNT = 9999;
    localparam ONE_MS_CNT = CLKSPDMHZ*1000 - 1;
    
    always@(posedge clk)
    begin
        if(res)
        begin
            count <= 0;
            en <= 0;
            msElapsed <= 0;
        end
        else
        begin
            if(en)
            begin
                count <= count + 1;
            end
            
            if(start)
            begin
                en <= 1;
            end
            else if (stop)
            begin
                en <= 0;
            end
            
            if(count == ONE_MS_CNT)
            begin
                msElapsed <= msElapsed + 1;
                count <= 0; 
                if(msElapsed == STOP_COUNT)
                begin
                    msElapsed <= 0;
                end
            end
        end 
    end
endmodule
module msTimer #(parameter CLKSPDMHZ = 100)(
    input start,
    input stop,
    input res,
    input clk,
    output reg [15:0] msElapsed
    );
    
    reg en;
    reg [31:0] count;
 
    localparam STOP_COUNT = 9999;
    localparam ONE_MS_CNT = CLKSPDMHZ*1000 - 1;
    
    always@(posedge clk)
    begin
        if(res)
        begin
            count <= 0;
            en <= 0;
            msElapsed <= 0;
        end
        else
        begin
            if(en)
            begin
                count <= count + 1;
            end
            
            if(start)
            begin
                en <= 1;
            end
            else if (stop)
            begin
                en <= 0;
            end
            
            if(count == ONE_MS_CNT)
            begin
                msElapsed <= msElapsed + 1;
                count <= 0; 
                if(msElapsed == STOP_COUNT)
                begin
                    msElapsed <= 0;
                end
            end
        end 
    end
endmodule
