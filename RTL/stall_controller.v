`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2026 04:34:54 PM
// Design Name: 
// Module Name: stall_controller
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


module stall_controller(
    input id_valid,
    input ex_valid,
    input ex_mem_read,
    input [4:0] ex_rd_addr,
    input [4:0] id_rs1_addr,
    input [4:0] id_rs2_addr,
    input id_rs1_used,
    input id_rs2_used,
    output reg stall
    );
    
    always @(*) begin
        stall = id_valid && ex_valid && ex_mem_read && (ex_rd_addr != 5'b0) &&
        ((id_rs1_used && (id_rs1_addr==ex_rd_addr)) || (id_rs2_used && (id_rs2_addr==ex_rd_addr)));
    end
endmodule
