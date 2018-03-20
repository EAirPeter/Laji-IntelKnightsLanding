`timescale 1ns / 1ps

`include "Test.vh"

module TbLaji();
    reg clk = 1'b1;
    always #5 clk <= !clk;
    reg rst_n = 1'b0;
    reg resume = 1'b0;
    reg [15:0] swt = 16'b11;
    reg [2:0] btn = 3'b000;
    wire [7:0] seg_n;
    wire [7:0] an_n;
    initial begin
        `cp(1) rst_n = 1'b1;
        `cp(4000) resume = 1'b1;
        `cp(1) resume = 1'b0;
        `cp(1000) resume = 1'b1;
        `cp(1) resume = 1'b0;
        `cp(1000) resume = 1'b1;
        `cp(1) resume = 1'b0;
        `cp(1000) resume = 1'b1;
        `cp(1) resume = 1'b0;
        `cp(1000) resume = 1'b1;
        `cp(1) resume = 1'b0;
    end
    initial begin
        `cp(22) btn[0] = 1'b1;
        `cp(40) btn[2] = 1'b1;
        `cp(250) btn[0] = 1'b0;
    end
    TopLajiIntelKnightsLanding vDUT(
        .clk(clk),
        .rst_n(rst_n),
        .resume(resume),
        .swt(swt),
        .btn(btn),
        .seg_n(seg_n),
        .an_n(an_n)
    );
endmodule
