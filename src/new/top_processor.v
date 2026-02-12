module top_processor(clk, clr, key_row, key_col, seg, dig );
    input clk, clr;
    input  [3:0] key_row;
  
    output [3:0] key_col;
    output [7:0] seg;
    output [7:0] dig;
   
    wire [3:0] hout,lout,kout;
    wire [3:0]data;
    wire valid;
    wire [31:0] data_key;
    
    wire  rclr;
    
    assign rclr = ~clr;
    
    assign data_key = {8'h00,hout,lout,12'h000,kout};
    
    processor pro ( 	.clk(clk), 
            .clr(clr), 
            .hout(hout), 
            .lout(lout), 
            .kout(kout), 
            .data(data), 
            .valid(valid)
       );
    ks ks(.i_clk(clk),.i_rst_n(clr), .row(key_row), .col(key_col),.keyboard_val(data),.valid(valid)  );
    
    seg7x8 seg7x8(.clk_50m(clk),
       .reset_n(~clr),
       .i_turn_off(8'b11001110),
       .i_dp	(8'b00010000),   
       .i_data(data_key),.seg(seg),.dig(dig)      
     );
endmodule
