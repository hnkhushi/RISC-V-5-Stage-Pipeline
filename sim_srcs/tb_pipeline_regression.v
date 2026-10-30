`timescale 1ns/1ps
// Adapt hierarchical names here if your top module has been renamed.
module tb_pipeline_regression;
    reg clk = 0;
    reg rst = 1;
    rv32_pipeline_top dut (.clk(clk), .rst(rst));
    always #5 clk = ~clk;
    localparam NW=110, NS=18, NR=16;
    reg [4:0] exp_rd [0:NW-1];
    reg [31:0] exp_data [0:NW-1], exp_wpc [0:NW-1];
    reg [2:0] exp_sf [0:NS-1];
    reg [31:0] exp_sa [0:NS-1], exp_sd [0:NS-1];
    reg [31:0] exp_rpc [0:NR-1], exp_target [0:NR-1];
    integer cycles=0, wi=0, si=0, ri=0, stalls=0;
    integer finish_cycle=-1;
    reg redirect_now, stalled_now;
    reg [31:0] target_now, held_pc, held_instr, store_mask;
    reg held_valid;
    initial begin
        exp_rd[0]=5'd1; exp_data[0]=32'h00000040; exp_wpc[0]=32'h00000000;
        exp_rd[1]=5'd2; exp_data[1]=32'h00000015; exp_wpc[1]=32'h00000004;
        exp_rd[2]=5'd3; exp_data[2]=32'hfffffff9; exp_wpc[2]=32'h00000008;
        exp_rd[3]=5'd4; exp_data[3]=32'h0000002a; exp_wpc[3]=32'h0000000c;
        exp_rd[4]=5'd5; exp_data[4]=32'h00000015; exp_wpc[4]=32'h00000010;
        exp_rd[5]=5'd6; exp_data[5]=32'h0000003f; exp_wpc[5]=32'h00000014;
        exp_rd[6]=5'd7; exp_data[6]=32'h0000007e; exp_wpc[6]=32'h00000018;
        exp_rd[7]=5'd7; exp_data[7]=32'h0000007f; exp_wpc[7]=32'h0000001c;
        exp_rd[8]=5'd7; exp_data[8]=32'h00000081; exp_wpc[8]=32'h00000020;
        exp_rd[9]=5'd8; exp_data[9]=32'h00000096; exp_wpc[9]=32'h00000024;
        exp_rd[10]=5'd9; exp_data[10]=32'h0000004d; exp_wpc[10]=32'h00000028;
        exp_rd[11]=5'd10; exp_data[11]=32'h00000003; exp_wpc[11]=32'h0000002c;
        exp_rd[12]=5'd11; exp_data[12]=32'h00000004; exp_wpc[12]=32'h00000030;
        exp_rd[13]=5'd12; exp_data[13]=32'h00000062; exp_wpc[13]=32'h00000034;
        exp_rd[14]=5'd13; exp_data[14]=32'h00000015; exp_wpc[14]=32'h0000003c;
        exp_rd[15]=5'd14; exp_data[15]=32'h00000004; exp_wpc[15]=32'h00000040;
        exp_rd[16]=5'd15; exp_data[16]=32'hfffffff0; exp_wpc[16]=32'h00000044;
        exp_rd[17]=5'd16; exp_data[17]=32'h00000000; exp_wpc[17]=32'h00000048;
        exp_rd[18]=5'd16; exp_data[18]=32'hfffffff4; exp_wpc[18]=32'h0000004c;
        exp_rd[19]=5'd16; exp_data[19]=32'hfffffff4; exp_wpc[19]=32'h00000050;
        exp_rd[20]=5'd16; exp_data[20]=32'h00000001; exp_wpc[20]=32'h00000054;
        exp_rd[21]=5'd16; exp_data[21]=32'h00000000; exp_wpc[21]=32'h00000058;
        exp_rd[22]=5'd16; exp_data[22]=32'hffffff00; exp_wpc[22]=32'h0000005c;
        exp_rd[23]=5'd16; exp_data[23]=32'h0fffffff; exp_wpc[23]=32'h00000060;
        exp_rd[24]=5'd16; exp_data[24]=32'hffffffff; exp_wpc[24]=32'h00000064;
        exp_rd[25]=5'd17; exp_data[25]=32'h00000050; exp_wpc[25]=32'h00000068;
        exp_rd[26]=5'd17; exp_data[26]=32'hfffffff0; exp_wpc[26]=32'h0000006c;
        exp_rd[27]=5'd17; exp_data[27]=32'h0000000f; exp_wpc[27]=32'h00000070;
        exp_rd[28]=5'd17; exp_data[28]=32'h00000001; exp_wpc[28]=32'h00000074;
        exp_rd[29]=5'd17; exp_data[29]=32'h00000001; exp_wpc[29]=32'h00000078;
        exp_rd[30]=5'd17; exp_data[30]=32'hffffff80; exp_wpc[30]=32'h0000007c;
        exp_rd[31]=5'd17; exp_data[31]=32'h1ffffffe; exp_wpc[31]=32'h00000080;
        exp_rd[32]=5'd17; exp_data[32]=32'hfffffffe; exp_wpc[32]=32'h00000084;
        exp_rd[33]=5'd14; exp_data[33]=32'h0000001f; exp_wpc[33]=32'h00000088;
        exp_rd[34]=5'd18; exp_data[34]=32'h00000000; exp_wpc[34]=32'h0000008c;
        exp_rd[35]=5'd18; exp_data[35]=32'h00000001; exp_wpc[35]=32'h00000090;
        exp_rd[36]=5'd18; exp_data[36]=32'hffffffff; exp_wpc[36]=32'h00000094;
        exp_rd[37]=5'd14; exp_data[37]=32'h00000020; exp_wpc[37]=32'h00000098;
        exp_rd[38]=5'd18; exp_data[38]=32'h00000015; exp_wpc[38]=32'h0000009c;
        exp_rd[39]=5'd19; exp_data[39]=32'h80000000; exp_wpc[39]=32'h000000a0;
        exp_rd[40]=5'd19; exp_data[40]=32'h7fffffff; exp_wpc[40]=32'h000000a4;
        exp_rd[41]=5'd19; exp_data[41]=32'h80000000; exp_wpc[41]=32'h000000a8;
        exp_rd[42]=5'd20; exp_data[42]=32'h000010ac; exp_wpc[42]=32'h000000ac;
        exp_rd[43]=5'd21; exp_data[43]=32'h00000015; exp_wpc[43]=32'h000000b4;
        exp_rd[44]=5'd22; exp_data[44]=32'h0000002a; exp_wpc[44]=32'h000000b8;
        exp_rd[45]=5'd21; exp_data[45]=32'h00000015; exp_wpc[45]=32'h000000bc;
        exp_rd[46]=5'd22; exp_data[46]=32'h00000000; exp_wpc[46]=32'h000000c0;
        exp_rd[47]=5'd21; exp_data[47]=32'h00000015; exp_wpc[47]=32'h000000c4;
        exp_rd[48]=5'd22; exp_data[48]=32'h00000015; exp_wpc[48]=32'h000000cc;
        exp_rd[49]=5'd23; exp_data[49]=32'h00000040; exp_wpc[49]=32'h000000d0;
        exp_rd[50]=5'd24; exp_data[50]=32'h00000040; exp_wpc[50]=32'h000000d8;
        exp_rd[51]=5'd25; exp_data[51]=32'h00000015; exp_wpc[51]=32'h000000dc;
        exp_rd[52]=5'd26; exp_data[52]=32'h00000015; exp_wpc[52]=32'h000000e4;
        exp_rd[53]=5'd21; exp_data[53]=32'h00000015; exp_wpc[53]=32'h000000e8;
        exp_rd[54]=5'd27; exp_data[54]=32'h00000009; exp_wpc[54]=32'h000000ec;
        exp_rd[55]=5'd22; exp_data[55]=32'h0000001e; exp_wpc[55]=32'h000000f0;
        exp_rd[56]=5'd23; exp_data[56]=32'h80ff8000; exp_wpc[56]=32'h000000f4;
        exp_rd[57]=5'd23; exp_data[57]=32'h80ff7f01; exp_wpc[57]=32'h000000f8;
        exp_rd[58]=5'd24; exp_data[58]=32'h00000001; exp_wpc[58]=32'h00000100;
        exp_rd[59]=5'd25; exp_data[59]=32'h00000001; exp_wpc[59]=32'h00000104;
        exp_rd[60]=5'd24; exp_data[60]=32'h0000007f; exp_wpc[60]=32'h00000108;
        exp_rd[61]=5'd25; exp_data[61]=32'h0000007f; exp_wpc[61]=32'h0000010c;
        exp_rd[62]=5'd24; exp_data[62]=32'hffffffff; exp_wpc[62]=32'h00000110;
        exp_rd[63]=5'd25; exp_data[63]=32'h000000ff; exp_wpc[63]=32'h00000114;
        exp_rd[64]=5'd24; exp_data[64]=32'hffffff80; exp_wpc[64]=32'h00000118;
        exp_rd[65]=5'd25; exp_data[65]=32'h00000080; exp_wpc[65]=32'h0000011c;
        exp_rd[66]=5'd24; exp_data[66]=32'h00007f01; exp_wpc[66]=32'h00000120;
        exp_rd[67]=5'd25; exp_data[67]=32'h00007f01; exp_wpc[67]=32'h00000124;
        exp_rd[68]=5'd24; exp_data[68]=32'hffff80ff; exp_wpc[68]=32'h00000128;
        exp_rd[69]=5'd25; exp_data[69]=32'h000080ff; exp_wpc[69]=32'h0000012c;
        exp_rd[70]=5'd23; exp_data[70]=32'hffffffff; exp_wpc[70]=32'h00000130;
        exp_rd[71]=5'd24; exp_data[71]=32'h80ffff01; exp_wpc[71]=32'h00000138;
        exp_rd[72]=5'd23; exp_data[72]=32'h00000123; exp_wpc[72]=32'h0000013c;
        exp_rd[73]=5'd24; exp_data[73]=32'h0123ff01; exp_wpc[73]=32'h00000144;
        exp_rd[74]=5'd23; exp_data[74]=32'h00000055; exp_wpc[74]=32'h00000148;
        exp_rd[75]=5'd24; exp_data[75]=32'h0123ff55; exp_wpc[75]=32'h00000150;
        exp_rd[76]=5'd10; exp_data[76]=32'hffffffff; exp_wpc[76]=32'h00000154;
        exp_rd[77]=5'd11; exp_data[77]=32'h00000001; exp_wpc[77]=32'h00000158;
        exp_rd[78]=5'd12; exp_data[78]=32'h00000001; exp_wpc[78]=32'h0000015c;
        exp_rd[79]=5'd24; exp_data[79]=32'h00000000; exp_wpc[79]=32'h00000160;
        exp_rd[80]=5'd24; exp_data[80]=32'h00000001; exp_wpc[80]=32'h00000174;
        exp_rd[81]=5'd24; exp_data[81]=32'h00000002; exp_wpc[81]=32'h0000018c;
        exp_rd[82]=5'd24; exp_data[82]=32'h00000003; exp_wpc[82]=32'h000001a4;
        exp_rd[83]=5'd24; exp_data[83]=32'h00000004; exp_wpc[83]=32'h000001bc;
        exp_rd[84]=5'd24; exp_data[84]=32'h00000005; exp_wpc[84]=32'h000001d4;
        exp_rd[85]=5'd24; exp_data[85]=32'h00000006; exp_wpc[85]=32'h000001ec;
        exp_rd[86]=5'd24; exp_data[86]=32'h00000007; exp_wpc[86]=32'h000001f8;
        exp_rd[87]=5'd24; exp_data[87]=32'h00000008; exp_wpc[87]=32'h00000210;
        exp_rd[88]=5'd26; exp_data[88]=32'h00000004; exp_wpc[88]=32'h00000224;
        exp_rd[89]=5'd27; exp_data[89]=32'h00000000; exp_wpc[89]=32'h00000228;
        exp_rd[90]=5'd27; exp_data[90]=32'h00000003; exp_wpc[90]=32'h0000022c;
        exp_rd[91]=5'd26; exp_data[91]=32'h00000003; exp_wpc[91]=32'h00000230;
        exp_rd[92]=5'd27; exp_data[92]=32'h00000006; exp_wpc[92]=32'h0000022c;
        exp_rd[93]=5'd26; exp_data[93]=32'h00000002; exp_wpc[93]=32'h00000230;
        exp_rd[94]=5'd27; exp_data[94]=32'h00000009; exp_wpc[94]=32'h0000022c;
        exp_rd[95]=5'd26; exp_data[95]=32'h00000001; exp_wpc[95]=32'h00000230;
        exp_rd[96]=5'd27; exp_data[96]=32'h0000000c; exp_wpc[96]=32'h0000022c;
        exp_rd[97]=5'd26; exp_data[97]=32'h00000000; exp_wpc[97]=32'h00000230;
        exp_rd[98]=5'd16; exp_data[98]=32'h00000015; exp_wpc[98]=32'h0000023c;
        exp_rd[99]=5'd5; exp_data[99]=32'h0000025c; exp_wpc[99]=32'h00000258;
        exp_rd[100]=5'd6; exp_data[100]=32'h0000025d; exp_wpc[100]=32'h00000264;
        exp_rd[101]=5'd7; exp_data[101]=32'h00000279; exp_wpc[101]=32'h00000268;
        exp_rd[102]=5'd8; exp_data[102]=32'h00000270; exp_wpc[102]=32'h0000026c;
        exp_rd[103]=5'd9; exp_data[103]=32'h00000271; exp_wpc[103]=32'h00000278;
        exp_rd[104]=5'd7; exp_data[104]=32'h00000295; exp_wpc[104]=32'h0000027c;
        exp_rd[105]=5'd7; exp_data[105]=32'h00000295; exp_wpc[105]=32'h00000284;
        exp_rd[106]=5'd8; exp_data[106]=32'h0000028c; exp_wpc[106]=32'h00000288;
        exp_rd[107]=5'd9; exp_data[107]=32'h0000028e; exp_wpc[107]=32'h00000294;
        exp_rd[108]=5'd28; exp_data[108]=32'h0000028e; exp_wpc[108]=32'h0000029c;
        exp_rd[109]=5'd31; exp_data[109]=32'h00000001; exp_wpc[109]=32'h000002a0;
        exp_sf[0]=3'd2; exp_sa[0]=32'h00000040; exp_sd[0]=32'h00000015;
        exp_sf[1]=3'd2; exp_sa[1]=32'h00000044; exp_sd[1]=32'h00000015;
        exp_sf[2]=3'd2; exp_sa[2]=32'h00000048; exp_sd[2]=32'h00000040;
        exp_sf[3]=3'd2; exp_sa[3]=32'h0000004c; exp_sd[3]=32'h80ff7f01;
        exp_sf[4]=3'd0; exp_sa[4]=32'h0000004d; exp_sd[4]=32'h000000ff;
        exp_sf[5]=3'd1; exp_sa[5]=32'h0000004e; exp_sd[5]=32'h00000123;
        exp_sf[6]=3'd0; exp_sa[6]=32'h0000004c; exp_sd[6]=32'h00000055;
        exp_sf[7]=3'd2; exp_sa[7]=32'h00000050; exp_sd[7]=32'h00000001;
        exp_sf[8]=3'd2; exp_sa[8]=32'h00000050; exp_sd[8]=32'h00000002;
        exp_sf[9]=3'd2; exp_sa[9]=32'h00000050; exp_sd[9]=32'h00000003;
        exp_sf[10]=3'd2; exp_sa[10]=32'h00000050; exp_sd[10]=32'h00000004;
        exp_sf[11]=3'd2; exp_sa[11]=32'h00000050; exp_sd[11]=32'h00000005;
        exp_sf[12]=3'd2; exp_sa[12]=32'h00000050; exp_sd[12]=32'h00000006;
        exp_sf[13]=3'd2; exp_sa[13]=32'h00000050; exp_sd[13]=32'h00000007;
        exp_sf[14]=3'd2; exp_sa[14]=32'h00000050; exp_sd[14]=32'h00000008;
        exp_sf[15]=3'd2; exp_sa[15]=32'h00000054; exp_sd[15]=32'h0000000c;
        exp_sf[16]=3'd2; exp_sa[16]=32'h00000058; exp_sd[16]=32'h00000295;
        exp_sf[17]=3'd2; exp_sa[17]=32'h00000058; exp_sd[17]=32'h0000028e;
        exp_rpc[0]=32'h00000164; exp_target[0]=32'h00000170;
        exp_rpc[1]=32'h0000017c; exp_target[1]=32'h00000188;
        exp_rpc[2]=32'h00000194; exp_target[2]=32'h000001a0;
        exp_rpc[3]=32'h000001ac; exp_target[3]=32'h000001b8;
        exp_rpc[4]=32'h000001c4; exp_target[4]=32'h000001d0;
        exp_rpc[5]=32'h000001dc; exp_target[5]=32'h000001e8;
        exp_rpc[6]=32'h00000200; exp_target[6]=32'h0000020c;
        exp_rpc[7]=32'h00000218; exp_target[7]=32'h00000224;
        exp_rpc[8]=32'h00000234; exp_target[8]=32'h0000022c;
        exp_rpc[9]=32'h00000234; exp_target[9]=32'h0000022c;
        exp_rpc[10]=32'h00000234; exp_target[10]=32'h0000022c;
        exp_rpc[11]=32'h00000240; exp_target[11]=32'h0000024c;
        exp_rpc[12]=32'h0000024c; exp_target[12]=32'h00000258;
        exp_rpc[13]=32'h00000258; exp_target[13]=32'h00000264;
        exp_rpc[14]=32'h0000026c; exp_target[14]=32'h00000278;
        exp_rpc[15]=32'h00000288; exp_target[15]=32'h00000294;
        repeat (2) @(negedge clk);
        rst=0;
    end
    task fail;
        input [8*180-1:0] reason;
        begin
            $display("FAIL at cycle %0d: %0s", cycles, reason);
            $display("EX: pc=%h valid=%b opcode=%h rd=x%0d stall=%b flush=%b",
                     dut.pc_ex,dut.valid_ex,dut.opcode_ex,dut.rd_addr_ex,dut.stall,dut.flush);
            $display("MEM: valid=%b rd=x%0d | WB: valid=%b en=%b rd=x%0d data=%h",
                     dut.valid_mem,dut.rd_addr_mem,dut.valid_wb,dut.wb_reg_write,
                     dut.wb_rd_addr,dut.wb_data);
            $finish;
        end
    endtask
    // Pre-NBA sampling observes the enables consumed at this rising edge.
    // This assumes positive-edge register-file and data-memory writes.
    always @(posedge clk) begin
        if (!rst) begin
            cycles=cycles+1;
            if ((dut.stall !== 1'b0) && (dut.stall !== 1'b1)) fail("stall is unknown");
            redirect_now=dut.valid_ex && (dut.branch_taken || dut.jump_taken);
            if ((redirect_now !== 1'b0) && (redirect_now !== 1'b1)) fail("redirect is unknown");
            if (dut.flush !== redirect_now) fail("flush differs from valid EX redirect");
            stalled_now=dut.stall && !redirect_now;
            held_pc=dut.pc; held_instr=dut.instr_id; held_valid=dut.valid_id;
            if (dut.stall) stalls=stalls+1;
            if (redirect_now) begin
                if (ri>=NR) fail("extra redirect");
                if (dut.pc_ex !== exp_rpc[ri]) begin
                    $display("Expected redirect from PC=%h; observed PC=%h",exp_rpc[ri],dut.pc_ex);
                    fail("redirect sequence mismatch (earlier branch may have been missed)");
                end
                target_now=exp_target[ri]; ri=ri+1;
            end
            if ((dut.wb_reg_write !== 1'b0) && (dut.wb_reg_write !== 1'b1)) fail("WB enable is unknown");
            if (dut.wb_reg_write) begin
                if (dut.valid_wb !== 1'b1) fail("invalid instruction enabled register write");
                if ((^dut.wb_rd_addr) === 1'bx) fail("WB destination is unknown");
                if (dut.wb_rd_addr!=0) begin
                    if (wi>=NW) fail("extra register write");
                    if (dut.wb_rd_addr !== exp_rd[wi] || dut.wb_data !== exp_data[wi]) begin
                        $display("WB[%0d] expected instruction PC=%h: x%0d=%h; observed x%0d=%h",
                                 wi,exp_wpc[wi],exp_rd[wi],exp_data[wi],dut.wb_rd_addr,dut.wb_data);
                        fail("register-write sequence/data mismatch");
                    end
                    $display("WB[%0d] x%0d=%h (expected instruction PC=%h)",wi,dut.wb_rd_addr,dut.wb_data,exp_wpc[wi]);
                    wi=wi+1;
                    if (dut.wb_rd_addr==31) finish_cycle=cycles;
                end
            end
            // Inspect actual memory port to catch invalid stores even when
            // a raw control bit remains high in an invalid pipeline entry.
            if ((dut.data_mem.mem_write !== 1'b0) && (dut.data_mem.mem_write !== 1'b1)) fail("memory write enable is unknown");
            if (dut.data_mem.mem_write) begin
                if (dut.valid_mem !== 1'b1) fail("invalid instruction enabled store");
                if (si>=NS) fail("extra/wrong-path store");
                case (exp_sf[si])
                    0: store_mask=32'h000000ff;
                    1: store_mask=32'h0000ffff;
                    2: store_mask=32'hffffffff;
                    default: store_mask=0;
                endcase
                if (dut.data_mem.funct3 !== exp_sf[si] ||
                    dut.data_mem.addr !== exp_sa[si] ||
                    (dut.data_mem.write_data & store_mask) !== exp_sd[si]) begin
                    $display("STORE[%0d] expected funct3=%h addr=%h data(masked)=%h",
                             si,exp_sf[si],exp_sa[si],exp_sd[si]);
                    $display("Observed funct3=%h addr=%h data=%h",dut.data_mem.funct3,dut.data_mem.addr,dut.data_mem.write_data);
                    fail("store sequence/address/data mismatch");
                end
                si=si+1;
            end
            #1;
            if (redirect_now) begin
                if (dut.pc !== target_now) begin
                    $display("Expected PC=%h observed=%h",target_now,dut.pc);
                    fail("redirect target mismatch");
                end
                if (dut.valid_id !== 1'b0 || dut.valid_ex !== 1'b0) fail("redirect did not invalidate both younger pipeline entries");
            end else if (stalled_now) begin
                if (dut.pc !== held_pc || dut.instr_id !== held_instr || dut.valid_id !== held_valid)
                    fail("stall did not hold PC and IF/ID instruction/valid");
                if (dut.valid_ex !== 1'b0) fail("stall did not insert ID/EX bubble");
            end
            if (finish_cycle>=0 && cycles>=finish_cycle+4) begin
                if (wi!=NW || si!=NS || ri!=NR) begin
                    $display("Counts: WB %0d/%0d stores %0d/%0d redirects %0d/%0d",wi,NW,si,NS,ri,NR);
                    fail("completion occurred with missing architectural events");
                end
                if (stalls==0) fail("load-use test observed no stalls");
                $display("PASS: pipeline regression passed. WB=%0d stores=%0d redirects=%0d stalls=%0d cycles_to_completion=%0d",
                         wi,si,ri,stalls,finish_cycle);
                $finish;
            end
            if (cycles>=3000) fail("timeout: missing completion marker or control-flow error");
        end
    end
endmodule
