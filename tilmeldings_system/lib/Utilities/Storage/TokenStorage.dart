import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import 'Storage.dart';

class TokenStorage {

  // @override
  // Future<File> localFile() async {
  //   final path = await localPath();
  //
  //   final prefs = await SharedPreferences.getInstance();
  //
  //   return File('$path/token');
  // }

  Future<bool> tokenExists() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;

    // return localFile().then((value) => value.exists());
  }

  Future<String> readToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token')!;

    // final file = await localFile();
    // return await file.readAsString();
  }

  Future<String> readTokenType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userType')!;
  }

  Future<void> writeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);

    // final file = await localFile();
    // return file.writeAsString(token);
  }

  Future<void> writeTokenType(String userType) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userType', userType);
  }
}