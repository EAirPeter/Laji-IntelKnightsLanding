`define DECL_F_____(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] if_``name_
`define DECL_F____O(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] if_``name_, ex_``name_``_old
`define DECL_FD____(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] if_``name_, id_``name_
`define DECL_FD___O(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] if_``name_, id_``name_, ex_``name_``_old
`define DECL_FDX___(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] if_``name_, id_``name_, ex_``name_
`define DECL_FDX__O(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] if_``name_, id_``name_, ex_``name_, ex_``name_``_old
`define DECL_FDXM__(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] if_``name_, id_``name_, ex_``name_, ma_``name_
`define DECL_FDXM_O(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] if_``name_, id_``name_, ex_``name_, ma_``name_, ex_``name_``_old
`define DECL_FDXMW_(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] if_``name_, id_``name_, ex_``name_, ma_``name_, wb_``name_
`define DECL_FDXMWO(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] if_``name_, id_``name_, ex_``name_, ma_``name_, wb_``name_, ex_``name_``_old
`define DECL__D____(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] id_``name_
`define DECL__D___O(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] id_``name_, ex_``name_``_old
`define DECL__DX___(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] id_``name_, ex_``name_
`define DECL__DX__O(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] id_``name_, ex_``name_, ex_``name_``_old
`define DECL__DXM__(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] id_``name_, ex_``name_, ma_``name_
`define DECL__DXM_O(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] id_``name_, ex_``name_, ma_``name_, ex_``name_``_old
`define DECL__DXMW_(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] id_``name_, ex_``name_, ma_``name_, wb_``name_
`define DECL__DXMWO(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] id_``name_, ex_``name_, ma_``name_, wb_``name_, ex_``name_``_old
`define DECL___X___(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] ex_``name_
`define DECL___X__O(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] ex_``name_, ex_``name_``_old
`define DECL___XM__(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] ex_``name_, ma_``name_
`define DECL___XM_O(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] ex_``name_, ma_``name_, ex_``name_``_old
`define DECL___XMW_(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] ex_``name_, ma_``name_, wb_``name_
`define DECL___XMWO(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] ex_``name_, ma_``name_, wb_``name_, ex_``name_``_old
`define DECL____M__(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] ma_``name_
`define DECL____M_O(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] ma_``name_, ex_``name_``_old
`define DECL____MW_(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] ma_``name_, wb_``name_
`define DECL____MWO(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] ma_``name_, wb_``name_, ex_``name_``_old
`define DECL_____W_(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] wb_``name_
`define DECL_____WO(nbit_, name_) \
    localparam NBit_``name_ = (nbit_); \
    wire [NBit_``name_ - 1:0] wb_``name_, ex_``name_``_old
