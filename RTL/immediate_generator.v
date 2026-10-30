`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2026 05:15:04 PM
// Design Name: 
// Module Name: immediate_generator
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


module immediate_generator(
    input [31:0] instr,
    input [2:0] imm_type,
    output reg [31:0] immediate
    );
    always @(*) begin
        case (imm_type)
            3'b001: immediate = {{20{instr[31]}},{instr[31:20]}}; //I-type
            3'b010: immediate = {{20{instr[31]}},{instr[31:25]},{instr[11:7]}}; //S-type
            3'b011: immediate = {{19{instr[31]}},{instr[31]},{instr[7]},{instr[30:25]},{instr[11:8]},{1'b0}}; //B-type
            3'b100: immediate = {instr[31:12], 12'b0}; //U-type
            3'b101: immediate = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0}; //J-type
            default: immediate = 32'b0;
        endcase   
    end
endmodule
