`timescale 1ns / 1ps

module tb_aluNaccDiv;
    // Inputs
    reg ah_reset, ah_inen;
    reg [3:0] bus_in;
    reg [1:0] hs;
    reg [1:0] ls;
    reg s_sub,s_and, s_div;
    reg [3:0] breg_in;
    reg s_add,clr, s_mul,clk,acc_oen;
    // Output
    wire sign_flag,zero_flag;
    wire [7:0] acc_out;
        
    // Instantiate the UUT
    aluNacc UUT (   .ah_reset(ah_reset), 
                    .ah_inen(ah_inen),.bus_in(bus_in), 
                    .hs(hs), .ls(ls), .s_sub(s_sub), 
                    .s_and(s_and), .s_div(s_div), 
                    .breg_in(breg_in),.s_add(s_add), 
                    .clr(clr), .s_mul(s_mul), .clk(clk), 
                    .sign_flag(sign_flag), 
                    .zero_flag(zero_flag), 
                    .acc_oen(acc_oen), 
                    .acc_out(acc_out)
            );
            
    always #50 clk = ~clk;
    
    initial begin
        ah_reset = 0;  ah_inen = 0;
        bus_in = 4'b0111; breg_in = 4'b0010;
        hs = 0; ls = 0;
        s_sub = 0; s_and = 0;
        s_div = 0;  s_add = 0;
        clk = 0; s_mul = 0;
        clr = 1; acc_oen = 1;
        #100; clr = 0;
        #100; ah_inen = 1; hs = 2'b11;
        #100; ah_inen = 0; hs = 2'b00;
        #100; ls = 2'b11;
        #100; ls = 2'b00;
        #100; ah_reset = 1;
        #100; ah_reset = 0;
        #100; hs = 2'b10; ls = 2'b10;                   //T3
        #100; hs = 2'b11; ls = 2'b00; s_div = 1;        //T4
        #100; hs = 2'b10; ls = 2'b10; s_div = 0;        //T5
        #100; hs = 2'b11; ls = 2'b00; s_div = 1;        //T6
        #100; hs = 2'b10; ls = 2'b10; s_div = 0;        //T7
        #100; hs = 2'b11; ls = 2'b00; s_div = 1;        //T8
        #100; hs = 2'b10; ls = 2'b10; s_div = 0;        //T9
        #100; hs = 2'b11; ls = 2'b00; s_div = 1;        //T10
        #100; hs = 2'b00; ls = 2'b10; s_div = 0;        //T11
        #100; hs = 2'b00; ls = 2'b00;
    end
    
endmodule