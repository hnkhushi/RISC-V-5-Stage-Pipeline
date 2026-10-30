`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2026 01:50:47 PM
// Design Name: 
// Module Name: id_id_reg
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


module if_id_reg(
    input clk,rst,ifid_en,flush,validin,
    input [31:0] pc,pcplus4,instr,
    output reg [31:0] pcout,pcplus4out,instrout,
    output reg validout
    );
    always @ (posedge clk) begin
        if (rst) begin
            pcout<=32'b0;
            pcplus4out<=32'b0;
            instrout<=32'b0;
        end
        else if (ifid_en) begin
            pcout<=pc;
            pcplus4out<=pcplus4;
            instrout<=instr;
        end
        if (rst | flush) begin
            validout<=1'b0;
        end
        else if (ifid_en) begin
            validout<=validin;
        end
    end
endmodule
