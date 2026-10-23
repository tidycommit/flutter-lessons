import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 24,
  title: 'Named routes with routes and Navigator.pushNamed',
  notesAsset: '24-named-routes.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonScope(lesson: lesson, child: Lesson24NamedRoutes());

void main() => runApp(lessonApp);

/// Lesson 24: Named routes with `routes` and `Navigator.pushNamed`.
///
/// The project owns its `MaterialApp`, so the snippet's `initialRoute` and
/// `routes` map are used as written. A [LessonScope] around it (see
/// `main.dart`) lets the info button find the notes.
class Lesson24NamedRoutes extends StatelessWidget {
  const Lesson24NamedRoutes({super.key});

  /// The snippet's MaterialApp `routes`.
  static final routes = <String, WidgetBuilder>{
    '/': (context) => const Lesson24Home(),
    '/settings': (context) => const Lesson24Settings(),
    '/about': (context) => const Lesson24About(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: routes,
    );
  }
}

class Lesson24Home extends StatelessWidget {
  const Lesson24Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: const [LessonInfoButton(lessonId: 24)],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              child: const Text('Settings'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/about'),
              child: const Text('About'),
            ),
          ],
        ),
      ),
    );
  }
}

class Lesson24Settings extends StatelessWidget {
  const Lesson24Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings screen')),
    );
  }
}

class Lesson24About extends StatelessWidget {
  const Lesson24About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Center(child: Text('About this app')),
    );
  }
}
