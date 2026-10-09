# Lesson 11: FloatingActionButton

**Date:** Sep 29, 2026

A `FloatingActionButton` (FAB) is a round button that floats above the content for the main action on a screen, such as adding an item. You give it to a `Scaffold` through the `floatingActionButton` slot, and the Scaffold places it in the bottom-right corner by default.

Set `tooltip` so the button has a label for screen readers and long presses. `FloatingActionButton.extended` shows a label next to the icon, and `floatingActionButtonLocation` on the Scaffold moves it.

## Key points

- Use at most one FAB per screen, for the primary action.
- The FAB belongs in the Scaffold slot, not in the body.
- Always set a `tooltip`.

## Example

This is the runnable example in `lib/lessons/11_floating_action_button.dart`:

```dart
class FloatingActionButtonLesson extends StatefulWidget {
  const FloatingActionButtonLesson({super.key});

  @override
  State<FloatingActionButtonLesson> createState() =>
      _FloatingActionButtonLessonState();
}

class _FloatingActionButtonLessonState
    extends State<FloatingActionButtonLesson> {
  int _items = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Items added: $_items')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _items++),
        tooltip: 'Add item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```
