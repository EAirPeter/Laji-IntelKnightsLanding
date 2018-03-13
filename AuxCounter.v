`timescale 1ns / 1ps

// Brief: Binary Counter, synchronized, auxiliary
// Author: EAirPeter
module AuxCounter(clk, rst_n, en, ld, val, cnt);
    parameter CntBit = 32;
    input clk;
    input rst_n;
    input en;
    input ld;
    input [CntBit - 1:0] val;
    output reg [CntBit - 1:0] cnt;

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n)
            cnt <= 'd0;
        else if (ld)
            cnt <= val;
        else if (en)
            cnt <= cnt + 'd1;
    end
endmodule
