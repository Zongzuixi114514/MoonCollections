///|
/// Tests for IndexMap module.
test "new map is empty" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  assert_true(m.is_empty())
  assert_eq(m.length(), 0)
}

///|
test "set and get" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("one", 1)
  m.set("two", 2)
  m.set("three", 3)
  assert_eq(m.get("one"), Some(1))
  assert_eq(m.get("two"), Some(2))
  assert_eq(m.get("three"), Some(3))
  assert_eq(m.get("four"), None)
}

///|
test "update existing key" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("key", 1)
  m.set("key", 100)
  assert_eq(m.get("key"), Some(100))
  assert_eq(m.length(), 1)
}

///|
test "length" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  assert_eq(m.length(), 0)
  m.set("a", 1)
  assert_eq(m.length(), 1)
  m.set("b", 2)
  assert_eq(m.length(), 2)
  m.set("a", 10)
  assert_eq(m.length(), 2)
}

///|
test "contains" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("key", 42)
  assert_true(m.contains("key"))
  assert_false(m.contains("missing"))
}

///|
test "get index" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("first", 1)
  m.set("second", 2)
  m.set("third", 3)
  assert_eq(m.get_index(0), Some(("first", 1)))
  assert_eq(m.get_index(1), Some(("second", 2)))
  assert_eq(m.get_index(2), Some(("third", 3)))
}

///|
test "get index out of bounds" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("key", 1)
  assert_eq(m.get_index(1), None)
  assert_eq(m.get_index(-1), None)
}

///|
test "get key by index" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("a", 1)
  m.set("b", 2)
  assert_eq(m.get_key(0), Some("a"))
  assert_eq(m.get_key(1), Some("b"))
  assert_eq(m.get_key(2), None)
}

///|
test "get value by index" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("x", 10)
  m.set("y", 20)
  assert_eq(m.get_value(0), Some(10))
  assert_eq(m.get_value(1), Some(20))
  assert_eq(m.get_value(5), None)
}

///|
test "insertion order preserved" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("z", 3)
  m.set("a", 1)
  m.set("m", 2)
  let keys = []
  for k in m.keys() {
    keys.push(k)
  }
  assert_eq(keys[0], "z")
  assert_eq(keys[1], "a")
  assert_eq(keys[2], "m")
}

///|
test "update preserves position" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("first", 1)
  m.set("second", 2)
  m.set("first", 100)
  assert_eq(m.get_index(0), Some(("first", 100)))
  assert_eq(m.get_index(1), Some(("second", 2)))
}

///|
test "remove by key" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("a", 1)
  m.set("b", 2)
  m.set("c", 3)
  let removed = m.remove("b")
  assert_eq(removed, Some(2))
  assert_eq(m.length(), 2)
  assert_false(m.contains("b"))
}

///|
test "remove preserves order" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("a", 1)
  m.set("b", 2)
  m.set("c", 3)
  let _ = m.remove("b")
  assert_eq(m.get_index(0), Some(("a", 1)))
  assert_eq(m.get_index(1), Some(("c", 3)))
}

///|
test "remove non-existent" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("a", 1)
  assert_eq(m.remove("b"), None)
  assert_eq(m.length(), 1)
}

///|
test "swap remove" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("a", 1)
  m.set("b", 2)
  m.set("c", 3)
  let removed = m.swap_remove(0)
  assert_eq(removed, Some(("a", 1)))
  assert_eq(m.length(), 2)
}

///|
test "shift remove preserves order" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("one", 1)
  m.set("two", 2)
  m.set("three", 3)
  m.set("four", 4)
  let removed = m.shift_remove(1)
  assert_eq(removed, Some(("two", 2)))
  assert_eq(m.length(), 3)
  assert_eq(m.get_index(0), Some(("one", 1)))
  assert_eq(m.get_index(1), Some(("three", 3)))
  assert_eq(m.get_index(2), Some(("four", 4)))
}

///|
test "first and last" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  assert_eq(m.first(), None)
  assert_eq(m.last(), None)
  m.set("first", 1)
  m.set("last", 2)
  assert_eq(m.first(), Some(("first", 1)))
  assert_eq(m.last(), Some(("last", 2)))
}

///|
test "first and last single element" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("only", 42)
  assert_eq(m.first(), Some(("only", 42)))
  assert_eq(m.last(), Some(("only", 42)))
}

///|
test "clear" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("a", 1)
  m.set("b", 2)
  m.clear()
  assert_true(m.is_empty())
  assert_eq(m.length(), 0)
  assert_eq(m.get("a"), None)
}

///|
test "from array" {
  let arr = [("x", 10), ("y", 20), ("z", 30)]
  let m = @indexmap.IndexMap::from_array(arr)
  assert_eq(m.length(), 3)
  assert_eq(m.get("x"), Some(10))
  assert_eq(m.get("y"), Some(20))
  assert_eq(m.get("z"), Some(30))
}

///|
test "iter key value pairs" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("name", 100)
  m.set("age", 200)
  let pairs = []
  for kv in m.iter() {
    pairs.push(kv)
  }
  assert_eq(pairs.length(), 2)
  assert_eq(pairs[0], ("name", 100))
  assert_eq(pairs[1], ("age", 200))
}

///|
test "values iterator" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("a", 10)
  m.set("b", 20)
  let vals = []
  for v in m.values() {
    vals.push(v)
  }
  assert_eq(vals[0], 10)
  assert_eq(vals[1], 20)
}

///|
test "eq same" {
  let a : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  a.set("k1", 1)
  a.set("k2", 2)
  let b : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  b.set("k1", 1)
  b.set("k2", 2)
  assert_eq(a, b)
}

///|
test "eq different values" {
  let a : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  a.set("k", 1)
  let b : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  b.set("k", 2)
  assert_false(a == b)
}

///|
test "eq different lengths" {
  let a : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  a.set("a", 1)
  let b : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  a.set("a", 1)
  a.set("b", 2)
  assert_false(a == b)
}

///|
test "large number of entries" {
  let m : @indexmap.IndexMap[Int, Int] = @indexmap.IndexMap::new()
  for i in 0..<100 {
    m.set(i, i * 10)
  }
  assert_eq(m.length(), 100)
  for i in 0..<100 {
    assert_eq(m.get(i), Some(i * 10))
  }
  for i in 0..<100 {
    assert_eq(m.get_index(i), Some((i, i * 10)))
  }
}

///|
test "string key hash" {
  let m : @indexmap.IndexMap[String, String] = @indexmap.IndexMap::new()
  m.set("hello", "world")
  m.set("foo", "bar")
  assert_eq(m.get("hello"), Some("world"))
  assert_eq(m.get("foo"), Some("bar"))
}

///|
test "int key hash" {
  let m : @indexmap.IndexMap[Int, String] = @indexmap.IndexMap::new()
  m.set(1, "one")
  m.set(-5, "minus five")
  m.set(0, "zero")
  assert_eq(m.get(1), Some("one"))
  assert_eq(m.get(-5), Some("minus five"))
  assert_eq(m.get(0), Some("zero"))
}

///|
test "retain" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("a", 1)
  m.set("b", 10)
  m.set("c", 3)
  m.set("d", 10)
  m.retain(fn(k, v) { v >= 5 })
  assert_eq(m.length(), 2)
  assert_true(m.contains("b"))
  assert_true(m.contains("d"))
  assert_false(m.contains("a"))
  assert_false(m.contains("c"))
}

///|
test "retain preserves order" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("x", 1)
  m.set("y", 2)
  m.set("z", 3)
  m.set("w", 4)
  m.retain(fn(k, v) { k != "y" && k != "w" })
  assert_eq(m.length(), 2)
  assert_eq(m.get_index(0), Some(("x", 1)))
  assert_eq(m.get_index(1), Some(("z", 3)))
}

///|
test "retain all" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("a", 1)
  m.set("b", 2)
  m.retain(fn(k, v) { true })
  assert_eq(m.length(), 2)
}

///|
test "retain none" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("a", 1)
  m.set("b", 2)
  m.retain(fn(k, v) { false })
  assert_eq(m.length(), 0)
}

///|
test "iter rev" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("first", 1)
  m.set("second", 2)
  m.set("third", 3)
  let result = []
  for kv in m.iter_rev() {
    result.push(kv)
  }
  assert_eq(result.length(), 3)
  assert_eq(result[0], ("third", 3))
  assert_eq(result[1], ("second", 2))
  assert_eq(result[2], ("first", 1))
}

///|
test "sort keys" {
  let m : @indexmap.IndexMap[Int, String] = @indexmap.IndexMap::new()
  m.set(30, "thirty")
  m.set(10, "ten")
  m.set(20, "twenty")
  m.sort_keys(fn(a, b) { if a < b { -1 } else if a > b { 1 } else { 0 } })
  assert_eq(m.get_index(0), Some((10, "ten")))
  assert_eq(m.get_index(1), Some((20, "twenty")))
  assert_eq(m.get_index(2), Some((30, "thirty")))
}

///|
test "sort keys single" {
  let m : @indexmap.IndexMap[Int, String] = @indexmap.IndexMap::new()
  m.set(1, "one")
  m.sort_keys(fn(a, b) { if a < b { -1 } else if a > b { 1 } else { 0 } })
  assert_eq(m.get_index(0), Some((1, "one")))
}

///|
test "sort keys empty" {
  let m : @indexmap.IndexMap[Int, String] = @indexmap.IndexMap::new()
  m.sort_keys(fn(a, b) { if a < b { -1 } else if a > b { 1 } else { 0 } })
  assert_eq(m.length(), 0)
}

///|
test "pop" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("a", 1)
  m.set("b", 2)
  let last = m.pop()
  assert_eq(last, Some(("b", 2)))
  assert_eq(m.length(), 1)
  let first = m.pop()
  assert_eq(first, Some(("a", 1)))
  assert_eq(m.length(), 0)
  assert_eq(m.pop(), None)
}

///|
test "to array" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("x", 10)
  m.set("y", 20)
  let arr = m.to_array()
  assert_eq(arr.length(), 2)
  assert_eq(arr[0], ("x", 10))
  assert_eq(arr[1], ("y", 20))
}

///|
test "get or init new" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  let v = m.get_or_init("key", fn() { 42 })
  assert_eq(v, 42)
  assert_eq(m.get("key"), Some(42))
}

///|
test "get or init existing" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("key", 100)
  let v = m.get_or_init("key", fn() { 999 })
  assert_eq(v, 100)
  assert_eq(m.get("key"), Some(100))
}

///|
test "get or init maintains order" {
  let m : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  m.set("a", 1)
  let _ = m.get_or_init("b", fn() { 2 })
  m.set("c", 3)
  assert_eq(m.get_index(0), Some(("a", 1)))
  assert_eq(m.get_index(1), Some(("b", 2)))
  assert_eq(m.get_index(2), Some(("c", 3)))
}
