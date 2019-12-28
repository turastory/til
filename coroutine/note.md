## Hierarchy

interface CoroutineContext
    interface Element : CoroutineContext

interface ContinuationInterceptor : CoroutineContext.Element

abstract class CoroutineDispatcher : ContinuationInterceptor

### withContext

- Calls the specified suspending block with a given coroutine context, suspends until it completes, and returns the result

### Continuation

-> Continuation is just a callback with some data.

### ContinuationInterceptor

- Marks coroutine context element that intercepts coroutine continuations.

-> Originally ContinuationInterceptor was designed to support specifying which thread the coroutine works on.
-> by using intre

#### interceptContinuation

- Returns continuation that wraps the original [continuation], thus intercepting all resumptions.

-> If this function returns a different continuation from the original one, it is considered "intercepted"

#### releaseInterceptedContinuation

- Invoked for the continuation instance returned by [interceptContinuation] when the original continuation completes and will not be used anymore.

### What is "coroutine framework" exactly?

### What it means "to intercept continuation?"

-> Before resuming any continuation, do something with the continuation.

As you can figure out by looking at the signatures of interceptContinuation() function, If you don't need any interception then you just return given continuation as is. 

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

### How can coroutines framework supports cancellation of coroutines?


