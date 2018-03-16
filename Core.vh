`ifndef LAJIINTEL_CORE_VH_
`define LAJIINTEL_CORE_VH_

`define IM_ADDR_BIT         10
`define DM_ADDR_BIT         12

// WhereToGo.operation
`define WTG_OP_BIT          3
`define WTG_OP_J32          `WTG_OP_BIT'h0      //  Set pc_new to data_x
`define WTG_OP_J26          `WTG_OP_BIT'h1      //  Set pc_new to {pc_4[31:28], imm26, 2'b00}
// Conditional branch, set pc_new to pc_4 + {off32[29:0], 2'b00} when
//   condition is met. Comparision between data_x and data_y or zero.
`define WTG_OP_BEQ          `WTG_OP_BIT'h2      
`define WTG_OP_BNE          `WTG_OP_BIT'h3
`define WTG_OP_BLEZ         `WTG_OP_BIT'h4
`define WTG_OP_BGTZ         `WTG_OP_BIT'h5
`define WTG_OP_BLTZ         `WTG_OP_BIT'h6
`define WTG_OP_BGEZ         `WTG_OP_BIT'h7

// ArithmeticLogicUnit.operation
`define ALU_OP_BIT          4
`define ALU_OP_AND          `ALU_OP_BIT'h0
`define ALU_OP_OR           `ALU_OP_BIT'h1
`define ALU_OP_XOR          `ALU_OP_BIT'h2
`define ALU_OP_NOR          `ALU_OP_BIT'h3
`define ALU_OP_ADD          `ALU_OP_BIT'h4
`define ALU_OP_SUB          `ALU_OP_BIT'h5
`define ALU_OP_SLLV         `ALU_OP_BIT'h6
`define ALU_OP_SRAV         `ALU_OP_BIT'h7
`define ALU_OP_SRLV         `ALU_OP_BIT'h8
// shamt used by the following 3 instructions
`define ALU_OP_SLL          `ALU_OP_BIT'h9
`define ALU_OP_SRA          `ALU_OP_BIT'ha
`define ALU_OP_SRL          `ALU_OP_BIT'hb

`define ALU_OP_SLT          `ALU_OP_BIT'hc
`define ALU_OP_SLTU         `ALU_OP_BIT'hd
// data_y << 16, shamt not used
`define ALU_OP_LUI          `ALU_OP_BIT'he

// DataMemory.operation
// S stands for Signed, U for Unsigned
// B for Byte, H for Half-word, WD for word 
`define DM_OP_BIT           3
`define DM_OP_SB            `DM_OP_BIT'h0
`define DM_OP_UB            `DM_OP_BIT'h1
`define DM_OP_SH            `DM_OP_BIT'h2
`define DM_OP_UH            `DM_OP_BIT'h3
`define DM_OP_WD            `DM_OP_BIT'h4

// Multiplexer.RegisterFile.register_number_requested_to_write
`define MUX_RF_REQW_BIT     2
// Register $(rd)
`define MUX_RF_REQW_RD      `MUX_RF_REQW_BIT'h0
// Register $(rt)
`define MUX_RF_REQW_RT      `MUX_RF_REQW_BIT'h1
// Register $ra
`define MUX_RF_REQW_31      `MUX_RF_REQW_BIT'h2

// Multiplexer.RegisterFile.data_requested_to_write
`define MUX_RF_DATAW_BIT    2
// Output of ALU
`define MUX_RF_DATAW_ALU    `MUX_RF_DATAW_BIT'h0
// PC + 4
`define MUX_RF_DATAW_PC4    `MUX_RF_DATAW_BIT'h1
// Output of DataMem
`define MUX_RF_DATAW_DM     `MUX_RF_DATAW_BIT'h2

// Multiplexer.ArithmeticLogicUnit.data_y
`define MUX_ALU_DATAY_BIT   2
// RegFile port B
`define MUX_ALU_DATAY_RFB   `MUX_ALU_DATAY_BIT'h0
// Sign-extended imm16
`define MUX_ALU_DATAY_EXTS  `MUX_ALU_DATAY_BIT'h1
// Zero-extended imm16
`define MUX_ALU_DATAY_EXTZ  `MUX_ALU_DATAY_BIT'h2

`endif
