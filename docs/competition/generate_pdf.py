"""Generate MoonCollections proposal PDF — one-page compact style."""
from fpdf import FPDF
import os

chinese_font = None
for fp in [
    "C:/Windows/Fonts/msyh.ttc",
    "C:/Windows/Fonts/msyhbd.ttc",
    "C:/Windows/Fonts/simsun.ttc",
    "C:/Windows/Fonts/simhei.ttf",
]:
    if os.path.exists(fp):
        chinese_font = fp
        break
if not chinese_font:
    print("ERROR: No Chinese font found!")
    exit(1)

class PDF(FPDF):
    def __init__(self):
        super().__init__()
        self.add_font("F", "", chinese_font)
        self.add_font("F", "B", chinese_font)

    def header(self):
        pass

    def footer(self):
        pass

    def title_line(self):
        self.set_fill_color(27, 67, 50)
        self.rect(self.l_margin, self.get_y(), self.w - self.l_margin - self.r_margin, 2, style="F")
        self.ln(4)
        self.set_font("F", "B", 16)
        self.set_text_color(27, 67, 50)
        self.cell(0, 7, "MoonCollections 项目申报书", align="C", new_x="LMARGIN", new_y="NEXT")
        self.set_font("F", "", 8)
        self.set_text_color(130, 120, 105)
        self.cell(0, 5, "2026 MoonBit 国产开源生态竞赛（个人赛）", align="C", new_x="LMARGIN", new_y="NEXT")
        self.ln(2)

    def sec(self, num, title):
        self.ln(1)
        self.set_font("F", "B", 10)
        self.set_text_color(27, 67, 50)
        self.cell(0, 5, f"{num}、{title}", new_x="LMARGIN", new_y="NEXT")
        self.set_draw_color(27, 67, 50)
        self.set_line_width(0.2)
        self.line(self.l_margin, self.get_y(), self.w - self.r_margin, self.get_y())
        self.ln(1.5)

    def body(self, text):
        self.set_font("F", "", 7.5)
        self.set_text_color(55, 55, 55)
        self.multi_cell(0, 3.8, text, align="L")

    def bullet(self, text):
        self.set_font("F", "", 7)
        self.set_text_color(65, 65, 65)
        self.cell(3, 3.6, "")
        self.cell(0, 3.6, "- " + text, new_x="LMARGIN", new_y="NEXT")

    def info(self, label, value):
        self.set_font("F", "B", 7.5)
        self.set_text_color(60, 60, 60)
        self.cell(28, 4.2, label + "：")
        self.set_font("F", "", 7.5)
        self.set_text_color(50, 50, 50)
        self.cell(0, 4.2, value, new_x="LMARGIN", new_y="NEXT")

    def sub(self, title):
        self.set_font("F", "B", 8)
        self.set_text_color(27, 67, 50)
        self.cell(0, 4.5, title, new_x="LMARGIN", new_y="NEXT")

    def t_header(self, cells, widths):
        self.set_fill_color(27, 67, 50)
        self.set_text_color(255, 255, 255)
        self.set_font("F", "B", 7)
        h = 5
        for cell, w in zip(cells, widths):
            x = self.get_x()
            self.rect(x, self.get_y(), w, h, style="F")
            self.cell(w, h, " " + cell)
        self.ln(h)

    def t_row(self, cells, widths, bold=False):
        if bold:
            self.set_fill_color(248, 245, 236)
            self.set_font("F", "B", 7)
        else:
            self.set_fill_color(255, 255, 255)
            self.set_font("F", "", 7)
        self.set_text_color(50, 50, 50)
        h = 4.8
        for cell, w in zip(cells, widths):
            x = self.get_x()
            self.rect(x, self.get_y(), w, h, style="DF")
            self.cell(w, h, " " + cell)
        self.ln(h)


pdf = PDF()
pdf.set_auto_page_break(auto=False)
pdf.add_page()

pdf.title_line()

# ===== 一 =====
pdf.sec("一", "基本信息")
pdf.info("项目名称", "MoonCollections：MoonBit 数据结构库（IndexMap / OrderedSet / BitSet / BloomFilter / LRUCache / UnionFind / CountMap）")
pdf.info("GitHub", "https://github.com/Zongzuixi114514/MoonCollections")
pdf.info("GitLink", "https://gitlink.org.cn/CC488/mooncollections")
pdf.info("项目方向", "MoonBit 基础库 / 数据结构与集合")
pdf.info("移植参考", "Rust indexmap、bit-set crate 设计思路｜许可证：MIT")

# ===== 二 =====
pdf.sec("二", "项目简介")
pdf.body(
    "MoonCollections 是一个纯 MoonBit 实现的数据结构库，提供 7 个核心模块。"
    "MoonBit 标准库缺少保序映射、保序集合、位图、布隆过滤器、LRU 缓存、并查集等常用数据结构，"
    "本项目系统性地填补这些空白。所有实现纯 MoonBit 代码，零外部依赖，跨平台 Native/Wasm/JS 可运行。"
)

# ===== 三 =====
pdf.sec("三", "核心模块")

pdf.sub("IndexMap（404行）保序哈希映射 | OrderedSet（225行）保序集合 | BitSet（312行）位图")
for item in [
    "IndexMap: set/get/remove, get_index/get_key/get_value, swap_remove/shift_remove, iter/iter_rev/keys/values, retain/sort_keys/pop, get_or_init/to_array",
    "OrderedSet: add/remove/contains, get_index/first/last, union/intersection/difference/symmetric_difference, is_subset/is_superset, iter/from_array",
    "BitSet: set/clear/toggle/has, count/count_zeros/any/all, fill/clear_all/complement, union/intersect/diff/sym_diff, is_subset/superset/disjoint, resize/from_indices/to_array",
]:
    pdf.bullet(item)

pdf.sub("BloomFilter（138行）概率集合 | LRUCache（125行）LRU 缓存 | UnionFind（104行）并查集 | CountMap（156行）计数器")
for item in [
    "BloomFilter: 可配置误判率与哈希数, add/contains/clear/estimated_fpr, 用于 URL 去重/缓存穿透防护",
    "LRUCache: 基于 IndexMap, get/put/peek/remove, lru/mru, set_capacity 动态缩容, iter 按 LRU 顺序",
    "UnionFind: union/find/connected, 路径压缩+按秩合并, count/size/roots/reset, 用于图连通性/Kruskal",
    "CountMap: increment/decrement/add/set, most_common/most_common_n, merge/from_array, 用于词频/直方图/投票",
]:
    pdf.bullet(item)

# ===== 四 =====
pdf.sec("四", "差异化价值")

pdf.body("IndexMap vs 标准库对比：")
pdf.t_header(["维度", "HashMap", "SortedMap", "IndexMap"], [26, 40, 40, 40])
for row in [
    ("迭代顺序", "未定义", "键排序", "插入顺序"),
    ("按键查找", "O(1)", "O(log n)", "O(1)"),
    ("按索引访问", "不支持", "不支持", "O(1)"),
    ("适用场景", "通用映射", "排序需求", "缓存/管道/配置"),
]:
    pdf.t_row(row, [26, 40, 40, 40])

pdf.body(
    "BitSet/BloomFilter/LRUCache/UnionFind/CountMap 在 MoonBit 生态中均无等价实现，填补了位运算、"
    "概率集合、缓存策略、图论算法、频率统计五个方向的生态空白。OrderedSet 实现了 HashSet 所没有的集合运算与保序迭代。"
)

# ===== 五 =====
pdf.sec("五", "项目规模与进度")

pdf.t_header(["模块", "源码行", "测试行", "测试数"], [50, 24, 24, 24])
for row in [
    ("bitmask (BitSet)", "312", "435", "27"),
    ("indexmap (IndexMap)", "404", "409", "26"),
    ("orderedset (OrderedSet)", "225", "217", "18"),
    ("bloomfilter", "138", "92", "12"),
    ("lrucache", "125", "150", "17"),
    ("unionfind", "104", "95", "12"),
    ("countmap", "156", "138", "15"),
    ("其他（CI/配置)", "33", "-", "-"),
    ("合计", "1,497", "1,536", "158"),
]:
    pdf.t_row(row, [50, 24, 24, 24], bold=(row[0] == "合计"))
pdf.ln(1)

pdf.body(
    "总计 3,033 行，158 测试全通过，CI 已配置。已完成全部 7 个模块实现、完整测试套件、项目文档、"
    "双仓库推送和 13 次有效提交。"
)

# ===== 六 =====
pdf.sec("六", "适用场景")
pdf.body(
    "缓存系统（LRU/IndexMap）| 数据管道去重（OrderedSet/IndexMap）| 配置文件保序处理（IndexMap）| "
    "权限位存储运算（BitSet）| URL 去重/黑名单过滤（BloomFilter）| 图连通性/Kruskal 算法（UnionFind）| "
    "词频统计/投票系统（CountMap）| MoonBit 生态基础设施补全"
)

output_path = os.path.join(os.path.dirname(__file__), "MoonCollections项目申报书.pdf")
pdf.output(output_path)
print(f"Done: {output_path}")
