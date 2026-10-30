`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 08:36:33 PM
// Design Name: 
// Module Name: pc
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


module pc_mod(
    input clk,rst,
    input [31:0] pc_next,
    output reg [31:0] pc
    );
    always @ (posedge clk) begin
        if (rst) pc<=32'b0;
        else pc<=pc_next;
    end
endmodule
