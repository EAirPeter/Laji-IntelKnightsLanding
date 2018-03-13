`timescale 1ns / 1ps

// Brief: Program Counter, sychronized
// Description: Update program counter
// Author: G-H-Y
module SynPC(clk, rst_n, en, pc_new, pc, pc_4);
    input clk;
    input rst_n;  //negedge reset
    input en;     //high enable normal
    input [31:0] pc_new;
    output reg [31:0] pc;
    output [31:0] pc_4;

    assign pc_4 = pc + 4;

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n)
   		    pc = 0;
   	    else if (en)
   		    pc = pc_new;
    end
endmodule
