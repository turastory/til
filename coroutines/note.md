# Coroutines Note

Q. Why intercepted() is an instrinsic function?

> More investigation is needed.

`intercepted()` could be implemented as:

```
suspend fun Continuation.intercepted() =
    coroutineContext[ContinuationInterceptor]?.interceptContinuation(this) ?: this
```

- If there's interceptor in coroutine context, then returns intercepted continuation.
- If there's no interceptor, then returns itself immediately.

Q. Why suspendCoroutineUninterceptedOrReturn() is an instrinsic function?

> It needs to access a parameter that is added at compile time - a `Continuation` to **all** suspend functions

Q. Differences between start/suspend/createCoroutine

### References

Coroutines proposal: https://github.com/Kotlin/KEEP/blob/master/proposals/coroutines.md

### Core concepts

> These interfaces are in kotlin.coroutines package.

interface Continuation<T>

interface CoroutineContext
    interface Element : CoroutineContext

interface ContinuationInterceptor : CoroutineContext.Element



### Structured Concurrency

http://250bpm.com/blog:71

### withContext

- Calls the specified suspending block with a given coroutine context, suspends until it completes, and returns the result.

### Continuation

-> Continuation is just a callback with some data.

### ContinuationInterceptor

- Marks coroutine context element that intercepts coroutine continuations.

#### interceptContinuation

- Returns continuation that wraps the original [continuation], thus intercepting all resumptions.

-> If this function returns a different continuation from the original one, it is considered "intercepted"

#### releaseInterceptedContinuation

- Invoked for the continuation instance returned by [interceptContinuation] when the original continuation completes and will not be used anymore.

#### What it means "to intercept continuation?"

-> Before resuming any continuation, do something with the continuation.

As you can figure out by looking at the signatures of interceptContinuation() function, If you don't need any interception then you just return given continuation as is. 

CoroutineDispatcher uses this mechanism to change the running environment of the coroutine.

### Communicating Sequential Processes (CSP)

Typically when we work with multiple processes(threads, or something like that), we use (shared mutable state) to communicate between them.

In CSP, instead using shared mutable state, processes communicate by sending/receiving values from unbuffered channels. Since there's no buffer in channels, synchronization is automatically established.

CSP is the idea behind Channels and Actors.

Interesting statements.. from this post: https://swtch.com/~rsc/thread/
> It is a widespread mistake to think only of concurrent programming as a means to increase performance.
> Such advantages are important but not relevant to this discussion. After all, they can be realized in other styles, such as asynchronous event-driven programming.
> Instead, we are interested in concurrent programming because it provides a natural abstraction that can make some programs much simpler.

References:

- https://youtu.be/YrrUCSi72E8?t=2192
- https://stackoverflow.com/questions/36391421/explain-dont-communicate-by-sharing-memory-share-memory-by-communicating
- https://blog.golang.org/share-memory-by-communicating

### What is "coroutine framework" exactly?

### How delay() function works?

There's an interface called Delay, and it has one suspend function `delay()`. In the simplest form, it looks like this:

```
public interface Delay {
    suspend fun delay(time: Long) = suspendCancellableCoroutine { scheduleResumeAfterDelay(time, it) }
    fun scheduleResumeAfterDelay(timeMillis: Long, continuation: CancellableContinuation<Unit>)
}
```

Here's two things to observe.

1. What is scheduleResumeAfterDelay? It schedules resumption of given continuation after specified delay.  This function is declared as abstract, and concrete implementation of Delay interface should provide the implementation.
2. It uses suspendCancellableCoroutine function. So first it suspends the execution of the coroutine, and the implemtation of scheduleResumeAfterDelay must resume given continuation at some point.

Most of derived classes of CoroutineDispatcher implements it. so top-level suspend function delay probes context of continuation to retrieve Delay interface, and invoke scheduleResumeAfterDelay() just like I mentioned above.

```
public suspend fun delay(timeMillis: Long) {
    if (timeMillis <= 0) return
    return suspendCancellableCoroutine { cont: CancellableContinuation<Unit> ->
        cont.context.delay.scheduleResumeAfterDelay(timeMillis, cont)
    }
}

internal val CoroutineContext.delay: Delay get() = get(ContinuationInterceptor) as? Delay ?: DefaultDelay
```

### How to achieve processing stream of data?

Ok. So we can sending a one-shot request and get back response. Also we can send multiple requests onces by starting multiple coroutines, and await/join them.

### Channel

> Channels are "communication primitives" that allow us to pass data between different coroutines. One coroutine can send some information to a channel, while the other one can receive this information from it.

> Deferred values provide a convenient way to transfer a single value between coroutines. Channels provide a way to transfer a stream of values.

> A Channel is conceptually "very similar to BlockingQueue". One key difference is that instead of a blocking put operation, it has a suspending send, and instead of a blocking take operation it has a suspending receive.

-> So Channel is coroutine-style version of BlockingQueue. It reminds me cold observable - when there's no observer, observable don't emit any item.

```
interface SendChannel<in E> {
    suspend fun send(element: E)
    fun close(): Boolean
}

interface ReceiveChannel<out E> {
    suspend fun receive(): E
}

interface Channel<E> : SendChannel<E>, ReceiveChannel<E>
```

#### Types of Channels

- Unlimited Channel
  There's no limit in the buffer of send channel.
  -> send() call never suspends.
  It corresponds to cold Observable<T> in Rx? [More research needed]

- Buffered Channel
  Channels size is constrained by the specified number.
  -> When the channel is full, send() suspends until more free space appears.
  It corresponds to cold Flowable<T> with Buffer strategy in Rx? [More research needed]

- Randezvous Channel
  There's no buffer at all.
  send() call but no receive() call -> suspends
  no send() call but receive() call -> suspends
  rendezvous -> meaning that send and receive should meet on time.
  It corresponds to cold.. Single? [More research needed]

- Conflated Channel
  A new element send to this channel will overwrite the existing element.
  -> ReceiveChannel will always get the latest element.
  send() call never suspends.

Although those channels above are similar to reactive streams in Rx, they're not actual reactive streams at all, rather they are considered some primitives to build reactive streams upon them.

#### What happens if call send() and receive() in the same scope? 

So consider following case:

```
launch {
    val channel = Channel<Int>()
    repeat(5) {
        channel.send(it + 1)
    }
    repeat(5) {
        val value = channel.receive()
        println(value * value)
    }
}
```

What happens in this case? The answer is: this coroutine suspends and never resumed. Why? It's embarrassingly simple.

When we first call channel.send(1), because the channel is randezvous channel, this whole coroutine suspends and that's it! Nothing happens.

You can add some buffers to the channel to resolve this suspension:

```
val channel = Channel<Int>(10)
```

But it will freeze too when the number of sending elements exceeds the size of the buffer. You may use unlimited buffer not to suspend send() call at all, but then you will lose the buffer.

The most recommended solution is to use different coroutines for channels:

```
coroutineScope {
    val channel = Channel<Int>()
    repeat(5) {
        // (1)
        launch {
            channel.send(it + 1)
        }
    }
    repeat(5) {
        val value = channel.receive()
        println(value * value)
    }
}
```

See (1). You can see for each operation it creates and starts a new coroutine.
It is not necessary but by doing this, you can achieve concurrency - When we meet channel.send(it + 1), because the channel is randezvous, we suspends the coroutine. So after first repeat, 5 coroutines are suspended at that moment.
For second repeat, each receive() call resumes suspended coroutines one-by-one, and eventually prints all values.

#### BroadcastChannel

Another type of channel is BroadcastChannel, which is a variant of SendChannel that can have multiple receivers.

receive() call behaves just like a regular channel, but send() call to BroadcastChannel never suspends.

And there's no randezvous and unlimited type.

### How can we achieve hot/cold observable by using coroutines?

### Iterator vs Sequence

> The key difference lies in the semantics and the implementation of the stdlib extension functions for Iterable<T> and Sequence<T>

For Sequence<T>, intermediate operation works lazily as possible. For Iterable<T>, intermediate operation works eagerly.

Laziness is less performant for smaller and more commonly used collections, because of locality of reference. So in Kotlin collections are not lazy by default, and laziness is extracted to the Sequence<T> interface.

Another difference between these two is the order of execution of operations. For Sequence<T>, intermediate operation works one-by-one - filter-map-filter-map. For Iterable<T>, intermediate operation works all-at-once - filter-filter-map-map.

### Iterator vs Channel

### Cooperative Cancellation?

It means in order to cancellation works, all coroutines have to cooperate with each other.

So even though one makes cancel() call, that job might still active until the computation is done. See the following example:

```
val startTime = System.currentTimeMillis()
val job = launch(Dispatchers.Default) {
    var nextPrintTime = startTime
    var i = 0
    while (i < 5) {
        if (System.currentTimeMillis() >= nextPrintTime) {
            println("job: I'm sleeping ${i++} ...")
            nextPrintTime += 500L
        }
    }
}
delay(1300L) // delay a bit
// Even though we call cancelAndJoin(), job is active until the useless computation above finishes.
job.cancelAndJoin()
```

We can use Job#isActive property to check if the job is cancelled/completed or not. So adding isActive to the condition would work:

```
while (i < 5 && isActive) {
    // ...
}
```

Additionally, you can clean up resources on cancellation. Cancellable suspending functions throw CancelllationException on cancellation, so we can use try {} finally {} expression to do finalization actions:

```
try {
    // while ...
} finally {
    // Clean up resources
}
```

-> This is "cooperative" cancellation. A coroutine is aware that cancellation can always happen at any time, and knows how to clean up resources when it is cancelled.
-> Though more details are unknown in this point. More research is needed on how cancellation of coroutines works in the lowest level.

### How can coroutines framework supports cancellation of coroutines? (WIP)

See CancellableContinuation<T> - which has an additional function cancel(). kotlinx.coroutines function `suspendCancellableCoroutine` and its variants use CancellableContinuation to support cancellation behavior.

CancellableContinuationImpl - which is an implementaiton of CancellableContinuation also implements DispatchedTask.

When cancellation happens, it throws CancellationException.

First, it makes existing coroutine to stop.
Coroutines framework handle this exception as a normal completion.

### What does yield() do exactly?

### Composing suspending functions

- Default -> Sequential
  ```
  doSomething() + doAnother()
  ```

- async -> Concurrent
  ```
  val one = doSomething()
  val two = doAnother()
  one.await() + two.await()
  ```
  
  with structured concurrency:
  ```
  coroutineScope {
      val one = doSomething()
      val two = doAnother()
      one.await() + two.await()
  }
  ```

### Flow

> "A cold asynchronous data stream" that sequentially emits values and completes normally or with an exception.

#### Context Preservation

> Context preservation - Collection of a flow always happens in the context of the calling coroutine.

Normally we use withContext to change the context where the coroutine runs. But due to context preservation, we cannot use inside of flow builder. (More technically, flow emission is not permitted to happen in different context from the consumers' context)

To change the context of the flow emission, you shall use flowOn() intermediate operator. Here's the behavior of flowOn():

- Changes the context of the upstream operations.
- Does not change the context of the downstream operations.

```
withContext(Dispatchers.Main) {
    val flow = flow { } // executed in Default
        .filter { } // executed in Default
        .flowOn(Dispatchers.Default)
        .transform { } // executed in IO
        .map { } // executed in IO
        .flowOn(Dispatchers.IO)
        .collect { } // executed in Main
}
```

This behavior makes easy to utilize coroutine functions in UI programming, such as Android development. If you use flowOn operator in remote(api) module, then there's no need to specify dispatchers in caller side.

But how can flowOn() change the context of flow emission exactly? Let's dig into this.

#### Inner works of flowOn()

According to docs, it says:

> The flowOn operator creates another coroutine for an upstream flow when it has to change the CoroutineDispatcher in its context.

#### Difference between safe/unsafe flow






