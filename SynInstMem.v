`timescale 1ns / 1ps
`include "Core.vh"

// Brief: Instruction Memory, synchronized
// Description: Fetch instruction from memory
// Author: azure-crab
module SynInstMem(clk, rst_n, addr, inst);
    input clk;
    input rst_n;
    input [31:0] addr;
    output [31:0] inst;
    reg [31:0] prog[1023:0];
    parameter prog_path = "F:/Vivado_Projects/benchmark.hex";    
    initial $readmemh(prog_path, prog);
    
    assign inst = prog[addr[11:2]];
endmodule
