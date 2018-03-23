`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Interrupt Device, 
//        generate necessary subroutining control info
// Author: FluorineDog
module SynIntrDevice(
    input clk, 
    input rst_n,
    input intr_en,
    input [3:0] device_request, // outer
    output interrupt_jump,
    output [`IM_ADDR_BIT-1:0] interrupt_jump_addr
); 
    
endmodule
