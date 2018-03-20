`timescale 1ns / 1ps

// Brief: DataFlow redirection
// Author: cuishaobo
module CmbReFlowDual(
    input [4:0]  origin_req, 
    input [31:0] origin_data,
    input reflow_en_1,
    input [4:0]reflow_req_1,
    input [31:0]reflow_data_1,
    input reflow_en_2,
    input [4:0]reflow_req_2,
    input [31:0]reflow_data_2,
    output reg [31:0] data
);
    always @(*) begin 
        data = origin_data;
        if(reflow_req_2 == origin_req)  begin
            data = reflow_data_2;
        end
        if(reflow_req_1 == origin_req)  begin
            data = reflow_data_1;
        end
    end
endmodule

module CmbReFlowSingle(
    input [4:0]  origin_req, 
    input [31:0] origin_data,
    input reflow_en_1,
    input [4:0]reflow_req_1,
    input [31:0]reflow_data_1,
    output reg [31:0] data
);
    always @(*) begin 
        data = origin_data;
        if(reflow_req_1 == origin_req)  begin
            data = reflow_data_1;
        end
    end
endmodule
