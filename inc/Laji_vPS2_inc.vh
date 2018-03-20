    // dog auto generation
    SynPS2 vPS2(
        .clk(clk),
        .rst_n(rst_n),
        .en(en_vps2),
        .clear(clear_vps2),
        .pc_4_in(pc_4_ps1),
        .pc_4(pc_4_ps2),
        .regfile_req_a_in(regfile_req_a_ps1),
        .regfile_req_a(regfile_req_a_ps2),
        .rt_in(rt_ps1),
        .rt(rt_ps2),
        .rd_in(rd_ps1),
        .rd(rd_ps2),
        .shamt_in(shamt_ps1),
        .shamt(shamt_ps2),
        .imm16_in(imm16_ps1),
        .imm16(imm16_ps2),
        .regfile_w_en_in(regfile_w_en_ps1),
        .regfile_w_en(regfile_w_en_ps2),
        .regfile_data_a_ori_in(regfile_data_a_ori_ps1),
        .regfile_data_a_ori(regfile_data_a_ori_ps2),
        .regfile_data_b_ori_in(regfile_data_b_ori_ps1),
        .regfile_data_b_ori(regfile_data_b_ori_ps2),
        .regfile_req_w_in(regfile_req_w_ps1),
        .regfile_req_w(regfile_req_w_ps2),
        .wtg_op_in(wtg_op_ps1),
        .wtg_op(wtg_op_ps2),
        .alu_op_in(alu_op_ps1),
        .alu_op(alu_op_ps2),
        .datamem_op_in(datamem_op_ps1),
        .datamem_op(datamem_op_ps2),
        .datamem_w_en_in(datamem_w_en_ps1),
        .datamem_w_en(datamem_w_en_ps2),
        .mux_regfile_req_w_in(mux_regfile_req_w_ps1),
        .mux_regfile_req_w(mux_regfile_req_w_ps2),
        .mux_regfile_data_w_in(mux_regfile_data_w_ps1),
        .mux_regfile_data_w(mux_regfile_data_w_ps2),
        .mux_alu_data_y_in(mux_alu_data_y_ps1),
        .mux_alu_data_y(mux_alu_data_y_ps2),
        .syscall_en_in(syscall_en_ps1),
        .syscall_en(syscall_en_ps2),
        .pc_guessed_in(pc_guessed_ps1),
        .pc_guessed(pc_guessed_ps2),
        .skip_load_use_in(skip_load_use_ps1),
        .skip_load_use(skip_load_use_ps2),
        .r_datamem_in(r_datamem_ps1),
        .r_datamem(r_datamem_ps2)
    );
