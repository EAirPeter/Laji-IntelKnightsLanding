`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Pipeline Interface
// Author: EAirPeter
module SynPiplIntf(clk, rst_n, en, nop, is_nop_i, data_i, is_nop_o, data_o);
    parameter Bits = 32;
    input clk, rst_n, en, nop;
    input is_nop_i;
    input [Bits - 1:0] data_i;
    output reg is_nop_o;
    output reg [Bits - 1:0] data_o;
    
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            is_nop_o <= 1'b0;
            data_o <= {Bits{1'b0}};
        end
        else if (en) begin
            if (nop) begin
                is_nop_o <= 1'b1;
                data_o <= {Bits{1'b0}};
            end
            else begin
                is_nop_o <= is_nop_i;
                data_o <= data_i;
            end
        end
    end
endmodule
