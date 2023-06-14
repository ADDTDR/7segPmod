`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2023 03:21:37 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input GCLK,
    output JA1,
    output JA2,
    output JA3
   
    );
    
reg [27:0] clock = 0; 
reg cc; 

reg [3:0] tx_d = 4'h0;
reg [3:0] i = 3'b0;


led_mon LDM (
    .clck(GCLK),
    .tx_d(tx_d),
    .latchPin(JA2),
    .dataPin(JA3),
    .clockPin(JA1)
    ); 
    
    
  always@(posedge GCLK)begin 
      clock <= clock + 1;
      cc <= clock[25];
   end 
 
 
     always@(negedge cc)
        begin
          tx_d <= i;
          if (i == 9)
            i <= 0;
          else   
            i <= i + 1;
         end  
endmodule
