# Coroutines rodemap

In this article, I suggest you a rodemap to coroutines. Also this is some sort of todo list that I will use for my study.

## Ideas behind coroutines

There are some theoretical ideas behind coroutines. Understading these concepts will be pretty helpful, although they are not directly related to coroutines.

- [ ] Continuation passing style
- [ ] Communication sequential processes
- [ ] Structured Concurrency

## Core concepts

Here I listed interfaces from kotlin.coroutines package, with an intrinsic function suspendCoroutineUninterceptedOrReturn(). Figurig out what they do may significantly improve understanding of the inner works of coroutines.

- [ ] Continuation
- [ ] CoroutineContext
- [ ] ContinuationInterceptor
- [ ] suspendCoroutineUninterceptedOrReturn()
  Unfortunately there's no good article about this function, despite of the importance of it.

## kotlinx

There are so many concepts in kotlinx library, but let's try to list them.

- [ ] Coroutine builders (launch, async, produce, runBlocking)
- [ ] Coroutine dispatchers
  - [ ] How does delay() function works?
- [ ] Cancellation mechanism
  - [ ] Cooperative cancellation
- [ ] Exception handling mechanism
- [ ] Synchronization primitives (Channel, Mutex)
  - [ ] Difference between iterator, sequence, channel
- [ ] Processing stream of data (Flow)
  - [ ] Context preservation
  - [ ] Exception transparency
