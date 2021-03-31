`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2020 04:10:06 PM
// Design Name: 
// Module Name: forwarding_unit
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
/*
ALU instruction (which comes from the Rd
field of the instruction) or a load (which comes from the Rt field, but we'll use the
notation Rd in this section)

ID_EX_RegisterRn1 ==> SOURCE 1
ID_EX_RegisterRm2 ==> SOURCE 2 
*/

module forwarding_unit(EX_MEM_RegWrite, EX_MEM_RegisterRd, MEM_WB_RegWrite, MEM_WB_RegisterRd,
    ID_EX_RegisterRn1, ID_EX_RegisterRm2, ForwardA, ForwardB);
    
input EX_MEM_RegWrite, MEM_WB_RegWrite;
input [4:0] EX_MEM_RegisterRd, MEM_WB_RegisterRd; 
input [4:0] ID_EX_RegisterRn1, ID_EX_RegisterRm2;

reg EX_HAZARD_Rn1;
reg EX_HAZARD_Rm2;

reg MEM_HAZARD_Rn1;
reg MEM_HAZARD_Rm2;

output reg [1:0] ForwardA, ForwardB;
always@(*)
begin
ForwardA <= 2'b00; //The first ALU operand comes from the register file
ForwardB <= 2'b00; //The second ALU operand comes from the register file


//EX HAZARD
//  If RF Writing,      Check it is not base Reg     Compare EX Desitnation and EX Source 1/2 Register and Forward if True
if (EX_MEM_RegWrite && (EX_MEM_RegisterRd != 31) && (EX_MEM_RegisterRd == ID_EX_RegisterRn1)) ForwardA <= 2'b10; //The first ALU operand is forwarded from the prior ALU result.
if (EX_MEM_RegWrite && (EX_MEM_RegisterRd != 31) && (EX_MEM_RegisterRd == ID_EX_RegisterRm2)) ForwardB <= 2'b10; //The second ALU operand is forwarded from the prior ALU result

EX_HAZARD_Rn1 <= (EX_MEM_RegWrite && (EX_MEM_RegisterRd != 31) && (EX_MEM_RegisterRd == ID_EX_RegisterRn1));
EX_HAZARD_Rm2 <= (EX_MEM_RegWrite && (EX_MEM_RegisterRd != 31) && (EX_MEM_RegisterRd == ID_EX_RegisterRm2));

//MEM HAZARD
//Check if RF Write and Desitionation Register is not base
if (MEM_WB_RegWrite && (MEM_WB_RegisterRd != 31) 
//&&  !(EX_MEM_RegWrite && (EX_MEM_RegisterRd != 31) && (EX_MEM_RegisterRd != ID_EX_RegisterRn1))
//IF Write Back Register Destination is equal to EX Source Register 1/2
&&  (MEM_WB_RegisterRd == ID_EX_RegisterRn1)) ForwardA <= 2'b01; //The first ALU operand is forwarded from data memory or an earlier ALU result.


if (MEM_WB_RegWrite && (MEM_WB_RegisterRd != 31) 
//&&  !(EX_MEM_RegWrite && (EX_MEM_RegisterRd != 31) && (EX_MEM_RegisterRd != ID_EX_RegisterRm2))
&&  (MEM_WB_RegisterRd == ID_EX_RegisterRm2)) ForwardB <= 2'b01; //The second ALU operand is forwarded from data memory or an earlier ALU result.

MEM_HAZARD_Rn1 <= (MEM_WB_RegWrite && (MEM_WB_RegisterRd != 31) && !(EX_MEM_RegWrite && (EX_MEM_RegisterRd != 31) && (EX_MEM_RegisterRd != ID_EX_RegisterRn1)) && (MEM_WB_RegisterRd == ID_EX_RegisterRn1));
MEM_HAZARD_Rm2 <= (MEM_WB_RegWrite && (MEM_WB_RegisterRd != 31) && !(EX_MEM_RegWrite && (EX_MEM_RegisterRd != 31) && (EX_MEM_RegisterRd != ID_EX_RegisterRn1)) && (MEM_WB_RegisterRd == ID_EX_RegisterRn1));

end
endmodule
