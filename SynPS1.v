`timescale 1ns / 1ps
`include "Core.vh"
// Brief: pipeline stage1, sychronized
// Author: FluorineDog
module SynPS1(
    input clk,
    input rst_n,
    input en,       
    input clear,
    input [`IM_ADDR_BIT - 1:0] pc_4_in,
    input [31:0] inst_in,
    output reg [`IM_ADDR_BIT - 1:0] pc_4,
    output reg [31:0] inst
);
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n | !clear) begin 
            pc_4 <= 0;
            inst <= 0;
        end else if(en) begin
            pc_4 <= pc_4_in;
            inst <= inst_in;
        end
    end
endmodule
