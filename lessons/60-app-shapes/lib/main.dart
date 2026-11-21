import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 60,
  title: 'Package vs app vs add-to-app module',
  notesAsset: '60-app-shapes.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: AppShapesPage());

void main() => runApp(lessonApp);

class AppShape {
  const AppShape({
    required this.title,
    required this.subtitle,
    required this.bullets,
  });

  final String title;
  final String subtitle;
  final List<String> bullets;
}

const shapes = [
  AppShape(
    title: 'Package',
    subtitle: 'Reusable library: UI + logic, no main().',
    bullets: [
      'No main() of its own',
      'Reusable UI and logic other apps can depend on',
      'Tested on its own',
    ],
  ),
  AppShape(
    title: 'App',
    subtitle: 'Has main(), hosts packages, sets theme and router.',
    bullets: [
      'Has main() — this is what you launch',
      'Hosts one or more packages',
      'Sets the theme and the router',
    ],
  ),
  AppShape(
    title: 'Module (add-to-app)',
    subtitle: 'Flutter compiled into an existing native app.',
    bullets: [
      'Lives inside an existing iOS or Android app',
      'Native owns the chrome (status bar, tabs, back stack)',
      'Flutter fills one screen or a flow inside that shell',
    ],
  ),
];

class AppShapesPage extends StatelessWidget {
  const AppShapesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App shapes'),
        actions: const [LessonInfoButton(lessonId: 60)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final shape in shapes)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: ListTile(
                  title: Text(shape.title),
                  subtitle: Text(shape.subtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ShapeDetailPage(shape: shape),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ShapeDetailPage extends StatelessWidget {
  const ShapeDetailPage({super.key, required this.shape});

  final AppShape shape;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(shape.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final bullet in shape.bullets)
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: Text(bullet),
            ),
        ],
      ),
    );
  }
}
