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

- The example's `Scaffold` is the pushed route, so its AppBar shows the back arrow to the lesson list automatically.
- The only addition is `actions: const [LessonInfoButton(lessonId: 2)]` on the AppBar, the button that opens these notes.

## Example

This is the runnable example in `lib/lessons/02_stateful_counter.dart`:

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
