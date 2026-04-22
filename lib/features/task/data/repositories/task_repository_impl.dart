import 'package:flutter/foundation.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../models/task_model.dart';
import 'package:powersync/powersync.dart'; // Misal pakai PowerSync

class TaskRepositoryImpl implements TaskRepository {
  final PowerSyncDatabase db;

  TaskRepositoryImpl(this.db);

  @override
  Stream<List<TaskEntity>> watchTasks() {
    return db.watch('SELECT * FROM tasks').map((rows) {
      return rows.map<TaskEntity>((row) => TaskModel.fromMap(row)).toList();
    });
  }

  @override
  Future<void> saveTask(TaskEntity task) async {
    debugPrint(
      'TaskRepositoryImpl.saveTask: ${task.id} - remaining: ${task.remainingDurationMs}',
    );
    // Kita konversi Entity ke Model supaya bisa panggil .toMap()
    final model = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      duration: task.duration,
      remainingDurationMs: task.remainingDurationMs,
      isDone: task.isDone,
      createdAt: task.createdAt,
    );

    await db.execute(
      'INSERT OR REPLACE INTO tasks(id, title, description, duration, remaining_duration_ms, is_done, created_at) VALUES(?, ?, ?, ?, ?, ?, ?)',
      [
        model.id,
        model.title,
        model.description,
        model.duration,
        model.remainingDurationMs,
        model.isDone ? 1 : 0,
        model.createdAt.toIso8601String(),
      ],
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    await db.execute('DELETE FROM tasks WHERE id = ?', [id]);
  }
}
