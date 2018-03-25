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

    input epc_w_en, 
    input [`IM_ADDR_BIT - 1: 0] epc_w_data,
   
    input [4:0] r_req, 
    output [31:0] r_data, 

    output intr_en, 
    output [3:0] intr_mask
);

    reg [31:0] cp0_data [31:0];
    assign intr_en = cp0_data[`CP0_STATUS_REQ_NUM][0];
    assign intr_mask = cp0_data[`CP0_STATUS_REQ_NUM][11:8];

    assign final_w_en = w_en | epc_w_en;
    assign final_w_req = (epc_w_en ? `CP0_EPC_REQ_NUM: w_req);
    assign final_w_data = (epc_w_en ? epc_w_data: w_data);

    always@(posedge clk, negedge rst_n) begin 
        if(!rst_n) begin
            ;
        end else begin
            if(final_w_en) begin
                cp0_data[final_w_req] <= final_w_data;
            end
        end
    end
endmodule
