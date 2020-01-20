# Json parsing in Kotlin

## Why Moshi is more reasonable choice rather than Gson?

There are so many reasons, but I think the most important reason is "Kotlin support".

Gson is a Java library and uses reflection to instantiate your classes. This is why you get NPE on non-null values. Moshi understands Kotlin and it supports non-null values, default values, etc.

with Moshi, You can use compile-time code generation to generate adapter classes. This is much faster than the reflection that Gson uses. (You can use reflection in Moshi too, but code gen is highly recommended because of performance and binary size - Moshi's reflection needs additional "kotlin-reflect" module.)

In fact, Moshi is effectively Gson 3.0, because the contributors are almost the same. So why don't we just use it? Personally I was happy with Gson, but for new projects I use Moshi.

You can find more discussions on [this reddit](https://www.reddit.com/r/androiddev/comments/684flw/why_use_moshi_over_gson/).

## Some observations

1. If you're using Kotlin, Moshi is the answer - but make sure you use codegen. Reflection is too slow.
2. Although you should annotate every data classes that you want to serialize, that's not a big deal.
3. kotlinx.serialization is not a viable option, for now.
4. Make sure you don't use codegen and reflection together. If you use reflection then generated adapters are useless.

## References

- [Reddit - Why use Moshi over Gson](https://www.reddit.com/r/androiddev/comments/684flw/why_use_moshi_over_gson/)
- [Beyond Gson — Evaluating JSON Parsers for Android & Kotlin](https://blog.usejournal.com/beyond-gson-evaluating-json-parsers-for-android-kotlin-e7aa4bcc413e)
