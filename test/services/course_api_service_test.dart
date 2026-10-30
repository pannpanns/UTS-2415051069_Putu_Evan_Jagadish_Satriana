import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:tuntas_kuliah/services/course_api_service.dart';

void main() {
  group('CourseApiService', () {
    test('sends GET request and parses courses', () async {
      final client = MockClient((request) async {
        expect(request.method, 'GET');

        return http.Response(
          jsonEncode([
            {
              'id': 1,
              'code': 'MOB01',
              'title': 'Git & GitHub',
              'credits': 2,
              'status': 'active',
            },
          ]),
          200,
        );
      });

      final service = CourseApiService(client: client);

      final courses = await service.getCourses();

      expect(courses.length, 1);
      expect(courses.first.title, 'Git & GitHub');
      expect(courses.first.id, 1);

      client.close();
    });

    test('throws exception when server returns 404', () async {
      final client = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final service = CourseApiService(client: client);

      expect(() => service.getCourses(), throwsA(isA<Exception>()));

      client.close();
    });
  });
}
