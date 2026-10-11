# Lesson 16: Stack and Positioned

**Date:** Oct 5, 2026

`Stack` places its children on top of each other, with later children painted above earlier ones. Children that are not positioned are aligned by the Stack's `alignment` (top-left by default) and decide the Stack's size.

`Positioned` pins a child to the Stack's edges using `top`, `right`, `bottom` and `left`. Negative values push it past the edge, which is how badges are made. Stack clips to its bounds by default (`Clip.hardEdge`), so `clipBehavior: Clip.none` is needed for the overhanging part to stay visible.

## Key points

- Order matters: the last child is on top.
- `Positioned` only works as a direct child of a `Stack`.
- Taps on the part drawn outside the Stack are not hit-tested.

## Code

Original snippet as taught:

```dart
Scaffold(
  appBar: AppBar(title: Text('Stack')),
  body: Center(
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(width: 200, height: 200, color: Colors.blue),
        Positioned(
          top: -12,
          right: -12,
          child: Container(
            padding: EdgeInsets.all(6),
            color: Colors.red,
            child: Text('NEW', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    ),
  ),
)
```

## How it is adapted in this app

- There is no `main()` or `runApp()`. The snippet's `Scaffold` is returned from the `build` method of `StackLesson`, a `StatelessWidget`.
- That `Scaffold` is the pushed route, so its AppBar shows the back arrow to the lesson list automatically.
- The AppBar gets `actions: const [LessonInfoButton(lessonId: 16)]`, the button that opens these notes.
- `const` is added where the analyzer asks for it, and the code is run through `dart format`. Nothing else changes.

## Example

This is the runnable example in `lib/lessons/16_stack.dart`:

```dart
class StackLesson extends StatelessWidget {
  const StackLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stack'),
        actions: const [LessonInfoButton(lessonId: 16)],
      ),
      body: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(width: 200, height: 200, color: Colors.blue),
            Positioned(
              top: -12,
              right: -12,
              child: Container(
                padding: const EdgeInsets.all(6),
                color: Colors.red,
                child: const Text('NEW', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```
