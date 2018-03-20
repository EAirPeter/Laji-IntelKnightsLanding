`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Write Back Stage, pipelined
// Author: EAirPeter
module PstWB(
    mux_rf_data_w, val_rf_w_tmp, dm_data,
    val_rf_data_w
);
    input [`MUX_RF_DATAW_NBIT - 1:0] mux_rf_data_w;
    input [31:0] val_rf_w_tmp, dm_data;
    output [31:0] val_rf_data_w;

    assign val_rf_data_w = mux_rf_data_w == `MUX_RF_DATAW_DM ? dm_data : val_rf_w_tmp;
endmodule
