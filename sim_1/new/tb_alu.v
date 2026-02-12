`timescale 1ns/1ps

module tb_alu;
  reg alu_sub, alu_div, alu_and, clk, clr, alu_add, alu_mul, al_lsb;
  reg [3:0] AH_in;
  reg [3:0] BREG_in;
  
  wire [3:0] ALU_out;
  wire Fa_cout, sign_flag, carry_flag, zero_flag;
  
  alu UUT (alu_sub, alu_div, AH_in, BREG_in, alu_and, ALU_out, Fa_cout, clk, clr, alu_add, alu_mul, al_lsb, sign_flag, carry_flag, zero_flag);
  
  always #50 clk=~clk;
  initial begin
    AH_in=4'b0101;
    BREG_in=4'b0010;
    alu_sub=0;
    alu_div=0;
    alu_and=0;
    alu_mul=0;
    alu_add=0;
    al_lsb=0;
    clk=0;
    clr=1;
  #100; clr=0;
  #100; alu_add=1;
  #100; alu_add=0; alu_sub=1;
  #100; alu_sub=0; alu_and=1;
  #100; alu_and=0;

//   #100; clr=0;
//   #100; AH_in=4'b1101;
//   BREG_in=4'b0111; alu_add=1;
//   #100; alu_add=0; AH_in=4'b0101;
//   BREG_in=4'b1010; alu_sub=1;
//   #100;BREG_in=4'b0101;
//   #100; alu_sub=0;
  end
endmodule