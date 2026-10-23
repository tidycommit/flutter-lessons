# Lesson 20: CircleAvatar

**Date:** Oct 9, 2026

`CircleAvatar` draws a circle, usually for a user's picture or initials. `radius` sets its size (48 gives a 96 px circle), `backgroundColor` fills it, and `child` is drawn in the middle, often a short `Text`.

For a photo, set `backgroundImage` to an `ImageProvider` such as `NetworkImage` and leave `child` empty, or keep initials as a fallback while the image loads. The initials 'AB' here are just a placeholder.

## Key points

- `radius: 48` means a diameter of 96 logical pixels.
- Keep initials to one or two characters so they fit.
- Use `foregroundImage` to show a photo over fallback initials.

## Code

Original snippet as taught:

```dart
Scaffold(
  appBar: AppBar(title: Text("Avatar")),
  body: Center(
    child: CircleAvatar(
      radius: 48,
      backgroundColor: Colors.teal,
      child: Text("AB", style: TextStyle(fontSize: 32, color: Colors.white)),
    ),
  ),
)
```

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `CircleAvatarLesson`.
- The snippet's `Scaffold` is returned from the `build` method of `CircleAvatarLesson`, a `StatelessWidget`.
- The AppBar gets `actions: const [LessonInfoButton(lessonId: 20)]`, the button that opens these notes.
- `const` is added where the analyzer asks for it, and the code is run through `dart format`. Nothing else changes.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 20,
  title: 'CircleAvatar',
  notesAsset: '20-circle-avatar.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: CircleAvatarLesson());

void main() => runApp(lessonApp);

/// Lesson 20: A teal CircleAvatar showing placeholder initials.
class CircleAvatarLesson extends StatelessWidget {
  const CircleAvatarLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Avatar"),
        actions: const [LessonInfoButton(lessonId: 20)],
      ),
      body: const Center(
        child: CircleAvatar(
          radius: 48,
          backgroundColor: Colors.teal,
          // Placeholder initials.
          child: Text(
            "AB",
            style: TextStyle(fontSize: 32, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
```
