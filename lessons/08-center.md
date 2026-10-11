# Lesson 08: Center

**Date:** Sep 26, 2026

`Center` positions its child in the middle of the space it is given. It is a shortcut for `Align(alignment: Alignment.center)`.

By default `Center` grows as large as its parent allows, so the child ends up in the middle of the screen or panel. If you set `widthFactor` or `heightFactor`, the `Center` instead sizes itself to a multiple of the child's size.

## Key points

- `Center` centers on both axes.
- Use `Align` when you need another position, such as `Alignment.bottomRight`.
- A `Container` with `alignment: Alignment.center` centers its own child the same way.

## Code

AppBar title supplied by the teacher; the original full code wasn't available.

```dart
class CenterLesson extends StatelessWidget {
  const CenterLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Center')),
      body: const Center(child: Text('Hello, Flutter!')),
    );
  }
}
```

## How it is adapted in this app

- The example's `Scaffold` is the pushed route, so its AppBar shows the back arrow to the lesson list automatically.
- The only addition is `actions: const [LessonInfoButton(lessonId: 8)]` on the AppBar, the button that opens these notes.

## Example

This is the runnable example in `lib/lessons/08_center.dart`:

```dart
class CenterLesson extends StatelessWidget {
  const CenterLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Center'),
        actions: const [LessonInfoButton(lessonId: 8)],
      ),
      body: const Center(child: Text('Hello, Flutter!')),
    );
  }
}
```
