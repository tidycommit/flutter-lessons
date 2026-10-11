import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

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
