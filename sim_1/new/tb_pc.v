`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/21 14:42:16
// Design Name: 
// Module Name: tb_pc
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


module tb_pc();
    reg pc_oen;
    reg pc_inc;
    reg load_pc;
    reg [7:0] pc_input;
    reg clr;
    reg clk;
    
    wire [7:0] pc_out;
    
    pc UUT(
           .clk(clk),
           .clr(clr),
           .pc_inc(pc_inc),
           .load_pc(load_pc),
           .pc_oen(pc_oen),
           .pc_input(pc_input),
           .pc_out(pc_out)
           );
    
    always #50 clk=~clk;
    initial begin
        pc_oen=1;
        pc_inc=0;
        load_pc=0;
        pc_input=8'h13;
        clr=1;
        clk=0;
        #100; clr=0;
        #100; pc_inc=1;
        #500; load_pc=1;
        #100; load_pc=0;
        #400; pc_oen=0;
        #100; pc_oen=1;
        #100; clr=1;
        #100; clr=0;
        #100;
    end
endmodule
