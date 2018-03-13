// Brief: Arithmetic Logic Unit, combinatorial
// Author: KailinLi
`include "Core.vh"
module CmbALU(op, data_x, data_y, shamt, data_res);
    input [`ALU_OP_BIT - 1:0] op;
    input [31:0] data_x;
    input [31:0] data_y;
    input [4:0] shamt;      // Separate input for shift 
    output [31:0] data_res;

    localparam MASK = 5'b11111;
    assign data_res = (op == `ALU_OP_AND)  ?  (data_x & data_y) :
                      (op == `ALU_OP_OR)   ?  (data_x | data_y) :
                      (op == `ALU_OP_XOR)  ?  (data_x ^ data_y) :
                      (op == `ALU_OP_NOR)  ? ~(data_x | data_y) :
                      (op == `ALU_OP_ADD)  ?  (data_x + data_y) :
                      (op == `ALU_OP_SUB)  ?  (data_x - data_y) :
                      (op == `ALU_OP_SLLV) ?  (data_x << (MASK & data_y)) :
                      (op == `ALU_OP_SRAV) ?  $unsigned(($signed(data_x) >>> (MASK & data_y))) :
                      (op == `ALU_OP_SRLV) ?  (data_x >> (MASK & data_y)) :
                      (op == `ALU_OP_SLL)  ?  (data_x << shamt) :
                      (op == `ALU_OP_SRA)  ?  $unsigned(($signed(data_x) >>> shamt)) :
                      (op == `ALU_OP_SRL)  ?  (data_x >> shamt) :
                      (op == `ALU_OP_SLT)  ?  ($signed(data_x) < $signed(data_y)) :
                      (op == `ALU_OP_SLTU) ?  (data_x < data_y) :
                      (op == `ALU_OP_LUI)  ?  (data_y << 'd16) : 0;

endmodule