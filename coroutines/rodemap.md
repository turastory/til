# Coroutines rodemap

Version: `1.0`

In this article, I suggest you a rodemap to coroutines. Also this is some sort of todo list that I will use for my study.

## Ideas behind coroutines

There are some theoretical ideas behind coroutines. Understading these concepts will be pretty helpful, although they are not directly related to coroutines.

- Continuation passing style
- Communication sequential processes
- Structured Concurrency
- So why we need coroutines anyway?

## Core concepts

Here I listed interfaces from kotlin.coroutines package, with an intrinsic function suspendCoroutineUninterceptedOrReturn().
Figurig out what they do may significantly improve understanding of the inner works of coroutines.

- Continuation
- CoroutineContext
- ContinuationInterceptor
- suspendCoroutineUninterceptedOrReturn()

  Unfortunately there's no good article about this function, despite of the importance of it.

## kotlinx

There are so many concepts in kotlinx library, but let's try to list them.

- Coroutine builders (launch, async, produce, runBlocking)
- Coroutine dispatchers

  - How does delay() function works?

- Cancellation mechanism

  - Cooperative cancellation

- Exception handling mechanism
- Synchronization primitives (Channel, Mutex)

  - Difference between iterator, sequence, channel

- Processing stream of data (Flow)

  - Context preservation
  - Exception transparency

## Further questions

These questions are from my own curiosity. Given what I have learned so far, I think the possibility of the coroutines is nearly indefinite, as long as you understand the philosophy and the principles of coroutines.

Some questions are not directly related to coroutines, but they are useful to understand the location of coroutines in the technological field. Nevertheless, they are rather heavy concepts, so I don't know if I have enough time to work on it.

- CPS - Can we replace callbacks with suspending functions forever?

  If CPS is just a fancy name of a callback, then why not replace it with a suspending function?

- Can coroutines solve the problem of animations/transitions in modern architectures like MVP, MVVM?

  In MVVM, typically we use ViewModel and LiveData to manage/expose data to View. ViewModel only handles the state of the View, not the animations. Maybe coroutines can help.

- Coroutines with functional paradigm (arrow-kt?)
- Rx vs Coroutines - what's the difference between them, and which one to use?
- Goroutines in Go vs Coroutines in Kotlin
