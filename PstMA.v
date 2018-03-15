`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Memory Access Stage, pipelined
// Author: EAirPeter
module PstMA(
     clk, en,
     dbg_dm_addr,
     rf_data_b, alu_data_res,
     ctl_dm_op, ctl_dm_we,
     dbg_dm_data,
     dm_data
);
    input clk, en;
    input [`DM_ADDR_BIT - 3:0] dbg_dm_addr;
    input [31:0] rf_data_b;
    input [31:0] alu_data_res;
    input [`DM_OP_BIT - 1:0] ctl_dm_op;
    input ctl_dm_we;
    output [31:0] dbg_dm_data, dm_data;

    (* keep = "soft" *)
    wire [31 - `DM_ADDR_BIT:0] unused_alu_data_res = alu_data_res[31:`DM_ADDR_BIT];

    SynDataMem vDM(
        .clk(clk),
        .en(en),
        .op(ctl_dm_op),
        .we(ctl_dm_we),
        .addr_dbg(dbg_dm_addr),
        .addr(alu_data_res[`DM_ADDR_BIT - 1:0]),
        .data_in(rf_data_b),
        .data_dbg(dbg_dm_data),
        .data(dm_data)
    );
endmodule
