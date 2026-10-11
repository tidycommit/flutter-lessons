# Lesson 04: Column and Row alignment

**Date:** Sep 22, 2026

`Column` lays its children out vertically and `Row` lays them out horizontally. Each has a main axis (the direction children are placed in) and a cross axis (perpendicular to it).

`mainAxisAlignment` decides how free space along the main axis is shared: packed at the start, centered, packed at the end, or spread between and around the children. `crossAxisAlignment` decides where children sit on the other axis, for example `start`, `center` or `stretch`.

## Key points

- For a `Column` the main axis is vertical; for a `Row` it is horizontal.
- `spaceBetween` puts no gap at the ends; `spaceEvenly` makes every gap equal.
- Alignment only matters when there is free space left over.

## In the app

This snippet has no AppBar of its own, so the app does not invent a title for it. It runs unchanged under a plain AppBar with no title, which holds only the back arrow to the lesson list and the lesson-notes button.

## Example

This is the runnable example in `lib/lessons/04_column_row.dart`:

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
    return Padding(
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
