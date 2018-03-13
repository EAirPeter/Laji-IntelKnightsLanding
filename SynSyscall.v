`timescale 1ns / 1ps

// Brief: Syscall Module, synchronized
// Description: If $v0 is 34, display content of $a0 on the 7-segment display;
//              Otherwise pause the execution of the program
// Author: KailinLi
module SynSyscall(clk, rst_n, en, syscall_en, data_v0, data_a0, display, halt);
    input clk;
    input rst_n;
    input en;
    input syscall_en;       
    input [31:0] data_v0;
    input [31:0] data_a0;
    output reg [31:0] display;
    output halt;

    wire enabled = en && syscall_en;
    assign halt = (enabled && data_v0 != 'd34) ? 1 : 0;
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n)
            display <= 0;
        else if (enabled && data_v0 == 'd34)
            display <= data_a0;
    end
endmodule
