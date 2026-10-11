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

- There is no `main()` or `runApp()`. The snippet's `Scaffold` is returned from the `build` method of `FloatingActionButtonLesson`, a `StatelessWidget`.
- That `Scaffold` is the pushed route, so its AppBar shows the back arrow to the lesson list automatically.
- The AppBar gets `actions: const [LessonInfoButton(lessonId: 11)]`, the button that opens these notes.
- `const` is added where the analyzer asks for it, and the code is run through `dart format`. Nothing else changes.

## Example

This is the runnable example in `lib/lessons/11_floating_action_button.dart`:

```dart
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
