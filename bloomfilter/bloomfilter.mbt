/// BloomFilter — a space-efficient probabilistic set data structure.
///
/// Can tell you "definitely not in set" or "possibly in set". No false negatives;
/// false positive rate is configurable via size and hash count.

struct BloomFilter {
  bits : Array[Byte]
  bit_count : Int
  hash_count : Int
}

fn hash_i(key_hash : Int, seed : Int) -> Int {
  let h = key_hash ^ (seed * 0x9E3779B9)
  h ^ (h >> 16)
}

/// Create a new BloomFilter.
///
/// Parameters:
/// - `expected_items`: approximate number of items you plan to insert
/// - `false_positive_rate`: desired false positive rate (e.g. 0.01 for 1%)
///
/// The filter is sized automatically based on these parameters.
pub fn BloomFilter::new(expected_items : Int, false_positive_rate : Double) -> BloomFilter {
  let bit_count = BloomFilter::optimal_bits(expected_items, false_positive_rate)
  let hash_count = BloomFilter::optimal_hashes(bit_count, expected_items)
  let byte_count = (bit_count + 7) / 8
  {
    bits: Array::makei(byte_count, fn(_) { b'\x00' }),
    bit_count: bit_count,
    hash_count: hash_count,
  }
}

/// Create a BloomFilter with explicit bit size and hash count.
pub fn BloomFilter::with_params(bit_count : Int, hash_count : Int) -> BloomFilter {
  let byte_count = (bit_count + 7) / 8
  {
    bits: Array::makei(byte_count, fn(_) { b'\x00' }),
    bit_count: bit_count,
    hash_count: hash_count,
  }
}

/// Compute optimal number of bits given expected items and false positive rate.
fn BloomFilter::optimal_bits(n : Int, p : Double) -> Int {
  if p <= 0.0 || n <= 0 {
    return 256
  }
  let m = (-n.to_double() * @math.ln(p)) / (@math.ln(2.0) * @math.ln(2.0))
  let result = m.to_int()
  if result < 64 { 64 } else { result }
}

/// Compute optimal number of hash functions.
fn BloomFilter::optimal_hashes(m : Int, n : Int) -> Int {
  let k = (m.to_double() / n.to_double()) * @math.ln(2.0)
  let result = k.to_int()
  if result < 1 { 1 } else if result > 16 { 16 } else { result }
}

/// Add an item to the filter. Accepts any hashable key.
pub fn[K : Hash] BloomFilter::add(self : BloomFilter, item : K) -> Unit {
  let h = item.hash()
  for i in 0..<self.hash_count {
    let idx = hash_i(h, i) % self.bit_count
    if idx < 0 {
      let idx = idx + self.bit_count
    }
    let byte_i = (idx) / 8
    let bit_off = (idx) % 8
    self.bits[byte_i] = self.bits[byte_i] | (b'\x01' << bit_off)
  }
}

/// Check if an item might be in the filter.
/// Returns `true` = "possibly in set", `false` = "definitely not in set".
pub fn[K : Hash] BloomFilter::contains(self : BloomFilter, item : K) -> Bool {
  let h = item.hash()
  for i in 0..<self.hash_count {
    let mut idx = hash_i(h, i) % self.bit_count
    if idx < 0 {
      idx = idx + self.bit_count
    }
    let byte_i = idx / 8
    let bit_off = idx % 8
    if ((self.bits[byte_i] >> bit_off) & b'\x01') == b'\x00' {
      return false
    }
  }
  true
}

/// Return the total number of bits in the filter.
pub fn BloomFilter::bit_count(self : BloomFilter) -> Int {
  self.bit_count
}

/// Return the number of hash functions used.
pub fn BloomFilter::hash_count(self : BloomFilter) -> Int {
  self.hash_count
}

/// Count the number of set bits.
pub fn BloomFilter::set_bits(self : BloomFilter) -> Int {
  let mut count = 0
  for i in 0..<self.bits.length() {
    count = count + self.bits[i].popcnt()
  }
  count
}

/// Estimate the current false positive rate based on the number of set bits.
pub fn BloomFilter::estimated_fpr(self : BloomFilter) -> Double {
  let set = self.set_bits().to_double()
  let total = self.bit_count.to_double()
  let proportion = set / total
  let k = self.hash_count.to_double()
  proportion.pow(k)
}

/// Clear all bits, resetting the filter to empty.
pub fn BloomFilter::clear(self : BloomFilter) -> Unit {
  for i in 0..<self.bits.length() {
    self.bits[i] = b'\x00'
  }
}

/// Implement `Show` for display.
pub impl Show for BloomFilter with fn output(self, logger) -> Unit {
  logger.write_string("BloomFilter(bits=")
  logger.write_string(self.bit_count.to_string())
  logger.write_string(", hashes=")
  logger.write_string(self.hash_count.to_string())
  logger.write_string(", set=")
  logger.write_string(self.set_bits().to_string())
  logger.write_string(")")
}
