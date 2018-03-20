`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Pipeline Interface
// Author: EAirPeter
module SynPiplIntf(clk, rst_n, en, nop, data_i, data_o);
    parameter NBit = 32;
    input clk, rst_n, en, nop;
    input [NBit - 1:0] data_i;
    output reg [NBit - 1:0] data_o;
    
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n)
            data_o <= {NBit{1'b0}};
        else if (en) begin
            data_o <= nop ? {NBit{1'b0}} : data_i;
        end
    end
endmodule
