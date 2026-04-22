import 'package:powersync/powersync.dart';

const appSchema = Schema([
  Table('tasks', [
    Column.text('title'),
    Column.text('description'),
    Column.integer('duration'),
    Column.integer('remaining_duration_ms'),
    Column.integer('is_done'),
    Column.text('created_at'),
  ]),
  Table('app_settings', [
    Column.text('value'),
  ]),
]);
