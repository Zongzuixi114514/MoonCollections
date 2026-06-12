/// BitSet — a fixed-size bit-level data structure for set operations.

/// A fixed-size set of bits, useful for integer set operations, flags, and permissions.
///
/// Internally stores bits in an `Array[Byte]` where each byte holds 8 bits.
/// Bits are indexed from 0.
struct BitSet {
  data : Array[Byte]
  len : Int
}

fn byte_index(index : Int) -> Int {
  index / 8
}

fn bit_offset(index : Int) -> Int {
  index % 8
}

/// Create a new BitSet with the given number of bits (all initially 0).
pub fn BitSet::new(size : Int) -> BitSet {
  let byte_count = (size + 7) / 8
  { data: Array::makei(byte_count, fn(_) { b'\x00' }), len: size }
}

/// Set the bit at `index` to 1.
pub fn BitSet::set(self : BitSet, index : Int) -> Unit {
  if 0 <= index && index < self.len {
    let byte_i = byte_index(index)
    let bit_off = bit_offset(index)
    self.data[byte_i] = self.data[byte_i] | (b'\x01' << bit_off)
  }
}

/// Set the bit at `index` to 0.
pub fn BitSet::clear(self : BitSet, index : Int) -> Unit {
  if 0 <= index && index < self.len {
    let byte_i = byte_index(index)
    let bit_off = bit_offset(index)
    self.data[byte_i] = self.data[byte_i] & (b'\x01' << bit_off).lnot()
  }
}

/// Toggle the bit at `index` (0 to 1, 1 to 0).
pub fn BitSet::toggle(self : BitSet, index : Int) -> Unit {
  if 0 <= index && index < self.len {
    let byte_i = byte_index(index)
    let bit_off = bit_offset(index)
    self.data[byte_i] = self.data[byte_i] ^ (b'\x01' << bit_off)
  }
}

/// Check if the bit at `index` is set.
pub fn BitSet::has(self : BitSet, index : Int) -> Bool {
  if 0 <= index && index < self.len {
    let byte_i = byte_index(index)
    let bit_off = bit_offset(index)
    ((self.data[byte_i] >> bit_off) & b'\x01') == b'\x01'
  } else {
    false
  }
}

/// Count the number of set bits. Uses hardware popcount on each byte.
pub fn BitSet::count(self : BitSet) -> Int {
  let mut total = 0
  for i in 0..<self.data.length() {
    total = total + self.data[i].popcnt()
  }
  total
}

/// Check if no bits are set.
pub fn BitSet::is_empty(self : BitSet) -> Bool {
  for i in 0..<self.data.length() {
    if self.data[i] != b'\x00' {
      return false
    }
  }
  true
}

/// Get the total number of bits in this BitSet.
pub fn BitSet::length(self : BitSet) -> Int {
  self.len
}

/// Set all bits to 1.
pub fn BitSet::fill(self : BitSet) -> Unit {
  for i in 0..<self.data.length() {
    self.data[i] = b'\xFF'
  }
}

/// Set all bits to 0.
pub fn BitSet::clear_all(self : BitSet) -> Unit {
  for i in 0..<self.data.length() {
    self.data[i] = b'\x00'
  }
}

/// Return a new BitSet that is the union of `self` and `other`.
pub fn BitSet::union(self : BitSet, other : BitSet) -> BitSet {
  let max_len = if self.len > other.len { self.len } else { other.len }
  let result = BitSet::new(max_len)
  let min_byte = if self.data.length() < other.data.length() {
    self.data.length()
  } else {
    other.data.length()
  }
  for i in 0..<min_byte {
    result.data[i] = self.data[i] | other.data[i]
  }
  for i in min_byte..<self.data.length() {
    result.data[i] = self.data[i]
  }
  for i in min_byte..<other.data.length() {
    result.data[i] = other.data[i]
  }
  result
}

/// Return a new BitSet that is the intersection of `self` and `other`.
pub fn BitSet::intersect(self : BitSet, other : BitSet) -> BitSet {
  let min_len = if self.len < other.len { self.len } else { other.len }
  let min_byte = if self.data.length() < other.data.length() {
    self.data.length()
  } else {
    other.data.length()
  }
  let result = BitSet::new(min_len)
  for i in 0..<min_byte {
    result.data[i] = self.data[i] & other.data[i]
  }
  result
}

/// Return a new BitSet that is the difference (self \ other).
pub fn BitSet::difference(self : BitSet, other : BitSet) -> BitSet {
  let result = BitSet::new(self.len)
  let min_byte = if self.data.length() < other.data.length() {
    self.data.length()
  } else {
    other.data.length()
  }
  for i in 0..<min_byte {
    result.data[i] = self.data[i] & other.data[i].lnot()
  }
  for i in min_byte..<self.data.length() {
    result.data[i] = self.data[i]
  }
  result
}

/// Return a new BitSet that is the symmetric difference of `self` and `other`.
pub fn BitSet::symmetric_difference(self : BitSet, other : BitSet) -> BitSet {
  let max_len = if self.len > other.len { self.len } else { other.len }
  let result = BitSet::new(max_len)
  let min_byte = if self.data.length() < other.data.length() {
    self.data.length()
  } else {
    other.data.length()
  }
  for i in 0..<min_byte {
    result.data[i] = self.data[i] ^ other.data[i]
  }
  for i in min_byte..<self.data.length() {
    result.data[i] = self.data[i]
  }
  for i in min_byte..<other.data.length() {
    result.data[i] = other.data[i]
  }
  result
}

/// Check if `self` is a subset of `other` (all bits set in self are also set in other).
pub fn BitSet::is_subset(self : BitSet, other : BitSet) -> Bool {
  let min_byte = if self.data.length() < other.data.length() {
    self.data.length()
  } else {
    other.data.length()
  }
  for i in 0..<min_byte {
    if (self.data[i] & other.data[i].lnot()) != b'\x00' {
      return false
    }
  }
  for i in min_byte..<self.data.length() {
    if self.data[i] != b'\x00' {
      return false
    }
  }
  true
}

/// Check if `self` is a superset of `other` (all bits set in other are also set in self).
pub fn BitSet::is_superset(self : BitSet, other : BitSet) -> Bool {
  other.is_subset(self)
}

/// Check if `self` and `other` have no bits in common.
pub fn BitSet::is_disjoint(self : BitSet, other : BitSet) -> Bool {
  let min_byte = if self.data.length() < other.data.length() {
    self.data.length()
  } else {
    other.data.length()
  }
  for i in 0..<min_byte {
    if (self.data[i] & other.data[i]) != b'\x00' {
      return false
    }
  }
  true
}

/// Check if at least one bit is set.
pub fn BitSet::any(self : BitSet) -> Bool {
  not(self.is_empty())
}

/// Check if all bits are set.
pub fn BitSet::all(self : BitSet) -> Bool {
  self.count() == self.len
}

/// Count the number of unset bits.
pub fn BitSet::count_zeros(self : BitSet) -> Int {
  self.len - self.count()
}

/// Resize the BitSet. If growing, new bits are set to 0.
/// If shrinking, bits beyond the new size are dropped.
pub fn BitSet::resize(self : BitSet, new_size : Int) -> BitSet {
  let result = BitSet::new(new_size)
  let min_byte = if self.data.length() < result.data.length() {
    self.data.length()
  } else {
    result.data.length()
  }
  for i in 0..<min_byte {
    result.data[i] = self.data[i]
  }
  result
}

/// Return a new BitSet with all bits flipped (complement).
pub fn BitSet::complement(self : BitSet) -> BitSet {
  let result = BitSet::new(self.len)
  for i in 0..<self.data.length() {
    result.data[i] = self.data[i].lnot()
  }
  result
}

/// Create a BitSet from an array of indices. Each index in the array sets
/// that bit to 1.
pub fn BitSet::from_indices(indices : Array[Int], size : Int) -> BitSet {
  let bits = BitSet::new(size)
  for i in 0..<indices.length() {
    bits.set(indices[i])
  }
  bits
}

/// Return an array of all set bit indices.
pub fn BitSet::to_array(self : BitSet) -> Array[Int] {
  let result = []
  for idx in self.iter() {
    result.push(idx)
  }
  result
}

/// Return an iterator over the indices of all set bits, in ascending order.
pub fn BitSet::iter(self : BitSet) -> Iter[Int] {
  let mut byte_i = 0
  let mut bit_off = 0
  Iter::new(
    fn() {
      while byte_i < self.data.length() {
        while bit_off < 8 {
          let current_bit = byte_i * 8 + bit_off
          bit_off = bit_off + 1
          if current_bit < self.len && ((self.data[byte_i] >> (bit_off - 1)) & b'\x01') != b'\x00' {
            return Some(current_bit)
          }
        }
        byte_i = byte_i + 1
        bit_off = 0
      } nobreak {
        None
      }
    },
  )
}

/// Implement `Show` for display.
pub impl Show for BitSet with fn output(self, logger) -> Unit {
  logger.write_string("BitSet::new(")
  logger.write_string(self.len.to_string())
  logger.write_string(")")
}

/// Implement `Eq` for comparing two BitSets. Two BitSets are equal if they
/// have the same length and all bits match.
pub impl Eq for BitSet with fn equal(self : BitSet, other : BitSet) -> Bool {
  guard self.len == other.len else { return false }
  for i in 0..<self.data.length() {
    guard self.data[i] == other.data[i] else { return false }
  }
  true
}
