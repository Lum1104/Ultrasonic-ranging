`timescale 1ns / 1ps


module top(
    input          clk     , // ʱ���ź�
    input          rst_n   , // reset��ť
    output         trig    , // trig�ź�
    
    input          echo    , // echo�ź�
    output [3:0]   sel     , // λѡ�ź�
    output [7:0]   seg       // ��ѡ�ź�
    );
    
    wire [13:0]   distance  ; // ���루���������
    // tubeģ�飬��������ܵ�չʾ
    tube tube_0(
        .clk    (clk)  ,
        .rst_n  (rst_n)  ,
        .dis_data(distance),
        
        .sel_reg     (sel)   ,
        .seg_reg     (seg)
    );
    // super_disģ�飬�����볬����ģ�齻���������ϰ������
    super_dis super_dis_0(
        .clk    (clk)    ,
        .rst_n  (rst_n)  ,
        .trig   (trig)   ,
        
        .echo   (echo)   ,
        .distance(distance)
    );
    
endmodule