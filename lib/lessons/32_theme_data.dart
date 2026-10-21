import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

/// Lesson 32: ThemeData as the single source of visual truth.
///
/// The snippet owns a nested MaterialApp so its theme and themeMode apply to
/// the whole demo. That MaterialApp brings its own Navigator, so the AppBar
/// gets an explicit back arrow to the lesson list, as in lesson 24, and a
/// PopScope routes system back to the nested Navigator first.
class Lesson32ThemeData extends StatefulWidget {
  const Lesson32ThemeData({super.key});

  @override
  State<Lesson32ThemeData> createState() => _Lesson32ThemeDataState();
}

class _Lesson32ThemeDataState extends State<Lesson32ThemeData> {
  bool _dark = false;
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // System and browser back go to the app's navigator, which would pop
    // the whole lesson even while the nested app shows the notes sheet. So
    // this route handles back itself: close the nested app's top route if
    // there is one, otherwise leave the lesson.
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final nested = _navigatorKey.currentState;
        if (nested != null && nested.canPop()) {
          nested.pop();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        // One place decides the look of the whole tree.
        theme: ThemeData(
          colorSchemeSeed: Colors.indigo,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          colorSchemeSeed: Colors.indigo,
          brightness: Brightness.dark,
        ),
        themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
        home: Scaffold(
          appBar: AppBar(
            // The nested MaterialApp has its own Navigator, where this is the
            // first route, so there is no implied back arrow. This one pops the
            // lesson off the app's navigator, back to the lesson list.
            leading: BackButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            ),
            title: const Text('ThemeData'),
            actions: const [LessonInfoButton(lessonId: 32)],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SwitchListTile(
                title: const Text('Dark mode'),
                value: _dark,
                onChanged: (value) => setState(() => _dark = value),
              ),
              const SizedBox(height: 12),
              const Lesson32ThemedCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class Lesson32ThemedCard extends StatelessWidget {
  const Lesson32ThemedCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Read values from the theme instead of hardcoding Colors.blue.
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order summary', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Every color here comes from Theme.of(context).',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Primary color',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () {}, child: const Text('Checkout')),
          ],
        ),
      ),
    );
  }
}
