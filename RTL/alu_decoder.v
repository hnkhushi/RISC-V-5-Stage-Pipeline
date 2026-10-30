`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2026 05:39:55 PM
// Design Name: 
// Module Name: alu_decoder
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


module alu_decoder(
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [3:0] alu_control
    );
    
    localparam [3:0] ADD = 4'b0000;
    localparam [3:0] SUB = 4'b0001;
    localparam [3:0] AND = 4'b0010;
    localparam [3:0] OR = 4'b0011;
    localparam [3:0] XOR = 4'b0100;
    localparam [3:0] SLL = 4'b0101;
    localparam [3:0] SRL = 4'b0110;
    localparam [3:0] SRA = 4'b0111;
    localparam [3:0] SLT = 4'b1000;
    localparam [3:0] SLTU = 4'b1001;
    
    
    always @(*) begin
        case (opcode)
            7'b0010011: begin 
            case (funct3)   //I type
                3'b000: alu_control = ADD; //ADDI
                3'b001: alu_control = SLL; //SLLI
                3'b010: alu_control = SLT; //SLTI
                3'b011: alu_control = SLTU; //SLTIU
                3'b100: alu_control = XOR; //XORI
                3'b101: begin
                if (funct7 == 7'b0000000) alu_control = SRL; //SRLI
                else if (funct7 == 7'b0100000) alu_control = SRA; //SRAI
                end
                3'b110: alu_control = OR; //ORI
                3'b111: alu_control = AND; //ANDI
            endcase
            end
            7'b0110011: begin
            case(funct3)    //R Type
                3'b000: begin
                    if (funct7==7'b0000000) alu_control=ADD;
                    else if (funct7==7'b0100000) alu_control = SUB;
                end
                3'b001: alu_control=SLL;
                3'b010: alu_control=SLT;
                3'b011: alu_control= SLTU;
                3'b100: alu_control=XOR;
                3'b101: begin
                    if (funct7==7'b0000000) alu_control=SRL;
                    else if (funct7==7'b0100000) alu_control=SRA;
                end
                3'b110: alu_control=OR;
                3'b111: alu_control=AND;
            endcase
            end
            7'b0000011: alu_control=ADD; //Load
            7'b0100011: alu_control=ADD; //Store
            7'b0010111: alu_control=ADD; //AUIPC
            7'b0110111: alu_control=ADD; //LUI
            7'b1100111: alu_control=ADD; //JAL
            7'b1101111: alu_control=ADD; //JALR
            7'b1100011: begin
                case (funct3)
                    3'b000: alu_control=SUB;
                    3'b001: alu_control=SUB;
                    3'b100: alu_control=SLT;
                    3'b101: alu_control=SLT;
                    3'b110: alu_control=SLTU;
                    3'b111: alu_control=SLTU;
                endcase
            end
            
            default : alu_control=ADD;
        endcase
    end
    
endmodule
