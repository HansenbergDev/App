import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:tilmeldings_system/Models/Student.dart';
import 'package:tilmeldings_system/Utilities/Clients/HttpClient.dart';

class StudentClient {
  const StudentClient({required this.httpClient});

  final HttpClient httpClient;

  Future<String> registerStudent(String name, DateTime enrolledFrom, DateTime enrolledTo) async {
    final response = await httpClient.post(
      '/student/register',
      <String, String> {
        'Content-Type': 'application/json'
      },
      <String, dynamic> {
        'name': name,
        'enrolled_from': DateFormat("yyyy-MM-dd").format(enrolledFrom),
        'enrolled_to': DateFormat("yyyy-MM-dd").format(enrolledTo)
      }
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['token'];
    }
    else {
      throw Exception("Failed to create student: ${response.statusCode}, ${response.body}");
    }
  }

  Future<Student?> getStudent(String token) async {
    final response = await httpClient.get(
        '/student',
        <String, String> {},
        <String, String> {
          'x-access-token': token
        });

    if (response.statusCode == 200) {
      return Student.fromJson(jsonDecode(response.body));
    }
    else {
      print('Failed to get student: ${response.statusCode}, ${response.body}');
      return null;
    }
  }
}
