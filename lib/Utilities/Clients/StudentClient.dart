import 'dart:convert';

import 'package:hansenberg_app/Models/Student.dart';
import 'package:hansenberg_app/Utilities/Clients/HttpClient.dart';
import 'package:intl/intl.dart';

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

  Future<bool> deleteStudent(String token) async {
    final response = await httpClient.delete(
        '/student',
        <String, String> {},
        <String, dynamic> {}
    );

    if (response.statusCode == 200) {
      return true;
    }
    else {
      print('Failed to delete student: ${response.statusCode}, ${response.body}');
      return false;
    }
  }
}
