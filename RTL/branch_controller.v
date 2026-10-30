`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 08:02:37 PM
// Design Name: 
// Module Name: branch_controller
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


module branch_controller(
    input [31:0] pc,imm,forwarded_a,forwarded_b,
    input [2:0] funct3,
    input branch,
    output [31:0] branch_target,
    output branch_taken
    );
    reg condition;
    always @(*) begin
        case(funct3)
            3'b000: condition = (forwarded_a==forwarded_b);
            3'b001: condition = (forwarded_a!=forwarded_b);
            3'b100: condition = ($signed(forwarded_a)<$signed(forwarded_b));
            3'b101: condition = ($signed(forwarded_a)>=$signed(forwarded_b));
            3'b110: condition = (forwarded_a<forwarded_b);
            3'b111: condition = (forwarded_a>=forwarded_b);
            default: condition = 1'b0;
        endcase
    end
    assign branch_taken = branch && condition;
    assign branch_target = pc+imm;
endmodule
