`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Pipeline Interface
// Author: EAirPeter
module SynPiplIntf(clk, rst_n, en, nop, data_i, data_o);
    parameter Bits = 32;
    input clk, rst_n, en, nop;
    input [Bits - 1:0] data_i;
    output reg [Bits - 1:0] data_o;
    
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n)
            data_o <= {Bits{1'b0}};
        else if (en) begin
            case (nop)
                0:  data_o <= data_i;
                1:  data_o <= {Bits{1'b0}};
            endcase
        end
    end
endmodule
