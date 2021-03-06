`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Instruction Decoding Stage, pipelined
// Author: EAirPeter
module PstID(
    clk, rst_n, en,
    dbg_rf_req, irq_src, inst,
    prv_ctl_rf_we, prv_val_rf_req_w, prv_val_rf_data_w,
    prv_ctl_rc0_op, prv_ctl_rc0_ie_we, prv_ctl_rc0_epc_we,
    prv_val_rc0_ie_w, prv_val_rc0_epc_w,
    dbg_rf_data,
    shamt, imm16, rf_data_a, rf_data_b,
    rc0_ir, rc0_ie, rc0_epc, rc0_ivld, rc0_inum,
    ctl_rf_ra, ctl_rf_rb, ctl_rf_we,
    ctl_rc0_op, ctl_rc0_ie_we, ctl_rc0_epc_we,
    ctl_alu_op, ctl_wtg_op,
    ctl_syscall_en, ctl_dm_op, ctl_dm_we,
    val_rf_req_w, val_rf_req_a, val_rf_req_b, mux_rf_data_w,
    sel_rc0_epc, mux_rc0_ie_w, mux_rc0_epc_w,
    mux_alu_data_y,
    is_jump, is_branch
);
    input clk, rst_n, en;
    input [4:0] dbg_rf_req;
    input [`NIRQ - 1:0] irq_src;
    input [31:0] inst;
    input prv_ctl_rf_we;
    input [4:0] prv_val_rf_req_w;
    input [31:0] prv_val_rf_data_w;
    input [`RC0_OP_NBIT - 1:0] prv_ctl_rc0_op;
    input prv_ctl_rc0_ie_we, prv_ctl_rc0_epc_we;
    input [31:0] prv_val_rc0_ie_w, prv_val_rc0_epc_w;
    output [31:0] dbg_rf_data;
    output [4:0] shamt;
    output [15:0] imm16;
    output [31:0] rf_data_a, rf_data_b;
    output [`NIRQ - 1:0] rc0_ir;
    output [31:0] rc0_ie, rc0_epc;
    output rc0_ivld;
    output [`NBIT_IRQ - 1:0] rc0_inum;
    output ctl_rf_ra, ctl_rf_rb, ctl_rf_we;
    output [`RC0_OP_NBIT - 1:0] ctl_rc0_op;
    output ctl_rc0_ie_we, ctl_rc0_epc_we;
    output [`ALU_OP_NBIT - 1:0] ctl_alu_op;
    output [`WTG_OP_NBIT - 1:0] ctl_wtg_op;
    output ctl_syscall_en;
    output [`DM_OP_NBIT - 1:0] ctl_dm_op;
    output ctl_dm_we;
    output reg [4:0] val_rf_req_w, val_rf_req_a, val_rf_req_b; // combinatorial
    output [`MUX_RF_DATAW_NBIT - 1:0] mux_rf_data_w;
    output sel_rc0_epc;
    output [`MUX_RC0_IEW_NBIT - 1:0] mux_rc0_ie_w;
    output [`MUX_RC0_EPCW_NBIT - 1:0] mux_rc0_epc_w;
    output [`MUX_ALU_DATAY_NBIT - 1:0] mux_alu_data_y;
    output is_jump, is_branch;

    wire [5:0] opcode, funct;
    wire [4:0] rs, rt, rd;
    wire rc0_ivld;
    wire [`MUX_RF_REQW_NBIT - 1:0] mux_rf_req_w;

    assign sel_rc0_epc = rd[0];

    always @(*) begin
        case (mux_rf_req_w)
            `MUX_RF_REQW_RD:
                val_rf_req_w <= rd;
            `MUX_RF_REQW_RT:
                val_rf_req_w <= rt;
            `MUX_RF_REQW_31:
                val_rf_req_w <= 5'd31;
            default:
                val_rf_req_w <= 5'd0;
        endcase
        case (ctl_syscall_en)
            0: begin
                val_rf_req_a <= rs;
                val_rf_req_b <= rt;
            end
            1: begin
                val_rf_req_a <= 2;
                val_rf_req_b <= 4;
            end
        endcase
    end

    CmbDecoder vDec(
        .inst(inst),
        .opcode(opcode),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .shamt(shamt),
        .funct(funct),
        .imm16(imm16)
    );
    SynRegFile vRF(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .we(prv_ctl_rf_we),
        .req_dbg(dbg_rf_req),
        .req_w(prv_val_rf_req_w),
        .req_a(val_rf_req_a),
        .req_b(val_rf_req_b),
        .data_w(prv_val_rf_data_w),
        .data_dbg(dbg_rf_data),
        .data_a(rf_data_a),
        .data_b(rf_data_b)
    );
    IrqRegC0 vRC0(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .op(prv_ctl_rc0_op),
        .ie_we(prv_ctl_rc0_ie_we),
        .epc_we(prv_ctl_rc0_epc_we),
        .ie_w(prv_val_rc0_ie_w),
        .epc_w(prv_val_rc0_epc_w),
        .irq_src(irq_src),
        .ir(rc0_ir),
        .ie(rc0_ie),
        .epc(rc0_epc),
        .ivld(rc0_ivld),
        .inum(rc0_inum)
    );
    CmbControl vCtl(
        .opcode(opcode),
        .rs(rs),
        .funct(funct),
        .is_epc(sel_rc0_epc),
        .wtg_op(ctl_wtg_op),
        .rf_ra(ctl_rf_ra),
        .rf_rb(ctl_rf_rb),
        .rf_we(ctl_rf_we),
        .rc0_op(ctl_rc0_op),
        .rc0_ie_we(ctl_rc0_ie_we),
        .rc0_epc_we(ctl_rc0_epc_we),
        .alu_op(ctl_alu_op),
        .dm_op(ctl_dm_op),
        .dm_we(ctl_dm_we),
        .syscall_en(ctl_syscall_en),
        .mux_rf_req_w(mux_rf_req_w),
        .mux_rf_data_w(mux_rf_data_w),
        .mux_rc0_ie_w(mux_rc0_ie_w),
        .mux_rc0_epc_w(mux_rc0_epc_w),
        .mux_alu_data_y(mux_alu_data_y),
        .is_jump(is_jump),
        .is_branch(is_branch)
    );
endmodule
