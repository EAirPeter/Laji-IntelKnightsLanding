`timescale 1ns / 1ps

`include "Auxiliary.vh"

module AuxCounter(clk, rst_n, en, cnt);
    parameter CntBit = 32;
    input clk;
    input rst_n;
    input en;
    output reg [CntBit - 1:0] cnt;

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n)
            cnt <= 'd0;
        else if (en)
            cnt <= cnt + 'd1;
    end
endmodule
