import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 6,
  title: 'Expanded',
  notesAsset: '06-expanded.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: ExpandedLesson());

void main() => runApp(lessonApp);

/// Lesson 06: Expanded children sharing space by flex factor.
class ExpandedLesson extends StatelessWidget {
  const ExpandedLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expanded'),
        actions: const [LessonInfoButton(lessonId: 6)],
      ),
      body: const Column(
        children: [
          _Panel(color: Colors.blueGrey, label: 'Fixed height: 80', height: 80),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _Panel(color: Colors.red, label: 'flex: 1'),
                ),
                Expanded(
                  flex: 2,
                  child: _Panel(color: Colors.green, label: 'flex: 2'),
                ),
                Expanded(
                  child: _Panel(color: Colors.blue, label: 'flex: 1'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.color, required this.label, this.height});

  final Color color;
  final String label;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: color,
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}
