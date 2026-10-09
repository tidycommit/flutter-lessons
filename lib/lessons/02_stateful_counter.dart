import 'package:flutter/material.dart';

/// Lesson 02: A counter that rebuilds when its State changes.
class StatefulCounterLesson extends StatefulWidget {
  const StatefulCounterLesson({super.key});

  @override
  State<StatefulCounterLesson> createState() => _StatefulCounterLessonState();
}

class _StatefulCounterLessonState extends State<StatefulCounterLesson> {
  int _count = 0;

  void _increment() {
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('You have pressed the button this many times:'),
          Text('$_count', style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _increment,
            icon: const Icon(Icons.add),
            label: const Text('Increment'),
          ),
        ],
      ),
    );
  }
}
