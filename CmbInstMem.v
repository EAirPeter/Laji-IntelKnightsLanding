`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Instruction Memory, combinatorial
// Description: Fetch instruction from memory
// Author: azure-crab
module CmbInstMem(addr, inst);
    parameter ProgPath = "F:/Vivado_Projects/benchmark.hex";
    input [`IM_ADDR_BIT - 1:0] addr;
    output [31:0] inst;
    
    reg [31:0] prog[0:1 << `IM_ADDR_BIT];
    initial $readmemh(ProgPath, prog);
    assign inst = prog[addr];
endmodule
