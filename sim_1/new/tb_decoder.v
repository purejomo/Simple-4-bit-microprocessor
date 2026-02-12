`timescale 1ns/1ps
module tb_decoder;

    reg [7:0] ir_in;

    wire nop, outb, outs, add_s, sub_s, 
         and_s, div_s, mul_s, shl, clr_s, 
         psah, shr, load, jz, jmp, jge, mov_ah_cr, mov_ah_dr, 
         mov_tmp_ah, mov_tmp_br, mov_tmp_cr, mov_tmp_dr, 
         mov_tmp_rr, mov_cr_ah, mov_cr_br, mov_dr_ah, mov_dr_tmp, 
         mov_dr_br, mov_rr_ah, mov_key_ah, mov_inr_tmp, mov_inr_rr;

    // Instantiate the decoder module
    decoder UUT(
        ir_in,
        nop, outb, outs, add_s, sub_s, and_s, div_s, 
        mul_s, shl, clr_s, psah, shr, load, jz, jmp, jge, 
        mov_ah_cr, mov_ah_dr, mov_tmp_ah, mov_tmp_br, 
        mov_tmp_cr, mov_tmp_dr, mov_tmp_rr, mov_cr_ah, 
        mov_cr_br, mov_dr_ah, mov_dr_tmp, mov_dr_br, 
        mov_rr_ah, mov_key_ah, mov_inr_tmp, mov_inr_rr
    );

    initial begin
        ir_in = 0;

        #100; ir_in = 8'h0B;
        #100; ir_in = 8'h07;
        #100; ir_in = 8'h50;
        #100; ir_in = 8'h52;
        #100; ir_in = 8'h54;
        #100; ir_in = 8'h55;
        #100; ir_in = 8'h51;
        #100; ir_in = 8'h15;
        #100; ir_in = 8'h10;
        #100; ir_in = 8'h14;
        #100; ir_in = 8'h16;
        #100; ir_in = 8'hD6;
        #100; ir_in = 8'hD0;
        #100; ir_in = 8'hD4;
        #100; ir_in = 8'hD2;
        #100; ir_in = 8'h83;
        #100; ir_in = 8'h84;
        #100; ir_in = 8'h88;
        #100; ir_in = 8'h8A;
        #100; ir_in = 8'h8B;
        #100; ir_in = 8'h8C;
        #100; ir_in = 8'h8D;
        #100; ir_in = 8'h98;
        #100; ir_in = 8'h9A;
        #100; ir_in = 8'hA0;
        #100; ir_in = 8'hA1;
        #100; ir_in = 8'hA2;
        #100; ir_in = 8'hA8;
        #100; ir_in = 8'hB0;
        #100; ir_in = 8'hB9;
        #100; ir_in = 8'hBD;
        #100;
    end
endmodule