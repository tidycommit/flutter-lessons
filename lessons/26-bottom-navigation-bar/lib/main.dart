import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 26,
  title: 'BottomNavigationBar',
  notesAsset: '26-bottom-navigation-bar.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: Lesson26BottomNav());

void main() => runApp(lessonApp);

/// Lesson 26: BottomNavigationBar.
///
/// Tapping an item swaps the body in place; no route is pushed, so the
/// AppBar never grows a back arrow.
class Lesson26BottomNav extends StatefulWidget {
  const Lesson26BottomNav({super.key});

  @override
  State<Lesson26BottomNav> createState() => _Lesson26BottomNavState();
}

class _Lesson26BottomNavState extends State<Lesson26BottomNav> {
  int _currentIndex = 0;

  static const _titles = ['Home', 'Search', 'Profile'];
  static const _bodies = ['Home page', 'Search page', 'Profile page'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: const [LessonInfoButton(lessonId: 26)],
      ),
      body: Center(
        child: Text(
          _bodies[_currentIndex],
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
