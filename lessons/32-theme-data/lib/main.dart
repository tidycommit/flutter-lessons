import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 32,
  title: 'ThemeData as the source of truth',
  notesAsset: '32-theme-data.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonScope(lesson: lesson, child: Lesson32ThemeData());

void main() => runApp(lessonApp);

/// Lesson 32: ThemeData as the single source of visual truth.
///
/// The project owns its `MaterialApp`, so the snippet's `theme`,
/// `darkTheme` and `themeMode` apply to the whole app. A [LessonScope]
/// around it (see `main.dart`) lets the info button find the notes.
class Lesson32ThemeData extends StatefulWidget {
  const Lesson32ThemeData({super.key});

  @override
  State<Lesson32ThemeData> createState() => _Lesson32ThemeDataState();
}

class _Lesson32ThemeDataState extends State<Lesson32ThemeData> {
  bool _dark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // One place decides the look of the whole tree.
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ThemeData'),
          actions: const [LessonInfoButton(lessonId: 32)],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: const Text('Dark mode'),
              value: _dark,
              onChanged: (value) => setState(() => _dark = value),
            ),
            const SizedBox(height: 12),
            const Lesson32ThemedCard(),
          ],
        ),
      ),
    );
  }
}

class Lesson32ThemedCard extends StatelessWidget {
  const Lesson32ThemedCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Read values from the theme instead of hardcoding Colors.blue.
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order summary', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Every color here comes from Theme.of(context).',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Primary color',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () {}, child: const Text('Checkout')),
          ],
        ),
      ),
    );
  }
}
