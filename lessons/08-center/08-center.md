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

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `CenterLesson`.
- The only addition is `actions: const [LessonInfoButton(lessonId: 8)]` on the AppBar, the button that opens these notes.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(id: 8, title: 'Center', notesAsset: '08-center.md');

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: CenterLesson());

void main() => runApp(lessonApp);

/// Lesson 08: Text centered in the available space.
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
