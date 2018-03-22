`timescale 1ns / 1ps

`include "Core.vh"

// Brief: Branch Prediction Table, Synchorized
// Author: FluorineDog
module SynBHT(
    input clk, 
    input rst_n, 
    input update_en, 
    input [`IM_ADDR_BIT - 1 : 0] update_pc_4,
    input [`IM_ADDR_BIT - 1 : 0] update_pc_remote,
    input [1:0] update_state_old,
    input [`IM_ADDR_BIT - 1 : 0] pc_4,
    input branch_succ,
    output reg [`IM_ADDR_BIT - 1:0] guess_new_pc,
    output reg [1:0] guess_state
);
    reg [7:0] lru_flags[7:0];
    reg [`IM_ADDR_BIT - 1: 0] pc_4_array [7:0];
    reg [2+`IM_ADDR_BIT - 1: 0] data_array[7:0];
    integer i, j, m, n;
    
    reg [2+`IM_ADDR_BIT - 1: 0] data_tmp[15:1]; // data area

    reg [`IM_ADDR_BIT - 1:0] pc_remote;
    reg [7:0] guess_selector;
    integer base;
    always @(*) begin
        guess_new_pc = pc_4;
        
        for(i=0; i<8; i=i+1) begin 
            guess_selector[i] = (pc_4_array[i] == pc_4);
        end
        for(i=0; i < 8; i = i + 1) begin
            data_tmp[8 + i] = (guess_selector[i]) ? data_array[i]: `IM_ADDR_BIT'h0;
        end

        for(base = (8 >> 1); base > 0 ; base = (base >> 1)) begin
            for(j = 0; j < base; j = j + 1) begin
                data_tmp[base + j] = data_tmp[ 2 * base + 2*j] | data_tmp[ 2 * base + 2*j + 1];
            end
        end
        guess_state = data_tmp[1][2+`IM_ADDR_BIT - 1 : `IM_ADDR_BIT];
        pc_remote = data_tmp[1][`IM_ADDR_BIT - 1:0];
        if(guess_state[1]) begin    // 11 -> 10 -> 00 -> 01
            guess_new_pc = pc_remote;
        end            
    end

    reg [7:0] to_die_mask; //Cmb
    reg [7:0] update_selector; //Cmb
    wire [7:0] mask_final; // combinatorial
    wire hit;    // combinatorial
    integer k;
    always @(*) begin
        for(i=0; i<8; i=i+1) begin 
            // use if hit
            update_selector[i] = (pc_4_array[i] == update_pc_4);
        end
        for(k = 0; k < 8; k=k+1) begin 
            // use if not hit
            to_die_mask[k] = (&(lru_flags[k]));
        end
    end

    assign hit = |update_selector;
    assign mask_final = hit ? update_selector : to_die_mask;
    

    reg[1:0] new_state;
    always @(*) begin
        case({update_state_old, branch_succ}) 
            3'b111: new_state = 2'b11;
            3'b101: new_state = 2'b11;
            3'b110: new_state = 2'b10;
            3'b001: new_state = 2'b10;
            3'b100: new_state = 2'b00;
            3'b011: new_state = 2'b00;
            3'b000: new_state = 2'b01;
            3'b010: new_state = 2'b01;
        endcase
    end

    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            for(i=0; i < 8; i = i+1) begin
                for(j=0; j < 8; j = j + 1) begin
                    lru_flags[i][j] <= (i <= j);
                end
                pc_4_array[i] <= 0;
                data_array[i] <= 0;
            end
        end
        else if(update_en) begin 
            for(i=0; i < 8; i = i+1) begin
                if(mask_final[i]) begin
                    data_array[i] <= {new_state, update_pc_remote};
                    pc_4_array[i] <= update_pc_4;
                end
            end
            for(n=0; n < 8; n = n + 1) begin
                lru_flags[n] <= (mask_final[n]) ? mask_final: lru_flags[n] | mask_final;
            end
        end
    end
endmodule



