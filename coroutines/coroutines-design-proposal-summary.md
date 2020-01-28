# Summary of Kotlin Coroutines design proposal

## Goals

- No dependency on a particular implementation of Futures or other such rich library
- Cover equally the "async/await" use case and "generator blocks"
- Make it possible to utilize Kotlin coroutines as wrappers for different existing asynchronous APIs (such as Java NIO, different implementations of Futures, etc).

## What is coroutine?

> A coroutine can be thought as an instance of suspendable computation.
> Coroutines calling each other can form the machinery for **cooperative multitasking**.

### What's the reason that coroutines in Kotlin is so special?

In Kotlin coroutines, there's no special keywords like `async`, `await`, `yield`. They're not primitives in Kotlin. And they can be implemented as a library function, by using only what standard library provides.

## Possible use cases

- Asynchronous computations

  Coroutines can replace callbacks.

- Futures

  Coroutines can represent some possible value in the future.
  Future, Promises or Deferred - can be written using coroutines.

- Generators

  Sequence - a lazy list can be written using coroutines.
  By using suspension mechanism, it is pretty easy to implement what `yield` does.

- Asynchronous UI

  You can easily switch running threads, by using coroutines.
  e.g. Running some IO operation on IO thread, and then show the results on UI thread.

-> In conclusion, Kotlin coroutine is a solution to concurrency. With coroutines and structured concurrency, you can embrace concurrency in your code naturally.

## Concepts

- Continuation interceptor

> We can achieve asynchronous UI using a continuation interceptor

> Lifecycle of coroutine - suspended, resumed, completed.
> Continuation interceptor has an option to intercept and **wrap** the continuation from their **resumption** to the subsequent suspension points.

> The initial code of the coroutine is treated as a resumption of its initial continuation.

- Restricted suspension

For generators use case, there's no need to change its context.


Channels are just sequences with unrestricted suspensions and buffers.

Many concepts regarding channels & mutex comes from Go.

