module SynRegFile(clk, rst_n, en, w_en, req_dbg, req_w, req_a, req_b, data_w,
	              data_dbg, data_a, data_b, data_v0, data_a0);
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
    output [31:0] data_v0;
    output [31:0] data_a0;

    integer k;
    reg [31:0] RegFile [31:0];

    initial begin
        RegFile[0] <= 8'h00000000;
    	for(k = 0; k < 32; k++)
    	RegFile[k] <= 0;
    end

    assign data_dbg = RegFile[req_dbg];
    assign data_a = RegFile[req_a];
    assign data_b = RegFile[req_b];
    assign data_v0 = RegFile[2] ;
    assign data_a0 = RegFile[4] ;
    
    always @(posedge clk) begin
    	if (w_en && req_w !=0) begin
    		RegFile[req_w] <= req_w;  		
    	end
    end
endmodule