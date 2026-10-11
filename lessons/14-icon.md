# Lesson 14: Icon

**Date:** Oct 3, 2026

`Icon` draws a glyph from an icon font. The `Icons` class contains the Material icons that ship with Flutter when `uses-material-design: true` is set in `pubspec.yaml`.

`size` is in logical pixels and `color` sets the fill. Icons are decorative by default, so add a `semanticLabel` when the icon carries meaning that a screen reader should announce.

## Key points

- `Icon(Icons.favorite, size: 64, color: Colors.red)` draws a 64 px red heart.
- Without `size` or `color`, values come from the surrounding `IconTheme`.
- Use `IconButton` when the icon should be tappable.

## Code

Original snippet as taught:

```dart
Scaffold(
  appBar: AppBar(title: Text('Icons')),
  body: Center(
    child: Icon(Icons.favorite, size: 64, color: Colors.red),
  ),
)
```

## How it is adapted in this app

- There is no `main()` or `runApp()`. The snippet's `Scaffold` is returned from the `build` method of `IconLesson`, a `StatelessWidget`.
- That `Scaffold` is the pushed route, so its AppBar shows the back arrow to the lesson list automatically.
- The AppBar gets `actions: const [LessonInfoButton(lessonId: 14)]`, the button that opens these notes.
- `const` is added where the analyzer asks for it, and the code is run through `dart format`. Nothing else changes.

## Example

This is the runnable example in `lib/lessons/14_icon.dart`:

```dart
class IconLesson extends StatelessWidget {
  const IconLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icons'),
        actions: const [LessonInfoButton(lessonId: 14)],
      ),
      body: const Center(
        child: Icon(Icons.favorite, size: 64, color: Colors.red),
      ),
    );
  }
}
```
