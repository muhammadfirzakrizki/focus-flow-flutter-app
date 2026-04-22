import 'dart:convert';

import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.duration,
    required super.remainingDurationMs,
    super.isDone = false,
    required super.createdAt,
  });

  // Fungsi CopyWith: Sangat berguna untuk update status isDone di UI Kit
  @override
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    int? duration,
    int? remainingDurationMs,
    bool? isDone,
    DateTime? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      remainingDurationMs: remainingDurationMs ?? this.remainingDurationMs,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // To Map: Langsung pakai bool untuk JSON SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_done': isDone ? 1 : 0,
      'duration': duration,
      'remaining_duration_ms': remainingDurationMs,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // From Map: Ambil data dengan proteksi default value
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    final rawIsDone = map['is_done'] ?? map['isDone'] ?? false;
    final bool parsedIsDone = rawIsDone == true || rawIsDone == 1;
    final rawDuration = map['duration'];
    final int parsedDuration = rawDuration is int
        ? rawDuration
        : int.tryParse('$rawDuration') ?? 30;
    final rawRemainingDurationMs =
        map['remaining_duration_ms'] ?? map['remainingDurationMs'];
    final int parsedRemainingDurationMs = rawRemainingDurationMs is int
        ? rawRemainingDurationMs
        : int.tryParse('$rawRemainingDurationMs') ?? (parsedDuration * 1000);
    final rawCreatedAt = map['created_at'] ?? map['createdAt'];

    return TaskModel(
      id: '${map['id'] ?? ''}',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isDone: parsedIsDone,
      duration: parsedDuration,
      remainingDurationMs: parsedRemainingDurationMs,
      createdAt: DateTime.tryParse('$rawCreatedAt') ?? DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source));
}
