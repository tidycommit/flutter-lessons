import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

/// Lesson 30: PopScope for handling back.
///
/// The lesson screen is pushed on the app's root navigator, and "Write a
/// note" pushes the note screen on that same navigator, as in the snippet.
/// So the PopScope sits on the top route and guards only that route: the
/// AppBar back arrow, system back and the back swipe all ask the top route
/// first, and the lesson list underneath is never popped by mistake.
class Lesson30PopScope extends StatelessWidget {
  const Lesson30PopScope({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PopScope Tip'),
        actions: const [LessonInfoButton(lessonId: 30)],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Lesson30EditNote()),
          ),
          child: const Text('Write a note'),
        ),
      ),
    );
  }
}

class Lesson30EditNote extends StatefulWidget {
  const Lesson30EditNote({super.key});

  @override
  State<Lesson30EditNote> createState() => _Lesson30EditNoteState();
}

class _Lesson30EditNoteState extends State<Lesson30EditNote> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _confirmLeave() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard note?'),
        content: const Text('Your note will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    if (leave == true && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasText,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _confirmLeave();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('New Note')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Type something...'),
            onChanged: (text) => setState(() => _hasText = text.isNotEmpty),
          ),
        ),
      ),
    );
  }
}
