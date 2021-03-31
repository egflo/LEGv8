`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CECS 530 - FALL 2020
// Engineer: Emmanuel Flores
// 
// Create Date: 09/11/2020 10:02:34 AM
// Design Name: 
// Module Name: regfile
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
                                Wr_en   clk   reset
                                   |    |      |
                                   |    |      |
                                ____________________
    Read               5       |                    |
    Register 1 -------/----->  |                    |
    (Address)                  |                    |
                               |                    |
    Read              5        |                    |----------/------> Read Data 1
    Register 2 -------/----->  |   Register File    |                   (to A input of ALU)
    (Address)                  |                    |
                               |                    |
    Write            5         |                    |----------/------> Read Data 2 
    Register -------/------>   |                    |                   (to B Input of ALU)
                               |                    |
                  64           |                    |
    Write  -------/-------->   |                    |
    Data                       |____________________|
   

*/

//clk - Clock
//reset - reset
//Write_enable - wr_en

//Read Register 1 - rd_addr_1 -> Instruction[9:5] Rn
//Read Register 2 - rd_addr_2
//Write Register - wr_addr
//Write Data - wr_data

//Read Data 1- rd_data_1
//Read Data 2 - rd_data_2

module regfile (clk, reset, wr_en, rd_addr_1, rd_addr_2, wr_addr, wr_data, rd_data_1, rd_data_2); 
    
input clk, reset, wr_en; //Clock, Reset, Write_Enabled
input [4:0] rd_addr_1, rd_addr_2, wr_addr; //Read_Address_1, Read_Address_2, Write_Address
input [63:0] wr_data; //Write_Data
output reg [63:0] rd_data_1, rd_data_2; //Read_Data_1, Read_Data_2
reg [63:0] RF[0:31]; //Memory Array (Register File)

// Add your code here
integer i; //For Loop 

// initialize R0 as all zeros in the Register module itself.
initial begin
RF[31] = 0;
end

//assign rd_data_1 = RF[rd_addr_1]; 
//assign rd_data_2 = RF[rd_addr_2];

//posedge - rising edge of the clock  0 to 1 (Executes Block on the positive (rising) edge of a clock signal)
always@(posedge clk) //Execute Block on the rising edge 0->1
begin
    if(reset == 1) begin
        //Clear Register File 
        //For loop -> Zero Everything
        for (i=0; i < 32; i=i+1) begin
            RF[i] <= 0;
        end
     end
    else if (wr_en) begin //Write Enable - Write Data to Register File
        RF[wr_addr] <= wr_data; 
    end
end

always@(negedge clk)
 begin
    if ((rd_addr_1 == wr_addr)&& wr_en) begin
        rd_data_1 <= wr_data;
    end else begin
        rd_data_1 <= RF[rd_addr_1];
    end
    
     if ((rd_addr_2 == wr_addr)&& wr_en) begin
        rd_data_2 <= wr_data;
    end else begin
        rd_data_2 <= RF[rd_addr_2];
    end
 end 
endmodule 
