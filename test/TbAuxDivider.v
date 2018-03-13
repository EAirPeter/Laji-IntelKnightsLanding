`timescale 1ns / 1ps

`include "Test.vh"

module TbAuxDivider();
    reg clk = 1'b0;
    always #5 clk <= !clk;
    reg rst_n = 1'b0;
    wire clk_out;
    initial begin
        `cp(1) rst_n = 1'b1;
    end
    AuxDivider #(
        .CntMax(5)
    ) vDUT(
        .clk(clk),
        .rst_n(rst_n),
        .clk_out(clk_out)
    );
endmodule
