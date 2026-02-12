`timescale 1ns/1ps
module tb_shreg;
//Inputs
  reg carry_msb;
  reg [1:0] c;
  reg [3:0] data_in;
  reg clr;
  reg clk;
  reg carry_lsb;
//Output
  wire [3:0] data_out;
  
  shreg UUT(
            .carry_msb(carry_msb),
            .carry_lsb(carry_lsb),
            .c(c),
            .clr(clr),
            .clk(clk),
            .data_in(data_in),
            .data_out(data_out)
            );
  always #50 clk=~clk;
  initial begin
    carry_msb=0;
    c=2'b00;
    data_in=4'b1100;
    clr=1;
    clk=0;
    carry_lsb=0;
    #100; clr=0;
    #100; c=2'b11;
    #100; c=2'b00;
    #100; c=2'b01;
    #200; c=2'b00;
    #100; c=2'b01;
    #200; c=2'b00;
    #100; c=2'b01;
    #200; c=2'b00;
    #100; c=2'b01;
    #200; c=2'b00;
    #100; c=2'b10;
    #200; c=2'b00;
    #100; c=2'b10;
    #200; c=2'b00;
    #100; c=2'b10;
    #200; c=2'b00;
    #100; c=2'b10;
    #200; c=2'b00;
    #100; c=2'b10;
    #200; c=2'b00;
    #100; end
endmodule