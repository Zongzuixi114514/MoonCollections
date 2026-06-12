/// MoonCollections — Data structure library for MoonBit.
///
/// Provides two main data structures:
/// - `IndexMap`: A hash map that preserves insertion order
/// - `BitSet`/`BitMask`: Bit-level data structures for set operations and flags
///
/// # Quick Start
///
/// ```moonbit
/// // IndexMap — order-preserving key-value store
/// let map : @indexmap.IndexMap[String, Int] = @indexmap.new()
/// map.set("first", 1)
/// map.set("second", 2)
/// map.get_index(0) // Some(("first", 1)) — insertion order
///
/// // BitSet — efficient set of integers
/// let bits = @bitmask.BitSet::new(256)
/// bits.set(42)
/// bits.has(42) // true
/// ```
