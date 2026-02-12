`timescale 1ns / 1ps

module reg4(data_out, data_in, inen, oen, clk, clr);
    output [3:0] data_out;
    input [3:0] data_in;
    input inen, oen, clk, clr;
    reg [3:0] st;
    
    always @(posedge clk, posedge clr) begin
        if(clr) begin 
            st=4'b0;
        end
        else if(inen) st=data_in;
        else st=st;
    end
    assign data_out=(oen)?st:4'bz;
endmodule
