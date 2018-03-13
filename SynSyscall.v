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
    output reg halt;

    always @(posedge clk, negedge rst_n) begin
      if (!rst_n) begin
        display <= 0;
        halt <= 0;
      end else if (en && syscall_en) begin
        if (data_v0 == 'd34) begin
          display <= data_a0;
          halt <= 0;
        end else begin
          display <= 0;
          halt <= 1;
        end
      end else begin
        display <= display;
        halt <= halt;
      end
    end

endmodule