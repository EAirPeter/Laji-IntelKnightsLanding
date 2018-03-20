`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Where To Go, combinatorial
// Description: Compute the value about to be updated into PC
// Author: azure-crab
module CmbWTG(op, imm, inum, epc, data_x, data_y, pc_4, pc_new, pc_branch, branched);
    input [`WTG_OP_NBIT - 1:0] op;
    input [`IM_ADDR_NBIT - 1:0] imm;
    input [`NBIT_IRQ - 1:0] inum;
    input [31:0] epc;
    input signed [31:0] data_x;
    input signed [31:0] data_y;
    input [`IM_ADDR_NBIT - 1:0] pc_4;
    output reg [`IM_ADDR_NBIT - 1:0] pc_new;
    output reg [`IM_ADDR_NBIT - 1:0] pc_branch;
    output reg branched;        // True on successful conditional branch

    (* keep = "soft" *)
    wire [31 - `IM_ADDR_NBIT:0] unused_epc = {epc[31:`IM_ADDR_NBIT + 2], epc[1:0]};

    wire [`IM_ADDR_NBIT - 1:0] j_addr = imm;
    wire [`IM_ADDR_NBIT - 1:0] b_addr = imm + pc_4;
    wire [`IM_ADDR_NBIT - 1:0] i_addr;

    always @(*) begin
        case (op)
            `WTG_OP_NOP: begin
                branched = 0;
                pc_new = pc_4;
                pc_branch = b_addr;
            end
            `WTG_OP_J32: begin
                branched = 0;
                pc_new = data_x[`IM_ADDR_NBIT + 1:2];
                pc_branch = j_addr;
            end
            `WTG_OP_J26: begin 
                branched = 0;
                pc_new = j_addr;
                pc_branch = j_addr;
            end
            `WTG_OP_BEQ: begin
                branched = (data_x == data_y);
                pc_new = branched ? b_addr : pc_4;
                pc_branch = b_addr;
            end
            `WTG_OP_BNE: begin
                branched = (data_x != data_y);
                pc_new = branched ? b_addr : pc_4;
                pc_branch = b_addr;
            end
            `WTG_OP_BGEZ: begin
                branched = (data_x >= 0);
                pc_new = branched ? b_addr : pc_4;
                pc_branch = b_addr;
            end
            `WTG_OP_IRQ: begin
                branched = 0;
                pc_new = i_addr;
                pc_branch = b_addr;
            end
            `WTG_OP_IRET: begin
                branched = 0;
                pc_new = epc[`IM_ADDR_NBIT + 1:2];
                pc_branch = b_addr;
            end
        endcase      
    end

    IrqISREntr vIsrEntr(
        .inum(inum),
        .entr(i_addr)
    );
endmodule
