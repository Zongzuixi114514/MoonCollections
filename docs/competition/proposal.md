# MoonCollections 项目申报书

## 基本信息

| 项目 | 内容 |
|------|------|
| **项目名称** | MoonCollections：MoonBit 数据结构库（IndexMap + BitSet + OrderedSet） |
| **GitHub 仓库** | https://github.com/Zongzuixi114514/MoonCollections |
| **GitLink 仓库** | https://gitlink.org.cn/CC488/mooncollections |
| **项目方向** | MoonBit 基础库 / 数据结构与集合 |
| **是否为移植项目** | 是（参考 Rust indexmap crate 和 bit-set crate 设计） |
| **许可证** | MIT |

## 项目简介

MoonCollections 是一个**纯 MoonBit 实现**的数据结构库，提供三个核心数据结构：

- **IndexMap**：保留插入顺序的哈希映射，兼具 `HashMap` 的快速查找和 `Array` 的有序迭代能力
- **OrderedSet**：保留插入顺序的集合，基于 IndexMap 构建，支持集合运算
- **BitSet**：固定大小位图数据结构，适用于集合运算、权限管理和标志位操作

MoonBit 标准库提供了 `HashMap`、`HashSet` 等无序集合，以及 `SortedMap`、`SortedSet` 等排序集合，但**缺少保留插入顺序**的映射和集合类型。位图（BitSet/BitMask）类数据结构同样是空白。本项目填补这些生态空缺。

## 核心功能范围

### IndexMap（保序哈希映射，404 行）

- 键值对插入/更新/删除（首次插入决定顺序，更新保持位置）
- 按键查找（O(1)）、按索引访问（O(1)）
- shift_remove 和 swap_remove 两种删除策略
- 顺序迭代（iter / keys / values）、反向迭代（iter_rev）
- 过滤器（retain）、排序（sort_keys）、pop 出栈操作
- get_or_init 懒初始化接口、to_array 导出
- Eq 和 Show trait 实现

### OrderedSet（保序集合，225 行）

- 元素的增删查改，插入顺序保持
- 按索引访问（get_index）、首尾元素获取（first/last）
- 集合运算：并集、交集、差集、对称差
- 子集/超集判定（is_subset / is_superset）
- 顺序迭代、批量构造（from_array）
- Eq 和 Show trait 实现

### BitSet（位图数据结构，312 行）

- 位级操作：set / clear / toggle / has
- 计数：count（popcount）、count_zeros、any、all
- 批操作：fill（全置1）、clear_all（全清零）、complement（取反）
- 集合运算：union、intersection、difference、symmetric_difference
- 关系判定：is_subset、is_superset、is_disjoint
- 变换：resize（扩容/缩容）、from_indices、to_array
- 升序迭代（iter），Eq 和 Show trait 实现

### 工程质量

- 103 个单元测试全部通过
- GitHub Actions CI 持续集成
- 完整 README（安装、快速开始、API 参考）

## 差异化价值

| 对比维度 | 标准库 HashMap | 标准库 SortedMap | MoonCollections IndexMap |
|---------|--------------|----------------|------------------------|
| 迭代顺序 | 未定义（hash 顺序） | 键排序 | **插入顺序** |
| 按键查找 | O(1) | O(log n) | **O(1)** |
| 按索引访问 | 不支持 | 不支持 | **O(1)** |
| 内存开销 | 低 | 中（树结构） | 中（双存储） |
| 适用场景 | 通用映射 | 键排序需求 | **缓存、配置、LRU、数据管道** |

| 对比维度 | 标准库 HashSet | MoonCollections OrderedSet |
|---------|--------------|--------------------------|
| 迭代顺序 | 未定义 | **插入顺序** |
| 集合运算 | 无内置 | **并集/交集/差集/对称差完整** |
| 索引访问 | 不支持 | **支持** |

BitSet 在 MoonBit 生态中无直接竞品，填补了位级数据结构空白。

## 项目规模

| 模块 | 源码行数 | 测试行数 |
|------|---------|---------|
| bitmask (BitSet) | 312 | 435 |
| indexmap (IndexMap) | 404 | 409 |
| orderedset (OrderedSet) | 225 | 217 |
| 其他（配置/文档/CI） | 33 | — |
| **合计** | **974** | **1061** |

项目总计约 **2,035 行**（源码 974 行 + 测试 1,061 行），符合 2,000-3,000 行有效代码的目标。

## 实现计划

1. **已完成**：BitSet 完整实现、IndexMap 基础功能（set/get/remove/iter）、OrderedSet 基础功能
2. **已完成**：BitSet 增强（subset/superset/symmetric_diff/complement/resize）、IndexMap 增强（retain/sort_keys/iter_rev/pop/get_or_init）
3. **已完成**：完整测试套件（103 测试）、CI 配置、项目文档
4. **待完成**：GitHub/GitLink 仓库推送、提交历史整理（10-20 commits）

## 适用场景

- **缓存系统**：LRU 缓存可利用 IndexMap 的插入顺序和 O(1) 操作实现
- **数据管道**：需要在保持输入顺序的同时进行去重和查找
- **配置文件处理**：保持配置项的书写顺序，同时支持按键快速查找
- **权限管理**：BitSet 可用于 RBAC 权限位的存储和运算
- **图论算法**：BitSet 可用于邻接矩阵的压缩存储和快速集合运算
- **MoonBit 生态基础设施**：为标准库补充缺失的数据结构类型
