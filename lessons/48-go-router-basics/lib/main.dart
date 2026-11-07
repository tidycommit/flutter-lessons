import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 48,
  title: 'go_router paths',
  notesAsset: '48-go-router-basics.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonScope(lesson: lesson, child: Lesson48GoRouterBasics());

void main() => runApp(lessonApp);

/// Lesson 48: go_router paths and `GoRoute`.
///
/// The project owns a nested `MaterialApp.router`, so the snippet's paths
/// stay inside this lesson. A [LessonScope] around it (see `main.dart`) lets
/// the info button find the notes. Each mount builds its own [GoRouter] so
/// a test can open the app more than once.
class Lesson48GoRouterBasics extends StatefulWidget {
  const Lesson48GoRouterBasics({super.key});

  @override
  State<Lesson48GoRouterBasics> createState() => _Lesson48GoRouterBasicsState();
}

class _Lesson48GoRouterBasicsState extends State<Lesson48GoRouterBasics> {
  late final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const Lesson48Home()),
      GoRoute(
        path: '/details',
        builder: (context, state) => const Lesson48Details(),
      ),
    ],
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

class Lesson48Home extends StatelessWidget {
  const Lesson48Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('go_router'),
        actions: const [LessonInfoButton(lessonId: 48)],
      ),
      body: Center(
        child: FilledButton(
          onPressed: () => context.push('/details'),
          child: const Text('Open details'),
        ),
      ),
    );
  }
}

class Lesson48Details extends StatelessWidget {
  const Lesson48Details({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(child: Text('You pushed /details')),
    );
  }
}
