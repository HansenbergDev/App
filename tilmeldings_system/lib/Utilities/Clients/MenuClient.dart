import 'dart:convert';

import 'package:tilmeldings_system/Models/Menu.dart';
import 'package:tilmeldings_system/Utilities/Clients/HttpClient.dart';

class MenuClient {

  const MenuClient({required this.httpClient});

  final HttpClient httpClient;

  Future<void> createMenu(Menu menu, String token) async {
    final response = await httpClient.post(
        '/menu',
        <String, String> {
          'Content-Type': 'application/json',
          'x-access-token': token
        },
        <String, dynamic> {
          'monday': menu.monday,
          'tuesday': menu.tuesday,
          'wednesday': menu.wednesday,
          'thursday': menu.thursday
        }
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to create menu: ${response.statusCode}, ${response.body}");
    }
  }

  Future<List<Menu>> getMenuAll() async {
    final response = await httpClient.get(
        '/menu/all',
        <String, String> {}
    );

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> json = jsonDecode(response.body);
      List<Menu> result = [];

      for (var element in json) {
        result.add(Menu.fromJson(element));
      }

      return result;
    }
    else {
      throw Exception('Failed to get all menus: ${response.statusCode}, ${response.body}');
    }
  }
}