`ifndef lajiintel_auxiliary_vh_
`define lajiintel_auxiliary_vh_

`define CNT_CLKPULSE(cp_) (cp_)
`define CNT_MICROSEC(us_) ((us_) * 100)
`define CNT_MILLISEC(ms_) ((ms_) * 100_000)
`define CNT_SEC(s_) ((s_) * 100_000_000)

`define MUX_DISP_DATA_BIT       3
`define MUX_DISP_DATA_CORE      `MUX_DISP_DATA_BIT'h0
`define MUX_DISP_DATA_CNT_CYC   `MUX_DISP_DATA_BIT'h1
`define MUX_DISP_DATA_CNT_JMP   `MUX_DISP_DATA_BIT'h2
`define MUX_DISP_DATA_CNT_BCH   `MUX_DISP_DATA_BIT'h3
`define MUX_DISP_DATA_CNT_BED   `MUX_DISP_DATA_BIT'h4
`define MUX_DISP_DATA_RF_DBG    `MUX_DISP_DATA_BIT'h5
`define MUX_DISP_DATA_DM_DBG    `MUX_DISP_DATA_BIT'h6

`endif
