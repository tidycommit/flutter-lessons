import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

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
