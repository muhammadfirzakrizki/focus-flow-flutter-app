import 'package:flutter/foundation.dart';
import '../../../../core/database/powersync_config.dart';
import '../models/task_model.dart';

class TaskLocalDataSource {
  /// Mengambil data secara reaktif (Stream).
  /// Setiap kali ada perubahan di database, UI akan otomatis update.
  Stream<List<TaskModel>> watchTasks() async* {
    await PowerSyncConfig.ensureReady();
    yield* db.watch('SELECT * FROM tasks ORDER BY created_at DESC').map((
      results,
    ) {
      return results.map((row) => TaskModel.fromMap(row)).toList();
    });
  }

  /// Mengambil semua task sekali panggil (Future).
  Future<List<TaskModel>> getAllTasks() async {
    await PowerSyncConfig.ensureReady();
    final results = await db.getAll(
      'SELECT * FROM tasks ORDER BY created_at DESC',
    );
    return results.map((row) => TaskModel.fromMap(row)).toList();
  }

  /// Menambah atau mengupdate task (Upsert).
  Future<void> saveTask(TaskModel task) async {
    debugPrint(
      'TaskLocalDataSource.saveTask: ${task.id} - remaining: ${task.remainingDurationMs}',
    );
    await PowerSyncConfig.ensureReady();
    await db.execute(
      '''
      INSERT OR REPLACE INTO tasks (id, title, description, is_done, duration, remaining_duration_ms, created_at)
      VALUES (?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        task.id,
        task.title,
        task.description,
        task.isDone ? 1 : 0,
        task.duration,
        task.remainingDurationMs,
        task.createdAt.toIso8601String(),
      ],
    );
  }

  /// Menghapus task berdasarkan ID.
  Future<void> deleteTask(String id) async {
    await PowerSyncConfig.ensureReady();
    await db.execute('DELETE FROM tasks WHERE id = ?', [id]);
  }

  /// Mengubah status isDone secara cepat.
  Future<void> toggleTaskStatus(String id, bool isDone) async {
    await PowerSyncConfig.ensureReady();
    await db.execute(
      '''
      UPDATE tasks
      SET is_done = ?, remaining_duration_ms = CASE
        WHEN ? = 1 THEN 0
        ELSE duration * 1000
      END
      WHERE id = ?
      ''',
      [isDone ? 1 : 0, isDone ? 1 : 0, id],
    );
  }
}
