`timescale 1ns / 1ps
`include "Core.vh"

// Brief: Where To Go, combinatorial
// Description: Compute the value about to be updated into PC
// Author: azure-crab
module CmbWTG_tb();
    reg [`WTG_OP_BIT - 1:0] ops[0:7];
    reg [31:0] off32s[0:3];
    reg [25:0] imm26s[0:1];
    reg [31:0] data_xs[0:3];
    reg [31:0] data_ys[0:3];
    reg [31:0] pc_4s[0:3];
    wire [31:0] pc_new;
    wire branched;        // True on successful conditional branch
    integer a = 0;
    integer b = 0;
    integer c = 0;
    integer d = 0;
    integer e = 0;
    integer f = 0;

    reg [`WTG_OP_BIT - 1:0] op;
    reg [31:0] off32;
    reg [25:0] imm26;
    reg [31:0] data_x;
    reg [31:0] data_y;
    reg [31:0] pc_4;
    CmbWTG tb(op, off32, imm26, data_x, data_y, pc_4, pc_new, branched);
    initial begin
        op[0] = `WTG_OP_J32;
        op[1] = `WTG_OP_J26;
        op[2] = `WTG_OP_BEQ;
        op[3] = `WTG_OP_BNE;
        op[4] = `WTG_OP_BLEZ;
        op[5] = `WTG_OP_BGTZ;
        op[6] = `WTG_OP_BLTZ;
        op[7] = `WTG_OP_BGEZ;
        off32s[0] = 'h12ff315a;
        off32s[1] = 'h25a9c201;
        off32s[2] = 'h549201bb;
        off32s[3] = 'h5728910a;
        imm26s[0] = 26'b10001001001101001010010010;
        imm26s[1] = 26'b01110101110100110100101011;
        data_xs[0] = -1;
        data_xs[1] = 0;
        data_xs[2] = 1;
        data_xs[3] = 257;
        data_ys[0] = -2;
        data_ys[1] = 3;
        data_ys[2] = 0;
        data_ys[3] = 255;
        pc_4s[0] = 124;
        pc_4s[1] = 32768;
        pc_4s[2] = ‭138413344‬;
        pc_4s[3] = 1440;
        for ( ; a < 8 ; a = a + 1) begin
            for (; b < 4; b = b + 1) begin
                for (; c < 2; c = c + 1) begin
                    for (; d < 4; d = d + 1) begin
                        for (; e < 4; e = e + 1) begin
                            for (; f < 4; f = f + 1) begin
                                #5 op <= ops[a];
                                off32 <= off32s[b];
                                imm26 <= imm26s[c];
                                data_x <= data_xs[d];
                                data_y <= data_ys[e];
                                pc_4 <= pc_4s[f];
                            end
                        end
                    end
                end
            end
        end
    end
endmodule
