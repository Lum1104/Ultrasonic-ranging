`timescale 1ns / 1ps


module tube(
    input         clk     ,
    input         rst_n   ,
    input [13:0]  dis_data, // 传入distance
    
    output [3:0]  sel_reg     ,//位选
    output [7:0]  seg_reg      //段选
    );
    // 把传入的以mm为单位的距离转换成cm为单位的数字
    wire [3:0]    dis_g   ; 
    wire [3:0]    dis_s   ;
    wire [3:0]    dis_b   ;
    wire [3:0]    dis_q   ;
    // 用于动态扫描
    reg [16:0]    cnt0    ;
    wire          add_cnt0;
    wire          end_cnt0;
    reg [1:0]     cnt1    ;
    wire          add_cnt1;
    wire          end_cnt1;
    // 展示数据
    reg [3:0]     data    ; 
    // 位选及段选信号
    reg [3:0]     sel     ;
    reg [7:0]     seg     ;
    
    // 因为数码管为共阴极的，所以我们将它们全部反向
    assign sel_reg = ~sel ;
    assign seg_reg = ~seg ;
    
    // 计算四位展示数字
    assign dis_g = dis_data%10;
    assign dis_s = (dis_data/10)%10;
    assign dis_b = (dis_data/100)%10;
    assign dis_q = (dis_data/1000)%10;
    
    // 动态扫描
    always@(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin 
            cnt0 <= 1'b0 ;
        end
        else if(add_cnt0)begin 
            if(end_cnt0)
                cnt0 <= 1'b0 ;
            else 
                cnt0 <= cnt0 + 1'b1;
        end
    end
    
    // 初始化
    assign add_cnt0 = 1 ;
    assign end_cnt0 = add_cnt0 && cnt0==100_000-1 ;// 1ms
    
    always@(posedge clk or negedge rst_n)begin
        // 如果按下rst按钮则将cnt重置 
        if(!rst_n)begin 
            cnt1 <= 1'b0; 
        end
        else if(add_cnt1)begin 
            if(end_cnt1)
                cnt1 <= 1'b0 ;
            else 
                cnt1 <= cnt1 + 1'b1 ;
        end
    end
    assign add_cnt1 = end_cnt0 ;
    // 每4ms重置一次
    assign end_cnt1 = add_cnt1 && cnt1==4-1 ;//4ms
    
    // 动态扫描
    always@(*)begin 
        case(cnt1)
            0:begin 
                sel <= 4'b1110 ;
                data <= dis_q ;
            end 
            1:begin 
                sel <= 4'b1101 ;
                data <= dis_b ;
            end
            2:begin 
                sel <= 4'b1011 ;
                data <= dis_s ;
            end 
            3:begin 
                sel <= 4'b0111 ;
                data <= dis_g ;
            end        
            default:begin 
                sel <= sel ;
                data <= data ;
            end    
        endcase
    end 
    // 对应赋值、位选
    always  @(*)begin
        if(sel==4'b1011)begin 
            case(data)
                0:seg <= 8'b01000000;
                1:seg <= 8'b01111001;
                2:seg <= 8'b00100100;
                3:seg <= 8'b00110000;
                4:seg <= 8'b00011001;
                5:seg <= 8'b00010010;
                6:seg <= 8'b00000010;
                7:seg <= 8'b01111000;
                8:seg <= 8'b00000000;
                9:seg <= 8'b00010000;
                default:seg <= 8'b00000000;
            endcase
        end
        else begin  
            case(data)
                0:seg <= 8'b11000000;
                1:seg <= 8'b11111001;
                2:seg <= 8'b10100100;
                3:seg <= 8'b10110000;
                4:seg <= 8'b10011001;
                5:seg <= 8'b10010010;
                6:seg <= 8'b10000010;
                7:seg <= 8'b11111000;
                8:seg <= 8'b10000000;
                9:seg <= 8'b10010000;
                default:seg <= 8'b10000000;
            endcase
        end 
    end
    
endmodule
