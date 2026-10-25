import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 36,
  title: 'Alert for errors, Toast for success',
  notesAsset: '36-alert-vs-toast.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: Lesson36AlertVsToast());

void main() => runApp(lessonApp);

/// Durable alert: stays visible until the user dismisses it.
class AppAlert extends StatelessWidget {
  const AppAlert({super.key, required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.error),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colors.onErrorContainer),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Dismiss',
            onPressed: onDismiss,
          ),
        ],
      ),
    );
  }
}

/// The page: an error shows as an [AppAlert], a success as a short SnackBar.
class Lesson36AlertVsToast extends StatefulWidget {
  const Lesson36AlertVsToast({super.key});

  @override
  State<Lesson36AlertVsToast> createState() => _Lesson36AlertVsToastState();
}

class _Lesson36AlertVsToastState extends State<Lesson36AlertVsToast> {
  String? _error;

  void _simulateError() {
    setState(() => _error = 'Could not save. Check your connection.');
  }

  void _simulateSuccess() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Saved!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        actions: const [LessonInfoButton(lessonId: 36)],
      ),
      body: Column(
        children: [
          if (_error != null)
            AppAlert(
              message: _error!,
              onDismiss: () => setState(() => _error = null),
            ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _simulateError,
            child: const Text('Simulate error'),
          ),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: _simulateSuccess,
            child: const Text('Simulate success'),
          ),
        ],
      ),
    );
  }
}
