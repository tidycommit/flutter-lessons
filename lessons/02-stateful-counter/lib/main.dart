import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 2,
  title: 'StatefulWidget counter',
  notesAsset: '02-stateful-counter.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: StatefulCounterLesson());

void main() => runApp(lessonApp);

/// Lesson 02: A counter that rebuilds when its State changes.
class StatefulCounterLesson extends StatefulWidget {
  const StatefulCounterLesson({super.key});

  @override
  State<StatefulCounterLesson> createState() => _StatefulCounterLessonState();
}

class _StatefulCounterLessonState extends State<StatefulCounterLesson> {
  int _count = 0;

  void _increment() {
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
        actions: const [LessonInfoButton(lessonId: 2)],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('You have pressed the button this many times:'),
            Text('$_count', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _increment,
              icon: const Icon(Icons.add),
              label: const Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
