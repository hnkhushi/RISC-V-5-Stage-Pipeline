`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 08:43:00 PM
// Design Name: 
// Module Name: ex_mem_reg
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


module ex_mem_reg(
    input clk,rst,ex_mem_en,valid_in,
    input [31:0] pc_plus4_in,alu_result_in,rs1_data_in,rs2_data_in,
    input [4:0] rd_addr_in,
    input [2:0] funct3_in,
    input reg_write_in,mem_write_in,mem_read_in,
    input [1:0] wb_src_in,
    output reg valid_out,
    output reg [31:0] pc_plus4_out,alu_result_out,rs1_data_out,rs2_data_out,
    output reg [4:0] rd_addr_out,
    output reg [2:0] funct3_out,
    output reg reg_write_out,mem_write_out,mem_read_out,
    output reg [1:0] wb_src_out
    );
    always @(posedge clk) begin
    if(rst) begin
        valid_out<=1'b0;
        pc_plus4_out<=32'b0;
        alu_result_out<=32'b0;
        rs1_data_out<=32'b0;
        rs2_data_out<=32'b0;
        rd_addr_out<=5'b0;
        funct3_out<=3'b0;
        reg_write_out<=1'b0;
        mem_write_out<=1'b0;
        mem_read_out<=1'b0;
        wb_src_out<=2'b0;
    end
    else if (ex_mem_en) begin
        valid_out<=valid_in;
        pc_plus4_out<=pc_plus4_in;
        alu_result_out<=alu_result_in;
        rs1_data_out<=rs1_data_in;
        rs2_data_out<=rs2_data_in;
        rd_addr_out<=rd_addr_in;
        funct3_out<=funct3_in;
        reg_write_out<=reg_write_in;
        mem_write_out<=mem_write_in;
        mem_read_out<=mem_read_in;
        wb_src_out<=wb_src_in;
    end
    end
endmodule
