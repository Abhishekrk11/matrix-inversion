`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.10.2024 20:28:15
// Design Name: 
// Module Name: tb
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


module tb();
    
 reg clk,rst,start;
 reg [71:0] matrix_in;
 wire done;
 wire [71:0] matrix_out;
 Matrix_Inversion_Top d1
(
clk,
rst,
start,
matrix_in,done,
matrix_out
);
 integer i;
 initial 
 clk=0;
 
 always
 #10 clk=~clk;
 
 initial
 begin
 rst=1;
 #15 rst=0;
 matrix_in[7:0]=8'd1;
 matrix_in[15:8]=8'd2;
 matrix_in[23:16]=8'd3;
 matrix_in[31:24]=8'd2;
 matrix_in[39:32]=8'd1;
 matrix_in[47:40]=8'd5;
 matrix_in[55:48]=8'd3;
 matrix_in[63:56]=8'd5;
 matrix_in[71:64]=8'd6;
 start=1;
 end
endmodule
