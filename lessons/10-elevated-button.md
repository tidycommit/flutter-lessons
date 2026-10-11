# Lesson 10: ElevatedButton

**Date:** Sep 28, 2026

`ElevatedButton` is a Material button with a filled, slightly raised look, meant for primary actions. It takes an `onPressed` callback and a `child`, usually a `Text`.

Passing `null` for `onPressed` disables the button, and it is drawn greyed out. `ElevatedButton.icon` adds an icon next to the label, and `ElevatedButton.styleFrom(...)` changes colours, padding and shape.

## Key points

- `onPressed: null` means disabled.
- Use `setState` in the callback when the press should change what is shown.
- `TextButton` and `OutlinedButton` are lighter alternatives for secondary actions.

## Code

AppBar title supplied by the teacher; the original full code wasn't available.

```dart
class ElevatedButtonLesson extends StatefulWidget {
  const ElevatedButtonLesson({super.key});

  @override
  State<ElevatedButtonLesson> createState() => _ElevatedButtonLessonState();
}

class _ElevatedButtonLessonState extends State<ElevatedButtonLesson> {
  int _presses = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ElevatedButton')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => setState(() => _presses++),
              child: const Text('Tap me'),
            ),
            const SizedBox(height: 12),
            Text('Pressed $_presses times'),
            const SizedBox(height: 24),
            const ElevatedButton(onPressed: null, child: Text('Disabled')),
          ],
        ),
      ),
    );
  }
}
```

## How it is adapted in this app

- The example's `Scaffold` is the pushed route, so its AppBar shows the back arrow to the lesson list automatically.
- The only addition is `actions: const [LessonInfoButton(lessonId: 10)]` on the AppBar, the button that opens these notes.

## Example

This is the runnable example in `lib/lessons/10_elevated_button.dart`:

```dart
class ElevatedButtonLesson extends StatefulWidget {
  const ElevatedButtonLesson({super.key});

  @override
  State<ElevatedButtonLesson> createState() => _ElevatedButtonLessonState();
}

class _ElevatedButtonLessonState extends State<ElevatedButtonLesson> {
  int _presses = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ElevatedButton'),
        actions: const [LessonInfoButton(lessonId: 10)],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => setState(() => _presses++),
              child: const Text('Tap me'),
            ),
            const SizedBox(height: 12),
            Text('Pressed $_presses times'),
            const SizedBox(height: 24),
            const ElevatedButton(onPressed: null, child: Text('Disabled')),
          ],
        ),
      ),
    );
  }
}
```
