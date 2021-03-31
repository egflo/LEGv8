`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CECS 530 - FALL 2020
// Engineer:  EMMANUEL FLRES
// 
// Create Date: 09/22/2020 11:17:08 AM
// Design Name: 
// Module Name: DataMem
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

module DataMem (clk, mem_wr, mem_rd, addr, wr_data, rd_data); 
 
input clk, mem_wr, mem_rd; 
input [7:0] addr; //addresses are from 00(0) to FF (255) 
input [63:0] wr_data; 
output [63:0] rd_data; 
reg [7:0] RF[0:255];
//256 bytes / 8 Bytes = 32 Double Words 
//1 Byte = 8 Bits

initial
begin
RF[0] = 8'h00;
RF[0 + 1] = 8'h00;
RF[0 + 2] = 8'h00;
RF[0 + 3] = 8'h00;
RF[0 + 4] = 8'h00;
RF[0 + 5] = 8'h00;
RF[0 + 6] = 8'h00;
RF[0 + 7] = 8'h00;

RF[8] = 8'h11;
RF[8 + 1] = 8'h11;
RF[8 + 2] = 8'h11;
RF[8 + 3] = 8'h11;
RF[8 + 4] = 8'h11;
RF[8 + 5] = 8'h11;
RF[8 + 6] = 8'h11;
RF[8 + 7] = 8'h11;

RF[16] = 8'h22;
RF[16 + 1] = 8'h22;
RF[16 + 2] = 8'h22;
RF[16 + 3] = 8'h22;
RF[16 + 4] = 8'h22;
RF[16 + 5] = 8'h22;
RF[16 + 6] = 8'h22;
RF[16 + 7] = 8'h22;

RF[24] = 8'h33;
RF[24 + 1] = 8'h33;
RF[24 + 2] = 8'h33;
RF[24 + 3] = 8'h33;
RF[24 + 4] = 8'h33;
RF[24 + 5] = 8'h33;
RF[24 + 6] = 8'h33;
RF[24 + 7] = 8'h33;

RF[32] = 8'h44;
RF[32 + 1] = 8'h44;
RF[32 + 2] = 8'h44;
RF[32 + 3] = 8'h44;
RF[32 + 4] = 8'h44;
RF[32 + 5] = 8'h44;
RF[32 + 6] = 8'h44;
RF[32 + 7] = 8'h44;

RF[40] = 8'h55;
RF[40 + 1] = 8'h55;
RF[40 + 2] = 8'h55;
RF[40 + 3] = 8'h55;
RF[40 + 4] = 8'h55;
RF[40 + 5] = 8'h55;
RF[40 + 6] = 8'h55;
RF[40 + 7] = 8'h55;

RF[48] = 8'h66;
RF[48 + 1] = 8'h66;
RF[48 + 2] = 8'h66;
RF[48 + 3] = 8'h66;
RF[48 + 4] = 8'h66;
RF[48 + 5] = 8'h66;
RF[48 + 6] = 8'h66;
RF[48 + 7] = 8'h66;

RF[56] = 8'h77;
RF[56 + 1] = 8'h77;
RF[56 + 2] = 8'h77;
RF[56 + 3] = 8'h77;
RF[56 + 4] = 8'h77;
RF[56 + 5] = 8'h77;
RF[56 + 6] = 8'h77;
RF[56 + 7] = 8'h77;

RF[64] = 8'h88;
RF[64 + 1] = 8'h88;
RF[64 + 2] = 8'h88;
RF[64 + 3] = 8'h88;
RF[64 + 4] = 8'h88;
RF[64 + 5] = 8'h88;
RF[64 + 6] = 8'h88;
RF[64 + 7] = 8'h88;

RF[72] = 8'h99;
RF[72 + 1] = 8'h99;
RF[72 + 2] = 8'h99;
RF[72 + 3] = 8'h99;
RF[72 + 4] = 8'h99;
RF[72 + 5] = 8'h99;
RF[72 + 6] = 8'h99;
RF[72 + 7] = 8'h99;

RF[80] = 8'haa;
RF[80 + 1] = 8'haa;
RF[80 + 2] = 8'haa;
RF[80 + 3] = 8'haa;
RF[80 + 4] = 8'haa;
RF[80 + 5] = 8'haa;
RF[80 + 6] = 8'haa;
RF[80 + 7] = 8'haa;

RF[88] = 8'hbb;
RF[88 + 1] = 8'hbb;
RF[88 + 2] = 8'hbb;
RF[88 + 3] = 8'hbb;
RF[88 + 4] = 8'hbb;
RF[88 + 5] = 8'hbb;
RF[88 + 6] = 8'hbb;
RF[88 + 7] = 8'hbb;

RF[96] = 8'hcc;
RF[96 + 1] = 8'hcc;
RF[96 + 2] = 8'hcc;
RF[96 + 3] = 8'hcc;
RF[96 + 4] = 8'hcc;
RF[96 + 5] = 8'hcc;
RF[96 + 6] = 8'hcc;
RF[96 + 7] = 8'hcc;

end

//asynchronous read memory: reading is independent of the clock
//MemRead = 0 have high impedance (all 'Z') on the read ports else read from addr
assign rd_data = (mem_rd == 0) ? 64'hzzzzzzzzzzzzzzzz : {RF[addr], RF[addr + 1], RF[addr + 2], RF[addr + 3], RF[addr + 4], RF[addr + 5], RF[addr + 6], RF[addr + 7]};

//posedge - rising edge of the clock  0 to 1 (Executes Block on the positive (rising) edge of a clock signal)
always@(posedge clk) //Execute Block on the rising edge 0->1
begin
    if(mem_rd == 1 & mem_wr == 1) begin
        RF[addr] = wr_data[63:56];
        RF[addr + 1] = wr_data[55:48];
        RF[addr + 2] = wr_data[47:40];
        RF[addr + 3] = wr_data[39:32];
        RF[addr + 4] = wr_data[31:24];
        RF[addr + 5] = wr_data[23:16];
        RF[addr + 6] = wr_data[15:8];
        RF[addr + 7] = wr_data[7:0];
        
        //rd_data <= {RF[addr], RF[addr + 1], RF[addr + 2], RF[addr + 3], RF[addr + 4], RF[addr + 5], RF[addr + 6], RF[addr + 7]};
    end
    else if(mem_rd == 0 & mem_wr == 1) begin
        RF[addr] <= wr_data[63:56];
        RF[addr + 1] <= wr_data[55:48];
        RF[addr + 2] <= wr_data[47:40];
        RF[addr + 3] <= wr_data[39:32];
        RF[addr + 4] <= wr_data[31:24];
        RF[addr + 5] <= wr_data[23:16];
        RF[addr + 6] <= wr_data[15:8];
        RF[addr + 7] <= wr_data[7:0];
    end   
end   

endmodule
