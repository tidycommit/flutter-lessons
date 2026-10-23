# Lesson 12: TextField and InputDecoration

**Date:** Sep 30, 2026

`TextField` is the basic text input. Its look is controlled by an `InputDecoration`: `labelText` shows a label that floats above the field once it has focus or text, and `border: OutlineInputBorder()` draws a rectangle around it. Other useful fields include `hintText`, `helperText`, `errorText` and `prefixIcon`.

This lesson's snippet only shows the decoration. To read what was typed, attach a `TextEditingController` and read `controller.text`, or use the `onChanged` callback. Create the controller in a `State` and dispose of it in `dispose()`.

## Key points

- `labelText` floats; `hintText` disappears when typing starts.
- Dispose of every `TextEditingController` you create.
- `onChanged` plus `setState` updates other widgets as the user types.

## Code

Original snippet as taught:

```dart
Scaffold(
  appBar: AppBar(title: Text('TextField')),
  body: Padding(
    padding: EdgeInsets.all(16),
    child: Center(
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Your name',
          border: OutlineInputBorder(),
        ),
      ),
    ),
  ),
)
```

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `TextFieldLesson`.
- The snippet's `Scaffold` is returned from the `build` method of `TextFieldLesson`, a `StatelessWidget`.
- The AppBar gets `actions: const [LessonInfoButton(lessonId: 12)]`, the button that opens these notes.
- `const` is added where the analyzer asks for it, and the code is run through `dart format`. Nothing else changes.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 12,
  title: 'TextField and InputDecoration',
  notesAsset: '12-text-field.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: TextFieldLesson());

void main() => runApp(lessonApp);

/// Lesson 12: A TextField with a label and an outline border.
class TextFieldLesson extends StatelessWidget {
  const TextFieldLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TextField'),
        actions: const [LessonInfoButton(lessonId: 12)],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Your name',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }
}
```
