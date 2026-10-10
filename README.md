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
  21-navigator-push-pop.md
lib/
  main.dart                 MaterialApp and app theme
  lessons/
    lesson.dart             Lesson model (id, title, date, markdown path, builder)
    lessons.dart            Central registry: the ordered list of all lessons
    01_hello_app.dart       Runnable example widget for each lesson
    ...
    21_navigator_push_pop.dart
  screens/
    home_screen.dart        ListView of lessons, Navigator.push to each one
    lesson_screen.dart      AppBar with title, back button and lesson notes
  widgets/
    lesson_notes.dart       Loads a lesson's markdown asset
    simple_markdown.dart    Minimal markdown renderer
test/
  app_test.dart             Opens every lesson and its notes
android/ ios/ web/          Platform runners from `flutter create`
```

## Adding a lesson

A lesson is one markdown file, one Dart file and one registry entry. For
example, a lesson 22 on passing data between screens:

1. **Text:** add `lessons/22-passing-data.md`. Start it with
   `# Lesson 22: Passing data between screens` (the test checks for this heading),
   then a `**Date:**` line, the explanation and the code in a fenced block.
   Everything in `lessons/` is bundled as an asset automatically.
2. **Example:** add `lib/lessons/22_passing_data.dart` with a widget such
   as `class PassingDataLesson extends StatelessWidget`.
3. **Registry:** in `lib/lessons/lessons.dart`, import the file and add:

   ```dart
   Lesson(
     id: 22,
     title: 'Passing data between screens',
     date: DateTime(2026, 10, 11),
     markdownPath: 'lessons/22-passing-data.md',
     builder: (_) => const PassingDataLesson(),
   ),
   ```

That's all: the home screen, the notes sheet and the tests pick it up. Run
`flutter analyze && flutter test` to confirm.

Notes for upcoming navigation lessons:

- An example widget runs inside a normal route, so it can call
  `Navigator.push` / `Navigator.pop` itself and pass data through constructor
  arguments or the value returned by `pop`.
- Named routes, tabs (`DefaultTabController`), drawers or `go_router` can be
  shown self-contained: the example can return its own `Scaffold`, a nested
  `Navigator`, or its own `MaterialApp` / `MaterialApp.router`. That keeps
  the lesson's routing separate from the app's own navigation.
- A lesson that needs a package (such as `go_router`) also needs a
  `flutter pub add` line in its markdown and a dependency in `pubspec.yaml`.

Lesson Dart files are named `NN_topic.dart` so they sort in order; the
`file_names` lint is turned off in `analysis_options.yaml` for that reason.
