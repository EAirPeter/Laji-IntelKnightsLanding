`timescale 1ns / 1ps
`include "Core.vh"

module CmbExt(imm16, out_sign, out_zero);
    input [15:0] imm16;
    output reg [31:0] out_sign;
    output reg [31:0] out_zero;
    
    always @ (*)
    begin
        out_zero <= {16'h0,imm16};
        out_sign <= {{16{imm16[15]}},imm16};
    end

endmodule