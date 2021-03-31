`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2020 06:26:13 PM
// Design Name: 
// Module Name: hazard_detection_unit
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


module hazard_detection_unit(ID_EX_MemRead, ID_EX_RegisterRd, IF_ID_RegisterRn1, IF_ID_RegisterRm2, ControlMux, IF_ID_Write, PCWrite, opcode);
/** 
    ID_EX_RegisterRd - Destination Register in EX stage
    IF_ID_RegisterRn1 - - Source 1 Register in ID stage
    IF_ID_RegisterRm1 - - Source 2 Register in ID stage
    
    Can insert the stall between the load and
    the instruction dependent on it. 
    
    LDUR X1,[X31, #8]
    SUB X5,X4,X1
    
*/

input ID_EX_MemRead;
input [4:0] ID_EX_RegisterRd, IF_ID_RegisterRn1, IF_ID_RegisterRm2;
output reg ControlMux, IF_ID_Write, PCWrite;

input opcode;

reg HAZARD;

initial begin
ControlMux = 0; IF_ID_Write = 1; PCWrite = 1;
end

always@(*) begin
//If current instruction cotains Source Registers in ID that are equal to EX Desitionation Registers Stall
HAZARD <= (ID_EX_MemRead && ((ID_EX_RegisterRd == IF_ID_RegisterRn1) || (ID_EX_RegisterRd == IF_ID_RegisterRm2)));

if (ID_EX_MemRead && ((ID_EX_RegisterRd == IF_ID_RegisterRn1) || (ID_EX_RegisterRd == IF_ID_RegisterRm2))) begin 
    ControlMux = 1; //Zero out the control signals
    IF_ID_Write = 0; //Stop writing to the register
    PCWrite = 0; //Stop getting the next PC 
    end
    
else begin 
    ControlMux = 0;
    IF_ID_Write = 1; 
    PCWrite = 1; 
    end
end
endmodule
