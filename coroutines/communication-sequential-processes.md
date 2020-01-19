WIP - This note is highly active.

TODO:

- [ ] Fill in the remaining TBD sections
- [ ] Review the article

# Communication sequential processes (CSP)

When you work with multiple threads of execution(e.g. threads, processes), you should think about synchronization between them.
There are several approaches to the problem(synchronization of threads of execution), and CSP is just one of them.

We will discover what approaches there are, and introduce CSP to another alternative to them.

## Synchronization with shared mutable state

Here's an excerpt from golang blog:

> Traditional threading models require the programmer to communicate between threads using shared memory. Typically, shared data structures are protected by locks, and threads will contend over those locks to access the data. In some cases, this is made easier by the use of thread-safe data structures such as Python's Queue.

-> We need a synchronization to access shared mutable data.

One solution to this problem is to use **thread-safe data structures** like AmoticInteger, etc. This solution works for every context - Threads, Coroutines, whatever, but does not scale to more complex situations.

Another solution is to use thread confinement to limit access to shared mutable state. Typical UI applications use this mechanism to achieve synchronization.

> There are several types (coarse, find-grained, etc.) of parallelism depending on the amount of work performed by each task. See "Wikipedia - Types of parallelism" for more details.

Mutual exclusion is another way. It defines **critical section** that must be executed sequentially.
In Kotlin, there's a class "Mutex" which supports locking/unlocking.

Mutex.lock() is a suspending function, so they don't block the thread.
But as any kind of synchronization comes with the cost, if you do fine-grained synchronization the program will be very show.

## What is CSP?

As stated above, typically when we work with multiple threads of execution, we use **shared mutable states** to communicate between them.

In CSP, instead using shared mutable state, **processes communicate by sending/receiving values from unbuffered channels**. Since there's no buffer in channels, synchronization is automatically established. (Sender send a value and waits until the receiver receives the value. The opposite is also true)

CSP is the idea behind Channels and Actors.

## Channel vs Actor

### Channel

From "Bell Labs and CSP Threads":

> In Hoare's CSP language, processes communicate by sending or receiving values from named unbuffered channels. Since the channels are unbuffered, the send operation blocks until the value has been transferred to a receiver, thus providing a mechanism for synchronization.

-> A channel is just a route which the processes communicate by.

There's no further mention about actors in the article.

### Actor

From "Roman's talk on CSP":

> Actor is another variant of CSP. Actor has "named coroutines", where CSP has "named channels".

> Actor == named coroutine + inbox channel (receiver)

From official coroutines document:

> An actor is an entity made up of a combination of a coroutine, the state that is confined and encapsulated into this coroutine, and a channel to communicate with other coroutines.

> An actor is a coroutine and a coroutine is executed sequentially, so confinement of the state to the specific coroutine works as a solution to the problem of shared mutable state.

> Actor is more efficient than locking under load, because in this case it always has work to do and it does not have to switch to a different context at all.

### What is "confinement" in the above statement?
  
You can achieve confinement by specifying the coroutine context where the coroutine executes.
Since execution of the coroutine is sequential, as stated above, all executions in a single coroutine are guaranteed to be executed on the specified coroutine context.

-> I think this is called "confinement of the state to the specific coroutine" in the above statement.

### Why actor is more efficient than locking?

An actor is essentially a coroutine, so they don't have to perform context switch. This is obvious.

What is not obvious is this statement: "it always has work to do".

Think about what actor is. It's a coroutine, **with inbox channel**. And when there's no message in the inbox, the coroutine does not run at all.
Which means, on the other hand, when the coroutine is running, it means that a message was received.

So when an actor is active, there should be a message - a task to do.

### Why we need shared mutable state in the first place? Why dominant programming languages didn't follow CSP in the first place?

TBD - I've posted a question about it in computer science community.

## Thoughts about concurrency

Here's some interesting quotes from "Bell Labs and CSP Threads"

> Concurrent programming in this style is interesting for reasons not of efficiency but of clarity. That is, it is a widespread mistake to think only of concurrent programming as a means to increase performance.

> Such advantages are important but not relevant to this discussion. After all, they can be realized in other styles, such as asynchronous event-driven programming.

> Instead, we are interested in concurrent programming because it provides a natural abstraction that can make some programs much simpler.

Usually we think that the concurrency increases performance and complexity together. But he says that the concurrency can make some programs much simpler.

## References

- [Bell Labs and CSP Threads](https://swtch.com/~rsc/thread/)
- [Roman's talk on CSP](https://youtu.be/YrrUCSi72E8?t=2192)
- [Arguments on R. Pike's quote](https://stackoverflow.com/questions/36391421/explain-dont-communicate-by-sharing-memory-share-memory-by-communicating)
- [Share memory by communicating - Golang blog](https://blog.golang.org/share-memory-by-communicating)
- [Wikipedia - Types of parallelism](https://en.wikipedia.org/wiki/Granularity_(parallel_computing)#Types_of_parallelism)
- [Course vs fine-grained synchronization](https://blog.georgovassilis.com/2014/02/04/on-coarse-vs-fine-grained-synchronization/)
