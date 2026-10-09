import 'package:flutter/material.dart';

/// Lesson 20: A teal CircleAvatar showing placeholder initials.
class CircleAvatarLesson extends StatelessWidget {
  const CircleAvatarLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircleAvatar(
        radius: 48,
        backgroundColor: Colors.teal,
        // Placeholder initials; swap in a real user's initials or a
        // backgroundImage in an app.
        child: Text('AB', style: TextStyle(fontSize: 32, color: Colors.white)),
      ),
    );
  }
}
