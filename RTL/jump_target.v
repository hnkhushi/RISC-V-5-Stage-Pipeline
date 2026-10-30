`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 08:15:06 PM
// Design Name: 
// Module Name: jump_target
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


module jump_controller(
    input jump,
    input [31:0] pc,imm,forwarded_a,
    input [6:0] opcode,
    output reg [31:0] jump_target,
    output jump_taken
    );
    
    always @(*) begin
        case (opcode) 
            7'b1101111:
                jump_target = pc+imm;
            7'b1100111:
                begin
                    jump_target=forwarded_a+imm;
                    jump_target[0] = 1'b0;
                end
            default: jump_target=32'b0;
        endcase
    end
    
    assign jump_taken = jump;
endmodule
