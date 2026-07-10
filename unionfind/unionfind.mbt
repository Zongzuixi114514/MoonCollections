///|
/// UnionFind — disjoint-set data structure with path compression and union by rank.
///
/// Supports efficient union and find operations, useful for graph connectivity,
/// Kruskal's MST algorithm, and dynamic connectivity problems.
struct UnionFind {
  parent : Array[Int]
  rank : Array[Int]
  mut set_count : Int
}

///|
/// Create a new UnionFind with `n` elements (0 to n-1), each in its own set.
pub fn UnionFind::new(n : Int) -> UnionFind {
  {
    parent: Array::makei(n, fn(i) { i }),
    rank: Array::makei(n, fn(_) { 0 }),
    set_count: n,
  }
}

///|
/// Find the root element of the set containing `x`, with path compression.
pub fn UnionFind::find(self : UnionFind, x : Int) -> Int {
  let mut cur = x
  while self.parent[cur] != cur {
    self.parent[cur] = self.parent[self.parent[cur]]
    cur = self.parent[cur]
  }
  cur
}

///|
/// Union the sets containing `x` and `y`. Returns `true` if they were in
/// different sets, `false` if already in the same set.
pub fn UnionFind::union(self : UnionFind, x : Int, y : Int) -> Bool {
  let rx = self.find(x)
  let ry = self.find(y)
  guard rx != ry else { return false }
  if self.rank[rx] < self.rank[ry] {
    self.parent[rx] = ry
  } else if self.rank[rx] > self.rank[ry] {
    self.parent[ry] = rx
  } else {
    self.parent[ry] = rx
    self.rank[rx] = self.rank[rx] + 1
  }
  self.set_count = self.set_count - 1
  true
}

///|
/// Check if `x` and `y` are in the same set.
pub fn UnionFind::connected(self : UnionFind, x : Int, y : Int) -> Bool {
  self.find(x) == self.find(y)
}

///|
/// Return the number of disjoint sets.
pub fn UnionFind::count(self : UnionFind) -> Int {
  self.set_count
}

///|
/// Return the number of elements.
pub fn UnionFind::length(self : UnionFind) -> Int {
  self.parent.length()
}

///|
/// Return the size of the set containing `x`.
pub fn UnionFind::size(self : UnionFind, x : Int) -> Int {
  let root = self.find(x)
  let mut count = 0
  for i in 0..<self.parent.length() {
    if self.find(i) == root {
      count = count + 1
    }
  }
  count
}

///|
/// Return a list of all roots (one per set).
pub fn UnionFind::roots(self : UnionFind) -> Array[Int] {
  let result = []
  for i in 0..<self.parent.length() {
    if self.parent[i] == i {
      result.push(i)
    }
  }
  result
}

///|
/// Reset all elements to their own singleton sets.
pub fn UnionFind::reset(self : UnionFind) -> Unit {
  let n = self.parent.length()
  for i in 0..<n {
    self.parent[i] = i
    self.rank[i] = 0
  }
  self.set_count = n
}

///|
/// Implement `Show` for display.
