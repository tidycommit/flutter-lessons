# Lesson 18: SwitchListTile

**Date:** Oct 7, 2026

`SwitchListTile` is a `ListTile` with a `Switch` built in, and the whole row is tappable. It needs the current `value` and an `onChanged` callback that receives the new value.

The switch does not store its own state. The parent keeps a `bool`, passes it as `value`, and calls `setState` in `onChanged` so the switch and anything else depending on that bool rebuild. In this snippet the switch starts on (`_darkMode = true`) and toggling it only flips the bool and the switch; a real app would pass the bool on, for example to `MaterialApp`'s `themeMode`.

## Key points

- `value` comes from your state; `onChanged` updates it.
- Passing `onChanged: null` disables the tile.
- `CheckboxListTile` and `RadioListTile` follow the same pattern.

## Code

Original snippet as taught:

```dart
bool _darkMode = true; // lives in your State class

Scaffold(
  appBar: AppBar(title: const Text('Settings')),
  body: ListView(
    children: [
      SwitchListTile(
        title: const Text('Dark mode'),
        value: _darkMode,
        onChanged: (v) => setState(() => _darkMode = v),
      ),
      const Divider(),
    ],
  ),
);
```

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `SwitchListTileLesson`.
- The snippet's `Scaffold` is returned from the `build` method of `SwitchListTileLesson`'s `State` class, which also holds `_darkMode`, as the snippet's comment says.
- The AppBar gets `actions: const [LessonInfoButton(lessonId: 18)]`, the button that opens these notes.
- `const` is added where the analyzer asks for it, and the code is run through `dart format`. Nothing else changes.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 18,
  title: 'SwitchListTile',
  notesAsset: '18-switch-list-tile.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: SwitchListTileLesson());

void main() => runApp(lessonApp);

/// Lesson 18: A Dark mode SwitchListTile on a Settings screen, toggled with setState.
class SwitchListTileLesson extends StatefulWidget {
  const SwitchListTileLesson({super.key});

  @override
  State<SwitchListTileLesson> createState() => _SwitchListTileLessonState();
}

class _SwitchListTileLessonState extends State<SwitchListTileLesson> {
  bool _darkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: const [LessonInfoButton(lessonId: 18)],
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark mode'),
            value: _darkMode,
            onChanged: (v) => setState(() => _darkMode = v),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
```
