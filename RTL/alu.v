`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2026 04:38:54 PM
// Design Name: 
// Module Name: alu
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


module alu(
    input [31:0] op_a,op_b,
    input [3:0] alu_control,
    output reg [31:0] alu_result,
    output reg less,lessu,zero
    );
    always @(*) begin
        less=1'b0;
        lessu=1'b0;
        case (alu_control)
            4'b0000: alu_result = op_a+op_b;
            4'b0001: alu_result = op_a-op_b;
            4'b0010: alu_result = op_a&op_b;
            4'b0011: alu_result = op_a|op_b;
            4'b0100: alu_result = op_a^op_b;
            4'b0101: alu_result = op_a << op_b[4:0];
            4'b0110: alu_result = op_a >> op_b[4:0];
            4'b0111: alu_result = ($signed(op_a)) >>> op_b[4:0];
            4'b1000: begin
                        less = ($signed(op_a)<$signed(op_b));
                        alu_result = {31'b0,less};
                    end
            4'b1001: begin
                        lessu = (op_a<op_b);
                        alu_result = {31'b0,lessu};
                    end
           default: alu_result=32'b0;
        endcase
        
        if (alu_result==32'b0)
        zero=1'b1;
        else
        zero=1'b0;
    end
endmodule
