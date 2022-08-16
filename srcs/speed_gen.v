`timescale 1ns / 1ps


module speed_gen(
    input     clk     ,
    input     rst_n   ,
    input     key     ,
    input [13:0]   distance  ,
    
    output [2:0]   led    ,
    output reg [13:0]   tube_data    
    );
    
    reg          key_1       ;
    reg          key_2       ;
    wire         key_neg     ;
    reg [2:0]    state       ;
    reg [13:0]   data_1      ;
    reg [13:0]   data_2      ;
    reg [30:0]   dis_time    ;
    wire [30:0]   speed_data  ; 
    
    assign led = state ;
    
    always@(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin 
            key_1 <= 0 ;
            key_2 <= 0 ;
        end 
        else begin 
            key_1 <= key ;
            key_2 <= key_1 ;
        end 
    end 
    assign key_neg = key_1==0 && key_2==1 ;
    
    always@(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin 
            state <= 0 ;
            data_1 <= 0 ;
            data_2 <= 0 ;
        end 
        else begin 
            case(state)
                0:begin 
                    if(key_neg)begin 
                        data_1 <= distance ;
                        state <= 1 ;
                    end 
                    else begin 
                        state <= 0 ;
                        //data_1 <= 0 ;
                    end 
                end 
                1:begin 
                    if(key_neg)begin 
                        data_2 <= distance ;
                        state <= 2 ;
                    end 
                    else begin 
                        state <= 1 ;
                        //data_2 <= 0 ;
                    end 
                end 
                2:begin 
                    if(key_neg)begin
                        state <= 0 ;
                    end 
                    else begin 
                        state <= 2 ; 
                    end 
                end 
            endcase 
        end 
    end 
    
    always@(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin 
            dis_time <= 0 ;
        end 
        else if(state==1)begin 
            dis_time <= dis_time + 1 ;
        end 
        else if(state==0&&key_neg)begin 
            dis_time <= 0  ;
        end 
        else begin 
            dis_time <= dis_time ;
        end 
    end 
    
    wire [13:0]    time_data    ;
    
    assign time_data = dis_time / 10_000_000 ;
    
    reg [13:0]   data_cha   ;
    
    always@(posedge clk or negedge rst_n)begin //     1/100_000_000 * dis_time 
        if(!rst_n)begin 
            data_cha <= 0 ;
        end 
        else if(data_2>=data_1)begin 
            data_cha <= data_2 - data_1 ;
        end 
        else begin 
            data_cha <= data_1 - data_2 ;
        end 
    end 
    
    assign speed_data = data_cha / time_data ;
    
    /*always@(posedge clk or negedge rst_n)begin //     1/100_000_000 * dis_time 
        if(!rst_n)begin 
            speed_data <= 0 ;
        end 
        else if(state==2&&key_neg)begin 
            speed_data <= (data_2 - data_1)*100_000_000 / dis_time ;
        end 
    end */
    
    always@(posedge clk or negedge rst_n)begin //     1/100_000_000 * dis_time 
        if(!rst_n)begin 
            tube_data <= 0 ;
        end 
        else if(state==0)begin 
            tube_data <= speed_data[13:0] ;
        end 
        else if(state==1)begin 
            tube_data <= data_1 ;
        end 
        else if(state==2)begin 
            tube_data <= data_2 ;
        end 
    end 
    
endmodule
