import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

/// Lesson 29: showDialog and showModalBottomSheet as routes.
///
/// The dialog and the bottom sheet are pushed on top of this screen, which
/// is itself the route pushed from the lesson list. Closing either one pops
/// only that popup route, so the AppBar's back arrow still leads straight
/// back to the lesson list.
class Lesson29Popups extends StatefulWidget {
  const Lesson29Popups({super.key});

  @override
  State<Lesson29Popups> createState() => _Lesson29PopupsState();
}

class _Lesson29PopupsState extends State<Lesson29Popups> {
  String _message = 'Nothing chosen yet';

  Future<void> _askToDelete() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete photo?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    setState(() {
      _message = confirmed == true ? 'Photo deleted' : 'Kept the photo';
    });
  }

  Future<void> _pickShare() async {
    final String? app = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              onTap: () => Navigator.pop(sheetContext, 'Email'),
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Messages'),
              onTap: () => Navigator.pop(sheetContext, 'Messages'),
            ),
          ],
        ),
      ),
    );
    if (!mounted || app == null) return;
    setState(() => _message = 'Shared with $app');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popups Tip'),
        actions: const [LessonInfoButton(lessonId: 29)],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_message, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _askToDelete,
              child: const Text('Delete photo'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _pickShare, child: const Text('Share')),
          ],
        ),
      ),
    );
  }
}
