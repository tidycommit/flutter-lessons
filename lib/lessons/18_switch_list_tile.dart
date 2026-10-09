import 'package:flutter/material.dart';

/// Lesson 18: A Dark mode switch that re-themes the example with setState.
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
