`timescale 1ns / 1ps

`include "Auxiliary.vh"

module TopLajiIntelKnightsLanding(clk, rst_n, swt, seg_n, an_n);
    input clk;
    input rst_n;
    input [15:0] swt;
    output [7:0] seg_n;
    output [7:0] an_n;

    wire freq_op = swt[0];
    wire [2:0] disp_op = swt[3:1];
    wire clk_div;
    wire core_clk = freq_op ? clk : clk_div;
    wire core_en;
    wire [4:0] regfile_req_dbg = swt[15:11];
    wire [31:0] datamem_addr_dbg = {24'd0, swt[15:6], 2'd0};
    wire [31:0] regfile_data_dbg;
    wire [31:0] datamem_data_dbg;
    wire [31:0] core_display;
    wire core_halt, core_is_jump, core_is_branch, core_branched;
    wire [31:0] cnt_cycle, cnt_jump, cnt_branch, cnt_branched;

    AuxDivider #(
        .CntMax(`CNT_MILLISEC(500))
    ) vDivCore(
        .clk(clk),
        .rst_n(rst_n),
        .clk_out(clk_div)
    );
    AuxDisplay #(
        .ScanCntMax(`CNT_MILLISEC(1))
    ) vDisp(
        .clk(clk),
        .rst_n(rst_n),
        .op(disp_op),
        .core(core_display),
        .cnt_cycle(cnt_cycle),
        .cnt_jump(cnt_jump),
        .cnt_branch(cnt_branch),
        .cnt_branched(cnt_branched),
        .seg_n(seg_n),
        .an_n(an_n)
    );
    AuxCounter #(
        .CntBit(32)
    ) vCtrCycle(
        .clk(clk),
        .rst_n(rst_n),
        .en(core_en),
        .cnt(cnt_cycle)
    );
    AuxCounter #(
        .CntBit(32)
    ) vCtrJump(
        .clk(clk),
        .rst_n(rst_n),
        .en(core_is_jump),
        .cnt(cnt_jump)
    );
    AuxCounter #(
        .CntBit(32)
    ) vCtrBranch(
        .clk(clk),
        .rst_n(rst_n),
        .en(core_is_branch),
        .cnt(cnt_branch)
    );
    AuxCounter #(
        .CntBit(32)
    ) vCtrBranched(
        .clk(clk),
        .rst_n(rst_n),
        .en(core_branched),
        .cnt(cnt_branched)
    );
    SynLajiIntelKnightsLanding vCore(
        .clk(core_clk),
        .rst_n(rst_n),
        .en(core_en),
        .regfile_req_dbg(regfile_req_dbg),
        .datamem_addr_dbg(datamem_addr_dbg),
        .regfile_data_dbg(regfile_data_dbg),
        .datamem_data_dbg(datamem_data_dbg),
        .display(core_display),
        .halt(core_halt),
        .is_jump(core_is_jump),
        .is_branch(core_is_branch),
        .branched(core_branched)
    );
endmodule
