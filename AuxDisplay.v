`timescale 1ns / 1ps

`include "Auxiliary.vh"

module AuxDisplay(clk, rst_n, data, seg_n, an_n);
    parameter ScanCntMax = `CNT_MILLISEC(1);
    input clk;
    input rst_n;
    input [31:0] data;
    output reg [7:0] seg_n; // combinatorial
    output [7:0] an_n;

    assign an_n = 8'b0;

    wire [3:0] value[7:0];
    assign value[7] = data[31:28];
    assign value[6] = data[27:24];
    assign value[5] = data[23:20];
    assign value[4] = data[19:16];
    assign value[3] = data[15:12];
    assign value[2] = data[11:8];
    assign value[1] = data[7:4];
    assign value[0] = data[3:0];

    wire [3:0] current = value[ctr_cnt];
    always @(*) begin
        case (current)
            'h0: seg_n <= 'b11000000;
            'h1: seg_n <= 'b11111001;
            'h2: seg_n <= 'b10100100;
            'h3: seg_n <= 'b10110000;
            'h4: seg_n <= 'b10011001;
            'h5: seg_n <= 'b10010010;
            'h6: seg_n <= 'b10000010;
            'h7: seg_n <= 'b11111000;
            'h8: seg_n <= 'b10000000;
            'h9: seg_n <= 'b10010000;
            'ha: seg_n <= 'b10001000;
            'hb: seg_n <= 'b10000011;
            'hc: seg_n <= 'b11000110;
            'hd: seg_n <= 'b10100001;
            'he: seg_n <= 'b10000110;
            'hf: seg_n <= 'b10001110;
        endcase
    end

    wire ctr_clk;
    wire [2:0] ctr_cnt;

    AuxDivider #(
        .CntMax(ScanCntMax)
    ) vDiv(
        .clk(clk),
        .rst_n(rst_n),
        .clk_out(ctr_clk)
    );
    AuxCounter #(
        .CntBit(3)
    ) vCtr(
        .clk(ctr_clk),
        .rst_n(rst_n),
        .en(1'b1),
        .ld(1'b0),
        .val(3'b0),
        .cnt(ctr_cnt)
    );
endmodule
