`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2026 09:58:36 PM
// Design Name: 
// Module Name: mem_wb_reg
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


module mem_wb_reg(
    input clk,rst,mem_wb_en,valid_in,reg_write_in,
    input [31:0] alu_result_in,read_data_in,pc_plus4_in,
    input [4:0] rd_addr_in,
    input [1:0] wb_src_in,
    output reg valid_out,reg_write_out,
    output reg [31:0] alu_result_out,read_data_out,pc_plus4_out,
    output reg [4:0] rd_addr_out,
    output reg [1:0] wb_src_out
    );
    always @(posedge clk) begin
        if (rst) begin
            valid_out<=1'b0;
            reg_write_out<=1'b0;
            alu_result_out<=32'b0;
            read_data_out<=32'b0;
            pc_plus4_out<=32'b0;
            rd_addr_out<=5'b0;
            wb_src_out<=2'b0;
        end
        else if (mem_wb_en) begin
            valid_out<=valid_in;
            reg_write_out<=reg_write_in;
            alu_result_out<=alu_result_in;
            read_data_out<=read_data_in;
            pc_plus4_out<=pc_plus4_in;
            rd_addr_out<=rd_addr_in;
            wb_src_out<=wb_src_in;
        end
    end
endmodule
