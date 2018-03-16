`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Program Counter, sychronized
// Description: Update program counter
// Author: G-H-Y
module SynPC(clk, rst_n, en, ld, pc_new, pc, pc_4);
    input clk, rst_n, en;
    input ld;
    input [`IM_ADDR_BIT - 1:0] pc_new;
    output reg [`IM_ADDR_BIT - 1:0] pc;
    output [`IM_ADDR_BIT - 1:0] pc_4;

    assign pc_4 = pc + 1;
    wire [`IM_ADDR_BIT - 1:0] pc_next = ld ? pc_new : pc_4;

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n)
   		    pc <= 0;
   	    else if (en)
   		    pc <= pc_next;
    end
endmodule
