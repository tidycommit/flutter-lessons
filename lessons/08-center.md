# Lesson 08: Center

**Date:** Sep 26, 2026

`Center` positions its child in the middle of the space it is given. It is a shortcut for `Align(alignment: Alignment.center)`.

By default `Center` grows as large as its parent allows, so the child ends up in the middle of the screen or panel. If you set `widthFactor` or `heightFactor`, the `Center` instead sizes itself to a multiple of the child's size.

## Key points

- `Center` centers on both axes.
- Use `Align` when you need another position, such as `Alignment.bottomRight`.
- A `Container` with `alignment: Alignment.center` centers its own child the same way.

## In the app

This snippet has no AppBar of its own, so the app does not invent a title for it. It runs unchanged under a plain AppBar with no title, which holds only the back arrow to the lesson list and the lesson-notes button.

## Example

This is the runnable example in `lib/lessons/08_center.dart`:

```dart
class CenterLesson extends StatelessWidget {
  const CenterLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 160,
        height: 160,
        color: Colors.indigo,
        alignment: Alignment.center,
        child: const Text(
          'Centered',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
```
