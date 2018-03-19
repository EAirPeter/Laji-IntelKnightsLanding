`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Execution Stage, pipelined
// Author: EAirPeter
module PstEX(
    clk, rst_n, en,
    pc_4, shamt, imm16, rf_data_a, rf_data_b,
    ctl_alu_op, ctl_wtg_op, ctl_syscall_en, mux_alu_data_y,
    alu_data_res, wtg_pc_new, wtg_pc_branch, branched, display, halt
);
    input clk, rst_n, en;
    input [`IM_ADDR_NBIT - 1:0] pc_4;
    input [4:0] shamt;
    input [15:0] imm16;
    input [31:0] rf_data_a, rf_data_b;
    input [`ALU_OP_NBIT - 1:0] ctl_alu_op;
    input [`WTG_OP_NBIT - 1:0] ctl_wtg_op;
    input ctl_syscall_en;
    input [`MUX_ALU_DATAY_NBIT - 1:0] mux_alu_data_y;
    output [31:0] alu_data_res;
    output [`IM_ADDR_NBIT - 1:0] wtg_pc_new, wtg_pc_branch;
    output branched;
    output [31:0] display;
    output halt;

    reg [31:0] val_alu_data_y; // combinatorial
    always @(*) begin
        case (mux_alu_data_y)
            `MUX_ALU_DATAY_RFB:
                val_alu_data_y <= rf_data_b;
            `MUX_ALU_DATAY_EXTS:
                val_alu_data_y <= {{16{imm16[15]}}, imm16};
            `MUX_ALU_DATAY_EXTZ:
                val_alu_data_y <= {16'b0, imm16};
            default:
                val_alu_data_y <= 32'b0;
        endcase
    end

    CmbALU vALU(
        .op(ctl_alu_op),
        .data_x(rf_data_a),
        .data_y(val_alu_data_y),
        .shamt(shamt),
        .data_res(alu_data_res)
    );
    CmbWTG vWTG(
        .op(ctl_wtg_op),
        .imm(imm16[`IM_ADDR_NBIT - 1:0]),
        .data_x(rf_data_a),
        .data_y(rf_data_b),
        .pc_4(pc_4),
        .pc_new(wtg_pc_new),
        .pc_branch(wtg_pc_branch),
        .branched(branched)
    );
    SynSyscall vSys(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .syscall_en(ctl_syscall_en),
        .data_v0(rf_data_a),
        .data_a0(rf_data_b),
        .display(display),
        .halt(halt)
    );
endmodule
