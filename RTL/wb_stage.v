`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2026 10:31:36 PM
// Design Name: 
// Module Name: wb_stage
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


module wb_stage(
input valid,reg_write,
input [31:0] alu_result,read_data,pc_plus4,
input [4:0] rd_addr,
input [1:0] wb_src,
output reg [31:0] wb_data,
output [4:0] wb_rd_addr,
output wb_reg_write
    );
    always @(*) begin
    case(wb_src)
    2'b00: wb_data = alu_result;
    2'b01: wb_data = read_data;
    2'b10: wb_data = pc_plus4;
    default: wb_data = 32'b0;
    endcase
    end
    
    assign wb_rd_addr = rd_addr;
    assign wb_reg_write = valid && reg_write && (rd_addr!=5'b0);
endmodule
