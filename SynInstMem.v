`timescale 1ns / 1ps
`include "Core.vh"

// Brief: Instruction Memory, synchronized
// Description: Fetch instruction from memory
// Author: azure-crab
module SynInstMem(clk, rst_n, addr, inst);
    parameter ProgPath = "F:/Vivado_Projects/benchmark.hex";
    input clk;
    input rst_n;
    input [31:0] addr;
    output [31:0] inst;
    
    reg [31:0] prog[0:1023];
    initial $readmemh(ProgPath, prog);
    assign inst = prog[addr[11:2]];
endmodule
