import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

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
