import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

/// One shared button for the whole app. Change the style here once,
/// and every screen that uses AppButton updates together.
class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(160, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

/// Lesson 31: Design-system mindset (stop inventing one-off widgets).
///
/// The snippet's own Scaffold is the pushed lesson route, so the AppBar
/// shows the back arrow to the lesson list automatically.
class Lesson31DesignSystem extends StatefulWidget {
  const Lesson31DesignSystem({super.key});

  @override
  State<Lesson31DesignSystem> createState() => _Lesson31DesignSystemState();
}

class _Lesson31DesignSystemState extends State<Lesson31DesignSystem> {
  int _presses = 0;

  void _press() => setState(() => _presses++);

  @override
  Widget build(BuildContext context) {
    const heading = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    const gap = SizedBox(height: 8);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Design system'),
        actions: const [LessonInfoButton(lessonId: 31)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Presses: $_presses',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),

          // Each button styled by hand: three different looks.
          const Text('Inconsistent', style: heading),
          gap,
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              onPressed: _press,
              child: const Text('Save'),
            ),
          ),
          gap,
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(onPressed: _press, child: const Text('SUBMIT')),
          ),
          gap,
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(),
                minimumSize: const Size(240, 56),
              ),
              onPressed: _press,
              child: const Text('Continue'),
            ),
          ),
          const SizedBox(height: 32),

          // Every button comes from the shared kit: one look.
          const Text('Consistent', style: heading),
          gap,
          Align(
            alignment: Alignment.centerLeft,
            child: AppButton(label: 'Save', onPressed: _press),
          ),
          gap,
          Align(
            alignment: Alignment.centerLeft,
            child: AppButton(label: 'Submit', onPressed: _press),
          ),
          gap,
          Align(
            alignment: Alignment.centerLeft,
            child: AppButton(label: 'Continue', onPressed: _press),
          ),
        ],
      ),
    );
  }
}
