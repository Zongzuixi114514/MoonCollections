///|
/// RingBuffer — a fixed-size circular queue.
///
/// When full, new writes overwrite the oldest data. Useful for streaming
/// windows, log buffers, and sliding-window algorithms.
struct RingBuffer[T] {
  data : Array[T?]
  mut head : Int
  mut tail : Int
  mut count : Int
  capacity : Int
}

///|
/// Create a new RingBuffer with the given capacity.
pub fn[T] RingBuffer::new(capacity : Int) -> RingBuffer[T] {
  {
    data: Array::makei(capacity, fn(_) { Option::None }),
    head: 0,
    tail: 0,
    count: 0,
    capacity,
  }
}

///|
/// Push an element. If full, overwrites the oldest element.
pub fn[T] RingBuffer::push(self : RingBuffer[T], value : T) -> Unit {
  self.data[self.tail] = Some(value)
  self.tail = (self.tail + 1) % self.capacity
  if self.count < self.capacity {
    self.count = self.count + 1
  } else {
    self.head = (self.head + 1) % self.capacity
  }
}

///|
/// Remove and return the oldest element.
pub fn[T] RingBuffer::pop(self : RingBuffer[T]) -> T? {
  guard self.count > 0 else { return None }
  let value = self.data[self.head]
  self.data[self.head] = Option::None
  self.head = (self.head + 1) % self.capacity
  self.count = self.count - 1
  value
}

///|
/// Peek at the oldest element without removing it.
pub fn[T] RingBuffer::peek(self : RingBuffer[T]) -> T? {
  guard self.count > 0 else { return None }
  self.data[self.head]
}

///|
/// Peek at the newest element without removing it.
pub fn[T] RingBuffer::peek_last(self : RingBuffer[T]) -> T? {
  guard self.count > 0 else { return None }
  let idx = if self.tail == 0 { self.capacity - 1 } else { self.tail - 1 }
  self.data[idx]
}

///|
/// Return the number of elements in the buffer.
pub fn[T] RingBuffer::length(self : RingBuffer[T]) -> Int {
  self.count
}

///|
/// Check if the buffer is empty.
pub fn[T] RingBuffer::is_empty(self : RingBuffer[T]) -> Bool {
  self.count == 0
}

///|
/// Check if the buffer is full.
pub fn[T] RingBuffer::is_full(self : RingBuffer[T]) -> Bool {
  self.count == self.capacity
}

///|
/// Return the capacity of the buffer.
pub fn[T] RingBuffer::capacity(self : RingBuffer[T]) -> Int {
  self.capacity
}

///|
/// Remove all elements from the buffer.
pub fn[T] RingBuffer::clear(self : RingBuffer[T]) -> Unit {
  for i in 0..<self.capacity {
    self.data[i] = Option::None
  }
  self.head = 0
  self.tail = 0
  self.count = 0
}

///|
/// Return an iterator over elements from oldest to newest.
pub fn[T] RingBuffer::iter(self : RingBuffer[T]) -> Iter[T] {
  let mut i = 0
  let total = self.count
  Iter::new(fn() {
    while i < total {
      let idx = (self.head + i) % self.capacity
      i = i + 1
      match self.data[idx] {
        Some(v) => return Some(v)
        None => ()
      }
    } nobreak {
      None
    }
  })
}

///|
/// Return all elements as an array, oldest first.
pub fn[T] RingBuffer::to_array(self : RingBuffer[T]) -> Array[T] {
  let result : Array[T] = []
  for v in self.iter() {
    result.push(v)
  }
  result
}

///|
/// Implement `Show` for display.
pub impl[T] Show for RingBuffer[T] with fn output(self, logger) -> Unit {
  logger.write_string("RingBuffer(len=")
  logger.write_string(self.count.to_string())
  logger.write_string(", cap=")
  logger.write_string(self.capacity.to_string())
  logger.write_string(")")
}
