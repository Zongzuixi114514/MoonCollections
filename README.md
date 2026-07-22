# MoonCollections

A comprehensive data structure library for MoonBit, providing 7 core data structures:

- **IndexMap** — A hash map that preserves insertion order
- **OrderedSet** — A set that preserves insertion order with set operations
- **BitSet** — A fixed-size bit-level data structure for set operations
- **BitVec** — A dynamically growable bit vector
- **BloomFilter** — Probabilistic set for space-efficient membership tests
- **LRUCache** — Least-recently-used cache built on IndexMap
- **UnionFind** — Disjoint-set with path compression and union by rank
- **CountMap** — Frequency counter / multiset
- **Trie** — Prefix tree for efficient string storage and lookup
- **RingBuffer** — Fixed-size circular buffer
- **SparseSet** — Sparse integer set with O(1) operations

## Installation

```bash
moon add Zongzuixi114514/mooncollections
```

## Import Configuration

In your `moon.pkg`, import the packages you need:

```
import {
  "Zongzuixi114514/mooncollections/indexmap",
  "Zongzuixi114514/mooncollections/orderedset" @oset,
  "Zongzuixi114514/mooncollections/bitmask",
  "Zongzuixi114514/mooncollections/bloomfilter",
  "Zongzuixi114514/mooncollections/lrucache",
  "Zongzuixi114514/mooncollections/unionfind",
  "Zongzuixi114514/mooncollections/countmap",
  "Zongzuixi114514/mooncollections/bitvec",
  "Zongzuixi114514/mooncollections/trie",
  "Zongzuixi114514/mooncollections/ringbuffer",
  "Zongzuixi114514/mooncollections/sparseset",
}
```

## Quick Start

```moonbit
// IndexMap — order-preserving key-value store
let map : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
map.set("first", 1)
map.set("second", 2)
map.get_index(0)  // Some(("first", 1))
map.keys()        // ["first", "second"] in insertion order

// OrderedSet — order-preserving set with set operations
let a = @indexmap.OrderedSet::from_array([1, 2, 3])
let b = @indexmap.OrderedSet::from_array([2, 3, 4])
let u = a.union(b)              // {1, 2, 3, 4}
let i = a.intersection(b)       // {2, 3}
a.is_subset(u)                  // true

// BitSet — bit-level set operations
let bits = @bitmask.BitSet::new(256)
bits.set(42)
bits.set(100)
bits.has(42)                    // true
bits.count()                    // 2
let other = @bitmask.BitSet::new(256)
other.set(100)
let inter = bits.intersection(other)  // only bit 100

// BloomFilter — probabilistic set membership
let bf = @bloomfilter.BloomFilter::new(1000, 0.01)
bf.add("hello")
bf.add("world")
bf.contains("hello")            // true
bf.contains("missing")          // false (probably)

// LRUCache — least-recently-used cache
let cache : @lrucache.LRUCache[String, Int] = @lrucache.LRUCache::new(3)
cache.put("a", 1)
cache.put("b", 2)
cache.put("c", 3)
cache.put("d", 4)               // evicts "a"
cache.get("a")                  // None

// UnionFind — disjoint-set
let uf = @unionfind.UnionFind::new(10)
uf.union(0, 1)
uf.union(1, 2)
uf.connected(0, 2)              // true
uf.connected(0, 3)              // false

// CountMap — frequency counter
let cm = @countmap.CountMap::from_array(["a", "b", "a", "a", "c"])
cm.get("a")                     // 3
cm.most_common()                // Some("a")
cm.entropy()                    // ~1.37

// BitVec — growable bit vector
let bv = @bitvec.BitVec::new()
bv.set(0)
bv.set(100)
bv.has(100)                     // true
bv.len()                        // 101

// Trie — prefix tree
let trie = @trie.Trie::new()
trie.insert("hello")
trie.insert("world")
trie.contains("hello")          // true
trie.starts_with("hel")         // true
```

## Run Commands

```bash
# Run all tests
moon test

# Type-check
moon check

# Format code
moon fmt

# Run CLI demo
moon run cmd/main
```

## License

MIT
