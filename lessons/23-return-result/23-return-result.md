# Lesson 23: Returning a result with Navigator.pop(context, value) and await

**Date:** Oct 12, 2026

This is lesson 3 of the navigation series.

Yesterday we sent data forward into a new screen. Today it goes the other way: the second screen hands an answer back.

`Navigator.push` returns a `Future`, which is a promise of a value that shows up later. When the second screen calls `Navigator.pop(context, 'Blue')`, that `'Blue'` becomes the value of the `Future`, so the first screen can write `final result = await Navigator.push(...)` and simply wait for the answer.

If the user leaves with the AppBar back arrow instead of picking something, pop happens with no value and `result` is `null`. That's why the code checks `if (result != null)` before calling `setState` to show the new choice.

This pattern is perfect for pickers, edit forms, and "are you sure?" screens.

## Key points

- `Navigator.push` returns a `Future` that completes when the pushed screen is popped.
- `Navigator.pop(context, value)` sends `value` back as that `Future`'s result.
- `Navigator.push<String>` types the result, so `result` is a `String?`.
- The back arrow pops with no value, so always handle `null`.

## Code

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: HomeScreen()));

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _color = 'none yet';

  Future<void> _pickColor() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const ColorPickerScreen()),
    );
    if (result != null) {
      setState(() => _color = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick a Color')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Favorite color: $_color', style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickColor,
              child: const Text('Choose color'),
            ),
          ],
        ),
      ),
    );
  }
}

class ColorPickerScreen extends StatelessWidget {
  const ColorPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const colors = ['Red', 'Green', 'Blue'];
    return Scaffold(
      appBar: AppBar(title: const Text('Colors')),
      body: ListView(
        children: [
          for (final color in colors)
            ListTile(
              title: Text(color),
              onTap: () => Navigator.pop(context, color),
            ),
        ],
      ),
    );
  }
}
```

## On screen

The home screen has an AppBar titled Pick a Color and, in the middle, the text "Favorite color: none yet" above a Choose color button. Tapping the button slides in a Colors screen with a back arrow and a list of Red, Green, and Blue. Tapping Blue closes that screen and the home text changes to "Favorite color: Blue". Tapping the back arrow instead just returns home and leaves the text unchanged.

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `Lesson23PickColor`.
- The Pick a Color AppBar keeps the snippet's title with default styling, and gets `actions: const [LessonInfoButton(lessonId: 23)]`, the button that opens these notes. It is the app's first screen, so it has no back arrow, as in the snippet.
- The classes are named `Lesson23PickColor` and `Lesson23ColorPicker` following the naming of the other navigation lessons. The titles, text and logic are unchanged, including the `if (result != null)` check.
- The Colors screen is pushed on the project's navigator. Picking a color or using its back arrow returns to Pick a Color.
- No `if (mounted)` check was added: `flutter analyze` reports no issues without it. The code is run through `dart format`.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 23,
  title: 'Returning a result with Navigator.pop(context, value) and await',
  notesAsset: '23-return-result.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: Lesson23PickColor());

void main() => runApp(lessonApp);

/// Lesson 23: Returning a result with Navigator.pop(context, value) and await.
class Lesson23PickColor extends StatefulWidget {
  const Lesson23PickColor({super.key});

  @override
  State<Lesson23PickColor> createState() => _Lesson23PickColorState();
}

class _Lesson23PickColorState extends State<Lesson23PickColor> {
  String _color = 'none yet';

  Future<void> _pickColor() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const Lesson23ColorPicker()),
    );
    if (result != null) {
      setState(() => _color = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick a Color'),
        actions: const [LessonInfoButton(lessonId: 23)],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Favorite color: $_color',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickColor,
              child: const Text('Choose color'),
            ),
          ],
        ),
      ),
    );
  }
}

class Lesson23ColorPicker extends StatelessWidget {
  const Lesson23ColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    const colors = ['Red', 'Green', 'Blue'];
    return Scaffold(
      appBar: AppBar(title: const Text('Colors')),
      body: ListView(
        children: [
          for (final color in colors)
            ListTile(
              title: Text(color),
              onTap: () => Navigator.pop(context, color),
            ),
        ],
      ),
    );
  }
}
```
