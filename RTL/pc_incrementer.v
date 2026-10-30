`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2026 01:47:36 PM
// Design Name: 
// Module Name: pc_incrementer
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


module pc_incrementer(
    input [31:0] pc,
    output [31:0] pcplus4 
    );
    assign pcplus4 = pc+4;
endmodule
