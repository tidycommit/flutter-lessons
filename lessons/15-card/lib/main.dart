import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 15,
  title: 'Card with ListTile',
  notesAsset: '15-card.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: CardLesson());

void main() => runApp(lessonApp);

/// Lesson 15: A Card holding a ListTile with a person icon, name and role.
class CardLesson extends StatelessWidget {
  const CardLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cards'),
        actions: const [LessonInfoButton(lessonId: 15)],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Ada Lovelace'),
            subtitle: Text('Mathematician'),
          ),
        ),
      ),
    );
  }
}
