///|
/// Tests for LRUCache module.
test "new cache" {
  let cache : @lrucache.LRUCache[String, Int] = @lrucache.LRUCache::new(3)
  assert_eq(cache.length(), 0)
  assert_eq(cache.capacity(), 3)
}

///|
test "put and get" {
  let cache : @lrucache.LRUCache[String, Int] = @lrucache.LRUCache::new(3)
  cache.put("a", 1)
  cache.put("b", 2)
  assert_eq(cache.get("a"), Some(1))
  assert_eq(cache.get("b"), Some(2))
  assert_eq(cache.get("c"), None)
}

///|
test "evict lru" {
  let cache : @lrucache.LRUCache[String, Int] = @lrucache.LRUCache::new(2)
  cache.put("a", 1)
  cache.put("b", 2)
  cache.put("c", 3)
  assert_eq(cache.get("a"), None)
  assert_eq(cache.get("b"), Some(2))
  assert_eq(cache.get("c"), Some(3))
}

///|
test "get updates lru order" {
  let cache : @lrucache.LRUCache[String, Int] = @lrucache.LRUCache::new(2)
  cache.put("a", 1)
  cache.put("b", 2)
  let _ = cache.get("a")
  cache.put("c", 3)
  assert_eq(cache.get("a"), Some(1))
  assert_eq(cache.get("b"), None)
  assert_eq(cache.get("c"), Some(3))
}

///|
test "put updates existing" {
  let cache : @lrucache.LRUCache[String, Int] = @lrucache.LRUCache::new(3)
  cache.put("a", 1)
  cache.put("a", 100)
  assert_eq(cache.get("a"), Some(100))
  assert_eq(cache.length(), 1)
}

///|
test "put existing updates lru order" {
  let cache : @lrucache.LRUCache[String, Int] = @lrucache.LRUCache::new(2)
  cache.put("a", 1)
  cache.put("b", 2)
  cache.put("a", 10)
  cache.put("c", 3)
  assert_eq(cache.get("b"), None)
  assert_eq(cache.get("a"), Some(10))
  assert_eq(cache.get("c"), Some(3))
}

///|
test "peek does not update order" {
  let cache : @lrucache.LRUCache[String, Int] = @lrucache.LRUCache::new(2)
  cache.put("a", 1)
  cache.put("b", 2)
  let _ = cache.peek("a")
  cache.put("c", 3)
  assert_eq(cache.get("a"), None)
  assert_eq(cache.get("b"), Some(2))
  assert_eq(cache.get("c"), Some(3))
}

///|
test "remove" {
  let cache : @lrucache.LRUCache[String, Int] = @lrucache.LRUCache::new(3)
  cache.put("a", 1)
  cache.put("b", 2)
  assert_eq(cache.remove("a"), Some(1))
  assert_eq(cache.length(), 1)
  assert_eq(cache.get("a"), None)
}

///|
test "contains" {
  let cache : @lrucache.LRUCache[String, Int] = @lrucache.LRUCache::new(3)
  cache.put("key", 42)
  assert_true(cache.contains("key"))
  assert_false(cache.contains("missing"))
}

///|
test "clear" {
  let cache : @lrucache.LRUCache[String, Int] = @lrucache.LRUCache::new(3)
  cache.put("a", 1)
  cache.put("b", 2)
  cache.clear()
  assert_eq(cache.length(), 0)
  assert_true(cache.is_empty())
}

///|
test "lru and mru" {
  let cache : @lrucache.LRUCache[String, Int] = @lrucache.LRUCache::new(3)
  cache.put("a", 1)
  cache.put("b", 2)
  cache.put("c", 3)
  assert_eq(cache.lru(), Some(("a", 1)))
  assert_eq(cache.mru(), Some(("c", 3)))
}

///|
test "lru after get" {
  let cache : @lrucache.LRUCache[String, Int] = @lrucache.LRUCache::new(3)
  cache.put("a", 1)
  cache.put("b", 2)
  cache.put("c", 3)
  let _ = cache.get("a")
  assert_eq(cache.lru(), Some(("b", 2)))
  assert_eq(cache.mru(), Some(("a", 1)))
}

///|
test "set capacity shrink" {
  let cache : @lrucache.LRUCache[String, Int] = @lrucache.LRUCache::new(5)
  cache.put("a", 1)
  cache.put("b", 2)
  cache.put("c", 3)
  cache.put("d", 4)
  cache.put("e", 5)
  cache.set_capacity(2)
  assert_eq(cache.length(), 2)
  assert_eq(cache.get("a"), None)
  assert_eq(cache.get("b"), None)
  assert_eq(cache.get("c"), None)
  assert_eq(cache.get("d"), Some(4))
  assert_eq(cache.get("e"), Some(5))
}

///|
test "iter order lru to mru" {
  let cache : @lrucache.LRUCache[String, Int] = @lrucache.LRUCache::new(3)
  cache.put("a", 1)
  cache.put("b", 2)
  cache.put("c", 3)
  let keys = []
  for kv in cache.iter() {
    keys.push(kv.0)
  }
  assert_eq(keys[0], "a")
  assert_eq(keys[1], "b")
  assert_eq(keys[2], "c")
}

///|
test "capacity 1" {
  let cache : @lrucache.LRUCache[String, Int] = @lrucache.LRUCache::new(1)
  cache.put("a", 1)
  cache.put("b", 2)
  assert_eq(cache.length(), 1)
  assert_eq(cache.get("a"), None)
  assert_eq(cache.get("b"), Some(2))
}
