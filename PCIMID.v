`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2020 03:37:10 PM
// Design Name: 
// Module Name: PCIMID
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


module PCIMID(clk, control_signals, InstructionOut, Zero, signext);

input clk;
input Zero;
input [63:0] signext;

output [8:0] control_signals;
output [31:0] InstructionOut;

wire [63:0] adder_out; //Connect to PCIn
wire [63:0] PCIn; //Conect Mux to PC
wire [63:0] PCOut; //Connect to IM


wire [63:0] alu_result; //Connect to PCIn from Mux

//------------------Branche Control -------------------------------

adder Adder_Branch (.in0(PCOut), .in1(signext<<2), .out(alu_result));
mux_2to1 MuxtoAdder(.sel(control_signals[2] & Zero), .in0(adder_out), .in1(alu_result), .out(PCIn));

//-----------------Program Counter ---------------------------
adder Adder (.in0(PCOut), .in1(4), .out(adder_out));
program_counter PC (.clk(clk), .PCIn(PCIn), .PCOut(PCOut));

//-----------------Instruction Memory --------------------------

instruction_memory IM (.PCOut(PCOut), .InstructionOut(InstructionOut));

//-----------------Instruction Decoder --------------------------
wire [10:0] opcode; 
assign opcode = (InstructionOut[31:24] == 8'b1011_0100) ? {3'b0,InstructionOut[31:24]} : InstructionOut[31:21];

instruction_decoder ID (.opcode(opcode), .control_signals(control_signals));

endmodule


