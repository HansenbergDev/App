import 'dart:convert';

import 'package:tilmeldings_system/Models/Enlistment.dart';
import 'package:tilmeldings_system/Models/StaffEnlistmentWeekData.dart';
import 'package:tilmeldings_system/Utilities/Clients/HttpClient.dart';

class StaffEnlistmentClient {

  const StaffEnlistmentClient({required this.httpClient});

  final HttpClient httpClient;

  Future<StaffEnlistmentWeekData?> getEnlistments(int year, int week, String token) async {
    final response = await httpClient.get(
        '/staff/enlistment',
        <String, String> {
          'year': '$year',
          'week': '$week',
        },
        <String, String> {
          'x-access-token': token
        }
    );

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return StaffEnlistmentWeekData.fromJson(jsonDecode(response.body));
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
}