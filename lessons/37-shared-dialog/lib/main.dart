import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 37,
  title: 'Shared confirm dialog',
  notesAsset: '37-shared-dialog.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: Lesson37SharedDialog());

void main() => runApp(lessonApp);

/// One shared confirm dialog. Returns true only when the user confirms.
Future<bool> showAppConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Delete',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false; // tapping outside counts as cancel
}

/// The page: each delete goes through [showAppConfirmDialog].
class Lesson37SharedDialog extends StatefulWidget {
  const Lesson37SharedDialog({super.key});

  @override
  State<Lesson37SharedDialog> createState() => _Lesson37SharedDialogState();
}

class _Lesson37SharedDialogState extends State<Lesson37SharedDialog> {
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3'];

  Future<void> _deleteLast() async {
    final name = _items.last;
    final confirmed = await showAppConfirmDialog(
      context,
      title: 'Delete $name?',
      message: "This removes it from the list. You can't undo this.",
    );
    if (!mounted || !confirmed) return;
    setState(() => _items.removeLast());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppDialog'),
        actions: const [LessonInfoButton(lessonId: 37)],
      ),
      body: Column(
        children: [
          for (final item in _items)
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.check)),
              title: Text(item),
            ),
          const SizedBox(height: 24),
          if (_items.isEmpty)
            const Text('All items deleted.')
          else
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: _deleteLast,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete item'),
            ),
        ],
      ),
    );
  }
}
