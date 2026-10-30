`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2026 05:55:29 PM
// Design Name: 
// Module Name: flush_cotntroller
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


module flush_controller(
    input ex_valid,
    input ex_branch_taken,
    input ex_jump_taken,
    output reg flush
    );
    always @(*) begin
        flush = ex_valid && (ex_branch_taken || ex_jump_taken);
    end
endmodule
