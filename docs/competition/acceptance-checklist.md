# MoonCollections — Competition Acceptance Checklist

## Core Features

### BitSet / BitMask
- [x] `BitSet::new(size)` — create with given bit count
- [x] `set(index)` / `clear(index)` / `toggle(index)` — bit manipulation
- [x] `has(index)` — check bit state
- [x] `count()` — popcount across all bytes
- [x] `is_empty()` / `length()` / `fill()` / `clear_all()`
- [x] `union(other)` / `intersect(other)` / `difference(other)` — set algebra
- [x] `iter()` — iterate indices of set bits
- [x] `Eq` trait — equality comparison
- [x] `Show` trait — string representation

### IndexMap
- [x] `IndexMap::new()` — create empty ordered map
- [x] `set(key, value)` — insert/update (preserves insertion position)
- [x] `get(key)` — key-based lookup
- [x] `get_index(i)` / `get_key(i)` / `get_value(i)` — positional access
- [x] `contains(key)` — key existence check
- [x] `remove(key)` — shift-remove by key
- [x] `swap_remove(i)` / `shift_remove(i)` — positional remove
- [x] `length()` / `is_empty()` / `clear()`
- [x] `first()` / `last()` — boundary access
- [x] `iter()` / `keys()` / `values()` — ordered iteration
- [x] `from_array(arr)` — batch construction
- [x] `retain(predicate)` — filter entries in-place
- [x] `iter_rev()` — reverse-order iteration
- [x] `sort_keys(compare)` — sort by key
- [x] `pop()` — remove and return last entry
- [x] `to_array()` — convert to ordered array
- [x] `get_or_init(key, init)` — get or lazy-insert
- [x] `Eq` trait — equality comparison
- [x] `Show` trait — string representation

### OrderedSet
- [x] `add(value)` / `remove(value)` — insert/delete
- [x] `contains(value)` — membership check
- [x] `get_index(i)` / `first()` / `last()` — positional access
- [x] `length()` / `is_empty()` / `clear()`
- [x] `union(other)` / `intersection(other)` / `difference(other)` / `symmetric_difference(other)`
- [x] `is_subset(other)` / `is_superset(other)`
- [x] `iter()` — ordered iteration
- [x] `from_array(arr)` — batch construction
- [x] `Eq` trait — equality comparison
- [x] `Show` trait — string representation

## Project Quality
- [x] `moon check` passes with 0 errors
- [x] `moon build` succeeds (via `moon test`)
- [x] `moon test` — 103 tests, all passing
- [x] CI configuration (`.github/workflows/ci.yml`)
- [x] README with installation, quick start, and API reference
- [x] MIT License
- [x] GitHub + GitLink mirror ready

## Code Statistics
- BitSet module: ~312 lines (bitmask/bitset.mbt)
- IndexMap module: ~404 lines (indexmap/indexmap.mbt)
- OrderedSet module: ~225 lines (orderedset/orderedset.mbt)
- Tests: ~1060 lines across all modules
- Total: ~2035 lines

## Competition Submission
- [ ] GitHub repository pushed
- [ ] GitLink mirror pushed
- [ ] 10-20 meaningful commits
- [ ] Project proposal PDF generated
