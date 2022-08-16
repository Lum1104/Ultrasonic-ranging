`timescale 1ns / 1ps


module top(
    input          clk     , // 时钟信号
    input          rst_n   , // reset按钮
    output         trig    , // trig信号
    
    input          echo    , // echo信号
    output [3:0]   sel     , // 位选信号
    output [7:0]   seg       // 段选信号
    );
    
    wire [13:0]   distance  ; // 距离（用于输出）
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
    
endmodule
