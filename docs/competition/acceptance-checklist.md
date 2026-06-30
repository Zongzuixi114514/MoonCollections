# MoonCollections — Competition Acceptance Checklist

## Core Features

### BitSet
- [x] `BitSet::new(size)` / `with_params(bits, hashes)` — create
- [x] `set(index)` / `clear(index)` / `toggle(index)` — bit manipulation
- [x] `has(index)` / `count()` / `count_zeros()` / `any()` / `all()`
- [x] `is_empty()` / `length()` / `fill()` / `clear_all()` / `complement()`
- [x] `union(other)` / `intersect(other)` / `difference(other)` / `symmetric_difference(other)`
- [x] `is_subset(other)` / `is_superset(other)` / `is_disjoint(other)`
- [x] `resize(new_size)` / `from_indices(arr)` / `to_array()`
- [x] `iter()` — iterate set bit indices
- [x] `Eq` + `Show` traits

### IndexMap
- [x] `new()` / `set(key, value)` / `get(key)` / `get_index(i)` / `get_key(i)` / `get_value(i)`
- [x] `contains(key)` / `remove(key)` / `swap_remove(i)` / `shift_remove(i)`
- [x] `length()` / `is_empty()` / `clear()` / `first()` / `last()` / `pop()`
- [x] `retain(predicate)` / `sort_keys(compare)` — in-place operations
- [x] `iter()` / `keys()` / `values()` / `iter_rev()` — ordered iteration
- [x] `get_or_init(key, init)` / `from_array(arr)` / `to_array()`
- [x] `Eq` + `Show` traits

### OrderedSet
- [x] `add(value)` / `remove(value)` / `contains(value)`
- [x] `get_index(i)` / `first()` / `last()` / `length()` / `is_empty()` / `clear()`
- [x] `union(other)` / `intersection(other)` / `difference(other)` / `symmetric_difference(other)`
- [x] `is_subset(other)` / `is_superset(other)`
- [x] `iter()` / `from_array(arr)` — ordered iteration and construction
- [x] `Eq` + `Show` traits

### BloomFilter
- [x] `new(expected, fpr)` / `with_params(bits, hashes)` — configurable creation
- [x] `add(item)` / `contains(item)` — insert and probabilistic lookup
- [x] `clear()` / `set_bits()` / `estimated_fpr()` / `bit_count()` / `hash_count()`
- [x] `Show` trait

### LRUCache
- [x] `new(capacity)` / `set_capacity(n)` — capacity management
- [x] `get(key)` / `peek(key)` / `put(key, value)` / `remove(key)`
- [x] `lru()` / `mru()` — access-order boundary
- [x] `contains(key)` / `length()` / `is_empty()` / `clear()` / `capacity()`
- [x] `iter()` — LRU-to-MRU order
- [x] `Show` trait

### UnionFind
- [x] `new(n)` / `find(x)` / `union(x, y)` / `connected(x, y)`
- [x] Path compression + union by rank
- [x] `count()` / `size(x)` / `length()` / `roots()` / `reset()`
- [x] `Show` trait

### CountMap
- [x] `increment(key)` / `decrement(key)` / `add(key, n)` / `get(key)` / `set(key, count)`
- [x] `remove(key)` / `contains(key)` / `length()` / `is_empty()` / `total()` / `clear()`
- [x] `most_common()` / `most_common_n(n)` — top-N with sorting
- [x] `merge(other)` / `from_array(arr)` / `iter()`
- [x] `Show` trait

## Project Quality
- [x] `moon check` — 0 errors
- [x] `moon build` — succeeds
- [x] `moon test` — 158 tests, all passing
- [x] CI configuration (`.github/workflows/ci.yml`)
- [x] README with installation, quick-start for all 7 modules, and API reference
- [x] MIT License (LICENSE + moon.mod + README all consistent)

## Code Statistics

| Module | Source | Tests | Test Count |
|--------|--------|-------|------------|
| bitmask (BitSet) | 312 | 435 | 27 |
| indexmap (IndexMap) | 404 | 409 | 26 |
| orderedset (OrderedSet) | 225 | 217 | 18 |
| bloomfilter | 138 | 92 | 12 |
| lrucache | 125 | 150 | 17 |
| unionfind | 104 | 95 | 12 |
| countmap | 156 | 138 | 15 |
| Other (CI/config) | 33 | - | - |
| **Total** | **1,497** | **1,536** | **158** |

**Grand total: 3,033 lines**

## Competition Submission
- [x] GitHub repository pushed (15 commits)
- [x] GitLink mirror pushed (15 commits)
- [x] 10-20 meaningful commits (15 commits, each a logical unit)
- [x] Project proposal PDF generated (1 page, competition format)
- [x] Author identity unified (CC488)
