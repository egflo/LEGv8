`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CECS 530 - FALL 2020
// Engineer: Emmanuel Flores
// 
// Create Date: 09/03/2020 08:37:03 PM
// Design Name: 
// Module Name: LEGv8ALU
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
module LEGv8ALU (ALU_operation, A, B, ALU_result, Zero);
    input [3:0] ALU_operation;
    input [63:0] A, B;
    output reg [63:0] ALU_result;
    output Zero;
    
// put your code here
    always @(A,B,ALU_operation)
    case(ALU_operation) 
    0: ALU_result <= A & B; // AND
    1: ALU_result <= A | B; // OR
    2: ALU_result <= A + B; // ADD
    6: ALU_result <= A - B; // SUBTRACT
    7: ALU_result <= B; // PASS INPUT B
    12: ALU_result <= ~(A|B); //NOR
    default: ALU_result <= 0;
    endcase
  
    //wire wire_variable = value;
    //assign wire_variable = expression
    assign Zero = ALU_result == 0; //ZERO FLAG
        
endmodule