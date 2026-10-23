import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 28,
  title: 'A Drawer menu that navigates',
  notesAsset: '28-drawer.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: Lesson28Drawer());

void main() => runApp(lessonApp);

/// Lesson 28: A Drawer menu that navigates.
///
/// Giving the Scaffold a `drawer:` makes the hamburger icon the AppBar's
/// leading widget. The system or browser back button closes an open drawer
/// first, and returns from a pushed page to the drawer screen.
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
        actions: const [LessonInfoButton(lessonId: 28)],
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
