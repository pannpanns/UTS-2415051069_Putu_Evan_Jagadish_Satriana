class Course {
  const Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'planned',
  });

  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;

  factory Course.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final rawCredits = json['credits'];

    return Course(
      id: rawId is int ? rawId : int.tryParse(rawId?.toString() ?? ''),
      code: (json['code'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      credits: rawCredits is num
          ? rawCredits.toInt()
          : int.tryParse(rawCredits?.toString() ?? '') ?? 0,
      status: json['status']?.toString() ?? 'planned',
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'title': title, 'credits': credits, 'status': status};
  }

  Course copyWith({
    int? id,
    String? code,
    String? title,
    int? credits,
    String? status,
  }) {
    return Course(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      credits: credits ?? this.credits,
      status: status ?? this.status,
    );
  }
}
