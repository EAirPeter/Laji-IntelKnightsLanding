`timescale 1ns / 1ps

`include "Core.vh"

// Brief: memory path selector, combinatorial
// Author: FluorineDog
module CmbRedirectMem(
    input datamem_w_en,     // self
    input [4:0] rt,               // self
    input regfile_w_en,     // mem
    input [4:0] regfile_req_w,    // mem
    output redirect
);
    assign redirect = 
           datamem_w_en 
        && regfile_w_en
        && (rt == regfile_req_w);
endmodule