/// Tests for BitSet module.

test "new bitset all zeros" {
  let bits = @bitmask.BitSet::new(64)
  for i in 0..<64 {
    assert_false!(bits.has(i))
  }
  assert_eq!(bits.length(), 64)
}

test "set and has" {
  let bits = @bitmask.BitSet::new(128)
  bits.set(0)
  bits.set(42)
  bits.set(127)
  assert_true!(bits.has(0))
  assert_true!(bits.has(42))
  assert_true!(bits.has(127))
  assert_false!(bits.has(1))
  assert_false!(bits.has(43))
  assert_false!(bits.has(126))
}

test "set boundary" {
  let bits = @bitmask.BitSet::new(8)
  bits.set(0)
  bits.set(7)
  assert_true!(bits.has(0))
  assert_true!(bits.has(7))
}

test "clear bit" {
  let bits = @bitmask.BitSet::new(64)
  bits.set(10)
  assert_true!(bits.has(10))
  bits.clear(10)
  assert_false!(bits.has(10))
}

test "toggle bit" {
  let bits = @bitmask.BitSet::new(64)
  assert_false!(bits.has(5))
  bits.toggle(5)
  assert_true!(bits.has(5))
  bits.toggle(5)
  assert_false!(bits.has(5))
}

test "multiple toggle" {
  let bits = @bitmask.BitSet::new(100)
  for i in 0..<100 {
    bits.toggle(i)
  }
  for i in 0..<100 {
    assert_true!(bits.has(i))
  }
  for i in 0..<100 {
    bits.toggle(i)
  }
  for i in 0..<100 {
    assert_false!(bits.has(i))
  }
}

test "count empty" {
  let bits = @bitmask.BitSet::new(256)
  assert_eq!(bits.count(), 0)
}

test "count bits" {
  let bits = @bitmask.BitSet::new(256)
  bits.set(0)
  bits.set(7)
  bits.set(8)
  bits.set(15)
  bits.set(100)
  bits.set(200)
  bits.set(255)
  assert_eq!(bits.count(), 7)
}

test "count after clear" {
  let bits = @bitmask.BitSet::new(64)
  bits.set(1)
  bits.set(2)
  bits.set(3)
  assert_eq!(bits.count(), 3)
  bits.clear(2)
  assert_eq!(bits.count(), 2)
}

test "is empty" {
  let bits = @bitmask.BitSet::new(64)
  assert_true!(bits.is_empty())
  bits.set(10)
  assert_false!(bits.is_empty())
  bits.clear(10)
  assert_true!(bits.is_empty())
}

test "fill all ones" {
  let bits = @bitmask.BitSet::new(64)
  bits.fill()
  for i in 0..<64 {
    assert_true!(bits.has(i))
  }
  assert_eq!(bits.count(), 64)
}

test "clear all" {
  let bits = @bitmask.BitSet::new(64)
  bits.fill()
  bits.clear_all()
  assert_true!(bits.is_empty())
  assert_eq!(bits.count(), 0)
}

test "union" {
  let a = @bitmask.BitSet::new(64)
  a.set(0)
  a.set(10)
  a.set(20)
  let b = @bitmask.BitSet::new(64)
  b.set(10)
  b.set(30)
  b.set(40)
  let c = a.union(b)
  assert_true!(c.has(0))
  assert_true!(c.has(10))
  assert_true!(c.has(20))
  assert_true!(c.has(30))
  assert_true!(c.has(40))
  assert_eq!(c.count(), 5)
}

test "union different sizes" {
  let a = @bitmask.BitSet::new(128)
  a.set(100)
  let b = @bitmask.BitSet::new(64)
  b.set(50)
  let c = a.union(b)
  assert_eq!(c.length(), 128)
  assert_true!(c.has(50))
  assert_true!(c.has(100))
}

test "intersect" {
  let a = @bitmask.BitSet::new(64)
  a.set(1)
  a.set(2)
  a.set(3)
  a.set(10)
  let b = @bitmask.BitSet::new(64)
  b.set(2)
  b.set(10)
  b.set(20)
  let c = a.intersect(b)
  assert_true!(c.has(2))
  assert_true!(c.has(10))
  assert_false!(c.has(1))
  assert_false!(c.has(3))
  assert_false!(c.has(20))
  assert_eq!(c.count(), 2)
}

test "intersect empty result" {
  let a = @bitmask.BitSet::new(64)
  a.set(1)
  a.set(2)
  let b = @bitmask.BitSet::new(64)
  b.set(3)
  b.set(4)
  let c = a.intersect(b)
  assert_true!(c.is_empty())
}

test "difference" {
  let a = @bitmask.BitSet::new(64)
  a.set(1)
  a.set(2)
  a.set(3)
  a.set(10)
  let b = @bitmask.BitSet::new(64)
  b.set(2)
  b.set(10)
  let c = a.difference(b)
  assert_true!(c.has(1))
  assert_true!(c.has(3))
  assert_false!(c.has(2))
  assert_false!(c.has(10))
  assert_eq!(c.count(), 2)
}

test "iter empty" {
  let bits = @bitmask.BitSet::new(64)
  let mut count = 0
  for idx in bits.iter() {
    let _ = idx
    count = count + 1
  }
  assert_eq!(count, 0)
}

test "iter set bits" {
  let bits = @bitmask.BitSet::new(200)
  bits.set(0)
  bits.set(50)
  bits.set(100)
  bits.set(150)
  bits.set(199)
  let indices = []
  for idx in bits.iter() {
    indices.push(idx)
  }
  assert_eq!(indices.length(), 5)
  assert_eq!(indices[0], 0)
  assert_eq!(indices[1], 50)
  assert_eq!(indices[2], 100)
  assert_eq!(indices[3], 150)
  assert_eq!(indices[4], 199)
}

test "eq same" {
  let a = @bitmask.BitSet::new(64)
  a.set(5)
  a.set(10)
  let b = @bitmask.BitSet::new(64)
  b.set(5)
  b.set(10)
  assert_eq!(a, b)
}

test "eq different" {
  let a = @bitmask.BitSet::new(64)
  a.set(5)
  let b = @bitmask.BitSet::new(64)
  b.set(10)
  assert_false!(a == b)
}

test "eq different lengths" {
  let a = @bitmask.BitSet::new(64)
  let b = @bitmask.BitSet::new(128)
  assert_false!(a == b)
}

test "out of bounds safe" {
  let bits = @bitmask.BitSet::new(64)
  bits.set(100)
  bits.clear(100)
  bits.toggle(100)
  assert_false!(bits.has(100))
}

test "boundary at byte edges" {
  let bits = @bitmask.BitSet::new(16)
  bits.set(7)
  bits.set(8)
  assert_true!(bits.has(7))
  assert_true!(bits.has(8))
  bits.toggle(7)
  bits.toggle(8)
  assert_false!(bits.has(7))
  assert_false!(bits.has(8))
}

test "self operations" {
  let bits = @bitmask.BitSet::new(64)
  bits.set(10)
  let same = bits.union(bits)
  assert_eq!(same.count(), 1)
  assert_true!(same.has(10))
  let inter = bits.intersect(bits)
  assert_eq!(inter.count(), 1)
  let diff = bits.difference(bits)
  assert_true!(diff.is_empty())
}

test "symmetric difference" {
  let a = @bitmask.BitSet::new(64)
  a.set(1); a.set(2); a.set(3)
  let b = @bitmask.BitSet::new(64)
  b.set(2); b.set(3); b.set(4)
  let c = a.symmetric_difference(b)
  assert_true!(c.has(1))
  assert_true!(c.has(4))
  assert_false!(c.has(2))
  assert_false!(c.has(3))
  assert_eq!(c.count(), 2)
}

test "symmetric difference different sizes" {
  let a = @bitmask.BitSet::new(128)
  a.set(100)
  a.set(50)
  let b = @bitmask.BitSet::new(64)
  b.set(50)
  let c = a.symmetric_difference(b)
  assert_false!(c.has(50))
  assert_true!(c.has(100))
  assert_eq!(c.count(), 1)
}

test "is subset" {
  let a = @bitmask.BitSet::new(64)
  a.set(1); a.set(2)
  let b = @bitmask.BitSet::new(64)
  b.set(1); b.set(2); b.set(3)
  assert_true!(a.is_subset(b))
  assert_false!(b.is_subset(a))
}

test "is subset equal" {
  let a = @bitmask.BitSet::new(64)
  a.set(1); a.set(2)
  let b = @bitmask.BitSet::new(64)
  b.set(1); b.set(2)
  assert_true!(a.is_subset(b))
  assert_true!(b.is_subset(a))
}

test "is superset" {
  let a = @bitmask.BitSet::new(64)
  a.set(1); a.set(2); a.set(3)
  let b = @bitmask.BitSet::new(64)
  b.set(2)
  assert_true!(a.is_superset(b))
  assert_false!(b.is_superset(a))
}

test "is disjoint" {
  let a = @bitmask.BitSet::new(64)
  a.set(1); a.set(2)
  let b = @bitmask.BitSet::new(64)
  b.set(3); b.set(4)
  assert_true!(a.is_disjoint(b))
  b.set(1)
  assert_false!(a.is_disjoint(b))
}

test "any" {
  let bits = @bitmask.BitSet::new(64)
  assert_false!(bits.any())
  bits.set(10)
  assert_true!(bits.any())
}

test "all" {
  let bits = @bitmask.BitSet::new(8)
  assert_false!(bits.all())
  bits.fill()
  assert_true!(bits.all())
}

test "count zeros" {
  let bits = @bitmask.BitSet::new(64)
  assert_eq!(bits.count_zeros(), 64)
  bits.set(0)
  bits.set(1)
  assert_eq!(bits.count_zeros(), 62)
}

test "resize grow" {
  let bits = @bitmask.BitSet::new(64)
  bits.set(10)
  bits.set(60)
  let bigger = bits.resize(128)
  assert_eq!(bigger.length(), 128)
  assert_true!(bigger.has(10))
  assert_true!(bigger.has(60))
  assert_eq!(bigger.count(), 2)
}

test "resize shrink" {
  let bits = @bitmask.BitSet::new(128)
  bits.set(10)
  bits.set(100)
  let smaller = bits.resize(64)
  assert_eq!(smaller.length(), 64)
  assert_true!(smaller.has(10))
  assert_false!(smaller.has(100))
  assert_eq!(smaller.count(), 1)
}

test "complement" {
  let bits = @bitmask.BitSet::new(8)
  bits.set(0)
  let comp = bits.complement()
  assert_false!(comp.has(0))
  assert_true!(comp.has(1))
  assert_true!(comp.has(7))
  assert_eq!(comp.count(), 7)
}

test "complement full set" {
  let bits = @bitmask.BitSet::new(8)
  bits.fill()
  let comp = bits.complement()
  assert_eq!(comp.count(), 0)
}

test "from indices" {
  let bits = @bitmask.BitSet::from_indices([0, 5, 10, 15], 64)
  assert_eq!(bits.count(), 4)
  assert_true!(bits.has(0))
  assert_true!(bits.has(5))
  assert_true!(bits.has(10))
  assert_true!(bits.has(15))
}

test "to array" {
  let bits = @bitmask.BitSet::new(256)
  bits.set(0)
  bits.set(127)
  bits.set(255)
  let arr = bits.to_array()
  assert_eq!(arr.length(), 3)
  assert_eq!(arr[0], 0)
  assert_eq!(arr[1], 127)
  assert_eq!(arr[2], 255)
}

test "subset empty set" {
  let a = @bitmask.BitSet::new(64)
  let b = @bitmask.BitSet::new(64)
  b.set(1)
  assert_true!(a.is_subset(b))
}

test "subset different sizes" {
  let a = @bitmask.BitSet::new(128)
  a.set(50)
  let b = @bitmask.BitSet::new(64)
  assert_false!(a.is_subset(b))
}
