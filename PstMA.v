`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Memory Access Stage, pipelined
// Author: EAirPeter
module PstMA(
     clk, en,
     dbg_dm_addr,
     pc_4, rf_data_b, ctl_dm_op, ctl_dm_we,
     sel_rf_w_pc_4, alu_data_res,
     dbg_dm_data,
     val_rf_w_tmp, dm_data
);
    input clk, en;
    input [`DM_ADDR_NBIT - 3:0] dbg_dm_addr;
    input [`IM_ADDR_NBIT - 1:0] pc_4;
    input [31:0] rf_data_b;
    input [`DM_OP_NBIT - 1:0] ctl_dm_op;
    input ctl_dm_we;
    input sel_rf_w_pc_4;
    input [31:0] alu_data_res;
    output [31:0] dbg_dm_data;
    output [31:0] val_rf_w_tmp;
    output [31:0] dm_data;

    assign val_rf_w_tmp = sel_rf_w_pc_4 ? {20'b0, pc_4, 2'b0} : alu_data_res;

    SynDataMem vDM(
        .clk(clk),
        .en(en),
        .op(ctl_dm_op),
        .we(ctl_dm_we),
        .addr_dbg(dbg_dm_addr),
        .addr(alu_data_res[`DM_ADDR_NBIT - 1:0]),
        .data_in(rf_data_b),
        .data_dbg(dbg_dm_data),
        .data(dm_data)
    );
endmodule
