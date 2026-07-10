///|
/// SparseSet — a space-efficient integer set with dense iteration and O(1) clear.
///
/// Stores integers in a dense array for fast iteration, with a sparse array
/// for O(1) membership checks. Ideal for integer-heavy workloads where
/// iteration performance matters.
struct SparseSet {
  sparse : Array[Int]
  dense : Array[Int]
  mut count : Int
  max_val : Int
}

///|
/// Create a new SparseSet for integers in range [0, max_val).
pub fn SparseSet::new(max_val : Int) -> SparseSet {
  let n = max_val + 1
  {
    sparse: Array::makei(n, fn(_) { -1 }),
    dense: Array::makei(max_val, fn(_) { 0 }),
    count: 0,
    max_val,
  }
}

///|
/// Insert a value into the set. Returns `true` if newly inserted.
pub fn SparseSet::insert(self : SparseSet, val : Int) -> Bool {
  guard 0 <= val && val <= self.max_val else { return false }
  let idx = self.sparse[val]
  guard idx == -1 || idx >= self.count else { return false }
  self.dense[self.count] = val
  self.sparse[val] = self.count
  self.count = self.count + 1
  true
}

///|
/// Remove a value from the set. Returns `true` if it was present.
pub fn SparseSet::remove(self : SparseSet, val : Int) -> Bool {
  guard 0 <= val && val <= self.max_val else { return false }
  let idx = self.sparse[val]
  guard idx != -1 && idx < self.count else { return false }
  let last_idx = self.count - 1
  let last_val = self.dense[last_idx]
  self.dense[idx] = last_val
  self.sparse[last_val] = idx
  self.sparse[val] = -1
  self.count = self.count - 1
  true
}

///|
/// Check if a value is in the set.
pub fn SparseSet::contains(self : SparseSet, val : Int) -> Bool {
  guard 0 <= val && val <= self.max_val else { return false }
  let idx = self.sparse[val]
  idx != -1 && idx < self.count
}

///|
/// Return the number of elements.
pub fn SparseSet::length(self : SparseSet) -> Int {
  self.count
}

///|
/// Check if the set is empty.
pub fn SparseSet::is_empty(self : SparseSet) -> Bool {
  self.count == 0
}

///|
/// Remove all elements (O(1)).
pub fn SparseSet::clear(self : SparseSet) -> Unit {
  self.count = 0
}

///|
/// Return an iterator over all elements in insertion order.
pub fn SparseSet::iter(self : SparseSet) -> Iter[Int] {
  let mut i = 0
  let total = self.count
  Iter::new(fn() {
    while i < total {
      let v = self.dense[i]
      i = i + 1
      let idx = self.sparse[v]
      if idx != -1 && idx < total {
        return Some(v)
      }
    } nobreak {
      None
    }
  })
}

///|
/// Return all elements as an array.
pub fn SparseSet::to_array(self : SparseSet) -> Array[Int] {
  let result = []
  for v in self.iter() {
    result.push(v)
  }
  result
}

///|
/// Implement `Show` for display.
pub impl Show for SparseSet with fn output(self, logger) -> Unit {
  logger.write_string("SparseSet(count=")
  logger.write_string(self.count.to_string())
  logger.write_string(")")
}
