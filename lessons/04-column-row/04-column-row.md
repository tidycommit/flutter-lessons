# Lesson 04: Column and Row alignment

**Date:** Sep 22, 2026

`Column` lays its children out vertically and `Row` lays them out horizontally. Each has a main axis (the direction children are placed in) and a cross axis (perpendicular to it).

`mainAxisAlignment` decides how free space along the main axis is shared: packed at the start, centered, packed at the end, or spread between and around the children. `crossAxisAlignment` decides where children sit on the other axis, for example `start`, `center` or `stretch`.

## Key points

- For a `Column` the main axis is vertical; for a `Row` it is horizontal.
- `spaceBetween` puts no gap at the ends; `spaceEvenly` makes every gap equal.
- Alignment only matters when there is free space left over.

## Code

AppBar title supplied by the teacher; the original full code wasn't available.

```dart
class ColumnRowLesson extends StatelessWidget {
  const ColumnRowLesson({super.key});

  static const _alignments = [
    MainAxisAlignment.start,
    MainAxisAlignment.center,
    MainAxisAlignment.end,
    MainAxisAlignment.spaceBetween,
    MainAxisAlignment.spaceEvenly,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Column & Row')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final alignment in _alignments) ...[
              Text('MainAxisAlignment.${alignment.name}'),
              Row(
                mainAxisAlignment: alignment,
                children: const [
                  _Box(color: Colors.red),
                  _Box(color: Colors.green),
                  _Box(color: Colors.blue),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.all(4),
      color: color,
    );
  }
}
```

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `ColumnRowLesson`.
- The only addition is `actions: const [LessonInfoButton(lessonId: 4)]` on the AppBar, the button that opens these notes.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 4,
  title: 'Column and Row alignment',
  notesAsset: '04-column-row.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: ColumnRowLesson());

void main() => runApp(lessonApp);

/// Lesson 04: Rows of boxes using different MainAxisAlignment values inside a Column.
class ColumnRowLesson extends StatelessWidget {
  const ColumnRowLesson({super.key});

  static const _alignments = [
    MainAxisAlignment.start,
    MainAxisAlignment.center,
    MainAxisAlignment.end,
    MainAxisAlignment.spaceBetween,
    MainAxisAlignment.spaceEvenly,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Column & Row'),
        actions: const [LessonInfoButton(lessonId: 4)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final alignment in _alignments) ...[
              Text('MainAxisAlignment.${alignment.name}'),
              Row(
                mainAxisAlignment: alignment,
                children: const [
                  _Box(color: Colors.red),
                  _Box(color: Colors.green),
                  _Box(color: Colors.blue),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.all(4),
      color: color,
    );
  }
}
```
