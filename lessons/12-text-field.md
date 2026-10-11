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

- There is no `main()` or `runApp()`. The snippet's `Scaffold` is returned from the `build` method of `TextFieldLesson`, a `StatelessWidget`.
- That `Scaffold` is the pushed route, so its AppBar shows the back arrow to the lesson list automatically.
- The AppBar gets `actions: const [LessonInfoButton(lessonId: 12)]`, the button that opens these notes.
- `const` is added where the analyzer asks for it, and the code is run through `dart format`. Nothing else changes.

## Example

This is the runnable example in `lib/lessons/12_text_field.dart`:

```dart
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
