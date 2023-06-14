# Number stick

## Simple 74hc595 sfifted 1 position 7 segment display 


simple display module based on 74hc595 shift register pmod compatible 

Binary  sequences corespondig to numbers    LSBFIRTS  configuration 

|     Binary      | Decimal number|
|-----------------|---------------|
|     0b00000011  | 1             |
|     0b11110110  | 2             |
|     0b11010111  | 3             | 
|     0b00001111  | 4             |
|     0b11011101  | 5             | 
|     0b11111101  | 6             |
|     0b00010011  | 7             |
|     0b11111111  | 8             |
|     0b11011111  | 9             |
|     0b11111011  | 0             |

## Wiring 
|Number stick pin|74HC Function|Pmod header pin|Arduino UNO|
|----------------|-------------|---------------|-----------|
| 1              |   VCC       |    VCC        | 3.3 V     |
| 2              |   GND       |    GND        |  GND      |
| 3              |   Clock     |    JA1        |   6       |
| 5              |   Latch     |    JA2        |   5       |
| 6              |   Data      |    JA3        |   4       |





# Top  module code  draft  
```verilog
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


```

# Stick umber module
```verilog 
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2023 02:33:43 PM
// Design Name: 
// Module Name: led_mon
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


module led_mon(
    input clck,
    input [3:0] tx_d,
    output  latchPin,
    output  dataPin,
    output  clockPin   
    );


reg [1:0] state = 'd1;
reg [7:0] tx_buf;
reg [30:0] counter;
reg clock_reg_div_800;
reg dout_reg;
reg latch_reg;
reg [3:0] bit_index = 4'h0;

localparam DONE= 'd0, 
           IDLE= 'd1,
           SEND= 'd2;

 
assign clockPin = (state == SEND) ? clock_reg_div_800 : 1'b0;
assign dataPin =  (state == SEND) ? dout_reg  : 1'b0;
assign latchPin =  latch_reg;

initial
    clock_reg_div_800 <= 0;    
       

always@(posedge (clck)) 
        begin
            if(counter == 399 )
                clock_reg_div_800 <= ~clock_reg_div_800;
            if(counter != 399 ) 
                counter <= counter + 1;
            else 
                counter <= 0;     
        end 


//Generate latch signal for 74hc595,  move data to output reg inside 74hc595  
always@(negedge (clock_reg_div_800))
           if (bit_index < 8)
              latch_reg <= 0;
           else 
              latch_reg <= 1;
               
                
// Calculate running bit index            
always@(negedge (clock_reg_div_800))
           begin 
               if (bit_index != 8) 
                   bit_index <= bit_index + 1; 
               else 
                   bit_index <= 0;                   
           end 
           
always@(negedge clock_reg_div_800)begin
        case(state)
          IDLE:begin
                
                // map input number to binary mask 
                if (tx_d == 0)
                 tx_buf <= 8'b11111011;
                if (tx_d == 1)
                 tx_buf <= 8'b00000011;
                if (tx_d == 2) 
                 tx_buf <= 8'b11110110;            
                if (tx_d == 3 )
                 tx_buf <= 8'b11010111;
                if (tx_d == 4 )
                 tx_buf <= 8'b00001111;
                if (tx_d == 5 )
                 tx_buf <= 8'b11011101;
                if (tx_d == 6 )
                 tx_buf <= 8'b11111101;
                if (tx_d == 7 )
                 tx_buf <= 8'b00010011;
                if (tx_d == 8)
                 tx_buf <= 8'b11111111;
                if (tx_d == 9)
                 tx_buf <= 8'b11011111;
               
                if(bit_index == 8)
                    state <= SEND;
          end 
          
          SEND:begin  
            dout_reg <= (tx_buf & (1 <<  bit_index) ) >> bit_index;
            if (bit_index == 8)
                state <= DONE;            
          end
          
          DONE:begin
            state <= IDLE;
          end 
          
        endcase
    end 
    
endmodule

```

# Simulation  
![Alt text](/number_list.PNG?raw=true "Simulation diagram")

# Hardware prototype
![Alt text](IMG_3520.jpg?raw=true 'Pmod_front plane')
![Alt text](IMG_3521.jpg?raw=true 'Pmod_back plane')
![Video](IMG_3397.MOV 'Pmod_front plane')