# Lesson 31: Design-system mindset

**Date:** Oct 20, 2026

This is the first lesson of Phase 2, on patterns used in larger apps, and the first in the design-system series.

Welcome to Phase 2! In a small app it's fine to style each button right where you use it. In a big app that turns messy fast: one screen has an orange pill, another has a plain text link, a third has a giant outlined button, and they all mean "do the main thing." A design system fixes that. It's a small shared kit of components (buttons, text fields, dialogs) plus simple rules for when to use each one, like "the primary action is a filled button, secondary actions are text or outlined buttons."

The trick is composition: instead of copy-pasting `ElevatedButton.styleFrom(...)` on every screen, you wrap it once in your own widget, here a tiny `AppButton`, and use that everywhere. Change the style in one place and every screen updates together, and the look, accessibility, and behavior stay consistent. One-off styling is still fine for quick experiments; real product screens should reach for the kit.

## Key points

- Shared components keep look, accessibility, and behavior consistent.
- Compose kit widgets instead of copy-pasting `ElevatedButton.styleFrom`.
- Write the rule down: primary action is a filled button; secondary is text or outlined.

No new packages today (no `flutter pub add` needed).

## Code

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: DesignSystemDemo()));

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

class DesignSystemDemo extends StatefulWidget {
  const DesignSystemDemo({super.key});

  @override
  State<DesignSystemDemo> createState() => _DesignSystemDemoState();
}

class _DesignSystemDemoState extends State<DesignSystemDemo> {
  int _presses = 0;

  void _press() => setState(() => _presses++);

  @override
  Widget build(BuildContext context) {
    const heading = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    const gap = SizedBox(height: 8);

    return Scaffold(
      appBar: AppBar(title: const Text('Design system')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Presses: $_presses',
              style: Theme.of(context).textTheme.titleMedium),
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
```

## On screen

An AppBar titled "Design system" sits above a "Presses: 0" counter. Under the bold heading "Inconsistent" are three hand-styled buttons that look nothing alike: an orange pill "Save" with white text, a plain text-only "SUBMIT", and a wide outlined stadium "Continue". Under "Consistent" are three `AppButton`s, "Save", "Submit" and "Continue", all the same size and shape with slightly rounded corners. Tapping any of the six buttons adds one to the counter.

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `Lesson31DesignSystem`.
- `DesignSystemDemo` is renamed `Lesson31DesignSystem`. `AppButton` keeps its name, because it is the idea being taught; it lives only in this lesson's file.
- The AppBar keeps `title: const Text('Design system')` with default styling, and gets `actions: const [LessonInfoButton(lessonId: 31)]`, the button that opens these notes.
- `dart format` puts the "Presses" `Text` arguments on separate lines; the code is otherwise unchanged.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 31,
  title: 'Design-system mindset',
  notesAsset: '31-design-system-mindset.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: Lesson31DesignSystem());

void main() => runApp(lessonApp);

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
/// The snippet's own Scaffold is the app's home screen, exactly as written.
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
```
