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

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `ElevatedButtonLesson`.
- The only addition is `actions: const [LessonInfoButton(lessonId: 10)]` on the AppBar, the button that opens these notes.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 10,
  title: 'ElevatedButton',
  notesAsset: '10-elevated-button.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: ElevatedButtonLesson());

void main() => runApp(lessonApp);

/// Lesson 10: An enabled ElevatedButton that counts presses and a disabled one.
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
