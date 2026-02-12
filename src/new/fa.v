`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/21 16:25:43
// Design Name: 
// Module Name: fa
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


module fa(c_in, x_in, y_in, sum, carry);
    input c_in, x_in, y_in;
    output sum, carry;
    
    assign sum = x_in  ^ y_in ^ c_in;
    assign carry = (x_in & y_in & c_in) | (x_in & y_in) | (x_in & c_in) | (y_in & c_in);
endmodule
