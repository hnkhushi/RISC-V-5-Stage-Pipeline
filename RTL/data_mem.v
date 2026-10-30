`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2026 04:25:54 PM
// Design Name: 
// Module Name: data_mem
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


module data_mem(
    input clk,mem_read,mem_write,
    input [2:0] funct3,
    input [31:0] addr,write_data,
    output reg [31:0] read_data
    );
    reg [31:0] mem [0:1023];
    wire [9:0] word_index=addr[11:2];
    wire [1:0] byte_offset=addr[1:0];
    reg [31:0] word_data;
    wire addr_valid = (addr < 32'd4096);
    reg [7:0] byte_data;
    reg [15:0] half_data;
    
    
    always @(*) begin
        word_data = 32'b0;
        byte_data = 8'b0;
        half_data = 16'b0;
        read_data = 32'b0;
    if (mem_read&&addr_valid) begin
    word_data = mem[word_index];
        case(funct3)
            3'b000: begin   //LB
                case(byte_offset)
                    2'b00: byte_data=word_data[7:0];
                    2'b01: byte_data=word_data[15:8];
                    2'b10: byte_data=word_data[23:16];
                    2'b11: byte_data=word_data[31:24];
                    //default: byte_data=word_data[7:0];
                endcase
                read_data={{24{byte_data[7]}},byte_data};
            end
            3'b100: begin   //LBU
                case(byte_offset)
                    2'b00: byte_data=word_data[7:0];
                    2'b01: byte_data=word_data[15:8];
                    2'b10: byte_data=word_data[23:16];
                    2'b11: byte_data=word_data[31:24];
                    //default: byte_data=word_data[7:0];
                endcase
                read_data={24'b0,byte_data};
            end
            3'b001: begin   //LH
                case(byte_offset)
                    2'b00: half_data=word_data[15:0];
                    2'b10: half_data=word_data[31:16];
                    default: half_data=word_data[15:0];
                endcase
                read_data={{16{half_data[15]}},half_data};
            end
            3'b101: begin   //LHU
                case(byte_offset)
                    2'b00: half_data=word_data[15:0];
                    2'b10: half_data=word_data[31:16];
                    default: half_data=word_data[15:0];
                endcase
                read_data={16'b0,half_data};
            end
            3'b010: begin   //LW
                read_data=word_data;
            end
        endcase
    end
    end
    
    always @(posedge clk) begin
        if (mem_write&&addr_valid) begin
            case(funct3)
                3'b000: begin
                    case (byte_offset) 
                        2'b00: mem[word_index][7:0]<= write_data[7:0];
                        2'b01: mem[word_index][15:8]<=write_data[7:0];
                        2'b10: mem[word_index][23:16]<=write_data[7:0];
                        2'b11: mem[word_index][31:24]<=write_data[7:0];
                    endcase
                end
                3'b001: begin
                    case (byte_offset)
                        2'b00: mem[word_index][15:0] <= write_data[15:0];
                        2'b10: mem[word_index][31:16] <= write_data[15:0];
                        default: mem[word_index][15:0] <= write_data[15:0];
                    endcase
                end
                3'b010: begin
                if(byte_offset==2'b00)
                mem[word_index]<=write_data;
                end
            endcase
        end
    end
endmodule
