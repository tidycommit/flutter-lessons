# Lesson 30: PopScope for handling back

**Date:** Oct 19, 2026

This is lesson 10 of the navigation series.

Sometimes leaving a screen too easily loses work, like when someone has typed half a note and taps the back arrow by accident. `PopScope` is a widget you wrap around a screen to decide whether "back" is allowed. Its `canPop` setting is the on/off switch: when `canPop` is true, back works as usual; when it's false, Flutter blocks the back arrow, the Android back button, and the back swipe, and calls `onPopInvokedWithResult` instead, so you can step in.

In this example, `canPop` is true while the note is empty and flips to false as soon as you type. If you then try to go back, `didPop` comes in as false (the pop was blocked), so we show a "Discard note?" dialog. If you pick Discard, we call `Navigator.pop` ourselves, which leaves the screen even though `canPop` is false, because `PopScope` only guards the back gestures and buttons, not your own code.

## Key points

- Wrap a screen in `PopScope` to decide whether "back" is allowed.
- `canPop: true` lets back work as usual; `canPop: false` blocks the back arrow, the Android back button and the back swipe.
- When a pop is blocked, `onPopInvokedWithResult` is called with `didPop` set to false, so that's where you step in (here: show a dialog).
- Tie `canPop` to your state: here it is `!_hasText`, updated with `setState` in the TextField's `onChanged`.
- Your own `Navigator.pop(context)` still leaves the screen even when `canPop` is false; `PopScope` only guards the back gestures and buttons.

## Code

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: HomeScreen()));

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PopScope Tip')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditNoteScreen()),
          ),
          child: const Text('Write a note'),
        ),
      ),
    );
  }
}

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({super.key});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _confirmLeave() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard note?'),
        content: const Text('Your note will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    if (leave == true && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasText,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _confirmLeave();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('New Note')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Type something...'),
            onChanged: (text) => setState(() => _hasText = text.isNotEmpty),
          ),
        ),
      ),
    );
  }
}
```

## On screen

The first screen has an AppBar titled "PopScope Tip" and a centered "Write a note" button. Tapping it opens a "New Note" screen with a back arrow and an empty text field that says "Type something...". If you go back while the field is empty, you return to the first screen right away. Once you've typed something, like "Buy milk and eggs", tapping the back arrow (or using the phone's back button or swipe) stays on the screen and shows a "Discard note?" dialog with the line "Your note will be lost." and two buttons. "Keep editing" closes the dialog and leaves your text in place, while "Discard" closes the dialog and takes you back to the first screen.

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `Lesson30PopScope`.
- `HomeScreen` is renamed `Lesson30PopScope` and `EditNoteScreen` is renamed `Lesson30EditNote`. The button, the `PopScope`, `_confirmLeave`, the dialog and the text field are unchanged.
- The first screen's AppBar keeps `title: const Text('PopScope Tip')` with default styling, and gets `actions: const [LessonInfoButton(lessonId: 30)]`, the button that opens these notes. The New Note screen keeps its own `AppBar(title: const Text('New Note'))` with no extra actions.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 30,
  title: 'PopScope for handling back',
  notesAsset: '30-popscope.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: Lesson30PopScope());

void main() => runApp(lessonApp);

/// Lesson 30: PopScope for handling back.
///
/// The Tip screen is the app's home, and "Write a note" pushes the note
/// screen on the same navigator, as in the snippet.
/// So the PopScope sits on the top route and guards only that route: the
/// AppBar back arrow, system back and the back swipe all ask the top route
/// first, and the Tip screen underneath is never popped by mistake.
class Lesson30PopScope extends StatelessWidget {
  const Lesson30PopScope({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PopScope Tip'),
        actions: const [LessonInfoButton(lessonId: 30)],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Lesson30EditNote()),
          ),
          child: const Text('Write a note'),
        ),
      ),
    );
  }
}

class Lesson30EditNote extends StatefulWidget {
  const Lesson30EditNote({super.key});

  @override
  State<Lesson30EditNote> createState() => _Lesson30EditNoteState();
}

class _Lesson30EditNoteState extends State<Lesson30EditNote> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _confirmLeave() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard note?'),
        content: const Text('Your note will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    if (leave == true && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasText,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _confirmLeave();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('New Note')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Type something...'),
            onChanged: (text) => setState(() => _hasText = text.isNotEmpty),
          ),
        ),
      ),
    );
  }
}
```
