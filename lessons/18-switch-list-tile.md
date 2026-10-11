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

- There is no `main()` or `runApp()`. The snippet's `Scaffold` is returned from the `build` method of `SwitchListTileLesson`'s `State` class, which also holds `_darkMode`, as the snippet's comment says.
- That `Scaffold` is the pushed route, so its AppBar shows the back arrow to the lesson list automatically.
- The AppBar gets `actions: const [LessonInfoButton(lessonId: 18)]`, the button that opens these notes.
- `const` is added where the analyzer asks for it, and the code is run through `dart format`. Nothing else changes.

## Example

This is the runnable example in `lib/lessons/18_switch_list_tile.dart`:

```dart
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
