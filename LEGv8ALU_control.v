`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CECS 530 - FALL 2020
// Engineer: Emmanuel Flores
// 
// Create Date: 09/07/2020 09:53:42 AM
// Design Name: 
// Module Name: LEGv8ALU_control
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


// Do NOT change name of the module or input and output ports 
module LEGv8ALU_control (ALU_operation, Opcode_field,  ALU_op);   
    input [1:0] ALU_op;  
    input [10:0] Opcode_field; 
    output reg [3:0] ALU_operation; 
    
    // put your code here 
    // x - Don't care bits  
    //Use ? For don't care
  
    always @(Opcode_field, ALU_op)
    casex(ALU_op)  
    2'b1x: 
        case(Opcode_field)
          11'b1000_1011_000: ALU_operation <= 4'b0010; //ADD
          11'b1100_1011_000: ALU_operation <= 4'b0110; //SUBTACT
          11'b1000_1010_000: ALU_operation <= 4'b0000; //AND
          11'b1010_1010_000: ALU_operation <= 4'b0001; //OR
        endcase
    2'b00: 
        case(Opcode_field)
          11'b11_111_000_010: ALU_operation <= 4'b0010; //LOAD
          11'b11_111_000_000: ALU_operation <= 4'b0010; //STORE
          11'bxx_xxx_xxx_xxx: ALU_operation <= 4'b1100; //NOR
        endcase
    2'bx1: ALU_operation <= 4'b0111; //PASS INPUT B
    default: ALU_operation <= 0;
    endcase    
endmodule  
