`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Control Module, synchronized
// Author: FluorineDog
module CmbControl(
    opcode, rs, funct, is_irq, is_epc,
    rf_ra, rf_rb, rf_we, rc0_op, rc0_ie_we, rc0_epc_we,
    alu_op, wtg_op, syscall_en, dm_op, dm_we,
    mux_rf_req_w, sel_rf_w_pc_4, sel_rf_w_dm,
    mux_rc0_ie_w, mux_rc0_epc_w,
    mux_alu_data_y,
    is_jump, is_branch
);
    input [5:0] opcode;
    input [4:0] rs;
    input [5:0] funct;
    input is_irq, is_epc;
    output reg rf_ra, rf_rb, rf_we;
    output reg [`RC0_OP_NBIT - 1:0] rc0_op;
    output reg rc0_ie_we, rc0_epc_we;
    output reg [`ALU_OP_NBIT - 1:0] alu_op; // alias to alu to increase Hamming Distance 
    output reg [`WTG_OP_NBIT - 1:0] wtg_op;
    output reg syscall_en;
    output reg [`DM_OP_NBIT - 1:0] dm_op;
    output reg dm_we;
    output reg [`MUX_RF_REQW_NBIT - 1:0] mux_rf_req_w;
    output reg sel_rf_w_pc_4;
    output reg sel_rf_w_dm;
    output reg [`MUX_RC0_IEW_NBIT - 1:0] mux_rc0_ie_w;
    output reg [`MUX_RC0_EPCW_NBIT - 1:0] mux_rc0_epc_w;
    output reg [`MUX_ALU_DATAY_NBIT - 1:0] mux_alu_data_y;
    output reg is_jump;     // 1 if the current instruction is a jump instruction
    output reg is_branch;   // 1 if the current instruction is a branch instraction
    
    always@(*) begin
        wtg_op = `WTG_OP_JNO;
        alu_op = `ALU_OP_ADD;
        dm_op = `DM_OP_WD;  
        rf_ra = 1;
        rf_rb = 1;
        rf_we = 1;
        rc0_op = `RC0_OP_NOP;
        rc0_ie_we = 0;
        rc0_epc_we = 0;
        mux_rc0_ie_w = `MUX_RC0_IEW_RF;
        mux_rc0_epc_w = `MUX_RC0_EPCW_RF;
        dm_we = 0;
        syscall_en = 0;

        mux_rf_req_w = `MUX_RF_REQW_RT;
        sel_rf_w_pc_4 = 0;
        sel_rf_w_dm = 0;
        mux_alu_data_y = `MUX_ALU_DATAY_EXTS;
        is_jump = 0;
        is_branch = 0;
        if (is_irq) begin
            rc0_op = `RC0_OP_IRQ;
            rc0_ie_we = 1;
            rc0_epc_we = 1;
            mux_rc0_ie_w = `MUX_RC0_IEW_ZERO;
            mux_rc0_epc_w = `MUX_RC0_EPCW_PC;
            rf_ra = 0;
            rf_rb = 0;
            rf_we = 0;
            wtg_op = `WTG_OP_IRQ;
        end
        else case(opcode)
            6'b000000:  begin 
                mux_rf_req_w = `MUX_RF_REQW_RD;
                mux_alu_data_y = `MUX_ALU_DATAY_RFB;
                case(funct)
                    6'b000000:  begin   alu_op = `ALU_OP_SLL; rf_ra = 0; end    // sll
                    6'b000010:  begin   alu_op = `ALU_OP_SRL; rf_ra = 0; end    // srl
                    6'b000011:  begin   alu_op = `ALU_OP_SRA; rf_ra = 0; end    // sra
                    6'b000100:          alu_op = `ALU_OP_SLLV;                  // sllv
                    6'b001000:  begin                       // jr
                        wtg_op = `WTG_OP_J32;
                        is_jump = 1;
                        rf_rb = 0;
                        rf_we = 0;
                    end
                    6'b001100:  begin                       // syscall
                        syscall_en = 1;
                        rf_we = 0;
                    end
                    6'b100000:  alu_op = `ALU_OP_ADD;       // add
                    6'b100001:  alu_op = `ALU_OP_ADD;       // addu
                    6'b100010:  alu_op = `ALU_OP_SUB;       // sub
                    6'b100100:  alu_op = `ALU_OP_AND;       // and
                    6'b100101:  alu_op = `ALU_OP_OR;        // or
                    6'b100111:  alu_op = `ALU_OP_NOR;       // nor
                    6'b101010:  alu_op = `ALU_OP_SLT;       // slt
                    6'b101011:  alu_op = `ALU_OP_SLTU;      // sltu
                endcase
            end

            6'b000001:  begin                               // bgez
                rf_rb = 0;
                rf_we = 0;
                wtg_op = `WTG_OP_BGEZ;
                is_branch = 1;
            end
            6'b000010:  begin   wtg_op = `WTG_OP_J26;   is_jump   = 1;      // j
                rf_ra = 0;
                rf_rb = 0;
                rf_we = 0;
            end
            6'b000011:  begin   wtg_op = `WTG_OP_J26;   is_jump   = 1;      // jal
                rf_ra = 0;
                rf_rb = 0;
                mux_rf_req_w = `MUX_RF_REQW_31;
                sel_rf_w_pc_4 = 1;
            end
            6'b000100:  begin   wtg_op = `WTG_OP_BEQ;   is_branch = 1; rf_we = 0;   end // beq
            6'b000101:  begin   wtg_op = `WTG_OP_BNE;   is_branch = 1; rf_we = 0;   end // bne

            6'b001000:  begin   alu_op = `ALU_OP_ADD;   rf_rb = 0;  end // addi
            6'b001001:  begin   alu_op = `ALU_OP_ADD;   rf_rb = 0;  end // addiu
            6'b001010:  begin   alu_op = `ALU_OP_SLT;   rf_rb = 0;  end // slti

            6'b001100:  begin   alu_op = `ALU_OP_AND;   rf_rb = 0;      // andi
                mux_alu_data_y = `MUX_ALU_DATAY_EXTZ;
            end
            6'b001101:  begin   alu_op = `ALU_OP_OR;    rf_rb = 0;      // ori
                mux_alu_data_y = `MUX_ALU_DATAY_EXTZ;
            end

            6'b001111:  begin   alu_op = `ALU_OP_LUI; rf_ra = 0; rf_rb = 0; end     // lui

            6'b010000:  begin
                rf_ra = 0;
                if (rs[4]) begin        // eret
                    rc0_op = `RC0_OP_RET;
                    rc0_ie_we = 1;
                    mux_rc0_ie_w = `MUX_RC0_IEW_ONE;
                    rf_rb = 0;
                    rf_we = 0;
                    wtg_op = `WTG_OP_IRET;
                end
                else if (rs[2]) begin   // mtc0
                    if (is_epc)
                        rc0_epc_we = 1;
                    else
                        rc0_ie_we = 1;
                    rf_we = 0;
                end
                else begin              // mfc0
                    rf_rb = 0;
                end
            end

            6'b100011:  begin   sel_rf_w_dm = 1; dm_op = `DM_OP_WD; rf_rb = 0; end  // lw
            6'b100100:  begin   sel_rf_w_dm = 1; dm_op = `DM_OP_UB; rf_rb = 0; end  // lbu

            6'b101011:  begin   dm_op = `DM_OP_WD; dm_we = 1; rf_we = 0; end  // sw
          endcase
      end
endmodule
