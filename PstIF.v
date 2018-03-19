`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Instruction Fetch Stage, pipelined
// Author: EAirPeter
module PstIF(
    clk, rst_n, en,
    pc_en, pc_ld_wtg, pc_ld_bht, wtg_pc_new, bht_pc_new,
    pc, pc_4, inst
);
    parameter ProgPath = "C:/.Xilinx/benchmark.hex";
    input clk, rst_n, en;
    input pc_en, pc_ld_wtg, pc_ld_bht;
    input [`IM_ADDR_NBIT - 1:0] wtg_pc_new, bht_pc_new;
    output [`IM_ADDR_NBIT - 1:0] pc, pc_4;
    output [31:0] inst;

    wire [`IM_ADDR_NBIT - 1:0] pc_new = pc_ld_wtg ? wtg_pc_new : pc_ld_bht ? bht_pc_new : pc_4;

    SynPC vPC(
        .clk(clk),
        .rst_n(rst_n),
        .en(en && pc_en),
        .ld(pc_ld_wtg || pc_ld_bht),
        .pc_new(pc_new),
        .pc(pc),
        .pc_4(pc_4)
    );
    CmbInstMem #(
        .ProgPath(ProgPath)
    ) vIM(
        .addr(pc),
        .inst(inst)
    );
endmodule
