`timescale 1ns / 1ps

`include "Core.vh"

// Brief: memory path selector, combinatorial
// Author: FluorineDog
module CmbBubble(
    input self_use_en_1,
    input [4:0] self_use_req_1,        // self
    input self_use_en_2,
    input [4:0] self_use_req_2,     // self
    input mem_read_en,         // write_back
    input [4:0] regfile_req_w,  // write_back
    output bubble
);
    assign bubble = 
           mem_read_en && 
                ((self_use_en_1 
                    && (regfile_req_w == self_use_req_1))
                || (self_use_en_2 
                    && (regfile_req_w == self_use_req_2)));
endmodule