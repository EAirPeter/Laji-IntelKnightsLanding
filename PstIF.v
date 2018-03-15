`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Instruction Fetch Stage, pipelined
// Author: EAirPeter
module PstIF(clk, rst_n, en, dbg_pc, pc_4, inst);
    parameter ProgPath = "C:/.Xilinx/benchmark.hex";
    input clk, rst_n, en;
    output [31:0] dbg_pc;
    output [`IM_ADDR_BIT - 1:0] pc_4;
    output [31:0] inst;
    
    wire [`IM_ADDR_BIT - 1:0] pc_new, pc;

    assign dbg_pc = {20'b0, pc, 2'b0};

    SynPC vPC(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .pc_new(pc_4),
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
