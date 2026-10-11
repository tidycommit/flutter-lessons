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

- The example's `Scaffold` is the pushed route, so its AppBar shows the back arrow to the lesson list automatically.
- The only addition is `actions: const [LessonInfoButton(lessonId: 3)]` on the AppBar, the button that opens these notes.

## Example

This is the runnable example in `lib/lessons/03_scaffold.dart`:

```dart
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
