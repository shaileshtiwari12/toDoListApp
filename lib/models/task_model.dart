// models/task_model.dart
class Task {
  int? id;
  String title;
  String category;
  int isDone;

  Task({this.id, required this.title, required this.category, required this.isDone});

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'],
        category: json['category'],
        isDone: json['isDone'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'isDone': isDone,
    };
  }
}
