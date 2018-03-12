`timescale 1ns / 1ps

`include "Auxiliary.vh"

module AuxDivider(clk, rst_n, clk_out);
    function integer Log2Ceil(input time cnt_max);
        for (Log2Ceil = 0; cnt_max; Log2Ceil = Log2Ceil + 1)
            cnt_max = cnt_max >> 1;
    endfunction
    parameter CntMax = `CNT_MILLISEC(500);
    localparam CntBit = Log2Ceil(CntMax);

    input clk;
    input rst_n;
    output reg clk_out = 'b0;
    
    reg [CntBit - 1:0] cnt = 'd0;

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            clk_out <= 'b0;
            cnt <= 'd0;
        end
        else if (cnt == CntMax - 'd1) begin
            clk_out <= ~clk_out;
            cnt <= 'd0;
        end
        else
            cnt <= cnt + 'd1;
    end
endmodule
