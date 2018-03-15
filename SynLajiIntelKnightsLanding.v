`timescale 1ns / 1ps

`include "Core.vh"

`define DECL_DAT(bits_, name_) \
    localparam Bits_``name_ = (bits_); \
    wire [Bits_``name_ - 1:0] if_``name_, id_``name_, ex_``name_, ma_``name_, wb_``name_

// Brief: CPU Top Module, synchronized
// Author: EAirPeter
module SynLajiIntelKnightsLanding(
    clk, rst_n, en, dbg_rf_req, dbg_dm_addr,
    dbg_pc, dbg_rf_data, dbg_dm_data,
    is_jump, is_branch, branched, display, halt
);
    parameter ProgPath = "C:/.Xilinx/benchmark.hex";
    input clk, rst_n, en;
    input [4:0] dbg_rf_req;
    input [`DM_ADDR_BIT - 3:0] dbg_dm_addr;
    output [31:0] dbg_pc;
    output [31:0] dbg_rf_data;
    output [31:0] dbg_dm_data;
    output is_jump, is_branch, branched;
    output [31:0] display;
    output halt;

    `DECL_DAT(`IM_ADDR_BIT      , pc_4              );
    `DECL_DAT(32                , inst              );
    `DECL_DAT(5                 , shamt             );
    `DECL_DAT(16                , imm16             );
    `DECL_DAT(32                , rf_data_a         );
    `DECL_DAT(32                , rf_data_b         );
    `DECL_DAT(32                , rf_data_v0        );
    `DECL_DAT(32                , rf_data_a0        );
    `DECL_DAT(1                 , ctl_rf_we         );
    `DECL_DAT(`ALU_OP_BIT       , ctl_alu_op        );
    `DECL_DAT(`WTG_OP_BIT       , ctl_wtg_op        );
    `DECL_DAT(1                 , ctl_syscall_en    );
    `DECL_DAT(`DM_OP_BIT        , ctl_dm_op         );
    `DECL_DAT(1                 , ctl_dm_we         );
    `DECL_DAT(5                 , val_rf_req_w      );
    `DECL_DAT(`MUX_RF_DATAW_BIT , mux_rf_data_w     );
    `DECL_DAT(`MUX_ALU_DATAY_BIT, mux_alu_data_y    );
    `DECL_DAT(1                 , is_jump           );
    `DECL_DAT(1                 , is_branch         );
    `DECL_DAT(32                , alu_data_res      );
    `DECL_DAT(`IM_ADDR_BIT      , wtg_pc_new        );
    `DECL_DAT(1                 , branched          );
    `DECL_DAT(32                , display           );
    `DECL_DAT(1                 , halt              );
    `DECL_DAT(32                , dm_data           );
    `DECL_DAT(32                , val_rf_data_w     );

    assign is_jump = wb_is_jump;
    assign is_branch = wb_is_branch;
    assign branched = wb_branched;
    assign display = wb_display;
    assign halt = wb_halt;

`define GPI_PIF vIFID
`define GPI_IST if
`define GPI_OST id
`define GPI_DAT `GPI_(pc_4) `GPI(inst)
`include "GenPiplIntf.vh"

`define GPI_PIF vIDEX
`define GPI_IST id
`define GPI_OST ex
`define GPI_DAT \
    `GPI_(pc_4) `GPI(shamt) `GPI(imm16) \
    `GPI(rf_data_a) `GPI(rf_data_b) `GPI(rf_data_v0) `GPI(rf_data_a0) \
    `GPI(ctl_rf_we) `GPI(ctl_alu_op) `GPI(ctl_wtg_op) `GPI(ctl_syscall_en) \
    `GPI(ctl_dm_op) `GPI(ctl_dm_we) `GPI(val_rf_req_w) \
    `GPI(mux_rf_data_w) `GPI(mux_alu_data_y) \
    `GPI(is_jump) `GPI(is_branch)
`include "GenPiplIntf.vh"

`define GPI_PIF vEXMA
`define GPI_IST ex
`define GPI_OST ma
`define GPI_DAT \
    `GPI_(pc_4) `GPI(rf_data_b) `GPI(ctl_rf_we) `GPI(ctl_dm_op) `GPI(ctl_dm_we) \
    `GPI(val_rf_req_w) `GPI(mux_rf_data_w) `GPI(is_jump) `GPI(is_branch) \
    `GPI(alu_data_res) `GPI(branched) `GPI(display) `GPI(halt)
`include "GenPiplIntf.vh"

`define GPI_PIF vMAWB
`define GPI_IST ma
`define GPI_OST wb
`define GPI_DAT \
    `GPI_(pc_4) `GPI(ctl_rf_we) `GPI(val_rf_req_w) `GPI(mux_rf_data_w) \
    `GPI(is_jump) `GPI(is_branch) `GPI(alu_data_res) \
    `GPI(branched) `GPI(display) `GPI(halt) `GPI(dm_data)
`include "GenPiplIntf.vh"

    PstIF #(
        .ProgPath(ProgPath)
    ) vIF(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .dbg_pc(dbg_pc),
        .pc_4(if_pc_4),
        .inst(if_inst)
    );
    PstID vID(
        .clk(clk),
        .en(en),
        .dbg_rf_req(dbg_rf_req),
        .inst(id_inst),
        .prv_ctl_rf_we(wb_ctl_rf_we),
        .prv_val_rf_req_w(wb_val_rf_req_w),
        .prv_val_rf_data_w(wb_val_rf_data_w),
        .dbg_rf_data(dbg_rf_data),
        .shamt(id_shamt),
        .imm16(id_imm16),
        .rf_data_a(id_rf_data_a),
        .rf_data_b(id_rf_data_b),
        .rf_data_v0(id_rf_data_v0),
        .rf_data_a0(id_rf_data_a0),
        .ctl_rf_we(id_ctl_rf_we),
        .ctl_alu_op(id_ctl_alu_op),
        .ctl_wtg_op(id_ctl_wtg_op),
        .ctl_syscall_en(id_ctl_syscall_en),
        .ctl_dm_op(id_ctl_dm_op),
        .ctl_dm_we(id_ctl_dm_we),
        .val_rf_req_w(id_val_rf_req_w),
        .mux_rf_data_w(id_mux_rf_data_w),
        .mux_alu_data_y(id_mux_alu_data_y),
        .is_jump(id_is_jump),
        .is_branch(id_is_branch)
    );
    PstEX vEX(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .pc_4(ex_pc_4),
        .shamt(ex_shamt),
        .imm16(ex_imm16),
        .rf_data_a(ex_rf_data_a),
        .rf_data_b(ex_rf_data_b),
        .rf_data_v0(ex_rf_data_v0),
        .rf_data_a0(ex_rf_data_a0),
        .ctl_alu_op(ex_ctl_alu_op),
        .ctl_wtg_op(ex_ctl_wtg_op),
        .ctl_syscall_en(ex_ctl_syscall_en),
        .mux_alu_data_y(ex_mux_alu_data_y),
        .alu_data_res(ex_alu_data_res),
        .wtg_pc_new(ex_wtg_pc_new),
        .branched(ex_branched),
        .display(ex_display),
        .halt(ex_halt)
    );
    PstMA vMA(
        .clk(clk),
        .en(en),
        .dbg_dm_addr(dbg_dm_addr),
        .rf_data_b(ma_rf_data_b),
        .alu_data_res(ma_alu_data_res),
        .ctl_dm_op(ma_ctl_dm_op),
        .ctl_dm_we(ma_ctl_dm_we),
        .dbg_dm_data(dbg_dm_data),
        .dm_data(ma_dm_data)
    );
    PstWB vWB(
        .pc_4(wb_pc_4),
        .mux_rf_data_w(wb_mux_rf_data_w),
        .alu_data_res(wb_alu_data_res),
        .dm_data(wb_dm_data),
        .val_rf_data_w(wb_val_rf_data_w)
    );
endmodule
