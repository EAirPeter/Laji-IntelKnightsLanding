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
    wire [`IM_ADDR_BIT - 1:0] pc, pc_4, pc_4_ps0;
    wire [31:0] inst, inst_ps0;
    wire [5:0] opcode, funct;
    wire [4:0] rs, rt, rd, shamt;
    wire [15:0] imm16;
    wire [31:0] ext_out_sign, ext_out_zero;
    wire regfile_w_en;
    wire [31:0] regfile_data_a, regfile_data_b, regfile_data_v0, regfile_data_a0;
    reg [4:0] regfile_req_w;    // combinatorial
    reg [31:0] regfile_data_w;  // combinatorial
    wire [`WTG_OP_BIT - 1:0] wtg_op;
    wire [`IM_ADDR_BIT - 1:0] wtg_pc_new;
    wire [`ALU_OP_BIT - 1:0] alu_op;
    reg [31:0] alu_data_y;      // combinatorial
    wire [31:0] alu_data_res;
    wire [`DM_OP_BIT - 1:0] datamem_op;
    wire datamem_w_en;
    wire [31:0] datamem_data;
    wire [`MUX_RF_REQW_BIT - 1:0] mux_regfile_req_w;
    wire [`MUX_RF_DATAW_BIT - 1:0] mux_regfile_data_w;
    wire [`MUX_ALU_DATAY_BIT - 1:0] mux_alu_data_y;
    assign pc_dbg = {20'd0, pc, 2'd0};
    wire [`IM_ADDR_BIT - 1:0] pc_new ;


    // wire [`IM_ADDR_BIT - 1:0] pc, pc_4;
    // wire [31:0] inst;

   // use it before SynPC later to save time
    assign pc_new = is_jump || branched ? wtg_pc_new : pc_4_ps0;
    SynPC vPC(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .pc_new(pc_new),
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
        .rt(rt),            // self use
        .rd(rd),            // self use 
        .shamt(shamt_dec),  // for_alu 
        .funct(funct),      // self use
        .imm16(imm16_dec)   // self use && for alu
    );


    CmbControl vCtl(
        .opcode(opcode),
        .rt(rt),
        .funct(funct),
        // output
        .op_wtg(wtg_op_ctl),
        .w_en_regfile(regfile_w_en), // self use
        .op_alu(alu_op_ctl),
        .op_datamem(datamem_op_ctl),
        .w_en_datamem(datamem_w_en_ctl),
        .syscall_en(syscall_en_ctl),
        .mux_regfile_req_w(mux_regfile_req_w),          // self use
        .mux_regfile_data_w(mux_regfile_data_w),        // self use
        .mux_alu_data_y(mux_alu_data_y_ctl), 
        .is_jump(is_jump),      // out_connection
        .is_branch(is_branch)   // out_connection
    );
    assign datamem_op = datamem_op_ctl;
    assign datamem_w_en = datamem_w_en_ctl;
    assign mux_alu_data_y = mux_alu_data_y_ctl;
    assign wtg_op = wtg_op_ctl;
    assign alu_op = alu_op_ctl;



    always @(*) begin
        case (mux_regfile_req_w)
            `MUX_RF_REQW_RD:
                regfile_req_w <= rd;
            `MUX_RF_REQW_RT:
                regfile_req_w <= rt;
            `MUX_RF_REQW_31:
                regfile_req_w <= 5'd31;
            default:
                regfile_req_w <= 5'd0;
        endcase
        case (mux_regfile_data_w)
            `MUX_RF_DATAW_ALU:
                regfile_data_w <= alu_data_res;
            `MUX_RF_DATAW_DM:
                regfile_data_w <= datamem_data;
            `MUX_RF_DATAW_PC4:
                regfile_data_w <= pc_4;
            default:
                regfile_data_w <= 32'd0;
        endcase
    end


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
        .data_dbg(regfile_data_dbg),
        .data_a(regfile_data_a),
        .data_b(regfile_data_b),
        .data_v0(regfile_data_v0),
        .data_a0(regfile_data_a0)
    );
    /////////////////////////////
    ///////   ps2 ID/EX  ////////

    /////////////////////////////

    CmbExt vExt(
        .imm16(imm16_),
        .out_sign(ext_out_sign),
        .out_zero(ext_out_zero)
    );

    always @(*) begin
        case (mux_alu_data_y)
            `MUX_ALU_DATAY_RFB:
                alu_data_y <= regfile_data_b;
            `MUX_ALU_DATAY_EXTS:
                alu_data_y <= ext_out_sign;
            `MUX_ALU_DATAY_EXTZ:
                alu_data_y <= ext_out_zero;
            default:
                alu_data_y <= 32'd0;
        endcase
    end

    CmbALU vALU(
        .op(alu_op),
        .data_x(regfile_data_a),
        .data_y(alu_data_y),
        .shamt(shamt),
        .data_res(alu_data_res)
    );

    SynSyscall vSys(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .syscall_en(syscall_en),
        .data_v0(regfile_data_v0),
        .data_a0(regfile_data_a0),
        .display(display),
        .halt(halt)
    );
    /////////////////////////////
    ///////   ps3 ID/DM  ////////
    /////////////////////////////


    CmbWTG vWTG(
        .op(wtg_op),
        .imm(imm16[`IM_ADDR_BIT - 1:0]),
        .data_x(regfile_data_a),
        .data_y(regfile_data_b),
        .pc_4(pc_4),
        .pc_new(wtg_pc_new),
        .branched(branched)
    );

    SynDataMem vDM(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .op(datamem_op),
        .w_en(datamem_w_en),
        .addr_dbg(datamem_addr_dbg),
        .addr(alu_data_res[`DM_ADDR_BIT - 1:0]),
        .data_in(regfile_data_b),
        .data_dbg(datamem_data_dbg),
        .data(datamem_data)
    );

endmodule
