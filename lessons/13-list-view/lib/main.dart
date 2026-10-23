import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 13,
  title: 'ListView of ListTiles',
  notesAsset: '13-list-view.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: ListViewLesson());

void main() => runApp(lessonApp);

/// Lesson 13: A scrolling ListView with three ListTiles.
class ListViewLesson extends StatelessWidget {
  const ListViewLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My List'),
        actions: const [LessonInfoButton(lessonId: 13)],
      ),
      body: ListView(
        children: const [
          ListTile(title: Text('Apples')),
          ListTile(title: Text('Bananas')),
          ListTile(title: Text('Cherries')),
        ],
      ),
    );
  }
}
