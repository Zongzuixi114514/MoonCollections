/// Tests for RingBuffer module.

test "new buffer empty" {
  let rb : @ringbuffer.RingBuffer[Int] = @ringbuffer.RingBuffer::new(5)
  assert_eq!(rb.length(), 0)
  assert_true!(rb.is_empty())
  assert_eq!(rb.capacity(), 5)
}

test "push and pop" {
  let rb : @ringbuffer.RingBuffer[Int] = @ringbuffer.RingBuffer::new(3)
  rb.push(1)
  rb.push(2)
  rb.push(3)
  assert_eq!(rb.length(), 3)
  assert_eq!(rb.pop(), Some(1))
  assert_eq!(rb.pop(), Some(2))
  assert_eq!(rb.pop(), Some(3))
  assert_eq!(rb.pop(), None)
}

test "peek" {
  let rb : @ringbuffer.RingBuffer[String] = @ringbuffer.RingBuffer::new(3)
  rb.push("first")
  rb.push("last")
  assert_eq!(rb.peek(), Some("first"))
  assert_eq!(rb.peek_last(), Some("last"))
}

test "overwrite when full" {
  let rb : @ringbuffer.RingBuffer[Int] = @ringbuffer.RingBuffer::new(3)
  rb.push(1)
  rb.push(2)
  rb.push(3)
  rb.push(4)
  assert_eq!(rb.length(), 3)
  assert_eq!(rb.pop(), Some(2))
  assert_eq!(rb.pop(), Some(3))
  assert_eq!(rb.pop(), Some(4))
}

test "is full" {
  let rb : @ringbuffer.RingBuffer[Int] = @ringbuffer.RingBuffer::new(2)
  assert_false!(rb.is_full())
  rb.push(1)
  rb.push(2)
  assert_true!(rb.is_full())
}

test "clear" {
  let rb : @ringbuffer.RingBuffer[Int] = @ringbuffer.RingBuffer::new(3)
  rb.push(1)
  rb.push(2)
  rb.clear()
  assert_eq!(rb.length(), 0)
  assert_eq!(rb.pop(), None)
}

test "iter" {
  let rb : @ringbuffer.RingBuffer[Int] = @ringbuffer.RingBuffer::new(5)
  rb.push(10)
  rb.push(20)
  rb.push(30)
  let results = []
  for v in rb.iter() {
    results.push(v)
  }
  assert_eq!(results[0], 10)
  assert_eq!(results[1], 20)
  assert_eq!(results[2], 30)
}

test "to array" {
  let rb : @ringbuffer.RingBuffer[Int] = @ringbuffer.RingBuffer::new(5)
  rb.push(100)
  rb.push(200)
  let arr = rb.to_array()
  assert_eq!(arr[0], 100)
  assert_eq!(arr[1], 200)
}

test "circular behavior" {
  let rb : @ringbuffer.RingBuffer[Int] = @ringbuffer.RingBuffer::new(3)
  rb.push(1)
  rb.push(2)
  rb.pop() |> ignore
  rb.push(3)
  rb.push(4)
  let arr = rb.to_array()
  assert_eq!(arr[0], 2)
  assert_eq!(arr[1], 3)
  assert_eq!(arr[2], 4)
}
