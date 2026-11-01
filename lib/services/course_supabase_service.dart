import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
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
}
