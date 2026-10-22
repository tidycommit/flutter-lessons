# flutter-lessons

Daily Flutter lessons, each with a short explanation and a runnable example.

This repo is one Flutter app. The home screen lists every lesson (number,
title and date). Tapping a lesson opens its example screen; the info button in
the AppBar opens the lesson text in a bottom sheet, so you can read the lesson
right next to the running code. The same text lives in `lessons/` as plain
markdown, readable on GitHub.

## Run it

You need the Flutter SDK (developed with Flutter 3.47.5 / Dart 3.13).

```sh
flutter pub get
flutter run              # pick a connected device or emulator
flutter run -d chrome    # run in the browser
```

Checks:

```sh
flutter analyze
flutter test
flutter build web --release
```

The app has no third-party runtime packages; the markdown is rendered by a
small built-in renderer (`lib/widgets/simple_markdown.dart`).

## Folder layout

```
lessons/                    Lesson text, one markdown file per lesson
  01-hello-app.md
  ...
  33-design-tokens.md
lib/
  main.dart                 MaterialApp and app theme
  lessons/
    lesson.dart             Lesson model (id, title, date, markdown path, builder)
    lessons.dart            Central registry: the ordered list of all lessons
    01_hello_app.dart       Runnable example widget for each lesson
    ...
    33_design_tokens.dart
  screens/
    home_screen.dart        ListView of lessons, Navigator.push to each one
    lesson_screen.dart      Route for one lesson (uses the lesson's own AppBar)
  widgets/
    lesson_info_button.dart Info action that opens a lesson's notes
    lesson_notes.dart       Loads a lesson's markdown asset
    simple_markdown.dart    Minimal markdown renderer
test/
  app_test.dart             Opens every lesson and its notes
android/ ios/ web/          Platform runners from `flutter create`
```

## Adding a lesson

A lesson is one markdown file, one Dart file and one registry entry, plus a
line in the test table. For example, a lesson 34 on a Hero animation:

1. **Text:** add `lessons/34-hero.md`. Start it with
   `# Lesson 34: Hero animation` (the test checks for this heading),
   then a `**Date:**` line, the explanation and the code in a fenced block.
   Everything in `lessons/` is bundled as an asset automatically.
2. **Example:** add `lib/lessons/34_hero.dart` with a widget such
   as `class HeroLesson extends StatelessWidget`. Follow the AppBar
   rule below.
3. **Registry:** in `lib/lessons/lessons.dart`, import the file and add:

   ```dart
   Lesson(
     id: 34,
     title: 'Hero animation',
     date: DateTime(2026, 10, 23),
     markdownPath: 'lessons/34-hero.md',
     builder: (_) => const HeroLesson(),
   ),
   ```
4. **Test table:** add the lesson's AppBar title to `expectedAppBarTitles`
   in `test/app_test.dart`. The test fails if a lesson is missing from the
   table.

The home screen, the notes sheet and the walkthrough test pick the rest up.
Run `flutter analyze && flutter test` to confirm.

### The AppBar rule

Each lesson's screen uses its snippet's own AppBar, with the info action
added. There is no shared AppBar around the examples.

- The example widget returns the snippet's `Scaffold` with the AppBar exactly
  as written: the same title text and any styling such as `backgroundColor`
  or `foregroundColor`. The only addition is
  `actions: const [LessonInfoButton(lessonId: NN)]`.
- That Scaffold is the pushed route, so the AppBar shows the back arrow to
  the lesson list automatically. Don't set `automaticallyImplyLeading: false`.
- In the markdown, keep the original snippet verbatim under `## Code`, add a
  `## How it is adapted in this app` note (no `main()`/`runApp()`, class
  name, info action, `const` for the analyzer), and end with the in-app code
  under `## Example`.
- If a snippet has no AppBar, don't invent a title. Ask the teacher for one,
  because every lesson needs an entry in the test table.
- Screens the lesson pushes itself, like a details screen, keep the AppBar
  from the snippet. They don't need the info action.

Notes for upcoming navigation lessons:

- An example widget runs inside a normal route, so it can call
  `Navigator.push` / `Navigator.pop` itself and pass data through constructor
  arguments or the value returned by `pop`.
- Named routes, tabs (`DefaultTabController`), drawers or `go_router` can be
  shown self-contained: the example can return its own `Scaffold`, a nested
  `Navigator`, or its own `MaterialApp` / `MaterialApp.router`. That keeps
  the lesson's routing separate from the app's own navigation. Keep the
  AppBar rule: the first screen's AppBar carries the info action and a way
  back to the lesson list.
- A Scaffold with a `drawer:` puts the hamburger icon in the AppBar's
  `leading` slot, where the back arrow would be. Keep the snippet's AppBar
  and add a "Back to lessons" action before the info action (lessons 25 and
  28), and add the lesson id to `lessonsWithoutBackArrow` in the tests.
- `showDialog` and `showModalBottomSheet` push routes on top of the lesson
  screen (lesson 29). They pop on their own, so the lesson screen keeps its
  normal back arrow and needs no "Back to lessons" action.
- A `PopScope` in a screen the lesson pushes (lesson 30) guards only that
  route, as long as the screen is pushed on the same navigator as the lesson.
  The AppBar back arrow and system back ask the top route first, so the
  lesson list is never popped by mistake.
- A snippet with its own `MaterialApp` (lesson 32) can keep it nested in the
  lesson. It brings its own `Navigator`, so the first screen has no implied
  back arrow; give the AppBar `leading: BackButton(...)` that pops with
  `Navigator.of(context, rootNavigator: true)`, as lesson 24 does.
- A lesson that needs a package (such as `go_router`) also needs a
  `flutter pub add` line in its markdown and a dependency in `pubspec.yaml`.

Notes for the Phase 2 lessons (31 onward):

- Lesson-local helpers that illustrate an idea, such as lesson 31's
  `AppButton` or lesson 33's `AppTokens`, live in the lesson's own file. Nothing outside that file uses
  them, so they don't need a lesson prefix.

Lesson Dart files are named `NN_topic.dart` so they sort in order; the
`file_names` lint is turned off in `analysis_options.yaml` for that reason.
