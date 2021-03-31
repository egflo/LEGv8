`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2020 06:00:11 PM
// Design Name: 
// Module Name: RFALUDM
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


module RFALUDM(ALUOp, Opcode_field, Zero, 
    clk, reset, RegWrite, rd_addr_1, rd_addr_2, wr_addr, ALUSrc, displacement,
    MemWrite, MemRead, MemtoReg, sign_extended);
        

//ALUwithControl I/O
input  [1:0]   ALUOp;
input  [10:0]   Opcode_field;    
output   Zero;
wire [63:0] ALU_result; //connect ALU_Result to Data Memory addr and to mem_reg in1

//RF I/O
input clk, reset, RegWrite; 
input [4:0] rd_addr_1, rd_addr_2, wr_addr;
wire [63:0] rd_data_1; //Connect rd_data_1 to ALU port A
wire [63:0] rd_data_2; //Connect rd_data_2 to mux and wr_data (MEM) and connect to wr_data
 
//MEM I/0
input MemWrite, MemRead; 
wire [63:0] rd_data; //Connect rd_data(MEM) to mem_reg in0
wire[63:0] wr_data; //Connect wr_data (mux) to wr_data (mem)

//Sign Extend I/O
input ALUSrc;
input [8:0] displacement;
output [63:0] sign_extended;

//ALU_Src to ALU input B
wire[63:0] alu_src_out;

//Mem_reg I/0
input MemtoReg;
wire[63:0] mem_reg_out; //Connect to RF wr_data


//---------------------- MUX ----------------------
mux_2to1 alu_src (.sel(ALUSrc), .in0(rd_data_2), .in1(sign_extended), .out(alu_src_out));

mux_2to1 mem_reg (.sel(MemtoReg), .in0(ALU_result), .in1(rd_data), .out(mem_reg_out));

//---------------------- MAIN MODUELS ----------------------
sign_extend signext(.in(displacement), .out(sign_extended));

DataMem datamem(.clk(clk), .mem_wr(MemWrite), .mem_rd(MemRead), .addr(ALU_result), .wr_data(rd_data_2), .rd_data(rd_data)); 

LEGv8ALUwithControl ALUwithCtrl(.ALUOp(ALUOp), .Opcode_field(Opcode_field), .A(rd_data_1), .B(alu_src_out),  .ALU_result(ALU_result), .Zero(Zero));    

regfile RF (.clk(clk), .reset(reset), .wr_en(RegWrite), .rd_addr_1(rd_addr_1),
             .rd_addr_2(rd_addr_2), .wr_addr(wr_addr), .wr_data(mem_reg_out), .rd_data_1(rd_data_1), .rd_data_2(rd_data_2)); 

    
endmodule