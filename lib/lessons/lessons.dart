// The central lesson registry. To add a lesson, drop a markdown file in
// lessons/, an example widget in lib/lessons/, then import it here and add
// one Lesson(...) entry to the list below. See "Adding a lesson" in README.md.

import '01_hello_app.dart';
import '02_stateful_counter.dart';
import '03_scaffold.dart';
import '04_column_row.dart';
import '05_padding_sizedbox.dart';
import '06_expanded.dart';
import '07_safearea.dart';
import '08_center.dart';
import '09_container.dart';
import '10_elevated_button.dart';
import '11_floating_action_button.dart';
import '12_text_field.dart';
import '13_list_view.dart';
import '14_icon.dart';
import '15_card.dart';
import '16_stack.dart';
import '17_text_style.dart';
import '18_switch_list_tile.dart';
import '19_snack_bar.dart';
import '20_circle_avatar.dart';
import '21_navigator_push_pop.dart';
import '22_passing_data.dart';
import '23_return_result.dart';
import '24_named_routes.dart';
import '25_push_replacement.dart';
import '26_bottom_navigation_bar.dart';
import '27_tabbar.dart';
import 'lesson.dart';

/// Every lesson, in the order shown on the home screen.
final List<Lesson> lessons = [
  Lesson(
    id: 1,
    title: 'Hello app',
    date: DateTime(2026, 9, 20),
    markdownPath: 'lessons/01-hello-app.md',
    builder: (_) => const HelloAppLesson(),
  ),
  Lesson(
    id: 2,
    title: 'StatefulWidget counter',
    date: DateTime(2026, 9, 20),
    markdownPath: 'lessons/02-stateful-counter.md',
    builder: (_) => const StatefulCounterLesson(),
  ),
  Lesson(
    id: 3,
    title: 'Scaffold',
    date: DateTime(2026, 9, 21),
    markdownPath: 'lessons/03-scaffold.md',
    builder: (_) => const ScaffoldLesson(),
  ),
  Lesson(
    id: 4,
    title: 'Column and Row alignment',
    date: DateTime(2026, 9, 22),
    markdownPath: 'lessons/04-column-row.md',
    builder: (_) => const ColumnRowLesson(),
  ),
  Lesson(
    id: 5,
    title: 'Padding and SizedBox',
    date: DateTime(2026, 9, 23),
    markdownPath: 'lessons/05-padding-sizedbox.md',
    builder: (_) => const PaddingSizedBoxLesson(),
  ),
  Lesson(
    id: 6,
    title: 'Expanded',
    date: DateTime(2026, 9, 24),
    markdownPath: 'lessons/06-expanded.md',
    builder: (_) => const ExpandedLesson(),
  ),
  Lesson(
    id: 7,
    title: 'SafeArea',
    date: DateTime(2026, 9, 25),
    markdownPath: 'lessons/07-safearea.md',
    builder: (_) => const SafeAreaLesson(),
  ),
  Lesson(
    id: 8,
    title: 'Center',
    date: DateTime(2026, 9, 26),
    markdownPath: 'lessons/08-center.md',
    builder: (_) => const CenterLesson(),
  ),
  Lesson(
    id: 9,
    title: 'Container',
    date: DateTime(2026, 9, 27),
    markdownPath: 'lessons/09-container.md',
    builder: (_) => const ContainerLesson(),
  ),
  Lesson(
    id: 10,
    title: 'ElevatedButton',
    date: DateTime(2026, 9, 28),
    markdownPath: 'lessons/10-elevated-button.md',
    builder: (_) => const ElevatedButtonLesson(),
  ),
  Lesson(
    id: 11,
    title: 'FloatingActionButton',
    date: DateTime(2026, 9, 29),
    markdownPath: 'lessons/11-floating-action-button.md',
    builder: (_) => const FloatingActionButtonLesson(),
  ),
  Lesson(
    id: 12,
    title: 'TextField and InputDecoration',
    date: DateTime(2026, 9, 30),
    markdownPath: 'lessons/12-text-field.md',
    builder: (_) => const TextFieldLesson(),
  ),
  Lesson(
    id: 13,
    title: 'ListView of ListTiles',
    date: DateTime(2026, 10, 1),
    markdownPath: 'lessons/13-list-view.md',
    builder: (_) => const ListViewLesson(),
  ),
  Lesson(
    id: 14,
    title: 'Icon',
    date: DateTime(2026, 10, 3),
    markdownPath: 'lessons/14-icon.md',
    builder: (_) => const IconLesson(),
  ),
  Lesson(
    id: 15,
    title: 'Card with ListTile',
    date: DateTime(2026, 10, 4),
    markdownPath: 'lessons/15-card.md',
    builder: (_) => const CardLesson(),
  ),
  Lesson(
    id: 16,
    title: 'Stack and Positioned',
    date: DateTime(2026, 10, 5),
    markdownPath: 'lessons/16-stack.md',
    builder: (_) => const StackLesson(),
  ),
  Lesson(
    id: 17,
    title: 'TextStyle',
    date: DateTime(2026, 10, 6),
    markdownPath: 'lessons/17-text-style.md',
    builder: (_) => const TextStyleLesson(),
  ),
  Lesson(
    id: 18,
    title: 'SwitchListTile',
    date: DateTime(2026, 10, 7),
    markdownPath: 'lessons/18-switch-list-tile.md',
    builder: (_) => const SwitchListTileLesson(),
  ),
  Lesson(
    id: 19,
    title: 'SnackBar',
    date: DateTime(2026, 10, 8),
    markdownPath: 'lessons/19-snack-bar.md',
    builder: (_) => const SnackBarLesson(),
  ),
  Lesson(
    id: 20,
    title: 'CircleAvatar',
    date: DateTime(2026, 10, 9),
    markdownPath: 'lessons/20-circle-avatar.md',
    builder: (_) => const CircleAvatarLesson(),
  ),
  Lesson(
    id: 21,
    title: 'Moving between screens with Navigator.push and Navigator.pop',
    date: DateTime(2026, 10, 10),
    markdownPath: 'lessons/21-navigator-push-pop.md',
    builder: (_) => const Lesson21Home(),
  ),
  Lesson(
    id: 22,
    title: 'Passing data to a new screen through its constructor',
    date: DateTime(2026, 10, 11),
    markdownPath: 'lessons/22-passing-data.md',
    builder: (_) => const Lesson22FruitList(),
  ),
  Lesson(
    id: 23,
    title: 'Returning a result with Navigator.pop(context, value) and await',
    date: DateTime(2026, 10, 12),
    markdownPath: 'lessons/23-return-result.md',
    builder: (_) => const Lesson23PickColor(),
  ),
  Lesson(
    id: 24,
    title: 'Named routes with routes and Navigator.pushNamed',
    date: DateTime(2026, 10, 13),
    markdownPath: 'lessons/24-named-routes.md',
    builder: (_) => const Lesson24NamedRoutes(),
  ),
  Lesson(
    id: 25,
    title: 'Leaving screens behind with pushReplacement and pushAndRemoveUntil',
    date: DateTime(2026, 10, 14),
    markdownPath: 'lessons/25-push-replacement.md',
    builder: (_) => const Lesson25LoginFlow(),
  ),
  Lesson(
    id: 26,
    title: 'BottomNavigationBar',
    date: DateTime(2026, 10, 15),
    markdownPath: 'lessons/26-bottom-navigation-bar.md',
    builder: (_) => const Lesson26BottomNav(),
  ),
  Lesson(
    id: 27,
    title: 'Tabs with TabBar, TabBarView, and DefaultTabController',
    date: DateTime(2026, 10, 16),
    markdownPath: 'lessons/27-tabbar.md',
    builder: (_) => const Lesson27Tabs(),
  ),
];
