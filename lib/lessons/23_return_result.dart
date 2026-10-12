import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

/// Lesson 23: Returning a result with Navigator.pop(context, value) and await.
class Lesson23PickColor extends StatefulWidget {
  const Lesson23PickColor({super.key});

  @override
  State<Lesson23PickColor> createState() => _Lesson23PickColorState();
}

class _Lesson23PickColorState extends State<Lesson23PickColor> {
  String _color = 'none yet';

  Future<void> _pickColor() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const Lesson23ColorPicker()),
    );
    if (result != null) {
      setState(() => _color = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick a Color'),
        actions: const [LessonInfoButton(lessonId: 23)],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Favorite color: $_color',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickColor,
              child: const Text('Choose color'),
            ),
          ],
        ),
      ),
    );
  }
}

class Lesson23ColorPicker extends StatelessWidget {
  const Lesson23ColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    const colors = ['Red', 'Green', 'Blue'];
    return Scaffold(
      appBar: AppBar(title: const Text('Colors')),
      body: ListView(
        children: [
          for (final color in colors)
            ListTile(
              title: Text(color),
              onTap: () => Navigator.pop(context, color),
            ),
        ],
      ),
    );
  }
}
