`timescale 1ns/1ps
module tb_acc;
  reg ah_reset;
  reg clr;
  reg clk;
  reg [3:0] ah_in;
  reg [3:0] aludata;
  reg ah_inen, carry_out;
  reg [1:0] hs, ls;
  
  wire [3:0] ah_out;
  wire [3:0] al_out;
  
  acc UUT(
          .ah_reset(ah_reset),
          .clr(clr),
          .clk(clk),
          .ah_in(ah_in),
          .ah_inen(ah_inen),
          .aludata(aludata),
          .carry_out(carry_out),
          .hs(hs),
          .ls(ls),
          .ah_out(ah_out),
          .al_out(al_out)
          );
  always #50 clk = ~clk;
  initial  begin
    aludata = 4'b0010;
    ah_in = 4'b0101;
    ah_reset = 0;
    clk = 0;
    ah_inen = 0;
    carry_out = 0;
    hs = 2'b00;
    ls = 2'b00;
    clr = 1;
    #100; clr = 0;
    #100; hs = 2'b11;
    #100; hs = 2'b00;
    #100; ah_inen = 1; hs = 2'b11;
    #100; hs = 2'b00; ls = 2'b11;
    #100; ls=2'b00;
    #100; hs=2'b01; ls=2'b01;
    #100; hs=2'b00; ls=2'b00;
    #100; hs=2'b10; ls=2'b01;
    #100; hs=2'b00; ls=2'b00;
    #100; hs=2'b10; ls=2'b10;
    #100; hs=2'b00; ls=2'b00;
    #100; ah_reset=1;
    #100; ah_reset=0;
    #100;
  end
endmodule