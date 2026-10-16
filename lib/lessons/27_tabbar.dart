import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

/// Lesson 27: Tabs with TabBar, TabBarView and DefaultTabController.
///
/// Switching tabs pushes no route, so the AppBar's back arrow always leads
/// straight back to the lesson list.
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
