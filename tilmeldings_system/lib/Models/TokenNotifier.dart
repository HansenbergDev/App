import 'package:flutter/cupertino.dart';

class TokenNotifier with ChangeNotifier {

  String? token;

  void setToken(String t) {
    token = t;
    notifyListeners();
  }
}