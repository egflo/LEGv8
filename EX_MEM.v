`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2020 03:10:11 PM
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(clk, RegWrite_In, MemtoReg_In, Branch_In, MemRead_In, MemWrite_In, Zero_In, ADD_result_In, ALU_result_In, rd_data_2_In, Instruction_In, RegisterRd_In,
RegWrite_Out, MemtoReg_Out, Branch_Out, MemRead_Out, MemWrite_Out, Zero_Out, ADD_result_Out, ALU_result_Out, rd_data_2_Out, Instruction_Out, RegisterRd_Out);

input clk;

input RegWrite_In, MemtoReg_In, Branch_In, MemRead_In, MemWrite_In, Zero_In;
input [63:0] ADD_result_In, ALU_result_In, rd_data_2_In;
input [4:0] Instruction_In, RegisterRd_In;

output reg RegWrite_Out, MemtoReg_Out, Branch_Out, MemRead_Out, MemWrite_Out, Zero_Out;
output reg [63:0] ADD_result_Out, ALU_result_Out, rd_data_2_Out;
output reg [4:0] Instruction_Out, RegisterRd_Out;
 
always@(posedge clk) //Execute Block on the rising edge 0->1
begin
    RegWrite_Out <= RegWrite_In;
    MemtoReg_Out <= MemtoReg_In;
    Branch_Out <= Branch_In;
    MemRead_Out <= MemRead_In;
    MemWrite_Out <= MemWrite_In;
    Zero_Out <= Zero_In;
    ADD_result_Out <= ADD_result_In;
    ALU_result_Out <= ALU_result_In;
    rd_data_2_Out <= rd_data_2_In;
    Instruction_Out <= Instruction_In;
    RegisterRd_Out <= RegisterRd_In;
end  

endmodule
