///|
/// Tests for BitVec module.
test "new bitvec empty" {
  let bv = @bitvec.BitVec::new()
  assert_eq(bv.count(), 0)
  assert_true(bv.is_empty())
}

///|
test "set and has" {
  let bv = @bitvec.BitVec::new()
  bv.set(0)
  bv.set(42)
  bv.set(1000)
  assert_true(bv.has(0))
  assert_true(bv.has(42))
  assert_true(bv.has(1000))
  assert_false(bv.has(1))
  assert_false(bv.has(500))
}

///|
test "auto grow" {
  let bv = @bitvec.BitVec::new()
  bv.set(999)
  assert_true(bv.has(999))
  assert_true(bv.capacity() >= 1000)
}

///|
test "clear" {
  let bv = @bitvec.BitVec::new()
  bv.set(10)
  bv.set(20)
  bv.clear(10)
  assert_false(bv.has(10))
  assert_true(bv.has(20))
}

///|
test "toggle" {
  let bv = @bitvec.BitVec::new()
  bv.toggle(5)
  assert_true(bv.has(5))
  bv.toggle(5)
  assert_false(bv.has(5))
}

///|
test "count" {
  let bv = @bitvec.BitVec::new()
  bv.set(0)
  bv.set(7)
  bv.set(8)
  bv.set(100)
  assert_eq(bv.count(), 4)
}

///|
test "clear all" {
  let bv = @bitvec.BitVec::new()
  bv.set(1)
  bv.set(2)
  bv.set(3)
  bv.clear_all()
  assert_eq(bv.count(), 0)
  assert_false(bv.has(1))
}

///|
test "iter" {
  let bv = @bitvec.BitVec::new()
  bv.set(0)
  bv.set(50)
  bv.set(100)
  let results = []
  for idx in bv.iter() {
    results.push(idx)
  }
  assert_eq(results[0], 0)
  assert_eq(results[1], 50)
  assert_eq(results[2], 100)
}

///|
test "to array" {
  let bv = @bitvec.BitVec::new()
  bv.set(10)
  bv.set(200)
  let arr = bv.to_array()
  assert_eq(arr.length(), 2)
}

///|
test "with capacity" {
  let bv = @bitvec.BitVec::with_capacity(2048)
  bv.set(1000)
  assert_eq(bv.capacity(), 2048)
  assert_true(bv.has(1000))
}

///|
test "max bit" {
  let bv = @bitvec.BitVec::new()
  bv.set(5)
  bv.set(100)
  bv.set(50)
  assert_eq(bv.max_bit(), Some(100))
}

///|
test "max bit empty" {
  let bv = @bitvec.BitVec::new()
  assert_eq(bv.max_bit(), None)
}
