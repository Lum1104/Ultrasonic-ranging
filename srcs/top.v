`timescale 1ns / 1ps


module top(
    input          clk     , // ʱ���ź�
    input          rst_n   , // reset��ť
    output         trig    , // trig�ź�
    
    input          echo    , // echo�ź�
    output [3:0]   sel     , // λѡ�ź�
    output [7:0]   seg     , // ��ѡ�ź�
    output [2:0]   led     ,
    input          key     ,
    output [3:0]   sel_1   ,
    output [7:0]   seg_1   
    );
    
    wire [13:0]   distance  ; // ���루���������
    wire             key_value   ;
    
   key_debounce  key_debounce(
    	.sys_clk     (clk),          //�ⲿ100Mʱ��
    	.sys_rst_n  (rst_n),        //�ⲿ��λ�źţ�����Ч
    
    	.key           (key),              //�ⲿ��������
    	.key_flag   (),         //����������Ч�ź�
	.key_value (key_value)         //���������������  
    );  

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
    // ����ģ��
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
