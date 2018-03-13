`timescale 1ns / 1ps

`include "Auxiliary.vh"

module TopLajiIntelKnightsLanding(clk, rst_n, resume, swt, seg_n, an_n);
    parameter ProgPath = "C:/.Xilinx/benchmark.hex";
    parameter CoreHighClkCnt = `CNT_MHZ(10);
    parameter CoreLowClkCnt = `CNT_HZ(1);
    parameter DispClkCnt = `CNT_KHZ(1);
    input clk;
    input rst_n;
    input resume;
    input [15:0] swt;
    output [7:0] seg_n;
    output [7:0] an_n;

    wire freq_op = swt[0];
    wire [2:0] mux_disp_data = swt[3:1];
    reg [31:0] disp_data;   // combinatorial
    wire clk_hi, clk_lo;
    wire core_clk = freq_op ? clk_lo : clk_hi;
    wire pe_resume;
    wire core_en;
    wire [4:0] regfile_req_dbg = swt[15:11];
    wire [31:0] datamem_addr_dbg = {24'd0, swt[15:6], 2'd0};
    wire [31:0] regfile_data_dbg;
    wire [31:0] datamem_data_dbg;
    wire [31:0] core_display;
    wire core_halt, core_is_jump, core_is_branch, core_branched;
    wire [31:0] cnt_cycle, cnt_jump, cnt_branch, cnt_branched;

    always @(*) begin
        case (mux_disp_data)
            `MUX_DISP_DATA_CORE:    disp_data <= core_display;
            `MUX_DISP_DATA_CNT_CYC: disp_data <= cnt_cycle;
            `MUX_DISP_DATA_CNT_JMP: disp_data <= cnt_jump;
            `MUX_DISP_DATA_CNT_BCH: disp_data <= cnt_branch;
            `MUX_DISP_DATA_CNT_BED: disp_data <= cnt_branched;
            `MUX_DISP_DATA_RF_DBG:  disp_data <= regfile_data_dbg;
            `MUX_DISP_DATA_DM_DBG:  disp_data <= datamem_data_dbg;
            default:                disp_data <= core_display;
        endcase
    end

    AuxDivider #(
        .CntMax(CoreHighClkCnt)
    ) vDivCoreHigh(
        .clk(clk),
        .rst_n(rst_n),
        .clk_out(clk_hi)
    );
    AuxDivider #(
        .CntMax(CoreLowClkCnt)
    ) vDivCoreLow(
        .clk(clk),
        .rst_n(rst_n),
        .clk_out(clk_lo)
    );
    AuxDisplay #(
        .ScanCntMax(DispClkCnt)
    ) vDisp(
        .clk(clk),
        .rst_n(rst_n),
        .data(disp_data),
        .seg_n(seg_n),
        .an_n(an_n)
    );
    AuxCounter #(
        .CntBit(32)
    ) vCtrCycle(
        .clk(clk),
        .rst_n(rst_n),
        .en(core_en),
        .ld(1'b0),
        .val(32'd0),
        .cnt(cnt_cycle)
    );
    AuxCounter #(
        .CntBit(32)
    ) vCtrJump(
        .clk(clk),
        .rst_n(rst_n),
        .en(core_is_jump),
        .ld(1'b0),
        .val(32'd0),
        .cnt(cnt_jump)
    );
    AuxCounter #(
        .CntBit(32)
    ) vCtrBranch(
        .clk(clk),
        .rst_n(rst_n),
        .en(core_is_branch),
        .ld(1'b0),
        .val(32'd0),
        .cnt(cnt_branch)
    );
    AuxCounter #(
        .CntBit(32)
    ) vCtrBranched(
        .clk(clk),
        .rst_n(rst_n),
        .en(core_branched),
        .ld(1'b0),
        .val(32'd0),
        .cnt(cnt_branched)
    );
    AuxEnabled vEnabled(
        .clk(core_clk),
        .rst_n(rst_n),
        .resume(resume),
        .halt(core_halt),
        .en(core_en)
    );
    SynLajiIntelKnightsLanding #(
        .ProgPath(ProgPath)
    ) vCore(
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
