`timescale 1ns / 1ps
`include "Core.vh"

// Brief: Instruction Decoder, combinatorial
// Author: FluorineDog
module CmbDecoder(inst, opcode, rs, rt, rd, shamt, funct, imm16, imm26);
    input [31:0] inst;
    output [5:0] opcode;
    output [4:0] rs;
    output [4:0] rt;
    output [4:0] rd;
    output [4:0] shamt;
    output [5:0] funct;
    output [15:0] imm16;
    output [25:0] imm26;
		
		assign opcode[5:0] = inst[31:26];
		assign rs[4:0] = inst[25:21];
		assign rt[4:0] = inst[20:16];
		assign rd[4:0] = inst[15:11];
		assign shamt[4:0] = inst[10:6];
		assign funct[5:0] = inst[5:0];
		assign imm16[15:0] = inst[15:0];
		assign imm26[25:0] = inst[25:0];
endmodule
