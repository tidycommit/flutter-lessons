import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 22,
  title: 'Passing data to a new screen through its constructor',
  notesAsset: '22-passing-data.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: Lesson22FruitList());

void main() => runApp(lessonApp);

/// Lesson 22: Passing data to a new screen through its constructor.
class Lesson22FruitList extends StatelessWidget {
  const Lesson22FruitList({super.key});

  static const fruits = ['Apple', 'Banana', 'Cherry'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fruits'),
        actions: const [LessonInfoButton(lessonId: 22)],
      ),
      body: ListView(
        children: [
          for (final fruit in fruits)
            ListTile(
              title: Text(fruit),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Pushes onto the app's navigator; the detail screen's
                // back arrow returns here.
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => Lesson22FruitDetail(name: fruit),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class Lesson22FruitDetail extends StatelessWidget {
  const Lesson22FruitDetail({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(
        child: Text('You picked $name!', style: const TextStyle(fontSize: 28)),
      ),
    );
  }
}
