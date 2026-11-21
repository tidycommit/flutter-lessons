# Lesson 62: Programmatic UI vs server-driven UI (SDUI)

**Date:** Nov 20, 2026

Programmatic UI means you build widgets in Dart: Column, Text, Button, all checked by the compiler. Server-driven UI (SDUI) means the app downloads JSON that describes the screen and inflates it into widgets at runtime. The big win is that the backend can change a layout without a store release. The cost is a runtime mapper, and mistakes show up when the app runs instead of when it compiles.

Two rules keep SDUI safe. First, keep a whitelist of component types: the mapper only builds 'column', 'text' and 'button', and ignores anything else. Second, map each JSON type to the same shared widgets your programmatic screens use, so both paths look identical. The demo below has a Programmatic / SDUI toggle that shows the same result both ways. No new packages are needed.

## Key points

- Programmatic UI builds widgets in Dart. SDUI downloads JSON and inflates a limited catalog of widgets at runtime.
- Keep a whitelist of component types. Unknown types are ignored (`SizedBox.shrink()`).
- Map each JSON type to the same shared widgets the programmatic path uses, so both paths look identical.

## Code

The tip's snippet, verbatim:

```dart
import 'dart:convert';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: SduiDemo()));

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
      return Text(node['value'] as String,
          style: const TextStyle(fontSize: 24));
    case 'button':
      return FilledButton(onPressed: () {}, child: Text(node['value'] as String));
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
      appBar: AppBar(title: const Text('SDUI')),
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
                  const Text('Hello from JSON',
                      style: TextStyle(fontSize: 24)),
                  FilledButton(onPressed: () {}, child: const Text('Tap')),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
```

## On screen

An app bar titled "SDUI". Under it, a Programmatic / SDUI toggle (SDUI selected at start). Below that, the text "Hello from JSON" and a "Tap" button. Tapping "Programmatic" swaps in a hard-coded Column that looks exactly the same; tapping "SDUI" builds it again from the JSON string.

## How it is adapted in this app

- This lesson is its own Flutter project. The snippet's `MaterialApp` is this project's `LessonApp` from the shared `lesson_kit` package, so the info button can find these notes. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` uses `SduiDemo` as home.
- `SduiDemo`'s AppBar keeps `title: const Text('SDUI')` and gets `actions: const [LessonInfoButton(lessonId: 62)]`. `layoutJson`, `inflate`, and `SduiDemo` keep the snippet's names and behavior. `SegmentedButton` is not a const call, because its selected set and `onSelectionChanged` are not compile-time constants.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
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
```
