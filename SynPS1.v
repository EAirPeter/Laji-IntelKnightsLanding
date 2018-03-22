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
    input [`IM_ADDR_BIT - 1:0] pc_guessed_in,
    input [1:0] bht_state_in,
    output reg [`IM_ADDR_BIT - 1:0] pc_4,
    output reg [31:0] inst,
    output reg [`IM_ADDR_BIT - 1:0] pc_guessed,
    output reg [1:0] bht_state
);
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin 
            pc_4 <= 0;
            inst <= 0;
            pc_guessed <= 0;
            bht_state <= 0;
        end else if(clear) begin
            pc_4 <= 0;
            inst <= 0;
            pc_guessed <= 0;
            bht_state <= 0;
        end else if(en) begin
            pc_4 <= pc_4_in;
            inst <= inst_in;
            pc_guessed <= pc_guessed_in;
            bht_state <= bht_state_in;
        end
    end
endmodule
