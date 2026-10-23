# Lesson 29: showDialog and showModalBottomSheet as routes

**Date:** Oct 18, 2026

This is lesson 9 of the navigation series.

A pop-up dialog and a bottom sheet are really just routes, the same kind of thing `Navigator.push` puts on the stack. `showDialog` slides an `AlertDialog` on top of your screen, and `showModalBottomSheet` slides a panel up from the bottom. Because they're routes, you close them with `Navigator.pop`, and tapping the dimmed area outside or pressing system back closes them too.

They also return a value: `Navigator.pop(dialogContext, true)` makes the `await` on `showDialog<bool>` return `true`; tapping outside returns `null`, so check for that. Use the builder's context (`dialogContext`, `sheetContext`) when popping, and check `mounted` before `setState` after an `await`.

## Key points

- `showDialog` and `showModalBottomSheet` push a route, just like `Navigator.push`.
- Close them with `Navigator.pop`; tapping the dimmed area outside or pressing system back closes them too.
- `Navigator.pop(dialogContext, true)` makes the `await` on `showDialog<bool>` return `true`.
- Tapping outside (or swiping a sheet down) returns `null`, so the result type is nullable (`bool?`, `String?`) and you check for `null`.
- Pop with the builder's context (`dialogContext`, `sheetContext`), not the screen's.
- After an `await`, check `mounted` before calling `setState`.

## Code

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: PopupsScreen()));

class PopupsScreen extends StatefulWidget {
  const PopupsScreen({super.key});

  @override
  State<PopupsScreen> createState() => _PopupsScreenState();
}

class _PopupsScreenState extends State<PopupsScreen> {
  String _message = 'Nothing chosen yet';

  Future<void> _askToDelete() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete photo?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    setState(() {
      _message = confirmed == true ? 'Photo deleted' : 'Kept the photo';
    });
  }

  Future<void> _pickShare() async {
    final String? app = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              onTap: () => Navigator.pop(sheetContext, 'Email'),
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Messages'),
              onTap: () => Navigator.pop(sheetContext, 'Messages'),
            ),
          ],
        ),
      ),
    );
    if (!mounted || app == null) return;
    setState(() => _message = 'Shared with $app');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popups Tip')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_message, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _askToDelete,
              child: const Text('Delete photo'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _pickShare,
              child: const Text('Share'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## On screen

The "Popups Tip" screen shows "Nothing chosen yet" with "Delete photo" and "Share" buttons below. "Delete photo" dims the screen and shows a dialog "Delete photo?" / "This cannot be undone." with Cancel and Delete. Delete sets the text to "Photo deleted"; Cancel or tapping outside sets "Kept the photo". "Share" slides up a bottom sheet with Email and Messages rows; picking one closes it and shows "Shared with Email" or "Shared with Messages"; swiping it down leaves the text unchanged.

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `Lesson29Popups`.
- `PopupsScreen` is renamed `Lesson29Popups`. `_askToDelete`, `_pickShare`, the dialog, the sheet and the body are unchanged; `dart format` just puts the short Share button on one line.
- The AppBar keeps `title: const Text('Popups Tip')` with default styling, and gets `actions: const [LessonInfoButton(lessonId: 29)]`, the button that opens these notes.
- The info button's notes open in a bottom sheet too, the same `showModalBottomSheet` this lesson is about.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 29,
  title: 'showDialog and showModalBottomSheet as routes',
  notesAsset: '29-dialogs-bottom-sheets.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: Lesson29Popups());

void main() => runApp(lessonApp);

/// Lesson 29: showDialog and showModalBottomSheet as routes.
///
/// The dialog and the bottom sheet are pushed on top of this screen as
/// routes of their own. Closing either one pops only that popup route.
class Lesson29Popups extends StatefulWidget {
  const Lesson29Popups({super.key});

  @override
  State<Lesson29Popups> createState() => _Lesson29PopupsState();
}

class _Lesson29PopupsState extends State<Lesson29Popups> {
  String _message = 'Nothing chosen yet';

  Future<void> _askToDelete() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete photo?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    setState(() {
      _message = confirmed == true ? 'Photo deleted' : 'Kept the photo';
    });
  }

  Future<void> _pickShare() async {
    final String? app = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              onTap: () => Navigator.pop(sheetContext, 'Email'),
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Messages'),
              onTap: () => Navigator.pop(sheetContext, 'Messages'),
            ),
          ],
        ),
      ),
    );
    if (!mounted || app == null) return;
    setState(() => _message = 'Shared with $app');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popups Tip'),
        actions: const [LessonInfoButton(lessonId: 29)],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_message, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _askToDelete,
              child: const Text('Delete photo'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _pickShare, child: const Text('Share')),
          ],
        ),
      ),
    );
  }
}
```
