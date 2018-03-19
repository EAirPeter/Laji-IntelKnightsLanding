#!/bin/python3
import re
pattern = re.compile(r"^(wire|reg) +(\[.*\])?(.*);")

table = [set() for i in range(0, 6)]
header = """`timescale 1ns / 1ps
`include "Core.vh"
// Brief: pipeline stage%d, sychronized
// Author: FluorineDog
module SynPS%d(
    input clk,
    input rst_n,
    input en,       
%s
);
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin 
%s
        end else begin
%s
        end
    end
endmodule
"""
defines_file = "inc/Laji_defines_inc.vh"
with open(defines_file) as file:
    for line in file.readlines():
        ans = pattern.match(line).groups()
        if not ans:
            continue
        width = ans[1]
        keywords = ans[2]
        # print(width, keywords)
        keywords = keywords.replace(",", " ")
        for word in keywords.split(): 
            if word[-3:-1] == "ps":
                # print(word[-1:])
                table[int(word[-1])].add((word, width))

tab = "    "
tab2 = tab + tab
tab3 = tab + tab + tab

header2 = """    // dog auto generation
    SynPS%d vPS%d(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),

%s
    );
"""

# print("hhh")
def gen(key_list, index):
    # filename = "test/Laji_vPS" + str(index)
    input_lines = []
    output_lines = []
    rst_lines = []
    pc_4_lines = []
    assign_lines = []

    for word, width in key_list:
        width = "" if width == None else width + " "
        input_lines.append(tab + "input " + width + word + "_in")
        output_lines.append(tab + "output reg " + width + word)
        rst_lines.append(tab3 + word + " <= 0;")
        pc_4_lines.append(tab3 + "%s <= %s_in;" % (word, word))
        assign_lines.append(tab2 + ".%s_in(%s_ps%d)" % (word, word, index))
        assign_lines.append(tab2 + ".%s(%s_ps%d)" % (word, word, index + 1))
    input_lines.sort()
    output_lines.sort()
    rst_lines.sort()
    pc_4_lines.sort()


    l1 = ",\n".join(input_lines + output_lines)
    l2 = "\n".join(rst_lines)
    l3 = "\n".join(pc_4_lines)

    ll1 = ",\n".join(assign_lines)
    index += 1
    filename = "SynPS%d.v" % index 
    with open(filename, "w") as file:
        file.write(header% (index, index, l1, l2, l3))

    
    filename = "inc/Laji_vPS%d_inc.vh" % index
    with open(filename, "w") as file:
        file.write(header2% (index, index, ll1))
    
for src in range(0, 5):
    if src == 4:
        continue
    dest = src + 1
    key_list = set()
    for word_src, width in table[src]:
        word_dest = word_src[:-1] + str(dest)
        # print(word1)
        if (word_dest, width) in table[dest]:
            key_list.add((word_src[:-4], width))
    gen(key_list, src)
