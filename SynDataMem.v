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
    
    reg [31:0] mem[1023:0];

    wire enabled = en & w_en;
    wire [9:0] effDbgAddr = addr_dbg[11:2];
    wire [9:0] effAddr = addr[11:2];
    assign data_dbg = mem[effDbgAddr];

    always @(*) begin
        case (op)
            `DM_OP_WD: data <= mem[effAddr];
            `DM_OP_UH: begin
                case (addr[1])
                    0: data <= {16'h0, mem[effAddr][15:0]};
                    1: data <= {16'h0, mem[effAddr][31:16]};
                endcase
            end
            `DM_OP_UB: begin
                case (addr[1:0])
                    0: data <= {24'h0, mem[effAddr][7:0]};
                    1: data <= {24'h0, mem[effAddr][15:8]};
                    2: data <= {24'h0, mem[effAddr][23:16]};
                    3: data <= {24'h0, mem[effAddr][31:24]};
                endcase
            end
            `DM_OP_SH: begin
                case (addr[1])
                    0: data <= {{16{mem[effAddr][15]}}, mem[effAddr][15:0]};
                    1: data <= {{16{mem[effAddr][31]}}, mem[effAddr][31:16]};
                endcase
            end
            `DM_OP_SB: begin
                case (addr[1:0])
                    0: data <= {{24{mem[effAddr][7]}}, mem[effAddr][7:0]};
                    1: data <= {{24{mem[effAddr][15]}}, mem[effAddr][15:8]};
                    2: data <= {{24{mem[effAddr][23]}}, mem[effAddr][23:16]};
                    3: data <= {{24{mem[effAddr][31]}}, mem[effAddr][31:24]};
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
                        0: mem[effAddr] <= {mem[effAddr][31:8], data_in[7:0]};
                        1: mem[effAddr] <= {mem[effAddr][31:16], data_in[7:0], mem[effAddr][7:0]};
                        2: mem[effAddr] <= {mem[effAddr][31:24], data_in[7:0], mem[effAddr][15:0]};
                        3: mem[effAddr] <= {data_in[7:0], mem[effAddr][23:0]};
                    endcase
                end
                `DM_OP_SH, `DM_OP_UH: begin
                    case(addr[1])
                        0: mem[effAddr] <= {mem[effAddr][31:16], data_in[15:0]};
                        1: mem[effAddr] <= {data_in[15:0], mem[effAddr][15:0]};
                    endcase
                end
                `DM_OP_WD:
                    mem[effAddr] <= data_in;
            endcase
        end
    end
endmodule
