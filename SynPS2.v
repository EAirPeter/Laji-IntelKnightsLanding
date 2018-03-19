`timescale 1ns / 1ps
`include "Core.vh"
// Brief: pipeline stage2, sychronized
// Author: FluorineDog
module SynPS2(
    input clk,
    input rst_n,
    input en,       
    input [15:0] imm16_in,
    input [31:0] regfile_data_a_in,
    input [31:0] regfile_data_b_in,
    input [4:0] rd_in,
    input [4:0] rt_in,
    input [4:0] shamt_in,
    input [`ALU_OP_BIT - 1:0] alu_op_in,
    input [`DM_OP_BIT - 1:0] datamem_op_in,
    input [`IM_ADDR_BIT - 1:0] pc_4_in,
    input [`MUX_ALU_DATAY_BIT - 1:0] mux_alu_data_y_in,
    input [`MUX_RF_DATAW_BIT - 1:0] mux_regfile_data_w_in,
    input [`MUX_RF_REQW_BIT - 1:0] mux_regfile_req_w_in,
    input [`WTG_OP_BIT - 1:0] wtg_op_in,
    input datamem_w_en_in,
    input regfile_w_en_in,
    input syscall_en_in,
    output reg [15:0] imm16,
    output reg [31:0] regfile_data_a,
    output reg [31:0] regfile_data_b,
    output reg [4:0] rd,
    output reg [4:0] rt,
    output reg [4:0] shamt,
    output reg [`ALU_OP_BIT - 1:0] alu_op,
    output reg [`DM_OP_BIT - 1:0] datamem_op,
    output reg [`IM_ADDR_BIT - 1:0] pc_4,
    output reg [`MUX_ALU_DATAY_BIT - 1:0] mux_alu_data_y,
    output reg [`MUX_RF_DATAW_BIT - 1:0] mux_regfile_data_w,
    output reg [`MUX_RF_REQW_BIT - 1:0] mux_regfile_req_w,
    output reg [`WTG_OP_BIT - 1:0] wtg_op,
    output reg datamem_w_en,
    output reg regfile_w_en,
    output reg syscall_en
);
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin 
            alu_op <= 0;
            datamem_op <= 0;
            datamem_w_en <= 0;
            imm16 <= 0;
            mux_alu_data_y <= 0;
            mux_regfile_data_w <= 0;
            mux_regfile_req_w <= 0;
            pc_4 <= 0;
            rd <= 0;
            regfile_data_a <= 0;
            regfile_data_b <= 0;
            regfile_w_en <= 0;
            rt <= 0;
            shamt <= 0;
            syscall_en <= 0;
            wtg_op <= 0;
        end else if(en) begin
            alu_op <= alu_op_in;
            datamem_op <= datamem_op_in;
            datamem_w_en <= datamem_w_en_in;
            imm16 <= imm16_in;
            mux_alu_data_y <= mux_alu_data_y_in;
            mux_regfile_data_w <= mux_regfile_data_w_in;
            mux_regfile_req_w <= mux_regfile_req_w_in;
            pc_4 <= pc_4_in;
            rd <= rd_in;
            regfile_data_a <= regfile_data_a_in;
            regfile_data_b <= regfile_data_b_in;
            regfile_w_en <= regfile_w_en_in;
            rt <= rt_in;
            shamt <= shamt_in;
            syscall_en <= syscall_en_in;
            wtg_op <= wtg_op_in;
        end
    end
endmodule
