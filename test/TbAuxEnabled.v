`timescale 1ns / 1ps

`include "Test.vh"

module TbAuxEnabled();
    reg clk = 1'b0;
    always #5 clk <= !clk;
    reg rst_n = 1'b0;
    reg resume = 1'b0;
    reg halt = 1'b0;
    wire en;
    initial begin
        `cp(1) rst_n = 1'b1;
        `cp(12) halt = 1'b1;
        `cp(1) halt = 1'b0;
        `cp(4) resume = 1'b1;
        `cp(1) resume = 1'b0;
    end
    AuxEnabled vDUT(
        .clk(clk),
        .rst_n(rst_n),
        .resume(resume),
        .halt(halt),
        .en(en)
    );
endmodule
