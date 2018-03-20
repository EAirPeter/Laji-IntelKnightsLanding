`timescale 1ns / 1ps

module IrqISREntr(inum, entr);
    localparam Entr0 = 'h034 >> 2;
    localparam Entr1 = 'h0b4 >> 2;
    localparam Entr2 = 'h134 >> 2;

    input [`NBIT_IRQ - 1:0] inum;
    output reg [`IM_ADDR_NBIT - 1:0] entr;  // combinatorial

    always @(*) begin
        case (inum)
            0:  entr <= Entr0;
            1:  entr <= Entr1;
            2:  entr <= Entr2;
            default:
                entr <= 0;
        endcase
    end
endmodule
