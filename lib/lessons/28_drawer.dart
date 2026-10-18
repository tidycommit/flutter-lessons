import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

/// Lesson 28: A Drawer menu that navigates.
///
/// Giving the Scaffold a `drawer:` makes the hamburger icon the AppBar's
/// leading widget, which replaces the back arrow to the lesson list. The
/// AppBar is kept exactly as the snippet writes it, so the way back to the
/// list is a "Back to lessons" action next to the info button, as in
/// lesson 25. The system or browser back button still closes an open drawer
/// first and otherwise leaves the lesson.
class Lesson28Drawer extends StatelessWidget {
  const Lesson28Drawer({super.key});

  void _openPage(BuildContext context, String title) {
    Navigator.pop(context); // close the drawer first
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Lesson28Page(title: title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawer Tip'),
        actions: const [Lesson28ExitButton(), LessonInfoButton(lessonId: 28)],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context), // just close it
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => _openPage(context, 'Settings'),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () => _openPage(context, 'About'),
            ),
          ],
        ),
      ),
      body: const Center(child: Text('Tap the menu icon to open the drawer')),
    );
  }
}

/// Leaves the lesson for the lesson list. The hamburger icon takes the
/// AppBar's `leading` slot, so this sits in the AppBar actions instead.
class Lesson28ExitButton extends StatelessWidget {
  const Lesson28ExitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.list),
      tooltip: 'Back to lessons',
      onPressed: () => Navigator.pop(context),
    );
  }
}

class Lesson28Page extends StatelessWidget {
  const Lesson28Page({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('This is the $title page')),
    );
  }
}
