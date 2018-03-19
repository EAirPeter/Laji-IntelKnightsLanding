`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Forwarding, combinatorial
// Author: EAirPeter
module CmbForward(
    mux_fwd_rf_a, mux_fwd_rf_b,
    ex_rf_data_a, ex_rf_data_b,
    ma_val_rf_w_tmp, wb_val_rf_data_w,
    ex_fwd_rf_a, ex_fwd_rf_b
);
    input [`MUX_FWD_RF_NBIT - 1:0] mux_fwd_rf_a, mux_fwd_rf_b;
    input [31:0] ex_rf_data_a, ex_rf_data_b;
    input [31:0] ma_val_rf_w_tmp, wb_val_rf_data_w;
    output reg [31:0] ex_fwd_rf_a, ex_fwd_rf_b; // combinatorial

    always @(*) begin
        case (mux_fwd_rf_a)
            `MUX_FWD_RF_NORM:
                ex_fwd_rf_a <= ex_rf_data_a;
            `MUX_FWD_RF_TMP:
                ex_fwd_rf_a <= ma_val_rf_w_tmp;
            `MUX_FWD_RF_DAT:
                ex_fwd_rf_a <= wb_val_rf_data_w;
            default:
                ex_fwd_rf_a <= ex_rf_data_a;
        endcase
        case (mux_fwd_rf_b)
            `MUX_FWD_RF_NORM:
                ex_fwd_rf_b <= ex_rf_data_b;
            `MUX_FWD_RF_TMP:
                ex_fwd_rf_b <= ma_val_rf_w_tmp;
            `MUX_FWD_RF_DAT:
                ex_fwd_rf_b <= wb_val_rf_data_w;
            default:
                ex_fwd_rf_b <= ex_rf_data_a;
        endcase
    end
endmodule
