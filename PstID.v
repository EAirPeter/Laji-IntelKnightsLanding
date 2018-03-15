`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Instruction Decoding Stage, pipelined
// Author: EAirPeter
module PstID(
    clk, en,
    dbg_rf_req,
    inst, prv_ctl_rf_we, prv_val_rf_req_w, prv_val_rf_data_w,
    dbg_rf_data,
    shamt, imm16,
    rf_data_a, rf_data_b, rf_data_v0, rf_data_a0,
    ctl_rf_we, ctl_alu_op, ctl_wtg_op,
    ctl_syscall_en, ctl_dm_op, ctl_dm_we,
    val_rf_req_w, mux_rf_data_w, mux_alu_data_y,
    is_jump, is_branch
);
    input clk, en;
    input [4:0] dbg_rf_req;
    input [31:0] inst;
    input prv_ctl_rf_we;
    input [4:0] prv_val_rf_req_w;
    input [31:0] prv_val_rf_data_w;
    output [31:0] dbg_rf_data;
    output [4:0] shamt;
    output [15:0] imm16;
    output [31:0] rf_data_a, rf_data_b, rf_data_v0, rf_data_a0;
    output ctl_rf_we;
    output [`ALU_OP_BIT - 1:0] ctl_alu_op;
    output [`WTG_OP_BIT - 1:0] ctl_wtg_op;
    output ctl_syscall_en;
    output [`DM_OP_BIT - 1:0] ctl_dm_op;
    output ctl_dm_we;
    output reg [4:0] val_rf_req_w; // combinatorial
    output [`MUX_RF_DATAW_BIT - 1:0] mux_rf_data_w;
    output [`MUX_ALU_DATAY_BIT - 1:0] mux_alu_data_y;
    output is_jump, is_branch;

    wire [5:0] opcode, funct;
    wire [4:0] rs, rt, rd;
    wire [`MUX_RF_REQW_BIT - 1:0] mux_rf_req_w;

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
        .en(en),
        .we(prv_ctl_rf_we),
        .req_dbg(dbg_rf_req),
        .req_w(prv_val_rf_req_w),
        .req_a(rs),
        .req_b(rt),
        .data_w(prv_val_rf_data_w),
        .data_dbg(dbg_rf_data),
        .data_a(rf_data_a),
        .data_b(rf_data_b),
        .data_v0(rf_data_v0),
        .data_a0(rf_data_a0)
    );
    CmbControl vCtl(
        .opcode(opcode),
        .rt(rt),
        .funct(funct),
        .wtg_op(ctl_wtg_op),
        .rf_we(ctl_rf_we),
        .alu_op(ctl_alu_op),
        .dm_op(ctl_dm_op),
        .dm_we(ctl_dm_we),
        .syscall_en(ctl_syscall_en),
        .mux_rf_req_w(mux_rf_req_w),
        .mux_rf_data_w(mux_rf_data_w),
        .mux_alu_data_y(mux_alu_data_y),
        .is_jump(is_jump),
        .is_branch(is_branch)
    );
endmodule