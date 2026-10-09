import 'package:flutter/material.dart';

/// Lesson 19: A Save button that shows a 'Saved!' SnackBar.
class SnackBarLesson extends StatelessWidget {
  const SnackBarLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Saved!')));
        },
        icon: const Icon(Icons.save),
        label: const Text('Save'),
      ),
    );
  }
}
