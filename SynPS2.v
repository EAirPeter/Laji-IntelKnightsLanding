`timescale 1ns / 1ps
`include "Core.vh"
// Brief: pipeline stage1, sychronized
// Description: forward between IF/ID
// main work: pc+4, inst
// Author: FluorineDog
module SynPS2(
    input clk,
    input rst_n,    //negedge reset
    input en,         //high enable normal
    input [31:0] inst_in,
    input [`IM_ADDR_BIT - 1: 0] pc_4_in,
    output reg [31:0] inst,
    output reg [`IM_ADDR_BIT - 1: 0] pc_4
);

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin 
            inst <= 0;
            pc_4 <= 0;
        end else begin
            inst <= inst_in;
            pc_4 <= pc_4_in;
        end
    end
endmodule
