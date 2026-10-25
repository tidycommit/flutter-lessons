# Lesson 36: Alert for errors, Toast for success

**Date:** Oct 25, 2026

This is lesson 6 of the design-system series: alerts and toasts.

Not all feedback is the same. When something goes wrong that the user has to fix, like a failed save, the message should stay until they deal with it. That is an **alert**: a banner inside the page that stays until the user taps its close icon (or the problem goes away). If you put that error in a SnackBar instead, it slides away after a few seconds and the user may never see it.

Good news is different. "Saved!" just needs a quick nod, so a **toast**-style `SnackBar` with a short duration is the right fit: it pops up at the bottom, disappears on its own, and never blocks the form.

## Key points

- Errors the user must fix go in an inline alert that stays visible until it is dismissed or the problem is fixed.
- Success messages use a short `SnackBar` that dismisses itself and doesn't block the form.
- Don't use a SnackBar for errors the user must fix.
- Give an alert one clear action, such as a close icon (Dismiss) or Retry.
- Call `hideCurrentSnackBar()` before `showSnackBar()` so repeated taps don't queue up toasts.

No new packages today (no `flutter pub add` needed): `SnackBar`, `ScaffoldMessenger` and the banner's `Container` are all in `package:flutter/material.dart`.

## Code

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: FeedbackDemo()));

/// Durable alert: stays visible until the user dismisses it.
class AppAlert extends StatelessWidget {
  const AppAlert({super.key, required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.error),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message,
                style: TextStyle(color: colors.onErrorContainer)),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Dismiss',
            onPressed: onDismiss,
          ),
        ],
      ),
    );
  }
}

class FeedbackDemo extends StatefulWidget {
  const FeedbackDemo({super.key});

  @override
  State<FeedbackDemo> createState() => _FeedbackDemoState();
}

class _FeedbackDemoState extends State<FeedbackDemo> {
  String? _error;

  void _simulateError() {
    setState(() => _error = 'Could not save. Check your connection.');
  }

  void _simulateSuccess() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Saved!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: Column(
        children: [
          if (_error != null)
            AppAlert(
              message: _error!,
              onDismiss: () => setState(() => _error = null),
            ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _simulateError,
            child: const Text('Simulate error'),
          ),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: _simulateSuccess,
            child: const Text('Simulate success'),
          ),
        ],
      ),
    );
  }
}
```

## On screen

The AppBar reads "Feedback". At first the page shows just two buttons, "Simulate error" and "Simulate success". Tapping "Simulate error" drops a red-outlined banner in at the top of the page with an error icon, the text "Could not save. Check your connection.", and a close (X) icon on the right; the banner stays there no matter how long you wait, and only goes away when you tap the X. Tapping "Simulate success" slides a green "Saved!" bar up from the bottom of the screen that fades away by itself after about two seconds, while the buttons (and any open error banner) stay usable the whole time.

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `Lesson36AlertVsToast`.
- `FeedbackDemo` is renamed `Lesson36AlertVsToast`. `AppAlert` keeps its name, because it is the idea being taught.
- The AppBar keeps `title: const Text('Feedback')` with default styling, and gets `actions: const [LessonInfoButton(lessonId: 36)]`, the button that opens these notes.
- `dart format` splits the alert's `Text(message, style: ...)` over several lines and a doc comment is added to the page; the code is otherwise unchanged.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 36,
  title: 'Alert for errors, Toast for success',
  notesAsset: '36-alert-vs-toast.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: Lesson36AlertVsToast());

void main() => runApp(lessonApp);

/// Durable alert: stays visible until the user dismisses it.
class AppAlert extends StatelessWidget {
  const AppAlert({super.key, required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.error),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colors.onErrorContainer),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Dismiss',
            onPressed: onDismiss,
          ),
        ],
      ),
    );
  }
}

/// The page: an error shows as an [AppAlert], a success as a short SnackBar.
class Lesson36AlertVsToast extends StatefulWidget {
  const Lesson36AlertVsToast({super.key});

  @override
  State<Lesson36AlertVsToast> createState() => _Lesson36AlertVsToastState();
}

class _Lesson36AlertVsToastState extends State<Lesson36AlertVsToast> {
  String? _error;

  void _simulateError() {
    setState(() => _error = 'Could not save. Check your connection.');
  }

  void _simulateSuccess() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Saved!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        actions: const [LessonInfoButton(lessonId: 36)],
      ),
      body: Column(
        children: [
          if (_error != null)
            AppAlert(
              message: _error!,
              onDismiss: () => setState(() => _error = null),
            ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _simulateError,
            child: const Text('Simulate error'),
          ),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: _simulateSuccess,
            child: const Text('Simulate success'),
          ),
        ],
      ),
    );
  }
}
```
