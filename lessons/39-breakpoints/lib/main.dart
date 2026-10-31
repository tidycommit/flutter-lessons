import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

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
