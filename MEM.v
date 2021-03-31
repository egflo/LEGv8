`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2020 09:33:03 AM
// Design Name: 
// Module Name: MEM
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


module MEM(clk, MemWrite, MemRead, Address, WriteData, ReadData, PCSrc, Zero, Branch);

input clk;

input MemWrite, MemRead, Zero, Branch;
input [7:0] Address;  
input [63:0] WriteData;

output [63:0] ReadData;
output PCSrc;


//---------------------- BRANCH ----------------------
assign PCSRC = Zero & Branch;

        
//---------------------- DATA MEMORY ----------------------
    
DataMem datamem(.clk(clk), .mem_wr(MemWrite), .mem_rd(MemRead), .addr(Address), .wr_data(WriteData), .rd_data(ReadData)); 
    
        
endmodule
