`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2026 05:09:26 PM
// Design Name: 
// Module Name: forwarding_unit
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


module forwarding_unit(
    input rs1_used,rs2_used,
    input [4:0] ex_rs1_addr,ex_rs2_addr,
    input mem_valid,
    input [4:0] mem_rd_addr,
    input mem_reg_write,
    input wb_valid,
    input wb_reg_write,
    input [4:0] wb_rd_addr,
    output forward_a_mem,forward_a_wb,forward_b_mem,forward_b_wb
    );
    
    
    // Forward from EX/MEM (highest priority)
assign forward_a_mem =
    rs1_used &&
    (ex_rs1_addr != 5'd0) &&
    mem_valid &&
    mem_reg_write &&
    (mem_rd_addr != 5'd0) &&
    (ex_rs1_addr == mem_rd_addr);

assign forward_b_mem =
    rs2_used &&
    (ex_rs2_addr != 5'd0) &&
    mem_valid &&
    mem_reg_write &&
    (mem_rd_addr != 5'd0) &&
    (ex_rs2_addr == mem_rd_addr);

// Forward from MEM/WB only if EX/MEM is not forwarding
assign forward_a_wb =
    rs1_used &&
    (ex_rs1_addr != 5'd0) &&
    wb_valid &&
    wb_reg_write &&
    (wb_rd_addr != 5'd0) &&
    (ex_rs1_addr == wb_rd_addr) &&
    !forward_a_mem;

assign forward_b_wb =
    rs2_used &&
    (ex_rs2_addr != 5'd0) &&
    wb_valid &&
    wb_reg_write &&
    (wb_rd_addr != 5'd0) &&
    (ex_rs2_addr == wb_rd_addr) &&
    !forward_b_mem;
    
endmodule
