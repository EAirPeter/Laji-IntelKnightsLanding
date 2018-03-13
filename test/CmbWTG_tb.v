`timescale 1ns / 1ps
`include "Core.vh"

// Brief: Where To Go, combinatorial
// Description: Compute the value about to be updated into PC
// Author: azure-crab
module CmbWTG_tb();
    reg [`WTG_OP_BIT - 1:0] op;
    reg [31:0] off32;
    reg [25:0] imm26;
    reg [31:0] data_x;
    reg [31:0] data_y;
    reg [31:0] pc_4;
    wire [31:0] pc_new;
    wire branched;        // True on successful conditional branch

    CmbWTG tb(op, off32, imm26, data_x, data_y, pc_4, pc_new, branched);
    initial begin
        pc_4 <= 'h1000;
        off32 <= 'h1000; 
        #50;
        op <= `WTG_OP_J32;
        data_x <= 'h80001000;

        #50;
        op <= `WTG_OP_J26;
        imm26 <= 'h8086;

        #50;
        op <= `WTG_OP_BEQ;
        data_x <= 1000;
        data_y <= 1001;

        #5;
        data_x <= 10000;
        data_y <= 10000;

        #50;
        op <= `WTG_OP_BNE;
        data_x <= 'h1000;
        data_y <= 'h1001;
        #5; 
        data_x <= 'h2000;
        data_y <= 'h2000;

        #50;
        op = `WTG_OP_BLEZ;
        data_x <= -1;
        #5;
        data_x <= 0;
        #5;
        data_x <= 1;

        #50;
        op = `WTG_OP_BGTZ;
        data_x <= -1;
        #5;
        data_x <= 0;
        #5;
        data_x <= 1;

        #50;
        op = `WTG_OP_BLTZ;
        data_x <= -1;        
        #5;
        data_x <= 0;
        #5;
        data_x <= 1;

        #50;
        op = `WTG_OP_BGEZ;
        data_x <= -1;
        #5;
        data_x <= 0;
        #5;
        data_x <= 1;
    end
endmodule
