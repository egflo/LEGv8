`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CECS 530 - FALL 2020
// Engineer: Emmanuel Flores
// 
// Create Date: 09/29/2020 09:43:02 PM
// Design Name: 
// Module Name: mux_2to1
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


module mux_2to1(sel, in0, in1, out);

input sel;
input   [63:0] in0;
input  [63:0] in1;
output reg [63:0]  out;


always@(sel, in0, in1)
 case(sel)
  0: out <= in0;
  1: out <= in1;
  default: out <= in0;
  endcase
endmodule
