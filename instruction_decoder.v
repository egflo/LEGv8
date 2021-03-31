`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2020 03:52:19 PM
// Design Name: 
// Module Name: instruction_decoder
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

module instruction_decoder(opcode, control_signals, IF_Flush);

input [10:0] opcode;
output [8:0] control_signals;
output reg IF_Flush;

reg Reg2Loc;
reg ALUSrc;
reg MemtoReg;
reg RegWrite;
reg MemRead;
reg MemWrite;
reg Branch;
reg [1:0] ALUOp;

initial IF_Flush = 0;

always@(opcode) begin
casex (opcode)
        11'b00_000_000_000: begin  Reg2Loc <= 0; ALUSrc <= 0; MemtoReg <= 0;  RegWrite <= 1; MemRead <= 0; MemWrite <= 0;  Branch <=0; ALUOp <= 01; end //PASSB 0111
        11'b10_001_010_000: begin  Reg2Loc <= 0; ALUSrc <= 0; MemtoReg <= 0;  RegWrite <= 1; MemRead <= 0; MemWrite <= 0;  Branch <=0; ALUOp <= 10; end //AND 0000
        11'b10_001_011_000: begin  Reg2Loc <= 0; ALUSrc <= 0; MemtoReg <= 0;  RegWrite <= 1; MemRead <= 0; MemWrite <= 0;  Branch <=0; ALUOp <= 10; end //ADD 0010
        11'b10_101_010_000: begin  Reg2Loc <= 0; ALUSrc <= 0; MemtoReg <= 0;  RegWrite <= 1; MemRead <= 0; MemWrite <= 0;  Branch <=0; ALUOp <= 10; end //ORR 0001
        11'b11_001_011_000: begin  Reg2Loc <= 0; ALUSrc <= 0; MemtoReg <= 0;  RegWrite <= 1; MemRead <= 0; MemWrite <= 0;  Branch <=0; ALUOp <= 10; end //SUB 0110
        11'b11_111_000_010: begin  Reg2Loc <= 0; ALUSrc <= 1; MemtoReg <= 1;  RegWrite <= 1; MemRead <= 1; MemWrite <= 0;  Branch <=0; ALUOp <= 00; end //LOAD 
        11'b11_111_000_000: begin  Reg2Loc <= 1; ALUSrc <= 1; MemtoReg <= 0;  RegWrite <= 0; MemRead <= 0; MemWrite <= 1;  Branch <=0; ALUOp <= 00; end //STORE
        11'b10_110_100_xxx: begin  Reg2Loc <= 1; ALUSrc <= 0; MemtoReg <= 0;  RegWrite <= 0; MemRead <= 0; MemWrite <= 0;  Branch <=1; ALUOp <= 01; IF_Flush <= 0; end //CBZ 
        default: begin Reg2Loc <= 0; ALUSrc <= 0; MemtoReg <= 0;  RegWrite <= 1; MemRead <= 0; MemWrite <= 0;  Branch <=0; ALUOp <= 00; end //NOR
endcase
end
  
assign control_signals = {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch , ALUOp};   

endmodule

