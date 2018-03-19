`timescale 1ns / 1ps

`include "Core.vh"

// Brief: CPU Top Module, synchronized
// Author: EAirPeter
module SynLajiIntelKnightsLanding(
    // clk, rst_n, en, regfile_req_dbg, datamem_addr_dbg,
    // pc_dbg, regfile_data_dbg, datamem_data_dbg, display,
    // halt, is_jump, is_branch, branched
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
    output branched
);

    parameter ProgPath = `BENCHMARK_FILEPATH;
    `include "inc/Laji_defines_inc.vh"
    assign pc_dbg = {20'd0, pc, 2'd0};

    // use it before SynPC later to save time
    // buggy
    assign pc_new_todo = is_jump || branched ? wtg_pc_new_todo : pc_4_ps0;
    ////////////////////////////
    ///////  ps0 gen/IF  ///////
    SynPC vPC(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .pc_new(pc_new_todo),
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


    ////////////////////////////
    ///////   ps1 IF/ID  ////////
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
        .is_jump(is_jump),      // out_connection
        .is_branch(is_branch)   // out_connection
    );


    wire mux_regfile_a_req = syscall_en_ps1;
    wire mux_regfile_b_req = syscall_en_ps1;
    always@(*) begin
        case(mux_regfile_a_req)
            `MUX_RFA_REQ_RS: regfile_req_a = rs;
            `MUX_RFA_REQ_V0: regfile_req_a = `V0;
        endcase
        case(mux_regfile_b_req)
            `MUX_RFB_REQ_RT: regfile_req_b = rt;
            `MUX_RFB_REQ_A0: regfile_req_b = `A0;
        endcase
 
    end


    SynRegFile vRF(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .w_en(regfile_w_en_ps4),        // DO AT PS4
        .req_dbg(regfile_req_dbg), 
        .req_w(regfile_req_w),          // DO AT PS4
        .req_a(regfile_req_a),
        .req_b(regfile_req_b),
        .data_w(regfile_data_w),        // DO AT PS4
        // output
        .data_dbg(regfile_data_dbg), // out connection
        .data_a(regfile_data_a_ps1), 
        .data_b(regfile_data_b_ps1)
    );
    /////////////////////////////
    ///////   ps2 ID/EX  ////////
    `include "inc/Laji_vPS2_inc.vh"
    /////////////////////////////

    CmbExt vExt(
        .imm16(imm16_ps2),
        .out_sign(ext_out_sign),
        .out_zero(ext_out_zero)
    );

    always @(*) begin
        case (mux_alu_data_y_ps2)
            `MUX_ALU_DATAY_RFB:
                alu_data_y <= regfile_data_b_ps2;
            `MUX_ALU_DATAY_EXTS:
                alu_data_y <= ext_out_sign;
            `MUX_ALU_DATAY_EXTZ:
                alu_data_y <= ext_out_zero;
            default:
                alu_data_y <= 32'd0;
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

    SynSyscall vSys(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .syscall_en(syscall_en_ps2),
        .data_v0(regfile_data_a_ps2),
        .data_a0(regfile_data_b_ps2),

        .display(display),              // out connection
        .halt(halt)                     // out connection
    );
    /////////////////////////////
    ///////   ps3 ID/DM  ////////
    `include "inc/Laji_vPS3_inc.vh"
    /////////////////////////////

    CmbWTG vWTG(
        .op(wtg_op_ps3),
        .imm(imm16_ps3[`IM_ADDR_BIT - 1:0]),
        .data_x(regfile_data_a_ps3),
        .data_y(regfile_data_b_ps3),
        .pc_4(pc_4_ps3),
        // output
        .pc_new(wtg_pc_new_todo),
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
        .data_in(regfile_data_b_ps3),
        // output
        .data_dbg(datamem_data_dbg),
        .data(datamem_data_ps3)
    );
    ///////////////////////
    //////write back///////
    `include "inc/Laji_vPS4_inc.vh"
    //////////////////////
    
    always @(*) begin
        case (mux_regfile_req_w_ps4)
            `MUX_RF_REQW_RD:
                regfile_req_w <= rd_ps4;
            `MUX_RF_REQW_RT:
                regfile_req_w <= rt_ps4;
            `MUX_RF_REQW_31:
                regfile_req_w <= 5'd31;
            default:
                regfile_req_w <= 5'd0;
        endcase
        case (mux_regfile_data_w_ps4)
            `MUX_RF_DATAW_ALU:
                regfile_data_w <= alu_data_res_ps4;
            `MUX_RF_DATAW_DM:
                regfile_data_w <= datamem_data_ps4;
            `MUX_RF_DATAW_PC4:
                regfile_data_w <= pc_4_ps4;
            default:
                regfile_data_w <= 32'd0;
        endcase
    end

endmodule
