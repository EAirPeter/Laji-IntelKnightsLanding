`timescale 1ns / 1ps
`include "Core.vh"
// Brief: Control Module, synchronized
// Author: FluorineDog
module CmbControl(opcode, rt, funct, op_wtg, w_en_regfile, op_alu, op_datamem, w_en_datamem, syscall_en, mux_regfile_req_w, mux_regfile_data_w, mux_alu_data_y, is_jump, is_branch);
    input [5:0] opcode;
    input [4:0] rt;
    input [5:0] funct;
    output reg [`WTG_OP_BIT - 1:0] op_wtg;
    output reg w_en_regfile;
    output [`ALU_OP_BIT - 1:0] op_alu; // alias to alu to increase Hamming Distance 
    output reg [`DM_OP_BIT - 1:0] op_datamem;
    output reg w_en_datamem;
    output reg syscall_en;
    output reg [`MUX_RF_REQW_BIT - 1:0] mux_regfile_req_w;
    output reg [`MUX_RF_DATAW_BIT - 1:0] mux_regfile_data_w;
    output reg [`MUX_ALU_DATAY_BIT - 1:0] mux_alu_data_y;
    output reg is_jump;     // 1 if the current instruction is a jump instruction
    output reg is_branch;   // 1 if the current instruction is a branch instraction

		wire is_bgez = rt[0];
		reg alu[`ALU_OP_BIT - 1:0];
		assign op_alu = alu; 

		always@(*)
			op_wtg = `WTG_OP_J32;
			alu = `ALU_OP_AND;
			op_datamem = `DM_OP_WD;	
			case(opcode)
				6'000000: 
					case(funct)
						6'000000:			alu = `ALU_OP_SLL;		// sll
						6'000010:			alu = `ALU_OP_SRL;		// srl
						6'000011:			alu = `ALU_OP_SRA;		// sra
						6'000100:			alu = `ALU_OP_SLLV;		// sllv
						6'000110:			alu = `ALU_OP_SRLV;		// srlv
						6'000111:			alu = `ALU_OP_SRAV;		// srav
						6'001000:			// alu_placeholder							// jr
													op_wtg = `WTG_OP_J32;
													is_jump = 1;
						6'001100:			// alu_placeholder							// syscall
						6'100000:			alu = `ALU_OP_ADD;		// add
						6'100001:			alu = `ALU_OP_ADD;		// addu
						6'100010:			alu = `ALU_OP_SUB;		// sub
						6'100011:			alu = `ALU_OP_SUB;		// subu
						6'100100:			alu = `ALU_OP_AND;		// and
						6'100101:			alu = `ALU_OP_OR;			// or
						6'100110:			alu = `ALU_OP_XOR;		// xor
						6'100111:			alu = `ALU_OP_NOR;		// nor
						6'101010:			alu = `ALU_OP_SLT;		// slt
						6'101011:			alu = `ALU_OP_SLTU;		// sltu
					endcase
				6'000001: 
				// 6'000001: //bgez
					case(rt)
						5'00000: 			op_wtg = `WTG_OP_BLTZ;	 // bltz
						5'00001: 			op_alu = `WTG_OP_BGEZ;  // bgez
					endcase
				6'000010: // j
				6'000011: // jal
				6'000100: // beq
				6'000101: // bne
				6'000110: // blez
				6'000111: // bgtz
				6'001000: // addi
				6'001001: // addiu
				6'001010: // slti
				6'001011: // sltiu
				6'001100: // andi
				6'001101: // ori
				6'001110: // xori
				6'001111: // lui
				6'100000: // lb
				6'100001: // lh
				6'100011: // lw
				6'100100: // lbu
				6'100101: // lhu
				6'101000: // sb
				6'101001: // sh
				6'101011: // sw
			endcase
		end
		assign is_jump = 
endmodule




























































