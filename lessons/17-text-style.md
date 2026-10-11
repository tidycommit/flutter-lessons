# Lesson 17: TextStyle

**Date:** Oct 6, 2026

The `style` property of `Text` takes a `TextStyle`, which controls how the text is drawn: `fontSize`, `fontWeight`, `fontStyle`, `color`, `letterSpacing`, `height` (line height), `decoration` and more.

Any property you leave out is inherited from the surrounding `DefaultTextStyle`, which comes from the theme. To tweak a theme style instead of starting from scratch, use something like `Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.deepPurple)`.

## Key points

- `fontSize` is in logical pixels.
- `FontWeight.bold` is the same as `FontWeight.w700`.
- Prefer theme text styles with `copyWith` for consistency across screens.

## In the app

This snippet has no AppBar of its own, so the app does not invent a title for it. It runs unchanged under a plain AppBar with no title, which holds only the back arrow to the lesson list and the lesson-notes button.

## Example

This is the runnable example in `lib/lessons/17_text_style.dart`:

```dart
class TextStyleLesson extends StatelessWidget {
  const TextStyleLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Hello, Flutter!',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}
```
