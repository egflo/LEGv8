`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2020 05:42:24 PM
// Design Name: 
// Module Name: PCIMIDRFALUDM
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


module LEGv8(clk, reset);

input clk,reset;
wire Zero;

//PCIMID
wire [31:0] InstructionOut; //Contains Instructions from PCIMID
wire [8:0] control_signals; //Subset of InstructionOut[31:21]

//Control_Sginals 
wire Reg2Loc;
wire ALUSrc;
wire MemtoReg;
wire RegWrite;
wire MemRead;
wire MemWrite;
wire Branch;
wire [1:0] ALUOp;
 

assign Reg2Loc = control_signals[8];
assign ALUSrc = control_signals[7];
assign MemtoReg = control_signals[6];
assign RegWrite = control_signals[5];
assign MemRead = control_signals[4];
assign MemWrite = control_signals[3];
assign Branch = control_signals[2]; 
assign ALUOp[1:0] = control_signals[1:0];

//Register File
wire [4:0] rd_addr_2;

//Sign Extend
wire [63:0] sign_extended; //Connect to Adder Branch

//---------------------- (IM-RF MUX) ----------------------

mux_2to1 reg_loc (.sel(control_signals[8]), .in0(InstructionOut[20:16]), .in1(InstructionOut[4:0]), .out(rd_addr_2));

// ---------------MAIN MODULES---------------------

PCIMID ctrl(.clk(clk), .control_signals(control_signals), .InstructionOut(InstructionOut), .Zero(Zero), .signext(sign_extended));


wire [8:0] displacement; 
assign displacement = (Branch == 1) ? InstructionOut[13:5] : InstructionOut[20:12];

RFALUDM main (.ALUOp(ALUOp), .Opcode_field(InstructionOut[31:21]), .Zero(Zero), 
    .clk(clk), .reset(reset), .RegWrite(RegWrite), .rd_addr_1(InstructionOut[9:5]), .rd_addr_2(rd_addr_2), .wr_addr(InstructionOut[4:0]), .ALUSrc(ALUSrc), .displacement(displacement),
    .MemWrite(MemWrite), .MemRead(MemRead), .MemtoReg(MemtoReg), .sign_extended(sign_extended));
endmodule
