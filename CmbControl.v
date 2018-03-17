`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Control Module, synchronized
// Author: FluorineDog
module CmbControl(
	opcode, rt, funct,
	op_wtg, w_en_regfile, op_alu, op_datamem, w_en_datamem, syscall_en,
	mux_regfile_req_w, mux_regfile_data_w, mux_alu_data_y, is_jump, is_branch
);
	input [5:0] opcode;
	input [4:0] rt;
	input [5:0] funct;
	output reg [`WTG_OP_BIT - 1:0] op_wtg;
	output reg w_en_regfile;
	output reg [`ALU_OP_BIT - 1:0] op_alu; // alias to alu to increase Hamming Distance 
	output reg [`DM_OP_BIT - 1:0] op_datamem;
	output reg w_en_datamem;
	output reg syscall_en;
	output reg [`MUX_RF_REQW_BIT - 1:0] mux_regfile_req_w;
	output reg [`MUX_RF_DATAW_BIT - 1:0] mux_regfile_data_w;
	output reg [`MUX_ALU_DATAY_BIT - 1:0] mux_alu_data_y;
	output reg is_jump;     // 1 if the current instruction is a jump instruction
	output reg is_branch;   // 1 if the current instruction is a branch instraction

	always@(*) begin
		op_wtg = `WTG_OP_J32;
		op_alu = `ALU_OP_AND;
		op_datamem = `DM_OP_WD;  
		w_en_regfile = 1;
		w_en_datamem = 0;
		syscall_en = 0;

		mux_regfile_req_w = `MUX_RF_REQW_RT;
		mux_regfile_data_w = `MUX_RF_DATAW_ALU;
		mux_alu_data_y = `MUX_ALU_DATAY_EXTS;
		is_jump = 0;
		is_branch = 0;
		case(opcode)
			6'b000000:  begin 
				mux_regfile_req_w   = `MUX_RF_REQW_RD;
				mux_regfile_data_w  = `MUX_RF_DATAW_ALU;
				mux_alu_data_y      = `MUX_ALU_DATAY_RFB;
				case(funct)
					6'b000000:  op_alu = `ALU_OP_SLL;       // sll
					6'b000010:  op_alu = `ALU_OP_SRL;       // srl
					6'b000011:  op_alu = `ALU_OP_SRA;       // sra
					6'b000100:  op_alu = `ALU_OP_SLLV;      // sllv
					6'b000110:  op_alu = `ALU_OP_SRLV;      // srlv
					6'b000111:  op_alu = `ALU_OP_SRAV;      // srav
					6'b001000:  begin                       // jr
						op_wtg = `WTG_OP_J32;
						is_jump = 1;
						w_en_regfile = 0;
					end
					6'b001100:  begin                       // syscall
						syscall_en = 1;
						w_en_regfile = 0;
					end
					6'b100000:  op_alu = `ALU_OP_ADD;       // add
					6'b100001:  op_alu = `ALU_OP_ADD;       // addu
					6'b100010:  op_alu = `ALU_OP_SUB;       // sub
					6'b100011:  op_alu = `ALU_OP_SUB;       // subu
					6'b100100:  op_alu = `ALU_OP_AND;       // and
					6'b100101:  op_alu = `ALU_OP_OR;        // or
					6'b100110:  op_alu = `ALU_OP_XOR;       // xor
					6'b100111:  op_alu = `ALU_OP_NOR;       // nor
					6'b101010:  op_alu = `ALU_OP_SLT;       // slt
					6'b101011:  op_alu = `ALU_OP_SLTU;      // sltu
				endcase
			end

			6'b000001:  begin
				w_en_regfile = 0;
				case(rt[0])
					1'b0: begin op_wtg = `WTG_OP_BLTZ;  is_branch = 1; end  // bltz
					1'b1: begin op_wtg = `WTG_OP_BGEZ;  is_branch = 1; end  // bgez
				endcase
			end
			6'b000010:  begin   op_wtg = `WTG_OP_J26;   is_jump   = 1; w_en_regfile = 0; end    // j
			6'b000011:  begin   op_wtg = `WTG_OP_J26;   is_jump   = 1;                          // jal
				mux_regfile_req_w = `MUX_RF_REQW_31;
				mux_regfile_data_w = `MUX_RF_DATAW_PC4;
			end
			6'b000100:  begin   op_wtg = `WTG_OP_BEQ;   is_branch = 1; w_en_regfile = 0; end    // beq
			6'b000101:  begin   op_wtg = `WTG_OP_BNE;   is_branch = 1; w_en_regfile = 0; end    // bne
			6'b000110:  begin   op_wtg = `WTG_OP_BLEZ;  is_branch = 1; w_en_regfile = 0; end    // blez
			6'b000111:  begin   op_wtg = `WTG_OP_BGTZ;  is_branch = 1; w_en_regfile = 0; end    // bgtz

			6'b001000:          op_alu = `ALU_OP_ADD;       // addi
			6'b001001:          op_alu = `ALU_OP_ADD;       // addiu
			6'b001010:          op_alu = `ALU_OP_SLT;       // slti
			6'b001011:          op_alu = `ALU_OP_SLTU;      // sltiu

			6'b001100:  begin   op_alu = `ALU_OP_AND; mux_alu_data_y = `MUX_ALU_DATAY_EXTZ; end     // andi
			6'b001101:  begin   op_alu = `ALU_OP_OR;  mux_alu_data_y = `MUX_ALU_DATAY_EXTZ; end     // ori
			6'b001110:  begin   op_alu = `ALU_OP_XOR; mux_alu_data_y = `MUX_ALU_DATAY_EXTZ; end     // xori

			6'b001111:  begin   op_alu = `ALU_OP_LUI; mux_regfile_data_w = `MUX_RF_DATAW_ALU; end   // lui

			6'b100000:  begin   op_alu = `ALU_OP_ADD; mux_regfile_data_w = `MUX_RF_DATAW_DM; op_datamem = `DM_OP_SB; end    // lb
			6'b100001:  begin   op_alu = `ALU_OP_ADD; mux_regfile_data_w = `MUX_RF_DATAW_DM; op_datamem = `DM_OP_SH; end    // lh
			6'b100011:  begin   op_alu = `ALU_OP_ADD; mux_regfile_data_w = `MUX_RF_DATAW_DM; op_datamem = `DM_OP_WD; end    // lw
			6'b100100:  begin   op_alu = `ALU_OP_ADD; mux_regfile_data_w = `MUX_RF_DATAW_DM; op_datamem = `DM_OP_UB; end    // lbu
			6'b100101:  begin   op_alu = `ALU_OP_ADD; mux_regfile_data_w = `MUX_RF_DATAW_DM; op_datamem = `DM_OP_UH; end    // lhu

			6'b101000:  begin   op_alu = `ALU_OP_ADD; op_datamem = `DM_OP_SB; w_en_datamem = 1; w_en_regfile = 0; end       // sb
			6'b101001:  begin   op_alu = `ALU_OP_ADD; op_datamem = `DM_OP_SH; w_en_datamem = 1; w_en_regfile = 0; end       // sh
			6'b101011:  begin   op_alu = `ALU_OP_ADD; op_datamem = `DM_OP_WD; w_en_datamem = 1; w_en_regfile = 0; end       // sw
		  endcase
	  end
endmodule
