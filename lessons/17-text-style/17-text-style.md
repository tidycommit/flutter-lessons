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

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `TextStyleLesson`.
- The snippet's `Scaffold` is returned from the `build` method of `TextStyleLesson`, a `StatelessWidget`.
- The AppBar gets `actions: const [LessonInfoButton(lessonId: 17)]`, the button that opens these notes.
- `const` is added where the analyzer asks for it, and the code is run through `dart format`. Nothing else changes.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 17,
  title: 'TextStyle',
  notesAsset: '17-text-style.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: TextStyleLesson());

void main() => runApp(lessonApp);

/// Lesson 17: Large, bold, deep purple text.
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
