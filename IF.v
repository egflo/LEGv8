`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2020 08:34:05 AM
// Design Name: 
// Module Name: IF
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


module IF(clk, PCSrc, ADD_result, PCOut, InstructionOut, PCWrite);

input clk;
input PCSrc, PCWrite;
input [63:0] ADD_result;

output [31:0] InstructionOut; //Connect to IF/IF Register
output [63:0] PCOut; //Connect to IM & IF/ID Register

wire [63:0] adder_out; //Connect to PCIn
wire [63:0] PCIn; //Conect Mux to PC

 
//------------------PC MUX -------------------------------
mux_2to1 PC_mux(.sel(PCSrc), .in0(adder_out), .in1(ADD_result), .out(PCIn));
    
//-----------------Program Counter ---------------------------
adder Adder (.in0(PCOut), .in1(4), .out(adder_out));
program_counter PC (.clk(clk), .PCIn(PCIn), .PCOut(PCOut), .PCWrite(PCWrite));
    
//-----------------Instruction Memory --------------------------
instruction_memory IM (.PCOut(PCOut), .InstructionOut(InstructionOut));    


endmodule
