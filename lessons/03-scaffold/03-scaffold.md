# Lesson 03: Scaffold

**Date:** Sep 21, 2026

`Scaffold` implements the basic Material page layout. It has named slots for the common parts of a screen: `appBar` at the top, `body` in the middle, and optional pieces such as `floatingActionButton`, `drawer` and `bottomNavigationBar`.

You fill only the slots you need and the Scaffold positions them for you. It also gives descendants a place to show snack bars and bottom sheets. The example fills the `appBar`, `body` and `bottomNavigationBar` slots so each one is easy to see.

## Key points

- `appBar` usually holds an `AppBar` with a title and actions.
- `body` takes the remaining space between the top and bottom bars.
- Most screens in an app start with a `Scaffold`.

## Code

AppBar title supplied by the teacher; the original full code wasn't available.

```dart
class ScaffoldLesson extends StatelessWidget {
  const ScaffoldLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My page')),
      body: const Center(child: Text('The body fills the space in between.')),
      bottomNavigationBar: const BottomAppBar(
        child: Center(child: Text('Bottom app bar')),
      ),
    );
  }
}
```

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `ScaffoldLesson`.
- The only addition is `actions: const [LessonInfoButton(lessonId: 3)]` on the AppBar, the button that opens these notes.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 3,
  title: 'Scaffold',
  notesAsset: '03-scaffold.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: ScaffoldLesson());

void main() => runApp(lessonApp);

/// Lesson 03: A Scaffold with an AppBar, a body and a bottom bar.
class ScaffoldLesson extends StatelessWidget {
  const ScaffoldLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My page'),
        actions: const [LessonInfoButton(lessonId: 3)],
      ),
      body: const Center(child: Text('The body fills the space in between.')),
      bottomNavigationBar: const BottomAppBar(
        child: Center(child: Text('Bottom app bar')),
      ),
    );
  }
}
```
