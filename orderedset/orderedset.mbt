/// OrderedSet — a set that preserves insertion order.
///
/// Built on top of `IndexMap`, it combines fast `HashMap` lookups with
/// ordered iteration. Elements are iterated in the order they were first
/// inserted.

struct OrderedSet[K] {
  inner : @indexmap.IndexMap[K, Unit]
}

/// Create a new, empty OrderedSet.
pub fn[K : Hash + Eq] OrderedSet::new() -> OrderedSet[K] {
  { inner: @indexmap.IndexMap::new() }
}

/// Insert an element. Returns `true` if the element was newly inserted,
/// `false` if it already existed.
pub fn[K : Hash + Eq] OrderedSet::add(self : OrderedSet[K], value : K) -> Bool {
  if self.inner.contains(value) {
    false
  } else {
    self.inner.set(value, ())
    true
  }
}

/// Remove an element. Returns `true` if the element was present.
pub fn[K : Hash + Eq] OrderedSet::remove(self : OrderedSet[K], value : K) -> Bool {
  match self.inner.remove(value) {
    Some(_) => true
    None => false
  }
}

/// Check if the set contains the given value.
pub fn[K : Hash + Eq] OrderedSet::contains(self : OrderedSet[K], value : K) -> Bool {
  self.inner.contains(value)
}

/// Return the number of elements in the set.
pub fn[K] OrderedSet::length(self : OrderedSet[K]) -> Int {
  self.inner.length()
}

/// Check if the set is empty.
pub fn[K] OrderedSet::is_empty(self : OrderedSet[K]) -> Bool {
  self.inner.is_empty()
}

/// Get the element at the given position index.
pub fn[K : Hash + Eq] OrderedSet::get_index(self : OrderedSet[K], index : Int) -> K? {
  match self.inner.get_index(index) {
    Some((k, _)) => Some(k)
    None => None
  }
}

/// Return the first element in insertion order.
pub fn[K : Hash + Eq] OrderedSet::first(self : OrderedSet[K]) -> K? {
  match self.inner.first() {
    Some((k, _)) => Some(k)
    None => None
  }
}

/// Return the last element in insertion order.
pub fn[K : Hash + Eq] OrderedSet::last(self : OrderedSet[K]) -> K? {
  match self.inner.last() {
    Some((k, _)) => Some(k)
    None => None
  }
}

/// Remove all elements from the set.
pub fn[K : Hash + Eq] OrderedSet::clear(self : OrderedSet[K]) -> Unit {
  self.inner.clear()
}

/// Return an iterator over elements in insertion order.
pub fn[K : Hash + Eq] OrderedSet::iter(self : OrderedSet[K]) -> Iter[K] {
  self.inner.keys()
}

/// Create an OrderedSet from an array, preserving input order.
pub fn[K : Hash + Eq] OrderedSet::from_array(arr : Array[K]) -> OrderedSet[K] {
  let set = OrderedSet::new()
  for i in 0..<arr.length() {
    set.add(arr[i]) |> ignore
  }
  set
}

/// Return a new OrderedSet that is the union of `self` and `other`.
/// Elements retain the order of `self` followed by new elements from `other`.
pub fn[K : Hash + Eq] OrderedSet::union(self : OrderedSet[K], other : OrderedSet[K]) -> OrderedSet[K] {
  let result = OrderedSet::new()
  for k in self.iter() {
    result.add(k) |> ignore
  }
  for k in other.iter() {
    result.add(k) |> ignore
  }
  result
}

/// Return a new OrderedSet that is the intersection of `self` and `other`.
/// Elements retain the order of `self`.
pub fn[K : Hash + Eq] OrderedSet::intersection(
  self : OrderedSet[K],
  other : OrderedSet[K],
) -> OrderedSet[K] {
  let result = OrderedSet::new()
  for k in self.iter() {
    if other.contains(k) {
      result.add(k) |> ignore
    }
  }
  result
}

/// Return a new OrderedSet that is the difference (`self` \ `other`).
pub fn[K : Hash + Eq] OrderedSet::difference(
  self : OrderedSet[K],
  other : OrderedSet[K],
) -> OrderedSet[K] {
  let result = OrderedSet::new()
  for k in self.iter() {
    if not(other.contains(k)) {
      result.add(k) |> ignore
    }
  }
  result
}

/// Return a new OrderedSet that is the symmetric difference of `self` and `other`.
pub fn[K : Hash + Eq] OrderedSet::symmetric_difference(
  self : OrderedSet[K],
  other : OrderedSet[K],
) -> OrderedSet[K] {
  let result = OrderedSet::new()
  for k in self.iter() {
    if not(other.contains(k)) {
      result.add(k) |> ignore
    }
  }
  for k in other.iter() {
    if not(self.contains(k)) {
      result.add(k) |> ignore
    }
  }
  result
}

/// Check if `self` is a subset of `other`.
pub fn[K : Hash + Eq] OrderedSet::is_subset(
  self : OrderedSet[K],
  other : OrderedSet[K],
) -> Bool {
  for k in self.iter() {
    if not(other.contains(k)) {
      return false
    }
  }
  true
}

/// Check if `self` is a superset of `other`.
pub fn[K : Hash + Eq] OrderedSet::is_superset(
  self : OrderedSet[K],
  other : OrderedSet[K],
) -> Bool {
  other.is_subset(self)
}

/// Insert or replace an element at a specific index. Shifts subsequent elements.
pub fn[K : Hash + Eq] OrderedSet::insert_at(
  self : OrderedSet[K],
  index : Int,
  value : K,
) -> Bool {
  if self.inner.contains(value) {
    false
  } else {
    let pairs : Array[(K, Unit)] = []
    for kv in self.inner.iter() {
      pairs.push((kv.0, ()))
    }
    let new_pairs : Array[(K, Unit)] = []
    for i in 0..<index {
      new_pairs.push(pairs[i])
    }
    new_pairs.push((value, ()))
    for i in index..<pairs.length() {
      let item = pairs[i]
      if item.0 != value {
        new_pairs.push(item)
      }
    }
    self.inner.clear()
    for i in 0..<new_pairs.length() {
      let (k, _) = new_pairs[i]
      self.inner.set(k, ())
    }
    true
  }
}

/// Implement `Eq` for comparing two OrderedSets.
pub impl[K : Hash + Eq] Eq for OrderedSet[K] with fn equal(
  self : OrderedSet[K],
  other : OrderedSet[K],
) -> Bool {
  guard self.length() == other.length() else { return false }
  for k in self.iter() {
    guard other.contains(k) else { return false }
  }
  true
}

/// Implement `Show` for display.
pub impl[K] Show for OrderedSet[K] with fn output(self, logger) -> Unit {
  logger.write_string("OrderedSet(length=")
  logger.write_string(self.length().to_string())
  logger.write_string(")")
}
