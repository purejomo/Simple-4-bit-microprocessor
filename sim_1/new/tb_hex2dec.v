`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/21 16:54:06
// Design Name: 
// Module Name: tb_hex2dec
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_hex2dec();

    reg [7:0] h;
    integer i;
    
    wire [3:0] dec_h;
    wire [3:0] dec_l;
    
    hex2dec UUT(
                .h(h),
                .dec_h(dec_h),
                .dec_l(dec_l)
                );
    initial begin 
        h=0;
        for(i=0;i<82;i=i+1)
        begin
            h = i; #100;
        end
    end
endmodule
