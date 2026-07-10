///|
/// Tests for BloomFilter module.
test "new filter" {
  let bf = @bloomfilter.BloomFilter::new(1000, 0.01)
  assert_eq(bf.hash_count() > 0, true)
  assert_eq(bf.bit_count() > 0, true)
}

///|
test "contains after add" {
  let bf = @bloomfilter.BloomFilter::new(1000, 0.01)
  bf.add("hello")
  bf.add("world")
  assert_true(bf.contains("hello"))
  assert_true(bf.contains("world"))
}

///|
test "definitely not in set" {
  let bf = @bloomfilter.BloomFilter::new(1000, 0.01)
  bf.add("hello")
  assert_false(bf.contains("goodbye"))
}

///|
test "multiple items" {
  let bf = @bloomfilter.BloomFilter::new(5000, 0.01)
  for i in 0..<100 {
    bf.add(i.to_string())
  }
  for i in 0..<100 {
    assert_true(bf.contains(i.to_string()))
  }
}

///|
test "clear" {
  let bf = @bloomfilter.BloomFilter::new(1000, 0.01)
  bf.add("test")
  bf.clear()
  assert_false(bf.contains("test"))
  assert_eq(bf.set_bits(), 0)
}

///|
test "set bits count" {
  let bf = @bloomfilter.BloomFilter::new(10000, 0.01)
  assert_eq(bf.set_bits(), 0)
  bf.add("item")
  let _ = bf.set_bits() > 0
  assert_true(bf.set_bits() > 0)
}

///|
test "string keys" {
  let bf = @bloomfilter.BloomFilter::new(1000, 0.01)
  bf.add("moonbit")
  bf.add("rust")
  bf.add("python")
  assert_true(bf.contains("moonbit"))
  assert_false(bf.contains("java"))
}

///|
test "int keys" {
  let bf = @bloomfilter.BloomFilter::new(1000, 0.01)
  bf.add(42)
  bf.add(100)
  assert_true(bf.contains(42))
  assert_true(bf.contains(100))
  assert_false(bf.contains(99))
}

///|
test "estimated fpr" {
  let bf = @bloomfilter.BloomFilter::new(10000, 0.01)
  let fpr = bf.estimated_fpr()
  assert_true(fpr >= 0.0)
}

///|
test "with params" {
  let bf = @bloomfilter.BloomFilter::with_params(1024, 7)
  assert_eq(bf.bit_count(), 1024)
  assert_eq(bf.hash_count(), 7)
}

///|
test "optimal bits positive" {
  let bf = @bloomfilter.BloomFilter::new(1, 0.01)
  assert_true(bf.bit_count() >= 64)
}

///|
test "no false negatives" {
  let bf = @bloomfilter.BloomFilter::new(10000, 0.01)
  for i in 0..<200 {
    bf.add(i.to_string())
  }
  for i in 0..<200 {
    assert_true(bf.contains(i.to_string()))
  }
}
