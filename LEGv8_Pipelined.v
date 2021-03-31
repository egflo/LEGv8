`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2020 08:24:32 AM
// Design Name: 
// Module Name: LEGv8_Pipelined
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


module LEGv8_Pipelined(clk, reset, PCSrc);

input clk,reset;

//-----IF--------
input PCSrc;
wire [63:0] ADD_result, PCIn, PCOut;
wire [31:0] InstructionOut;

//-----IF-ID--------
wire [63:0] IF_ID_PC_Out; //Register for PCOut
wire [31:0] IF_ID_Instruction_Out; //Register for Instruction Out


//-----ID--------
wire [4:0] rd_addr_2;
wire [63:0] rd_data_1, rd_data_2, sign_extended;
wire [10:0] opcode; 
wire [8:0] control_signals, displacement;


//-----ID-EX--------
wire [8:0] ID_EX_control_signals;
wire [63:0] ID_EX_PCOut, ID_EX_rd_data_1, ID_EX_rd_data_2, ID_EX_sign_extended;
wire [10:0] ID_EX_opcode; 
wire [4:0] ID_EX_instructionOut;


//----EX--------
wire [1:0] ALUOp;
wire ALUSrc, Zero;
wire [63:0] ALU_result, ADD_result_EX;


//-----EX-MEM-----
wire EX_MEM_RegWrite_Out, EX_MEM_MemtoReg_Out, EX_MEM_Branch_Out, EX_MEM_MemRead_Out, EX_MEM_MemWrite_Out, EX_MEM_Zero_Out;
wire [63:0] EX_MEM_ADD_result_Out, EX_MEM_ALU_result_Out, EX_MEM_rd_data_2_Out;
wire [4:0] EX_MEM_Instruction_Out;

//-----MEM---------
wire [63:0] rd_data;


//----MEM-WB.....
wire MEM_WB_RegWrite, MEM_WB_MemtoReg;
wire [63:0] MEM_WB_ReadData, MEM_WB_ALU_result; 
wire [4:0] MEM_WB_Instruction;


//--- WB--------
wire[63:0] WB_wr_data; 

//--------------------------------IF-----------------------------------------------------------//

IF IF(.clk(clk), .PCSrc(PCSrc), .ADD_result(ADD_result), .PCOut(PCOut), .InstructionOut(InstructionOut));

//--------------------------------IF-ID-----------------------------------------------------------//

IF_ID IF_ID(.clk(clk), .PC_In(PCOut), .Instruction_In(InstructionOut), .PC_Out(IF_ID_PC_Out), .Instruction_Out(IF_ID_Instruction_Out));

//--------------------------------ID-----------------------------------------------------------//

assign displacement = (control_signals[2] == 1) ? IF_ID_Instruction_Out[13:5] : IF_ID_Instruction_Out[20:12];

ID ID(.clk(clk), .Instruction(IF_ID_Instruction_Out), .wr_addr(MEM_WB_Instruction), .wr_data(WB_wr_data), .RegWrite(MEM_WB_RegWrite), .control_signals(control_signals), 
                       .displacement(displacement), .sign_extended(sign_extended), .rd_data_1(rd_data_1), .rd_data_2(rd_data_2));
             
//--------------------------------ID_EX-----------------------------------------------------------//
ID_EX ID_EX(.clk(clk), .control_signals_In(control_signals), .PC_In(IF_ID_PC_Out), .rd_data_1_In(rd_data_1), .rd_data_2_In(rd_data_2), .sign_extend_In(sign_extended), .opcode_In(IF_ID_Instruction_Out[31:21]), .Instruction_In(IF_ID_Instruction_Out[4:0]),
    .control_signals_Out(ID_EX_control_signals), .PC_Out(ID_EX_PCOut), .rd_data_1_Out(ID_EX_rd_data_1), .rd_data_2_Out(ID_EX_rd_data_2), .sign_extend_Out(ID_EX_sign_extended), .opcode_Out(ID_EX_opcode), .Instruction_Out(ID_EX_instructionOut));
          

//--------------------------------EX-----------------------------------------------------------//
assign ALUOp[1:0] = ID_EX_control_signals[1:0];
assign ALUSrc = ID_EX_control_signals[7];

EX EX(.ALUOp(ALUOp), .Opcode_field(ID_EX_opcode), .Zero(Zero), .ALU_result(ALU_result), 
        .ADD_result(ADD_result_EX), .ALUSrc(ALUSrc), .rd_data_1(ID_EX_rd_data_1), .rd_data_2(ID_EX_rd_data_2), .sign_extended(ID_EX_sign_extended));

//--------------------------------EX_MEM-----------------------------------------------------------//

EX_MEM EX_MEM (.clk(clk), .RegWrite_In(ID_EX_control_signals[5]), .MemtoReg_In(ID_EX_control_signals[6]), .Branch_In(ID_EX_control_signals[2]), .MemRead_In(ID_EX_control_signals[4]), .MemWrite_In(ID_EX_control_signals[3]), .Zero_In(Zero), 
        .ADD_result_In(ADD_result_EX), .ALU_result_In(ALU_result), .rd_data_2_In(ID_EX_rd_data_2), .Instruction_In(ID_EX_instructionOut), .RegWrite_Out(EX_MEM_RegWrite_Out),
        .MemtoReg_Out(EX_MEM_MemtoReg_Out), .Branch_Out(EX_MEM_Branch_Out), .MemRead_Out(EX_MEM_MemRead_Out), .MemWrite_Out(EX_MEM_MemWrite_Out), .Zero_Out(EX_MEM_Zero_Out),
        .ADD_result_Out(EX_MEM_ADD_result_Out), .ALU_result_Out(EX_MEM_ALU_result_Out), .rd_data_2_Out(EX_MEM_rd_data_2_Out), .Instruction_Out(EX_MEM_Instruction_Out));

//--------------------------------MEM-----------------------------------------------------------//

MEM MEM(.clk(clk), .MemWrite(EX_MEM_MemWrite_Out), .MemRead(EX_MEM_MemRead_Out), .Address(EX_MEM_ALU_result_Out), 
           .WriteData(EX_MEM_rd_data_2_Out), .ReadData(rd_data), .PCSrc(PCSrc), .Zero(EX_MEM_Zero_Out), .Branch(EX_MEM_Branch_Out)); 
           
//--------------------------------MEM-WB-----------------------------------------------------------//

MEM_WB MEM_WB (.clk(clk), .RegWrite_In(EX_MEM_RegWrite_Out), .MemtoReg_In(EX_MEM_MemtoReg_Out), .ReadData_In(rd_data), .ALU_result_In(EX_MEM_ALU_result_Out), .Instruction_In(EX_MEM_Instruction_Out),
.RegWrite_Out(MEM_WB_RegWrite), .MemtoReg_Out(MEM_WB_MemtoReg), .ReadData_Out(MEM_WB_ReadData), .ALU_result_Out(MEM_WB_ALU_result), .Instruction_Out(MEM_WB_Instruction));

//--------------------------------MEM-----------------------------------------------------------//

WB WB(.rd_data(MEM_WB_ReadData), .ALU_result(MEM_WB_ALU_result), .MemtoReg(MEM_WB_MemtoReg), .WriteData(WB_wr_data));

endmodule
