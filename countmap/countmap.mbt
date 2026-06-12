/// CountMap — a frequency counter / multiset data structure.
///
/// Tracks counts of items, useful for word frequency, histogram building,
/// and voting/consensus algorithms.

struct CountMap[K] {
  mut inner : @hashmap.HashMap[K, Int]
}

/// Create a new, empty CountMap.
pub fn[K : Hash + Eq] CountMap::new() -> CountMap[K] {
  { inner: @hashmap.HashMap([], capacity=8) }
}

/// Increment the count for a key. Returns the new count.
pub fn[K : Hash + Eq] CountMap::increment(self : CountMap[K], key : K) -> Int {
  let count = self.inner.get_or_default(key, 0) + 1
  self.inner.set(key, count)
  count
}

/// Add `n` to the count for a key. Returns the new count.
pub fn[K : Hash + Eq] CountMap::add(self : CountMap[K], key : K, n : Int) -> Int {
  let count = self.inner.get_or_default(key, 0) + n
  self.inner.set(key, count)
  count
}

/// Decrement the count for a key. Returns the new count. Count will not go below 0.
pub fn[K : Hash + Eq] CountMap::decrement(self : CountMap[K], key : K) -> Int {
  let count = self.inner.get_or_default(key, 0)
  if count <= 1 {
    self.inner.remove(key)
    0
  } else {
    let new_count = count - 1
    self.inner.set(key, new_count)
    new_count
  }
}

/// Get the count for a key.
pub fn[K : Hash + Eq] CountMap::get(self : CountMap[K], key : K) -> Int {
  self.inner.get_or_default(key, 0)
}

/// Set the count for a key directly.
pub fn[K : Hash + Eq] CountMap::set(self : CountMap[K], key : K, count : Int) -> Unit {
  if count <= 0 {
    self.inner.remove(key)
  } else {
    self.inner.set(key, count)
  }
}

/// Remove a key entirely from the counter.
pub fn[K : Hash + Eq] CountMap::remove(self : CountMap[K], key : K) -> Unit {
  self.inner.remove(key)
}

/// Check if a key has been counted at least once.
pub fn[K : Hash + Eq] CountMap::contains(self : CountMap[K], key : K) -> Bool {
  self.inner.contains(key)
}

/// Return the number of distinct keys.
pub fn[K] CountMap::length(self : CountMap[K]) -> Int {
  self.inner.length()
}

/// Check if there are no keys.
pub fn[K] CountMap::is_empty(self : CountMap[K]) -> Bool {
  self.inner.is_empty()
}

/// Return the sum of all counts.
pub fn[K] CountMap::total(self : CountMap[K]) -> Int {
  let mut sum = 0
  for v in self.inner.values() {
    sum = sum + v
  }
  sum
}

/// Return an iterator over (key, count) pairs. Order is undefined.
pub fn[K] CountMap::iter(self : CountMap[K]) -> Iter[(K, Int)] {
  self.inner.iter()
}

/// Return the key with the highest count. If multiple tie, one is returned arbitrarily.
pub fn[K : Hash + Eq] CountMap::most_common(self : CountMap[K]) -> K? {
  let mut max_key = None
  let mut max_count = 0
  for kv in self.inner.iter() {
    if kv.1 > max_count {
      max_count = kv.1
      max_key = Some(kv.0)
    }
  }
  max_key
}

/// Return the top `n` most common keys with their counts. If there are fewer than
/// `n` distinct keys, all are returned. Results are sorted in descending count order.
pub fn[K : Hash + Eq] CountMap::most_common_n(self : CountMap[K], n : Int) -> Array[(K, Int)] {
  let pairs = []
  for kv in self.inner.iter() {
    pairs.push(kv)
  }
  let len = pairs.length()
  for i in 0..<len {
    for j in 0..<(len - 1 - i) {
      if pairs[j].1 < pairs[j + 1].1 {
        let temp = pairs[j]
        pairs[j] = pairs[j + 1]
        pairs[j + 1] = temp
      }
    }
  }
  let result = []
  let limit = if n < len { n } else { len }
  for i in 0..<limit {
    result.push(pairs[i])
  }
  result
}

/// Merge another CountMap into this one.
pub fn[K : Hash + Eq] CountMap::merge(self : CountMap[K], other : CountMap[K]) -> Unit {
  for kv in other.inner.iter() {
    let _ = self.add(kv.0, kv.1)
  }
}

/// Remove all entries.
pub fn[K : Hash + Eq] CountMap::clear(self : CountMap[K]) -> Unit {
  self.inner = @hashmap.HashMap([], capacity=8)
}

/// Create a CountMap from an array of items.
pub fn[K : Hash + Eq] CountMap::from_array(arr : Array[K]) -> CountMap[K] {
  let cm = CountMap::new()
  for i in 0..<arr.length() {
    let _ = cm.increment(arr[i])
  }
  cm
}

/// Implement `Show` for display.
pub impl[K] Show for CountMap[K] with fn output(self, logger) -> Unit {
  logger.write_string("CountMap(keys=")
  logger.write_string(self.length().to_string())
  logger.write_string(", total=")
  logger.write_string(self.total().to_string())
  logger.write_string(")")
}
