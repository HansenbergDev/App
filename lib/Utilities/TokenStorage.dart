import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {

  Future<bool> tokenExists() async {
    return (await SharedPreferences.getInstance()).getString('token') != null;
  }

  Future<String> readToken() async {
    return (await SharedPreferences.getInstance()).getString('token')!;
  }

  Future<void> writeToken(String token) async {
    (await SharedPreferences.getInstance()).setString('token', token);
  }

  Future<void> deleteToken() async {
    (await SharedPreferences.getInstance()).remove('token');
  }
}