# Event Loop

Node runs the script from top to bottom.

Once node starts, it runs the script from top to bottom, and if there's no non-blocking calls, it simply exists. Otherwise, non-blocking calls cause the event loop to run until there're no more callbacks.





### Phases

There are multiple "phases" in the event loop. Each phase has a FIFO queue of callbacks to execute.

#### timers

The timer phase executes callbacks which do something after certain amount of time. We can register these callbacks using `setTimeout()` or `setInterval()`, etc.

#### pending

The pending phase executes callbacks for some system operations such as types of TCP errors.

#### Idle, Prepare

These phases are used internally.

#### poll

The poll phase calculates how long will it block for I/O and executes callbacks in poll queue.

#### check

We can execute callbacks immediately after the poll phase has completed. These kinds of callbacks are set using `setImmediate()`.

##### Notes on `setImmediate()`

The main advantage to use `setImmediate()` is that, the callback will always be executed before any timers, *if they're scheduled witin I/O cycle*.

Here's an answer on the condition in the last clause: https://stackoverflow.com/questions/56153710/why-settimeout-and-setiimidiate-are-deterministic-only-in-io-cycle

Shortly speaking, it is because of the design of `libuv` whom Node uses for event loop and asychronous bevahiors.

#### close

If a socket or handle is closed unexpectedly, "close" event will be emiited in this phase.

#### Relationships

There're 7 types of phases above, and only 3 phases has their own task queue: **timers**, **poll**, and **check**.

We could observe the following facts about their relationships:

Here's a brief summary of the overall behavior.

- event loop waits for callbacks to be added to poll queue. Once the callback is added, execute it.
- If check queue is not empty, executes callbacks in check queue after completing the poll queue.
- If poll queue is empty and timers are set, check the timers if they've reached the thresholds. If any timer is ready, event loop will get to timers phase and execute the corresponding callback.



### `process.nextTick`

`process.nextTick()` put a new callback to the enclosing task's microtask queue.

> `process.nextTick()` is not part of the event loop. `nextTickQueue` will be processed after the current operation is completed, regardless of the current phase of the event loop.

Because of this behavior, **`process.nextTick()` may prevents the event loop from reaching the poll phase.** Depite of this problem, by using `process.nextTick()`, we can ensure certain code blocks are executed **after the user's code**, *and* **before the event loop proceeds**.

Here're some use cases: https://nodejs.org/en/docs/guides/event-loop-timers-and-nexttick/#why-use-process-nexttick

##### Notes on `process.nextTick()` and `setImmediate()`

- `process.nextTick()` fires immediately on the same phase
- `setImmediate()` fires on the following iteration or 'tick' of the event loop

> *We recommend developers use `setImmediate()` in all cases because it's easier to reason about.*