`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2020 09:15:51 AM
// Design Name: 
// Module Name: EX
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


module EX(ALUOp, Opcode_field, Zero, ALU_result, ADD_result, ALUSrc, rd_data_1, rd_data_2, sign_extended , PCOut);
    

input  [1:0] ALUOp;
input  [10:0] Opcode_field;    
input [63:0] rd_data_1;
input [63:0] rd_data_2;
input [63:0] sign_extended;
input [63:0] PCOut;
input ALUSrc;

output Zero;
output [63:0] ALU_result;    
output [63:0] ADD_result; 

wire [63:0] alu_src_out;

//---------------------- MUX ----------------------
mux_2to1 alu_src (.sel(ALUSrc), .in0(rd_data_2), .in1(sign_extended), .out(alu_src_out));
   
//------------------Branche Control -------------------------------
adder Adder_Branch (.in0(PCOut), .in1(sign_extended<<2), .out(ADD_result));

//------------------------------ALU----------------------------------
LEGv8ALUwithControl ALUwithCtrl(.ALUOp(ALUOp), .Opcode_field(Opcode_field), .A(rd_data_1), .B(alu_src_out),  .ALU_result(ALU_result), .Zero(Zero));    
 
endmodule


