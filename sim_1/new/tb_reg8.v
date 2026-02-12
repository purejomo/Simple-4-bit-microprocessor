`timescale 1ns / 1ps

module tb_reg8;
//Input
    reg clr;
    reg clk;
    reg inen;
    reg oen;
    reg [7:0] data_in;
    
//Output
    wire [7:0] data_out;
    
    reg8 UUT(
            .data_out(data_out),
            .data_in(data_in),
            .inen(inen),
            .oen(oen),
            .clk(clk),
            .clr(clr)
    );
    
    always #50 clk=~clk;
    initial begin
        clr=1;
        inen=0;
        oen=0;
        clk=0;
        data_in=8'h48;
        #100; clr=0;
        #200; inen=1;
        #100; oen=1;
        #100; oen=0;
        #100; inen=0; oen=1;

        #100; clr=1;
        #100; clr=0;
        #100;
    end
endmodule