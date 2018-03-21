#include <cstdarg>
#include <cstddef>
#include <cstdio>
#include <memory>
#include <unordered_map>
#include <vector>

using namespace std;

using ScopedFile = unique_ptr<FILE, decltype(&fclose)>;

char buf[4096];

ScopedFile FileOpen(const char *mode, const char *path) {
    return {fopen(path, mode), &fclose};
}

ScopedFile FileOpenFmt(const char *mode, const char *fmt, ...) {
    va_list varg;
    va_start(varg, fmt);
    vsprintf(buf, fmt, varg);
    va_end(varg);
    return FileOpen(mode, buf);
}

template<class T, size_t n>
constexpr size_t GetSize(T (&)[n]) {
    return n;
}

constexpr char lbls[][6] {
    "F____", "FD___", "FDX__", "FDXM_", "FDXMW",
                      "FDO__", "FDOM_", "FDOMW",
             "_D___", "_DX__", "_DXM_", "_DXMW",
                      "_DO__", "_DOM_", "_DOMW",
                      "__X__", "__XM_", "__XMW",
                               "___M_", "___MW",
                                        "____W",
};
constexpr auto nlbl = GetSize(lbls);
const unordered_map<char, const char *> mdecl {
    {'F', "if_``name_"},
    {'D', "id_``name_"},
    {'X', "ex_``name_"},
    {'O', "ex_``name_``_old, ex_``name_"},
    {'M', "ma_``name_"},
    {'W', "wb_``name_"},
};
constexpr auto npif = 4;
constexpr char pifnams[npif][5] {
    "IFID", "IDEX", "EXMA", "MAWB"
};
const vector<pair<const char *, int>> pifkwds[npif] {
    {{"FD", 0}},
    {{"DX", 1}, {"DO", 2}},
    {{"XM", 3}, {"OM", 4}},
    {{"MW", 5}}
};

constexpr auto npnam = 6;
constexpr const char *pinams[npnam] {
    "if_``name_", "id_``name_", "id_``name_",
    "ex_``name_", "ex_``name_", "ma_``name_"
};
constexpr const char *ponams[npnam] {
    "id_``name_", "ex_``name_", "ex_``name_``_old",
    "ma_``name_", "ma_``name_", "wb_``name_"
};

void PrintDecl(FILE *fp) {
    for (auto &lbl : lbls) {
        fprintf(fp, "`define GEN_%s(nbit_, name_) wire [(nbit_) - 1:0] ", lbl);
        auto flag = true;
        for (auto &c : lbl) {
            auto it = mdecl.find(c);
            if (it == mdecl.end())
                continue;
            if (flag)
                flag = false;
            else
                fprintf(fp, ", ");
            fprintf(fp, "%s", it->second);
        }
        fprintf(fp, ";\n");
    }
}

void PrintNBit(FILE *fp, int i) {
    for (auto &lbl : lbls) {
        fprintf(fp, "`define GEN_%s(nbit_, name_)", lbl);
        auto idx = -1;
        for (auto &[kwd, key] : pifkwds[i])
            if (strstr(lbl, kwd))
                idx = key;
        if (idx != -1)
            fprintf(fp, " + (nbit_)");
        fprintf(fp, "\n");
    }
}

void PrintIPort(FILE *fp, int i) {
    for (auto &lbl : lbls) {
        fprintf(fp, "`define GEN_%s(nbit_, name_)", lbl);
        auto idx = -1;
        for (auto &[kwd, key] : pifkwds[i])
            if (strstr(lbl, kwd))
                idx = key;
        if (idx != -1)
            fprintf(fp, " , %s", pinams[idx]);
        fprintf(fp, "\n");
    }
}

void PrintOPort(FILE *fp, int i) {
    for (auto &lbl : lbls) {
        fprintf(fp, "`define GEN_%s(nbit_, name_)", lbl);
        auto idx = -1;
        for (auto &[kwd, key] : pifkwds[i])
            if (strstr(lbl, kwd))
                idx = key;
        if (idx != -1)
            fprintf(fp, " , %s", ponams[idx]);
        fprintf(fp, "\n");
    }
}

void PrintPif(FILE *fp) {
    for (auto i = 0; i < npif; ++i) {
        auto &pif = pifnams[i];
        fprintf(fp, "wire pipltmp_%s;\n", pif);
        fprintf(fp, "SynPiplIntf #(\n");
        PrintNBit(fp, i);
        fprintf(fp, "    .NBit(1 `GEN_DAT)\n");
        fprintf(fp, "`include \"GenUndef.vh\"\n");
        fprintf(fp, ") v%s(\n", pif);
        fprintf(fp, "    .clk(clk),\n");
        fprintf(fp, "    .rst_n(rst_n),\n");
        fprintf(fp, "`ifdef PIF_%s_ENA\n", pif);
        fprintf(fp, "    .en(`PIF_%s_ENA),\n", pif);
        fprintf(fp, "`else\n");
        fprintf(fp, "    .en(en),\n");
        fprintf(fp, "`endif\n");
        fprintf(fp, "`ifdef PIF_%s_NOP\n", pif);
        fprintf(fp, "    .nop(`PIF_%s_NOP),\n", pif);
        fprintf(fp, "`else\n");
        fprintf(fp, "    .nop(1'b0),\n");
        fprintf(fp, "`endif\n");
        PrintIPort(fp, i);
        fprintf(fp, "    .data_i({1'b0 `GEN_DAT}),\n");
        fprintf(fp, "`include \"GenUndef.vh\"\n");
        PrintOPort(fp, i);
        fprintf(fp, "    .data_o({pipltmp_%s `GEN_DAT})\n", pif);
        fprintf(fp, "`include \"GenUndef.vh\"\n");
        fprintf(fp, ");\n");
    }
}

void GenAll() {
    auto sf = FileOpen("w", "GenAll.vh");
    auto fp = sf.get();
    PrintDecl(fp);
    fprintf(fp, "`GEN_DAT\n");
    fprintf(fp, "`include \"GenUndef.vh\"\n");
    PrintPif(fp);
}

void GenUndef() {
    auto sf = FileOpen("w", "GenUndef.vh");
    auto fp = sf.get();
    for (auto &lbl : lbls)
        fprintf(fp, "`undef GEN_%s\n", lbl);
}

int main() {
    GenAll();
    GenUndef();
    return 0;
}
