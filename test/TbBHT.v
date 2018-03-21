`timescale 1ns / 1ps

`include "Test.vh"

module TbAuxEnabled();
    reg clk = 1'b0;
    always #5 clk <= !clk;
    reg rst_n = 1'b0;
    reg update_en;
    reg [`IM_ADDR_BIT - 1 : 0] update_pc_4;
    reg [`IM_ADDR_BIT - 1 : 0] update_pc_remote;
    reg [1:0] update_state_old;
    reg [`IM_ADDR_BIT - 1 : 0] pc_4;
    reg branch_succ;
    wire [`IM_ADDR_BIT - 1:0] guess_new_pc;
    wire [1:0] guess_state;
    initial begin
        rst_n = 0;
        pc_4 = 'h1;
        `cp(3) rst_n = 1;

        update_pc_4 = 'h1;
        update_pc_remote = 'h1;
        update_state_old = 'b10;
        branch_succ = 1;
        `cp(3);
        update_en = 1;
        `cp(2);
        update_en = 0;
        `cp(3);

        update_pc_4 = 'h2;
        update_pc_remote = 'h2;
        update_state_old = 'b10;
        branch_succ = 1;
        `cp(3);
        update_en = 1;
        `cp(2);
        update_en = 0;
        `cp(3);


        update_pc_4 = 'h3;
        update_pc_remote = 'h3;
        update_state_old = 'b10;
        branch_succ = 1;
        `cp(3);
        update_en = 1;
        `cp(2);
        update_en = 0;
        `cp(3);


        update_pc_4 = 'h4;
        update_pc_remote = 'h4;
        update_state_old = 'b10;
        branch_succ = 1;
        `cp(3);
        update_en = 1;
        `cp(2);
        update_en = 0;
        `cp(3);


        update_pc_4 = 'h4;
        update_pc_remote = 'h4;
        update_state_old = 'b10;
        branch_succ = 1;
        `cp(3);
        update_en = 1;
        `cp(2);
        update_en = 0;
        `cp(3);

        update_pc_4 = 'h2;
        update_pc_remote = 'h2;
        update_state_old = 'b10;
        branch_succ = 1;
        `cp(3);
        update_en = 1;
        `cp(2);
        update_en = 0;
        `cp(3);



        update_pc_4 = 'h5;
        update_pc_remote = 'h5;
        update_state_old = 'b10;
        branch_succ = 1;
        `cp(3);
        update_en = 1;
        `cp(2);
        update_en = 0;
        `cp(3);


        update_pc_4 = 'h6;
        update_pc_remote = 'h6;
        update_state_old = 'b10;
        branch_succ = 1;
        `cp(3);
        update_en = 1;
        `cp(2);
        update_en = 0;
        `cp(3);


        update_pc_4 = 'h7;
        update_pc_remote = 'h7;
        update_state_old = 'b10;
        branch_succ = 1;
        `cp(3);
        update_en = 1;
        `cp(2);
        update_en = 0;
        `cp(3);

        update_pc_4 = 'h8;
        update_pc_remote = 'h8;
        update_state_old = 'b10;
        branch_succ = 1;
        `cp(3);
        update_en = 1;
        `cp(2);
        update_en = 0;
        `cp(3);


        update_pc_4 = 'h1;
        update_pc_remote = 'h1;
        update_state_old = 'b10;
        branch_succ = 1;
        `cp(3);
        update_en = 1;
        `cp(2);
        update_en = 0;
        `cp(3);

        update_pc_4 = 'h9;
        update_pc_remote = 'h9;
        update_state_old = 'b10;
        branch_succ = 1;
        `cp(3);
        update_en = 1;
        `cp(2);
        update_en = 0;
        `cp(3);
        pc_4 = 2;
        `cp(5);
        pc_4 = 3;
        `cp(5);
    end
    SynBHT vTest(
        .clk(clk), 
        .rst_n(rst_n), 
        .update_en(update_en),
        .update_pc_4(update_pc_4),
        .update_state_old(update_state_old),
        .pc_4(pc_4),
        .branch_succ(branch_succ),
        .guess_new_pc(guess_new_pc),
        .guess_state(guess_state)
    );
endmodule
