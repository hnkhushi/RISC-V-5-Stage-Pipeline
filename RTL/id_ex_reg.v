`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2026 08:10:46 PM
// Design Name: 
// Module Name: id_ex_reg
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


module id_ex_reg(
    input clk,rst,id_ex_en,flush,valid_in,
    input [31:0] pc_in,pcplus4_in,rs1_data_in,rs2_data_in,immediate_in,
    input [4:0] rs1_addr_in,rs2_addr_in,rs_addr_in,
    input [2:0] funct3_in,
    input [6:0] opcode_in,funct7_in,
    input reg_write_in,mem_read_in,mem_write_in,branch_in,jump_in,jalr_in,rs1_used_in,rs2_used_in,
    input [1:0] alua_src_in,alub_src_in,wb_src_in,
    output reg valid_out,
    output reg [31:0] pc_out,pcplus4_out,rs1_data_out,rs2_data_out,immediate_out,
    output reg [4:0] rs1_addr_out,rs2_addr_out,rs_addr_out,
    output reg [2:0] funct3_out,
    output reg [6:0] opcode_out,funct7_out,
    output reg reg_write_out,mem_read_out,mem_write_out,branch_out,jump_out,jalr_out,rs1_used_out,rs2_used_out,
    output reg [1:0] alua_src_out,alub_src_out,wb_src_out );
    
    always @(posedge clk) begin
    if(rst) begin
        pc_out<=32'b0;
        pcplus4_out<=32'b0;
        rs1_data_out<=32'b0;
        rs2_data_out<=32'b0;
        immediate_out<=32'b0;
        rs1_addr_out<=5'b0;
        rs2_addr_out<=5'b0;
        rs_addr_out<=5'b0;
        funct3_out<=3'b0;
        opcode_out<=7'b0;
        funct7_out<=7'b0;
        reg_write_out<=1'b0;
        mem_read_out<=1'b0;
        mem_write_out<=1'b0;
        branch_out<=1'b0;
        jump_out<=1'b0;
        jalr_out<=1'b0;
        alua_src_out<=2'b0;
        alub_src_out<=2'b0;
        wb_src_out<=2'b0;
        rs1_used_out<=1'b0;
        rs2_used_out<=1'b0;
    
    end
    else if (flush) begin
        // Insert a bubble into EX.
        valid_out      <= 1'b0;
        reg_write_out  <= 1'b0;
        mem_read_out   <= 1'b0;
        mem_write_out  <= 1'b0;
        branch_out     <= 1'b0;
        jump_out       <= 1'b0;
        jalr_out       <= 1'b0;
        rs1_used_out   <= 1'b0;
        rs2_used_out   <= 1'b0;

        alua_src_out   <= 2'b0;
        alub_src_out   <= 2'b0;
        wb_src_out     <= 2'b0;
    end
    else if (id_ex_en) begin
        pc_out<=pc_in;
        pcplus4_out<=pcplus4_in;
        rs1_data_out<=rs1_data_in;
        rs2_data_out<=rs2_data_in;
        immediate_out<=immediate_in;
        rs1_addr_out<=rs1_addr_in;
        rs2_addr_out<=rs2_addr_in;
        rs_addr_out<=rs_addr_in;
        funct3_out<=funct3_in;
        opcode_out<=opcode_in;
        funct7_out<=funct7_in;
        reg_write_out<=reg_write_in;
        mem_read_out<=mem_read_in;
        mem_write_out<=mem_write_in;
        branch_out<=branch_in;
        jump_out<=jump_in;
        jalr_out<=jalr_in;
        alua_src_out<=alua_src_in;
        alub_src_out<=alub_src_in;
        wb_src_out<=wb_src_in;
        rs1_used_out<=rs1_used_in;
        rs2_used_out<=rs2_used_in;
    end
    
    if (rst|flush) valid_out<=1'b0;
    else if (id_ex_en) valid_out<=valid_in;
    end
endmodule
