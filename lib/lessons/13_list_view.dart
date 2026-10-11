import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

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
