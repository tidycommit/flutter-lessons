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

- The example's `Scaffold` is the pushed route, so its AppBar shows the back arrow to the lesson list automatically.
- The only addition is `actions: const [LessonInfoButton(lessonId: 9)]` on the AppBar, the button that opens these notes.

## Example

This is the runnable example in `lib/lessons/09_container.dart`:

```dart
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
