`timescale 1ns / 1ps

// Brief: Bit Extender, combinatorial
// Author: cuishaobo
module CmbExt(imm16, out_sign, out_zero);
    input [15:0] imm16;
    output [31:0] out_sign;
    output [31:0] out_zero;
    
    assign out_zero = {16'h0, imm16};
    assign out_sign = {{16{imm16[15]}}, imm16};
endmodule
