import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

/// Lesson 24: Named routes with `routes` and `Navigator.pushNamed`.
///
/// The lesson can't own the app's MaterialApp, so it hosts its own nested
/// Navigator with the same route names.
class Lesson24NamedRoutes extends StatefulWidget {
  const Lesson24NamedRoutes({super.key});

  /// The same route map as the snippet's MaterialApp `routes`.
  static final routes = <String, WidgetBuilder>{
    '/': (context) => const Lesson24Home(),
    '/settings': (context) => const Lesson24Settings(),
    '/about': (context) => const Lesson24About(),
  };

  @override
  State<Lesson24NamedRoutes> createState() => _Lesson24NamedRoutesState();
}

class _Lesson24NamedRoutesState extends State<Lesson24NamedRoutes> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // System and browser back pop the nested Navigator first (Settings or
    // About back to Home); on Home they leave the lesson.
    return NavigatorPopHandler<Object?>(
      onPopWithResult: (_) => _navigatorKey.currentState!.maybePop(),
      child: Navigator(
        key: _navigatorKey,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          final builder = Lesson24NamedRoutes.routes[settings.name];
          if (builder == null) return null;
          return MaterialPageRoute<void>(builder: builder, settings: settings);
        },
      ),
    );
  }
}

class Lesson24Home extends StatelessWidget {
  const Lesson24Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Home is the nested Navigator's first route, so there is no implied
        // back arrow. This one pops the lesson off the app's navigator.
        leading: BackButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
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
