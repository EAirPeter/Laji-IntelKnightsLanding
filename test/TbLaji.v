`timescale 1ns / 1ps

`include "Test.vh"

module TbLaji();
    reg clk = 1'b1;
    always #5 clk <= !clk;
    reg rst_n = 1'b0;
    reg resume = 1'b0;
    reg [15:0] swt = 16'b11;
    wire [7:0] seg_n;
    wire [7:0] an_n;
    initial begin
        `cp(1) rst_n = 1'b1;
    end
    TopLajiIntelKnightsLanding vDUT(
        .clk(clk),
        .rst_n(rst_n),
        .resume(resume),
        .swt(swt),
        .seg_n(seg_n),
        .an_n(an_n)
    );
endmodule
