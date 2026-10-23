import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 4,
  title: 'Column and Row alignment',
  notesAsset: '04-column-row.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: ColumnRowLesson());

void main() => runApp(lessonApp);

/// Lesson 04: Rows of boxes using different MainAxisAlignment values inside a Column.
class ColumnRowLesson extends StatelessWidget {
  const ColumnRowLesson({super.key});

  static const _alignments = [
    MainAxisAlignment.start,
    MainAxisAlignment.center,
    MainAxisAlignment.end,
    MainAxisAlignment.spaceBetween,
    MainAxisAlignment.spaceEvenly,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Column & Row'),
        actions: const [LessonInfoButton(lessonId: 4)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final alignment in _alignments) ...[
              Text('MainAxisAlignment.${alignment.name}'),
              Row(
                mainAxisAlignment: alignment,
                children: const [
                  _Box(color: Colors.red),
                  _Box(color: Colors.green),
                  _Box(color: Colors.blue),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.all(4),
      color: color,
    );
  }
}
