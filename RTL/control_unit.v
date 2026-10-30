`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/22/2026 07:44:42 PM
// Design Name: 
// Module Name: control_unit
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

// wb_src 00-ALU 01-MEM 10-PC+4
module control_unit(
    input [6:0] opcode,
    input [2:0] funct3,
    output reg reg_write,mem_read,mem_write,branch,jump,jalr,rs1_used,rs2_used,
    output reg [1:0] alua_src,alub_src,wb_src,
    output reg [2:0] imm_type
    );
    always @ (*) begin
        case (opcode)
            7'b0110011: begin //R type
                reg_write=1'b1;
                mem_read=1'b0;
                mem_write=1'b0;
                alua_src=2'b00; //rs1
                alub_src=2'b00; //rs2
                wb_src=2'b00; //ALU
                branch=1'b0;
                jump=1'b0;
                jalr=1'b0;
                imm_type=3'b0;
                rs1_used=1'b1;
                rs2_used=1'b1;
            end
            7'b0010011: begin // I type
                reg_write=1'b1;
                mem_read=1'b0;
                mem_write=1'b0;
                alua_src=2'b00; //rs1
                alub_src=2'b01; //immediate
                wb_src=2'b00; //ALU
                branch=1'b0;
                jump=1'b0;
                jalr=1'b0;
                imm_type=3'b001;
                rs1_used=1'b1;
                rs2_used=1'b0;
            end
            7'b0000011: begin // Load type
                reg_write=1'b1;
                mem_read=1'b1;
                mem_write=1'b0;
                alua_src=2'b00; //rs1
                alub_src=2'b01; //immediate 
                wb_src=2'b01; //MEM               
                branch=1'b0;
                jump=1'b0;
                jalr=1'b0;
                imm_type=3'b001;
                rs1_used=1'b1;
                rs2_used=1'b0;
            end
            7'b0100011: begin // Store type
                reg_write=1'b0;
                mem_read=1'b0;
                mem_write=1'b1;
                alua_src=2'b00; //rs1
                alub_src=2'b01; //immediate
                wb_src=2'b00; //ALU
                branch=1'b0;
                jump=1'b0;
                jalr=1'b0;
                imm_type=3'b010;
                rs1_used=1'b1;
                rs2_used=1'b1;
            end
            7'b1100011: begin // Branch type
                reg_write=1'b0;
                mem_read=1'b0;
                mem_write=1'b0;
                alua_src=2'b00; //rs1
                alub_src=2'b00; //rs2
                wb_src=2'b00; //ALU
                branch=1'b1;
                jump=1'b0;
                jalr=1'b0;
                imm_type=3'b011;
                rs1_used=1'b1;
                rs2_used=1'b1;
            end
            7'b1101111: begin // JAL type
                reg_write=1'b1;
                mem_read=1'b0;
                mem_write=1'b0;
                alua_src=2'b01; //PC
                alub_src=2'b01; //Immediate
                wb_src=2'b10; //PC+4
                branch=1'b0;
                jump=1'b1;
                jalr=1'b0;
                imm_type=3'b101;
                rs1_used=1'b0;
                rs2_used=1'b0;
            end
            7'b1100111: begin // JALR type
                reg_write=1'b1;
                mem_read=1'b0;
                mem_write=1'b0;
                alua_src=2'b00; //rs1 **
                alub_src=2'b01; //Immediate
                wb_src=2'b10; //PC+4
                branch=1'b0;
                jump=1'b1;
                jalr=1'b1;
                imm_type=3'b001;
                rs1_used=1'b1;
                rs2_used=1'b0;
            end
            7'b0110111: begin // LUI type
                reg_write=1'b1;
                mem_read=1'b0;
                mem_write=1'b0;
                alua_src=2'b10; //zero
                alub_src=2'b01; //Immediate
                wb_src=2'b00; //ALU
                branch=1'b0;
                jump=1'b0;
                jalr=1'b0;
                imm_type=3'b100;
                rs1_used=1'b0;
                rs2_used=1'b0;
            end
            7'b0010111 : begin //AUIPC
                reg_write = 1'b1;
                mem_write = 1'b0;
                mem_read = 1'b0;
                branch = 1'b0;
                jump = 1'b0;
                alua_src = 2'b01;//PC
                alub_src = 2'b01;//immediate
                wb_src = 2'b00;//ALU
                jalr=1'b0;
                imm_type=3'b100;
                rs1_used=1'b0;
                rs2_used=1'b0;
            end 
            default: begin
                reg_write = 1'b0;
                mem_write = 1'b0;
                mem_read = 1'b0;
                branch = 1'b0;
                jump = 1'b0;
                alua_src = 2'b00;
                alub_src = 2'b00;
                wb_src = 2'b00;
                jalr=1'b0;
                imm_type=3'b000;
                rs1_used=1'b0;
                rs2_used=1'b0;
            end    
        endcase
    end
endmodule
