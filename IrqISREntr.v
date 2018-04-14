`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Interrupt Service Routing Entrance, combinatorial, interrupt
// Author: EAirPeter
module IrqISREntr(inum, entr);
    localparam Entr0 = 'h48c >> 2;
    localparam Entr1 = 'h50c >> 2;
    localparam Entr2 = 'h58c >> 2;

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
