# Lesson 06: Expanded

**Date:** Sep 24, 2026

`Expanded` makes a child of a `Row`, `Column` or `Flex` fill the space left over after the fixed-size children are laid out. When several children are `Expanded`, they share that space in proportion to their `flex` values, which default to 1.

In the example the outer `Expanded` lets the row take all the height below the 80 px panel. Inside the row, the middle panel has `flex: 2`, so it is twice as wide as each of its neighbours.

## Key points

- `Expanded` must be a direct child of a `Row`, `Column` or `Flex`.
- Leftover space is divided by `flex`: here 1 + 2 + 1 = 4 parts.
- `Flexible` is similar but lets the child be smaller than its share.

## Code

AppBar title supplied by the teacher; the original full code wasn't available.

```dart
class ExpandedLesson extends StatelessWidget {
  const ExpandedLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expanded')),
      body: const Column(
        children: [
          _Panel(color: Colors.blueGrey, label: 'Fixed height: 80', height: 80),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _Panel(color: Colors.red, label: 'flex: 1'),
                ),
                Expanded(
                  flex: 2,
                  child: _Panel(color: Colors.green, label: 'flex: 2'),
                ),
                Expanded(
                  child: _Panel(color: Colors.blue, label: 'flex: 1'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.color, required this.label, this.height});

  final Color color;
  final String label;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: color,
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}
```

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `ExpandedLesson`.
- The only addition is `actions: const [LessonInfoButton(lessonId: 6)]` on the AppBar, the button that opens these notes.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 6,
  title: 'Expanded',
  notesAsset: '06-expanded.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: ExpandedLesson());

void main() => runApp(lessonApp);

/// Lesson 06: Expanded children sharing space by flex factor.
class ExpandedLesson extends StatelessWidget {
  const ExpandedLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expanded'),
        actions: const [LessonInfoButton(lessonId: 6)],
      ),
      body: const Column(
        children: [
          _Panel(color: Colors.blueGrey, label: 'Fixed height: 80', height: 80),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _Panel(color: Colors.red, label: 'flex: 1'),
                ),
                Expanded(
                  flex: 2,
                  child: _Panel(color: Colors.green, label: 'flex: 2'),
                ),
                Expanded(
                  child: _Panel(color: Colors.blue, label: 'flex: 1'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.color, required this.label, this.height});

  final Color color;
  final String label;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: color,
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}
```
