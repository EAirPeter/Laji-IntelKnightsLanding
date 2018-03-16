`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Pipeline Interface Controller, combinatorial
// Author: EAirPeter
module CmbPIC(
    id_pc,
    id_rf_ra, id_rf_rb, id_rf_req_a, id_rf_req_b,
    ex_pc, ex_pc_4, ex_rf_we, ex_rf_req_w,
    ex_sel_rf_w_dm, ex_is_jump, ex_branched,
    ex_wtg_pc_new, ex_halt,
    ma_rf_we, ma_rf_req_w,
    pc_en, pc_ld,
    ifid_en, ifid_nop, idex_en, idex_nop,
    id_mux_fwd_rf_a, id_mux_fwd_rf_b,
    is_nop
);
    input [`IM_ADDR_BIT - 1:0] id_pc;
    input id_rf_ra, id_rf_rb;
    input [4:0] id_rf_req_a, id_rf_req_b;
    input [`IM_ADDR_BIT - 1:0] ex_pc, ex_pc_4;
    input ex_rf_we;
    input [4:0] ex_rf_req_w;
    input ex_sel_rf_w_dm, ex_is_jump, ex_branched;
    input [`IM_ADDR_BIT - 1:0] ex_wtg_pc_new;
    input ex_halt;
    input ma_rf_we;
    input [4:0] ma_rf_req_w;
    output reg pc_en, pc_ld;
    output reg ifid_en, ifid_nop, idex_en, idex_nop; // combinatorial
    output reg [`MUX_FWD_RF_BIT - 1:0] id_mux_fwd_rf_a, id_mux_fwd_rf_b;
    output reg is_nop;

    reg noc_ra, noc_rb, noc_ex, noc_ma;
    reg noc_raex, noc_rama, noc_rbex, noc_rbma;
    reg [`IM_ADDR_BIT - 1:0] pc_correct;
    reg noc_go;
    reg is_clr;

    always @(*) begin
        pc_en = 1;
        pc_ld = 0;
        ifid_en = 1;
        ifid_nop = 0;
        idex_en = 1;
        idex_nop = 0;
        id_mux_fwd_rf_a = `MUX_FWD_RF_NORM;
        id_mux_fwd_rf_b = `MUX_FWD_RF_NORM;
        is_nop = 0;
        noc_ra = !id_rf_ra || id_rf_req_a == 0;
        noc_rb = !id_rf_rb || id_rf_req_b == 0;
        noc_ex = !ex_rf_we || ex_rf_req_w == 0;
        noc_ma = !ma_rf_we || ma_rf_req_w == 0;
        noc_raex = noc_ra || noc_ex || id_rf_req_a != ex_rf_req_w;
        noc_rama = noc_ra || noc_ma || id_rf_req_a != ma_rf_req_w;
        noc_rbex = noc_rb || noc_ex || id_rf_req_b != ex_rf_req_w;
        noc_rbma = noc_rb || noc_ma || id_rf_req_b != ma_rf_req_w;
        if (!noc_raex) begin
            if (ex_sel_rf_w_dm)
                is_nop = 1;
            else
                id_mux_fwd_rf_a = `MUX_FWD_RF_TMP;
        end
        else if (!noc_rama)
            id_mux_fwd_rf_a = `MUX_FWD_RF_DAT;
        if (!noc_rbex) begin
            if (ex_sel_rf_w_dm)
                is_nop = 1;
            else
                id_mux_fwd_rf_b = `MUX_FWD_RF_TMP;
        end
        else if (!noc_rbma)
            id_mux_fwd_rf_b = `MUX_FWD_RF_DAT;
        if (ex_halt)
            is_nop = 1;
        pc_correct = ex_is_jump || ex_branched ? ex_wtg_pc_new : ex_pc_4;
        noc_go = ex_pc == ex_pc_4;
        is_clr = !noc_go && id_pc != pc_correct;
        if (is_nop) begin
            pc_en = 0;
            ifid_en = 0;
            idex_nop = 1;
        end
        if (is_clr) begin
            pc_ld = 1;
            ifid_nop = 1;
            idex_nop = 1;
        end
    end
endmodule
