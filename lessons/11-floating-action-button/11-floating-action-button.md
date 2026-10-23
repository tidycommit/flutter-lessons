# Lesson 11: FloatingActionButton

**Date:** Sep 29, 2026

A `FloatingActionButton` (FAB) is a round button that floats above the content for the main action on a screen, such as adding an item. You give it to a `Scaffold` through the `floatingActionButton` slot, and the Scaffold places it in the bottom-right corner by default.

In this lesson `onPressed` is an empty function, so tapping the button shows a ripple but changes nothing; a real app would put the screen's main action there. In real apps, also set `tooltip` so the button has a label for screen readers and long presses. `FloatingActionButton.extended` shows a label next to the icon, and `floatingActionButtonLocation` on the Scaffold moves it.

## Key points

- Use at most one FAB per screen, for the primary action.
- The FAB belongs in the Scaffold slot, not in the body.
- Set a `tooltip` in real apps (the lesson snippet leaves it out).

## Code

Original snippet as taught:

```dart
Scaffold(
  appBar: AppBar(title: Text('FAB Tip')),
  body: Center(child: Text('Tap the + button')),
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: Icon(Icons.add),
  ),
)
```

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `FloatingActionButtonLesson`.
- The snippet's `Scaffold` is returned from the `build` method of `FloatingActionButtonLesson`, a `StatelessWidget`.
- The AppBar gets `actions: const [LessonInfoButton(lessonId: 11)]`, the button that opens these notes.
- `const` is added where the analyzer asks for it, and the code is run through `dart format`. Nothing else changes.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 11,
  title: 'FloatingActionButton',
  notesAsset: '11-floating-action-button.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: FloatingActionButtonLesson());

void main() => runApp(lessonApp);

/// Lesson 11: A Scaffold with a FloatingActionButton.
class FloatingActionButtonLesson extends StatelessWidget {
  const FloatingActionButtonLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAB Tip'),
        actions: const [LessonInfoButton(lessonId: 11)],
      ),
      body: const Center(child: Text('Tap the + button')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
```
