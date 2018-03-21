`define GEN_F____(nbit_, name_) wire [(nbit_) - 1:0] if_``name_;
`define GEN_FD___(nbit_, name_) wire [(nbit_) - 1:0] if_``name_, id_``name_;
`define GEN_FDX__(nbit_, name_) wire [(nbit_) - 1:0] if_``name_, id_``name_, ex_``name_;
`define GEN_FDXM_(nbit_, name_) wire [(nbit_) - 1:0] if_``name_, id_``name_, ex_``name_, ma_``name_;
`define GEN_FDXMW(nbit_, name_) wire [(nbit_) - 1:0] if_``name_, id_``name_, ex_``name_, ma_``name_, wb_``name_;
`define GEN_FDO__(nbit_, name_) wire [(nbit_) - 1:0] if_``name_, id_``name_, ex_``name_``_old, ex_``name_;
`define GEN_FDOM_(nbit_, name_) wire [(nbit_) - 1:0] if_``name_, id_``name_, ex_``name_``_old, ex_``name_, ma_``name_;
`define GEN_FDOMW(nbit_, name_) wire [(nbit_) - 1:0] if_``name_, id_``name_, ex_``name_``_old, ex_``name_, ma_``name_, wb_``name_;
`define GEN__D___(nbit_, name_) wire [(nbit_) - 1:0] id_``name_;
`define GEN__DX__(nbit_, name_) wire [(nbit_) - 1:0] id_``name_, ex_``name_;
`define GEN__DXM_(nbit_, name_) wire [(nbit_) - 1:0] id_``name_, ex_``name_, ma_``name_;
`define GEN__DXMW(nbit_, name_) wire [(nbit_) - 1:0] id_``name_, ex_``name_, ma_``name_, wb_``name_;
`define GEN__DO__(nbit_, name_) wire [(nbit_) - 1:0] id_``name_, ex_``name_``_old, ex_``name_;
`define GEN__DOM_(nbit_, name_) wire [(nbit_) - 1:0] id_``name_, ex_``name_``_old, ex_``name_, ma_``name_;
`define GEN__DOMW(nbit_, name_) wire [(nbit_) - 1:0] id_``name_, ex_``name_``_old, ex_``name_, ma_``name_, wb_``name_;
`define GEN___X__(nbit_, name_) wire [(nbit_) - 1:0] ex_``name_;
`define GEN___XM_(nbit_, name_) wire [(nbit_) - 1:0] ex_``name_, ma_``name_;
`define GEN___XMW(nbit_, name_) wire [(nbit_) - 1:0] ex_``name_, ma_``name_, wb_``name_;
`define GEN____M_(nbit_, name_) wire [(nbit_) - 1:0] ma_``name_;
`define GEN____MW(nbit_, name_) wire [(nbit_) - 1:0] ma_``name_, wb_``name_;
`define GEN_____W(nbit_, name_) wire [(nbit_) - 1:0] wb_``name_;
`GEN_DAT
`include "GenUndef.vh"
wire pipltmp_IFID;
SynPiplIntf #(
`define GEN_F____(nbit_, name_)
`define GEN_FD___(nbit_, name_) + (nbit_)
`define GEN_FDX__(nbit_, name_) + (nbit_)
`define GEN_FDXM_(nbit_, name_) + (nbit_)
`define GEN_FDXMW(nbit_, name_) + (nbit_)
`define GEN_FDO__(nbit_, name_) + (nbit_)
`define GEN_FDOM_(nbit_, name_) + (nbit_)
`define GEN_FDOMW(nbit_, name_) + (nbit_)
`define GEN__D___(nbit_, name_)
`define GEN__DX__(nbit_, name_)
`define GEN__DXM_(nbit_, name_)
`define GEN__DXMW(nbit_, name_)
`define GEN__DO__(nbit_, name_)
`define GEN__DOM_(nbit_, name_)
`define GEN__DOMW(nbit_, name_)
`define GEN___X__(nbit_, name_)
`define GEN___XM_(nbit_, name_)
`define GEN___XMW(nbit_, name_)
`define GEN____M_(nbit_, name_)
`define GEN____MW(nbit_, name_)
`define GEN_____W(nbit_, name_)
    .NBit(1 `GEN_DAT)
`include "GenUndef.vh"
) vIFID(
    .clk(clk),
    .rst_n(rst_n),
`ifdef PIF_IFID_ENA
    .en(`PIF_IFID_ENA),
`else
    .en(en),
`endif
`ifdef PIF_IFID_NOP
    .nop(`PIF_IFID_NOP),
`else
    .nop(1'b0),
`endif
`define GEN_F____(nbit_, name_)
`define GEN_FD___(nbit_, name_) , if_``name_
`define GEN_FDX__(nbit_, name_) , if_``name_
`define GEN_FDXM_(nbit_, name_) , if_``name_
`define GEN_FDXMW(nbit_, name_) , if_``name_
`define GEN_FDO__(nbit_, name_) , if_``name_
`define GEN_FDOM_(nbit_, name_) , if_``name_
`define GEN_FDOMW(nbit_, name_) , if_``name_
`define GEN__D___(nbit_, name_)
`define GEN__DX__(nbit_, name_)
`define GEN__DXM_(nbit_, name_)
`define GEN__DXMW(nbit_, name_)
`define GEN__DO__(nbit_, name_)
`define GEN__DOM_(nbit_, name_)
`define GEN__DOMW(nbit_, name_)
`define GEN___X__(nbit_, name_)
`define GEN___XM_(nbit_, name_)
`define GEN___XMW(nbit_, name_)
`define GEN____M_(nbit_, name_)
`define GEN____MW(nbit_, name_)
`define GEN_____W(nbit_, name_)
    .data_i({1'b0 `GEN_DAT}),
`include "GenUndef.vh"
`define GEN_F____(nbit_, name_)
`define GEN_FD___(nbit_, name_) , id_``name_
`define GEN_FDX__(nbit_, name_) , id_``name_
`define GEN_FDXM_(nbit_, name_) , id_``name_
`define GEN_FDXMW(nbit_, name_) , id_``name_
`define GEN_FDO__(nbit_, name_) , id_``name_
`define GEN_FDOM_(nbit_, name_) , id_``name_
`define GEN_FDOMW(nbit_, name_) , id_``name_
`define GEN__D___(nbit_, name_)
`define GEN__DX__(nbit_, name_)
`define GEN__DXM_(nbit_, name_)
`define GEN__DXMW(nbit_, name_)
`define GEN__DO__(nbit_, name_)
`define GEN__DOM_(nbit_, name_)
`define GEN__DOMW(nbit_, name_)
`define GEN___X__(nbit_, name_)
`define GEN___XM_(nbit_, name_)
`define GEN___XMW(nbit_, name_)
`define GEN____M_(nbit_, name_)
`define GEN____MW(nbit_, name_)
`define GEN_____W(nbit_, name_)
    .data_o({pipltmp_IFID `GEN_DAT})
`include "GenUndef.vh"
);
wire pipltmp_IDEX;
SynPiplIntf #(
`define GEN_F____(nbit_, name_)
`define GEN_FD___(nbit_, name_)
`define GEN_FDX__(nbit_, name_) + (nbit_)
`define GEN_FDXM_(nbit_, name_) + (nbit_)
`define GEN_FDXMW(nbit_, name_) + (nbit_)
`define GEN_FDO__(nbit_, name_) + (nbit_)
`define GEN_FDOM_(nbit_, name_) + (nbit_)
`define GEN_FDOMW(nbit_, name_) + (nbit_)
`define GEN__D___(nbit_, name_)
`define GEN__DX__(nbit_, name_) + (nbit_)
`define GEN__DXM_(nbit_, name_) + (nbit_)
`define GEN__DXMW(nbit_, name_) + (nbit_)
`define GEN__DO__(nbit_, name_) + (nbit_)
`define GEN__DOM_(nbit_, name_) + (nbit_)
`define GEN__DOMW(nbit_, name_) + (nbit_)
`define GEN___X__(nbit_, name_)
`define GEN___XM_(nbit_, name_)
`define GEN___XMW(nbit_, name_)
`define GEN____M_(nbit_, name_)
`define GEN____MW(nbit_, name_)
`define GEN_____W(nbit_, name_)
    .NBit(1 `GEN_DAT)
`include "GenUndef.vh"
) vIDEX(
    .clk(clk),
    .rst_n(rst_n),
`ifdef PIF_IDEX_ENA
    .en(`PIF_IDEX_ENA),
`else
    .en(en),
`endif
`ifdef PIF_IDEX_NOP
    .nop(`PIF_IDEX_NOP),
`else
    .nop(1'b0),
`endif
`define GEN_F____(nbit_, name_)
`define GEN_FD___(nbit_, name_)
`define GEN_FDX__(nbit_, name_) , id_``name_
`define GEN_FDXM_(nbit_, name_) , id_``name_
`define GEN_FDXMW(nbit_, name_) , id_``name_
`define GEN_FDO__(nbit_, name_) , id_``name_
`define GEN_FDOM_(nbit_, name_) , id_``name_
`define GEN_FDOMW(nbit_, name_) , id_``name_
`define GEN__D___(nbit_, name_)
`define GEN__DX__(nbit_, name_) , id_``name_
`define GEN__DXM_(nbit_, name_) , id_``name_
`define GEN__DXMW(nbit_, name_) , id_``name_
`define GEN__DO__(nbit_, name_) , id_``name_
`define GEN__DOM_(nbit_, name_) , id_``name_
`define GEN__DOMW(nbit_, name_) , id_``name_
`define GEN___X__(nbit_, name_)
`define GEN___XM_(nbit_, name_)
`define GEN___XMW(nbit_, name_)
`define GEN____M_(nbit_, name_)
`define GEN____MW(nbit_, name_)
`define GEN_____W(nbit_, name_)
    .data_i({1'b0 `GEN_DAT}),
`include "GenUndef.vh"
`define GEN_F____(nbit_, name_)
`define GEN_FD___(nbit_, name_)
`define GEN_FDX__(nbit_, name_) , ex_``name_
`define GEN_FDXM_(nbit_, name_) , ex_``name_
`define GEN_FDXMW(nbit_, name_) , ex_``name_
`define GEN_FDO__(nbit_, name_) , ex_``name_``_old
`define GEN_FDOM_(nbit_, name_) , ex_``name_``_old
`define GEN_FDOMW(nbit_, name_) , ex_``name_``_old
`define GEN__D___(nbit_, name_)
`define GEN__DX__(nbit_, name_) , ex_``name_
`define GEN__DXM_(nbit_, name_) , ex_``name_
`define GEN__DXMW(nbit_, name_) , ex_``name_
`define GEN__DO__(nbit_, name_) , ex_``name_``_old
`define GEN__DOM_(nbit_, name_) , ex_``name_``_old
`define GEN__DOMW(nbit_, name_) , ex_``name_``_old
`define GEN___X__(nbit_, name_)
`define GEN___XM_(nbit_, name_)
`define GEN___XMW(nbit_, name_)
`define GEN____M_(nbit_, name_)
`define GEN____MW(nbit_, name_)
`define GEN_____W(nbit_, name_)
    .data_o({pipltmp_IDEX `GEN_DAT})
`include "GenUndef.vh"
);
wire pipltmp_EXMA;
SynPiplIntf #(
`define GEN_F____(nbit_, name_)
`define GEN_FD___(nbit_, name_)
`define GEN_FDX__(nbit_, name_)
`define GEN_FDXM_(nbit_, name_) + (nbit_)
`define GEN_FDXMW(nbit_, name_) + (nbit_)
`define GEN_FDO__(nbit_, name_)
`define GEN_FDOM_(nbit_, name_) + (nbit_)
`define GEN_FDOMW(nbit_, name_) + (nbit_)
`define GEN__D___(nbit_, name_)
`define GEN__DX__(nbit_, name_)
`define GEN__DXM_(nbit_, name_) + (nbit_)
`define GEN__DXMW(nbit_, name_) + (nbit_)
`define GEN__DO__(nbit_, name_)
`define GEN__DOM_(nbit_, name_) + (nbit_)
`define GEN__DOMW(nbit_, name_) + (nbit_)
`define GEN___X__(nbit_, name_)
`define GEN___XM_(nbit_, name_) + (nbit_)
`define GEN___XMW(nbit_, name_) + (nbit_)
`define GEN____M_(nbit_, name_)
`define GEN____MW(nbit_, name_)
`define GEN_____W(nbit_, name_)
    .NBit(1 `GEN_DAT)
`include "GenUndef.vh"
) vEXMA(
    .clk(clk),
    .rst_n(rst_n),
`ifdef PIF_EXMA_ENA
    .en(`PIF_EXMA_ENA),
`else
    .en(en),
`endif
`ifdef PIF_EXMA_NOP
    .nop(`PIF_EXMA_NOP),
`else
    .nop(1'b0),
`endif
`define GEN_F____(nbit_, name_)
`define GEN_FD___(nbit_, name_)
`define GEN_FDX__(nbit_, name_)
`define GEN_FDXM_(nbit_, name_) , ex_``name_
`define GEN_FDXMW(nbit_, name_) , ex_``name_
`define GEN_FDO__(nbit_, name_)
`define GEN_FDOM_(nbit_, name_) , ex_``name_
`define GEN_FDOMW(nbit_, name_) , ex_``name_
`define GEN__D___(nbit_, name_)
`define GEN__DX__(nbit_, name_)
`define GEN__DXM_(nbit_, name_) , ex_``name_
`define GEN__DXMW(nbit_, name_) , ex_``name_
`define GEN__DO__(nbit_, name_)
`define GEN__DOM_(nbit_, name_) , ex_``name_
`define GEN__DOMW(nbit_, name_) , ex_``name_
`define GEN___X__(nbit_, name_)
`define GEN___XM_(nbit_, name_) , ex_``name_
`define GEN___XMW(nbit_, name_) , ex_``name_
`define GEN____M_(nbit_, name_)
`define GEN____MW(nbit_, name_)
`define GEN_____W(nbit_, name_)
    .data_i({1'b0 `GEN_DAT}),
`include "GenUndef.vh"
`define GEN_F____(nbit_, name_)
`define GEN_FD___(nbit_, name_)
`define GEN_FDX__(nbit_, name_)
`define GEN_FDXM_(nbit_, name_) , ma_``name_
`define GEN_FDXMW(nbit_, name_) , ma_``name_
`define GEN_FDO__(nbit_, name_)
`define GEN_FDOM_(nbit_, name_) , ma_``name_
`define GEN_FDOMW(nbit_, name_) , ma_``name_
`define GEN__D___(nbit_, name_)
`define GEN__DX__(nbit_, name_)
`define GEN__DXM_(nbit_, name_) , ma_``name_
`define GEN__DXMW(nbit_, name_) , ma_``name_
`define GEN__DO__(nbit_, name_)
`define GEN__DOM_(nbit_, name_) , ma_``name_
`define GEN__DOMW(nbit_, name_) , ma_``name_
`define GEN___X__(nbit_, name_)
`define GEN___XM_(nbit_, name_) , ma_``name_
`define GEN___XMW(nbit_, name_) , ma_``name_
`define GEN____M_(nbit_, name_)
`define GEN____MW(nbit_, name_)
`define GEN_____W(nbit_, name_)
    .data_o({pipltmp_EXMA `GEN_DAT})
`include "GenUndef.vh"
);
wire pipltmp_MAWB;
SynPiplIntf #(
`define GEN_F____(nbit_, name_)
`define GEN_FD___(nbit_, name_)
`define GEN_FDX__(nbit_, name_)
`define GEN_FDXM_(nbit_, name_)
`define GEN_FDXMW(nbit_, name_) + (nbit_)
`define GEN_FDO__(nbit_, name_)
`define GEN_FDOM_(nbit_, name_)
`define GEN_FDOMW(nbit_, name_) + (nbit_)
`define GEN__D___(nbit_, name_)
`define GEN__DX__(nbit_, name_)
`define GEN__DXM_(nbit_, name_)
`define GEN__DXMW(nbit_, name_) + (nbit_)
`define GEN__DO__(nbit_, name_)
`define GEN__DOM_(nbit_, name_)
`define GEN__DOMW(nbit_, name_) + (nbit_)
`define GEN___X__(nbit_, name_)
`define GEN___XM_(nbit_, name_)
`define GEN___XMW(nbit_, name_) + (nbit_)
`define GEN____M_(nbit_, name_)
`define GEN____MW(nbit_, name_) + (nbit_)
`define GEN_____W(nbit_, name_)
    .NBit(1 `GEN_DAT)
`include "GenUndef.vh"
) vMAWB(
    .clk(clk),
    .rst_n(rst_n),
`ifdef PIF_MAWB_ENA
    .en(`PIF_MAWB_ENA),
`else
    .en(en),
`endif
`ifdef PIF_MAWB_NOP
    .nop(`PIF_MAWB_NOP),
`else
    .nop(1'b0),
`endif
`define GEN_F____(nbit_, name_)
`define GEN_FD___(nbit_, name_)
`define GEN_FDX__(nbit_, name_)
`define GEN_FDXM_(nbit_, name_)
`define GEN_FDXMW(nbit_, name_) , ma_``name_
`define GEN_FDO__(nbit_, name_)
`define GEN_FDOM_(nbit_, name_)
`define GEN_FDOMW(nbit_, name_) , ma_``name_
`define GEN__D___(nbit_, name_)
`define GEN__DX__(nbit_, name_)
`define GEN__DXM_(nbit_, name_)
`define GEN__DXMW(nbit_, name_) , ma_``name_
`define GEN__DO__(nbit_, name_)
`define GEN__DOM_(nbit_, name_)
`define GEN__DOMW(nbit_, name_) , ma_``name_
`define GEN___X__(nbit_, name_)
`define GEN___XM_(nbit_, name_)
`define GEN___XMW(nbit_, name_) , ma_``name_
`define GEN____M_(nbit_, name_)
`define GEN____MW(nbit_, name_) , ma_``name_
`define GEN_____W(nbit_, name_)
    .data_i({1'b0 `GEN_DAT}),
`include "GenUndef.vh"
`define GEN_F____(nbit_, name_)
`define GEN_FD___(nbit_, name_)
`define GEN_FDX__(nbit_, name_)
`define GEN_FDXM_(nbit_, name_)
`define GEN_FDXMW(nbit_, name_) , wb_``name_
`define GEN_FDO__(nbit_, name_)
`define GEN_FDOM_(nbit_, name_)
`define GEN_FDOMW(nbit_, name_) , wb_``name_
`define GEN__D___(nbit_, name_)
`define GEN__DX__(nbit_, name_)
`define GEN__DXM_(nbit_, name_)
`define GEN__DXMW(nbit_, name_) , wb_``name_
`define GEN__DO__(nbit_, name_)
`define GEN__DOM_(nbit_, name_)
`define GEN__DOMW(nbit_, name_) , wb_``name_
`define GEN___X__(nbit_, name_)
`define GEN___XM_(nbit_, name_)
`define GEN___XMW(nbit_, name_) , wb_``name_
`define GEN____M_(nbit_, name_)
`define GEN____MW(nbit_, name_) , wb_``name_
`define GEN_____W(nbit_, name_)
    .data_o({pipltmp_MAWB `GEN_DAT})
`include "GenUndef.vh"
);
