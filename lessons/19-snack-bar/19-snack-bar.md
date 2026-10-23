# Lesson 19: SnackBar

**Date:** Oct 8, 2026

A `SnackBar` is a short message that slides in at the bottom of the screen and disappears after a few seconds. You show one through the `ScaffoldMessenger`, which `MaterialApp` creates for you: `ScaffoldMessenger.of(context).showSnackBar(...)`.

Because the messenger sits above every route, the snack bar is not lost if the user navigates while it is showing. The snippet wraps the button in a `Builder`, a habit from the older `Scaffold.of(context)` API, which needed a `context` below the Scaffold; `ScaffoldMessenger.of(context)` works without it. A `SnackBar` can also carry a `SnackBarAction`, such as Undo, and its `duration` can be changed.

## Key points

- Use `ScaffoldMessenger.of(context)`, not the older `Scaffold.of(context).showSnackBar`.
- Keep the message short and confirm what just happened.
- Call `hideCurrentSnackBar()` to dismiss one early.

## Code

Original snippet as taught:

```dart
Scaffold(
  appBar: AppBar(title: Text("SnackBar")),
  body: Center(
    child: Builder(
      builder: (context) => ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Saved!")),
          );
        },
        child: Text("Save"),
      ),
    ),
  ),
)
```

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `SnackBarLesson`.
- The snippet's `Scaffold` is returned from the `build` method of `SnackBarLesson`, a `StatelessWidget`.
- The AppBar gets `actions: const [LessonInfoButton(lessonId: 19)]`, the button that opens these notes.
- `const` is added where the analyzer asks for it, and the code is run through `dart format`. Nothing else changes.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 19,
  title: 'SnackBar',
  notesAsset: '19-snack-bar.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: SnackBarLesson());

void main() => runApp(lessonApp);

/// Lesson 19: A Save button that shows a 'Saved!' SnackBar.
class SnackBarLesson extends StatelessWidget {
  const SnackBarLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SnackBar"),
        actions: const [LessonInfoButton(lessonId: 19)],
      ),
      body: Center(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Saved!")));
            },
            child: const Text("Save"),
          ),
        ),
      ),
    );
  }
}
```
