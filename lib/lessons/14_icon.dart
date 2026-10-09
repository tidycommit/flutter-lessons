import 'package:flutter/material.dart';

/// Lesson 14: A large red heart icon.
class IconLesson extends StatelessWidget {
  const IconLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.favorite,
        size: 64,
        color: Colors.red,
        semanticLabel: 'Favorite',
      ),
    );
  }
}
