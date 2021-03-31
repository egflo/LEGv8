`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2020 03:43:15 PM
// Design Name: 
// Module Name: program_counter
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


module program_counter(clk, PCIn, PCOut, PCWrite);
  
input clk, PCWrite;
input [63:0] PCIn;
output reg [63:0] PCOut;
reg [63:0] Cycle;

// PC will be zero and so the 0th instruction
initial PCOut = 0; 

always@(posedge clk) //Execute Block on the rising edge 0->1
begin    
    if (PCWrite == 1)  //Write Only When on the Posedge + PCWrite Enabled (For Hazards)
        PCOut <= PCIn;
        
end   

always@(*) Cycle <= (PCOut/4) + 1;

endmodule
