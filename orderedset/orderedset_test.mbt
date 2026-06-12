/// Tests for OrderedSet module.

test "new set is empty" {
  let s : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  assert_true!(s.is_empty())
  assert_eq!(s.length(), 0)
}

test "add and contains" {
  let s : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  assert_true!(s.add(1))
  assert_true!(s.add(2))
  assert_true!(s.add(3))
  assert_false!(s.add(2))
  assert_true!(s.contains(1))
  assert_true!(s.contains(2))
  assert_true!(s.contains(3))
  assert_false!(s.contains(4))
  assert_eq!(s.length(), 3)
}

test "remove" {
  let s : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  s.add(1) |> ignore
  s.add(2) |> ignore
  s.add(3) |> ignore
  assert_true!(s.remove(2))
  assert_false!(s.contains(2))
  assert_eq!(s.length(), 2)
  assert_false!(s.remove(99))
}

test "get index" {
  let s : @orderedset.OrderedSet[String] = @orderedset.OrderedSet::new()
  s.add("a") |> ignore
  s.add("b") |> ignore
  s.add("c") |> ignore
  assert_eq!(s.get_index(0), Some("a"))
  assert_eq!(s.get_index(1), Some("b"))
  assert_eq!(s.get_index(2), Some("c"))
  assert_eq!(s.get_index(3), None)
}

test "first and last" {
  let s : @orderedset.OrderedSet[String] = @orderedset.OrderedSet::new()
  assert_eq!(s.first(), None)
  assert_eq!(s.last(), None)
  s.add("first") |> ignore
  s.add("last") |> ignore
  assert_eq!(s.first(), Some("first"))
  assert_eq!(s.last(), Some("last"))
}

test "clear" {
  let s : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  s.add(1) |> ignore
  s.add(2) |> ignore
  s.clear()
  assert_true!(s.is_empty())
}

test "from array" {
  let s = @orderedset.OrderedSet::from_array(["z", "a", "m"])
  assert_eq!(s.length(), 3)
  assert_eq!(s.get_index(0), Some("z"))
  assert_eq!(s.get_index(1), Some("a"))
  assert_eq!(s.get_index(2), Some("m"))
}

test "from array dedup" {
  let s = @orderedset.OrderedSet::from_array(["a", "b", "a", "c", "b"])
  assert_eq!(s.length(), 3)
  assert_eq!(s.get_index(0), Some("a"))
  assert_eq!(s.get_index(1), Some("b"))
  assert_eq!(s.get_index(2), Some("c"))
}

test "iter in order" {
  let s : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  s.add(30) |> ignore
  s.add(10) |> ignore
  s.add(20) |> ignore
  let result = []
  for k in s.iter() {
    result.push(k)
  }
  assert_eq!(result[0], 30)
  assert_eq!(result[1], 10)
  assert_eq!(result[2], 20)
}

test "union" {
  let a : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  a.add(1) |> ignore
  a.add(2) |> ignore
  let b : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  b.add(2) |> ignore
  b.add(3) |> ignore
  let c = a.union(b)
  assert_eq!(c.length(), 3)
  assert_true!(c.contains(1))
  assert_true!(c.contains(2))
  assert_true!(c.contains(3))
}

test "intersection" {
  let a : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  a.add(1) |> ignore
  a.add(2) |> ignore
  a.add(3) |> ignore
  let b : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  b.add(2) |> ignore
  b.add(3) |> ignore
  b.add(4) |> ignore
  let c = a.intersection(b)
  assert_eq!(c.length(), 2)
  assert_true!(c.contains(2))
  assert_true!(c.contains(3))
  assert_false!(c.contains(1))
}

test "difference" {
  let a : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  a.add(1) |> ignore
  a.add(2) |> ignore
  a.add(3) |> ignore
  let b : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  b.add(2) |> ignore
  let c = a.difference(b)
  assert_eq!(c.length(), 2)
  assert_true!(c.contains(1))
  assert_true!(c.contains(3))
  assert_false!(c.contains(2))
}

test "symmetric difference" {
  let a : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  a.add(1) |> ignore
  a.add(2) |> ignore
  let b : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  b.add(2) |> ignore
  b.add(3) |> ignore
  let c = a.symmetric_difference(b)
  assert_eq!(c.length(), 2)
  assert_true!(c.contains(1))
  assert_true!(c.contains(3))
  assert_false!(c.contains(2))
}

test "is subset" {
  let a : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  a.add(1) |> ignore
  a.add(2) |> ignore
  let b : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  b.add(1) |> ignore
  b.add(2) |> ignore
  b.add(3) |> ignore
  assert_true!(a.is_subset(b))
  assert_false!(b.is_subset(a))
}

test "is superset" {
  let a : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  a.add(1) |> ignore
  a.add(2) |> ignore
  a.add(3) |> ignore
  let b : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  b.add(2) |> ignore
  assert_true!(a.is_superset(b))
  assert_false!(b.is_superset(a))
}

test "eq" {
  let a : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  a.add(1) |> ignore
  a.add(2) |> ignore
  let b : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  b.add(1) |> ignore
  b.add(2) |> ignore
  assert_eq!(a, b)
}

test "eq different lengths" {
  let a : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  a.add(1) |> ignore
  let b : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  b.add(1) |> ignore
  b.add(2) |> ignore
  assert_false!(a == b)
}

test "large set" {
  let s : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  for i in 0..<100 {
    s.add(i) |> ignore
  }
  assert_eq!(s.length(), 100)
  for i in 0..<100 {
    assert_true!(s.contains(i))
  }
}

test "self union" {
  let a : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  a.add(1) |> ignore
  a.add(2) |> ignore
  let c = a.union(a)
  assert_eq!(c, a)
}

test "self difference" {
  let a : @orderedset.OrderedSet[Int] = @orderedset.OrderedSet::new()
  a.add(1) |> ignore
  a.add(2) |> ignore
  let c = a.difference(a)
  assert_true!(c.is_empty())
}
