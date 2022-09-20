import 'dart:convert';

import 'package:hansenberg_app/Models/Enlistment.dart';
import 'package:hansenberg_app/Utilities/Clients/HttpClient.dart';

class EnlistmentClient {

  const EnlistmentClient({required this.httpClient});

  final HttpClient httpClient;

  Future<bool> updateEnlistment(int year, int week, Enlistment enlistment, String token) async {
    final response = await httpClient.patch(
        endpoint: '/student/enlistment',
        headers: <String, String> {
          'Content-Type': 'application/json',
          'x-access-token': token
        },
        body: <String, dynamic> {
          'year': year,
          'week': week,
          'monday': enlistment.monday,
          'tuesday': enlistment.tuesday,
          'wednesday': enlistment.wednesday,
          'thursday': enlistment.thursday,
          'friday': enlistment.friday,
        }
    );

    return response.statusCode == 200;

    if (response.statusCode == 200) {
      return true;
      throw Exception("Failed to update enlistment: ${response.statusCode}, ${response.body}");
    }
    else {
      return false;
    }
  }

  Future<bool> createEnlistment(int year, int week, Enlistment enlistment, String token) async {
    final response = await httpClient.post(
        endpoint: '/student/enlistment',
        headers: <String, String> {
          'Content-Type': 'application/json',
          'x-access-token': token
        },
        body: <String, dynamic> {
          'year': year,
          'week': week,
          'monday': enlistment.monday,
          'tuesday': enlistment.tuesday,
          'wednesday': enlistment.wednesday,
          'thursday': enlistment.thursday,
          'friday': enlistment.friday,
        }
    );

    return response.statusCode == 201;

    if (response.statusCode != 201) {
      throw Exception("Failed to create enlistment: ${response.statusCode}, ${response.body}");
    }
  }

  Future<Enlistment?> getEnlistment(int year, int week, String token) async {
    final response = await httpClient.get(
        endpoint: '/student/enlistment/single',
        params: <String, String> {
          'year': '$year',
          'week': '$week',
        },
        headers: <String, String> {
          'x-access-token': token
        }
    );

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return Enlistment.fromJson(jsonDecode(response.body));
      }
      else {
        return null;
      }
    }
    else {
      print("Failed to get enlistment: ${response.statusCode}, ${response.body}");
      return null;
    }
  }
  
  

  // Future<List<Enlistment>> getEnlistmentAll(String token) async {
  //   final response = await httpClient.get(
  //       '/student/enlistment',
  //       <String, String> {},
  //       <String, String> {
  //         'x-access-token': token
  //       }
  //   );
  //
  //   if (response.statusCode == 200) {
  //     List<Map<String, dynamic>> json = jsonDecode(response.body);
  //
  //     List<Enlistment> result = [];
  //
  //     for (var element in json) {
  //       result.add(Enlistment.fromJson(element));
  //     }
  //
  //     return result;
  //   }
  //   else {
  //     throw Exception('Failed to get enlistments: ${response.statusCode}, ${response.body}');
  //   }
  // }
}