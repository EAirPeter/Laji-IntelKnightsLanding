#include <cstdio>

using namespace std;

constexpr auto tot = 5;

void Generate(int beg, int end, bool old) {
    constexpr const char *lbls[tot + 1][2] {
        {"F", "if_``name_"},
        {"D", "id_``name_"},
        {"X", "ex_``name_"},
        {"M", "ma_``name_"},
        {"W", "wb_``name_"},
        {"O", "ex_``name_``_old"},
    };
    printf("`define DECL_");
    for (auto i = 0; i < tot + 1; ++i)
        printf("%s", (i >= beg && i < end) || (i == tot && old) ? lbls[i][0] : "_");
    printf("(nbit_, name_) \\\n");
    printf("    localparam NBit_``name_ = (nbit_); \\\n");
    printf("    wire [NBit_``name_ - 1:0] %s", lbls[beg][1]);
    for (auto i = beg + 1; i < end; ++i)
        printf(", %s", lbls[i][1]);
    if (old)
        printf(", ex_``name_``_old");
    printf("\n");
}

int main() {
    for (auto i = 0; i < tot; ++i)
        for (auto j = i + 1; j <= tot; ++j) {
            Generate(i, j, false);
            Generate(i, j, true);
        }
    return 0;
}
