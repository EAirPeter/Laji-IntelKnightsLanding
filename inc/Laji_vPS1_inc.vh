    // dog auto generation
    SynPS1 vPS1(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),

        .pc_4_in(pc_4_ps0),
        .pc_4(pc_4_ps1),
        .inst_in(inst_ps0),
        .inst(inst_ps1)
    );
