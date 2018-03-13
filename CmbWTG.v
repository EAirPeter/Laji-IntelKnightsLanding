`timescale 1ns / 1ps
`include "Core.vh"

// Brief: Where To Go, combinatorial
// Description: Compute the value about to be updated into PC
// Author: azure-crab
module CmbWTG(op, off32, imm26, data_x, data_y, pc_4, pc_new, branched);
    input [`WTG_OP_BIT - 1:0] op;
    input [31:0] off32;
    input [25:0] imm26;
    input signed [31:0] data_x;
    input signed [31:0] data_y;
    input [31:0] pc_4;
    output reg [31:0] pc_new;
    output reg branched;        // True on successful conditional branch

    wire [31:0] j_addr = {pc_4[31:28], imm26, 2'b00};
    wire [31:0] b_addr = {off32[29:0], 2'b00} + pc_4;

    always @(*) begin
        case (op)
            `WTG_OP_J32 : begin
                branched = 0;
                pc_new = data_x;
            end
            `WTG_OP_J26 : begin 
                branched = 0;
                pc_new = j_addr;
            end
            `WTG_OP_BEQ : begin
                branched = (data_x == data_y);
                pc_new = branched ? b_addr : pc_4;
            end
            `WTG_OP_BNE : begin
                branched = (data_x != data_y);
                pc_new = branched ? b_addr : pc_4;
            end
            `WTG_OP_BLEZ : begin
                branched = (data_x <= 0);                            
                pc_new = branched ? b_addr : pc_4;
            end
            `WTG_OP_BGTZ : begin
                branched = (data_x > 0);
                pc_new = branched ? b_addr : pc_4;
            end
            `WTG_OP_BLTZ : begin
                branched = (data_x < 0);
                pc_new = branched ? b_addr : pc_4;
            end
            `WTG_OP_BGEZ : begin
                branched = (data_x >= 0);
                pc_new = branched ? b_addr : pc_4;
            end
            default : begin
                branched = 0;
                pc_new = pc_4;
            end
        endcase      
    end
endmodule