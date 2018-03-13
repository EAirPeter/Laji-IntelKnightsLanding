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
			w_en_datamem = 0;
			syscall_en = 0;
			// default is for the 
			mux_regfile_req_w = `MUX_RF_REQW_RT;
			mux_regfile_data_w = `MUX_RF_DATAW_ALU;
			mux_alu_data_w = `MUX_ALU_DATAY_EXTS;
			is_jump = 0;
			is_branch = 0;
			// mux_regfile_req_w = 
			// 
			case(opcode)
				6'000000: 
					begin 
						mux_regfile_req_w 	= `MUX_RF_REQW_RD;
						mux_regfile_data_w 	= `MUX_RF_DATAW_ALU;
						mux_alu_data_w 			= `MUX_ALU_DATAY_RFB;
						case(funct)
							6'000000:			alu = `ALU_OP_SLL;		// sll
							6'000010:			alu = `ALU_OP_SRL;		// srl
							6'000011:			alu = `ALU_OP_SRA;		// sra
							6'000100:			alu = `ALU_OP_SLLV;		// sllv
							6'000110:			alu = `ALU_OP_SRLV;		// srlv
							6'000111:			alu = `ALU_OP_SRAV;		// srav
							6'001000:			// alu_placeholder							// jr
								begin
														op_wtg = `WTG_OP_J32;
														is_jump = 1;
								end
							6'001100:			// alu_placeholder							// syscall
								begin
														syscall_en = 1;
								end
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
					end
				6'000001: 
				// 6'000001: //bgez
					case(rt)
						5'00000: 			op_wtg = `WTG_OP_BLTZ;	 // bltz
						5'00001: 			op_alu = `WTG_OP_BGEZ;  // bgez
					endcase
				6'000010: begin op_wtg = j;    	is_jump   = 1; end			// j
				6'000011: begin op_wtg = jal;  	is_jump   = 1; 
										mux_regfile_req_w = `MUX_RF_REQW_31;
										mux_regfile_data_w = `MUX_RF_DATAW_PC4;
									end			// jal
				6'000100: begin op_wtg = beq;  	is_branch = 1; end			// beq
				6'000101: begin op_wtg = bne;  	is_branch = 1; end			// bne
				6'000110: begin op_wtg = blez; 	is_branch = 1; end			// blez
				6'000111: begin op_wtg = bgtz; 	is_branch = 1; end			// bgtz

				6'001000: alu = `ALU_OP_ADD;			// addi
				6'001001: alu = `ALU_OP_ADD;			// addiu
				6'001010: alu = `ALU_OP_SLT;			// slti
				6'001011: alu = `ALU_OP_SLTU;			// sltiu

				6'001100: begin alu = `ALU_OP_AND; mux_alu_data_w = `MUX_ALU_DATAY_EXTZ; end	// andi
				6'001101: begin alu = `ALU_OP_OR;	 mux_alu_data_w = `MUX_ALU_DATAY_EXTZ; end	// ori
				6'001110: begin alu = `ALU_OP_XOR; mux_alu_data_w = `MUX_ALU_DATAY_EXTZ; end	// xori

				6'001111: begin alu = `ALU_OP_LUI; mux_regfile_data_w = `MUX_RF_DATAW_DM; end	// lui
				6'100000: begin alu = `ALU_OP_ADD; mux_regfile_data_w = `MUX_RF_DATAW_DM; op_datamem = `DM_OP_SB; end	// lb
				6'100001: begin alu = `ALU_OP_ADD; mux_regfile_data_w = `MUX_RF_DATAW_DM; op_datamem = `DM_OP_SH; end	// lh
				6'100011: begin alu = `ALU_OP_ADD; mux_regfile_data_w = `MUX_RF_DATAW_DM; op_datamem = `DM_OP_WD; end	// lw
				6'100100: begin alu = `ALU_OP_ADD; mux_regfile_data_w = `MUX_RF_DATAW_DM; op_datamem = `DM_OP_UB; end	// lbu
				6'100101: begin alu = `ALU_OP_ADD; mux_regfile_data_w = `MUX_RF_DATAW_DM; op_datamem = `DM_OP_UH; end	// lhu

				6'101000: begin alu = `ALU_OP_ADD; op_datamem = `DM_OP_SB; end			// sb
				6'101001: begin alu = `ALU_OP_ADD; op_datamem = `DM_OP_SH; end			// sh
				6'101011: begin alu = `ALU_OP_ADD; op_datamem = `DM_OP_WD; end			// sw
			endcase
		end
endmodule




























































