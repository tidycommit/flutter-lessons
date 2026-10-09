import 'package:flutter/material.dart';

/// Lesson 09: A decorated Container with size, padding, rounded corners and a shadow.
class ContainerLesson extends StatelessWidget {
  const ContainerLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 240,
        height: 140,
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.lightBlue.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.lightBlue, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: const Text(
          'width, height, padding and a BoxDecoration',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
