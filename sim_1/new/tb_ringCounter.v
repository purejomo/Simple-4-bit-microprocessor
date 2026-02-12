`timescale 1ns/1ps
module tb_ringCounter;
    reg clk, clr;
    wire [11:0] t;

    // Instantiate the ringCounter module
    ringCounter UUT (
        .clk(clk),
        .clr(clr),
        .t(t)
    );

    // Generate clock signal
    always #50 clk = ~clk;

    // Initialize inputs
    initial begin
        clk = 0;
        clr = 0;
    end
    
endmodule