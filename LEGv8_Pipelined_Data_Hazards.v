`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2020 04:58:40 PM
// Design Name: 
// Module Name: LEGv8_Pipelined_Data_Hazards
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


module LEGv8_Pipelined_Data_Hazards(clk, reset, PCSrc);

input clk,reset;

wire ControlMux, IF_ID_Write, PCWrite, IF_Flush;

//-----IF--------
input PCSrc;
wire [63:0] ADD_result, PCIn, PCOut;
wire [31:0] InstructionOut;

//-----IF-ID--------
wire [63:0] IF_ID_PC_Out; //Register for PCOut
wire [31:0] IF_ID_Instruction_Out; //Register for Instruction Out
wire [4:0] IF_ID_RegisterRn, IF_ID_RegisterRm, IF_ID_RegisterRd;

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
wire [4:0] ID_EX_RegisterRn, ID_EX_RegisterRm, ID_EX_RegisterRd;

//----EX--------
wire [1:0] ALUOp;
wire ALUSrc, Zero;
wire [63:0] ALU_result, ADD_result_EX;
wire [63:0] A, B;


//-----EX-MEM-----
wire EX_MEM_RegWrite_Out, EX_MEM_MemtoReg_Out, EX_MEM_Branch_Out, EX_MEM_MemRead_Out, EX_MEM_MemWrite_Out, EX_MEM_Zero_Out;
wire [63:0] EX_MEM_ADD_result_Out, EX_MEM_ALU_result_Out, EX_MEM_rd_data_2_Out;
wire [4:0] EX_MEM_Instruction_Out;
wire [4:0] EX_MEM_RegisterRd;

//-----MEM---------
wire [63:0] rd_data;


//----MEM-WB.....
wire MEM_WB_RegWrite, MEM_WB_MemtoReg;
wire [63:0] MEM_WB_ReadData, MEM_WB_ALU_result; 
wire [4:0] MEM_WB_Instruction;
wire [4:0] MEM_WB_RegisterRd;

//--- WB--------
wire[63:0] WB_wr_data; 



//OTHER 
assign ALUOp[1:0] = ID_EX_control_signals[1:0];
assign ALUSrc = ID_EX_control_signals[7];
wire[1:0] ForwardA, ForwardB;

//PART 2 
//wire [4:0] HARn2Rt4; //HARn2Rd4 is the result of comparison between the Rd field in the MEM stage with the Rn field in the ID stage
//wire [4:0] HARm2Rt4; // HARn2Rt4 is the result of comparison between the Rt field in the MEM stage with the Rn field in the ID stage
//wire [4:0] HARm2Rt4; // HARn2Rt3 is the result of comparison between the Rt field in the EX stage with the Rn field in the ID stage. 


//--------------------------------IF-----------------------------------------------------------//

IF IF(.clk(clk), .PCSrc(PCSrc), .ADD_result(ADD_result), .PCOut(PCOut), .InstructionOut(InstructionOut), .PCWrite(PCWrite));

//--------------------------------IF-ID-----------------------------------------------------------//

IF_ID IF_ID(.clk(clk), .PC_In(PCOut), .Instruction_In(InstructionOut), .PC_Out(IF_ID_PC_Out), .Instruction_Out(IF_ID_Instruction_Out), .IF_ID_Write(IF_ID_Write), .IF_Flush(IF_Flush));

//--------------------------------ID-----------------------------------------------------------//

hazard_detection_unit Hazard_Detection_Unit (.ID_EX_MemRead(ID_EX_control_signals[4]), .ID_EX_RegisterRd(ID_EX_RegisterRd), .IF_ID_RegisterRn1(IF_ID_RegisterRn), 
    .IF_ID_RegisterRm2(IF_ID_RegisterRm), .ControlMux(ControlMux), .IF_ID_Write(IF_ID_Write), .PCWrite(PCWrite), .opcode(IF_ID_Instruction_Out[31:21]));

assign displacement = (control_signals[2] == 1) ? IF_ID_Instruction_Out[13:5] : IF_ID_Instruction_Out[20:12];

ID ID(.clk(clk), .reset(reset), .Instruction(IF_ID_Instruction_Out), .wr_addr(MEM_WB_RegisterRd), .wr_data(WB_wr_data), .RegWrite(MEM_WB_RegWrite), .control_signals(control_signals), 
                       .displacement(displacement), .sign_extended(sign_extended), .rd_data_1(rd_data_1), .rd_data_2(rd_data_2), .RegisterRn(IF_ID_RegisterRn), .RegisterRm(IF_ID_RegisterRm), .RegisterRd(IF_ID_RegisterRd), .IF_Flush(IF_Flush));
  
wire [9:0] ctrl_output;
mux_2to1 ctrl_mux (.sel(ControlMux), .in0(control_signals), .in1(0), .out(ctrl_output)); 
             
//--------------------------------ID_EX-----------------------------------------------------------//
ID_EX ID_EX(.clk(clk), .control_signals_In(ctrl_output), .PC_In(IF_ID_PC_Out), .rd_data_1_In(rd_data_1), .rd_data_2_In(rd_data_2), .sign_extend_In(sign_extended), .opcode_In(IF_ID_Instruction_Out[31:21]),
    .RegisterRn_In(IF_ID_RegisterRn), .RegisterRm_In(IF_ID_RegisterRm),.RegisterRd_In(IF_ID_RegisterRd), .Instruction_In(IF_ID_Instruction_Out[4:0]),
    .control_signals_Out(ID_EX_control_signals), .PC_Out(ID_EX_PCOut), .rd_data_1_Out(ID_EX_rd_data_1), .rd_data_2_Out(ID_EX_rd_data_2), .sign_extend_Out(ID_EX_sign_extended), .opcode_Out(ID_EX_opcode), 
    .RegisterRn_Out(ID_EX_RegisterRn), .RegisterRm_Out(ID_EX_RegisterRm), .RegisterRd_Out(ID_EX_RegisterRd),.Instruction_Out(ID_EX_instructionOut));

//--------------------------------EX-----------------------------------------------------------//

forwarding_unit Forwarding_Unit (.EX_MEM_RegWrite(EX_MEM_RegWrite_Out), .EX_MEM_RegisterRd(EX_MEM_RegisterRd), .MEM_WB_RegWrite(MEM_WB_RegWrite), 
        .MEM_WB_RegisterRd(MEM_WB_RegisterRd), .ID_EX_RegisterRn1(ID_EX_RegisterRn), .ID_EX_RegisterRm2(ID_EX_RegisterRm), .ForwardA(ForwardA), .ForwardB(ForwardB));

mux_3to1 ALU_A_mux (.sel(ForwardA), .in0(ID_EX_rd_data_1), .in1(WB_wr_data), .in2(EX_MEM_ALU_result_Out), .out(A));
mux_3to1 ALU_B_mux (.sel(ForwardB), .in0(ID_EX_rd_data_2), .in1(WB_wr_data), .in2(EX_MEM_ALU_result_Out), .out(B));

EX EX(.ALUOp(ALUOp), .Opcode_field(ID_EX_opcode), .Zero(Zero), .ALU_result(ALU_result), 
        .ADD_result(ADD_result_EX), .ALUSrc(ALUSrc), .rd_data_1(A), .rd_data_2(B), .sign_extended(ID_EX_sign_extended),.PCOut(ID_EX_PCOut));


//--------------------------------EX_MEM-----------------------------------------------------------//
EX_MEM EX_MEM (.clk(clk), .RegWrite_In(ID_EX_control_signals[5]), .MemtoReg_In(ID_EX_control_signals[6]), .Branch_In(ID_EX_control_signals[2]), .MemRead_In(ID_EX_control_signals[4]), .MemWrite_In(ID_EX_control_signals[3]), .Zero_In(Zero), 
        .ADD_result_In(ADD_result_EX), .ALU_result_In(ALU_result), .rd_data_2_In(B), .Instruction_In(ID_EX_instructionOut), .RegWrite_Out(EX_MEM_RegWrite_Out),
        .MemtoReg_Out(EX_MEM_MemtoReg_Out), .Branch_Out(EX_MEM_Branch_Out), .MemRead_Out(EX_MEM_MemRead_Out), .MemWrite_Out(EX_MEM_MemWrite_Out), .Zero_Out(EX_MEM_Zero_Out),
        .ADD_result_Out(EX_MEM_ADD_result_Out), .ALU_result_Out(EX_MEM_ALU_result_Out), .rd_data_2_Out(EX_MEM_rd_data_2_Out), .Instruction_Out(EX_MEM_Instruction_Out),
        .RegisterRd_In(ID_EX_RegisterRd),.RegisterRd_Out(EX_MEM_RegisterRd));

//--------------------------------MEM-----------------------------------------------------------//

MEM MEM(.clk(clk), .MemWrite(EX_MEM_MemWrite_Out), .MemRead(EX_MEM_MemRead_Out), .Address(EX_MEM_ALU_result_Out), 
           .WriteData(EX_MEM_rd_data_2_Out), .ReadData(rd_data), .PCSrc(PCSrc), .Zero(EX_MEM_Zero_Out), .Branch(EX_MEM_Branch_Out)); 
           
//--------------------------------MEM-WB-----------------------------------------------------------//

MEM_WB MEM_WB (.clk(clk), .RegWrite_In(EX_MEM_RegWrite_Out), .MemtoReg_In(EX_MEM_MemtoReg_Out), .ReadData_In(rd_data), .ALU_result_In(EX_MEM_ALU_result_Out), .Instruction_In(EX_MEM_Instruction_Out),
.RegWrite_Out(MEM_WB_RegWrite), .MemtoReg_Out(MEM_WB_MemtoReg), .ReadData_Out(MEM_WB_ReadData), .ALU_result_Out(MEM_WB_ALU_result), .Instruction_Out(MEM_WB_Instruction),
.RegisterRd_In(EX_MEM_RegisterRd),.RegisterRd_Out(MEM_WB_RegisterRd));

//--------------------------------WB-----------------------------------------------------------//

WB WB(.rd_data(MEM_WB_ReadData), .ALU_result(MEM_WB_ALU_result), .MemtoReg(MEM_WB_MemtoReg), .WriteData(WB_wr_data));

endmodule
