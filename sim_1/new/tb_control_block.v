`timescale 1ns / 1ps

module tb_control_block;
    reg [7:0] opcode;
    reg z_f, s_f, clk, clr;
    wire pc_oen, mar_inen, rom_en, mdr_inen;
    wire pc_inc, mdr_oen, ir_inen, tmp_inen;
    wire tmp_oen, creg_inen, creg_oen, dreg_inen;
    wire dreg_oen, rreg_inen, rreg_oen;
    wire breg_inen, inreg_oen, keych_oen;
    wire outreg_inen, keyout_inen, load_pc, acc_oen;
    wire ah_inen, ah_reset, adds, subs, ands, divs, muls;
    wire [1:0] hs, ls;

    // Instantiate the control_block module
    control_block UUT (
        .z_f(z_f), .s_f(s_f), .clk(clk), .clr(clr), .opcode(opcode),
        .pc_oen(pc_oen), .mar_inen(mar_inen), .rom_en(rom_en),
        .mdr_inen(mdr_inen), .pc_inc(pc_inc), .mdr_oen(mdr_oen),
        .ir_inen(ir_inen), .tmp_inen(tmp_inen), .tmp_oen(tmp_oen),
        .creg_inen(creg_inen), .creg_oen(creg_oen), .dreg_inen(dreg_inen),
        .dreg_oen(dreg_oen), .rreg_inen(rreg_inen), .rreg_oen(rreg_oen),
        .breg_inen(breg_inen), .inreg_oen(inreg_oen), .keych_oen(keych_oen),
        .outreg_inen(outreg_inen), .keyout_inen(keyout_inen),
        .load_pc(load_pc), .acc_oen(acc_oen), .ah_inen(ah_inen),
        .ah_reset(ah_reset), .adds(adds), .subs(subs),
        .ands(ands), .divs(divs), .muls(muls), .hs(hs), .ls(ls)
    );

    // Clock generation
    always #50 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize inputs
        s_f = 0; 
        z_f = 0;
        clk = 0; 
        clr = 1; 
        opcode = 0;

        #100; clr = 0; opcode = 8'h00;
        #1200; opcode = 8'h0B;
        #1200; opcode = 8'h07;
        #1200; opcode = 8'h50;
        #1200; opcode = 8'h52;
        #1200; opcode = 8'h54;
        #1200; opcode = 8'h15;
        #1200; opcode = 8'h10;
        #1200; opcode = 8'h14;
        #1200; opcode = 8'h16;
        #1200; opcode = 8'hD6;
        #1200; opcode = 8'hD0;
        #1200; opcode = 8'hD4;
        #1200; opcode = 8'hD2;
        #1200; opcode = 8'h83;
        #1200; opcode = 8'h84;
        #1200; opcode = 8'h88;
        #1200; opcode = 8'h8A;
        #1200; opcode = 8'h8B;
        #1200; opcode = 8'h98;
        #1200; opcode = 8'h9A;
        #1200; opcode = 8'hA0;
        #1200; opcode = 8'hA2;
        #1200; opcode = 8'hA1;
        #1200; opcode = 8'hA8;
        #1200; opcode = 8'hB0;
        #1200; opcode = 8'hB9;
        #1200; opcode = 8'hBD;
        #100;
    end
endmodule
