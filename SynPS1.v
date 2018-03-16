`timescale 1ns / 1ps
`include "Core.vh"
// Brief: Program Counter, sychronized
// Description: Update program counter
// Author: FluorineDog
module SynPS1(clk, rst_n, en, inst_in, inst, pc_4_in, pc_4);
  input clk;
  input rst_n;  //negedge reset
  input en;     //high enable normal
  input [31:0] inst_in;
  output reg [31:0] inst;
  input [`IM_ADDR_BIT - 1: 0] pc_4_in;
  output [`IM_ADDR_BIT - 1: 0] pc_4;


  always @(posedge clk, negedge rst_n) begin
    if (!rst_n)
      inst <= 0:
      pc_4 <= pc_4_in;
    else
      inst <= inst_in;
    end
endmodule
