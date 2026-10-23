import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 25,
  title: 'Leaving screens behind with pushReplacement and pushAndRemoveUntil',
  notesAsset: '25-push-replacement.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: Lesson25Login());

void main() => runApp(lessonApp);

/// Lesson 25: Leaving screens behind with `pushReplacement` and
/// `pushAndRemoveUntil`.
///
/// The project's `MaterialApp` (from `LessonApp`) has Login as its home, so
/// both calls rewrite the app's own stack, just as in the snippet.
class Lesson25Login extends StatelessWidget {
  const Lesson25Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: const [LessonInfoButton(lessonId: 25)],
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
        actions: const [LessonInfoButton(lessonId: 25)],
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
