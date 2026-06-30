/// Tests for Trie module.

test "new trie empty" {
  let t = @trie.Trie::new()
  assert_eq!(t.length(), 0)
}

test "insert and contains" {
  let t = @trie.Trie::new()
  t.insert("hello") |> ignore
  t.insert("world") |> ignore
  assert_true!(t.contains("hello"))
  assert_true!(t.contains("world"))
  assert_false!(t.contains("foo"))
}

test "insert duplicate" {
  let t = @trie.Trie::new()
  assert_true!(t.insert("word"))
  assert_false!(t.insert("word"))
  assert_eq!(t.length(), 1)
}

test "starts with" {
  let t = @trie.Trie::new()
  t.insert("hello") |> ignore
  t.insert("help") |> ignore
  t.insert("world") |> ignore
  assert_true!(t.starts_with("hel"))
  assert_true!(t.starts_with("hello"))
  assert_false!(t.starts_with("abc"))
}

test "count prefix" {
  let t = @trie.Trie::new()
  t.insert("hello") |> ignore
  t.insert("help") |> ignore
  t.insert("he") |> ignore
  t.insert("world") |> ignore
  assert_eq!(t.count_prefix("he"), 3)
  assert_eq!(t.count_prefix("hello"), 1)
  assert_eq!(t.count_prefix("xyz"), 0)
}

test "remove" {
  let t = @trie.Trie::new()
  t.insert("test") |> ignore
  assert_true!(t.contains("test"))
  assert_true!(t.remove("test"))
  assert_false!(t.contains("test"))
  assert_false!(t.remove("test"))
}

test "remove prefix" {
  let t = @trie.Trie::new()
  t.insert("abc") |> ignore
  t.insert("abcd") |> ignore
  t.remove("abcd") |> ignore
  assert_true!(t.contains("abc"))
  assert_false!(t.contains("abcd"))
}

test "autocomplete" {
  let t = @trie.Trie::new()
  t.insert("hello") |> ignore
  t.insert("help") |> ignore
  t.insert("helmet") |> ignore
  t.insert("world") |> ignore
  let results = t.autocomplete("hel", 10)
  assert_eq!(results.length(), 3)
}

test "autocomplete limit" {
  let t = @trie.Trie::new()
  t.insert("a") |> ignore
  t.insert("aa") |> ignore
  t.insert("aaa") |> ignore
  t.insert("aab") |> ignore
  t.insert("aac") |> ignore
  let results = t.autocomplete("a", 3)
  assert_eq!(results.length(), 3)
}

test "to array" {
  let t = @trie.Trie::new()
  t.insert("z") |> ignore
  t.insert("a") |> ignore
  t.insert("m") |> ignore
  let words = t.to_array()
  assert_eq!(words.length(), 3)
}

test "clear" {
  let t = @trie.Trie::new()
  t.insert("test") |> ignore
  t.clear()
  assert_eq!(t.length(), 0)
  assert_false!(t.contains("test"))
}

test "empty string" {
  let t = @trie.Trie::new()
  t.insert("") |> ignore
  assert_true!(t.contains(""))
  assert_eq!(t.length(), 1)
}
