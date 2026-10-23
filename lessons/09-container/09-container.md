# Lesson 09: Container

**Date:** Sep 27, 2026

`Container` combines several layout and painting widgets in one: size (`width`, `height`, `constraints`), spacing (`padding`, `margin`), `alignment` of its child, and painting through `decoration`.

A `BoxDecoration` can draw a background colour, gradient, border, rounded corners and shadows. When you use `decoration`, put the colour inside the `BoxDecoration`; setting both `color` and `decoration` on the Container is an error.

## Key points

- `padding` is space inside the decoration; `margin` is space outside it.
- Without a size or child constraints, a Container tries to be as big as possible.
- For a single job, a dedicated widget like `Padding` or `SizedBox` is often clearer.

## Code

AppBar title supplied by the teacher; the original full code wasn't available.

```dart
class ContainerLesson extends StatelessWidget {
  const ContainerLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Container')),
      body: Center(
        child: Container(
          width: 240,
          height: 140,
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.lightBlue.shade100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.lightBlue, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Text('Hello!'),
        ),
      ),
    );
  }
}
```

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `ContainerLesson`.
- The only addition is `actions: const [LessonInfoButton(lessonId: 9)]` on the AppBar, the button that opens these notes.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 9,
  title: 'Container',
  notesAsset: '09-container.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: ContainerLesson());

void main() => runApp(lessonApp);

/// Lesson 09: A decorated Container with size, padding, rounded corners and a shadow.
class ContainerLesson extends StatelessWidget {
  const ContainerLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Container'),
        actions: const [LessonInfoButton(lessonId: 9)],
      ),
      body: Center(
        child: Container(
          width: 240,
          height: 140,
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.lightBlue.shade100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.lightBlue, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Text('Hello!'),
        ),
      ),
    );
  }
}
```
