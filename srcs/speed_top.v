`timescale 1ns / 1ps


module speed_top(
    input     clk     ,
    input     rst_n   ,
    input     key     ,
    input [13:0]   distance  ,
    
    output [2:0]   led    ,
    output [3:0]   sel   ,
    output [7:0]   seg   
    );
    
    wire [13:0]   tube_data   ;
    
    speed_gen speed_gen(
        .clk      (clk      ) ,
        .rst_n    (rst_n    ) ,
        .key      (key      ) ,
        .distance (distance ) ,
    
        .led      (led      ) ,
        .tube_data(tube_data)    
    );
    
    tube tube_0(
         .clk    (clk)  ,
         .rst_n  (rst_n)  ,
         .dis_data(tube_data),
            
         .sel_reg     (sel)   ,
         .seg_reg     (seg)
        );
    
endmodule
