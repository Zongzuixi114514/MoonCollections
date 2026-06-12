# MoonCollections

A data structure library for MoonBit, providing 7 core modules:

- **IndexMap** — A hash map that preserves insertion order
- **OrderedSet** — A set that preserves insertion order
- **BitSet** — A fixed-size bit-level data structure for set operations
- **BloomFilter** — Probabilistic set for space-efficient membership checks
- **LRUCache** — Least-recently-used cache built on IndexMap
- **UnionFind** — Disjoint-set with path compression and union by rank
- **CountMap** — Frequency counter / multiset

## Installation

```bash
moon add oilleelssq-wq/mooncollections
```

## Quick Start

```moonbit
// IndexMap — order-preserving key-value store
let map : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
map.set("first", 1)
map.set("second", 2)
map.get_index(0)  // Some(("first", 1))

// BitSet — bit-level set operations
let bits = @bitmask.BitSet::new(256)
bits.set(42)
bits.has(42)  // true

// BloomFilter — probabilistic set
let bf = @bloomfilter.BloomFilter::new(1000, 0.01)
bf.add("hello")
bf.contains("hello")  // true

// LRUCache — least-recently-used cache
let cache : @lrucache.LRUCache[String, Int] = @lrucache.LRUCache::new(3)
cache.put("a", 1)
cache.get("a")  // Some(1)

// UnionFind — disjoint-set
let uf = @unionfind.UnionFind::new(10)
uf.union(0, 1)
uf.connected(0, 1)  // true

// CountMap — frequency counter
let cm = @countmap.CountMap::from_array(["a", "b", "a", "a"])
cm.get("a")  // 3
cm.most_common()  // Some("a")
```

## License

MIT
