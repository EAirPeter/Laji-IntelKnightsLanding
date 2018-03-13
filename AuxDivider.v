`timescale 1ns / 1ps

`include "Auxiliary.vh"

module AuxDivider(clk, rst_n, clk_out);
    function integer Log2Ceil(input time cnt_max);
        for (Log2Ceil = 0; cnt_max; Log2Ceil = Log2Ceil + 1)
            cnt_max = cnt_max >> 1;
    endfunction
    parameter CntMax = `CNT_SEC(1);
    parameter CntHalf = CntMax / 2;
    localparam CntBit = Log2Ceil(CntMax);

    input clk;
    input rst_n;
    output reg clk_out;
    
    wire [CntBit - 1:0] ctr_cnt;
    wire ctr_ld = ctr_cnt == CntMax - 'd1;

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n)
            clk_out <= 1'b0;
        else if (ctr_ld)
            clk_out <= !clk_out;
    end

    AuxCounter #(
        .CntBit(CntBit)
    ) vCtr(
        .clk(clk),
        .rst_n(rst_n),
        .en(1'b1),
        .ld(ctr_ld),
        .val({CntBit{1'b0}}),
        .cnt(ctr_cnt)
    );
endmodule
