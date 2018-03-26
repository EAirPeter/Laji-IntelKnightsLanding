`timescale 1ns / 1ps

// Brief: Register File, synchronized
// Author: G-H-Y
module SynRegFile(
    clk, rst_n, en, w_en, req_dbg, req_w, req_a, req_b, data_w,
	data_dbg, data_a, data_b
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

    reg [31:0] regs[31:1];
    
    assign data_dbg = req_dbg == 0 ? 32'd0 : regs[req_dbg];
    assign data_a = req_a == 0 ? 32'd0 : regs[req_a];
    assign data_b = req_b == 0 ? 32'd0 : regs[req_b];
    integer i;    
    always @(negedge clk) begin
        if(!rst_n) begin
            // set initial for sp
            for(i = 1; i < 32; i=i+1) begin
                regs[i] <= i ? 'h400:'hcccc;
            end
        end
        else if (en && w_en && req_w != 5'd0)
            regs[req_w] <= data_w;
    end
endmodule
