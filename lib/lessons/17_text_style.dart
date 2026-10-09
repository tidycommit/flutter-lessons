import 'package:flutter/material.dart';

/// Lesson 17: Large, bold, deep purple text.
class TextStyleLesson extends StatelessWidget {
  const TextStyleLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Hello, Flutter!',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}
