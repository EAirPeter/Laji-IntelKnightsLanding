`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Data Memory, combinatorial
// Author: cuishaobo
module SynDataMem(clk, rst_n, en, op, w_en, addr_dbg, addr, data_in, data_dbg, data);
    localparam MemLen = 1 << (`DM_ADDR_BIT - 2);
    input clk;
    input rst_n;
    input en;
    input [`DM_OP_BIT - 1:0] op;
    input w_en;             // Write Enable
    input [`DM_ADDR_BIT - 1:0] addr_dbg;  // Address of the data for debugging
    input [`DM_ADDR_BIT - 1:0] addr;
    input [31:0] data_in;
    output [31:0] data_dbg; // Data to be displayed for debugging
    output reg [31:0] data;
    wire enable = en && w_en;

    // (* ram_style = "block" *) 
    reg [7:0] mem_a[MemLen - 1:0];
    reg [7:0] mem_b[MemLen - 1:0];
    reg [7:0] mem_c[MemLen - 1:0];
    reg [7:0] mem_d[MemLen - 1:0];

    wire [`DM_ADDR_BIT - 3:0] dbg_addr = addr_dbg[`DM_ADDR_BIT - 1:2];
    wire [`DM_ADDR_BIT - 3:0] eff_addr = addr[`DM_ADDR_BIT - 1:2];
    wire [7:0] data_a = mem_a[eff_addr];
    wire [7:0] data_b = mem_b[eff_addr];
    wire [7:0] data_c = mem_c[eff_addr];
    wire [7:0] data_d = mem_d[eff_addr];
    
    assign data_dbg = {mem_d[dbg_addr], mem_c[dbg_addr], mem_b[dbg_addr], mem_a[dbg_addr]};

    reg [7:0] write_data_a;
    reg [7:0] write_data_b;
    reg [7:0] write_data_c;
    reg [7:0] write_data_d;

    reg write_en_a;
    reg write_en_b;
    reg write_en_c;
    reg write_en_d;

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

    always @(*) begin
        write_data_a = 32'b0;
        write_data_b = 32'b0;
        write_data_c = 32'b0;
        write_data_d = 32'b0;
        write_en_a = 1'b0;
        write_en_b = 1'b0;
        write_en_c = 1'b0;
        write_en_d = 1'b0;
        
        case (op)
            `DM_OP_SB, `DM_OP_UB: begin
                case(addr[1:0])
                    0: begin write_data_a = data_in[7:0]; write_en_a = enable; end
                    1: begin write_data_b = data_in[7:0]; write_en_b = enable; end
                    2: begin write_data_c = data_in[7:0]; write_en_c = enable; end
                    3: begin write_data_d = data_in[7:0]; write_en_d = enable; end
                endcase
            end
            `DM_OP_SH, `DM_OP_UH: begin
                case(addr[1])
                    0:  begin
                        write_data_a = data_in[7:0]; 
                        write_data_b = data_in[15:8]; 
                        write_en_a = enable;
                        write_en_b = enable;
                    end
                    1:  begin 
                        write_data_c = data_in[7:0]; 
                        write_data_d = data_in[15:8]; 
                        write_en_c = enable;
                        write_en_d = enable;
                    end
                endcase
            end
            `DM_OP_WD: begin 
                write_data_a = data_in[7:0];
                write_data_b = data_in[15:8];
                write_data_c = data_in[23:16];
                write_data_d = data_in[31:24];
                write_en_a = enable;
                write_en_b = enable;
                write_en_c = enable;
                write_en_d = enable;
            end
        endcase
    end

    always @(posedge clk) begin
        if(write_en_a) begin
            mem_a[eff_addr] <= write_data_a;
        end

        if(write_en_b) begin
            mem_b[eff_addr] <= write_data_b;
        end

        if(write_en_c) begin
            mem_c[eff_addr] <= write_data_c;
        end

        if(write_en_d) begin
            mem_d[eff_addr] <= write_data_d;
        end
    end

endmodule
