`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2020 08:46:28 AM
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(clk, PC_In, Instruction_In, PC_Out, Instruction_Out, IF_ID_Write, IF_Flush);

input clk, IF_ID_Write, IF_Flush;
input [63:0] PC_In;
input [31:0] Instruction_In;

output reg [63:0] PC_Out;
output reg [31:0] Instruction_Out;

always@(posedge clk) //Execute Block on the rising edge 0->1
begin
    if (IF_ID_Write == 1) begin
        PC_Out <= PC_In;
        Instruction_Out <= Instruction_In;
    end  
    
    if (IF_Flush == 1) begin
        PC_Out <= 0; //Flush PC
        Instruction_Out <= 0; //Flush Instruction
    end
end
endmodule
