`timescale 1ns / 1ps
`include "Core.vh"
// Brief: pipeline stage2, sychronized
// Author: FluorineDog
module SynPS2(
    input clk,
    input rst_n,
    input en,       
    input clear,
    input [`IM_ADDR_BIT - 1:0] pc_4_in,
    input [4:0] regfile_req_a_in,
    input [4:0] regfile_req_b_in,
    input [4:0] rt_in,
    input [4:0] rd_in,
    input [4:0] shamt_in,
    input [15:0] imm16_in,
    input regfile_w_en_in,
    input [31:0] regfile_data_a_ori_in,
    input [31:0] regfile_data_b_ori_in,
    input [4:0] regfile_req_w_in,
    input [`WTG_OP_BIT - 1:0] wtg_op_in,
    input [`ALU_OP_BIT - 1:0] alu_op_in,
    input [`DM_OP_BIT - 1:0] datamem_op_in,
    input datamem_w_en_in,
    input [`MUX_RF_REQW_BIT - 1:0] mux_regfile_req_w_in,
    input [`MUX_RF_DATAW_BIT - 1:0] mux_regfile_data_w_in,
    input [`MUX_ALU_DATAY_BIT - 1:0] mux_alu_data_y_in,
    input syscall_en_in,
    input [`IM_ADDR_BIT - 1:0] pc_guessed_in,
    input skip_load_use_in,
    input r_datamem_in,
    input [1:0] bht_state_in,
    input is_branch_in,
    input is_jump_in,
    input [`INTR_OP_BIT-1:0] op_intr_in,
    output reg [`IM_ADDR_BIT - 1:0] pc_4,
    output reg [4:0] regfile_req_a,
    output reg [4:0] regfile_req_b,
    output reg [4:0] rt,
    output reg [4:0] rd,
    output reg [4:0] shamt,
    output reg [15:0] imm16,
    output reg regfile_w_en,
    output reg [31:0] regfile_data_a_ori,
    output reg [31:0] regfile_data_b_ori,
    output reg [4:0] regfile_req_w,
    output reg [`WTG_OP_BIT - 1:0] wtg_op,
    output reg [`ALU_OP_BIT - 1:0] alu_op,
    output reg [`DM_OP_BIT - 1:0] datamem_op,
    output reg datamem_w_en,
    output reg [`MUX_RF_REQW_BIT - 1:0] mux_regfile_req_w,
    output reg [`MUX_RF_DATAW_BIT - 1:0] mux_regfile_data_w,
    output reg [`MUX_ALU_DATAY_BIT - 1:0] mux_alu_data_y,
    output reg syscall_en,
    output reg [`IM_ADDR_BIT - 1:0] pc_guessed,
    output reg skip_load_use,
    output reg r_datamem,
    output reg [1:0] bht_state,
    output reg is_branch,
    output reg is_jump,
    output reg [`INTR_OP_BIT-1:0] op_intr
);
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin 
            pc_4 <= 0;
            regfile_req_a <= 0;
            regfile_req_b <= 0;
            rt <= 0;
            rd <= 0;
            shamt <= 0;
            imm16 <= 0;
            regfile_w_en <= 0;
            regfile_data_a_ori <= 0;
            regfile_data_b_ori <= 0;
            regfile_req_w <= 0;
            wtg_op <= 0;
            alu_op <= 0;
            datamem_op <= 0;
            datamem_w_en <= 0;
            mux_regfile_req_w <= 0;
            mux_regfile_data_w <= 0;
            mux_alu_data_y <= 0;
            syscall_en <= 0;
            pc_guessed <= 0;
            skip_load_use <= 0;
            r_datamem <= 0;
            bht_state <= 0;
            is_branch <= 0;
            is_jump <= 0;
            op_intr <= 0;
        end else if(clear) begin
            pc_4 <= 0;
            regfile_req_a <= 0;
            regfile_req_b <= 0;
            rt <= 0;
            rd <= 0;
            shamt <= 0;
            imm16 <= 0;
            regfile_w_en <= 0;
            regfile_data_a_ori <= 0;
            regfile_data_b_ori <= 0;
            regfile_req_w <= 0;
            wtg_op <= 0;
            alu_op <= 0;
            datamem_op <= 0;
            datamem_w_en <= 0;
            mux_regfile_req_w <= 0;
            mux_regfile_data_w <= 0;
            mux_alu_data_y <= 0;
            syscall_en <= 0;
            pc_guessed <= 0;
            skip_load_use <= 0;
            r_datamem <= 0;
            bht_state <= 0;
            is_branch <= 0;
            is_jump <= 0;
            op_intr <= 0;
        end else if(en) begin
            pc_4 <= pc_4_in;
            regfile_req_a <= regfile_req_a_in;
            regfile_req_b <= regfile_req_b_in;
            rt <= rt_in;
            rd <= rd_in;
            shamt <= shamt_in;
            imm16 <= imm16_in;
            regfile_w_en <= regfile_w_en_in;
            regfile_data_a_ori <= regfile_data_a_ori_in;
            regfile_data_b_ori <= regfile_data_b_ori_in;
            regfile_req_w <= regfile_req_w_in;
            wtg_op <= wtg_op_in;
            alu_op <= alu_op_in;
            datamem_op <= datamem_op_in;
            datamem_w_en <= datamem_w_en_in;
            mux_regfile_req_w <= mux_regfile_req_w_in;
            mux_regfile_data_w <= mux_regfile_data_w_in;
            mux_alu_data_y <= mux_alu_data_y_in;
            syscall_en <= syscall_en_in;
            pc_guessed <= pc_guessed_in;
            skip_load_use <= skip_load_use_in;
            r_datamem <= r_datamem_in;
            bht_state <= bht_state_in;
            is_branch <= is_branch_in;
            is_jump <= is_jump_in;
            op_intr <= op_intr_in;
        end
    end
endmodule
