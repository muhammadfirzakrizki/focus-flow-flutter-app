import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final int duration; // Dalam detik
  final int remainingDurationMs;
  final bool isDone;
  final DateTime createdAt;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.remainingDurationMs,
    this.isDone = false,
    required this.createdAt,
  });

  // Method copyWith sangat penting untuk Use Case (Immutability)
  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    int? duration,
    int? remainingDurationMs,
    bool? isDone,
    DateTime? createdAt,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      remainingDurationMs: remainingDurationMs ?? this.remainingDurationMs,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    duration,
    remainingDurationMs,
    isDone,
    createdAt,
  ];
}
