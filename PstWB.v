`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Write Back Stage, pipelined
// Author: EAirPeter
module PstWB(
    pc_4, mux_rf_data_w, alu_data_res, dm_data,
    val_rf_data_w
);
    input [`IM_ADDR_BIT - 1:0] pc_4;
    input [`MUX_RF_DATAW_BIT - 1:0] mux_rf_data_w;
    input [31:0] alu_data_res, dm_data;
    output reg [31:0] val_rf_data_w; // combinatorial

    always @(*) begin
        case (mux_rf_data_w)
            `MUX_RF_DATAW_ALU:
                val_rf_data_w <= alu_data_res;
            `MUX_RF_DATAW_DM:
                val_rf_data_w <= dm_data;
            `MUX_RF_DATAW_PC4:
                val_rf_data_w <= pc_4;
            default:
                val_rf_data_w <= 32'b0;
        endcase
    end
endmodule
