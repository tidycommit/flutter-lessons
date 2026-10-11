import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

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
