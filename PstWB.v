`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Write Back Stage, pipelined
// Author: EAirPeter
module PstWB(
    sel_rf_w_dm, val_rf_w_tmp, dm_data,
    val_rf_data_w
);
    input sel_rf_w_dm;
    input [31:0] val_rf_w_tmp, dm_data;
    output [31:0] val_rf_data_w;

    assign val_rf_data_w = sel_rf_w_dm ? dm_data : val_rf_w_tmp;
endmodule
