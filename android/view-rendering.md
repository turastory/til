# View Rendering

Notes about Android view system.

## Rendering sequence

- onMeasure()
- onLayout()
- onDraw()

## onMeasure

In onMeasure(), two measure specs are provided for width and height.

onMeasure() could be called multiple times by its parent, for measuring proper size of the view.

### MeasureSpec

MeasureSpec is the combination of size and mode bits, for avoiding object creation.

Size is just an int value in pixels, while Mode is a little bit complex concept.

There are 3 modes:

- EXACTLY: View should be exactly the size specified. For example, "64dp" or "match_parent"
- AT_MOST: View can be as big as much it wants, **up to specified size**. e.g. "wrap_content", "match_parent"
- UNSPECIFIED: View can be **as big as it wants**.

-> Although there are some examples of each mode, it doesn't mean that those examples always provide the same modes. For example, when you specify "wrap_content" for the child view, then first onMeasure() receives AT_MOST with parent's size. After that, onMeasure() may receives EXACTLY or AT_MOST again, to accurately measure how the size of the view is.

### setMeasuredDimension

By calling setMeasuredDimension() in onMeasure() method, you can confirm the size of the view. If you don't call it in onMeasure(), then an exception is thrown.
