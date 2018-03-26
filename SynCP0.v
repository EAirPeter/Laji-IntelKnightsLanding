`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Co-processor 0, use alike datamem
// Author: FluorineDog
// RF
module SynCP0(
    input clk,
    input rst_n,

    // if mtc0 is issued
    input w_en,
    input [4:0] w_req,
    input [31:0] w_data, 

    // if hidden instruction is coming 
    input epc_w_en,  
    input [`IM_ADDR_BIT - 1: 0] epc_w_data,
    
    // if eret is coming
    input is_eret,
   
    input [4:0] r_req, 
    output [31:0] r_data, 

    output intr_en, 
    output [3:0] intr_mask,

    output [`IM_ADDR_BIT-1:0] epc_addr
);

    wire[15:0] dbg_epc_addr = {epc_addr,2'b0};
    reg [31:0] cp0_data [31:0];
    assign intr_en = cp0_data[`CP0_STATUS_REQ_NUM][0];
    assign intr_mask = cp0_data[`CP0_STATUS_REQ_NUM][11:8];

    assign r_data = cp0_data[r_req];

    assign checker = {1'b0, w_en} + {1'b0, epc_w_en} + {1'b0, is_eret};

    assign epc_addr = cp0_data[`CP0_EPC_REQ_NUM][`IM_ADDR_BIT-1:0];
    integer i;
    always@(posedge clk, negedge rst_n) begin 
        if(!rst_n) begin
            for(i=0; i < 32; i=i+1) begin
                cp0_data[i] <= (`CP0_STATUS_REQ_NUM == i)? 32'hff01:32'hcccc;
            end
        end else if(epc_w_en)begin  
            // i ready to jmp 
            // store pc here
            cp0_data[`CP0_EPC_REQ_NUM][`IM_ADDR_BIT - 1 : 0] <= epc_w_data;
            cp0_data[`CP0_STATUS_REQ_NUM][0] <= 0;
        end else if(w_en) begin
            cp0_data[w_req] <= w_data;
        end else if(is_eret) begin
            cp0_data[`CP0_STATUS_REQ_NUM][0] <= 1;
        end
    end
endmodule