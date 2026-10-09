import 'package:flutter/material.dart';

/// Lesson 08: A box centered in the available space.
class CenterLesson extends StatelessWidget {
  const CenterLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 160,
        height: 160,
        color: Colors.indigo,
        alignment: Alignment.center,
        child: const Text(
          'Centered',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
