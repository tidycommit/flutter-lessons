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

- There is no `main()` or `runApp()`. The snippet's `Scaffold` is returned from the `build` method of `SnackBarLesson`, a `StatelessWidget`.
- That `Scaffold` is the pushed route, so its AppBar shows the back arrow to the lesson list automatically.
- The AppBar gets `actions: const [LessonInfoButton(lessonId: 19)]`, the button that opens these notes.
- `const` is added where the analyzer asks for it, and the code is run through `dart format`. Nothing else changes.

## Example

This is the runnable example in `lib/lessons/19_snack_bar.dart`:

```dart
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
