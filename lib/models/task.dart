class Task {
  const Task({
    this.id,
    required this.title,
    required this.courseId,
    required this.deadline,
    this.priority = priorityMedium,
    this.status = statusNotStarted,
  });

  static const String priorityHigh = 'Tinggi';
  static const String priorityMedium = 'Sedang';
  static const String priorityLow = 'Rendah';

  static const List<String> priorities = [
    priorityHigh,
    priorityMedium,
    priorityLow,
  ];

  static const String statusNotStarted = 'Belum Mulai';
  static const String statusInProgress = 'Dikerjakan';
  static const String statusCompleted = 'Selesai';

  static const List<String> statuses = [
    statusNotStarted,
    statusInProgress,
    statusCompleted,
  ];

  final String? id;
  final String title;
  final String courseId;
  final DateTime deadline;
  final String priority;
  final String status;

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id']?.toString(),
      title: (json['title'] ?? '').toString(),
      courseId: (json['course_id'] ?? '').toString(),
      deadline: DateTime.parse(json['deadline'].toString()),
      priority: (json['priority'] ?? priorityMedium).toString(),
      status: (json['status'] ?? statusNotStarted).toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title.trim(),
      'course_id': courseId,
      'deadline': _formatDate(deadline),
      'priority': priority,
      'status': status,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? courseId,
    DateTime? deadline,
    String? priority,
    String? status,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      courseId: courseId ?? this.courseId,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      status: status ?? this.status,
    );
  }

  static String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }
}
