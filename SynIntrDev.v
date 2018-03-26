`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Interrupt Device, 
//        generate necessary subroutining control info
// Author: FluorineDog
module SynIntrDevice(
    input clk, 
    input rst_n,

    input intr_en,
    input [3:0] intr_mask,
    input [3:0] device_request, // outer
    input eret_clear_en,

    output intr_jmp,
    output [`IM_ADDR_BIT-1:0] intr_jmp_addr 
); 
    reg [3:0] device_in_queue;
    reg [1:0] highest_req;
    integer i;
    always @(*) begin
        highest_req = 0;
        for( i = 0; i < 4; i=i+1) begin
            if(device_request[i])begin
                highest_req = i;
            end
        end
    end
    always@(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            device_in_queue <= 0;
        end 
        else if(eret_clear_en) begin 
            device_in_queue[highest_req] <= 0;
        end else begin
            device_in_queue <= (device_request | device_in_queue);
        end
    end 
    assign intr_jmp = intr_en && (|(intr_mask & device_in_queue));
    assign intr_jmp_addr = `INTERRUPT_VECTOR_TOP_DIV4 + highest_req * 4;
endmodule
