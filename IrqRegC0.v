`timescale 1ns / 1ps

`include "Core.vh"

// Brief: C0 Registers, synchronized, interrupt
// Author: EAirPeter
// Descrption: IR, IRS, IE, EPC registers
module IrqRegC0(
    clk, rst_n, en, op,
    ie_we, epc_we, ie_w, epc_w, irq_src,
    ie, epc, ivld, inum
);
    input clk, rst_n, en;
    input [`RC0_OP_NBIT - 1:0] op;
    input ie_we, epc_we;
    input [31:0] ie_w, epc_w;
    input [`NIRQ - 1:0] irq_src;
    output reg [31:0] ie;
    output reg [31:0] epc;
    output ivld;                            // combinatorial
    output reg [`NBIT_IRQ - 1:0] inum;      // combinatorial

    reg [`NIRQ - 1:0] ir, irs;
    reg [`NIRQ - 1:0] irm, irsm_n, imask;   // combinatorial
    wire [`NIRQ - 1:0] ivld_tmp = ir & imask;
    
    assign ivld = |ivld_tmp;

    integer i;

    always @(*) begin
        inum = 0;
        irm = 0;
        irsm_n = {`NIRQ{1'b1}};
        imask = {`NIRQ{1'b1}};
        for (i = 0; i < `NIRQ; i = i + 1)
            if (irs[i]) begin
                irsm_n = ~(`NIRQ'b1 << i);
                imask = ~(((`NIRQ'b1 << i) - 1) | (`NIRQ'b1 << i));
            end
        for (i = 0; i < `NIRQ; i = i + 1)
            if (ivld_tmp[i]) begin
                inum = i;
                irm = 1 << i;
            end
    end

    always @(negedge clk, negedge rst_n) begin
        if (!rst_n) begin
            ie <= 32'b1;
            ir <= `NIRQ'b0;
            irs <= `NIRQ'b0;
        end
        else if (en) begin
            if (ie_we)
                ie <= ie_w;
            case (op)
                `RC0_OP_IRQ: begin
                    ir <= ir | irq_src;
                    irs <= irs | irm;
                end
                `RC0_OP_RET: begin
                    ir <= ir & irsm_n;
                    irs <= irs & irsm_n;
                end
                default:
                    ir <= ir | irq_src;
            endcase
        end
    end

    always @(negedge clk) begin
        if (en) begin
            if (epc_we)
                epc <= epc_w;
        end
    end
endmodule
