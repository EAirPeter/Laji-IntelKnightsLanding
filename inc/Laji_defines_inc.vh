wire [`IM_ADDR_BIT - 1:0] pc, pc_4_ps0, pc_4_ps1, pc_4_ps2, pc_4_ps3, pc_4_ps4;
wire [31:0] inst_ps0, inst_ps1;
wire [5:0] opcode, funct;
wire [4:0] rs;
reg [4:0] regfile_req_a;          // conbinatorial
wire [4:0] rt;
reg [4:0] regfile_req_b;          // conbinatorial 
wire [4:0] rt_ps1, rt_ps2, rt_ps3;
wire [4:0] rd_ps1, rd_ps2;
wire [4:0] shamt_ps1, shamt_ps2;
wire [15:0] imm16_ps1, imm16_ps2, imm16_ps3;
wire [31:0] ext_out_sign, ext_out_zero;
wire regfile_w_en_ps1, regfile_w_en_ps2, regfile_w_en_ps3, regfile_w_en_ps4;
wire [31:0] regfile_data_a_ps1, regfile_data_a_ps2, regfile_data_a_ps3;
wire [31:0] regfile_data_b_ps1, regfile_data_b_ps2, regfile_data_b_ps3;
reg [4:0] regfile_req_w_ps1;    // combinatorial
wire [4:0] regfile_req_w_ps2, regfile_req_w_ps3, regfile_req_w_ps4;
reg [31:0] regfile_data_w_ps4;  // combinatorial
wire [`WTG_OP_BIT - 1:0] wtg_op_ps1, wtg_op_ps2, wtg_op_ps3;
wire [`IM_ADDR_BIT - 1:0] wtg_pc_new_ps3;
wire [`ALU_OP_BIT - 1:0] alu_op_ps1, alu_op_ps2;
// reg [31:0] alu_data_x;      // combinatorial
reg [31:0] alu_data_y;      // combinatorial
wire [31:0] alu_data_res_ps2, alu_data_res_ps3, alu_data_res_ps4;
wire [`DM_OP_BIT - 1:0] datamem_op_ps1, datamem_op_ps2, datamem_op_ps3;
wire datamem_w_en_ps1, datamem_w_en_ps2, datamem_w_en_ps3;
wire [31:0] datamem_data_ps3, datamem_data_ps4;
wire [`MUX_RF_REQW_BIT - 1:0] mux_regfile_req_w_ps1, mux_regfile_req_w_ps2;
wire [`MUX_RF_DATAW_BIT - 1:0] mux_regfile_data_w_ps1, mux_regfile_data_w_ps2, mux_regfile_data_w_ps3, mux_regfile_data_w_ps4;
// wire [`MUX_ALU_DATAY_BIT - 1:0] mux_alu_data_x_ps1, mux_alu_data_x_ps2;
wire [`MUX_ALU_DATAY_BIT - 1:0] mux_alu_data_y_ps1, mux_alu_data_y_ps2;
wire [`IM_ADDR_BIT - 1:0] pc_new;
wire syscall_en_ps1, syscall_en_ps2, syscall_en_ps3;
wire halt_ps3, halt_ps4;
wire clear_vps1, clear_vps2, clear_vps3, clear_vps4;
wire [`IM_ADDR_BIT - 1:0] pc_guessed_ps0, pc_guessed_ps1, pc_guessed_ps2, pc_guessed_ps3;
wire stop_x_wb_vps1, stop_x_dm_vps1, stop_y_wb_vps1, stop_y_dm_vps1;
wire en_vps0, en_vps1, en_vps2, en_vps3, en_vps4;