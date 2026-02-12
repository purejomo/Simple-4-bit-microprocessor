`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/21 13:38:40
// Design Name: 
// Module Name: reg8
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


module reg8(data_out, data_in, inen, oen, clk, clr);
    output [7:0] data_out;
    input [7:0] data_in;
    input inen, oen, clk, clr;
    reg [7:0] st;
    
    always @(posedge clk, posedge clr) begin
        if(clr) st=8'b0;
        else if(inen) st=data_in;
        else st=st;
    end
    assign data_out=(oen)?st:8'bz;
endmodule
