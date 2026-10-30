`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2026 01:49:32 PM
// Design Name: 
// Module Name: imem
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


module imem(
    input [31:0] addr,
    output [31:0] instr,
    output if_valid
    );
    reg [31:0] mem [0:255];
    initial begin
        $readmemh("program.h", mem);
    end
    assign instr = mem[addr[31:2]];
    assign if_valid=1'b1;
endmodule
