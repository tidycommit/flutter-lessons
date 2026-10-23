import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 27,
  title: 'Tabs with TabBar, TabBarView, and DefaultTabController',
  notesAsset: '27-tabbar.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: Lesson27Tabs());

void main() => runApp(lessonApp);

/// Lesson 27: Tabs with TabBar, TabBarView and DefaultTabController.
///
/// Switching tabs pushes no route, so the AppBar never grows a back arrow.
class Lesson27Tabs extends StatelessWidget {
  const Lesson27Tabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tabs Tip'),
          actions: const [LessonInfoButton(lessonId: 27)],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car), text: 'Car'),
              Tab(icon: Icon(Icons.directions_bike), text: 'Bike'),
              Tab(icon: Icon(Icons.directions_walk), text: 'Walk'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Driving: 10 min')),
            Center(child: Text('Biking: 25 min')),
            Center(child: Text('Walking: 50 min')),
          ],
        ),
      ),
    );
  }
}
