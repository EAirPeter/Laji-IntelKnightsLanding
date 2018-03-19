    // dog auto generation
    SynPS1 vPS1(
        .clk(clk),
        .rst_n(rst_n),
        .en(en_vps1),
        .clear(clear_vps1),
        .pc_4_in(pc_4_ps0),
        .pc_4(pc_4_ps1),
        .inst_in(inst_ps0),
        .inst(inst_ps1),
        .pc_guessed_in(pc_guessed_ps0),
        .pc_guessed(pc_guessed_ps1)
    );
