# Lesson 39: Layout breakpoints

**Date:** Oct 28, 2026

This is lesson 9 of the design-system series: responsive breakpoints.

The same Flutter app can run on a phone, a tablet, and a wide desktop browser, so a layout built only for a narrow phone ends up stretched and empty on a big screen. The fix is breakpoints: a few named width thresholds that decide which layout to show. A common set is "compact" below 600 pixels, "medium" below 1024, and "expanded" for anything wider. Put them in one small `breakpointFor(width)` function so every screen uses the same numbers instead of inventing its own, just like the design tokens from lesson 33.

To get the width, reach for `LayoutBuilder` first. It tells you how much room the parent actually gave this widget, which matters when your widget sits inside a side panel or a dialog instead of filling the whole screen. `MediaQuery.sizeOf(context).width` gives the full window width, which is handy for app-level decisions. In this demo, a compact width stacks "Nav" on top of "Content" in a column, and wider widths put them side by side in a row, with a wider nav on expanded screens. Since a phone can't be resized, a slider sets a fake width and `FittedBox` shrinks that pretend screen to fit.

## Key points

- Name the breakpoints once: compact below 600, medium below 1024, otherwise expanded (`AppBreakpoint` and `breakpointFor`).
- Prefer `LayoutBuilder` when the width comes from the parent; use `MediaQuery.sizeOf(context).width` for whole-window decisions.
- Compact stacks the panels in a `Column`; medium and expanded use a `Row` with a fixed-width nav (160 or 240).
- Don't hardcode phone-only UIs when the app also targets tablets and desktops.

No new packages today (no `flutter pub add` needed): `LayoutBuilder`, `FittedBox` and `Slider` are all in `package:flutter/material.dart`.

## Code

The tip's snippet, verbatim:

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: BreakpointsDemo()));

enum AppBreakpoint { compact, medium, expanded }

/// One place that turns a width into a named breakpoint.
AppBreakpoint breakpointFor(double width) {
  if (width < 600) return AppBreakpoint.compact;
  if (width < 1024) return AppBreakpoint.medium;
  return AppBreakpoint.expanded;
}

class BreakpointsDemo extends StatefulWidget {
  const BreakpointsDemo({super.key});

  @override
  State<BreakpointsDemo> createState() => _BreakpointsDemoState();
}

class _BreakpointsDemoState extends State<BreakpointsDemo> {
  double _fakeWidth = 800;

  @override
  Widget build(BuildContext context) {
    final breakpoint = breakpointFor(_fakeWidth);
    return Scaffold(
      appBar: AppBar(title: const Text('Breakpoints')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Fake width: ${_fakeWidth.round()} px (${breakpoint.name})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Slider(
            min: 320,
            max: 1400,
            value: _fakeWidth,
            onChanged: (value) => setState(() => _fakeWidth = value),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              // Pretend screen of _fakeWidth pixels, scaled down to fit.
              child: FittedBox(
                child: SizedBox(
                  width: _fakeWidth,
                  height: 500,
                  child: const ResponsiveLayout(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Picks a layout from the width its parent gives it.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = breakpointFor(constraints.maxWidth);
        const nav = _Panel(label: 'Nav', color: Colors.indigo);
        const content = _Panel(label: 'Content', color: Colors.teal);

        if (breakpoint == AppBreakpoint.compact) {
          return const Column(
            children: [
              SizedBox(height: 120, child: nav),
              Expanded(child: content),
            ],
          );
        }

        final navWidth = breakpoint == AppBreakpoint.medium ? 160.0 : 240.0;
        return Row(
          children: [
            SizedBox(width: navWidth, child: nav),
            const Expanded(child: content),
          ],
        );
      },
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      color: color,
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
```

## On screen

The AppBar reads "Breakpoints". Under it, a line says "Fake width: 800 px (medium)", followed by a purple slider about halfway along. Below that is a scaled-down pretend screen: a narrow indigo "Nav" panel on the left and a wide teal "Content" panel filling the rest, side by side. Dragging the slider left below 600 switches the label to "compact" and the pretend screen to a stacked layout, with a short "Nav" bar on top and "Content" underneath. Dragging it right past 1024 switches the label to "expanded" and keeps the side-by-side row, with a wider "Nav" panel.

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `Lesson39Breakpoints`.
- `BreakpointsDemo` is renamed `Lesson39Breakpoints` (its state class follows). `AppBreakpoint`, `breakpointFor`, `ResponsiveLayout` and `_Panel` keep their names, because they are the idea being taught.
- The AppBar keeps `title: const Text('Breakpoints')` with default styling, and gets `actions: const [LessonInfoButton(lessonId: 39)]`, the button that opens these notes.
- The snippet compiles as written and is already `dart format` clean, so the code is otherwise unchanged. One quirk to know: the label rounds the width but `breakpointFor` gets the exact value, so a slider value like 599.6 reads "600 px (compact)".

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 39,
  title: 'Layout breakpoints',
  notesAsset: '39-breakpoints.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: Lesson39Breakpoints());

void main() => runApp(lessonApp);

enum AppBreakpoint { compact, medium, expanded }

/// One place that turns a width into a named breakpoint.
AppBreakpoint breakpointFor(double width) {
  if (width < 600) return AppBreakpoint.compact;
  if (width < 1024) return AppBreakpoint.medium;
  return AppBreakpoint.expanded;
}

/// The page: a slider sets a fake screen width for [ResponsiveLayout].
class Lesson39Breakpoints extends StatefulWidget {
  const Lesson39Breakpoints({super.key});

  @override
  State<Lesson39Breakpoints> createState() => _Lesson39BreakpointsState();
}

class _Lesson39BreakpointsState extends State<Lesson39Breakpoints> {
  double _fakeWidth = 800;

  @override
  Widget build(BuildContext context) {
    final breakpoint = breakpointFor(_fakeWidth);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breakpoints'),
        actions: const [LessonInfoButton(lessonId: 39)],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Fake width: ${_fakeWidth.round()} px (${breakpoint.name})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Slider(
            min: 320,
            max: 1400,
            value: _fakeWidth,
            onChanged: (value) => setState(() => _fakeWidth = value),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              // Pretend screen of _fakeWidth pixels, scaled down to fit.
              child: FittedBox(
                child: SizedBox(
                  width: _fakeWidth,
                  height: 500,
                  child: const ResponsiveLayout(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Picks a layout from the width its parent gives it.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = breakpointFor(constraints.maxWidth);
        const nav = _Panel(label: 'Nav', color: Colors.indigo);
        const content = _Panel(label: 'Content', color: Colors.teal);

        if (breakpoint == AppBreakpoint.compact) {
          return const Column(
            children: [
              SizedBox(height: 120, child: nav),
              Expanded(child: content),
            ],
          );
        }

        final navWidth = breakpoint == AppBreakpoint.medium ? 160.0 : 240.0;
        return Row(
          children: [
            SizedBox(width: navWidth, child: nav),
            const Expanded(child: content),
          ],
        );
      },
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      color: color,
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
```
