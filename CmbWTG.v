`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Where To Go, combinatorial
// Description: Compute the value about to be updated into PC
// Author: azure-crab
module CmbWTG(
    input [`WTG_OP_BIT - 1:0] op,
    input [`IM_ADDR_BIT - 1:0] imm,
    input signed [31:0] data_x,
    input signed [31:0] data_y,
    input [`IM_ADDR_BIT - 1:0] pc_4,
    input [`IM_ADDR_BIT - 1:0] pc_guessed,
    output reg [`IM_ADDR_BIT - 1:0] pc_new,
    // True on successful conditional branch
    output reg [`IM_ADDR_BIT - 1:0] pc_remote,
    output reg branched,        
    output pred_succ
);
    assign pred_succ = pc_guessed == pc_new;
    wire [`IM_ADDR_BIT - 1:0] j_addr = imm;
    wire [`IM_ADDR_BIT - 1:0] b_addr = imm + pc_4;

    always @(*) begin
        pc_remote = b_addr;
        case (op)
            `WTG_OP_J32: begin
                branched = 0;
                pc_new = data_x[`IM_ADDR_BIT - 1:0];
                pc_remote = data_x[`IM_ADDR_BIT - 1:0];
            end
            `WTG_OP_J26: begin 
                branched = 0;
                pc_new = j_addr;
                pc_remote = j_addr;
            end
            `WTG_OP_BEQ: begin
                branched = (data_x == data_y);
                pc_new = branched ? b_addr : pc_4;
            end
            `WTG_OP_BNE: begin
                branched = (data_x != data_y);
                pc_new = branched ? b_addr : pc_4;
            end
            `WTG_OP_BLEZ: begin
                branched = (data_x <= 0);                            
                pc_new = branched ? b_addr : pc_4;
            end
            `WTG_OP_BGTZ: begin
                branched = (data_x > 0);
                pc_new = branched ? b_addr : pc_4;
            end
            `WTG_OP_BLTZ: begin
                branched = (data_x < 0);
                pc_new = branched ? b_addr : pc_4;
            end
            `WTG_OP_BGEZ: begin
                branched = (data_x >= 0);
                pc_new = branched ? b_addr : pc_4;
            end
            default: begin
                branched = 0;
                pc_new = pc_4;
            end
        endcase      
    end
endmodule
