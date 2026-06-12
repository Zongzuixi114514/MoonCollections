/// Tests for UnionFind module.

test "new uf count equals n" {
  let uf = @unionfind.UnionFind::new(10)
  assert_eq!(uf.count(), 10)
  assert_eq!(uf.length(), 10)
}

test "initial each separate" {
  let uf = @unionfind.UnionFind::new(5)
  for i in 0..<5 {
    assert_eq!(uf.find(i), i)
  }
}

test "union two" {
  let uf = @unionfind.UnionFind::new(10)
  assert_true!(uf.union(0, 1))
  assert_eq!(uf.count(), 9)
  assert_true!(uf.connected(0, 1))
}

test "union already connected" {
  let uf = @unionfind.UnionFind::new(10)
  uf.union(0, 1) |> ignore
  assert_false!(uf.union(0, 1))
}

test "connected transitive" {
  let uf = @unionfind.UnionFind::new(10)
  uf.union(0, 1) |> ignore
  uf.union(1, 2) |> ignore
  assert_true!(uf.connected(0, 2))
}

test "not connected" {
  let uf = @unionfind.UnionFind::new(10)
  assert_false!(uf.connected(3, 7))
}

test "path compression" {
  let uf = @unionfind.UnionFind::new(100)
  for i in 1..<100 {
    uf.union(0, i) |> ignore
  }
  assert_eq!(uf.count(), 1)
  for i in 0..<100 {
    assert_eq!(uf.find(i), uf.find(0))
  }
}

test "roots" {
  let uf = @unionfind.UnionFind::new(5)
  uf.union(0, 1) |> ignore
  uf.union(2, 3) |> ignore
  let roots = uf.roots()
  assert_eq!(roots.length(), 3)
}

test "size of set" {
  let uf = @unionfind.UnionFind::new(10)
  uf.union(0, 1) |> ignore
  uf.union(1, 2) |> ignore
  uf.union(0, 3) |> ignore
  assert_eq!(uf.size(0), 4)
  assert_eq!(uf.size(5), 1)
}

test "reset" {
  let uf = @unionfind.UnionFind::new(5)
  uf.union(0, 1) |> ignore
  uf.union(2, 3) |> ignore
  uf.reset()
  assert_eq!(uf.count(), 5)
  assert_false!(uf.connected(0, 1))
}

test "union many" {
  let uf = @unionfind.UnionFind::new(50)
  for i in 0..<49 {
    uf.union(i, i + 1) |> ignore
  }
  assert_eq!(uf.count(), 1)
}

test "union by rank demo" {
  let uf = @unionfind.UnionFind::new(10)
  uf.union(0, 1) |> ignore
  uf.union(2, 3) |> ignore
  uf.union(4, 5) |> ignore
  uf.union(0, 2) |> ignore
  uf.union(0, 4) |> ignore
  assert_eq!(uf.count(), 5)
  assert_eq!(uf.size(0), 6)
}
