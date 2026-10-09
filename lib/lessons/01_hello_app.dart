import 'package:flutter/material.dart';

/// Lesson 01: The smallest useful widget: some centered text.
class HelloAppLesson extends StatelessWidget {
  const HelloAppLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Hello, world!', style: TextStyle(fontSize: 24)),
    );
  }
}
