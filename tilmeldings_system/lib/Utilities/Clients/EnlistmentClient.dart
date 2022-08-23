import 'dart:convert';

import 'package:tilmeldings_system/Models/Enlistment.dart';
import 'package:tilmeldings_system/Utilities/Clients/HttpClient.dart';

class EnlistmentClient {

  const EnlistmentClient({required this.httpClient});

  final HttpClient httpClient;

  Future<void> createEnlistment(int year, int week, Enlistment enlistment, String token) async {
    final response = await httpClient.post(
        '/student/enlistments',
        <String, String> {
          'Content-Type': 'application/json',
          'x-access-token': token
        },
        <String, dynamic> {
          'year': year,
          'week': week,
          'monday': enlistment.monday,
          'tuesday': enlistment.tuesday,
          'wednesday': enlistment.wednesday,
          'thursday': enlistment.thursday,
          'friday': enlistment.friday,
        }
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to create enlistment: ${response.statusCode}, ${response.body}");
    }
  }

  Future<List<Enlistment>> getEnlistments(String token) async {
    final response = await httpClient.get(
        '/student/enlistments',
        <String, String> {
          'x-access-token': token
        }
    );

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> json = jsonDecode(response.body);

      List<Enlistment> result = [];

      for (var element in json) {
        result.add(Enlistment.fromJson(element));
      }

      return result;
    }
    else {
      throw Exception('Failed to get enlistments: ${response.statusCode}, ${response.body}');
    }
  }
}