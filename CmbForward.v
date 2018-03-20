`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Forwarding, combinatorial
// Author: EAirPeter
module CmbForward(
    mux_fwd_rf_a, mux_fwd_rf_b,
    ex_rf_data_a, ex_rf_data_b,
    ma_val_rf_w_tmp, wb_val_rf_data_w,
    mux_fwd_rc0_ie, mux_fwd_rc0_epc,
    ex_val_rc0_ie_w, ex_val_rc0_epc_w,
    id_rc0_ie, id_rc0_epc,
    ma_val_rc0_ie_w, ma_val_rc0_epc_w,
    ex_fwd_rf_a, ex_fwd_rf_b,,
    id_fwd_rc0_ie, id_fwd_rc0_epc
);
    input [`MUX_FWD_RF_NBIT - 1:0] mux_fwd_rf_a, mux_fwd_rf_b;
    input [31:0] ex_rf_data_a, ex_rf_data_b;
    input [31:0] ma_val_rf_w_tmp, wb_val_rf_data_w;
    input [`MUX_FWD_RC0_NBIT - 1:0] mux_fwd_rc0_ie, mux_fwd_rc0_epc;
    input [31:0] id_rc0_ie, id_rc0_epc;
    input [31:0] ex_val_rc0_ie_w, ex_val_rc0_epc_w;
    input [31:0] ma_val_rc0_ie_w, ma_val_rc0_epc_w;
    output reg [31:0] ex_fwd_rf_a, ex_fwd_rf_b; // combinatorial
    output reg [31:0] id_fwd_rc0_ie, id_fwd_rc0_epc; // combinatorial

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
        case (mux_fwd_rc0_ie)
            `MUX_FWD_RC0_NORM:
                id_fwd_rc0_ie <= id_rc0_ie;
            `MUX_FWD_RC0_EX:
                id_fwd_rc0_ie <= ex_val_rc0_ie_w;
            `MUX_FWD_RC0_MA:
                id_fwd_rc0_ie <= ma_val_rc0_ie_w;
            default:
                id_fwd_rc0_ie <= id_rc0_ie;
        endcase
        case (mux_fwd_rc0_epc)
            `MUX_FWD_RC0_NORM:
                id_fwd_rc0_epc <= id_rc0_epc;
            `MUX_FWD_RC0_EX:
                id_fwd_rc0_epc <= ex_val_rc0_epc_w;
            `MUX_FWD_RC0_MA:
                id_fwd_rc0_epc <= ma_val_rc0_epc_w;
            default:
                id_fwd_rc0_epc <= id_rc0_epc;
        endcase
    end
endmodule
