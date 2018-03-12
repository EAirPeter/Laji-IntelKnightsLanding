`ifndef lajiintel_auxiliary_vh_
`define lajiintel_auxiliary_vh_

`define CNT_CLKPULSE(cp_) (cp_)
`define CNT_MICROSEC(us_) ((us_) * 100)
`define CNT_MILLISEC(ms_) ((ms_) * 100_000)
`define CNT_SEC(s_) ((s_) * 100_000_000)

`define DISP_OP_BIT         3
`define DISP_OP_CORE        `DISP_OP_BIT'h0
`define DISP_OP_CNT_CYC     `DISP_OP_BIT'h1
`define DISP_OP_CNT_JMP     `DISP_OP_BIT'h2
`define DISP_OP_CNT_BCH     `DISP_OP_BIT'h3
`define DISP_OP_CNT_BED     `DISP_OP_BIT'h4
`define DISP_OP_RF_DBG      `DISP_OP_BIT'h5
`define DISP_OP_DM_DBG      `DISP_OP_BIT'h6

`endif
