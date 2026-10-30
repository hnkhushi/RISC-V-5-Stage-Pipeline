`timescale 1ns/1ps
module tb_bubble_sort;
    reg clk=0;
    reg rst=1;
    rv32_pipeline_top dut (.clk(clk),.rst(rst));
    always #5 clk=~clk;
    reg [31:0] expected [0:7];
    reg [31:0] shadow [0:7];
    reg [7:0] initialized=0;
    reg [7:0] readback_seen=0;
    reg flag_cleared=0, completed=0;
    integer cycles=0, stalls=0, redirects=0, retired=0, stores=0;
    integer comparisons=0, index, j;
    reg [31:0] address;
    reg [31:0] data;
    initial begin
        expected[0]=-18; expected[1]=-5; expected[2]=0; expected[3]=3;
        expected[4]=7; expected[5]=12; expected[6]=23; expected[7]=45;
        $display("INPUT: 23, -5, 12, 0, 45, -18, 7, 3");
        repeat (2) @(negedge clk);
        rst=0;
    end
    task fail;
        input [8*160-1:0] reason;
        begin
            $display("FAIL cycle %0d: %0s",cycles,reason);
            $display("EX pc=%h valid=%b stall=%b flush=%b WB rd=x%0d data=%h",
                     dut.pc_ex,dut.valid_ex,dut.stall,dut.flush,dut.wb_rd_addr,dut.wb_data);
            $finish;
        end
    endtask
    // Observe the actual enables/data consumed at a rising edge, before NBA.
    // shadow is a mirror of DUT stores, not a replacement for DUT memory.
    always @(posedge clk) begin
        if (!rst) begin
            cycles=cycles+1;
            if (dut.stall === 1'b1) stalls=stalls+1;
            if (dut.valid_wb === 1'b1) retired=retired+1;
            // Exclude the final permanent halt loop from application statistics.
            if (dut.valid_ex && dut.pc_ex != 168 &&
                (dut.branch_taken || dut.jump_taken)) redirects=redirects+1;
            // A load-use stall holds the branch in ID, not EX. Count each
            // valid comparison once when it reaches EX.
            if (dut.valid_ex && dut.pc_ex == 92) comparisons=comparisons+1;
            if ((dut.data_mem.mem_write !== 1'b0) &&
                (dut.data_mem.mem_write !== 1'b1)) fail("unknown memory write enable");
            if (dut.data_mem.mem_write) begin
                if (dut.valid_mem !== 1'b1) fail("invalid instruction attempted a store");
                if (dut.data_mem.funct3 !== 3'b010) fail("unexpected non-word store");
                address=dut.data_mem.addr; data=dut.data_mem.write_data;
                if ((^address) === 1'bx || (^data) === 1'bx) fail("unknown store address/data");
                stores=stores+1;
                if (address>=64 && address<=92 && address[1:0]==0) begin
                    if (completed) fail("array modified after completion flag");
                    index=(address-64)/4;
                    shadow[index]=data;
                    initialized[index]=1'b1;
                end else if (address==96) begin
                    if (data==0) begin
                        if (flag_cleared || initialized!=0) fail("unexpected completion-flag clear");
                        flag_cleared=1;
                    end else if (data==1) begin
                        if (!flag_cleared || completed || initialized!==8'hff)
                            fail("invalid completion sequence");
                        for (j=0;j<8;j=j+1)
                            if (shadow[j] !== expected[j]) begin
                                $display("Array[%0d] expected=%0d observed=%0d",j,$signed(expected[j]),$signed(shadow[j]));
                                fail("sorted store image mismatch");
                            end
                        if (readback_seen!==8'hff) fail("completion flag preceded all sorted readbacks");
                        completed=1;
                        $display("Completion flag written at byte address 96");
                    end else fail("unexpected completion flag value");
                end else fail("store outside array/completion flag");
            end
            if ((dut.wb_reg_write !== 1'b0) &&
                (dut.wb_reg_write !== 1'b1)) fail("unknown WB enable");
            if (dut.wb_reg_write) begin
                if (dut.valid_wb !== 1'b1) fail("invalid register write");
                // Only the final sorted-array loads use x10..x17.
                if (dut.wb_rd_addr>=10 && dut.wb_rd_addr<=17) begin
                    index=dut.wb_rd_addr-10;
                    if (readback_seen[index]) fail("duplicate sorted readback");
                    if (dut.wb_data !== expected[index]) begin
                        $display("Readback[%0d] expected=%0d observed=%0d",index,
                                 $signed(expected[index]),$signed(dut.wb_data));
                        fail("actual memory readback mismatch");
                    end
                    readback_seen[index]=1;
                    $display("RESULT[%0d] address=%0d value=%0d",index,64+index*4,$signed(dut.wb_data));
                end
                if (dut.wb_rd_addr==31) begin
                    if (dut.wb_data!==32'd1 || !completed || readback_seen!==8'hff)
                        fail("invalid final marker or incomplete results");
                    if (retired!=258 || stores!=42 || redirects!=39 || comparisons!=28) begin
                        $display("Observed: retired=%0d stores=%0d redirects=%0d comparisons=%0d",retired,stores,redirects,comparisons);
                        fail("application event count mismatch");
                    end
                    if (stalls==0) fail("expected load-to-branch stalls were absent");
                    $display("OUTPUT: -18, -5, 0, 3, 7, 12, 23, 45");
                    $display("PASS: signed bubble sort completed correctly");
                    $display("Cycles to marker=%0d, retired=%0d, stalls=%0d, redirects=%0d",cycles,retired,stalls,redirects);
                    $display("Comparisons=28 swaps=16 stores=%0d CPI=%0.3f",stores,$itor(cycles)/$itor(retired));
                    $finish;
                end
            end
            if (cycles>=5000) fail("timeout waiting for bubble-sort completion");
        end
    end
endmodule
