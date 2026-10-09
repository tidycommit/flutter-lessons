import 'package:flutter/material.dart';

import '../lessons/lesson.dart';
import '../lessons/lessons.dart';
import 'lesson_screen.dart';

/// Lists every lesson and opens its example screen on tap.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _open(BuildContext context, Lesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => LessonScreen(lesson: lesson)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Lessons')),
      body: ListView.separated(
        itemCount: lessons.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          return ListTile(
            leading: CircleAvatar(child: Text(lesson.number)),
            title: Text(lesson.title),
            subtitle: Text(lesson.formattedDate),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(context, lesson),
          );
        },
      ),
    );
  }
}
