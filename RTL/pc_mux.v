`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 08:32:26 PM
// Design Name: 
// Module Name: pc_mux
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


module pc_mux(
    input [31:0] pcplus4,branch_target,jump_target,
    input branch_taken,jump_taken,
    output reg [31:0] pc_next
    );
    always @(*) begin
    if (branch_taken) pc_next = branch_target;
    else if (jump_taken) pc_next = jump_target;
    else pc_next = pcplus4;
    end
endmodule
