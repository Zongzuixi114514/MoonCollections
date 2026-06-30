/// Tests for SparseSet module.

test "new set empty" {
  let s = @sparseset.SparseSet::new(100)
  assert_eq!(s.length(), 0)
  assert_true!(s.is_empty())
}

test "insert and contains" {
  let s = @sparseset.SparseSet::new(100)
  assert_true!(s.insert(5))
  assert_true!(s.insert(10))
  assert_true!(s.insert(99))
  assert_true!(s.contains(5))
  assert_true!(s.contains(99))
  assert_false!(s.contains(50))
  assert_eq!(s.length(), 3)
}

test "insert duplicate" {
  let s = @sparseset.SparseSet::new(50)
  assert_true!(s.insert(10))
  assert_false!(s.insert(10))
  assert_eq!(s.length(), 1)
}

test "insert out of range" {
  let s = @sparseset.SparseSet::new(10)
  assert_false!(s.insert(-1))
  assert_false!(s.insert(11))
}

test "remove" {
  let s = @sparseset.SparseSet::new(100)
  s.insert(5) |> ignore
  s.insert(10) |> ignore
  s.insert(15) |> ignore
  assert_true!(s.remove(10))
  assert_false!(s.contains(10))
  assert_eq!(s.length(), 2)
  assert_true!(s.contains(5))
  assert_true!(s.contains(15))
}

test "clear O1" {
  let s = @sparseset.SparseSet::new(100)
  for i in 0..<50 {
    s.insert(i) |> ignore
  }
  assert_eq!(s.length(), 50)
  s.clear()
  assert_eq!(s.length(), 0)
  assert_false!(s.contains(25))
}

test "clear then reuse" {
  let s = @sparseset.SparseSet::new(100)
  s.insert(1) |> ignore
  s.insert(2) |> ignore
  s.clear()
  assert_true!(s.insert(1))
  assert_eq!(s.length(), 1)
}

test "iter" {
  let s = @sparseset.SparseSet::new(100)
  s.insert(10) |> ignore
  s.insert(20) |> ignore
  s.insert(30) |> ignore
  let results = []
  for v in s.iter() {
    results.push(v)
  }
  assert_eq!(results.length(), 3)
}

test "to array" {
  let s = @sparseset.SparseSet::new(100)
  s.insert(5) |> ignore
  s.insert(25) |> ignore
  let arr = s.to_array()
  assert_eq!(arr.length(), 2)
}

test "many operations" {
  let s = @sparseset.SparseSet::new(1000)
  for i in 0..<100 {
    s.insert(i) |> ignore
  }
  assert_eq!(s.length(), 100)
  for i in 0..<50 {
    s.remove(i) |> ignore
  }
  assert_eq!(s.length(), 50)
}
