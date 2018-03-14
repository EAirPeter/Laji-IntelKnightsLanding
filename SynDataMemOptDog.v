`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Data Memory, combinatorial
// Author: cuishaobo
module SynDataMem(clk, rst_n, en, op, w_en, addr_dbg, addr, data_in, data_dbg, data);
    input clk;
    input rst_n;
    input en;
    input [`DM_OP_BIT - 1:0] op;
    input w_en;             // Write Enable
    input [31:0] addr_dbg;  // Address of the data for debugging
    input [31:0] addr;
    input [31:0] data_in;
    output [31:0] data_dbg; // Data to be displayed for debugging
    output reg [31:0] data;

    assign data_dbg = addr_dbg;

    // (* ram_style = "block" *) 
    reg [7:0] mem_a[1023:0];
    reg [7:0] mem_b[1023:0];
    reg [7:0] mem_c[1023:0];
    reg [7:0] mem_d[1023:0];

    wire [9:0] eff_addr = addr[11:2];
    wire [7:0] data_a = mem_a[eff_addr];
    wire [7:0] data_b = mem_b[eff_addr];
    wire [7:0] data_c = mem_c[eff_addr];
    wire [7:0] data_d = mem_d[eff_addr];

    always@(*) begin
        case (op)
            `DM_OP_WD: data <= {data_d, data_c, data_b, data_a};
            `DM_OP_UH: begin
                case (addr[1])
                    0: data <= {16'h0, data_b, data_a};
                    1: data <= {16'h0, data_d, data_c};
                endcase
            end
            `DM_OP_UB: begin
                case (addr[1:0])
                    0: data <= {24'h0, data_a};
                    1: data <= {24'h0, data_b};
                    2: data <= {24'h0, data_c};
                    3: data <= {24'h0, data_d};
                endcase
            end
            `DM_OP_SH: begin
                case (addr[1])
                    0: data <= {{16{data_b[7]}}, data_b, data_a};
                    1: data <= {{16{data_d[7]}}, data_d, data_c};
                endcase
            end
            `DM_OP_SB: begin
                case (addr[1:0])
                    0: data <= {{24{data_a[7]}}, data_a};
                    1: data <= {{24{data_b[7]}}, data_b};
                    2: data <= {{24{data_c[7]}}, data_c};
                    3: data <= {{24{data_d[7]}}, data_d};
                endcase
            end
            default:
                data <= 0;
        endcase
    end

    always @(posedge clk) begin
        if(en && w_en) begin
            case (op)
                `DM_OP_SB, `DM_OP_UB: begin
                    case(addr[1:0])
                        0: mem_a[eff_addr] <= data_in[7:0];
                        1: mem_b[eff_addr] <= data_in[7:0];
                        2: mem_c[eff_addr] <= data_in[7:0];
                        3: mem_d[eff_addr] <= data_in[7:0];
                    endcase
                end
                `DM_OP_SH, `DM_OP_UH: begin
                    case(addr[1])
                        0:  begin
                            mem_a[eff_addr] <= data_in[7:0];
                            mem_b[eff_addr] <= data_in[15:8];
                        end
                        1:  begin 
                            mem_c[eff_addr] <= data_in[7:0];
                            mem_d[eff_addr] <= data_in[15:8];
                        end
                    endcase
                end
                `DM_OP_WD: begin 
                    mem_a[eff_addr] <= data_in[7:0];
                    mem_b[eff_addr] <= data_in[15:8];
                    mem_c[eff_addr] <= data_in[23:16];
                    mem_d[eff_addr] <= data_in[31:24];
                end
            endcase
        end
    end

endmodule
