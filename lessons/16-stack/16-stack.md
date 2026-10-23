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

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `StackLesson`.
- The snippet's `Scaffold` is returned from the `build` method of `StackLesson`, a `StatelessWidget`.
- The AppBar gets `actions: const [LessonInfoButton(lessonId: 16)]`, the button that opens these notes.
- `const` is added where the analyzer asks for it, and the code is run through `dart format`. Nothing else changes.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 16,
  title: 'Stack and Positioned',
  notesAsset: '16-stack.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: StackLesson());

void main() => runApp(lessonApp);

/// Lesson 16: A blue box with a red 'NEW' badge that hangs over its corner.
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
