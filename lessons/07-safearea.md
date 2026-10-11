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

- The example's `Scaffold` is the pushed route, so its AppBar shows the back arrow to the lesson list automatically.
- The only addition is `actions: const [LessonInfoButton(lessonId: 7)]` on the AppBar, the button that opens these notes.

## Example

This is the runnable example in `lib/lessons/07_safearea.dart`:

```dart
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
