`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Control Module, synchronized
// Author: FluorineDog
module CmbControl(
    opcode, rt, funct,
    rf_we, alu_op, wtg_op, syscall_en, dm_op, dm_we,
    mux_rf_req_w, mux_rf_data_w, mux_alu_data_y, is_jump, is_branch
);
    input [5:0] opcode;
    input [4:0] rt;
    input [5:0] funct;
    output reg rf_we;
    output reg [`ALU_OP_BIT - 1:0] alu_op; // alias to alu to increase Hamming Distance 
    output reg [`WTG_OP_BIT - 1:0] wtg_op;
    output reg syscall_en;
    output reg [`DM_OP_BIT - 1:0] dm_op;
    output reg dm_we;
    output reg [`MUX_RF_REQW_BIT - 1:0] mux_rf_req_w;
    output reg [`MUX_RF_DATAW_BIT - 1:0] mux_rf_data_w;
    output reg [`MUX_ALU_DATAY_BIT - 1:0] mux_alu_data_y;
    output reg is_jump;     // 1 if the current instruction is a jump instruction
    output reg is_branch;   // 1 if the current instruction is a branch instraction
    
    (* keep = "soft" *)
    wire [3:0] unused_rt = rt[4:1];

    always@(*) begin
        wtg_op = `WTG_OP_J32;
        alu_op = `ALU_OP_AND;
        dm_op = `DM_OP_WD;  
        rf_we = 1;
        dm_we = 0;
        syscall_en = 0;

        mux_rf_req_w = `MUX_RF_REQW_RT;
        mux_rf_data_w = `MUX_RF_DATAW_ALU;
        mux_alu_data_y = `MUX_ALU_DATAY_EXTS;
        is_jump = 0;
        is_branch = 0;
        case(opcode)
            6'b000000:  begin 
                mux_rf_req_w   = `MUX_RF_REQW_RD;
                mux_rf_data_w  = `MUX_RF_DATAW_ALU;
                mux_alu_data_y      = `MUX_ALU_DATAY_RFB;
                case(funct)
                    6'b000000:  alu_op = `ALU_OP_SLL;       // sll
                    6'b000010:  alu_op = `ALU_OP_SRL;       // srl
                    6'b000011:  alu_op = `ALU_OP_SRA;       // sra
                    6'b000100:  alu_op = `ALU_OP_SLLV;      // sllv
                    6'b000110:  alu_op = `ALU_OP_SRLV;      // srlv
                    6'b000111:  alu_op = `ALU_OP_SRAV;      // srav
                    6'b001000:  begin                       // jr
                        wtg_op = `WTG_OP_J32;
                        is_jump = 1;
                        rf_we = 0;
                    end
                    6'b001100:  begin                       // syscall
                        syscall_en = 1;
                        rf_we = 0;
                    end
                    6'b100000:  alu_op = `ALU_OP_ADD;       // add
                    6'b100001:  alu_op = `ALU_OP_ADD;       // addu
                    6'b100010:  alu_op = `ALU_OP_SUB;       // sub
                    6'b100011:  alu_op = `ALU_OP_SUB;       // subu
                    6'b100100:  alu_op = `ALU_OP_AND;       // and
                    6'b100101:  alu_op = `ALU_OP_OR;        // or
                    6'b100110:  alu_op = `ALU_OP_XOR;       // xor
                    6'b100111:  alu_op = `ALU_OP_NOR;       // nor
                    6'b101010:  alu_op = `ALU_OP_SLT;       // slt
                    6'b101011:  alu_op = `ALU_OP_SLTU;      // sltu
                endcase
            end

            6'b000001:  begin
                rf_we = 0;
                case(rt[0])
                    1'b0: begin wtg_op = `WTG_OP_BLTZ;  is_branch = 1;              end // bltz
                    1'b1: begin wtg_op = `WTG_OP_BGEZ;  is_branch = 1;              end // bgez
                endcase
            end
            6'b000010:  begin   wtg_op = `WTG_OP_J26;   is_jump   = 1; rf_we = 0;   end // j
            6'b000011:  begin   wtg_op = `WTG_OP_J26;   is_jump   = 1;                  // jal
                mux_rf_req_w = `MUX_RF_REQW_31;
                mux_rf_data_w = `MUX_RF_DATAW_PC4;
            end
            6'b000100:  begin   wtg_op = `WTG_OP_BEQ;   is_branch = 1; rf_we = 0;   end // beq
            6'b000101:  begin   wtg_op = `WTG_OP_BNE;   is_branch = 1; rf_we = 0;   end // bne
            6'b000110:  begin   wtg_op = `WTG_OP_BLEZ;  is_branch = 1; rf_we = 0;   end // blez
            6'b000111:  begin   wtg_op = `WTG_OP_BGTZ;  is_branch = 1; rf_we = 0;   end // bgtz

            6'b001000:          alu_op = `ALU_OP_ADD;       // addi
            6'b001001:          alu_op = `ALU_OP_ADD;       // addiu
            6'b001010:          alu_op = `ALU_OP_SLT;       // slti
            6'b001011:          alu_op = `ALU_OP_SLTU;      // sltiu

            6'b001100:  begin   alu_op = `ALU_OP_AND; mux_alu_data_y = `MUX_ALU_DATAY_EXTZ; end     // andi
            6'b001101:  begin   alu_op = `ALU_OP_OR;  mux_alu_data_y = `MUX_ALU_DATAY_EXTZ; end     // ori
            6'b001110:  begin   alu_op = `ALU_OP_XOR; mux_alu_data_y = `MUX_ALU_DATAY_EXTZ; end     // xori

            6'b001111:  begin   alu_op = `ALU_OP_LUI; mux_rf_data_w = `MUX_RF_DATAW_ALU;    end     // lui

            6'b100000:  begin   alu_op = `ALU_OP_ADD; mux_rf_data_w = `MUX_RF_DATAW_DM; dm_op = `DM_OP_SB; end  // lb
            6'b100001:  begin   alu_op = `ALU_OP_ADD; mux_rf_data_w = `MUX_RF_DATAW_DM; dm_op = `DM_OP_SH; end  // lh
            6'b100011:  begin   alu_op = `ALU_OP_ADD; mux_rf_data_w = `MUX_RF_DATAW_DM; dm_op = `DM_OP_WD; end  // lw
            6'b100100:  begin   alu_op = `ALU_OP_ADD; mux_rf_data_w = `MUX_RF_DATAW_DM; dm_op = `DM_OP_UB; end  // lbu
            6'b100101:  begin   alu_op = `ALU_OP_ADD; mux_rf_data_w = `MUX_RF_DATAW_DM; dm_op = `DM_OP_UH; end  // lhu

            6'b101000:  begin   alu_op = `ALU_OP_ADD; dm_op = `DM_OP_SB; dm_we = 1; rf_we = 0; end  // sb
            6'b101001:  begin   alu_op = `ALU_OP_ADD; dm_op = `DM_OP_SH; dm_we = 1; rf_we = 0; end  // sh
            6'b101011:  begin   alu_op = `ALU_OP_ADD; dm_op = `DM_OP_WD; dm_we = 1; rf_we = 0; end  // sw
          endcase
      end
endmodule
