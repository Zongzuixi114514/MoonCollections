# MoonCollections 开发报告

## 一、项目概述

MoonCollections 是为 2026 MoonBit 国产开源生态竞赛开发的纯 MoonBit 数据结构库。项目目标是为 MoonBit 生态补充标准库中缺失的常用数据结构，包括保序映射、保序集合、位图、布隆过滤器、LRU 缓存、并查集和频率计数器，共 7 个模块。

- **开发周期**：2026 年 6 月
- **代码规模**：源码 1,497 行，测试 1,536 行，合计 3,033 行
- **测试覆盖**：158 个单元测试，全部通过
- **依赖**：零第三方依赖，仅使用 MoonBit 标准库
- **许可证**：MIT

## 二、技术架构

### 2.1 模块划分

```
mooncollections/
├── bitmask/        BitSet — 位图数据结构
├── indexmap/       IndexMap — 保序哈希映射
├── orderedset/     OrderedSet — 保序集合（依赖 IndexMap）
├── bloomfilter/    BloomFilter — 概率集合
├── lrucache/       LRUCache — 最近最少使用缓存（依赖 IndexMap）
├── unionfind/      UnionFind — 并查集
├── countmap/       CountMap — 频率计数器
├── cmd/            CLI 入口占位
└── docs/           竞赛文档
```

### 2.2 设计原则

**纯 MoonBit 实现**：所有模块均为 MoonBit 原生代码，不使用 FFI 绑定，确保跨平台兼容（Native / Wasm / JS）。

**渐进复杂度**：从简单数据结构（UnionFind、BitSet）到组合型结构（IndexMap → OrderedSet → LRUCache），形成清晰的依赖层次。

**类型安全**：充分利用 MoonBit 的 trait 系统，为支持的操作提供编译期约束（Hash + Eq），为调试提供 Show trait 实现。

**API 一致性**：所有模块遵循相同的命名惯例，迭代器统一返回 Iter[T]，构造器统一使用 new() / from_array() 模式。

### 2.3 依赖关系

```
BitSet          ← 独立，使用 Array[Byte] 存储
UnionFind       ← 独立，使用 Array[Int] 存储
CountMap        ← 依赖 @hashmap.HashMap
IndexMap        ← 依赖 @hashmap.HashMap + Array
OrderedSet      ← 依赖 IndexMap（复用保序逻辑）
LRUCache        ← 依赖 IndexMap（复用保序逻辑，实现 LRU 驱逐）
BloomFilter     ← 独立，使用 Array[Byte] + @math 哈希
```

## 三、各模块实现细节

### 3.1 BitSet（312 行）

**数据结构**：以 `Array[Byte]` 为内部存储，每字节存 8 位。位数可配置，不支持动态扩容。

**核心算法**：
- 位操作利用 MoonBit 的 `BitAnd`、`BitOr`、`BitXOr`、`Shr`、`Shl` trait 和 `.lnot()` 方法
- `count()` 使用硬件指令 `Byte::popcnt()`
- `iter()` 实现为惰性迭代器，按字节遍历，跳过零字节加速

**设计决策**：选择固定大小而非动态扩容。原因：(1) 集合运算语义要求双方位数匹配；(2) 避免了扩容时的边界判断开销；(3) `resize()` 方法提供显式的大小变换。

### 3.2 IndexMap（404 行）

**数据结构**：双存储架构 — 外层 `Array[K]` 维护插入顺序，内层 `HashMap[K, (Int, V)]` 维护键到（索引，值）的映射。

**核心算法**：
- `set(key, val)`：已存在则更新值（位置不变），不存在则追加到 Array 末尾
- `remove(key)`：shift-remove，O(n) 移动后续元素并更新索引
- `swap_remove(i)`：交换删除，O(1) 将末元素移到删除位置
- `retain(predicate)`：原地过滤，逐元素检查后执行 shift-remove
- `sort_keys(compare)`：冒泡排序 + 索引同步更新

**设计决策**：提供 shift_remove 和 swap_remove 两种删除策略。shift_remove 保序但 O(n)，swap_remove 不保序但 O(1)，用户根据场景选择。这是参考 Rust indexmap 的设计。

**关键难点**：删除操作需要同步更新 HashMap 中所有受影响元素的索引。实现中对每步操作都显式调用 `map.set(key, (new_index, value))` 更新映射。

### 3.3 OrderedSet（225 行）

**数据结构**：完全委托给 IndexMap[K, Unit]，将集合语义映射为映射语义（元素 → 键，Unit → 占位值）。

**设计决策**：选择组合而非独立实现。优点：(1) 复用 IndexMap 的所有操作逻辑和测试覆盖；(2) 当 IndexMap 修复 bug 或优化性能时，OrderedSet 自动受益；(3) 代码量减少 60% 以上。

### 3.4 BloomFilter（138 行）

**数据结构**：`Array[Byte]` 位数组 + 多个哈希函数。

**核心算法**：
- 哈希函数：利用 MoonBit 内置 `Hash` trait 的 `hash()` 方法 + 种子组合 `hash ^ (seed * 0x9E3779B9)`
- 位数组大小自动计算：`m = -n * ln(p) / (ln(2)^2)`（n=预期元素数，p=目标误判率）
- 哈希函数数量自动计算：`k = (m/n) * ln(2)`

**设计决策**：不实现删除操作。标准布隆过滤器不支持删除（会导致假阴性），如需删除应使用计数布隆过滤器，可作为未来扩展。

### 3.5 LRUCache（125 行）

**数据结构**：委托给 IndexMap[K, V]，利用其保序特性实现 LRU 驱逐。

**核心算法**：
- `get(key)`：remove(key) + set(key, value)，将元素移到末尾（最近使用）
- `put(key, val)`：若超容量，移除第一个元素（最久未使用，即 IndexMap 的第一个）
- `peek(key)`：直接读取 IndexMap 的值，不动顺序

**设计决策**：访问即重新排序的语义通过 remove+reinsert 实现，虽然每次 get 是 O(n)，但对于缓存容量通常较小（100-10000）的场景是可接受的。如果未来需要 O(1) 的 get，可以改用双向链表 + HashMap 的组合。

### 3.6 UnionFind（104 行）

**数据结构**：两个 `Array[Int]`——parent 数组存父节点索引，rank 数组存树高（用于按秩合并）。

**核心算法**：
- `find(x)`：路径压缩 —— 每次查找将当前节点直接指向祖父节点（`parent[x] = parent[parent[x]]`）
- `union(x, y)`：按秩合并 —— 将较矮的树合并到较高的树下，同高时任意合并并增加秩

**复杂度**：使用两种优化后，均摊时间复杂度接近 O(α(n))（阿克曼函数的反函数，实际上可视为常数时间）。

### 3.7 CountMap（156 行）

**数据结构**：委托给 HashMap[K, Int]，将键映射到计数器。

**核心算法**：
- `increment(key)`：使用 `get_or_default` 获取当前计数 + 1 后写回
- `decrement(key)`：减到 0 时自动 `remove(key)` 清理
- `most_common_n(n)`：收集所有键值对后用冒泡排序按计数值降序排列，取前 n 个

**设计决策**：decrement 到 0 时自动删除键，避免零计数值占用空间。most_common_n 使用 O(n²) 的冒泡排序而非 O(n log n) 的快速排序，因为：(1) MoonBit 标准库未提供排序函数；(2) CountMap 的键数量通常不会极大；(3) 实现简洁可读。

## 四、测试策略

### 4.1 测试组织

每个模块有独立的 `*_test.mbt` 文件，使用 MoonBit 内置的 `test` 关键字和 `assert_eq`/`assert_true`/`assert_false` 断言。

### 4.2 测试覆盖

| 模块 | 测试数 | 覆盖范围 |
|------|--------|---------|
| BitSet | 27 | 位操作、计数、集合运算、子集关系、迭代、边界条件 |
| IndexMap | 26 | 增删改查、顺序保持、过滤器、排序、迭代器、Eq |
| OrderedSet | 18 | 增删查、集合运算、子集关系、迭代、去重 |
| BloomFilter | 12 | 添加/查询、空过滤器、误判率、大批量、类型兼容 |
| LRUCache | 17 | 增删查、LRU 驱逐、peek 不动顺序、容量变更、迭代 |
| UnionFind | 12 | 合并、连通性、路径压缩、集合计数、重置 |
| CountMap | 15 | 增减、topN、合并、from_array、清空、迭代 |

### 4.3 测试原则

- **每 API 至少一个测试**：每个公开方法都有对应的测试用例
- **边界条件覆盖**：空容器、单元素、满容量、越界索引
- **不变式验证**：插入顺序保持、集合运算恒等式（A∪A=A、A∩∅=∅）
- **大型数据测试**：IndexMap 100 条目插入验证，BloomFilter 200 条目无假阴性

## 五、遇到的问题与解决方案

### 5.1 MoonBit 语法适应

**问题**：BitSet 实现初期，尝试使用 C-style 的 `~` 运算符做按位取反，编译器报错"unrecognized character"。

**解决**：MoonBit 使用 `.lnot()` 方法实现按位取反。字节的位运算需通过 `.lnot()`、`.popcnt()`、`.lsr()`、`.lsl()` 等方法，或直接使用 `^`、`|`、`&`、`<<`、`>>` 运算符。

### 5.2 迭代器模式

**问题**：MoonBit 的 `Iter::new(fn)` 使用 `return Some(value)` 产生值和 `nobreak { None }` 结束迭代，而非 Rust 的 `yield` 或 Python 的 `yield`。

**解决**：研究标准库 HashMap 的 `iter()` 实现，理解 MoonBit 的闭包式迭代器模式：`while` 循环内用 `return Some(value)` 产生元素，循环外 `nobreak { None }` 表示结束。

### 5.3 结构体字段可变性

**问题**：为 BitSet 的 `data` 和 `len` 字段加 `mut` 导致编译警告"field mutability never used"。但为 IndexMap 的 `map` 和 `keys` 字段不加 `mut` 导致"record field is immutable"。

**解决**：MoonBit 中 `mut` 标记的是字段本身可否被整体替换（如 `self.field = new_value`），而非其内部状态可否被修改。通过索引修改 `Array` 元素不需要 `mut`，但整体替换字段值（如 `clear()` 中的 `self.map = HashMap([])`) 需要。

### 5.4 Map 字面量歧义

**问题**：match 表达式的空分支 `None => {}` 被编译器解析为 Map 字面量而非 Unit 值。

**解决**：使用 `None => ()` 明确表示返回 Unit 值。

### 5.5 HashMap 包引用

**问题**：IndexMap 和 CountMap 内部使用 HashMap，但子包中直接写 `HashMap` 无法解析。

**解决**：子包的 `moon.pkg` 需要显式 `import { "moonbitlang/core/hashmap" }`，代码中通过 `@hashmap.HashMap` 引用。

### 5.6 浮点运算

**问题**：BloomFilter 中 `p.ln()` 报错"Type Double has no method ln"。

**解决**：MoonBit 的数学函数通过 `@math` 包提供，应使用 `@math.ln(p)` 而非面向对象的 `p.ln()`。

## 六、工程实践

### 6.1 CI/CD

配置 GitHub Actions 自动构建流程：
- `moon check` — 类型检查
- `moon build` — 编译
- `moon test` — 运行全部 158 个测试

### 6.2 Git 工作流

16 次有意义的提交，每次对应一个独立的逻辑单元：
1. 项目脚手架（moon.mod、CI、LICENSE）
2-3. BitSet 实现 + 测试
4-5. IndexMap 实现 + 测试
6. OrderedSet（实现 + 测试合一）
7-11. BloomFilter、LRUCache、UnionFind、CountMap（各实现 + 测试合一）
12. 项目文档（README + 申报书 + 验收清单）
13. GitHub URL 更新
14. PDF 更新
15. LICENSE 修正（Apache-2.0 → MIT）
16. README.mbt.md 和验收清单完善

### 6.3 双仓库维护

项目同时推送到 GitHub 和 GitLink 两个远程仓库，通过 HTTPS 认证和 force-push 策略管理历史。

## 七、未来展望

### 7.1 性能优化

- IndexMap 的 get/remove 目前 O(1) 通过 HashMap 完成，但 shift-remove 需要 O(n) 的索引更新。可以通过记录"墓碑"标记延迟清理来优化。
- CountMap 的 `most_common_n` 可使用堆排序替代冒泡排序，将复杂度从 O(n²) 降至 O(n log k)。

### 7.2 功能扩展

- **Trie 前缀树**：字符串搜索和自动补全
- **PriorityQueue Extensions**：支持更新优先级、合并操作
- **Serialization**：为所有结构添加 JSON / 二进制序列化支持
- **Counting BloomFilter**：支持删除操作的布隆过滤器变体

### 7.3 生态贡献

- 发布到 MoonBit 包注册表（mooncakes.io）
- 编写使用教程和最佳实践文档
- 根据社区反馈持续改进 API 设计

## 八、总结

MoonCollections 项目在两周时间内完成了 7 个数据结构模块的完整实现、测试和文档工作。项目遵循纯 MoonBit、零依赖、类型安全的设计原则，为 MoonBit 生态贡献了一套实用且可扩展的基础数据结构库。

所有代码已通过编译和测试验证，双仓库部署就绪，CI 持续集成配置完成，具备作为竞赛提交项目的完整性和工程质量。
