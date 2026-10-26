# Lesson 37: Shared confirm dialog

**Date:** Oct 26, 2026

This is lesson 7 of the design-system series: modal dialogs as a shared pattern.

Every "Are you sure?" box in an app should look and behave the same way. Instead of building a fresh `AlertDialog` on every screen, write one helper, `showAppConfirmDialog`, and call it everywhere. It wraps Flutter's `showDialog` and an `AlertDialog`, so the title, message, button order and styling stay consistent. To change how confirmations look, you change one function.

The helper returns a `Future<bool>`: `true` means the user confirmed, `false` means they cancelled. Tapping outside the dialog returns `null`, which the helper turns into `false`. As in lesson 29, a dialog is just a route pushed on top of the screen, so each button closes it with `Navigator.pop(context, value)`, the same way a pushed screen returns a result. Destructive actions get a clear label like "Delete" and a red button so nobody taps it by accident.

## Key points

- Put confirmations behind one helper, `showAppConfirmDialog`, so every screen gets the same title, actions and barrier behavior.
- Return `Future<bool>`: `true` means confirmed; cancel and tapping outside (`null`) both mean `false`.
- Give destructive actions a clear label ("Delete") and a distinct style (the theme's `error` color).
- The dialog is a route, so it pops itself with `Navigator.pop(context, value)`.
- After the `await`, check `mounted` before calling `setState`.

No new packages today (no `flutter pub add` needed): `showDialog`, `AlertDialog` and the buttons are all in `package:flutter/material.dart`.

## Code

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: DialogDemo()));

/// One shared confirm dialog. Returns true only when the user confirms.
Future<bool> showAppConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Delete',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false; // tapping outside counts as cancel
}

class DialogDemo extends StatefulWidget {
  const DialogDemo({super.key});

  @override
  State<DialogDemo> createState() => _DialogDemoState();
}

class _DialogDemoState extends State<DialogDemo> {
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3'];

  Future<void> _deleteLast() async {
    final name = _items.last;
    final confirmed = await showAppConfirmDialog(
      context,
      title: 'Delete $name?',
      message: "This removes it from the list. You can't undo this.",
    );
    if (!mounted || !confirmed) return;
    setState(() => _items.removeLast());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppDialog')),
      body: Column(
        children: [
          for (final item in _items)
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.check)),
              title: Text(item),
            ),
          const SizedBox(height: 24),
          if (_items.isEmpty)
            const Text('All items deleted.')
          else
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: _deleteLast,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete item'),
            ),
        ],
      ),
    );
  }
}
```

## On screen

The AppBar reads "AppDialog". Below it is a list of three rows, "Item 1", "Item 2" and "Item 3", each with a small check-mark circle, and under the list a red-outlined "Delete item" button with a trash icon. Tapping "Delete item" dims the screen and pops up a dialog titled "Delete Item 3?" with the message "This removes it from the list. You can't undo this." and two buttons: a plain "Cancel" and a red filled "Delete". Tapping "Cancel" (or anywhere outside the dialog) closes it and the list stays the same. Tapping "Delete" closes the dialog and "Item 3" disappears from the list; the next tap asks about "Item 2", and so on. Once every item is gone, the button is replaced by the text "All items deleted."

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `Lesson37SharedDialog`.
- `DialogDemo` is renamed `Lesson37SharedDialog`. `showAppConfirmDialog` keeps its name, because it is the idea being taught.
- The AppBar keeps `title: const Text('AppDialog')` with default styling, and gets `actions: const [LessonInfoButton(lessonId: 37)]`, the button that opens these notes.
- A doc comment is added to the page; the code is otherwise unchanged.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 37,
  title: 'Shared confirm dialog',
  notesAsset: '37-shared-dialog.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: Lesson37SharedDialog());

void main() => runApp(lessonApp);

/// One shared confirm dialog. Returns true only when the user confirms.
Future<bool> showAppConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Delete',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false; // tapping outside counts as cancel
}

/// The page: each delete goes through [showAppConfirmDialog].
class Lesson37SharedDialog extends StatefulWidget {
  const Lesson37SharedDialog({super.key});

  @override
  State<Lesson37SharedDialog> createState() => _Lesson37SharedDialogState();
}

class _Lesson37SharedDialogState extends State<Lesson37SharedDialog> {
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3'];

  Future<void> _deleteLast() async {
    final name = _items.last;
    final confirmed = await showAppConfirmDialog(
      context,
      title: 'Delete $name?',
      message: "This removes it from the list. You can't undo this.",
    );
    if (!mounted || !confirmed) return;
    setState(() => _items.removeLast());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppDialog'),
        actions: const [LessonInfoButton(lessonId: 37)],
      ),
      body: Column(
        children: [
          for (final item in _items)
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.check)),
              title: Text(item),
            ),
          const SizedBox(height: 24),
          if (_items.isEmpty)
            const Text('All items deleted.')
          else
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: _deleteLast,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete item'),
            ),
        ],
      ),
    );
  }
}
```
