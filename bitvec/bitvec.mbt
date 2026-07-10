///|
/// BitVec — a dynamically growable bit vector.
///
/// Unlike BitSet which has a fixed size, BitVec grows automatically as bits
/// are set beyond its current capacity. Useful for sparse bit sets with
/// unknown upper bounds.
struct BitVec {
  data : Array[Byte]
  mut len : Int
}

///|
/// Create a new, empty BitVec.
pub fn BitVec::new() -> BitVec {
  { data: [], len: 0 }
}

///|
/// Create a BitVec with initial capacity for `n` bits.
pub fn BitVec::with_capacity(n : Int) -> BitVec {
  let byte_count = (n + 7) / 8
  { data: Array::makei(byte_count, fn(_) { b'\x00' }), len: 0 }
}

///|
/// Set the bit at `index` to 1. Grows automatically if needed.
pub fn BitVec::set(self : BitVec, index : Int) -> Unit {
  self.ensure_capacity(index)
  let byte_i = index / 8
  let bit_off = index % 8
  self.data[byte_i] = self.data[byte_i] | (b'\x01' << bit_off)
}

///|
/// Set the bit at `index` to 0.
pub fn BitVec::clear(self : BitVec, index : Int) -> Unit {
  if index / 8 < self.data.length() {
    let byte_i = index / 8
    let bit_off = index % 8
    self.data[byte_i] = self.data[byte_i] & (b'\x01' << bit_off).lnot()
  }
}

///|
/// Toggle the bit at `index`.
pub fn BitVec::toggle(self : BitVec, index : Int) -> Unit {
  self.ensure_capacity(index)
  let byte_i = index / 8
  let bit_off = index % 8
  self.data[byte_i] = self.data[byte_i] ^ (b'\x01' << bit_off)
}

///|
/// Check if the bit at `index` is set.
pub fn BitVec::has(self : BitVec, index : Int) -> Bool {
  let byte_i = index / 8
  guard byte_i < self.data.length() else { return false }
  let bit_off = index % 8
  ((self.data[byte_i] >> bit_off) & b'\x01') == b'\x01'
}

///|
/// Count the number of set bits.
pub fn BitVec::count(self : BitVec) -> Int {
  let mut total = 0
  for i in 0..<self.data.length() {
    total = total + self.data[i].popcnt()
  }
  total
}

///|
/// Check if no bits are set.
pub fn BitVec::is_empty(self : BitVec) -> Bool {
  for i in 0..<self.data.length() {
    if self.data[i] != b'\x00' {
      return false
    }
  }
  true
}

///|
/// Return the current bit capacity (not the number of set bits).
pub fn BitVec::capacity(self : BitVec) -> Int {
  self.data.length() * 8
}

///|
/// Return an iterator over the indices of all set bits.
pub fn BitVec::iter(self : BitVec) -> Iter[Int] {
  let mut byte_i = 0
  let mut bit_off = 0
  let byte_len = self.data.length()
  Iter::new(fn() {
    while byte_i < byte_len {
      while bit_off < 8 {
        let current_bit = byte_i * 8 + bit_off
        bit_off = bit_off + 1
        if (self.data[byte_i] & (b'\x01' << (bit_off - 1))) != b'\x00' {
          return Some(current_bit)
        }
      }
      byte_i = byte_i + 1
      bit_off = 0
    } nobreak {
      None
    }
  })
}

///|
/// Return all set bit indices as an array.
pub fn BitVec::to_array(self : BitVec) -> Array[Int] {
  let result = []
  for idx in self.iter() {
    result.push(idx)
  }
  result
}

///|
/// Remove all bits (O(1) — just clears length, not the underlying data).
pub fn BitVec::clear_all(self : BitVec) -> Unit {
  for i in 0..<self.data.length() {
    self.data[i] = b'\x00'
  }
}

///|
/// Return the highest set bit index, or None if empty.
pub fn BitVec::max_bit(self : BitVec) -> Int? {
  let mut i = self.data.length() - 1
  while i >= 0 {
    let byte = self.data[i]
    if byte != b'\x00' {
      let mut bit_off = 7
      while bit_off >= 0 {
        if ((byte >> bit_off) & b'\x01') == b'\x01' {
          return Some(i * 8 + bit_off)
        }
        bit_off = bit_off - 1
      }
    }
    i = i - 1
  }
  None
}

///|
fn BitVec::ensure_capacity(self : BitVec, index : Int) -> Unit {
  let needed = index / 8 + 1
  while self.data.length() < needed {
    self.data.push(b'\x00')
  }
}

///|
/// Implement `Show` for display.
pub impl Show for BitVec with fn output(self, logger) -> Unit {
  logger.write_string("BitVec(cap=")
  logger.write_string(self.capacity().to_string())
  logger.write_string(", count=")
  logger.write_string(self.count().to_string())
  logger.write_string(")")
}
