# Lesson 16: Stack and Positioned

**Date:** Oct 5, 2026

`Stack` places its children on top of each other, with later children painted above earlier ones. Children that are not positioned are aligned by the Stack's `alignment` (top-left by default) and decide the Stack's size.

`Positioned` pins a child to the Stack's edges using `top`, `right`, `bottom` and `left`. Negative values push it past the edge, which is how badges are made. Stack clips to its bounds by default (`Clip.hardEdge`), so `clipBehavior: Clip.none` is needed for the overhanging part to stay visible.

## Key points

- Order matters: the last child is on top.
- `Positioned` only works as a direct child of a `Stack`.
- Taps on the part drawn outside the Stack are not hit-tested.

## In the app

This snippet has no AppBar of its own, so the app does not invent a title for it. It runs unchanged under a plain AppBar with no title, which holds only the back arrow to the lesson list and the lesson-notes button.

## Example

This is the runnable example in `lib/lessons/16_stack.dart`:

```dart
class StackLesson extends StatelessWidget {
  const StackLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        // Let the badge draw outside the Stack's bounds.
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 180,
            height: 110,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('Product', style: TextStyle(fontSize: 18)),
          ),
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'NEW',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```
