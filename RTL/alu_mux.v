`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2026 05:13:43 PM
// Design Name: 
// Module Name: alu_mux
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


module alu_mux(
    input [31:0] forwarded_a, forwarded_b, pc, imm,
    input [1:0] alua_src,alub_src,
    output reg [31:0] alua_out, alub_out
    );
    
    always @(*) begin
        case (alua_src)
            2'b00: alua_out=forwarded_a;
            2'b01: alua_out=pc;
            2'b10: alua_out=32'b0;
            default: alua_out=forwarded_a;
        endcase
        case (alub_src)
            2'b00: alub_out=forwarded_b;
            2'b01: alub_out=imm;
            default: alub_out=forwarded_b;
        endcase
    end
endmodule
