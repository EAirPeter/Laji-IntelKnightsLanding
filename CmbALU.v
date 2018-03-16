`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Arithmetic Logic Unit, combinatorial
// Author: KailinLi
module CmbALU(op, data_x, data_y, shamt, data_res);
    input [`ALU_OP_BIT - 1:0] op;
    input [31:0] data_x;
    input [31:0] data_y;
    input [4:0] shamt;      // Separate input for shift 
    output reg [31:0] data_res;

    always @(*) begin
        case (op)
            `ALU_OP_AND:
                data_res <= (data_x & data_y);
            `ALU_OP_OR:
                data_res <= (data_x | data_y);
            `ALU_OP_XOR:
                data_res <= (data_x ^ data_y);
            `ALU_OP_NOR:
                data_res <= ~(data_x | data_y);
            `ALU_OP_ADD:
                data_res <= (data_x + data_y);
            `ALU_OP_SUB:
                data_res <= (data_x - data_y);
            `ALU_OP_SLLV:
                data_res <= (data_y << data_x[4:0]);
            `ALU_OP_SLL:
                data_res <= (data_y << shamt);
            `ALU_OP_SRA:
                data_res <= $unsigned(($signed(data_y) >>> shamt));
            `ALU_OP_SRL:
                data_res <= (data_y >> shamt);
            `ALU_OP_SLT:
                data_res <= ($signed(data_x) < $signed(data_y));
            `ALU_OP_SLTU:
                data_res <= (data_x < data_y);
            `ALU_OP_LUI:
                data_res <= (data_y << 'd16);
            default:
                data_res <= 32'd0;
        endcase
    end
endmodule
