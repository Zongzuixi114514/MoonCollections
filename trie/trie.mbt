/// Trie — a prefix tree for efficient string storage and lookup.
///
/// Supports insertion, deletion, prefix search, and autocomplete suggestions.
/// Uses Int keys (character codes) for HashMap compatibility.

struct TrieNode {
  children : @hashmap.HashMap[Int, TrieNode]
  mut is_end : Bool
  mut count : Int
}

struct Trie {
  mut root : TrieNode
  mut size : Int
}

fn new_node() -> TrieNode {
  {
    children: @hashmap.HashMap([], capacity=4),
    is_end: false,
    count: 0,
  }
}

/// Create a new, empty Trie.
pub fn Trie::new() -> Trie {
  { root: new_node(), size: 0 }
}

/// Insert a word into the Trie. Returns `true` if newly added.
pub fn Trie::insert(self : Trie, word : String) -> Bool {
  let mut node = self.root
  let len = word.length()
  for i in 0..<len {
    let ch = word[i].to_int()
    match node.children.get(ch) {
      Some(_) => ()
      None => node.children.set(ch, new_node())
    }
    match node.children.get(ch) {
      Some(child) => {
        child.count = child.count + 1
        node = child
      }
      None => ()
    }
  }
  if node.is_end {
    false
  } else {
    node.is_end = true
    self.size = self.size + 1
    true
  }
}

/// Check if a word exists in the Trie.
pub fn Trie::contains(self : Trie, word : String) -> Bool {
  match self.search_node(word) {
    Some(node) => node.is_end
    None => false
  }
}

/// Check if any word in the Trie starts with the given prefix.
pub fn Trie::starts_with(self : Trie, prefix : String) -> Bool {
  self.search_node(prefix).is_some()
}

/// Return the number of words in the Trie.
pub fn Trie::length(self : Trie) -> Int {
  self.size
}

/// Return the number of words that have the given prefix.
pub fn Trie::count_prefix(self : Trie, prefix : String) -> Int {
  match self.search_node(prefix) {
    Some(node) => node.count
    None => 0
  }
}

/// Remove a word from the Trie. Returns `true` if the word was present.
pub fn Trie::remove(self : Trie, word : String) -> Bool {
  let len = word.length()
  guard len > 0 && self.size > 0 else { return false }
  let deleted = self.remove_from(self.root, word, 0, len)
  if deleted {
    self.size = self.size - 1
  }
  deleted
}

fn Trie::remove_from(
  self : Trie,
  node : TrieNode,
  word : String,
  index : Int,
  len : Int,
) -> Bool {
  if index == len {
    guard node.is_end else { return false }
    node.is_end = false
    return true
  }
  let ch = word[index].to_int()
  match node.children.get(ch) {
    Some(child) => {
      child.count = child.count - 1
      let result = self.remove_from(child, word, index + 1, len)
      if result && child.children.is_empty() && not(child.is_end) {
        node.children.remove(ch)
      }
      result
    }
    None => false
  }
}

/// Find all words with the given prefix, up to `limit` matches.
pub fn Trie::autocomplete(self : Trie, prefix : String, limit : Int) -> Array[String] {
  let result = []
  match self.search_node(prefix) {
    Some(node) => self.collect_words(node, prefix, result, limit)
    None => ()
  }
  result
}

fn Trie::collect_words(
  self : Trie,
  node : TrieNode,
  prefix : String,
  result : Array[String],
  limit : Int,
) -> Unit {
  if result.length() >= limit {
    return
  }
  if node.is_end {
    result.push(prefix)
  }
  for kv in node.children.iter() {
    if result.length() >= limit {
      return
    }
    let ch = kv.0
    let child = kv.1
    let next_prefix = prefix + ch.unsafe_to_char().to_string()
    self.collect_words(child, next_prefix, result, limit)
  }
}

/// Return all words in the Trie.
pub fn Trie::to_array(self : Trie) -> Array[String] {
  self.autocomplete("", self.size)
}

fn Trie::search_node(self : Trie, word : String) -> TrieNode? {
  let mut node = self.root
  let len = word.length()
  for i in 0..<len {
    let ch = word[i].to_int()
    match node.children.get(ch) {
      Some(child) => node = child
      None => return None
    }
  }
  Some(node)
}

/// Clear all entries from the Trie.
pub fn Trie::clear(self : Trie) -> Unit {
  self.root = new_node()
  self.size = 0
}

/// Implement `Show` for display.
pub impl Show for Trie with fn output(self, logger) -> Unit {
  logger.write_string("Trie(words=")
  logger.write_string(self.size.to_string())
  logger.write_string(")")
}
