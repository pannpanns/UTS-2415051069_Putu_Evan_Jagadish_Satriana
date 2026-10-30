class Course {
  const Course({this.id, required this.name, this.code, this.lecturer});

  final String? id;
  final String name;
  final String? code;
  final String? lecturer;

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id']?.toString(),
      name: (json['name'] ?? '').toString(),
      code: json['code']?.toString(),
      lecturer: json['lecturer']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'code': code, 'lecturer': lecturer};
  }

  Course copyWith({String? id, String? name, String? code, String? lecturer}) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      lecturer: lecturer ?? this.lecturer,
    );
  }
}
