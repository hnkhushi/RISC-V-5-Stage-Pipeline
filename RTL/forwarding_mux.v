`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2026 05:46:43 PM
// Design Name: 
// Module Name: forwarding_mux
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


module forwarding_mux(
    input [31:0] rs1_data, rs2_data, mem_alu_result, wb_data,
    input forward_a_mem,forward_a_wb,forward_b_mem,forward_b_wb,
    output reg [31:0] forwarded_a,forwarded_b
    );
    always @(*) begin
        if (forward_a_mem) 
            forwarded_a = mem_alu_result;
        else if (forward_a_wb)
            forwarded_a = wb_data;
        else 
            forwarded_a = rs1_data;
    end
    
    always @(*) begin
        if (forward_b_mem) 
            forwarded_b = mem_alu_result;
        else if (forward_b_wb)
            forwarded_b = wb_data;
        else 
            forwarded_b = rs2_data;
    end
    
endmodule
