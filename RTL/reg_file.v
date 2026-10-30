`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2026 07:44:07 PM
// Design Name: 
// Module Name: reg_file
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


module reg_file(
    input clk,rst,wr_en,
    input [4:0] rs1_addr, rs2_addr,rd_addr,
    input [31:0] wr_data, 
    output reg [31:0] rs1_data,rs2_data
    );
    reg [31:0] mem [0:31];
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            mem[i] = 0;
    end
    always @ (posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                mem[i] = 0;
        end
        else if (wr_en&&rd_addr!=5'b0) begin
            mem[rd_addr]=wr_data;
        end
    end
    always @(*) begin
        if (rs1_addr==5'b0)
        rs1_data=32'b0;
        else if (wr_en && (rd_addr!=5'b0) && (rs1_addr==rd_addr)) begin
            rs1_data=wr_data;
        end
        else rs1_data=mem[rs1_addr];
    end
    always @(*) begin
        if (rs2_addr==5'b0)
        rs2_data=32'b0;
        else if (wr_en && (rd_addr!=5'b0) && (rs2_addr==rd_addr)) begin
            rs2_data=wr_data;
        end
        else rs2_data=mem[rs2_addr];
    end
endmodule
