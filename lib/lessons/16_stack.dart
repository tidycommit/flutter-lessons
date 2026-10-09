import 'package:flutter/material.dart';

/// Lesson 16: A box with a red 'NEW' badge that hangs over its corner.
class StackLesson extends StatelessWidget {
  const StackLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        // Let the badge draw outside the Stack's bounds.
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 180,
            height: 110,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('Product', style: TextStyle(fontSize: 18)),
          ),
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'NEW',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
