`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2020 09:45:04 AM
// Design Name: 
// Module Name: WB
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


module WB(rd_data, ALU_result, MemtoReg, WriteData);

input [63:0] rd_data;
input [63:0] ALU_result;
input MemtoReg;

output [63:0] WriteData;
    
//---------------------- MUX ----------------------
mux_2to1 mem_reg (.sel(MemtoReg), .in0(ALU_result), .in1(rd_data), .out(WriteData));    


endmodule
