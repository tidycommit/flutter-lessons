# Lesson 12: TextField and InputDecoration

**Date:** Sep 30, 2026

`TextField` is the basic text input. Its look is controlled by an `InputDecoration`: `labelText` shows a label that floats above the field once it has focus or text, and `border: OutlineInputBorder()` draws a rectangle around it. Other useful fields include `hintText`, `helperText`, `errorText` and `prefixIcon`.

To read what was typed, attach a `TextEditingController` and read `controller.text`, or use the `onChanged` callback. Create the controller in a `State` and dispose of it in `dispose()`.

## Key points

- `labelText` floats; `hintText` disappears when typing starts.
- Dispose of every `TextEditingController` you create.
- `onChanged` plus `setState` updates other widgets as the user types.

## In the app

This snippet has no AppBar of its own, so the app does not invent a title for it. It runs unchanged under a plain AppBar with no title, which holds only the back arrow to the lesson list and the lesson-notes button.

## Example

This is the runnable example in `lib/lessons/12_text_field.dart`:

```dart
class TextFieldLesson extends StatefulWidget {
  const TextFieldLesson({super.key});

  @override
  State<TextFieldLesson> createState() => _TextFieldLessonState();
}

class _TextFieldLessonState extends State<TextFieldLesson> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = _controller.text.trim();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Your name',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Text(name.isEmpty ? 'Type your name above.' : 'Hello, $name!'),
        ],
      ),
    );
  }
}
```
