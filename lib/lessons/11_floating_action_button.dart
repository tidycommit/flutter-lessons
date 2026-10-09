import 'package:flutter/material.dart';

/// Lesson 11: A Scaffold with a FloatingActionButton that increments a counter.
class FloatingActionButtonLesson extends StatefulWidget {
  const FloatingActionButtonLesson({super.key});

  @override
  State<FloatingActionButtonLesson> createState() =>
      _FloatingActionButtonLessonState();
}

class _FloatingActionButtonLessonState
    extends State<FloatingActionButtonLesson> {
  int _items = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Items added: $_items')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _items++),
        tooltip: 'Add item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
