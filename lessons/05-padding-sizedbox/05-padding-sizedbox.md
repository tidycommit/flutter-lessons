# Lesson 05: Padding and SizedBox

**Date:** Sep 23, 2026

`Padding` adds empty space inside its own bounds, around its child. The amount is an `EdgeInsets`, such as `EdgeInsets.all(24)`, `EdgeInsets.symmetric(horizontal: 16)` or `EdgeInsets.only(top: 8)`.

`SizedBox` forces a specific width, height or both. With no child it is an easy fixed gap between items in a `Column` or `Row`. With a child, it constrains that child to the given size.

## Key points

- Use `Padding` for space around something.
- Use an empty `SizedBox` for space between things.
- Both are cheap and can usually be `const`.

## Code

AppBar title supplied by the teacher; the original full code wasn't available.

```dart
class PaddingSizedBoxLesson extends StatelessWidget {
  const PaddingSizedBoxLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Padding')),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('First line, 24 px from the edges'),
            SizedBox(height: 8),
            Text('Second line, 8 px below'),
            SizedBox(height: 32),
            Text('Third line, 32 px below'),
            SizedBox(height: 24),
            SizedBox(
              width: 200,
              height: 48,
              child: ColoredBox(
                color: Colors.amber,
                child: Center(child: Text('SizedBox 200 x 48')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `PaddingSizedBoxLesson`.
- The only addition is `actions: const [LessonInfoButton(lessonId: 5)]` on the AppBar, the button that opens these notes.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 5,
  title: 'Padding and SizedBox',
  notesAsset: '05-padding-sizedbox.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: PaddingSizedBoxLesson());

void main() => runApp(lessonApp);

/// Lesson 05: Spacing with Padding around content and SizedBox between items.
class PaddingSizedBoxLesson extends StatelessWidget {
  const PaddingSizedBoxLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Padding'),
        actions: const [LessonInfoButton(lessonId: 5)],
      ),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('First line, 24 px from the edges'),
            SizedBox(height: 8),
            Text('Second line, 8 px below'),
            SizedBox(height: 32),
            Text('Third line, 32 px below'),
            SizedBox(height: 24),
            SizedBox(
              width: 200,
              height: 48,
              child: ColoredBox(
                color: Colors.amber,
                child: Center(child: Text('SizedBox 200 x 48')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```
