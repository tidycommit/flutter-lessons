# Lesson 07: SafeArea

**Date:** Sep 25, 2026

Phones have areas the app can draw under but should not put content in: the status bar, camera notches, rounded corners and the home indicator. `SafeArea` reads these insets from `MediaQuery` and pads its child so nothing important is hidden.

You can turn individual sides off with `top`, `bottom`, `left` and `right`. On this lesson screen the `AppBar` already handles the top inset, so on a phone you mostly see the bottom edge move. In a browser the insets are usually zero.

## Key points

- Wrap screen content in `SafeArea` when there is no `AppBar` handling the top.
- `SafeArea` only adds padding; it does not change colours.
- The insets come from `MediaQuery.paddingOf(context)`.

## Code

AppBar title supplied by the teacher; the original full code wasn't available.

```dart
class SafeAreaLesson extends StatelessWidget {
  const SafeAreaLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hello')),
      body: SafeArea(
        child: Container(
          color: Colors.orange,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(24),
          child: const Text(
            'This box stays clear of notches, status bars and the home '
            'indicator.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
```

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `SafeAreaLesson`.
- The only addition is `actions: const [LessonInfoButton(lessonId: 7)]` on the AppBar, the button that opens these notes.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 7,
  title: 'SafeArea',
  notesAsset: '07-safearea.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: SafeAreaLesson());

void main() => runApp(lessonApp);

/// Lesson 07: A screen whose body is wrapped in SafeArea.
class SafeAreaLesson extends StatelessWidget {
  const SafeAreaLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello'),
        actions: const [LessonInfoButton(lessonId: 7)],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.orange,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(24),
          child: const Text(
            'This box stays clear of notches, status bars and the home '
            'indicator.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
```
