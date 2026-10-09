import 'package:flutter/material.dart';

/// Lesson 07: Content kept clear of system UI with SafeArea.
class SafeAreaLesson extends StatelessWidget {
  const SafeAreaLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      // The light background shows any inset area SafeArea keeps clear.
      color: Colors.orange.shade100,
      child: SafeArea(
        child: Container(
          color: Colors.orange,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(24),
          child: const Text(
            'This box stays clear of notches, status bars and the home '
            'indicator.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
