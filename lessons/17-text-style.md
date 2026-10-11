# Lesson 17: TextStyle

**Date:** Oct 6, 2026

The `style` property of `Text` takes a `TextStyle`, which controls how the text is drawn: `fontSize`, `fontWeight`, `fontStyle`, `color`, `letterSpacing`, `height` (line height), `decoration` and more.

Any property you leave out is inherited from the surrounding `DefaultTextStyle`, which comes from the theme. To tweak a theme style instead of starting from scratch, use something like `Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.deepPurple)`.

## Key points

- `fontSize` is in logical pixels.
- `FontWeight.bold` is the same as `FontWeight.w700`.
- Prefer theme text styles with `copyWith` for consistency across screens.

## Code

Original snippet as taught:

```dart
Scaffold(
  appBar: AppBar(title: const Text('Text Styles')),
  body: const Center(
    child: Text(
      'Hello, Flutter!',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
    ),
  ),
)
```

## How it is adapted in this app

- There is no `main()` or `runApp()`. The snippet's `Scaffold` is returned from the `build` method of `TextStyleLesson`, a `StatelessWidget`.
- That `Scaffold` is the pushed route, so its AppBar shows the back arrow to the lesson list automatically.
- The AppBar gets `actions: const [LessonInfoButton(lessonId: 17)]`, the button that opens these notes.
- `const` is added where the analyzer asks for it, and the code is run through `dart format`. Nothing else changes.

## Example

This is the runnable example in `lib/lessons/17_text_style.dart`:

```dart
class TextStyleLesson extends StatelessWidget {
  const TextStyleLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Styles'),
        actions: const [LessonInfoButton(lessonId: 17)],
      ),
      body: const Center(
        child: Text(
          'Hello, Flutter!',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}
```
