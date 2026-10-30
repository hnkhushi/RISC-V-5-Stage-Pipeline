`timescale 1ns/1ps

module tb_load_use;

    reg clk;
    reg rst;

    wire [31:0] debug_pc;
    wire [31:0] debug_instr;
    wire if_valid;
    wire valid_id;

    wire [6:0] opcode_ex;
    wire [6:0] funct7_ex;
    wire [2:0] funct3_ex;
    wire [4:0] rs1_addr_ex;
    wire [4:0] rs2_addr_ex;
    wire [4:0] rd_addr_ex;
    wire [31:0] alu_result_ex;

    integer cycles;
    integer stall_count;
    integer failures;

    reg seen_x5, seen_x6, seen_x7, seen_x8;
    reg seen_x9, seen_x10, seen_x11, seen_x12;

    rv32_pipeline_top dut (
        .clk(clk),
        .rst(rst),
        .debug_pc(debug_pc),
        .debug_instr(debug_instr),
        .if_valid(if_valid),
        .valid_id(valid_id),
        .opcode_ex(opcode_ex),
        .funct7_ex(funct7_ex),
        .funct3_ex(funct3_ex),
        .rs1_addr_ex(rs1_addr_ex),
        .rs2_addr_ex(rs2_addr_ex),
        .rd_addr_ex(rd_addr_ex),
        .alu_result_ex(alu_result_ex)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;

        cycles = 0;
        stall_count = 0;
        failures = 0;

        seen_x5  = 0;
        seen_x6  = 0;
        seen_x7  = 0;
        seen_x8  = 0;
        seen_x9  = 0;
        seen_x10 = 0;
        seen_x11 = 0;
        seen_x12 = 0;

        repeat (2) @(negedge clk);
        rst = 0;

        repeat (50) begin
            @(negedge clk);
            cycles = cycles + 1;

            $display(
                "Cycle=%0d PC=%08h Instr=%08h stall=%b",
                cycles, debug_pc, debug_instr, dut.stall
            );
            
            $display(
    "EX valid=%b opcode=%h rs1=x%0d rs2=x%0d rd=x%0d | fwdA=%h fwdB=%h ALU=%h | MEM rd=x%0d load=%b | WB valid=%b write=%b rd=x%0d data=%h",
    dut.valid_ex,
    dut.opcode_ex,
    dut.rs1_addr_ex,
    dut.rs2_addr_ex,
    dut.rd_addr_ex,
    dut.forwarded_a,
    dut.forwarded_b,
    dut.alu_result_ex,
    dut.rd_addr_mem,
    dut.mem_read_mem,
    dut.valid_wb,
    dut.wb_reg_write,
    dut.wb_rd_addr,
    dut.wb_data
);

$display(
    "PIPELINE: EX(valid=%b rd=x%0d regwrite=%b) | MEM(valid=%b rd=x%0d regwrite=%b memread=%b memdata=%h) | WB(valid=%b rd=x%0d regwrite=%b wb_src=%b alu=%h memdata=%h wb_data=%h)",
    dut.valid_ex,
    dut.rd_addr_ex,
    dut.reg_write_ex,

    dut.valid_mem,
    dut.rd_addr_mem,
    dut.reg_write_mem,
    dut.mem_read_mem,
    dut.read_data_mem,

    dut.valid_wb,
    dut.wb_rd_addr,
    dut.reg_write_wb,
    dut.wb_src_wb,
    dut.alu_result_wb,
    dut.read_data_wb,
    dut.wb_data
);

            if (dut.stall) begin
                stall_count = stall_count + 1;
                $display(
                    "  STALL: EX rd=x%0d, ID rs1=x%0d, ID rs2=x%0d",
                    dut.rd_addr_ex,
                    dut.rs1_addr_id,
                    dut.rs2_addr_id
                );
            end

            if (dut.wb_reg_write && dut.valid_wb) begin
                $display(
                    "  WB: x%0d = %08h",
                    dut.wb_rd_addr, dut.wb_data
                );

                case (dut.wb_rd_addr)
                    5: begin
                        if (dut.wb_data !== 32'd21) begin
                            $display("FAIL: x5 expected 21");
                            failures = failures + 1;
                        end
                        seen_x5 = 1;
                    end

                    6: begin
                        if (dut.wb_data !== 32'd42) begin
                            $display("FAIL: x6 expected 42");
                            failures = failures + 1;
                        end
                        seen_x6 = 1;
                    end

                    7: begin
                        if (dut.wb_data !== 32'd0) begin
                            $display("FAIL: x7 expected 0");
                            failures = failures + 1;
                        end
                        seen_x7 = 1;
                    end

                    8: begin
                        if (dut.wb_data !== 32'd21) begin
                            $display("FAIL: x8 expected 21");
                            failures = failures + 1;
                        end
                        seen_x8 = 1;
                    end

                    9: begin
                        if (dut.wb_data !== 32'd7) begin
                            $display("FAIL: x9 expected 7");
                            failures = failures + 1;
                        end
                        seen_x9 = 1;
                    end

                    10: begin
                        if (dut.wb_data !== 32'd28) begin
                            $display("FAIL: x10 expected 28");
                            failures = failures + 1;
                        end
                        seen_x10 = 1;
                    end

                    11: begin
                        if (dut.wb_data !== 32'd21) begin
                            $display("FAIL: x11 expected 21");
                            failures = failures + 1;
                        end
                        seen_x11 = 1;
                    end

                    12: begin
                        if (dut.wb_data !== 32'd42) begin
                            $display("FAIL: x12 expected 42");
                            failures = failures + 1;
                        end
                        seen_x12 = 1;
                    end
                endcase
            end
        end

        if (!seen_x5 || !seen_x6 || !seen_x7 || !seen_x8 ||
            !seen_x9 || !seen_x10 || !seen_x11 || !seen_x12) begin
            $display("FAIL: Missing expected register write(s)");
            failures = failures + 1;
        end

        if (stall_count < 2) begin
            $display(
                "FAIL: Expected at least 2 stall cycles, got %0d",
                stall_count
            );
            failures = failures + 1;
        end

        if (failures == 0)
            $display("PASS: Load-use hazard test passed.");
        else
            $display("FAIL: %0d error(s)", failures);

        $finish;
    end

endmodule