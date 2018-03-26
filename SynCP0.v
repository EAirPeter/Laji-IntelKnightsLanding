`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Co-processor 0, use alike datamem
// Author: FluorineDog
// RF
module SynCP0(
    input clk,
    input rst_n,

    input w_en,
    input [4:0] w_req,
    input [31:0] w_data, 

    // if hidden instruction is coming 
    input epc_w_en,  
    input [`IM_ADDR_BIT - 1: 0] epc_w_data,
   
    input [4:0] r_req, 
    output [31:0] r_data, 

    output intr_en, 
    output [3:0] intr_mask,

    output [`IM_ADDR_BIT-1:0] epc_addr
);

    reg [31:0] cp0_data [31:0];
    assign intr_en = cp0_data[`CP0_STATUS_REQ_NUM][0];
    assign intr_mask = cp0_data[`CP0_STATUS_REQ_NUM][11:8];

    assign r_data = cp0_data[r_req];

    assign epc_addr = cp0_data[`CP0_EPC_REQ_NUM][`IM_ADDR_BIT-1:0];
    always@(posedge clk, negedge rst_n) begin 
        if(!rst_n) begin
            cp0_data[`CP0_EPC_REQ_NUM] <= 32'hff01;
            cp0_data[`CP0_STATUS_REQ_NUM] <= 0;
        end else if(epc_w_en)begin  // store pc here
            cp0_data[`CP0_EPC_REQ_NUM][`IM_ADDR_BIT - 1 : 0] <= epc_w_data;
            cp0_data[`CP0_STATUS_REQ_NUM][0] <= 1'b1;
        end
    end
endmodule