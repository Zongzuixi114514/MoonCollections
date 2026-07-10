///|
/// IndexMap — a hash map that preserves insertion order.
///
/// Combines the fast key lookups of a `HashMap` with the ordered iteration
/// of an `Array`. Keys are iterated in the order they were first inserted.
struct IndexMap[K, V] {
  mut map : @hashmap.HashMap[K, (Int, V)]
  mut keys : Array[K]
}

///|
/// Create a new, empty IndexMap.
pub fn[K : Hash + Eq, V] IndexMap::new() -> IndexMap[K, V] {
  { map: @hashmap.HashMap([], capacity=8), keys: [] }
}

///|
/// Insert or update a key-value pair. If the key already exists, only the value
/// is updated and the key keeps its original position.
pub fn[K : Hash + Eq, V] IndexMap::set(
  self : IndexMap[K, V],
  key : K,
  value : V,
) -> Unit {
  match self.map.get(key) {
    Some((idx, _)) => self.map.set(key, (idx, value))
    None => {
      let idx = self.keys.length()
      self.keys.push(key)
      self.map.set(key, (idx, value))
    }
  }
}

///|
/// Get the value associated with a key.
pub fn[K : Hash + Eq, V] IndexMap::get(self : IndexMap[K, V], key : K) -> V? {
  match self.map.get(key) {
    Some((_, v)) => Some(v)
    None => None
  }
}

///|
/// Get the key-value pair at the given position index.
pub fn[K : Hash + Eq, V] IndexMap::get_index(
  self : IndexMap[K, V],
  index : Int,
) -> (K, V)? {
  if 0 <= index && index < self.keys.length() {
    let key = self.keys[index]
    match self.map.get(key) {
      Some((_, v)) => Some((key, v))
      None => None
    }
  } else {
    None
  }
}

///|
/// Get the key at the given position index.
pub fn[K, V] IndexMap::get_key(self : IndexMap[K, V], index : Int) -> K? {
  if 0 <= index && index < self.keys.length() {
    Some(self.keys[index])
  } else {
    None
  }
}

///|
/// Get the value at the given position index.
pub fn[K : Hash + Eq, V] IndexMap::get_value(
  self : IndexMap[K, V],
  index : Int,
) -> V? {
  if 0 <= index && index < self.keys.length() {
    self.get(self.keys[index])
  } else {
    None
  }
}

///|
/// Check if the map contains the given key.
pub fn[K : Hash + Eq, V] IndexMap::contains(
  self : IndexMap[K, V],
  key : K,
) -> Bool {
  self.map.contains(key)
}

///|
/// Return the number of entries in the map.
pub fn[K, V] IndexMap::length(self : IndexMap[K, V]) -> Int {
  self.keys.length()
}

///|
/// Check if the map is empty.
pub fn[K, V] IndexMap::is_empty(self : IndexMap[K, V]) -> Bool {
  self.keys.length() == 0
}

///|
/// Remove a key-value pair by key. Returns the removed value, or None.
/// Remaining entries are shifted to fill the gap (O(n)).
pub fn[K : Hash + Eq, V] IndexMap::remove(self : IndexMap[K, V], key : K) -> V? {
  match self.map.get(key) {
    Some((idx, value)) => {
      self.map.remove(key)
      let last = self.keys.length() - 1
      if idx < last {
        for i in idx..<last {
          let next_key = self.keys[i + 1]
          self.keys[i] = next_key
          match self.map.get(next_key) {
            Some((_, v)) => self.map.set(next_key, (i, v))
            None => ()
          }
        }
      }
      let _ = self.keys.unsafe_pop()
      Some(value)
    }
    None => None
  }
}

///|
/// Remove the key-value pair at the given position index using swap-remove (O(1)).
/// The last element is moved into the removed position.
pub fn[K : Hash + Eq, V] IndexMap::swap_remove(
  self : IndexMap[K, V],
  index : Int,
) -> (K, V)? {
  if 0 <= index && index < self.keys.length() {
    let key = self.keys[index]
    let value = match self.map.get(key) {
      Some((_, v)) => v
      None => return None
    }
    self.map.remove(key)
    let last_idx = self.keys.length() - 1
    if index < last_idx {
      let last_key = self.keys[last_idx]
      self.keys[index] = last_key
      match self.map.get(last_key) {
        Some((_, v)) => self.map.set(last_key, (index, v))
        None => ()
      }
    }
    let _ = self.keys.unsafe_pop()
    Some((key, value))
  } else {
    None
  }
}

///|
/// Remove the key-value pair at the given position index, shifting all
/// subsequent entries to fill the gap (O(n)). Preserves order.
pub fn[K : Hash + Eq, V] IndexMap::shift_remove(
  self : IndexMap[K, V],
  index : Int,
) -> (K, V)? {
  if 0 <= index && index < self.keys.length() {
    let key = self.keys[index]
    let value = match self.map.get(key) {
      Some((_, v)) => v
      None => return None
    }
    self.map.remove(key)
    let last = self.keys.length() - 1
    if index < last {
      for i in index..<last {
        let next_key = self.keys[i + 1]
        self.keys[i] = next_key
        match self.map.get(next_key) {
          Some((_, v)) => self.map.set(next_key, (i, v))
          None => ()
        }
      }
    }
    let _ = self.keys.unsafe_pop()
    Some((key, value))
  } else {
    None
  }
}

///|
/// Return an iterator over key-value pairs in insertion order.
pub fn[K : Hash + Eq, V] IndexMap::iter(self : IndexMap[K, V]) -> Iter[(K, V)] {
  let mut i = 0
  let len = self.keys.length()
  Iter::new(fn() {
    while i < len {
      let key = self.keys[i]
      i = i + 1
      match self.map.get(key) {
        Some((_, v)) => return Some((key, v))
        None => ()
      }
    } nobreak {
      None
    }
  })
}

///|
/// Return an iterator over keys in insertion order.
pub fn[K, V] IndexMap::keys(self : IndexMap[K, V]) -> Iter[K] {
  let mut i = 0
  let len = self.keys.length()
  Iter::new(fn() {
    while i < len {
      let key = self.keys[i]
      i = i + 1
      return Some(key)
    } nobreak {
      None
    }
  })
}

///|
/// Return an iterator over values in insertion order.
pub fn[K : Hash + Eq, V] IndexMap::values(self : IndexMap[K, V]) -> Iter[V] {
  let mut i = 0
  let len = self.keys.length()
  Iter::new(fn() {
    while i < len {
      let key = self.keys[i]
      i = i + 1
      match self.map.get(key) {
        Some((_, v)) => return Some(v)
        None => ()
      }
    } nobreak {
      None
    }
  })
}

///|
/// Return the first key-value pair in insertion order, or None if empty.
pub fn[K : Hash + Eq, V] IndexMap::first(self : IndexMap[K, V]) -> (K, V)? {
  self.get_index(0)
}

///|
/// Return the last key-value pair in insertion order, or None if empty.
pub fn[K : Hash + Eq, V] IndexMap::last(self : IndexMap[K, V]) -> (K, V)? {
  let len = self.keys.length()
  if len == 0 {
    None
  } else {
    self.get_index(len - 1)
  }
}

///|
/// Remove all entries from the map.
pub fn[K : Hash + Eq, V] IndexMap::clear(self : IndexMap[K, V]) -> Unit {
  self.map = @hashmap.HashMap([], capacity=8)
  self.keys = []
}

///|
/// Create an IndexMap from an array of key-value pairs.
pub fn[K : Hash + Eq, V] IndexMap::from_array(
  arr : Array[(K, V)],
) -> IndexMap[K, V] {
  let m = IndexMap::new()
  for i in 0..<arr.length() {
    let (k, v) = arr[i]
    m.set(k, v)
  }
  m
}

///|
/// Remove all entries that do NOT satisfy the predicate.
/// Entries passing the predicate keep their relative order.
pub fn[K : Hash + Eq, V] IndexMap::retain(
  self : IndexMap[K, V],
  predicate : (K, V) -> Bool,
) -> Unit {
  let mut i = 0
  while i < self.keys.length() {
    let key = self.keys[i]
    match self.map.get(key) {
      Some((_, v)) =>
        if !predicate(key, v) {
          self.map.remove(key)
          let last = self.keys.length() - 1
          if i < last {
            for j in i..<last {
              let next_key = self.keys[j + 1]
              self.keys[j] = next_key
              match self.map.get(next_key) {
                Some((_, val)) => self.map.set(next_key, (j, val))
                None => ()
              }
            }
          }
          let _ = self.keys.unsafe_pop()
        } else {
          i = i + 1
        }
      None => self.keys.remove(i) |> ignore
    }
  }
}

///|
/// Return an iterator over key-value pairs in reverse insertion order.
pub fn[K : Hash + Eq, V] IndexMap::iter_rev(
  self : IndexMap[K, V],
) -> Iter[(K, V)] {
  let mut i = self.keys.length() - 1
  Iter::new(fn() {
    while i >= 0 {
      let key = self.keys[i]
      i = i - 1
      match self.map.get(key) {
        Some((_, v)) => return Some((key, v))
        None => ()
      }
    } nobreak {
      None
    }
  })
}

///|
/// Sort the entries by key using the given comparison function.
/// This changes the internal order permanently.
pub fn[K : Hash + Eq, V] IndexMap::sort_keys(
  self : IndexMap[K, V],
  compare : (K, K) -> Int,
) -> Unit {
  let len = self.keys.length()
  if len <= 1 {
    return
  }
  for i in 0..<(len - 1) {
    for j in 0..<(len - 1 - i) {
      if compare(self.keys[j], self.keys[j + 1]) > 0 {
        let temp = self.keys[j]
        self.keys[j] = self.keys[j + 1]
        self.keys[j + 1] = temp
        match self.map.get(self.keys[j]) {
          Some((_, v)) => self.map.set(self.keys[j], (j, v))
          None => ()
        }
        match self.map.get(self.keys[j + 1]) {
          Some((_, v)) => self.map.set(self.keys[j + 1], (j + 1, v))
          None => ()
        }
      }
    }
  }
}

///|
/// Remove and return the last key-value pair.
pub fn[K : Hash + Eq, V] IndexMap::pop(self : IndexMap[K, V]) -> (K, V)? {
  let len = self.keys.length()
  if len == 0 {
    None
  } else {
    let key = self.keys[len - 1]
    let value = match self.map.get(key) {
      Some((_, v)) => v
      None => return None
    }
    self.map.remove(key)
    let _ = self.keys.unsafe_pop()
    Some((key, value))
  }
}

///|
/// Convert the map to an array of key-value pairs in insertion order.
pub fn[K : Hash + Eq, V] IndexMap::to_array(
  self : IndexMap[K, V],
) -> Array[(K, V)] {
  let result = []
  for kv in self.iter() {
    result.push(kv)
  }
  result
}

///|
/// Get or insert a value. If the key exists, returns the existing value.
/// If not, calls `init` to create a new value, inserts it, and returns it.
pub fn[K : Hash + Eq, V] IndexMap::get_or_init(
  self : IndexMap[K, V],
  key : K,
  init : () -> V,
) -> V {
  match self.map.get(key) {
    Some((_, v)) => v
    None => {
      let v = init()
      self.set(key, v)
      v
    }
  }
}

///|
/// Implement `Show` for display.
pub impl[K, V] Show for IndexMap[K, V] with fn output(
  self : IndexMap[K, V],
  logger,
) -> Unit {
  logger.write_string("IndexMap(length=")
  logger.write_string(self.length().to_string())
  logger.write_string(")")
}

///|
/// Implement `Eq` for comparing two IndexMaps. Two maps are equal if they
/// have the same length and contain the same key-value pairs.
pub impl[K : Hash + Eq, V : Eq] Eq for IndexMap[K, V] with fn equal(
  self : IndexMap[K, V],
  other : IndexMap[K, V],
) -> Bool {
  guard self.length() == other.length() else { return false }
  for i in 0..<self.keys.length() {
    let k = self.keys[i]
    guard other.contains(k) else { return false }
    guard self.get(k) == other.get(k) else { return false }
  }
  true
}
