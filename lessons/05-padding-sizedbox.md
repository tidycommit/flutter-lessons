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

- The example's `Scaffold` is the pushed route, so its AppBar shows the back arrow to the lesson list automatically.
- The only addition is `actions: const [LessonInfoButton(lessonId: 5)]` on the AppBar, the button that opens these notes.

## Example

This is the runnable example in `lib/lessons/05_padding_sizedbox.dart`:

```dart
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
