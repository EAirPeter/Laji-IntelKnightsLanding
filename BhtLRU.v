`timescale 1ns / 1ps

`include "Core.vh"

// Brief: LRU Algorithm, synchronized, BHT
// Author: EAirPeter
module BhtLRU(clk, rst_n, touch_en, touch_item, lru_item);
    parameter NItem = 8;
    input clk, rst_n, touch_en;
    input [NItem - 1:0] touch_item;
    output [NItem - 1:0] lru_item;
    
    reg [NItem - 1:0] stack[NItem - 1:0];
    wire [NItem - 1:1] hit;

    assign lru_item = stack[NItem - 1];

    generate
        genvar i;
        for (i = 1; i < NItem; i = i + 1) begin
            assign hit[i] = touch_item == stack[i];
        end
        always @(posedge clk, negedge rst_n) begin
            if (!rst_n)
                stack[0] <= 1;
            else if (touch_en)
                stack[0] <= touch_item;
        end
        for (i = 1; i < NItem; i = i + 1) begin
            always @(posedge clk, negedge rst_n) begin
                if (!rst_n)
                    stack[i] <= 1 << i;
                else if (touch_en && hit[NItem - 1:i] != 0)
                    stack[i] <= stack[i - 1];
            end
        end
    endgenerate

endmodule
