`timescale 1ns / 1ps

// Brief: Register File, synchronized
// Author: G-H-Y
module SynRegFile(
    clk, rst_n, en, w_en, req_dbg, req_w, req_a, req_b, data_w,
	data_dbg, data_a, data_b, data_v0, data_a0
);
    input clk;
    input rst_n;
    input en;
    input w_en;
    input [4:0] req_dbg;
    input [4:0] req_w;
    input [4:0] req_a;
    input [4:0] req_b;
    input [31:0] data_w;
    output [31:0] data_dbg;
    output [31:0] data_a;
    output [31:0] data_b;
    output [31:0] data_v0;
    output [31:0] data_a0;

    reg [31:0] regs[31:1];
    
    assign data_dbg = req_dbg == 0 ? 32'd0 : regs[req_dbg];
    assign data_a = req_a == 0 ? 32'd0 : regs[req_a];
    assign data_b = req_b == 0 ? 32'd0 : regs[req_b];
    assign data_v0 = regs[2];
    assign data_a0 = regs[4];
    
    always @(posedge clk) begin
        if (en && w_en && req_w != 5'd0)
            regs[req_w] <= data_w;
    end
endmodule
