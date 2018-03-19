`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Branch History Table, synchronized
// Author: EAirPeter
module SynBHT(
    clk, rst_n, op, pc_r, pc_w, dst_w, dst_r, take_r
);
    localparam NBitAddr = 3;
    input clk, rst_n;
    input [`BHT_OP_NBIT - 1:0] op;
    input [`IM_ADDR_NBIT - 1:0] pc_r;
    input [`IM_ADDR_NBIT - 1:0] pc_w;   // always touch pc_w
    input [`IM_ADDR_NBIT - 1:0] dst_w;
    output [`IM_ADDR_NBIT - 1:0] dst_r; // combinatorial
    output take_r;

    localparam NItem = 1 << NBitAddr;

    reg [NItem - 1:0] mem_vld;
    reg [`IM_ADDR_NBIT - 1:0] mem_pc[NItem - 1:0];
    reg [`IM_ADDR_NBIT - 1:0] mem_dst[NItem - 1:0];
    reg [1:0] mem_hist[NItem - 1:0];

    wire [NItem - 1:0] dst_r_tmp[`IM_ADDR_NBIT - 1:0];
    wire [NItem - 1:0] take_r_tmp;
    wire [NItem - 1:0] hist_tmp[1:0];
    wire [NItem - 1:0] f_hit_r, f_hit_w;
    wire vld_r = |f_hit_r;
    wire vld_w = |f_hit_w;
    wire [NItem - 1:0] f_lru;
    wire [NItem - 1:0] f_write = vld_w ? f_hit_w : f_lru;
    wire [1:0] hist;

    assign take_r = vld_r & |take_r_tmp;

    generate
        genvar i, j;
        for (i = 0; i < NItem; i = i + 1) begin
            assign f_hit_r[i] = mem_vld[i] && mem_pc[i] == pc_r;
            assign f_hit_w[i] = mem_vld[i] && mem_pc[i] == pc_w;
            assign take_r_tmp[i] = f_hit_r[i] & mem_hist[i][1];
        end
        for (j = 0; j < `IM_ADDR_NBIT; j = j + 1) begin
            for (i = 0; i < NItem; i = i + 1) begin
                assign dst_r_tmp[j][i] = f_hit_r[i] & mem_dst[i][j];
            end
            assign dst_r[j] = |dst_r_tmp[j];
        end
        for (j = 0; j < 2; j = j + 1) begin
            for (i = 0; i < NItem; i = i + 1) begin
                assign hist_tmp[j][i] = f_write[i] & mem_hist[i][j];
            end
            assign hist[j] = |hist_tmp[j];
        end
    endgenerate

    reg lru_touch;  // combinatorial
    reg [NItem - 1:0] w_enable;
    reg [1:0] w_init, w_bound, w_incr, w_hist;
    reg w_calc;

    always @(*) begin
        lru_touch = 1;
        w_enable = f_write;
        w_init = 2'b10;
        w_bound = 2'b11;
        w_incr = 2'b01;
        w_hist = 2'b11;
        w_calc = 1;
        case (op)
            `BHT_OP_NOP: begin
                lru_touch = 0;
                w_enable = {NItem{1'b0}};
                w_calc = 0;
            end
            `BHT_OP_SET: begin
                w_hist = 2'b11;
                w_calc = 0;
            end
            `BHT_OP_DEC: begin
                w_init = 2'b01;
                w_bound = 2'b00;
                w_incr = 2'b11;
            end
            `BHT_OP_INC: begin
                w_init = 2'b10;
                w_bound = 2'b11;
                w_incr = 2'b01;
            end
        endcase
        if (w_calc) begin
            if (!vld_w)
                w_hist = w_init;
            else if (hist != w_bound)
                w_hist = hist + w_incr;
            else
                w_enable = {NItem{1'b0}};
        end
    end

    integer k;
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n)
            mem_vld <= {NItem{1'b0}};
        else
            for (k = 0; k < NItem; k = k + 1)
                if (w_enable[k])
                    mem_vld[k] <= 1'b1;
    end
    
    always @(posedge clk) begin
        for (k = 0; k < NItem; k = k + 1)
            if (w_enable[k]) begin
                mem_pc[k] <= pc_w;
                mem_dst[k] <= dst_w;
                mem_hist[k] <= w_hist;
            end
    end

    BhtLRU #(
        .NItem(NItem)
    ) vLRU(
        .clk(clk),
        .rst_n(rst_n),
        .touch_en(lru_touch),
        .touch_item(f_write),
        .lru_item(f_lru)
    );
endmodule
