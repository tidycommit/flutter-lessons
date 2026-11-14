import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 50,
  title: 'ShellRoute bottom nav',
  notesAsset: '50-shell-route.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonScope(lesson: lesson, child: Lesson50ShellRoute());

void main() => runApp(lessonApp);

const List<String> tabPaths = ['/home', '/search', '/profile'];

/// Lesson 50: ShellRoute with a shared AppBar and bottom bar.
///
/// The project owns a nested `MaterialApp.router`, so the snippet's paths
/// stay inside this lesson. A [LessonScope] around it (see `main.dart`) lets
/// the info button find the notes. Each mount builds its own [GoRouter] so
/// a test can open the app more than once.
class Lesson50ShellRoute extends StatefulWidget {
  const Lesson50ShellRoute({super.key});

  @override
  State<Lesson50ShellRoute> createState() => _Lesson50ShellRouteState();
}

class _Lesson50ShellRouteState extends State<Lesson50ShellRoute> {
  late final GoRouter _router = GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TabPage(
                label: 'Home',
                icon: Icons.home,
                color: Colors.teal,
              ),
            ),
          ),
          GoRoute(
            path: '/search',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TabPage(
                label: 'Search',
                icon: Icons.search,
                color: Colors.orange,
              ),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TabPage(
                label: 'Profile',
                icon: Icons.person,
                color: Colors.indigo,
              ),
            ),
          ),
        ],
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

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final index = tabPaths.indexOf(path).clamp(0, tabPaths.length - 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ShellRoute'),
        actions: const [LessonInfoButton(lessonId: 50)],
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => context.go(tabPaths[i]),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class TabPage extends StatelessWidget {
  const TabPage({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withValues(alpha: 0.15),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 72, color: color),
          const SizedBox(height: 12),
          Text(label, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text('Path: ${GoRouterState.of(context).uri.path}'),
        ],
      ),
    );
  }
}
