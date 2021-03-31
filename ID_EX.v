`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2020 01:26:57 PM
// Design Name: 
// Module Name: ID_EX
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


module ID_EX(clk, control_signals_In, PC_In, rd_data_1_In, rd_data_2_In, sign_extend_In, opcode_In, Instruction_In, RegisterRn_In, RegisterRm_In, RegisterRd_In,
    control_signals_Out, PC_Out, rd_data_1_Out, rd_data_2_Out, sign_extend_Out, opcode_Out, Instruction_Out, RegisterRn_Out, RegisterRm_Out, RegisterRd_Out);
 
input clk;
 
input [8:0] control_signals_In;
input [63:0] PC_In, rd_data_1_In, rd_data_2_In, sign_extend_In;
input [10:0] opcode_In;
input [4:0] Instruction_In, RegisterRn_In, RegisterRm_In, RegisterRd_In;

output reg[8:0] control_signals_Out;
output reg [63:0] PC_Out, rd_data_1_Out, rd_data_2_Out, sign_extend_Out;
output reg [10:0] opcode_Out;
output reg [4:0] Instruction_Out, RegisterRn_Out, RegisterRm_Out, RegisterRd_Out;
    
always@(posedge clk) //Execute Block on the rising edge 0->1
begin
    control_signals_Out <= control_signals_In;
    PC_Out <= PC_In;
    rd_data_1_Out <= rd_data_1_In;
    rd_data_2_Out <= rd_data_2_In;
    sign_extend_Out <= sign_extend_In;
    opcode_Out <= opcode_In;
    Instruction_Out <= Instruction_In;
    RegisterRn_Out <= RegisterRn_In;
    RegisterRm_Out <= RegisterRm_In;
    RegisterRd_Out <= RegisterRd_In;
end  

endmodule
