`timescale 1ns / 1ps

`include "Core.vh"

// Brief: CPU Top Module, synchronized
// Author: EAirPeter
module SynLajiIntelKnightsLanding(
    clk, rst_n, en, dbg_rf_req, dbg_dm_addr, irq_src,
    dbg_rf_data, dbg_dm_data,
    irq_st, is_jump, is_branch, branched, is_nop,
    dbp_hit, dbp_miss, display, halt
);
    parameter ProgPath = "";
    input clk, rst_n, en;
    input [4:0] dbg_rf_req;
    input [`DM_ADDR_NBIT - 3:0] dbg_dm_addr;
    input [`NIRQ - 1:0] irq_src;
    output [31:0] dbg_rf_data;
    output [31:0] dbg_dm_data;
    output [`NIRQ - 1:0] irq_st;
    output is_jump, is_branch, branched, is_nop, dbp_hit, dbp_miss;
    output [31:0] display;
    output halt;

    wire [`IM_ADDR_NBIT - 1:0] if_bht_pc_new;
    wire if_bht_take;
    wire id_ctl_rf_ra, id_ctl_rf_rb;
    wire [4:0] id_val_rf_req_a, id_val_rf_req_b;
    wire [`IM_ADDR_NBIT - 1:0] ex_wtg_pc_new, ex_wtg_pc_branch;
    wire pic_pc_en, pic_pc_ld_wtg;
    wire [`BHT_OP_NBIT - 1:0] pic_bht_op;
    wire pic_ifid_en, pic_ifid_nop;
    wire pic_idex_en, pic_idex_nop;

`define GEN_DAT \
    `GEN_FDX__(`IM_ADDR_NBIT        , pc                ) \
    `GEN_FDXM_(`IM_ADDR_NBIT        , pc_4              ) \
    `GEN_FD___(32                   , inst              ) \
    `GEN__DX__(5                    , shamt             ) \
    `GEN__DX__(16                   , imm16             ) \
    `GEN__DO__(32                   , rf_data_a         ) \
    `GEN__DOM_(32                   , rf_data_b         ) \
    `GEN__DO__(32                   , rc0_ie            ) \
    `GEN__DO__(32                   , rc0_epc           ) \
    `GEN__DX__(1                    , rc0_ivld          ) \
    `GEN__DX__(`NBIT_IRQ            , rc0_inum          ) \
    `GEN__DOMW(1                    , ctl_rf_we         ) \
    `GEN__DOMW(`RC0_OP_NBIT         , ctl_rc0_op        ) \
    `GEN__DOMW(1                    , ctl_rc0_ie_we     ) \
    `GEN__DOMW(1                    , ctl_rc0_epc_we    ) \
    `GEN__DX__(`ALU_OP_NBIT         , ctl_alu_op        ) \
    `GEN__DO__(`WTG_OP_NBIT         , ctl_wtg_op        ) \
    `GEN__DO__(1                    , ctl_syscall_en    ) \
    `GEN__DXM_(`DM_OP_NBIT          , ctl_dm_op         ) \
    `GEN__DOM_(1                    , ctl_dm_we         ) \
    `GEN__DXMW(5                    , val_rf_req_w      ) \
    `GEN__DXMW(`MUX_RF_DATAW_NBIT   , mux_rf_data_w     ) \
    `GEN____MW(32                   , val_rf_w_tmp      ) \
    `GEN__DX__(1                    , sel_rc0_epc       ) \
    `GEN___XM_(32                   , val_rc0_data      ) \
    `GEN__DO__(`MUX_RC0_IEW_NBIT    , mux_rc0_ie_w      ) \
    `GEN__DO__(`MUX_RC0_EPCW_NBIT   , mux_rc0_epc_w     ) \
    `GEN___XMW(32                   , val_rc0_ie_w      ) \
    `GEN___XMW(32                   , val_rc0_epc_w     ) \
    `GEN__DX__(`MUX_ALU_DATAY_NBIT  , mux_alu_data_y    ) \
    `GEN__DXM_(1                    , is_jump           ) \
    `GEN__DXM_(1                    , is_branch         ) \
    `GEN___XM_(32                   , alu_data_res      ) \
    `GEN___XM_(1                    , branched          ) \
    `GEN___XM_(1                    , is_nop            ) \
    `GEN___XM_(1                    , dbp_hit           ) \
    `GEN___XM_(1                    , dbp_miss          ) \
    `GEN___XM_(32                   , display           ) \
    `GEN___XMW(1                    , halt              ) \
    `GEN____MW(32                   , dm_data           ) \
    `GEN_____W(32                   , val_rf_data_w     ) \
    `GEN__DX__(`MUX_FWD_RF_NBIT     , mux_fwd_rf_a      ) \
    `GEN__DX__(`MUX_FWD_RF_NBIT     , mux_fwd_rf_b      ) \
    `GEN__DX__(`MUX_FWD_RC0_NBIT    , mux_fwd_rc0_ie    ) \
    `GEN__DX__(`MUX_FWD_RC0_NBIT    , mux_fwd_rc0_epc   )
`define PIF_IFID_ENA en && pic_ifid_en
`define PIF_IFID_NOP pic_ifid_nop
`define PIF_IDEX_ENA en && pic_idex_en
`define PIF_IDEX_NOP pic_idex_nop
`include "GenAll.vh"

    assign is_jump = ma_is_jump;
    assign is_branch = ma_is_branch;
    assign branched = ma_branched;
    assign is_nop = ma_is_nop;
    assign dbp_hit = ma_dbp_hit;
    assign dbp_miss = ma_dbp_miss;
    assign display = ma_display;
    assign halt = wb_halt;

    CmbPIC vPIC(
        .id_pc(id_pc),
        .id_rf_ra(id_ctl_rf_ra),
        .id_rf_rb(id_ctl_rf_rb),
        .id_rf_req_a(id_val_rf_req_a),
        .id_rf_req_b(id_val_rf_req_b),
        .ex_pc(ex_pc),
        .ex_pc_4(ex_pc_4),
        .ex_rf_we(ex_ctl_rf_we),
        .ex_rf_req_w(ex_val_rf_req_w),
        .ex_mux_rf_data_w(ex_mux_rf_data_w),
        .ex_rc0_op(ex_ctl_rc0_op),
        .ex_rc0_ie_we(ex_ctl_rc0_ie_we),
        .ex_rc0_epc_we(ex_ctl_rc0_epc_we),
        .ex_is_jump(ex_is_jump),
        .ex_is_branch(ex_is_branch),
        .ex_branched(ex_branched),
        .ex_wtg_pc_new(ex_wtg_pc_new),
        .ex_halt(ex_halt),
        .ma_rf_we(ma_ctl_rf_we),
        .ma_rf_req_w(ma_val_rf_req_w),
        .ma_rc0_ie_we(ma_ctl_rc0_ie_we),
        .ma_rc0_epc_we(ma_ctl_rc0_epc_we),
        .pc_en(pic_pc_en),
        .pc_ld_wtg(pic_pc_ld_wtg),
        .bht_op(pic_bht_op),
        .ifid_en(pic_ifid_en),
        .ifid_nop(pic_ifid_nop),
        .idex_en(pic_idex_en),
        .idex_nop(pic_idex_nop),
        .id_mux_fwd_rf_a(id_mux_fwd_rf_a),
        .id_mux_fwd_rf_b(id_mux_fwd_rf_b),
        .id_mux_fwd_rc0_ie(id_mux_fwd_rc0_ie),
        .id_mux_fwd_rc0_epc(id_mux_fwd_rc0_epc),
        .is_nop(ex_is_nop),
        .dbp_hit(ex_dbp_hit),
        .dbp_miss(ex_dbp_miss)
    );
    CmbForward vFwd(
        .mux_fwd_rf_a(ex_mux_fwd_rf_a),
        .mux_fwd_rf_b(ex_mux_fwd_rf_b),
        .ex_rf_data_a(ex_rf_data_a_old),
        .ex_rf_data_b(ex_rf_data_b_old),
        .ma_val_rf_w_tmp(ma_val_rf_w_tmp),
        .wb_val_rf_data_w(wb_val_rf_data_w),
        .mux_fwd_rc0_ie(ex_mux_fwd_rc0_ie),
        .mux_fwd_rc0_epc(ex_mux_fwd_rc0_epc),
        .ex_rc0_ie(ex_rc0_ie_old),
        .ex_rc0_epc(ex_rc0_epc_old),
        .ma_val_rc0_ie_w(ma_val_rc0_ie_w),
        .ma_val_rc0_epc_w(ma_val_rc0_epc_w),
        .wb_val_rc0_ie_w(wb_val_rc0_ie_w),
        .wb_val_rc0_epc_w(wb_val_rc0_epc_w),
        .ex_fwd_rf_a(ex_rf_data_a),
        .ex_fwd_rf_b(ex_rf_data_b),
        .ex_fwd_rc0_ie(ex_rc0_ie),
        .ex_fwd_rc0_epc(ex_rc0_epc)
    );
    SynBHT vBHT(
        .clk(clk),
        .rst_n(rst_n),
        .op(pic_bht_op),
        .pc_r(if_pc),
        .pc_w(ex_pc),
        .dst_w(ex_wtg_pc_branch),
        .dst_r(if_bht_pc_new),
        .take_r(if_bht_take)
    );
    IrqOverride vIrqOvrd(
        .rc0_ie(ex_rc0_ie),
        .rc0_ivld(ex_rc0_ivld),
        .ma_rc0_op(ma_ctl_rc0_op),
        .wb_rc0_op(wb_ctl_rc0_op),
        .ctl_rf_we(ex_ctl_rf_we_old),
        .ctl_rc0_op(ex_ctl_rc0_op_old),
        .ctl_rc0_ie_we(ex_ctl_rc0_ie_we_old),
        .ctl_rc0_epc_we(ex_ctl_rc0_epc_we_old),
        .ctl_wtg_op(ex_ctl_wtg_op_old),
        .ctl_syscall_en(ex_ctl_syscall_en_old),
        .ctl_dm_we(ex_ctl_dm_we_old),
        .mux_rc0_ie_w(ex_mux_rc0_ie_w_old),
        .mux_rc0_epc_w(ex_mux_rc0_epc_w_old),
        .irq_rf_we(ex_ctl_rf_we),
        .irq_rc0_op(ex_ctl_rc0_op),
        .irq_rc0_ie_we(ex_ctl_rc0_ie_we),
        .irq_rc0_epc_we(ex_ctl_rc0_epc_we),
        .irq_wtg_op(ex_ctl_wtg_op),
        .irq_syscall_en(ex_ctl_syscall_en),
        .irq_dm_we(ex_ctl_dm_we),
        .imx_rc0_ie_w(ex_mux_rc0_ie_w),
        .imx_rc0_epc_w(ex_mux_rc0_epc_w)
    );
    PstIF #(
        .ProgPath(ProgPath)
    ) vIF(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .pc_en(pic_pc_en),
        .pc_ld_wtg(pic_pc_ld_wtg),
        .pc_ld_bht(if_bht_take),
        .wtg_pc_new(ex_wtg_pc_new),
        .bht_pc_new(if_bht_pc_new),
        .pc(if_pc),
        .pc_4(if_pc_4),
        .inst(if_inst)
    );
    PstID vID(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .dbg_rf_req(dbg_rf_req),
        .irq_src(irq_src),
        .inst(id_inst),
        .prv_ctl_rf_we(wb_ctl_rf_we),
        .prv_val_rf_req_w(wb_val_rf_req_w),
        .prv_val_rf_data_w(wb_val_rf_data_w),
        .prv_ctl_rc0_op(wb_ctl_rc0_op),
        .prv_ctl_rc0_ie_we(wb_ctl_rc0_ie_we),
        .prv_ctl_rc0_epc_we(wb_ctl_rc0_epc_we),
        .prv_val_rc0_ie_w(wb_val_rc0_ie_w),
        .prv_val_rc0_epc_w(wb_val_rc0_epc_w),
        .dbg_rf_data(dbg_rf_data),
        .shamt(id_shamt),
        .imm16(id_imm16),
        .rf_data_a(id_rf_data_a),
        .rf_data_b(id_rf_data_b),
        .rc0_ir(irq_st),
        .rc0_ie(id_rc0_ie),
        .rc0_epc(id_rc0_epc),
        .rc0_ivld(id_rc0_ivld),
        .rc0_inum(id_rc0_inum),
        .ctl_rf_ra(id_ctl_rf_ra),
        .ctl_rf_rb(id_ctl_rf_rb),
        .ctl_rf_we(id_ctl_rf_we),
        .ctl_rc0_op(id_ctl_rc0_op),
        .ctl_rc0_ie_we(id_ctl_rc0_ie_we),
        .ctl_rc0_epc_we(id_ctl_rc0_epc_we),
        .ctl_alu_op(id_ctl_alu_op),
        .ctl_wtg_op(id_ctl_wtg_op),
        .ctl_syscall_en(id_ctl_syscall_en),
        .ctl_dm_op(id_ctl_dm_op),
        .ctl_dm_we(id_ctl_dm_we),
        .val_rf_req_w(id_val_rf_req_w),
        .val_rf_req_a(id_val_rf_req_a),
        .val_rf_req_b(id_val_rf_req_b),
        .mux_rf_data_w(id_mux_rf_data_w),
        .sel_rc0_epc(id_sel_rc0_epc),
        .mux_rc0_ie_w(id_mux_rc0_ie_w),
        .mux_rc0_epc_w(id_mux_rc0_epc_w),
        .mux_alu_data_y(id_mux_alu_data_y),
        .is_jump(id_is_jump),
        .is_branch(id_is_branch)
    );
    PstEX vEX(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .pc(ex_pc),
        .pc_4(ex_pc_4),
        .shamt(ex_shamt),
        .imm16(ex_imm16),
        .rf_data_a(ex_rf_data_a),
        .rf_data_b(ex_rf_data_b),
        .rc0_inum(ex_rc0_inum),
        .rc0_ie(ex_rc0_ie),
        .rc0_epc(ex_rc0_epc),
        .ctl_alu_op(ex_ctl_alu_op),
        .ctl_wtg_op(ex_ctl_wtg_op),
        .ctl_syscall_en(ex_ctl_syscall_en),
        .sel_rc0_epc(ex_sel_rc0_epc),
        .mux_rc0_ie_w(ex_mux_rc0_ie_w),
        .mux_rc0_epc_w(ex_mux_rc0_epc_w),
        .mux_alu_data_y(ex_mux_alu_data_y),
        .val_rc0_data(ex_val_rc0_data),
        .val_rc0_ie_w(ex_val_rc0_ie_w),
        .val_rc0_epc_w(ex_val_rc0_epc_w),
        .alu_data_res(ex_alu_data_res),
        .wtg_pc_new(ex_wtg_pc_new),
        .wtg_pc_branch(ex_wtg_pc_branch),
        .branched(ex_branched),
        .display(ex_display),
        .halt(ex_halt)
    );
    PstMA vMA(
        .clk(clk),
        .en(en),
        .pc_4(ma_pc_4),
        .dbg_dm_addr(dbg_dm_addr),
        .rf_data_b(ma_rf_data_b),
        .ctl_dm_op(ma_ctl_dm_op),
        .ctl_dm_we(ma_ctl_dm_we),
        .mux_rf_data_w(ma_mux_rf_data_w),
        .alu_data_res(ma_alu_data_res),
        .val_rc0_data(ma_val_rc0_data),
        .dbg_dm_data(dbg_dm_data),
        .val_rf_w_tmp(ma_val_rf_w_tmp),
        .dm_data(ma_dm_data)
    );
    PstWB vWB(
        .mux_rf_data_w(wb_mux_rf_data_w),
        .val_rf_w_tmp(wb_val_rf_w_tmp),
        .dm_data(wb_dm_data),
        .val_rf_data_w(wb_val_rf_data_w)
    );
endmodule
