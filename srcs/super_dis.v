`timescale 1ns / 1ps


module super_dis(
    input            clk     , // 100MHZ
    input            rst_n   , // 低电平有效
    output           trig    , // 超声波回响信号
    
    input            echo    , // 超声波触发信号
    output reg [13:0]    distance // 障碍物距离
    );
    
    reg [26:0]        cnt        ;
    wire              add_cnt    ;
    wire              end_cnt    ; 
    reg [2:0]         cnt_d      ;
    wire              add_cnt_d  ;
    wire              end_cnt_d  ;
    reg [26:0]        cnt_echo   ;
    wire              add_cnt_echo;
    wire              end_cnt_echo; 
    reg [26:0]        distance_1  ;
    
    always@(posedge clk or negedge rst_n)begin 
        if(!rst_n)
            cnt <= 1'b0;
        else if(add_cnt)begin 
            if(end_cnt)
                cnt <= 1'b0;
            else 
                cnt <= cnt + 1'b1;
        end
    end
    assign add_cnt = 1;
    assign end_cnt = add_cnt && cnt==10_000_000-1 ; // 100ms
    
    assign trig = (cnt>=100&&cnt<=2000) ? 1'b1 : 1'b0 ; // 产生19us触发信号
    
    ///////
    always@(posedge clk or negedge rst_n)begin 
        if(!rst_n)
            cnt_d <= 1'b0 ;
        else if(add_cnt_d)begin 
            if(end_cnt_d)
                cnt_d <= 1'b0 ;
            else 
                cnt_d <= cnt_d + 1'b1 ;
        end
    end
    assign add_cnt_d = end_cnt ;
    assign end_cnt_d = add_cnt_d && cnt_d==5-1 ;
    
    //记录回响信号时间
    always@(posedge clk or negedge rst_n)begin 
        if(!rst_n)
            cnt_echo <= 1'b0;
        else if(echo)
            cnt_echo <= cnt_echo + 1'b1;
        else if(end_cnt)
            cnt_echo <= 1'b0;
    end 
    
    //计算距离
    always@(posedge clk or negedge rst_n)begin //     1/10_000 * cnt_echo * 17 1
        if(!rst_n)
            distance_1 <= 1'b0;
        else if(cnt==10_000_000-5)
            distance_1 <= (cnt_echo*17)/10_000 + distance_1;//mm  
        else if(end_cnt_d)begin 
            distance_1 <= 0 ;
        end
    end
    
    //取平均数据滤波
    always@(posedge clk or negedge rst_n)begin 
        if(!rst_n)
            distance <= 1'b0 ;
        else if(cnt_d==4&&cnt==10_000_000-5)begin 
            distance <= distance_1 / 5 ;
        end 
        else 
            distance <= distance ;
    end
    
endmodule