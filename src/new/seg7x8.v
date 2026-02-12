module seg7x8(
  	input         clk_50m,
	input         reset_n,
  
	input  [7:0]  i_turn_off,             // 
  	input  [7:0]  i_dp,                   // 
  	input  [31:0] i_data,                 // 
  
  	output [7:0]  seg,                  // 
  	output [7:0]  dig                   // 
    );

	reg [16:0] cnt;                         // 

	always @ (posedge clk_50m, negedge reset_n)
 		if (!reset_n)     cnt <= 0;
  		else     cnt <= cnt + 1'b1;

//++++++++++++++++++++++++++++++++++++++
// seg7_addr 
//++++++++++++++++++++++++++++++++++++++
	wire seg7_clk = cnt[16];  // (2^17/50M = 2.6114)ms 
	reg [2:0]  seg7_addr;                   // seg7

	always @ (posedge seg7_clk, negedge reset_n)
  	     if (!reset_n)     seg7_addr <= 0;
 	     else    seg7_addr <= seg7_addr + 1'b1; 

//++++++++++++++++++++++++++++++++++++++
// seg7_addr
//++++++++++++++++++++++++++++++++++++++
	reg [7:0] o_dig_r;                      // 
// SEG7
	always 
    	  case (seg7_addr)
    	    0 : o_dig_r = 8'b0000_0001;
    	    1 : o_dig_r = 8'b0000_0010;
            2 : o_dig_r = 8'b0000_0100;
            3 : o_dig_r = 8'b0000_1000;
            4 : o_dig_r = 8'b0001_0000;
            5 : o_dig_r = 8'b0010_0000;
            6 : o_dig_r = 8'b0100_0000;
            7 : o_dig_r = 8'b1000_0000;
         endcase
	reg turn_off_r;       // ?  segment   —©                        
	always
  	    case (seg7_addr)
                0 : turn_off_r = i_turn_off[0];
                1 : turn_off_r = i_turn_off[1];
                2 : turn_off_r = i_turn_off[2];
                3 : turn_off_r = i_turn_off[3];
                4 : turn_off_r = i_turn_off[4];
                5 : turn_off_r = i_turn_off[5];
                6 : turn_off_r = i_turn_off[6];
                7 : turn_off_r = i_turn_off[7];
            endcase
//++++++++++++++++++++++++++++++++++++++
	reg dp_r;   // ?  setment     (dot)                                   
	always
            case (seg7_addr)           
                 0 : dp_r = i_dp[0];
                 1 : dp_r = i_dp[1];
                 2 : dp_r = i_dp[2];
                 3 : dp_r = i_dp[3];
                 4 : dp_r = i_dp[4];
                 5 : dp_r = i_dp[5];
                 6 : dp_r = i_dp[6];
                 7 : dp_r = i_dp[7];
            endcase
	reg [3:0] seg_data_r; // ?  seg               
	always
  	    case (seg7_addr)
	        0 : seg_data_r = i_data[3:0];
	        1 : seg_data_r = i_data[7:4];
	        2 : seg_data_r = i_data[11:8];
	        3 : seg_data_r = i_data[15:12];
	        4 : seg_data_r = i_data[19:16];
	        5 : seg_data_r = i_data[23:20];
	        6 : seg_data_r = i_data[27:24];
	        7 : seg_data_r = i_data[31:28];
	      endcase
//--------------------------------------
reg [7:0] o_seg_r;                  
/*
          0
       -------
      |      |   
5     |  6   |     1   
      -------
      |      |   
4     |      |     2  
      ------- .    7
         3         
 */
 
	always @ (posedge clk_50m, negedge reset_n)
  	    if (!reset_n)   o_seg_r <= 8'hFF;                 
	    else if (turn_off_r)  o_seg_r <= 8'hFF; //  ©ö 
   	    else if (!dp_r)   // ?  seg   DP?          
               case (seg_data_r)              
          	4'h0 : o_seg_r <= 8'hC0;
	           4'h1 : o_seg_r <= 8'hF9;
   	           4'h2 : o_seg_r <= 8'hA4;
	           4'h3 : o_seg_r <= 8'hB0;
	           4'h4 : o_seg_r <= 8'h99;
	           4'h5 : o_seg_r <= 8'h92;
	           4'h6 : o_seg_r <= 8'h82;
	           4'h7 : o_seg_r <= 8'hF8;
	           4'h8 : o_seg_r <= 8'h80;
	           4'h9 : o_seg_r <= 8'h90;
	           4'hA : o_seg_r <= 8'h88;
	           4'hB : o_seg_r <= 8'h83;
	           4'hC : o_seg_r <= 8'hC6;
	           4'hD : o_seg_r <= 8'hA1;
	           4'hE : o_seg_r <= 8'h86;
	           4'hF : o_seg_r <= 8'h8E;
                endcase
                
 	else case (seg_data_r)  // ?  seg      ?             
          4'h0 : o_seg_r <= 8'hC0 ^ 8'h80;
          4'h1 : o_seg_r <= 8'hF9 ^ 8'h80;
          4'h2 : o_seg_r <= 8'hA4 ^ 8'h80;
          4'h3 : o_seg_r <= 8'hB0 ^ 8'h80;
          4'h4 : o_seg_r <= 8'h99 ^ 8'h80;
          4'h5 : o_seg_r <= 8'h92 ^ 8'h80;
          4'h6 : o_seg_r <= 8'h82 ^ 8'h80;
          4'h7 : o_seg_r <= 8'hF8 ^ 8'h80;
          4'h8 : o_seg_r <= 8'h80 ^ 8'h80;
          4'h9 : o_seg_r <= 8'h90 ^ 8'h80;
          4'hA : o_seg_r <= 8'h88 ^ 8'h80;
          4'hB : o_seg_r <= 8'h83 ^ 8'h80;
          4'hC : o_seg_r <= 8'hC6 ^ 8'h80;
          4'hD : o_seg_r <= 8'hA1 ^ 8'h80;
          4'hE : o_seg_r <= 8'h86 ^ 8'h80;
          4'hF : o_seg_r <= 8'h8E ^ 8'h80;
        endcase

        assign dig = o_dig_r; 
        assign seg = ~o_seg_r;//     cathode ??             
endmodule
               
