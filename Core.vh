`ifndef LAJIINTEL_CORE_VH_
`define LAJIINTEL_CORE_VH_

`define IM_ADDR_NBIT         10
`define DM_ADDR_NBIT         12

// BranchHistoryTable.operation
`define BHT_OP_NBIT         2
`define BHT_OP_NOP          `WTG_OP_NBIT'h0
`define BHT_OP_SET          `WTG_OP_NBIT'h1
`define BHT_OP_DEC          `WTG_OP_NBIT'h2
`define BHT_OP_INC          `WTG_OP_NBIT'h3

// WhereToGo.operation
`define WTG_OP_NBIT         3
`define WTG_OP_JNO          `WTG_OP_NBIT'h0
`define WTG_OP_J32          `WTG_OP_NBIT'h1      //  Set pc_new to data_x
`define WTG_OP_J26          `WTG_OP_NBIT'h2      //  Set pc_new to {pc_4[31:28], imm26, 2'b00}
// Conditional branch, set pc_new to pc_4 + {off32[29:0], 2'b00} when
//   condition is met. Comparision between data_x and data_y or zero.
`define WTG_OP_BEQ          `WTG_OP_NBIT'h3
`define WTG_OP_BNE          `WTG_OP_NBIT'h4
`define WTG_OP_BGEZ         `WTG_OP_NBIT'h5

// ArithmeticLogicUnit.operation
`define ALU_OP_NBIT         4
`define ALU_OP_AND          `ALU_OP_NBIT'h0
`define ALU_OP_OR           `ALU_OP_NBIT'h1
`define ALU_OP_XOR          `ALU_OP_NBIT'h2
`define ALU_OP_NOR          `ALU_OP_NBIT'h3
`define ALU_OP_ADD          `ALU_OP_NBIT'h4
`define ALU_OP_SUB          `ALU_OP_NBIT'h5
`define ALU_OP_SLLV         `ALU_OP_NBIT'h6
// shamt used by the following 3 instructions
`define ALU_OP_SLL          `ALU_OP_NBIT'h7
`define ALU_OP_SRA          `ALU_OP_NBIT'h8
`define ALU_OP_SRL          `ALU_OP_NBIT'h9

`define ALU_OP_SLT          `ALU_OP_NBIT'ha
`define ALU_OP_SLTU         `ALU_OP_NBIT'hb
// data_y << 16, shamt not used
`define ALU_OP_LUI          `ALU_OP_NBIT'hc

// DataMemory.operation
// S stands for Signed, U for Unsigned
// B for Byte, H for Half-word, WD for word 
`define DM_OP_NBIT          1
`define DM_OP_WD            `DM_OP_NBIT'h0
`define DM_OP_UB            `DM_OP_NBIT'h1

// Multiplexer.RegisterFile.register_number_requested_to_write
`define MUX_RF_REQW_NBIT    2
// Register $(rd)
`define MUX_RF_REQW_RD      `MUX_RF_REQW_NBIT'h0
// Register $(rt)
`define MUX_RF_REQW_RT      `MUX_RF_REQW_NBIT'h1
// Register $ra
`define MUX_RF_REQW_31      `MUX_RF_REQW_NBIT'h2

// Multiplexer.RegisterFile.data_requested_to_write
`define MUX_RF_DATAW_NBIT   2
// Output of ALU
`define MUX_RF_DATAW_ALU    `MUX_RF_DATAW_NBIT'h0
// PC + 4
`define MUX_RF_DATAW_PC4    `MUX_RF_DATAW_NBIT'h1
// Output of DataMem
`define MUX_RF_DATAW_DM     `MUX_RF_DATAW_NBIT'h2

// Multiplexer.ArithmeticLogicUnit.data_y
`define MUX_ALU_DATAY_NBIT  2
// RegFile port B
`define MUX_ALU_DATAY_RFB   `MUX_ALU_DATAY_NBIT'h0
// Sign-extended imm16
`define MUX_ALU_DATAY_EXTS  `MUX_ALU_DATAY_NBIT'h1
// Zero-extended imm16
`define MUX_ALU_DATAY_EXTZ  `MUX_ALU_DATAY_NBIT'h2

// Multiplexer.Forwarding.register_file
`define MUX_FWD_RF_NBIT     2
`define MUX_FWD_RF_NORM     `MUX_FWD_RF_NBIT'h0
`define MUX_FWD_RF_TMP      `MUX_FWD_RF_NBIT'h2
`define MUX_FWD_RF_DAT      `MUX_FWD_RF_NBIT'h3

`endif
