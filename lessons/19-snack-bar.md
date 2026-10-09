# Lesson 19: SnackBar

**Date:** Oct 8, 2026

A `SnackBar` is a short message that slides in at the bottom of the screen and disappears after a few seconds. You show one through the `ScaffoldMessenger`, which `MaterialApp` creates for you: `ScaffoldMessenger.of(context).showSnackBar(...)`.

Because the messenger sits above every route, the snack bar is not lost if the user navigates while it is showing. A `SnackBar` can also carry a `SnackBarAction`, such as Undo, and its `duration` can be changed.

## Key points

- Use `ScaffoldMessenger.of(context)`, not the older `Scaffold.of(context).showSnackBar`.
- Keep the message short and confirm what just happened.
- Call `hideCurrentSnackBar()` to dismiss one early.

## Example

This is the runnable example in `lib/lessons/19_snack_bar.dart`:

```dart
class SnackBarLesson extends StatelessWidget {
  const SnackBarLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Saved!')));
        },
        icon: const Icon(Icons.save),
        label: const Text('Save'),
      ),
    );
  }
}
```
