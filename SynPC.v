`timescale 1ns / 1ps

// Brief: Program Counter, sychronized
// Description: Update program counter
// Author: G-H-Y
module SynPC(clk, rst_n, en, pc_new, pc, pc_4);
    input clk;
    input rst_n;  //negedge reset
    input en;     //high enable normal
    input [31:0] pc_new;
    output [31:0] pc;
    output [31:0] pc_4;

    reg [9:0] pc_simp;
    wire pc_4_simp = pc_simp + 1;

    assign pc = {20{1'b0}, pc_simp, 2{1'b0}};
    assign pc_4 = {20{1'b0}, pc_4_simp, 2{1'b0}};

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n)
   		    pc_simp = 0;
   	    else if (en)
   		    pc_simp = pc_new[11:2];
    end
endmodule
