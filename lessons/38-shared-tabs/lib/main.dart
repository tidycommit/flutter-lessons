import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 38,
  title: 'Shared tabs pattern',
  notesAsset: '38-shared-tabs.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: Lesson38SharedTabs());

void main() => runApp(lessonApp);

/// One shared tabs widget: labels on top, matching pages below.
class AppTabs extends StatelessWidget {
  const AppTabs({super.key, required this.labels, required this.children})
    : assert(
        labels.length == children.length,
        'Each tab label needs exactly one page.',
      );

  final List<String> labels;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: labels.length,
      child: Column(
        children: [
          TabBar(tabs: [for (final label in labels) Tab(text: label)]),
          Expanded(child: TabBarView(children: children)),
        ],
      ),
    );
  }
}

/// The page: three tabs built with the shared [AppTabs] widget.
class Lesson38SharedTabs extends StatelessWidget {
  const Lesson38SharedTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppTabs'),
        actions: const [LessonInfoButton(lessonId: 38)],
      ),
      // Not `const AppTabs(...)`: a const call would evaluate the assert
      // at compile time, and `List.length` isn't allowed there.
      body: AppTabs(
        labels: const ['Overview', 'Details', 'Settings'],
        children: const [
          _TabPage(text: 'Overview content'),
          _TabPage(text: 'Details content'),
          _TabPage(text: 'Settings content'),
        ],
      ),
    );
  }
}

/// Each tab body is its own small, independent widget.
class _TabPage extends StatelessWidget {
  const _TabPage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text, style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}
