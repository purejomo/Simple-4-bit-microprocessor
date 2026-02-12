`timescale 1ns/1ps
module tb_aluNaccMul;
  reg ah_reset, ah_inen;
  reg [3:0] bus_in;
  reg [1:0] hs;
  reg [1:0] ls;
  reg s_sub, s_and, s_div;
  reg s_add, s_mul, clr, clk, acc_oen;
  reg [3:0] breg_in;
  
  wire sign_flag, zero_flag;
  wire [7:0] acc_out;
  
  aluNacc UUT(
              .ah_reset(ah_reset),
              .ah_inen(ah_inen),
              .s_sub(s_sub),
              .s_and(s_and),
              .s_div(s_div),
              .s_add(s_add),
              .s_mul(s_mul),
              .clr(clr),
              .acc_oen(acc_oen),
              .clk(clk),
              .breg_in(breg_in),
              .bus_in(bus_in),
              .hs(hs),
              .ls(ls),
              .sign_flag(sign_flag),
              .zero_flag(zero_flag),
              .acc_out(acc_out)
              );
              
  always #50 clk=~clk;
  initial begin
    ah_reset=0; ah_inen=0;
    bus_in=4'b1001; breg_in=4'b1001;
    hs=0; ls=0;
    s_sub=0; s_and=0;
    s_div=0; s_add=0;
    clk=0; s_mul=0;
    clr=1; acc_oen=1;
    #100; clr=0;
    #100; ah_inen=1; hs=2'b11;
    #100; ah_inen=0; hs=2'b00;
    #100; ls=2'b11;
    #100; ls=2'b00;
    #100; ah_reset=1;
    #100; ah_reset=0;
    
    #100; hs=2'b11; s_mul=1;
    #100; hs=2'b01; ls=2'b01; s_mul=0;
    #100; hs=2'b11; ls=2'b00; s_mul=1;
    #100; hs=2'b01; ls=2'b01; s_mul=0;
    #100; hs=2'b11; ls=2'b00; s_mul=1;
    #100; hs=2'b01; ls=2'b01; s_mul=0;
    #100; hs=2'b11; ls=2'b00; s_mul=1;
    #100; hs=2'b01; ls=2'b01; s_mul=0;
    #100; hs=2'b00; ls=2'b00;
    #100;
  end
endmodule