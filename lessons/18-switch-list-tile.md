# Lesson 18: SwitchListTile

**Date:** Oct 7, 2026

`SwitchListTile` is a `ListTile` with a `Switch` built in, and the whole row is tappable. It needs the current `value` and an `onChanged` callback that receives the new value.

The switch does not store its own state. The parent keeps a `bool`, passes it as `value`, and calls `setState` in `onChanged` so the switch and anything else depending on that bool rebuild. Here the bool also picks a light or dark `ThemeData` for the example area.

## Key points

- `value` comes from your state; `onChanged` updates it.
- Passing `onChanged: null` disables the tile.
- `CheckboxListTile` and `RadioListTile` follow the same pattern.

## Example

This is the runnable example in `lib/lessons/18_switch_list_tile.dart`:

```dart
class SwitchListTileLesson extends StatefulWidget {
  const SwitchListTileLesson({super.key});

  @override
  State<SwitchListTileLesson> createState() => _SwitchListTileLessonState();
}

class _SwitchListTileLessonState extends State<SwitchListTileLesson> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: _darkMode ? Brightness.dark : Brightness.light,
      ),
      child: Material(
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Dark mode'),
              subtitle: Text(_darkMode ? 'On' : 'Off'),
              value: _darkMode,
              onChanged: (value) => setState(() => _darkMode = value),
            ),
          ],
        ),
      ),
    );
  }
}
```
