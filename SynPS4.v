`timescale 1ns / 1ps
`include "Core.vh"
// Brief: pipeline stage4, sychronized
// Author: FluorineDog
module SynPS4(
    input clk,
    input rst_n,
    input en,       
    input clear,
    input [`IM_ADDR_BIT - 1:0] pc_4_in,
    input [4:0] rt_in,
    input [4:0] rd_in,
    input regfile_w_en_in,
    input [31:0] alu_data_res_in,
    input [31:0] datamem_data_in,
    input [`MUX_RF_REQW_BIT - 1:0] mux_regfile_req_w_in,
    input [`MUX_RF_DATAW_BIT - 1:0] mux_regfile_data_w_in,
    input halt_in,
    output reg [`IM_ADDR_BIT - 1:0] pc_4,
    output reg [4:0] rt,
    output reg [4:0] rd,
    output reg regfile_w_en,
    output reg [31:0] alu_data_res,
    output reg [31:0] datamem_data,
    output reg [`MUX_RF_REQW_BIT - 1:0] mux_regfile_req_w,
    output reg [`MUX_RF_DATAW_BIT - 1:0] mux_regfile_data_w,
    output reg halt
);
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n | !clear) begin 
            pc_4 <= 0;
            rt <= 0;
            rd <= 0;
            regfile_w_en <= 0;
            alu_data_res <= 0;
            datamem_data <= 0;
            mux_regfile_req_w <= 0;
            mux_regfile_data_w <= 0;
            halt <= 0;
        end else if(en) begin
            pc_4 <= pc_4_in;
            rt <= rt_in;
            rd <= rd_in;
            regfile_w_en <= regfile_w_en_in;
            alu_data_res <= alu_data_res_in;
            datamem_data <= datamem_data_in;
            mux_regfile_req_w <= mux_regfile_req_w_in;
            mux_regfile_data_w <= mux_regfile_data_w_in;
            halt <= halt_in;
        end
    end
endmodule
