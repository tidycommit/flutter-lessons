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
  23-return-result.md
lib/
  main.dart                 MaterialApp and app theme
  lessons/
    lesson.dart             Lesson model (id, title, date, markdown path, builder)
    lessons.dart            Central registry: the ordered list of all lessons
    01_hello_app.dart       Runnable example widget for each lesson
    ...
    23_return_result.dart
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
line in the test table. For example, a lesson 24 on named routes:

1. **Text:** add `lessons/24-named-routes.md`. Start it with
   `# Lesson 24: Named routes` (the test checks for this heading),
   then a `**Date:**` line, the explanation and the code in a fenced block.
   Everything in `lessons/` is bundled as an asset automatically.
2. **Example:** add `lib/lessons/24_named_routes.dart` with a widget such
   as `class NamedRoutesLesson extends StatelessWidget`. Follow the AppBar
   rule below.
3. **Registry:** in `lib/lessons/lessons.dart`, import the file and add:

   ```dart
   Lesson(
     id: 24,
     title: 'Named routes',
     date: DateTime(2026, 10, 13),
     markdownPath: 'lessons/24-named-routes.md',
     builder: (_) => const NamedRoutesLesson(),
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
- A lesson that needs a package (such as `go_router`) also needs a
  `flutter pub add` line in its markdown and a dependency in `pubspec.yaml`.

Lesson Dart files are named `NN_topic.dart` so they sort in order; the
`file_names` lint is turned off in `analysis_options.yaml` for that reason.
