import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/course.dart';
import 'course_data_source.dart';

class CourseApiService implements CourseDataSource {
  CourseApiService({http.Client? client, Uri? endpoint})
    : _client = client ?? http.Client(),
      _endpoint = endpoint ?? Uri.parse(apiUrl);

  static const String apiUrl = 'https://course-api-pearl.vercel.app/courses';

  final http.Client _client;
  final Uri _endpoint;

  @override
  Future<List<Course>> getCourses() async {
    try {
      final response = await _client
          .get(_endpoint)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception(
          'Gagal mengambil data mata kuliah '
          '(HTTP ${response.statusCode})',
        );
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! List) {
        throw const FormatException('Format response API bukan array JSON.');
      }

      return decoded.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Format data mata kuliah tidak valid.');
        }

        return Course.fromJson(item);
      }).toList();
    } on TimeoutException {
      throw Exception('Koneksi ke server melewati batas waktu.');
    } on http.ClientException {
      throw Exception(
        'Tidak dapat terhubung ke server. Periksa koneksi internet.',
      );
    }
  }
}
