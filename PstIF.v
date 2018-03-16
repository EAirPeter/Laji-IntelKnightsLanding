`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Instruction Fetch Stage, pipelined
// Author: EAirPeter
module PstIF(clk, rst_n, en, pc_en, pc_ld, pc_new, pc, pc_4, inst);
    parameter ProgPath = "C:/.Xilinx/benchmark.hex";
    input clk, rst_n, en;
    input pc_en, pc_ld;
    input [`IM_ADDR_BIT - 1:0] pc_new;
    output [`IM_ADDR_BIT - 1:0] pc, pc_4;
    output [31:0] inst;

    SynPC vPC(
        .clk(clk),
        .rst_n(rst_n),
        .en(en && pc_en),
        .ld(pc_ld),
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
