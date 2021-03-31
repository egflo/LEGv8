`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2020 05:00:35 PM
// Design Name: 
// Module Name: mux_3to1
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


module mux_3to1(sel, in0, in1, in2, out);

input[1:0] sel;
input   [63:0] in0;
input  [63:0] in1;
input  [63:0] in2;
output reg [63:0]  out;


always@(sel, in0, in1, in2)
 case(sel)
  0: out <= in0;
  1: out <= in1;
  2: out <= in2;
  default: out <= in0;
  endcase
endmodule
