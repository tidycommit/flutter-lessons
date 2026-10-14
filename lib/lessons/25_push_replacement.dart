import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

/// Lesson 25: Leaving screens behind with `pushReplacement` and
/// `pushAndRemoveUntil`.
///
/// Both calls rewrite the navigator's stack. On the app's root navigator they
/// would wipe the lesson list, so the lesson hosts its own nested Navigator
/// and only that stack is replaced or cleared.
class Lesson25LoginFlow extends StatefulWidget {
  const Lesson25LoginFlow({super.key});

  @override
  State<Lesson25LoginFlow> createState() => _Lesson25LoginFlowState();
}

class _Lesson25LoginFlowState extends State<Lesson25LoginFlow> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // System and browser back pop the nested Navigator first (Settings back
    // to Home); on a screen that is alone in the stack they leave the lesson.
    return NavigatorPopHandler<Object?>(
      onPopWithResult: (_) => _navigatorKey.currentState!.maybePop(),
      child: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (settings) => MaterialPageRoute<void>(
          builder: (context) => const Lesson25Login(),
          settings: settings,
        ),
      ),
    );
  }
}

/// Leaves the lesson for the lesson list. Login and Home have no back arrow
/// by design, so this sits in their AppBar actions instead of `leading`.
class Lesson25ExitButton extends StatelessWidget {
  const Lesson25ExitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.list),
      tooltip: 'Back to lessons',
      onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
    );
  }
}

class Lesson25Login extends StatelessWidget {
  const Lesson25Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: const [Lesson25ExitButton(), LessonInfoButton(lessonId: 25)],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Replace Login with Home: nothing to go back to.
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Lesson25Home()),
            );
          },
          child: const Text('Log in'),
        ),
      ),
    );
  }
}

class Lesson25Home extends StatelessWidget {
  const Lesson25Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'), // no back arrow appears
        actions: const [Lesson25ExitButton(), LessonInfoButton(lessonId: 25)],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Welcome! You are logged in.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Lesson25Settings(),
                  ),
                );
              },
              child: const Text('Open Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class Lesson25Settings extends StatelessWidget {
  const Lesson25Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')), // back arrow to Home
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Push Login and clear every screen beneath it.
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Lesson25Login()),
              (route) => false,
            );
          },
          child: const Text('Log out'),
        ),
      ),
    );
  }
}
