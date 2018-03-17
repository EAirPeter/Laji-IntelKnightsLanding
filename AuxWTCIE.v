`timescale 1ns / 1ps

// Brief: Whether The Core Is Enabled, synchronized, auxiliary
// Author: EAirPeter
module AuxWTCIE(clk, rst_n, resume, halt, en);
    input clk, rst_n, resume, halt;
    output reg en;

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n)
            en <= 1'b1;
        else if (resume)
            en <= 1'b1;
        else if (halt)
            en <= 1'b0;
    end
endmodule
