///|
/// Tests for CountMap module.
test "new countmap empty" {
  let cm : @countmap.CountMap[String] = @countmap.CountMap::new()
  assert_eq(cm.length(), 0)
  assert_eq(cm.total(), 0)
}

///|
test "increment" {
  let cm : @countmap.CountMap[String] = @countmap.CountMap::new()
  assert_eq(cm.increment("a"), 1)
  assert_eq(cm.increment("a"), 2)
  assert_eq(cm.increment("b"), 1)
  assert_eq(cm.get("a"), 2)
  assert_eq(cm.get("b"), 1)
  assert_eq(cm.get("c"), 0)
}

///|
test "add n" {
  let cm : @countmap.CountMap[String] = @countmap.CountMap::new()
  assert_eq(cm.add("x", 5), 5)
  assert_eq(cm.add("x", 3), 8)
}

///|
test "decrement" {
  let cm : @countmap.CountMap[String] = @countmap.CountMap::new()
  cm.increment("a") |> ignore
  cm.increment("a") |> ignore
  cm.increment("a") |> ignore
  assert_eq(cm.decrement("a"), 2)
  assert_eq(cm.decrement("a"), 1)
  assert_eq(cm.decrement("a"), 0)
  assert_eq(cm.get("a"), 0)
}

///|
test "set count" {
  let cm : @countmap.CountMap[String] = @countmap.CountMap::new()
  cm.set("k", 10)
  assert_eq(cm.get("k"), 10)
  cm.set("k", 0)
  assert_eq(cm.get("k"), 0)
  assert_false(cm.contains("k"))
}

///|
test "remove" {
  let cm : @countmap.CountMap[String] = @countmap.CountMap::new()
  cm.increment("x") |> ignore
  cm.remove("x")
  assert_eq(cm.get("x"), 0)
  assert_false(cm.contains("x"))
}

///|
test "contains" {
  let cm : @countmap.CountMap[String] = @countmap.CountMap::new()
  cm.increment("hello") |> ignore
  assert_true(cm.contains("hello"))
  assert_false(cm.contains("world"))
}

///|
test "is empty" {
  let cm : @countmap.CountMap[String] = @countmap.CountMap::new()
  assert_true(cm.is_empty())
  cm.increment("a") |> ignore
  assert_false(cm.is_empty())
}

///|
test "total" {
  let cm : @countmap.CountMap[String] = @countmap.CountMap::new()
  cm.increment("a") |> ignore
  cm.increment("a") |> ignore
  cm.increment("b") |> ignore
  assert_eq(cm.total(), 3)
}

///|
test "most common" {
  let cm : @countmap.CountMap[String] = @countmap.CountMap::new()
  cm.add("a", 3) |> ignore
  cm.add("b", 10) |> ignore
  cm.add("c", 5) |> ignore
  assert_eq(cm.most_common(), Some("b"))
}

///|
test "most common empty" {
  let cm : @countmap.CountMap[String] = @countmap.CountMap::new()
  assert_true(cm.most_common() is None)
}

///|
test "most common n" {
  let cm : @countmap.CountMap[String] = @countmap.CountMap::new()
  cm.add("a", 3) |> ignore
  cm.add("b", 10) |> ignore
  cm.add("c", 5) |> ignore
  cm.add("d", 1) |> ignore
  let top2 = cm.most_common_n(2)
  assert_eq(top2.length(), 2)
  assert_eq(top2[0].0, "b")
  assert_eq(top2[1].0, "c")
}

///|
test "merge" {
  let cm1 : @countmap.CountMap[String] = @countmap.CountMap::new()
  cm1.increment("a") |> ignore
  cm1.increment("a") |> ignore
  let cm2 : @countmap.CountMap[String] = @countmap.CountMap::new()
  cm2.increment("a") |> ignore
  cm2.increment("b") |> ignore
  cm1.merge(cm2)
  assert_eq(cm1.get("a"), 3)
  assert_eq(cm1.get("b"), 1)
}

///|
test "from array" {
  let cm = @countmap.CountMap::from_array(["x", "y", "x", "z", "x"])
  assert_eq(cm.get("x"), 3)
  assert_eq(cm.get("y"), 1)
  assert_eq(cm.get("z"), 1)
  assert_eq(cm.length(), 3)
}

///|
test "clear" {
  let cm : @countmap.CountMap[String] = @countmap.CountMap::new()
  cm.increment("a") |> ignore
  cm.increment("b") |> ignore
  cm.clear()
  assert_eq(cm.length(), 0)
  assert_eq(cm.total(), 0)
}

///|
test "iter pairs" {
  let cm : @countmap.CountMap[String] = @countmap.CountMap::new()
  cm.add("k1", 10) |> ignore
  cm.add("k2", 20) |> ignore
  let mut total = 0
  for kv in cm.iter() {
    total = total + kv.1
  }
  assert_eq(total, 30)
}

///|
test "entropy" {
  let cm : @countmap.CountMap[String] = @countmap.CountMap::new()
  cm.add("a", 1) |> ignore
  cm.add("b", 1) |> ignore
  let e = cm.entropy()
  assert_true(e > 0.9)
  assert_true(e < 1.1)
}

///|
test "entropy empty" {
  let cm : @countmap.CountMap[String] = @countmap.CountMap::new()
  assert_eq(cm.entropy(), 0.0)
}

///|
test "entropy single" {
  let cm : @countmap.CountMap[String] = @countmap.CountMap::new()
  cm.add("x", 10) |> ignore
  assert_eq(cm.entropy(), 0.0)
}
