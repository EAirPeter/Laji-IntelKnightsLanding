`timescale 1ns / 1ps

`include "Core.vh"

// Brief: CPU Top Module, synchronized
// Author: EAirPeter
module SynLajiIntelKnightsLanding(
    input clk, 
    input rst_n, 
    input en,
    input [4:0] regfile_req_dbg,
    input [`DM_ADDR_BIT - 1:0] datamem_addr_dbg,
    output [31:0] pc_dbg,
    output [31:0] regfile_data_dbg,
    output [31:0] datamem_data_dbg,
    output [31:0] display,
    output halt, 
    output is_jump, 
    output is_branch, 
    output branched,
    output valid_inst
);

    parameter ProgPath = `BENCHMARK_FILEPATH;
    `include "inc/Laji_defines_inc.vh"
    assign pc_dbg = {20'd0, pc, 2'd0};
    wire [`IM_ADDR_BIT - 1 + 2:0] pc_4_dbg0 = {pc_4_ps0, 2'd0};
    wire [`IM_ADDR_BIT - 1 + 2:0] pc_4_dbg1 = {pc_4_ps1, 2'd0};
    wire [`IM_ADDR_BIT - 1 + 2:0] pc_4_dbg2 = {pc_4_ps2, 2'd0};
    wire [`IM_ADDR_BIT - 1 + 2:0] pc_4_dbg3 = {pc_4_ps3, 2'd0};
    wire [`IM_ADDR_BIT - 1 + 2:0] pc_4_dbg4 = {pc_4_ps4, 2'd0};

    // use BHT instead, buggy
    // assign pc_guessed_ps0 = pc_4_ps0;
    assign pc_new = pred_succ ? pc_guessed_ps0 : wtg_pc_new_ps3;
    ////////////////////////////
    ///////  ps0 gen/IF  ///////
    assign en_vps0 = !pred_succ || en_vps2;
    SynPC vPC(
        .clk(clk),
        .rst_n(rst_n),
        .en(en_vps0),
        .pc_new(pc_new),
        // output
        .pc(pc),
        .pc_4(pc_4_ps0)
    );
    ////////////////////////////

    CmbInstMem #(
        .ProgPath(ProgPath)
    ) vIM(
        .addr(pc),
        // output
        .inst(inst_ps0)
    );
    // current instruction: branch
    SynBHT vBHT(
        .clk(clk),
        .rst_n(rst_n),
        .update_en(wtg_op_ps3 != `WTG_OP_DEFAULT),
        .update_pc_4(pc_4_ps3),
        .update_pc_remote(pc_remote),
        .update_state_old(bht_state_ps3),
        .branch_succ(branched || is_jump_ps3),
        
        .pc_4(pc_4_ps0),
        .guess_new_pc(pc_guessed_ps0),
        .guess_state(bht_state_ps0)
    );

    ////////////////////////////
    ///////   ps1 IF/ID  ////////
    assign en_vps1 = en_vps2;
    assign clear_vps1 = !pred_succ;
    `include "inc/Laji_vPS1_inc.vh"
    ////////////////////////////

    CmbDecoder vDec(
        .inst(inst_ps1),
        // output
        .opcode(opcode),    // self use
        .rs(rs),            // self use
        .rt(rt),            
        .rd(rd_ps1),             
        .shamt(shamt_ps1),  // for_alu 
        .funct(funct),      // self use
        .imm16(imm16_ps1)   // self use && for alu
    );

    assign rt_ps1 = rt;

    CmbControl vCtl(
        .opcode(opcode),
        .rt(rt),
        .funct(funct),
        // output
        .op_wtg(wtg_op_ps1),
        .w_en_regfile(regfile_w_en_ps1),
        .op_alu(alu_op_ps1),
        .op_datamem(datamem_op_ps1),
        .w_en_datamem(datamem_w_en_ps1),
        .syscall_en(syscall_en_ps1),
        .mux_regfile_req_w(mux_regfile_req_w_ps1),          // self use
        .mux_regfile_data_w(mux_regfile_data_w_ps1), 
        .mux_alu_data_y(mux_alu_data_y_ps1), 
        .r_datamem(r_datamem_ps1),
        .is_jump(is_jump_ps1),      
        .is_branch(is_branch_ps1)  
    );

    assign skip_load_use_ps1 = is_jump_ps1 || is_branch_ps1 || syscall_en_ps1;
    wire mux_regfile_a_req = syscall_en_ps1;
    wire mux_regfile_b_req = syscall_en_ps1;
    always@(*) begin
        case(mux_regfile_a_req)
            `MUX_RFA_REQ_RS: regfile_req_a_ps1 = rs;
            `MUX_RFA_REQ_V0: regfile_req_a_ps1 = `V0;
        endcase
        case(mux_regfile_b_req)
            `MUX_RFB_REQ_RT: regfile_req_b_ps1 = rt;
            `MUX_RFB_REQ_A0: regfile_req_b_ps1 = `A0;
        endcase
    end

    SynRegFile vRF(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .w_en(regfile_w_en_ps4),        // DO AT PS4
        .req_dbg(regfile_req_dbg), 
        .req_w(regfile_req_w_ps4),          // DO AT PS4
        .req_a(regfile_req_a_ps1),
        .req_b(regfile_req_b_ps1),
        .data_w(regfile_data_w_ps4),        // DO AT PS4
        // output
        .data_dbg(regfile_data_dbg), // out connection
        .data_a(regfile_data_a_ori_ps1), 
        .data_b(regfile_data_b_ori_ps1)
    );

    always @(*) begin
        case (mux_regfile_req_w_ps1)
            `MUX_RF_REQW_RD:
                regfile_req_w_ps1 = rd_ps1;
            `MUX_RF_REQW_RT:
                regfile_req_w_ps1 = rt_ps1;
            `MUX_RF_REQW_31:
                regfile_req_w_ps1 = 5'd31;
            default:
                regfile_req_w_ps1 = 5'd0;
        endcase
    end

    CmbBubble vLD_USE_BUBBLE(
        .self_use_en_1(1'h1),
        .self_use_req_1(regfile_req_a_ps1),
        .self_use_en_2(1'h1),
        .self_use_req_2(regfile_req_b_ps1),
        .mem_read_en(r_datamem_ps2 && !skip_load_use_ps2),
        .regfile_req_w(regfile_req_w_ps2),
        .bubble(bubble)
    );

   /////////////////////////////
    ///////   ps2 ID/EX  ////////
    assign en_vps2 = en_vps3 && !bubble;
    assign clear_vps2 = !pred_succ || bubble;
    `include "inc/Laji_vPS2_inc.vh"
    /////////////////////////////

    CmbReFlowDual vRF_A_REFLOW(
        .origin_req(regfile_req_a_ps2), 
        .origin_data(regfile_data_a_ori_ps2),
        .reflow_en_1(regfile_w_en_ps3),
        .reflow_req_1(regfile_req_w_ps3),
        .reflow_data_1(alu_data_res_ps3),
        .reflow_en_2(regfile_w_en_ps4),
        .reflow_req_2(regfile_req_w_ps4),
        .reflow_data_2(regfile_data_w_ps4),
        // output
        .data(regfile_data_a_ps2)
    );

    CmbReFlowDual vRF_B_REFLOW(
        .origin_req(regfile_req_b_ps2), 
        .origin_data(regfile_data_b_ori_ps2),
        .reflow_en_1(regfile_w_en_ps3),
        .reflow_req_1(regfile_req_w_ps3),
        .reflow_data_1(alu_data_res_ps3),
        .reflow_en_2(regfile_w_en_ps4),
        .reflow_req_2(regfile_req_w_ps4),
        .reflow_data_2(regfile_data_w_ps4),
        // output
        .data(regfile_data_b_ps2)
    );

    CmbExt vExt(
        .imm16(imm16_ps2),
        .out_sign(ext_out_sign),
        .out_zero(ext_out_zero)
    );

    always @(*) begin
        case (mux_alu_data_y_ps2)
            `MUX_ALU_DATAY_RFB:
                alu_data_y = regfile_data_b_ps2;
            `MUX_ALU_DATAY_EXTS:
                alu_data_y = ext_out_sign;
            `MUX_ALU_DATAY_EXTZ:
                alu_data_y = ext_out_zero;
            default:
                alu_data_y = 32'd0;
        endcase
    end

    CmbALU vALU(
        .op(alu_op_ps2),
        .data_x(regfile_data_a_ps2),
        .data_y(alu_data_y),
        .shamt(shamt_ps2),
        // output
        .data_res(alu_data_res_ps2)
    );

    /////////////////////////////
    ///////   ps3 EX/DM  ////////
    assign en_vps3 = en_vps4;
    assign clear_vps3 = !pred_succ;
    `include "inc/Laji_vPS3_inc.vh"
    /////////////////////////////
    assign is_jump = is_jump_ps3;
    assign is_branch = is_branch_ps3;

    CmbReFlowSingle vDM_REG_A_REFLOW(
        .origin_req(regfile_req_a_ps3),
        .origin_data(regfile_data_a_ps3),
        .reflow_en_1(r_datamem_ps4),
        .reflow_req_1(regfile_req_w_ps4),
        .reflow_data_1(regfile_data_w_ps4),
        .data(regfile_data_a_final_ps3)
    );

    CmbReFlowSingle vDM_REG_B_REFLOW(
        .origin_req(regfile_req_b_ps3),
        .origin_data(regfile_data_b_ps3),
        .reflow_en_1(r_datamem_ps4),
        .reflow_req_1(regfile_req_w_ps4),
        .reflow_data_1(regfile_data_w_ps4),
        .data(regfile_data_b_final_ps3)
    );

    SynSyscall vSys(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .syscall_en(syscall_en_ps3),
        .data_v0(regfile_data_a_final_ps3),
        .data_a0(regfile_data_b_final_ps3),
        .display(display),              // out connection
        .halt(halt_ps3)                 // out connection
    );

    CmbWTG vWTG(
        .op(wtg_op_ps3),
        .imm(imm16_ps3[`IM_ADDR_BIT - 1:0]),
        .data_x(regfile_data_a_final_ps3),
        .data_y(regfile_data_b_final_ps3),
        .pc_4(pc_4_ps3),
        .pc_guessed(pc_guessed_ps3),
        // output
        .pc_remote(pc_remote),
        .pc_new(wtg_pc_new_ps3),
        .pred_succ(pred_succ),
        .branched(branched)            // out connection
    );

    SynDataMem vDM(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .op(datamem_op_ps3),
        .w_en(datamem_w_en_ps3),
        .addr_dbg(datamem_addr_dbg),
        .addr(alu_data_res_ps3[`DM_ADDR_BIT - 1:0]),
        .data_in(regfile_data_b_final_ps3),
        // output
        .data_dbg(datamem_data_dbg),
        .data(datamem_data_ps3)
    );

    ///////////////////////
    //////write back///////
    assign en_vps4 = en;
    assign clear_vps4 = 0;
    `include "inc/Laji_vPS4_inc.vh"
    //////////////////////

    // reg [15:0] inst_counter;
    assign valid_inst = (pc_4_ps4 != 0);

    // always @(posedge clk, negedge rst_n) begin
    //     if(!rst_n)
    //         inst_counter <= 0;
    //     else begin
    //         if(en && valid_inst) begin
    //             inst_counter <= inst_counter + 1;
    //         end
    //     end
    // end
    assign halt = halt_ps4;
    always @(*) begin
        case (mux_regfile_data_w_ps4)
            `MUX_RF_DATAW_ALU:
                regfile_data_w_ps4 = alu_data_res_ps4;
            `MUX_RF_DATAW_DM:
                regfile_data_w_ps4 = datamem_data_ps4;
            `MUX_RF_DATAW_PC4:
                regfile_data_w_ps4 = pc_4_ps4;
            default:
                regfile_data_w_ps4 = 32'd0;
        endcase
    end
endmodule

