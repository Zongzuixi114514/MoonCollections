///|
/// LRU Cache — a Least Recently Used cache built on IndexMap.
///
/// When the cache reaches capacity, the least recently used entry is evicted.
/// Accessing an entry (get) marks it as recently used.
/// Inserting an entry (put) also marks it as recently used.
struct LRUCache[K, V] {
  inner : @indexmap.IndexMap[K, V]
  mut capacity : Int
}

///|
/// Create a new LRU Cache with the given capacity.
pub fn[K : Hash + Eq, V] LRUCache::new(capacity : Int) -> LRUCache[K, V] {
  { inner: @indexmap.IndexMap::new(), capacity }
}

///|
/// Get a value by key. Marks it as recently used.
pub fn[K : Hash + Eq, V] LRUCache::get(self : LRUCache[K, V], key : K) -> V? {
  match self.inner.remove(key) {
    Some(v) => {
      self.inner.set(key, v)
      Some(v)
    }
    None => None
  }
}

///|
/// Peek at a value without updating its access order.
pub fn[K : Hash + Eq, V] LRUCache::peek(self : LRUCache[K, V], key : K) -> V? {
  self.inner.get(key)
}

///|
/// Insert a key-value pair. If the key already exists, updates the value and
/// marks it as recently used. If at capacity, evicts the least recently used entry.
pub fn[K : Hash + Eq, V] LRUCache::put(
  self : LRUCache[K, V],
  key : K,
  value : V,
) -> Unit {
  if self.inner.contains(key) {
    let _ = self.inner.remove(key)
    self.inner.set(key, value)
  } else {
    if self.inner.length() >= self.capacity {
      match self.inner.first() {
        Some((k, _)) => {
          let _ = self.inner.remove(k)
        }
        None => ()
      }
    }
    self.inner.set(key, value)
  }
}

///|
/// Remove a key from the cache.
pub fn[K : Hash + Eq, V] LRUCache::remove(self : LRUCache[K, V], key : K) -> V? {
  self.inner.remove(key)
}

///|
/// Check if the cache contains a key.
pub fn[K : Hash + Eq, V] LRUCache::contains(
  self : LRUCache[K, V],
  key : K,
) -> Bool {
  self.inner.contains(key)
}

///|
/// Return the number of entries in the cache.
pub fn[K, V] LRUCache::length(self : LRUCache[K, V]) -> Int {
  self.inner.length()
}

///|
/// Check if the cache is empty.
pub fn[K, V] LRUCache::is_empty(self : LRUCache[K, V]) -> Bool {
  self.inner.is_empty()
}

///|
/// Return the capacity of the cache.
pub fn[K, V] LRUCache::capacity(self : LRUCache[K, V]) -> Int {
  self.capacity
}

///|
/// Remove all entries from the cache.
pub fn[K : Hash + Eq, V] LRUCache::clear(self : LRUCache[K, V]) -> Unit {
  self.inner.clear()
}

///|
/// Return an iterator over key-value pairs in order from least recently used
/// to most recently used.
pub fn[K : Hash + Eq, V] LRUCache::iter(self : LRUCache[K, V]) -> Iter[(K, V)] {
  self.inner.iter()
}

///|
/// Return the least recently used entry.
pub fn[K : Hash + Eq, V] LRUCache::lru(self : LRUCache[K, V]) -> (K, V)? {
  self.inner.first()
}

///|
/// Return the most recently used entry.
pub fn[K : Hash + Eq, V] LRUCache::mru(self : LRUCache[K, V]) -> (K, V)? {
  self.inner.last()
}

///|
/// Change the capacity. If the new capacity is smaller, least recently used
/// entries are evicted to fit.
pub fn[K : Hash + Eq, V] LRUCache::set_capacity(
  self : LRUCache[K, V],
  new_capacity : Int,
) -> Unit {
  self.capacity = new_capacity
  while self.inner.length() > self.capacity {
    match self.inner.first() {
      Some((k, _)) => {
        let _ = self.inner.remove(k)
      }
      None => break
    }
  }
}

///|
/// Implement `Show` for display.
pub impl[K, V] Show for LRUCache[K, V] with fn output(self, logger) -> Unit {
  logger.write_string("LRUCache(len=")
  logger.write_string(self.length().to_string())
  logger.write_string(", capacity=")
  logger.write_string(self.capacity.to_string())
  logger.write_string(")")
}
