import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseWritableDataSource {
  CourseSupabaseService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<List<Course>> getCourses() async {
    final data = await _client.from('courses').select().order('id');

    return data.map((row) => Course.fromJson(row)).toList();
  }

  @override
  Future<Course> createCourse(Course course) async {
    final response = await _client
        .from('courses')
        .insert(course.toJson())
        .select()
        .single();

    return Course.fromJson(response);
  }

  @override
  Future<Course> updateCourse(Course course) async {
    if (course.id == null) {
      throw ArgumentError('ID mata kuliah tidak valid.');
    }

    final response = await _client
        .from('courses')
        .update(course.toJson())
        .eq('id', course.id!)
        .select()
        .single();

    return Course.fromJson(response);
  }
}
