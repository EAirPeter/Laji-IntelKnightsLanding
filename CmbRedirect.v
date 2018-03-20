`timescale 1ns / 1ps

`include "Core.vh"

// Brief: memory path selector, combinatorial
// Author: FluorineDog
module CmbRedirect(
    input self_use_en,          // self
    input [4:0] self_w_req,     // self
    input regfile_w_en,         // write_back
    input [4:0] regfile_req_w,  // write_back
    output redirect
);
    assign redirect = 
           self_use_en 
        && regfile_w_en
        && (regfile_req_w == self_w_req)
        && (regfile_req_w != 0);// buggy flag to hide problem
endmodule