`timescale 1ns / 1ps

`include "Test.vh"

module TbAuxCounter();
    reg clk = 1'b0;
    always #5 clk <= !clk;
    reg rst_n = 1'b0;
    reg en = 1'b0;
    reg ld = 1'b0;
    reg [3:0] val = 4'd11;
    wire [3:0] cnt;
    initial begin
        `cp(1) rst_n = 1'b1;
        `cp(3) en = 1'b1;
        `cp(20) ld = 1'b1;
        `cp(1) ld = 1'b0;
        `cp(14) en = 1'b0;
        `cp(2) en = 1'b0;
        `cp(2) `ns(3) rst_n = 1'b0;
    end
    AuxCounter #(
        .CntBit(4)
    ) vDUT(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .ld(ld),
        .val(val),
        .cnt(cnt)
    );

endmodule
