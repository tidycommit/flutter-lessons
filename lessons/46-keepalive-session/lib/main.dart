import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 46,
  title: 'keepAlive shared state',
  notesAsset: '46-keepalive-session.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
///
/// ProviderScope stores every provider's state. It must sit above any
/// widget that uses ref.
const lessonApp = ProviderScope(
  child: LessonApp(lesson: lesson, home: Lesson46KeepAliveSession()),
);

void main() => runApp(lessonApp);

// Survives when nobody is listening.
class Session extends Notifier<String?> {
  @override
  String? build() {
    ref.keepAlive();
    return null;
  }

  void login(String name) => state = name;
  void logout() => state = null;
}

// Same thing without keepAlive: it resets once unwatched.
class TempSession extends Notifier<String?> {
  @override
  String? build() => null;

  void login(String name) => state = name;
  void logout() => state = null;
}

final sessionProvider = NotifierProvider.autoDispose<Session, String?>(
  Session.new,
);
final tempSessionProvider = NotifierProvider.autoDispose<TempSession, String?>(
  TempSession.new,
);

class Lesson46KeepAliveSession extends StatefulWidget {
  const Lesson46KeepAliveSession({super.key});

  @override
  State<Lesson46KeepAliveSession> createState() =>
      _Lesson46KeepAliveSessionState();
}

class _Lesson46KeepAliveSessionState extends State<Lesson46KeepAliveSession> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session'),
        actions: const [LessonInfoButton(lessonId: 46)],
      ),
      // Only the current tab is built, so Profile stops listening when hidden.
      body: tab == 0 ? const ProfileTab() : const OtherTab(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.apps), label: 'Other'),
        ],
      ),
    );
  }
}

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kept = ref.watch(sessionProvider);
    final temp = ref.watch(tempSessionProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.lock),
          title: const Text('Session (keepAlive)'),
          subtitle: Text(kept ?? 'Signed out'),
        ),
        ListTile(
          leading: const Icon(Icons.timer_outlined),
          title: const Text('Temp session (auto-dispose)'),
          subtitle: Text(temp ?? 'Signed out'),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () {
                  ref.read(sessionProvider.notifier).login('Ada');
                  ref.read(tempSessionProvider.notifier).login('Ada');
                },
                child: const Text('Log in'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ref.read(sessionProvider.notifier).logout();
                  ref.read(tempSessionProvider.notifier).logout();
                },
                child: const Text('Log out'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class OtherTab extends StatelessWidget {
  const OtherTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Nothing here watches the session.\nNow go back to Profile.',
        textAlign: TextAlign.center,
      ),
    );
  }
}
