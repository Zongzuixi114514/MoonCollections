///|
/// MoonCollections Demo — exercises all 7 data structure modules.
/// Run with `moon run cmd/main` from the project root.
fn main {
  println("=== MoonCollections Demo ===\n")

  // 1. IndexMap — order-preserving key-value store
  println("--- 1. IndexMap ---")
  let map : @indexmap.IndexMap[String, Int] = @indexmap.IndexMap::new()
  map.set("first", 1)
  map.set("second", 2)
  map.set("third", 3)
  println("  Length: " + map.length().to_string())
  match map.get("second") {
    Some(v) => println("  get(\"second\"): " + v.to_string())
    None => println("  get(\"second\"): None")
  }
  match map.get_index(0) {
    Some((k, v)) =>
      println("  get_index(0): (\"" + k + "\", " + v.to_string() + ")")
    None => println("  get_index(0): None")
  }

  // 2. OrderedSet — insertion-order set
  println("--- 2. OrderedSet ---")
  let set : @orderedset.OrderedSet[String] = @orderedset.OrderedSet::new()
  let _ = set.add("apple")
  let _ = set.add("banana")
  let _ = set.add("cherry")
  let _ = set.add("banana")
  println("  Length: " + set.length().to_string())
  println("  Contains \"banana\": " + set.contains("banana").to_string())

  // 3. BitSet — fixed-size bit-level set operations
  println("--- 3. BitSet ---")
  let bits = @bitmask.BitSet::new(16)
  bits.set(0)
  bits.set(3)
  bits.set(7)
  bits.set(15)
  println("  Count: " + bits.count().to_string())
  println("  Has bit 7: " + bits.has(7).to_string())
  println("  Has bit 5: " + bits.has(5).to_string())
  println("  All: " + bits.all().to_string())
  println("  Any: " + bits.any().to_string())
  let comp = bits.complement()
  println("  Complement count: " + comp.count().to_string())

  // 4. BloomFilter — probabilistic set membership
  println("--- 4. BloomFilter ---")
  let bf = @bloomfilter.BloomFilter::new(1000, 0.01)
  bf.add("hello")
  bf.add("world")
  bf.add("moonbit")
  println("  Contains \"hello\": " + bf.contains("hello").to_string())
  println("  Contains \"missing\": " + bf.contains("missing").to_string())
  println("  Bit count: " + bf.bit_count().to_string())
  println("  Hash count: " + bf.hash_count().to_string())

  // 5. LRUCache — least-recently-used cache
  println("--- 5. LRUCache ---")
  let cache : @lrucache.LRUCache[String, Int] = @lrucache.LRUCache::new(3)
  cache.put("a", 1)
  cache.put("b", 2)
  cache.put("c", 3)
  cache.put("d", 4)
  println("  Length: " + cache.length().to_string())
  match cache.get("a") {
    Some(v) => println("  get(\"a\"): " + v.to_string())
    None => println("  get(\"a\"): None (evicted)")
  }
  match cache.get("b") {
    Some(v) => println("  get(\"b\"): " + v.to_string())
    None => println("  get(\"b\"): None")
  }

  // 6. UnionFind — disjoint-set with path compression
  println("--- 6. UnionFind ---")
  let uf = @unionfind.UnionFind::new(6)
  let _ = uf.union(0, 1)
  let _ = uf.union(1, 2)
  let _ = uf.union(3, 4)
  println("  Connected(0, 2): " + uf.connected(0, 2).to_string())
  println("  Connected(0, 3): " + uf.connected(0, 3).to_string())
  println("  Size(0): " + uf.size(0).to_string())
  println("  Groups: " + uf.count().to_string())

  // 7. CountMap — frequency counter / multiset
  println("--- 7. CountMap ---")
  let cm : @countmap.CountMap[String] = @countmap.CountMap::new()
  let _ = cm.increment("apple")
  let _ = cm.increment("banana")
  let _ = cm.increment("apple")
  let _ = cm.increment("cherry")
  let _ = cm.increment("apple")
  println("  Count(\"apple\"): " + cm.get("apple").to_string())
  match cm.most_common() {
    Some(k) => println("  Most common: " + k)
    None => println("  Most common: None")
  }
  println("  Length: " + cm.length().to_string())

  println("\n=== All demos complete ===")
}
