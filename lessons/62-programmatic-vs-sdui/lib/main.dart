import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 62,
  title: 'Programmatic UI vs server-driven UI (SDUI)',
  notesAsset: '62-programmatic-vs-sdui.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: SduiDemo());

void main() => runApp(lessonApp);

const String layoutJson = '''
{
  "type": "column",
  "children": [
    { "type": "text", "value": "Hello from JSON" },
    { "type": "button", "value": "Tap" }
  ]
}
''';

// The whitelist: only these types can ever be built.
Widget inflate(Map<String, dynamic> node) {
  switch (node['type']) {
    case 'column':
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final c in node['children'] as List)
            inflate(c as Map<String, dynamic>),
        ],
      );
    case 'text':
      return Text(
        node['value'] as String,
        style: const TextStyle(fontSize: 24),
      );
    case 'button':
      return FilledButton(
        onPressed: () {},
        child: Text(node['value'] as String),
      );
    default:
      return const SizedBox.shrink(); // unknown type: ignore safely
  }
}

class SduiDemo extends StatefulWidget {
  const SduiDemo({super.key});

  @override
  State<SduiDemo> createState() => _SduiDemoState();
}

class _SduiDemoState extends State<SduiDemo> {
  bool sdui = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SDUI'),
        actions: const [LessonInfoButton(lessonId: 62)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Programmatic')),
                ButtonSegment(value: true, label: Text('SDUI')),
              ],
              selected: {sdui},
              onSelectionChanged: (s) => setState(() => sdui = s.first),
            ),
            const SizedBox(height: 24),
            if (sdui)
              inflate(jsonDecode(layoutJson) as Map<String, dynamic>)
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Hello from JSON', style: TextStyle(fontSize: 24)),
                  FilledButton(onPressed: () {}, child: const Text('Tap')),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
