`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2020 09:08:30 AM
// Design Name: 
// Module Name: ID
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


module ID(clk, reset, Instruction, wr_addr, wr_data, RegWrite, control_signals, displacement, sign_extended, rd_data_1, rd_data_2, RegisterRn, RegisterRm, RegisterRd, IF_Flush);

input clk, reset, RegWrite;
input [31:0] Instruction;   
input [4:0] wr_addr;
input [63:0] wr_data;
input [8:0] displacement;

output [8:0] control_signals;
output [63:0] sign_extended, rd_data_1, rd_data_2;
output IF_Flush;
output [4:0] RegisterRn, RegisterRm, RegisterRd;

wire [4:0] rd_addr_2;

//---------------------- Sign Extended ----------------------

sign_extend signext(.in(displacement), .out(sign_extended));

//---------------------- (IM-RF MUX) ----------------------

mux_2to1 reg_loc (.sel(Instruction[28]), .in0(Instruction[20:16]), .in1(Instruction[4:0]), .out(rd_addr_2));

//-----------------Instruction Decoder --------------------------
    
instruction_decoder ID (.opcode(Instruction[31:21]), .control_signals(control_signals), .IF_Flush(IF_Flush));    

//----------------- Register File  --------------------------

regfile RF (.clk(clk), .reset(reset), .wr_en(RegWrite), .rd_addr_1(Instruction[9:5]),
             .rd_addr_2(Instruction[20:16]), .wr_addr(wr_addr), .wr_data(wr_data), .rd_data_1(rd_data_1), .rd_data_2(rd_data_2)); 

assign RegisterRm = Instruction[20:16]; //SOURCE 2
assign RegisterRn = Instruction[9:5]; //SORUCE 1
assign RegisterRd = Instruction[4:0]; //DESTINATION

endmodule
