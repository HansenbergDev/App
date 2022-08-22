import 'dart:convert';

import 'package:tilmeldings_system/Models/Student.dart';
import 'package:tilmeldings_system/Utilities/HttpClient.dart';

class StudentClient {
  const StudentClient({required this.httpClient});

  final HttpClient httpClient;

  Future<String> registerStudent(String name, DateTime enrolledFrom, DateTime enrolledTo) async {
    final response = await httpClient.post(
      '/student/register',
      <String, String> {},
      jsonEncode(<String, String> {
        'name': name,
        'enrolled_from': enrolledFrom.toString(),
        'enrolled_to': enrolledTo.toString()
      })
    );

    if (response.statusCode == 201) {
      final token = "student|${jsonDecode(response.body)['token']}";
      print(token);
      return token;
    }
    else {
      throw Exception("Failed to create student: ${response.statusCode}, ${response.body}");
    }
  }

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
