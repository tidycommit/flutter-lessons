# Lesson 02: StatefulWidget counter

**Date:** Sep 20, 2026

A `StatefulWidget` is split into two classes. The widget itself is immutable and only creates a `State` object. The `State` object lives across rebuilds and holds data that can change, such as a counter.

To change that data, wrap the change in `setState()`. This tells Flutter the state is dirty, so `build` runs again and the new value appears on screen. Changing a field without `setState()` updates the value but not the UI.

## Key points

- Keep mutable fields in the `State` class, not in the widget.
- Call `setState()` with the change that should trigger a rebuild.
- Private names like `_count` keep state details inside the file.

## Code

AppBar title supplied by the teacher; the original full code wasn't available.

```dart
class StatefulCounterLesson extends StatefulWidget {
  const StatefulCounterLesson({super.key});

  @override
  State<StatefulCounterLesson> createState() => _StatefulCounterLessonState();
}

class _StatefulCounterLessonState extends State<StatefulCounterLesson> {
  int _count = 0;

  void _increment() {
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('You have pressed the button this many times:'),
            Text('$_count', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _increment,
              icon: const Icon(Icons.add),
              label: const Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `StatefulCounterLesson`.
- The only addition is `actions: const [LessonInfoButton(lessonId: 2)]` on the AppBar, the button that opens these notes.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 2,
  title: 'StatefulWidget counter',
  notesAsset: '02-stateful-counter.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: StatefulCounterLesson());

void main() => runApp(lessonApp);

/// Lesson 02: A counter that rebuilds when its State changes.
class StatefulCounterLesson extends StatefulWidget {
  const StatefulCounterLesson({super.key});

  @override
  State<StatefulCounterLesson> createState() => _StatefulCounterLessonState();
}

class _StatefulCounterLessonState extends State<StatefulCounterLesson> {
  int _count = 0;

  void _increment() {
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
        actions: const [LessonInfoButton(lessonId: 2)],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('You have pressed the button this many times:'),
            Text('$_count', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _increment,
              icon: const Icon(Icons.add),
              label: const Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
```
