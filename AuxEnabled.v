`timescale 1ns / 1ps

`include "Auxiliary.vh"

module AuxEnabled(clk, rst_n, resume, halt, en);
    input clk, rst_n, resume, halt;
    output reg en;

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n)
            en = 1'b1;
        else if (resume)
            en = 1'b1;
        else if (halt)
            en = 1'b0;
    end
endmodule
