import 'dart:convert';

class TaskModel {
  final int? id;
  final String title;
  final String description;
  final bool isDone;
  final int duration; // Tambahan: Durasi fokus dalam detik (misal: 30)

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    this.isDone = false,
    this.duration = 30, // Default durasi 30 detik
  });

  // 1. Konversi dari Object ke Map (untuk Database/JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone ? 1 : 0,
      'duration': duration,
    };
  }

  // 2. Konversi dari Map ke Object (saat ambil data)
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isDone: map['isDone'] == 1,
      duration: map['duration'] ?? 25,
    );
  }

  // 3. Helper untuk SharedPreferences (Encode ke String JSON)
  String toJson() => json.encode(toMap());

  // 4. Helper untuk SharedPreferences (Decode dari String JSON)
  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source));
}
