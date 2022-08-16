`timescale 1ns / 1ps


module top(
    input          clk     , // 时钟信号
    input          rst_n   , // reset按钮
    output         trig    , // trig信号
    
    input          echo    , // echo信号
    output [3:0]   sel     , // 位选信号
    output [7:0]   seg     , // 段选信号
    output [2:0]   led     ,
    input          key     ,
    output [3:0]   sel_1   ,
    output [7:0]   seg_1   
    );
    
    wire [13:0]   distance  ; // 距离（用于输出）
    wire             key_value   ;
    
   key_debounce  key_debounce(
    	.sys_clk     (clk),          //外部100M时钟
    	.sys_rst_n  (rst_n),        //外部复位信号，低有效
    
    	.key           (key),              //外部按键输入
    	.key_flag   (),         //按键数据有效信号
	.key_value (key_value)         //按键消抖后的数据  
    );  

    // tube模块，用于数码管的展示
    tube tube_0(
        .clk    (clk)  ,
        .rst_n  (rst_n)  ,
        .dis_data(distance),
        
        .sel_reg     (sel)   ,
        .seg_reg     (seg)
    );
    // super_dis模块，用于与超声波模块交互，计算障碍物距离
    super_dis super_dis_0(
        .clk    (clk)    ,
        .rst_n  (rst_n)  ,
        .trig   (trig)   ,
        
        .echo   (echo)   ,
        .distance(distance)
    );
    // 测速模块
    speed_top speed_top(
        .clk     (clk),
        .rst_n   (rst_n),
        .key     (key),
        .distance(distance),
    
        .led      (led      ) ,
        .sel   (sel_1),
        .seg   (seg_1)
    );
    
endmodule
