`timescale 1ns / 1ps
`include "Core.vh"
// Brief: Program Counter, sychronized
// Description: Update program counter
// Author: FluorineDog
module SynPC(clk, rst_n, en, pc_new, pc, pc_4);
    input clk;
    input rst_n;  //negedge reset
    input en;     //high enable normal
    input [`IM_ADDR_BIT - 1:0] pc_new;
    output reg [`IM_ADDR_BIT - 1:0] pc;
    output [`IM_ADDR_BIT - 1:0] pc_4;

    assign pc_4 = pc + 1;

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n)
   		    pc = 0;
   	    else if (en)
   		    pc = pc_new;
    end
endmodule
