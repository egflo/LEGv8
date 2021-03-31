`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2020 04:32:45 PM
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(clk, RegWrite_In, MemtoReg_In, ReadData_In, ALU_result_In, Instruction_In, RegisterRd_In,
RegWrite_Out, MemtoReg_Out, ReadData_Out, ALU_result_Out, Instruction_Out, RegisterRd_Out);

input clk;

input RegWrite_In, MemtoReg_In;
input [63:0] ReadData_In, ALU_result_In; 
input [4:0] Instruction_In, RegisterRd_In;

output reg RegWrite_Out, MemtoReg_Out;
output reg [63:0] ReadData_Out, ALU_result_Out; 
output reg [4:0] Instruction_Out, RegisterRd_Out;

always@(posedge clk) //Execute Block on the rising edge 0->1
begin
    RegWrite_Out <= RegWrite_In;
    MemtoReg_Out <= MemtoReg_In;
    ReadData_Out <= ReadData_In;
    ALU_result_Out <= ALU_result_In;
    Instruction_Out <= Instruction_In;
    RegisterRd_Out <= RegisterRd_In;
end  

endmodule
