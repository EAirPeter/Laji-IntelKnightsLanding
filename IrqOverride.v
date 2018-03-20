`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Control Signal Overriding, combinatorial, interrupt
// Author: EAirPeter
module IrqOverride(
    rc0_ie, rc0_ivld, ma_rc0_op, wb_rc0_op,
    ctl_rf_we, ctl_rc0_op, ctl_rc0_ie_we, ctl_rc0_epc_we, ctl_wtg_op,
    ctl_syscall_en, ctl_dm_we, mux_rc0_ie_w, mux_rc0_epc_w,
    irq_rf_we, irq_rc0_op, irq_rc0_ie_we, irq_rc0_epc_we, irq_wtg_op,
    irq_dm_we, irq_syscall_en, imx_rc0_ie_w, imx_rc0_epc_w
);
    input [31:0] rc0_ie;
    input rc0_ivld;
    input [`RC0_OP_NBIT - 1:0] ma_rc0_op;
    input [`RC0_OP_NBIT - 1:0] wb_rc0_op;
    input ctl_rf_we;
    input [`RC0_OP_NBIT - 1:0] ctl_rc0_op;
    input ctl_rc0_ie_we, ctl_rc0_epc_we;
    input [`WTG_OP_NBIT - 1:0] ctl_wtg_op;
    input ctl_syscall_en, ctl_dm_we;
    input [`MUX_RC0_IEW_NBIT - 1:0] mux_rc0_ie_w;
    input [`MUX_RC0_EPCW_NBIT - 1:0] mux_rc0_epc_w;
    output reg irq_rf_we;                                   // combinatorial
    output reg [`RC0_OP_NBIT - 1:0] irq_rc0_op;             // combinatorial
    output reg irq_rc0_ie_we, irq_rc0_epc_we;               // combinatorial
    output reg [`WTG_OP_NBIT - 1:0] irq_wtg_op;             // combinatorial
    output reg irq_syscall_en, irq_dm_we;                   // combinatorial
    output reg [`MUX_RC0_IEW_NBIT - 1:0] imx_rc0_ie_w;      // combinatorial
    output reg [`MUX_RC0_EPCW_NBIT - 1:0] imx_rc0_epc_w;    // combinatorial

    (* keep = "soft" *)
    wire [1:0] unused_rc0_op = {ma_rc0_op[0], wb_rc0_op[0]};

    wire is_irq = rc0_ie != 0 && rc0_ivld && !ma_rc0_op[1] && !wb_rc0_op[1];

    always @(*) begin
        if (is_irq) begin
            irq_rf_we <= 1'b0;
            irq_rc0_op <= `RC0_OP_IRQ;
            irq_rc0_ie_we <= 1'b1;
            irq_rc0_epc_we <= 1'b1;
            irq_wtg_op <= `WTG_OP_IRQ;
            irq_syscall_en <= 1'b0;
            irq_dm_we <= 1'b0;
            imx_rc0_ie_w <= `MUX_RC0_IEW_ZERO;
            imx_rc0_epc_w <= `MUX_RC0_EPCW_PC;
        end
        else begin
            irq_rf_we <= ctl_rf_we;
            irq_rc0_op <= ctl_rc0_op;
            irq_rc0_ie_we <= ctl_rc0_ie_we;
            irq_rc0_epc_we <= ctl_rc0_epc_we;
            irq_wtg_op <= ctl_wtg_op;
            irq_syscall_en <= ctl_syscall_en;
            irq_dm_we <= ctl_dm_we;
            imx_rc0_ie_w <= mux_rc0_ie_w;
            imx_rc0_epc_w <= mux_rc0_epc_w;
        end
    end

endmodule
