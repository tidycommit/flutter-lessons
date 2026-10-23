# Lesson 21: Moving between screens with Navigator.push and Navigator.pop

**Date:** Oct 10, 2026

This is the first lesson in a series on navigation.

Flutter keeps the screens of an app in a stack, managed by a `Navigator`. `Navigator.push` puts a new screen on top of the stack, and `Navigator.pop` removes the top screen so the one below shows again. Each screen is wrapped in a route; `MaterialPageRoute` gives the platform's usual transition, such as the slide-in on iOS.

When a screen is pushed, its `AppBar` adds a back arrow automatically. Tapping that arrow pops the screen, just like calling `Navigator.pop(context)` yourself.

## Key points

- `Navigator.push(context, MaterialPageRoute(builder: ...))` opens a new screen on top.
- `Navigator.pop(context)` closes the current screen and returns to the previous one.
- The `AppBar` of a pushed screen shows a back arrow that pops it.
- On screen: Home has an Open details button; tapping it slides in Details, which has a back arrow and a Go back button. Either one returns to Home.

## Code

```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DetailsScreen()),
            );
          },
          child: const Text('Open details'),
        ),
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back'),
        ),
      ),
    );
  }
}
```

To run it on its own, use `HomeScreen` as the `home` of a `MaterialApp`:

```dart
void main() => runApp(const MaterialApp(home: HomeScreen()));
```

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `Lesson21Home`.
- The Home AppBar keeps the snippet's title with default styling, and gets `actions: const [LessonInfoButton(lessonId: 21)]`, the button that opens these notes. It is the app's first screen, so it has no back arrow, as in the snippet.
- The classes are named `Lesson21Home` and `Lesson21Details` following the naming of the other navigation lessons. The titles are still Home and Details.
- Details is pushed on the project's navigator. Its back arrow and the Go back button both return to Home.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 21,
  title: 'Moving between screens with Navigator.push and Navigator.pop',
  notesAsset: '21-navigator-push-pop.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: Lesson21Home());

void main() => runApp(lessonApp);

/// Lesson 21: Moving between screens with Navigator.push and Navigator.pop.
class Lesson21Home extends StatelessWidget {
  const Lesson21Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: const [LessonInfoButton(lessonId: 21)],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Pushes onto the app's navigator; Details' back arrow
            // returns here.
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const Lesson21Details(),
              ),
            );
          },
          child: const Text('Open details'),
        ),
      ),
    );
  }
}

class Lesson21Details extends StatelessWidget {
  const Lesson21Details({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Go back'),
        ),
      ),
    );
  }
}
```
