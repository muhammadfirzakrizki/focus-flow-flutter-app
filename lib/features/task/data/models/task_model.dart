import 'dart:convert';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final bool isDone;
  final int duration;
  final DateTime createdAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.isDone = false,
    this.duration = 30,
  });

  // Fungsi CopyWith: Sangat berguna untuk update status isDone di UI Kit
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isDone,
    int? duration,
    DateTime? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      duration: duration ?? this.duration,
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
    final rawCreatedAt = map['created_at'] ?? map['createdAt'];

    return TaskModel(
      id: '${map['id'] ?? ''}',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isDone: parsedIsDone,
      duration: parsedDuration,
      createdAt: DateTime.tryParse('$rawCreatedAt') ?? DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source));
}
