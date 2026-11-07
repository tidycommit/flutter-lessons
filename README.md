# flutter-lessons

Daily Flutter lessons, each with a short explanation and a runnable example.

Every lesson is its own small Flutter project under `lessons/`. Open a lesson
folder and run it, and you get just that lesson's app: the snippet's own
screen and AppBar, plus an info button in the AppBar that opens the lesson
text in a bottom sheet, so you can read the lesson right next to the running
code. The same text sits in the folder as plain markdown, readable on GitHub.

## Run a lesson

You need the Flutter SDK (developed with Flutter 3.47.5 / Dart 3.13).

```sh
cd lessons/24-named-routes
flutter run -d chrome    # run in the browser
flutter run              # or pick a connected device or emulator
```

`flutter run` fetches the packages on first use. The projects are set up for
the web. To run one on a phone or emulator, add the mobile runners once in
that folder with `flutter create --platforms android,ios .` (they are not
committed).

Inside one lesson:

```sh
flutter analyze
flutter test
flutter build web --release
```

## Check every lesson

```sh
scripts/check.sh          # shared package and all lessons
scripts/check.sh 07 34    # only lessons/07-* and lessons/34-*
```

On Windows, use the PowerShell version. It works in Windows PowerShell 5.1
and PowerShell 7 (`pwsh`, also on macOS and Linux):

```powershell
.\scripts\check.ps1          # shared package and all lessons
.\scripts\check.ps1 07 34    # only lessons/07-* and lessons/34-*
```

If the execution policy blocks local scripts, run it like this instead:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/check.ps1
powershell -ExecutionPolicy Bypass -File scripts/check.ps1 07 34
```

Both scripts run `flutter pub get`, `flutter analyze` and `flutter test` in
`packages/lesson_kit` and each lesson project, and print the test count for
each. They exit non-zero if anything fails, including a lesson number that
matches no folder. The repo has no CI, so run one before pushing.

## Folder layout

```
lessons/
  01-hello-app/               One standalone Flutter project per lesson
    01-hello-app.md           Lesson text (bundled as the notes asset)
    pubspec.yaml              Only the packages this lesson needs
    pubspec.lock
    analysis_options.yaml
    lib/main.dart             main(), the lesson info and the example code
    test/lesson_test.dart     Tests for this lesson
    web/                      Web runner from `flutter create`
  ...
  37-shared-dialog/
  38-shared-tabs/
  39-breakpoints/
  40-semantics/
  41-riverpod-counter/
  42-watch-vs-read/
  43-consumer/
  44-async-notifier/
  45-provider-overrides/
  46-keepalive-session/
  47-side-effects/
  48-go-router-basics/
  49-route-params/
packages/
  lesson_kit/                 Shared code, used as a path dependency
    lib/src/lesson_info.dart        LessonInfo: id, title, notes asset
    lib/src/lesson_app.dart         LessonApp (MaterialApp + theme) and LessonScope
    lib/src/lesson_info_button.dart Info action that opens the lesson's notes
    lib/src/lesson_notes.dart       Loads the notes asset into a bottom sheet
    lib/src/simple_markdown.dart    Minimal markdown renderer
scripts/
  check.sh                    analyze + test across every project
```

Lessons 01–40 have no third-party runtime packages. From lesson 41 on, the
Riverpod lessons (41 through 47) add `flutter_riverpod`, each to its own
`pubspec.yaml` only. Lessons 48 and 49 add `go_router` the same way.

## Adding a lesson

Each daily lesson is a new folder. For example, a lesson 50 on a Hero
animation, dated 2026-11-08:

1. **Create the project** from the repo root:

   ```sh
   flutter create --empty --platforms web \
     --project-name lesson_50_hero lessons/50-hero
   cd lessons/50-hero
   rm -rf README.md .idea *.iml
   cp ../49-route-params/analysis_options.yaml .
   ```

2. **pubspec.yaml:** set the description to `"Lesson 50: Hero animation"`,
   then add the shared package and the notes asset:

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     lesson_kit:
       path: ../../packages/lesson_kit

   flutter:
     uses-material-design: true
     assets:
       - 50-hero.md
   ```

   Add any package the lesson needs here (`flutter pub add <name>`), and
   mention that command in the lesson text.

3. **Text:** add `50-hero.md`. Start it with `# Lesson 50: Hero animation`
   (the test checks that this heading matches the lesson info), then a
   `**Date:**` line, the explanation, the original snippet verbatim under
   `## Code`, a `## How it is adapted in this app` note, and the final
   `lib/main.dart` (after the imports) under `## Example`.

4. **lib/main.dart:**

   ```dart
   import 'package:flutter/material.dart';

   import 'package:lesson_kit/lesson_kit.dart';

   /// This lesson, as the info button and the notes heading see it.
   const lesson = LessonInfo(
     id: 50,
     title: 'Hero animation',
     notesAsset: '50-hero.md',
   );

   /// The whole lesson app; `main` runs it and the tests pump it.
   const lessonApp = LessonApp(lesson: lesson, home: Lesson50Hero());

   void main() => runApp(lessonApp);

   class Lesson50Hero extends StatelessWidget {
     const Lesson50Hero({super.key});

     @override
     Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(
           title: const Text('Hero Tip'), // exactly as in the snippet
           actions: const [LessonInfoButton(lessonId: 50)],
         ),
         body: const Placeholder(),
       );
     }
   }
   ```

5. **test/lesson_test.dart:** copy it from a recent lesson and set
   `expectedAppBarTitle` to the snippet's AppBar title. The shared tests check
   the lesson info, the AppBar (title, default colors, info action, no back
   arrow on the first screen), and that the notes open with the right
   heading. Add tests for what the lesson teaches below them.

6. In `web/index.html` and `web/manifest.json`, set the title to
   `Lesson 50`.

7. Run `flutter analyze && flutter test` in the folder (or
   `scripts/check.sh 50`), then `flutter run -d chrome` to try it.

### The AppBar rule

Each lesson uses its snippet's own AppBar, with the info action added.

- The first screen returns the snippet's `Scaffold` with the AppBar exactly
  as written: the same title text and any styling such as `backgroundColor`
  or `foregroundColor`. The only addition is
  `actions: const [LessonInfoButton(lessonId: NN)]`. If the snippet already
  has actions, add the info button to that list. Leave the list non-const
  when another action's callback is not a constant (lesson 44's reload
  button).
- The first screen is the app's home, so it has no back arrow, as in the
  snippet. Screens the lesson pushes itself keep their snippet AppBar and
  its back arrow; they don't need the info action.
- If a snippet has no AppBar, don't invent a title. Ask the teacher for one.
- If the snippet's own `MaterialApp` is the lesson (named routes in lesson
  24, `ThemeData` in lesson 32, `MaterialApp.router` for `go_router` in
  lessons 48 and 49), keep it, and wrap it in
  `LessonScope(lesson: lesson, child: ...)` instead of using `LessonApp`, so
  the info button can still find the notes. The first screen still has the
  info button and no back arrow: the lesson is the whole app, so there is
  no outer lessons list to pop. Screens the router pushes keep their own
  way back (`context.pop()`, or `context.go('/')` when the snippet says so).
- Do not const-call a widget whose constructor asserts on its arguments.
  `NavigationBar` is not a const constructor for that reason. Keep a const
  list literal for the arguments that can be const, such as
  `destinations: const [...]` in lesson 46.
- Lesson-local helpers that illustrate an idea, such as lesson 31's
  `AppButton`, lesson 33's `AppTokens`, lesson 35's `AppTextField` and
  `PhoneNumberFormatter`, lesson 36's `AppAlert`, lesson 37's
  `showAppConfirmDialog`, lesson 38's `AppTabs`, lesson 39's `breakpointFor`,
  lesson 40's `StarRating`, lessons 41–43's `Counter` and `counterProvider`,
  lesson 43's `StaticHeader`, lesson 44's `FakeItems`, lesson 45's
  `TodoRepository`, lesson 46's `Session`, lesson 47's `LoadStatus`, or
  lesson 49's `fruitColors`, live in the lesson's own `main.dart`. Since
  every lesson is its own project, two lessons can use the same name.
