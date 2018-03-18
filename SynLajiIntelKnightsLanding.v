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
    wire [`IM_ADDR_BIT - 1:0] pc, pc_4_ps0, pc_4_ps1, pc_4_ps2, pc_4_ps3, pc_4_ps4;
    wire [31:0] inst_ps0, inst_ps1;
    wire [5:0] opcode, funct;
    wire [4:0] rs;
    wire [4:0] rt, rt_ps1, rt_ps2, rt_ps3, rt_ps4;
    wire [4:0] rd, rd_ps1, rd_ps2, rd_ps3, rd_ps4;
    wire [4:0] shamt_ps1, shamt_ps2;
    wire [15:0] imm16_ps1, imm16_ps2, imm16_ps3;
    wire [31:0] ext_out_sign, ext_out_zero;
    wire regfile_w_en;
    wire [31:0] regfile_data_a_ps1, regfile_data_a_ps2, regfile_data_a_ps3;
    wire [31:0] regfile_data_b_ps1, regfile_data_b_ps2, regfile_data_b_ps3;
    wire [31:0] regfile_data_v0_ps1, regfile_data_v0_ps2;
    wire [31:0] regfile_data_a0_ps1, regfile_data_a0_ps2;
    reg [4:0] regfile_req_w;    // combinatorial
    reg [31:0] regfile_data_w;  // combinatorial
    wire [`WTG_OP_BIT - 1:0] wtg_op_ps1, wtg_op_ps2, wtg_op_ps3;
    wire [`IM_ADDR_BIT - 1:0] wtg_pc_new_todo;
    wire [`ALU_OP_BIT - 1:0] alu_op_ps1, alu_op_ps2;
    reg [31:0] alu_data_y;      // combinatorial
    wire [31:0] alu_data_res_ps2, alu_data_res_ps3, alu_data_res_ps4;
    wire [`DM_OP_BIT - 1:0] datamem_op_ps1, datamem_op_ps2, datamem_op_ps3;
    wire datamem_w_en_ps1, datamem_w_en_ps2, datamem_w_en_ps3;
    wire [31:0] datamem_data_ps3, datamem_data_ps4;
    wire [`MUX_RF_REQW_BIT - 1:0] mux_regfile_req_w_ps1, mux_regfile_req_w_ps2, 
            mux_regfile_req_w_ps3, mux_regfile_req_w_ps4;
    wire [`MUX_RF_DATAW_BIT - 1:0] mux_regfile_data_w_ps1, mux_regfile_data_w_ps2, 
            mux_regfile_data_w_ps3, mux_regfile_data_w_ps4;
    wire [`MUX_ALU_DATAY_BIT - 1:0] mux_alu_data_y_ps1, mux_alu_data_y_ps2;
    assign pc_dbg = {20'd0, pc, 2'd0};
    wire [`IM_ADDR_BIT - 1:0] pc_new_todo;


    // wire [`IM_ADDR_BIT - 1:0] pc, pc_4;
    // wire [31:0] inst;

    // use it before SynPC later to save time
    // buggy
    assign pc_new_todo = is_jump || branched ? wtg_pc_new_todo : pc_4_ps0;
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
    ////////////////////////////


    CmbInstMem #(
        .ProgPath(ProgPath)
    ) vIM(
        .addr(pc),
        // output
        .inst(inst_ps0)
    );


    ////////////////////////////
    ////////////////////////////

    // SynPS1 vPS1(
    //     .clk(clk), 
    //     .rst_n(rst_n),
    //     .en(en),
    //     .inst_in(inst_ps0),
    //     .pc_4_in(pc_4_ps0),
    //     // output
    //     .inst(inst_ps1),
    //     .pc_4(pc_4_ps1)
    // );
    
    assign inst_ps1 = inst_ps0;
    assign pc_4_ps1 = pc_4_ps0;
    
    ////////////////////////////
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



    SynRegFile vRF(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .w_en(regfile_w_en),
        .req_dbg(regfile_req_dbg), 
        .req_w(regfile_req_w),
        .req_a(rs),
        .req_b(rt),
        .data_w(regfile_data_w),
        // output
        .data_dbg(regfile_data_dbg), // out connection
        .data_a(regfile_data_a_ps1), 
        .data_b(regfile_data_b_ps1),
        .data_v0(regfile_data_v0_ps1),
        .data_a0(regfile_data_a0_ps1)
    );
    /////////////////////////////
    ///////   ps2 ID/EX  ////////
    assign regfile_data_a_ps2 = regfile_data_a_ps1;
    assign regfile_data_b_ps2 = regfile_data_b_ps1;
    assign regfile_data_v0_ps2 = regfile_data_v0_ps1;
    assign regfile_data_a0_ps2 = regfile_data_a0_ps1;


    assign rd_ps2 = rd_ps1;
    assign rt_ps2 = rt_ps1;
    assign mux_regfile_data_w_ps2 = mux_regfile_data_w_ps1;
    assign mux_regfile_req_w_ps2 = mux_regfile_req_w_ps1;

    assign wtg_op_ps2 = wtg_op_ps1;
    assign imm16_ps2 = imm16_ps1;
    assign pc_4_ps2 = pc_4_ps1;
    assign datamem_op_ps2 = datamem_op_ps1;
    assign datamem_w_en_ps2 = datamem_w_en_ps1;
    assign syscall_en_ps2 = syscall_en_ps1;
    assign shamt_ps2 = shamt_ps1;
    assign alu_op_ps2 = alu_op_ps1;
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
        .data_v0(regfile_data_v0_ps2),
        .data_a0(regfile_data_a0_ps2),

        .display(display),              // out connection
        .halt(halt)                     // out connection
    );
    /////////////////////////////
    ///////   ps3 ID/DM  ////////
    assign rd_ps3 = rd_ps2;
    assign rt_ps3 = rt_ps2;
    assign mux_regfile_data_w_ps3 = mux_regfile_data_w_ps2;
    assign mux_regfile_req_w_ps3 = mux_regfile_req_w_ps2;
    assign alu_data_res_ps3 = alu_data_res_ps2;

    assign wtg_op_ps3 = wtg_op_ps2;
    assign imm16_ps3 = imm16_ps2;
    assign regfile_data_a_ps3 = regfile_data_a_ps2;
    assign regfile_data_b_ps3 = regfile_data_b_ps2;
    assign pc_4_ps3 = pc_4_ps2;
    assign datamem_op_ps3 = datamem_op_ps2;
    assign datamem_w_en_ps3 = datamem_w_en_ps2;

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
    assign rd_ps4 = rd_ps3;
    assign rt_ps4 = rt_ps3;
    assign mux_regfile_data_w_ps4 = mux_regfile_data_w_ps3;
    assign datamem_data_ps4 = datamem_data_ps3;
    assign mux_regfile_req_w_ps4 = mux_regfile_req_w_ps3;
    assign alu_data_res_ps4 = alu_data_res_ps3;
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
