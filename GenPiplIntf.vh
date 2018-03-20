// GPI_PIF, GPI_ENA, GPI_NOP, GPI_IST, GPI_OST, GPI_DAT
// GPI GPI_ GPI_O

`ifndef GPI_ENA
`define GPI_ENA en
`endif

`ifndef GPI_NOP
`define GPI_NOP 1'b0
`endif

`define GPI_CAT_(x_, y_) x_``_``y_
`define GPI_CAT(x_, y_) `GPI_CAT_(x_, y_)
`define GPI_BNM(name_) `GPI_CAT(NBit, name_)
`define GPI_INM(name_) `GPI_CAT(`GPI_IST, name_)
`define GPI_ONM(name_) `GPI_CAT(`GPI_OST, name_)

SynPiplIntf #(
`define GPI_(name_) `GPI_BNM(name_)
`define GPI(name_) + `GPI_(name_)
`define GPI_O(name_) `GPI(name_)
    .NBit(`GPI_DAT)
`undef GPI_O
`undef GPI
`undef GPI_
) `GPI_PIF(
    .clk(clk),
    .rst_n(rst_n),
    .en(`GPI_ENA),
    .nop(`GPI_NOP),
    .data_i({
`define GPI_(name_) `GPI_INM(name_)
`define GPI(name_) , `GPI_(name_)
`define GPI_O(name_) `GPI(name_)
        `GPI_DAT
`undef GPI_O
`undef GPI
`undef GPI_
    }),
    .data_o({
`define GPI_(name_) `GPI_ONM(name_)
`define GPI(name_) , `GPI_(name_)
`define GPI_O(name_) , `GPI_CAT(`GPI_ONM(name_), old)
        `GPI_DAT
`undef GPI_O
`undef GPI
`undef GPI_
    })
);

`undef GPI_BNM
`undef GPI_ONM
`undef GPI_INM
`undef GPI_CAT
`undef GPI_CAT_

`undef GPI_DAT
`undef GPI_OST
`undef GPI_IST
`undef GPI_NOP
`undef GPI_ENA
`undef GPI_PIF
