# Third-Party Notices

MoonCollections is a MoonBit port referencing the design of the following Rust crates:

## indexmap

- Source: https://github.com/indexmap-rs/indexmap
- License: Apache-2.0 OR MIT
- Reference scope: The `IndexMap` module (`indexmap/`) adapts the order-preserving hash map design from `indexmap`. The insertion-order preservation strategy (HashMap + keys array), `shift_remove`/`swap_remove` deletion semantics, `get_index` index-based access, `retain` filtering, and `sort_keys` ordering are informed by the Rust implementation. The MoonBit implementation is a clean-room port written in pure MoonBit; no Rust code was copied.

## bit-set

- Source: https://github.com/contain-rs/bit-set
- License: Apache-2.0 OR MIT
- Reference scope: The `BitSet` module (`bitmask/`) and `BitVec` module (`bitvec/`) adapt the bit-level set operations design from `bit-set` and `bit-vec`. The byte-array storage, bit indexing, `set`/`clear`/`toggle`/`has` operations, `union`/`intersection`/`difference`/`symmetric_difference` set algebra, `is_subset`/`is_superset`/`is_disjoint` relations, `count` (popcount), `iter` traversal, and `resize` semantics are informed by the Rust implementations. The MoonBit implementations are clean-room ports written in pure MoonBit; no Rust code was copied.
