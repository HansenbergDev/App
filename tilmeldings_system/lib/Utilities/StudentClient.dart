import 'dart:convert';

import 'package:tilmeldings_system/Models/Student.dart';
import 'package:tilmeldings_system/Utilities/HttpClient.dart';

class StudentClient {
  const StudentClient({required this.httpClient});

  final HttpClient httpClient;

  Future<Student> getStudent(String token) async {
    final response = await httpClient.get(
        '/student',
        <String, String> {
          'x-access-token': token
        });

    if (response.statusCode == 200) {
      return Student.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Failed to get student: ${response.statusCode}, ${response.body}');
    }
  }
}
